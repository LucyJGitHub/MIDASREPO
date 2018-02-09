     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Maintain Payment Date Offset Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000323   - Maintain Payment Date Offset Codes              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG433             Date 02Dec05               *
      *                 239874             Date 15May06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 01Jun00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG433 - Recompiled due to change in FTPDOCPD                *
      *  239874 - Applied fix 217979.                                 *
      *  217979 - Chain the subfile record if it should be updated by *
      *           latest changes.                                     *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
     FFT000323DFCF   E             WORKSTN SFILE(FT323S1:SFLRRN)
     FFTPDOCL1  UF A E           K DISK    Commit Infds(PdDs) InFsr(PdSr)
     FFTPDOCL0  IF   E           K DISK    RENAME(FTPDOCD0:FL0)
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
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
     DP#PYDTOC         S                   Like(PYDTOC)
     D  Reload         S              1
     D  ValidOK        S              1
     D  TimeOK         S              1
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')
 
     DTimeDSSt         DS
     D  TimeFieldSt            1      6  0
     D  TimeHourSt             1      2  0
     D  TimeMinSt              3      4  0
     D  TimeSecSt              5      6  0
 
     DTimeDSCt         DS
     D  TimeFieldCt            1      6  0
     D  TimeHourCt             1      2  0
     D  TimeMinCt              3      4  0
     D  TimeSecCt              5      6  0
 
 
     D TimeDS          DS
     D  Hours                  1      2
     D  Minutes                4      5
     D  Seconds                7      8
 
     D                 DS
     D WBCOSDO
     D  WBCOSDO1               1      1
     D  WBCOSDO2               2      2
     D  WBCOSDO3               3      3
     D  WBCOSDO4               4      4
     D  WBCOSDO5               5      5
     D  WBCOSDO6               6      6
 
     D                 DS
     D WBCOPDO
     D  WBCOPDO1               1      1
     D  WBCOPDO2               2      2
     D  WBCOPDO3               3      3
     D  WBCOPDO4               4      4
     D  WBCOPDO5               5      5
     D  WBCOPDO6               6      6
 
     D                 DS
     D WACOSDO
     D  WACOSDO1               1      1
     D  WACOSDO2               2      2
     D  WACOSDO3               3      3
     D  WACOSDO4               4      4
     D  WACOSDO5               5      5
     D  WACOSDO6               6      6
 
     D                 DS
     D WACOPDO
     D  WACOPDO1               1      1
     D  WACOPDO2               2      2
     D  WACOPDO3               3      3
     D  WACOPDO4               4      4
     D  WACOPDO5               5      5
     D  WACOPDO6               6      6
 
     D ZField          S             16
     D ZADec           S              1  0
     D ZADig           S              2  0
     D ZAlignOK        S              1
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PdDS            DS
     D  PdStatus         *Status
 
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Digits          C                   CONST('0123456789 ')
     D Record_Locked   C                   Const(01218)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Code_Type       S              5
     D Del_IN          S              1
     D Del_OT          S              1
     D Del_CP          S              1
     D Del_CC          S              1
     D Del_RF          S              1
     D Del_CT          S              1
     D Del_PC          S              1
     D Error           S              1
 
     D PdLocked        S              1
     D ReturnPt        S              6
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
 
     C                   Dow       *Inkc = *Off
 
 
     C                   If        PdLocked = 'Y'
     C                   Eval      PdLocked = 'N'
     C                   Eval      Reload   = 'Y'
     C                   Endif
 
     C                   If        Reload = 'Y'
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Endif
 
      * Display subfile data
     C                   Write     MsgCtl
     C                   Write     FT323T1
     C                   Exfmt     FT323C1
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
 
     C                   Select
 
      * When positioner changed, reload subfile
     C                   When      *In60
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
      * F9 pressed : Add Record
     C                   When      *InkI  = *On
     C                   Eval      #Act   = 'I'
     C                   MoveA     '000000000000'*in(44)
     C                   Eval      *In56  = *Off
 
      * Clear Screen Data
     C                   Exsr      Clr_Dta
 
      * Default values
     C                   Eval      WLSTTIM = *Blanks
     C                   Eval      WLCUTOF = *Blanks
 
     C                   Exsr      DtlRcd
 
     C                   Other
 
      * Sfldsp = 30.  ie records exist, then can process
     C                   If        *In30 = *On
     C                   Exsr      Prc@Sf
     C                   Endif
 
     C                   Endsl
 
      * End *INKC
     C                   Enddo
 
     C                   Commit
 
     C                   Eval      *Inlr = *On
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr@Sf - Clear Subfile                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr@Sf        Begsr
      * Clear Subfile
     C                   Seton                                          3031
     C                   Write     FT323C1
     C                   Setoff                                         3031
      *
      * Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
 
      * Reset subfile display indicators
     C                   Eval      *In43 = *Off
     C                   Eval      *In34 = *Off
     C                   Eval      SflSel = *Blanks
 
     C                   Endsr
      *****************************************************************
      *                                                               *
      * Load@sf - Load subfile data                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Load@sf       Begsr
 
     C                   If        PosCde <> *Blanks
     C     PosCde        Setll     FTPDOCL0                           75  77
     C                   Select
     C                   When      *In75
     C                   ReadP     FTPDOCL0                               77
     C     PYDTOC        Setll     FTPDOCL0
     C                   Endsl
     C                   Else
     C     *Loval        Setll     FTPDOCL0
     C                   Endif
 
      * Read Records into Subfile
     C                   Read      FTPDOCL0                               32
     C                   Dow       *In32 = *Off
     C                   Eval      Sflrrn = Sflrrn + 1
     C                   Write     FT323S1
     C                   Read      FTPDOCL0                               32
     C                   Enddo
      *
      * Compare SFLRRN with 0 to see if there is anything to display
     C                   If        Sflrrn > 0
     C                   Eval      *in30 = *On
     C                   Else
     C                   Eval      Msgid = 'GEN0001'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Prc@Sff - Process Subfile                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Prc@Sf        Begsr
 
     C                   Eval      *In44 = *Off
     C                   Eval      *In49 = *Off
     C                   Eval      *In50 = *Off
     C                   Eval      *In55 = *Off
     C                   Eval      *In56 = *Off
 
      * Set switch not to reload subfile
     C                   Eval      ReLoad = 'N'
 
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT323S1                                33
     C                   Dow       *In33 = *Off
 
     C     SflRrn        Chain     FT323S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT323S1
 
     C                   Setoff                                         1012
     C                   Select
 
      * Change current record
     C                   When      SflSel = 'A'
     C                   Eval      #Act = 'A'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *Off
     C                   Eval      *In55 = *On
     C     PYDTOC        Chain     FTPDOCL1                           97
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
 
      * Enquire on current record
     C                   When      SflSel = 'E'
     C                   Eval      #Act = 'E'
     C                   Eval      *In44 = *Off
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In55 = *On
     C                   Eval      *In56 = *On
     C     PYDTOC        Chain     FTPDOCL0                           97
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
 
      * Delete current record
     C                   When      SflSel = 'D'
 
     C                   CallB     'FTC0005'
     C                   Parm                    PYDTOC
     C                   Parm      '*ALL '       Code_Type
     C                   Parm      *Blank        Del_IN
     C                   Parm      *Blank        Del_OT
     C                   Parm      *Blank        Del_CP
     C                   Parm      *Blank        Del_CC
     C                   Parm      *Blank        Del_RF
     C                   Parm      *Blank        Del_CT
     C                   Parm      *Blank        Del_PC
     C                   Parm      *Blank        Error
 
     C                   If        Error   <> 'Y'   And
     C                             Del_IN  <> 'Y'   And
     C                             Del_OT  <> 'Y'   And
     C                             Del_CP  <> 'Y'   And
     C                             Del_CC  <> 'Y'   And
     C                             Del_RF  <> 'Y'   And
     C                             Del_CT  <> 'Y'   And
     C                             Del_PC  <> 'Y'
 
     C                   Eval      #Act = 'D'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In55 = *On
     C                   Eval      *In56 = *On
     C     PYDTOC        Chain     FTPDOCL1                           97
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
     C                   Else
     C     SflRrn        Chain     FT323S1                            44
     C                   Eval      SflSel = *Blank
     C                   Eval      *in43 = *On
     C                   Update    FT323S1
     C                   Eval      Msgid = 'FTF3012'
     C                   Exsr      SndMsg
     C                   Endif
 
      *
      * If subfile select != A or C then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT323S1                            44
     C                   Update    FT323S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT323S1                                33
     C                   Enddo
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * DtlRcd - Add a new record                                     *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     DtlRcd        Begsr
 
     C                   Eval      *In12 = *Off
 
      * Setof display indicators
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In47 = *Off
     C                   Eval      *In48 = *Off
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
     C                   Eval      *In53 = *Off
     C                   Eval      *In54 = *Off
 
      * Loop until some valid action taken
     C                   Dow       *In03 = *Off And *In12 = *Off
 
     C                   If        SflSel = 'D'
     C                   Eval      *In44 = *On
     C                   Endif
 
     C                   Write     MsgCtl
     C                   Exfmt     FT323X1
 
     C                   If        *In03 = *Off and *In12 = *Off
 
      * Clear old messages and validate input
 
     C                   CALL      'ZA0250'
 
     C                   Eval      ValidOK = 'Y'
     C                   Eval      TimeOK = 'Y'
 
     C                   Exsr      FmtTime
 
     C                   Exsr      Validate
 
      * All validated OK.
 
     C                   If        ValidOK = 'Y'
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   Select
 
     C                   When      SflSel = *Blank
     C                   Exsr      MovFil
     C                   Write     FTPDOCD0
     C                   Eval      Reload = 'Y'
     C                   Eval      *In12 = *On
 
     C                   When      SflSel = 'A'
     C     WPYDTOC       Chain     FTPDOCL1                           97
     C                   Exsr      MovFil
     C                   Update    FTPDOCD0
     C     *Loval        Setll     FTPDOCL1
     C                   Unlock    FTPDOCL1
     C                   Commit
 
     C     SflRrn        Chain     FT323S1                            97
     C                   Exsr      MovFil
     C                   Update    FT323S1
     C                   Eval      *In12 = *On
 
     C                   WHEN      SflSel = 'E'
     C     SflRrn        Chain     FT323S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Exsr      MovFil
     C                   Update    FT323S1
 
     C                   When      SflSel = 'D'
 
     C                   If        *In10
     C     WPYDTOC       Delete    FTPDOCL1                           97
     C                   Eval      Reload = 'Y'
     C                   Eval      SflSel = *Blanks
     C                   Endif
 
     C                   Endsl
 
     C                   Endif
 
     C                   If        *In10
     C                   Leave
     C                   Endif
 
     C                   Endif
 
     C**********         If        *In12                                                      217979
     C     *In12         IFEQ      '1'                                                        217979
     C     Reload        ANDEQ     'N'                                                        217979
     C     SflRrn        Chain     FT323S1                            97
     C                   Eval      *In34 = *On
     C                   Eval      SflSel = *Blank
     C                   Update    FT323S1
     C                   Eval      *In34 = *Off
     C     *Loval        Setll     FTPDOCL1
     C                   Unlock    FTPDOCL1
     C                   Endif
 
     C                   Enddo
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate Data Items                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Validate      Begsr
 
     C                   IF        WBCOSDO = '000000'
     C                   Eval      WBCOSDO = *Blanks
     C                   Endif
 
     C                   IF        WACOPDO = '000000'
     C                   Eval      WACOPDO = *Blanks
     C                   Endif
 
     C                   IF        WACOSDO = '000000'
     C                   Eval      WACOSDO = *Blanks
     C                   Endif
 
     C                   IF        WBCOPDO = '000000'
     C                   Eval      WBCOPDO = *Blanks
     C                   Endif
 
 
      * Validate Payment Date code
     C                   Eval      *in45 = *Off
     C                   Select
      * Transaction type code cannot be blanks
     C                   When      WPYDTOC = *Blanks
     C                   Eval      Msgid = 'FTF3005'
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
     C                   Other
 
      * Payment Date Offset code must be unique if add
     C     WPYDTOC       Chain     FTPDOCL0                           97
     C                   If        Not *In97 AND SflSel = *Blank
     C                   Eval      Msgid = 'FTF3006'
     C                   Eval      MsgDta = WPYDTOC
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsl
 
      * Validate transaction description
     C                   Eval      *In46 = *Off
     C                   If        WPYDTOD = *Blanks
     C                   Eval      Msgid = 'FTF3004'
     C                   Eval      *in46 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
      * Validate Local Start Time, if no time error.
     C                   If        TimeOK = 'Y'
     C                   Eval      TimeDS = WLSTTIM
      * Reset error indicator
     C                   Eval      *in48 = *Off
     C                   Movel     Hours         TimeHourST
     C                   Movel     Minutes       TimeMinST
     C                   Movel     Seconds       TimeSecST
     C
     C                   If        WLSTTIM   <> *Blanks
 
     C                   If        TimeHourSt < 0 OR TimeHourSt > 24
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3007'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeMinSt  < 0 OR TimeMinSt  > 59
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3008'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeSecSt  < 0 OR TimeSecSt  > 59
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3009'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeHourSt = 24
     C                   If        TimeMinSt  <> 0 or
     C                             TimeSecSt  <> 0
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3211'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif
 
      ** If there's an error in validation, do not format the data
 
     C                   If        *IN48
     C                   Eval      WLSTTIM = Saved_Start
     C                   EndIf
 
     C                   Endif
      *
     C                   EndIf
 
      * Ensure that if the 'local cut-off time' is entered
      *   '99:99:99' then after cut of settle date is prohibited
 
     C                   If        TimeOK = 'Y'
     C
     C                   If        WLCUTOF = '99:99:99' and WACOSDO <> *Blanks
     C                   Eval      *in53 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3010'
     C                   Exsr      SndMsg
     C                   Endif
 
      * Ensure that if the 'local cut-off time' is entered
      *   '99:99:99' then after cut of payment date is prohibited
     C                   If        WLCUTOF = '99:99:99' and WACOPDO <> *Blanks
     C                   Eval      *in54 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3010'
     C                   Exsr      SndMsg
     C                   Endif
 
      * Ensure that if the 'local cut-off time' is entered correct values
     C                   Eval      TimeDS = WLCUTOF
      * Reset error indicator
     C                   Eval      *in47 = *Off
     C                   Movel     Hours         TimeHourCT
     C                   Movel     Minutes       TimeMinCT
     C                   Movel     Seconds       TimeSecCT
 
     C                   If        WLCUTOF <> '00:00:00' and
     C                             WLCUTOF <> '99:99:99'
 
     C                   If        TimeHourCt < 0 OR TimeHourCt > 24
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3007'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeMinCt  < 0 OR TimeMinCt  > 59
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3008'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeSecCt  < 0 OR TimeSecCt  > 59
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3009'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeHourCt = 24
     C                   If        TimeMinCt  <> 0 or
     C                             TimeSecCt  <> 0
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3211'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif
 
      ** If there's an error in validation, do not format the data
 
     C                   If        *IN47
     C                   Eval      WLCUTOF = Saved_Cut_Off
     C                   EndIf
 
     C                   Endif
      *
     C                   EndIf
 
      * If local start time and local cut-off time entered, ensure that
      *   cut-off time >=start time
 
     C                   If        TimeOK = 'Y'
     C                   If        WLCUTOF <> '99:99:99' and
     C                             WLSTTIM <> '00:00:00'
 
     C                   If        TimeHourSt > TimeHourCt
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3011'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeMinSt > TimeMinCt and
     C                             TimeHourSt >= TimeHourCt
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3011'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   If        TimeSecSt > TimeSecCt    and
     C                             TimeHourSt >= TimeHourCt and
     C                             TimeMinSt >= TimeMinCt
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3011'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endif
      *
     C                   EndIf
 
      * Validate date offsets
     C                   Eval      *In51 = *Off
     C     WBCOSDO1      SCAN      Digits:1      i                 1 0
     C     WBCOSDO2      SCAN      Digits:1      j                 1 0
     C     WBCOSDO3      SCAN      Digits:1      k                 1 0
     C     WBCOSDO4      SCAN      Digits:1      l                 1 0
     C     WBCOSDO5      SCAN      Digits:1      m                 1 0
     C     WBCOSDO6      SCAN      Digits:1      n                 1 0
     C                   If        i=0 or j=0 or k=0 or l=0 or m=0 or n=0
     C                   Eval      *in51 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3270'
     C                   Exsr      SndMsg
     C                   ENDIF
 
     C                   Eval      *In52 = *Off
     C     WBCOPDO1      SCAN      Digits:1      i
     C     WBCOPDO2      SCAN      Digits:1      j
     C     WBCOPDO3      SCAN      Digits:1      k
     C     WBCOPDO4      SCAN      Digits:1      l
     C     WBCOPDO5      SCAN      Digits:1      m
     C     WBCOPDO6      SCAN      Digits:1      n
     C                   If        i=0 or j=0 or k=0 or l=0 or m=0 or n=0
     C                   Eval      *in52 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3270'
     C                   Exsr      SndMsg
     C                   ENDIF
 
     C                   Eval      *In53 = *Off
     C     WACOSDO1      SCAN      Digits:1      i
     C     WACOSDO2      SCAN      Digits:1      j
     C     WACOSDO3      SCAN      Digits:1      k
     C     WACOSDO4      SCAN      Digits:1      l
     C     WACOSDO5      SCAN      Digits:1      m
     C     WACOSDO6      SCAN      Digits:1      n
     C                   If        i=0 or j=0 or k=0 or l=0 or m=0 or n=0
     C                   Eval      *in53 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3270'
     C                   Exsr      SndMsg
     C                   ENDIF
 
     C                   Eval      *In54 = *Off
     C     WACOPDO1      SCAN      Digits:1      i
     C     WACOPDO2      SCAN      Digits:1      j
     C     WACOPDO3      SCAN      Digits:1      k
     C     WACOPDO4      SCAN      Digits:1      l
     C     WACOPDO5      SCAN      Digits:1      m
     C     WACOPDO6      SCAN      Digits:1      n
     C                   If        i=0 or j=0 or k=0 or l=0 or m=0 or n=0
     C                   Eval      *in54 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3270'
     C                   Exsr      SndMsg
     C                   ENDIF
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear Screen Date                                             *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Dta       Begsr
     C                   Eval      WPYDTOC = *Blanks
     C                   Eval      WPYDTOD = *Blanks
     C                   Eval      WLCUTOF = *Blanks
     C                   Eval      WLSTTIM = *Blanks
     C                   Eval      WBCOSDO = *Blanks
     C                   Eval      WBCOPDO = *Blanks
     C                   Eval      WACOSDO = *Blanks
     C                   Eval      WACOPDO = *Blanks
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Move file to screen                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil2       Begsr
     C                   Eval      WPYDTOC = PYDTOC
     C                   Eval      WPYDTOD = PYDTOD
     C                   Eval      WLSTTIM = *Blanks
     C                   Eval      WLCUTOF = *Blanks
 
     C                   Movel     LSTTIM        WLSTTIM
     C                   Movel     LCUTOF        WLCUTOF
 
     C                   Exsr      FmtTime
 
     C                   Move      BCOSDO        ZField
     C                   CallB     'ZEDIT'
     C                   Parm                    ZField
     C                   Parm      *Zero         ZADec
     C                   Move      ZField        WBCOSDO
 
     C                   Move      BCOPDO        ZField
     C                   CallB     'ZEDIT'
     C                   Parm                    ZField
     C                   Parm      *Zero         ZADec
     C                   Move      ZField        WBCOPDO
 
     C                   Move      ACOSDO        ZField
     C                   CallB     'ZEDIT'
     C                   Parm                    ZField
     C                   Parm      *Zero         ZADec
     C                   Move      ZField        WACOSDO
 
     C                   Move      ACOPDO        ZField
     C                   CallB     'ZEDIT'
     C                   Parm                    ZField
     C                   Parm      *Zero         ZADec
     C                   Move      ZField        WACOPDO
 
     C                   If        WBCOSDO = '000000'
     C                   Eval      WBCOSDO = *Blanks
     C                   Endif
 
     C                   If        WBCOPDO = '000000'
     C                   Eval      WBCOPDO = *Blanks
     C                   Endif
 
     C                   If        WACOSDO = '000000'
     C                   Eval      WACOSDO = *Blanks
     C                   Endif
 
     C                   If        WACOPDO = '000000'
     C                   Eval      WACOPDO = *Blanks
     C                   Endif
 
     C                   If        WLSTTIM = '000000'
     C                   Eval      WLSTTIM = *Blanks
     C                   Endif
 
     C                   If        WLCUTOF = '000000'
     C                   Eval      WLCUTOF = *Blanks
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov File Move data to File structure                          *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil        Begsr
     C                   Eval      PYDTOC = WPYDTOC
     C                   Eval      PYDTOD = WPYDTOD
 
     C                   Z-Add     TimeFieldSt   LSTTIM
     C                   Z-Add     TimeFieldCt   LCUTOF
 
     C                   Eval      ZADec = 0
     C                   Eval      ZADig = 6
 
     C                   Eval      ZField = WBCOSDO
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOK
     C                   Parm                    ZField
     C                   Parm                    ZADec
     C                   Parm                    ZADig
     C                   Move      ZField        BCOSDO
 
     C                   Eval      ZField = WBCOPDO
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOK
     C                   Parm                    ZField
     C                   Parm                    ZADec
     C                   Parm                    ZADig
     C                   Move      ZField        BCOPDO
 
     C                   Eval      ZField = WACOSDO
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOK
     C                   Parm                    ZField
     C                   Parm                    ZADec
     C                   Parm                    ZADig
     C                   Move      ZField        ACOSDO
 
     C                   Eval      ZField = WACOPDO
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOK
     C                   Parm                    ZField
     C                   Parm                    ZADec
     C                   Parm                    ZADig
     C                   Move      ZField        ACOPDO
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Format time                                                   *
      *                                                               *
      * Called by: MovFil2                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     FmtTime       Begsr
      * Format data
      ** Save entered data, to prevent format if in error.
 
     C                   MoveL(P)  WLSTTIM       Saved_Start       8
     C                   CallB     'FTTIMECHAR'
     C                   Parm                    RetCodeIn
     C                   Parm                    WLSTTIM
 
     C                   If        RetCodeIn <> *Blanks
     C                   Eval      Msgid = 'FTF3269'
     C                   Exsr      SndMsg
     C                   Eval      ValidOK = 'N'
     C                   Eval      TimeOK = 'N'
     C                   Eval      *In48 = *On
     C                   Eval      WLSTTIM = Saved_Start
     C                   Eval      ValidOK = 'N'
     C                   Endif
 
      ** Save entered data, to prevent format if in error.
 
     C                   MoveL(P)  WLCUTOF       Saved_Cut_Off     8
     C                   CallB     'FTTIMECHAR'
     C                   Parm                    RetCodeIn
     C                   Parm                    WLCUTOF
 
     C                   If        RetCodeIn <> *Blanks
     C                   Eval      Msgid = 'FTF3269'
     C                   Exsr      SndMsg
     C                   Eval      ValidOK = 'N'
     C                   Eval      TimeOK = 'N'
     C                   Eval      *In47 = *On
     C                   Eval      WLCUTOF = Saved_Cut_Off
     C                   Eval      ValidOK = 'N'
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * PdSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PdSr          Begsr
     C                   Eval      PdLocked = 'N'
     C                   If        PdStatus = Record_Locked
     C                   Eval      PdLocked = 'Y'
     C                   Eval      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   Exsr      SndMsg
     C                   Eval      ReturnPt = '*GETIN'
     C     SflRrn        Chain     FT323S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Update    FT323S1
     C                   Endif
     C                   Endsr     ReturnPt
      /EJECT
      *****************************************************************
      *                                                               *
      * SndMsg - Send Program Message                                 *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
      *
      * Only write message if requested
     C                   If        Msgid <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    Msgid
     C                   Parm                    Msgf
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   Endif
      *
      * Reset message Id
     C                   Reset                   Msgds
     C                   Endsr
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
 
     C     *Entry        Plist
     C                   Parm                    P#PYDTOC
 
     C                   Eval      #WrkSt = PsJobName
     C                   Eval      #Pgm   = PsProcPgm
 
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      ReLoad = 'Y'
 
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
(c) Finastra International Limited 2001
