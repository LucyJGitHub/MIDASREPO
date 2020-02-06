     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Maintain Transaction Types')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000324   - Maintain Transaction Types                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009  *CREATE    Date 01Jul00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
     FFT000324DFCF   E             WORKSTN SFILE(FT324S1:SFLRRN)
     FFTTRNTL0  IF   E           K DISK    Rename(FTTRNTD0:TRREAD)
     FFTTRNTL1  UF A E           K DISK    Commit Infds(TrDs) InFsr(TrSr)
 
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
     DP#Type           S                   Like(TRTYPE)
     D  Reload         S              1
     D  ValidOK        S              1
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D TrDS            DS
     D  TrStatus         *Status
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for Access Objects - long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D Record_Locked   C                   Const(01218)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TrLocked        S              1
     D ReturnPt        S              6
 
 
     D Quotes          C                   Const('Blanks ')
 
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
 
     C                   If        TrLocked = 'Y'
     C                   Eval      TrLocked = 'N'
     C                   Eval      Reload   = 'Y'
     C                   Eval      SflSel = *Blanks
     C                   Endif
 
      * Load Subfile
     C                   If        Reload = 'Y'
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Eval      Reload = 'N'
     C                   Endif
 
      * Display subfile data
     C                   Write     MsgCtl
     C                   Write     FT324T1
     C                   Exfmt     FT324C1
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
      *
     C                   Select
      * F9 pressed : Add Record
     C                   When      *InkI  = *On
     C                   Eval      #Act = 'I'
     C                   Eval      *In49 = *Off
     C                   Eval      *In50 = *Off
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
      * set default values
     C                   Eval      WTRTYPE = *Blanks
     C                   Eval      WTrnDsc = *Blanks
     C                   Eval      WRcvInt = 'N'
     C                   Eval      WPayGen = 'N'
 
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
     C                   Write     FT324C1
     C                   Setoff                                         3031
      *
      * Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
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
     C                   Setoff                                           32
     C     *LOVAL        Setll     FTTRNTL0
      *
      * Read Records into Subfile
     C                   Read      FTTRNTL0                               32
     C                   Dow       *In32 = *Off
     C                   Eval      Sflrrn = Sflrrn + 1
     C                   Write     FT324S1
     C                   Read      FTTRNTL0                               32
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
      *
     C                   Eval      *In49 = *Off
     C                   Eval      *In50 = *Off
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT324S1                                33
     C                   Dow       *In33 = *Off
 
     C     SflRrn        Chain     FT324S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT324S1
 
     C                   Setoff                                         1012
     C                   Select
 
      * Change current record
     C                   When      SflSel = 'A'
     C                   Eval      #Act = 'A'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *Off
     C                   Eval      *In51 = *On
 
     C     TRTYPE        Chain     FTTRNTL1                           97
     C                   IF        Not *In97
 
     C                   Eval      WTRTYPE = TRTYPE
     C                   Eval      WTrnDsc = TrnDsc
     C                   Eval      WRcvInt = RcvInt
     C                   Eval      WPayGen = PayGen
 
     C                   Exsr      DtlRcd
     C                   Endif
 
      * Enquire on current record
     C                   When      SflSel = 'E'
     C                   Eval      #Act = 'E'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In51 = *On
     C                   Eval      *In52 = *On
     C     TRTYPE        Chain     FTTRNTL0                           97
     C                   Eval      WTRTYPE = TRTYPE
     C                   Eval      WTrnDsc = TrnDsc
     C                   Eval      WRcvInt = RcvInt
     C                   Eval      WPayGen = PayGen
 
     C                   Exfmt     FT324X1
     C     SflRrn        Chain     FT324S1                            44
     C                   Eval      SflSel = *Blank
     C                   Update    FT324S1
 
      * Delete current record
     C                   When      SflSel = 'D'
 
     C                   If        Coredl = 'Y'
 
     C                   Eval      MsgDta = TRTYPE
     C                   Eval      Msgid = 'FTF3015'
     C                   Exsr      SndMsg
     C     SflRrn        Chain     FT324S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Update    FT324S1
 
     C                   Else
 
     C     TRTYPE        Chain     FTTRNTL1                           97
     C                   IF        Not *In97
 
     C                   Eval      #Act = 'D'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In51 = *On
     C                   Eval      *In52 = *On
     C                   Eval      WTRTYPE = TRTYPE
     C                   Eval      WTrnDsc = TrnDsc
     C                   Eval      WRcvInt = RcvInt
     C                   Eval      WPayGen = PayGen
 
     C                   Exsr      DtlRcd
     C                   Endif
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
     C     SflRrn        Chain     FT324S1                            44
     C                   Update    FT324S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT324S1                                33
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
 
      * Loop until some valid action taken
     C                   Dow       *In03 = *Off And *In12 = *Off
 
     C                   If        SflSel = 'D'
     C                   Eval      *In44 = *On
     C                   Else
     C                   Eval      *In44 = *Off
     C                   Endif
 
     C                   Write     MsgCtl
     C                   Exfmt     FT324X1
 
      * Setof display indicators
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In47 = *Off
     C                   Eval      *In48 = *Off
 
     C                   Eval      ValidOK = 'Y'
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
>>>  C                   If        *In03 = *Off and *Inkl = *Off
 
      * Validate transaction type code
     C                   Select
      * Transaction type code cannot be blanks
     C                   When      WTRTYPE = *Blanks
     C                   Eval      Msgid = 'FTF3000'
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
     C                   Other
      * Transaction type code must be unique if add
     C     WTRTYPE       Chain     FTTRNTL0                           97
     C                   If        Not *In97 AND SflSel = *Blank
     C                   Eval      Msgid = 'FTF3001'
     C                   Eval      MsgDta = WTRTYPE
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsl
 
      * Validate transaction description
     C                   If        WTrnDsc = *Blanks
     C                   Eval      Msgid = 'FTF3002'
     C                   Eval      *in46 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
      * Validate receivers intermediaries charges
     C                   If        WRcvInt <> 'Y' and WRcvInt <> 'N'
     C                   Eval      Msgid = 'FTF3003'
     C                   Eval      MsgDta = WRcvInt
     C                   IF        MsgDta = *Blanks
     C                   Eval      MsgDta = Quotes
     C                   Endif
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
      * Validate payment generation flag
     C                   If        WPayGen <> 'Y' and WPayGen <> 'N'
     C                   Eval      Msgid = 'FTF3003'
     C                   Eval      MsgDta = WPayGen
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
      * If feature CFT014 NOT ACTIVE, do not allow OP to have flag Receivers
      *  / Intermediary charges set.
     C     CFT014        IFNE      'Y'
     C                   IF        WTrType = 'OP'  And
     C                             WRcvInt = 'Y'
     C                   Eval      Msgid = 'FTF3274'
     C                   Eval      MsgDta = WPayGen
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
 
     C                   ENDIF
     C                   ENDIF
 
      * All validated OK.
     C                   If        ValidOK = 'Y'
     C                   CALL      'ZA0250'
 
     C                   Select
 
     C                   When      SflSel = *Blank
     C     WTRTYPE       Chain     FTTRNTL1                           97
     C                   IF        *IN97
     C                   Exsr      MovFil
     C                   Write     FTTRNTD0
     C                   Eval      *In12 = *On
     C                   Eval      Reload = 'Y'
     C                   ENDIF
 
     C                   When      SflSel = 'A'
     C     WTRTYPE       Chain     FTTRNTL1                           97
     C                   Exsr      MovFil
     C                   Update    FTTRNTD0
     C                   Eval      *In12 = *On
 
     C     SflRrn        Chain     FT324S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Exsr      MovFil
     C                   Update    FT324S1
 
 
     C                   When      SflSel = 'D'
     C                   If        *In10
     C     WTRTYPE       Delete    FTTRNTL1                           97
     C                   Eval      Reload = 'Y'
     C                   Eval      SflSel = *Blanks
     C                   Endif
 
     C                   Endsl
 
