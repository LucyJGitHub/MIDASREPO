     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Maintain Notification Code Words')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000329   - Maintain Payment Date Offset Codes              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Function:  This program allows the input, review and         *
      *             maintenance of Notification Code Words.           *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CFT009  *CREATE    Date 01Jun00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
     FFT000329DFCF   E             WORKSTN SFILE(FT329S1:SFLRRN)
     FFTNCWDL0  IF   E           K DISK    Rename(FTNCWDD0:NCREAD)
     FFTNCWDL1  UF A E           K DISK    Commit Infds(NcDs) InFsr(NcSr)
 
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
     DP#NCODEW         S                   Like(NCODEW)
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
     D NcDS            DS
     D  NcStatus         *Status
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Record_Locked   C                   Const(01218)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D NcLocked        S              1
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
 
     C                   If        NcLocked = 'Y'
     C                   Eval      NcLocked = 'N'
     C                   Eval      Reload   = 'Y'
     C                   Endif
 
     C                   If        Reload = 'Y'
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Endif
 
      * Display subfile data
     C                   Write     MsgCtl
     C                   Write     FT329T1
     C                   Exfmt     FT329C1
 
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
     C                   Eval      *In44  = *Off
     C                   Eval      *In45  = *Off
     C                   Eval      *In46  = *On
     C                   Eval      *In49  = *Off
 
      * Clear Screen Data
     C                   Exsr      Clr_Dta
 
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
     C                   Write     FT329C1
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
 
     C                   If        PosCde <> *Blanks
     C     PosCde        Setll     FTNCWDL0                           75  77
     C                   Select
     C                   When      *In75
     C                   ReadP     FTNCWDL0                               77
     C     NCODEW        Setll     FTNCWDL0
     C                   Endsl
     C                   Else
     C     *Loval        Setll     FTNCWDL0
     C                   Endif
 
      * Read Records into Subfile
     C                   Read      FTNCWDL0                               32
     C                   Dow       *In32 = *Off
     C                   Eval      Sflrrn = Sflrrn + 1
     C                   Write     FT329S1
     C                   Read      FTNCWDL0                               32
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
 
      * Set switch not to reload subfile
     C                   Eval      ReLoad = 'N'
 
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT329S1                                33
     C                   Dow       *In33 = *Off
 
     C     SflRrn        Chain     FT329S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT329S1
 
     C                   Setoff                                         1012
     C                   Select
 
      * Change current record
     C                   When      SflSel = 'A'
     C                   Eval      #Act = 'A'
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *On
     C                   Eval      *In49 = *Off
     C     NCODEW        Chain     FTNCWDL1                           97
     C                   IF        Not *In97
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
     C                   Endif
 
      * Delete current record
     C                   When      SflSel = 'D'
     C                   Eval      #Act = 'D'
     C                   Eval      *In44 = *On
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In49 = *On
     C                   Exsr      MovFil2
     C                   Exsr      DtlRcd
 
      * Enquire current record
     C                   When      SflSel = 'E'
     C                   Eval      #Act = 'E'
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In49 = *On
     C                   Exsr      MovFil2
     C                   Exsr      DtlRcd
      *
      * If subfile select != A or D then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT329S1                            44
     C                   Update    FT329S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT329S1                                33
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
 
     C                   Write     MsgCtl
     C                   Exfmt     FT329X1
 
     C                   Eval      ValidOK = 'Y'
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   IF        *InkL = *Off
 
     C                   IF        SflSel = ' '  or
     C                             SflSel = 'A'
     C                   Exsr      Validate
     C                   Endif
 
      * All validated OK.
     C                   If        ValidOK = 'Y'
     C                   CALL      'ZA0250'
 
     C                   Select
 
     C                   When      SflSel = *Blank
     C                   Exsr      MovFil
     C                   Write     FTNCWDD0
     C                   Eval      Reload = 'Y'
     C                   Eval      *In12 = *On
 
     C                   When      SflSel = 'A'
     C     NCODEW        Chain     FTNCWDL1                           97
     C                   Eval      *In12 = *On
     C                   Eval      Reload = 'Y'
     C                   IF        Not *In97
     C                   Exsr      MovFil
     C                   Update    FTNCWDD0
     C                   Commit
     C                   Endif
 
     C                   When      SflSel = 'D'
     C     NCODEW        Delete    FTNCWDL1                           97
     C                   Eval      Reload = 'Y'
     C                   Eval      *In12 = *On
     C                   Eval      Reload = 'Y'
 
     C                   Endsl
 
     C                   Endif
 
     C                   ENDIF
 
     C                   Enddo
 
     C     SflRrn        Chain     FT329S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Exsr      MovFil
     C                   Update    FT329S1
 
     C     *Loval        Setll     FTNCWDL1
     C                   Unlock    FTNCWDL1
 
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
 
 
      * Validate Notification Code Word
     C                   Select
      * Cannot be blank
     C                   When      WNCODEW = *Blanks
     C                   Eval      Msgid = 'FTF3013'
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
     C                   Other
 
      * Notification Code Word must be unique if add
     C     WNCODEW       Chain     FTNCWDL0                           97
     C                   If        Not *In97
     C                   Eval      Msgid = 'FTF3014'
     C                   Eval      MsgDta = WNCODEW
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsl
 
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
     C                   Eval      WNCODEW = *Blanks
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
     C                   Eval      WNCODEW = NCODEW
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
     C                   Eval      NCODEW = WNCODEW
     C                   Endsr
      *****************************************************************
      *                                                               *
      * NcSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     NcSr          Begsr
     C                   Eval      NcLocked = 'N'
 
     C                   If        NcStatus = Record_Locked
     C                   Eval      NcLocked = 'Y'
     C                   Eval      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   Exsr      SndMsg
     C                   Eval      ReturnPt = '*GETIN'
 
     C     SflRrn        Chain     FT329S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Update    FT329S1
 
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
     C                   Parm                    P#NCODEW
 
     C                   Eval      #WrkSt = PsJobName
     C                   Eval      #Pgm = PsProcPgm
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
(c) Misys International Banking Systems Ltd. 2001