>>>  C                   Endif
 
     C                   Endif
 
     C                   If        *In12
     C     SflRrn        Chain     FT324S1                            97
     C                   Eval      *In34 = *On
     C                   Eval      SflSel = *Blanks
     C                   Update    FT324S1
     C                   Eval      *In34 = *Off
     C                   Endif
 
     C                   If        *In10
     C                   Leave
     C                   Endif
 
     C     *Loval        Setll     FTTRNTL1
     C                   Unlock    FTTRNTL1
     C                   Commit
 
     C                   Enddo
 
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
     C                   Eval      TRTYPE = WTRTYPE
     C                   Eval      TrnDsc = WTrnDsc
     C                   Eval      RcvInt = WRcvInt
     C                   Eval      PayGen = WPayGen
     C                   Eval      COREDL = 'N'
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * TrSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     TrSr          Begsr
     C                   Eval      TrLocked = 'N'
     C                   If        TrStatus = Record_Locked
     C                   Eval      TrLocked = 'Y'
     C                   Eval      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   Exsr      SndMsg
     C                   Eval      ReturnPt = '*GETIN'
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
     C                   Parm                    P#Type
 
     C                   Eval      #Pgm = PsProcPgm
     C                   Eval      #WrkSt = PsJobName
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
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      Reload = 'Y'
 
      * Check if CFT014 is active.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT014'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT014'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT014            1
     C                   ELSE
     C                   MOVEL     'N'           CFT014
     C                   ENDIF
 
 
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
