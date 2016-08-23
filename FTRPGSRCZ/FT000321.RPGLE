     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Maintain Payment Charge Definitions')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000321   - Maintain Payment Charge Definitions             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Function : This program allows the maintenance of payment    *
      *             charge details                                    *
      *                                                               *
      *  Last Amend No. MD025574           Date 19Aug14               *
      *  Prev Amend No. 259785             Date 14Jan13               *
      *                 CFT147             Date 14Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 251529             Date 06Dec07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245708             Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025574 - Description amended not changed on subfile        *
      *  259785 - Fix for CFT147.                                     *
      *           Base Ccy amounts calc'd from max value "other ccy"  *
      *           amounts are exceeding field size.  Add              *
      *           processing so that if calculated base ccy amount    *
      *           exceeds max for field size, restrict it to max      *
      *           value allowed.                                      *
      *           Added hooks: CFT147_046, CFT147_047                 *
      *           Amended hooks: CFT147_002, CFT147_019               *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_001, CFT147_002, CFT147_003,    *
      *           CFT147_004, CFT147_005, CFT147_006, CFT147_007,     *
      *           CFT147_008, CFT147_009, CFT147_010, CFT147_011,     *
      *           CFT147_012, CFT147_013, CFT147_014, CFT147_015,     *
      *           CFT147_016, CFT147_017, CFT147_018, CFT147_019,     *
      *           CFT147_020, CFT147_021                              *
      *  251529 - Add validation to prevent database error when       *
      *           range amount is greater than 9999999999999          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245708 - Subfile text not displayed.                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
     FFT000321DFCF   E             WORKSTN SFILE(SFL321S1:SFRRN1)
     F                                     SFILE(SFL321S2:SFRRN2)
     FFTPCHGL0  IF   E           K DISK    RENAME(FTPCHGD0:CGREAD)
 
     FFTPCHGL1  UF A E           K DISK    Commit Infds(PyDs) InFsr(PYSR)
 
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
      *
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       KC  Exit                                                *
      *       KI  Add record                                          *
      *       KJ  Confirm                                             *
      *       KL  Previous                                            *
      *                                                               *
      *       02  Enquiry mode                                        *
      *       03  <F3> End                                            *
      *       04  Amend mode                                          *
      *       05  <F5> Refresh                                        *
      *       06  Protect all fields in delete mode                   *
      *       07  Allow <F10> confirm                                 *
      *       09  <F9> Add                                            *
      *                                                               *
      *       10  <F10> confirm                                       *
      *       12  <F12> previous                                      *
      *                                                               *
      *       20  SFLDSP for individual code sfl                      *
      *       21  SFLDSPCTL SFLCLR for individual code sfl            *
      *       22  SFLEND for individual code sfl                      *
      *       23  CFT010 is on                                        *
      *       29  Non display of start and end range fields for OB    *
      *           record in individual code sfl                       *
      *                                                               *
      *       30  SFLDSP for code list sfl                            *
      *       31  SFLDSPCTL SFLCLR for code list sfl                  *
      *       32  SFLEND for code list sfl                            *
      *       33  PAGEDOWN for code list sfl                          *
      *       34  SFLNXTCHG for code list sfl                         *
      *       35  Sfl selection error for code list sfl               *
      *       36  Position code field changed for code list sfl       *
      *                                                               *
      *       51  Validation of payment charge code                   *
      *       52  Validation of charge description                    *
      *       53  Validation of VAT liable indicator                  *
      *       54  Validation of calculation method (manual)           *
      *       55  Validation of calculation method (STP)              *
      *       56  Validation of manual base range start               *
      *       57  Validation of manual base range end                 *
      *       58  Validation of manual base range rate                *
      *       59  Validation of manual base range pro mile            *
      *                                                               *
      *       60  Validation of manual base minimum charge            *
      *       61  Validation of manual base maximum charge            *
      *       62  Validation of manual other currency                 *
      *       63  Validation of manual other range start              *
      *       64  Validation of manual other range end                *
      *       65  Validation of manual other range pro mile           *
      *       66  Validation of manual other minimum charge           *
      *       67  Validation of manual other maximum charge           *
      *       68  Validation of STP base range start                  *
      *       69  Validation of STP base range end                    *
      *                                                               *
      *       70  Validation of STP base range rate                   *
      *       71  Validation of STP base range pro mile               *
      *       72  Validation of STP base minimum charge               *
      *       73  Validation of STP base maximum charge               *
      *       74  Validation of STP other currency                    *
      *       75  Validation of STP other range start                 *
      *       76  Validation of STP other range end                   *
      *       77  Validation of STP other range pro mile              *
      *       78  Validation of STP other minimum charge              *
      *       79  Validation of STP other maximum charge              *
      *                                                               *
      *       80  Allow input of Manual Other Currency (Range 1 only) *
      *       81  Scan for ? in  Manual Other Currency (Range 1 only) *
      *       82  Scan for ? in  Manual Other Currency (Range 1 only) *
      *           (used for setting STP other currency)               *
      *       93  Setll                                               *
      *       94  Setll                                               *
      *       96  Chain                                               *
      *       97  Chain                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D  #Reload        S              1
     D  #Valid         S              1
     D  #Act           S              1
     D  #Add           S              1
     D  #Amend         S              1
     D  #Delete        S              1
     D  #Enquire       S              1
     D  #End           S              1
     D  #Addok         S              1
     D  #Adderr        S              1
     D  #Amendok       S              1
     D  #Amenderr      S              1
     D  #Err1          S              1
     D  #Sf2pos        S              1
     D  #Pmbase        S              1
     D  #Rtbase        S              1
     D  #Pmstp         S              1
     D  #Rtstp         S              1
     D  #Manother      S              1
     D  #Stpother      S              1
     D  #C1            S              2  0
     D  #C2            S              2  0
     D  #C3            S              2  0
     D  #Rrn1          S                   LIKE(Sfrrn1)
     D  #Key1          S                   LIKE(PYCHCD)
     D  #Diff1         S                   LIKE(SABC01)
     D  #Diff2         S                   LIKE(STOC01)
     D  #RTCD          S              7
     D  #OPTN          S              7
     D  #CCYA          S                   LIKE(BJCYCD)
     D  #DEC           S              2  0
     D  #INT           S              2  0
     D  #Basccy        S                   LIKE(BJCYCD)
     D  #Basmd         S                   LIKE(A6MDIN)
     D  #Basdec        S              2  0
     D  #Basint        S              2  0
     D  #Othmd         S                   LIKE(A6MDIN)
     D  #Othdec        S              2  0
     D  #Othint        S              2  0
     D  #F3Curr        S              1
     D  #CcyPrompt     S              1
     D  X              S              3  0
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D BasManOB        S              1
     D OthManOB        S              1
     D STPBasOb        S              1
     D STPOthOb        S              1
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('GBFTUSRMSG')
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D PyDS            DS
     D  PyStatus         *Status
 
      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D/COPY OFCPYSRCZ,CFT147_001                                                              CFT147
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Record_Locked   C                   Const(01218)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PyLocked        S              1
     D ReturnPt        S              6
     D/COPY OFCPYSRCZ,CFT147_002                                                              CFT147
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   DOW       *Inkc = *Off and #End <> 'Y'
 
     C                   IF        PyLocked = 'Y'
     C                   EVAL      PyLocked = 'N'
     C                   EVAL      #Reload = 'Y'
     C                   EVAL      SFLSL1 = ' '
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t1
     C                   EXFMT     Ctl321c1
 
     C                   ELSE
 
     C                   IF        #Reload = 'Y'
     C                   EXSR      CLRSF1
     C                   EXSR      LOADSF1
     C                   ENDIF
      * Display subfile data if data to display
      * Else display no data screen
 
     C                   IF        *In30 = *On
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t1
     C                   EXFMT     Ctl321c1
     C                   ELSE
     C                   EXFMT     Fmt321
     C                   ENDIF
 
      * Clear old messages
 
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
      * When positioner changed, reload subfile
     C                   WHEN      *In36
     C                   EXSR      CLRSF1
     C                   EXSR      LOADSF1
 
      * F9 pressed : Add Record
     C                   WHEN      *InkI  = *On
     C                   EVAL      #Act   = 'I'
 
     C                   EXSR      ADDREC
 
      * Pagedown pressed : Load some more records
     C                   WHEN      *In33  = *On
     C                   EVAL      #Act   = 'R'
 
     C                   EXSR      LOADSF1
 
     C                   OTHER
 
      * Sfldsp = 30.  ie records exist, then can process
     C                   IF        *In30 = *On
     C                   EXSR      PRCSF1
     C                   ENDIF
 
     C                   ENDSL
      * End Record Locked
     C                   COMMIT
     C                   ENDIF
 
      * End *INKC
     C                   ENDDO
 
     C                   EVAL      *Inlr = *On
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * CLRSF1 - Clear Subfile 1 - Charge definition list             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     CLRSF1        BEGSR
      *    ******
 
      * Clear Subfile
 
     C                   SETON                                          3031
     C                   WRITE     CTL321C1
     C                   SETOFF                                         3031
 
      * Reset SFLRRN
 
     C                   EVAL      Sfrrn1 = *Zero
     C                   EVAL      #Rrn1 = *Zero
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * LOADSF1 - Load subfile data - page at a time.                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     LOADSF1       BEGSR
      *    *******
 
     C                   IF        PosCde <> *Blanks and *In33 = *Off
     C     PosCde        SETLL     FTPCHGL0                           93  94
     C                   SELECT
     C                   WHEN      *In93
     C                   READP     FTPCHGL0                               94
     C     PYCHCD        SETLL     FTPCHGL0
     C                   ENDSL
     C                   ELSE
 
     C                   IF        *In33 = *Off
     C     *Loval        SETLL     FTPCHGL0
     C                   ELSE
     C     #key1         SETGT     FTPCHGL0
     C                   ENDIF
 
     C                   ENDIF
 
      * Read Records into Subfile page at a time
 
     C                   READ      FTPCHGL0                               32
 
     C                   EVAL      #C1 = 0
     C                   EVAL      Sfrrn1 = #Rrn1
 
     C                   DOW       *In32 = *Off
     C                   EVAL      Sfrrn1 = Sfrrn1 + 1
     C                   WRITE     Sfl321s1
     C                   EVAL      #C1 = #C1 + 1
 
     C                   IF        #C1 = 10
     C                   EVAL      #ReLoad = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   READ      FTPCHGL0                               32
     C                   ENDDO
 
      * Compare SFLRRN with 0 to see if there is anything to display
 
     C                   IF        Sfrrn1 > 0
     C                   EVAL      *in30 = *On
     C                   ENDIF
 
     C                   EVAL      #Rrn1 = Sfrrn1
     C                   EVAL      #key1 = PYCHCD
     C                   EVAL      Sfpos1 = Sfrrn1
 
     C     #key1         SETLL     FTPCHGL0
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * PRCSF1  - Process Subfile selections                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AMDREC DELREC ENQREC SNDMSG                            *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     PRCSF1        BEGSR
      *    ******
 
      * Set switch not to reload subfile
 
     C                   EVAL      #Reload = 'N'
     C                   EVAL      #Err1 = *blanks
 
      * Read subfile for any subfile select records
 
     C                   EVAL      *In34 = *Off
     C                   READC     Sfl321s1                               34
 
     C                   DOW       *In34 = *Off and #End <> 'Y'
     C                             and #Err1 <> 'Y'
 
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      *In35 = *Off
     C                   UPDATE    Sfl321s1
 
     C                   EVAL      *In02 = *Off
     C                   EVAL      *In04 = *Off
     C                   EVAL      *In06 = *Off
     C                   EVAL      *In09 = *Off
 
     C                   SELECT
 
      * Amend current record
 
     C                   WHEN      Sflsl1 = 'A'
     C/COPY OFCPYSRCZ,CFT147_003                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL1                           97
     C/COPY OFCPYSRCZ,CFT147_004                                                              CFT147
     C                   IF        NOT *IN97
     C                   EVAL      #Act = 'A'
     C                   EXSR      AMDREC
                                                                                            MD025574
      ** If description has change ensure it is sjown on subfile after                      MD025574
                                                                                            MD025574
     C     Sfrrn1        CHAIN     Sfl321s1                           96                    MD025574
     C                   EVAL      *IN35 = *OFF                                             MD025574
     C                   EVAL      CHDESC = SCHDSC                                          MD025574
     C                   UPDATE    Sfl321s1                                                 MD025574
     C                   ENDIF
 
      * Delete current record
 
     C                   WHEN      Sflsl1 = 'D'
     C                   EVAL      #Act = 'D'
     C/COPY OFCPYSRCZ,CFT147_005                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL1                           97
     C/COPY OFCPYSRCZ,CFT147_006                                                              CFT147
     C                   EXSR      DELREC
 
      * Enquire current record
 
     C                   WHEN      Sflsl1 = 'E'
     C                   EVAL      #Act = 'E'
     C     PYCHCD        CHAIN     FTPCHGL0                           97
     C                   EXSR      ENQREC
 
 
      * If subfile select <> A D or E then error message
 
     C                   OTHER
     C     Sflsl1        IFNE      *BLANK
     C                   EVAL      *In35 = *On
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1001'
     C                   EVAL      #Err1 = 'Y'
     C                   EVAL      Sfpos1 = Sfrrn1
     C                   EXSR      SNDMSG
     C                   EVAL      *in35 = *On
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   UPDATE    Sfl321s1
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDSL
 
     C                   READC     Sfl321s1                               34
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * ADDREC - Add a new record to FTPCHGPD                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: CLRSF2 LOADSF2 VALIDATE                                *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     ADDREC        BEGSR
      *    ******
 
     C                   EVAL      #Add = 'Y'
     C                   CLEAR                   FTPCHGD0
 
      * Display subfile records ready for input
 
     C                   DOW       #Add = 'Y'
 
     C                   IF        #Adderr <> 'Y'
     C                   IF        #Ccyprompt <> 'Y'
     C                   EXSR      CLRSF2
     C                   EXSR      LOADSF2
 
     C                   EVAL      #Adderr = *blanks
 
     C                   EVAL      *In20 = *On
     C                   EVAL      *In22 = *On
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t2
 
     C     11            CHAIN     Sfl321s2                           96
     C                   EVAL      *In29 = *On
     C                   UPDATE    Sfl321s2
     C                   EVAL      *In29 = *Off
 
     C                   EXFMT     Ctl321c2
     C                   ELSE
     C                   EVAL      #Ccyprompt = ' '
     C                   EXFMT     Ctl321c2
     C                   ENDIF
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      *In03 = *On
     C                   EVAL      #Add = *blanks
     C                   EVAL      #End = 'Y'
 
     C                   WHEN      *In05 = *On
      * Reset add error flag
     C                   EVAL      #Adderr = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   WHEN      *In12 = *On
     C                   EVAL      #Add = *blanks
     C                   EVAL      #Adderr = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
 
     C                   OTHER
 
 
     C                   EXSR      VALIDATE
      * Validate again to check defaulted values from 'other' to 'base'.
      * If *IN81 and #RTCD = *NRF then <F3> was pressed last time
      * currency prompt was called so set flag to clear field to
      * stop call again on second validation.
     C                   IF        #RTCD = '*NRF   ' and *IN81
     C                   EVAL      #F3Curr = 'Y'
     C                   ENDIF
 
     C                   EXSR      VALIDATE
 
     C/COPY OFCPYSRCZ,CFT147_007                                                              CFT147
     C                   IF        #Addok = 'Y'
     C                   EVAL      *In07 = *On
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t4
 
     C     11            CHAIN     Sfl321s2                           96
     C                   EVAL      *In29 = *On
     C                   UPDATE    Sfl321s2
     C                   EVAL      *In29 = *Off
 
 
     C                   IF        #Addok = 'Y'
     C                   IF        #Ccyprompt <> 'Y'
     C                   WRITE     FTPCHGD0
     C                   EVAL      #Reload = 'Y'
     C                   EVAL      #Add = ' '
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      *In07 = *Off
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t2
 
     C     11            CHAIN     Sfl321s2                           96
     C                   EVAL      *In29 = *On
     C                   UPDATE    Sfl321s2
     C                   EVAL      *In29 = *Off
 
     C                   EXFMT     Ctl321c2
 
     C                   ENDIF
 
     C                   IF        *InkC
     C                   EVAL      #Add = *blanks
     C                   LEAVE
     C                   EVAL      #End = 'Y'
     C                   ENDIF
 
     C                   IF        *InkL
     C                   EVAL      *In06 = *Off
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
      * Clear old messages
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * AMDREC - Amend a record in FTPCHGPD                           *
      *                                                               *
      * Called by: PRCSF1                                             *
      *                                                               *
      * Calls: CLRSF2 LOADSF2 VALIDATE                                *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     AMDREC        BEGSR
      *    ******
 
     C                   EVAL      *In04 = *On
     C                   EVAL      #Amend = 'Y'
     C/COPY OFCPYSRCZ,CFT147_008                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL1                           97
     C/COPY OFCPYSRCZ,CFT147_009                                                              CFT147
 
      * Display subfile records ready for amend
 
     C                   DOW       #Amend = 'Y'
 
     C                   IF        #Amenderr <> 'Y' or *In05 = *On
     C                   EXSR      CLRSF2
     C                   EXSR      LOADSF2
 
     C                   EVAL      *In20 = *On
     C                   EVAL      *In22 = *On
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t2
 
     C     11            CHAIN     Sfl321s2                           96
     C                   EVAL      *In29 = *On
     C                   UPDATE    Sfl321s2
     C                   EVAL      *In29 = *Off
 
     C                   EXFMT     Ctl321c2
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      *In03 = *On
     C                   EVAL      #Amend = *blanks
     C                   EVAL      #End = 'Y'
 
     C                   WHEN      *In05 = *On
     C                   EVAL      #Amenderr = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
     C/COPY OFCPYSRCZ,CFT147_010                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL1                           97
     C/COPY OFCPYSRCZ,CFT147_011                                                              CFT147
 
     C                   WHEN      *In12 = *On
     C                   EVAL      #Amend = *blanks
     C                   EVAL      #Amenderr = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
 
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      Sflsl1= *blanks
     C                   EVAL      *In35 = *Off
     C                   UPDATE    Sfl321s1
 
     C                   OTHER
 
 
     C                   EXSR      VALIDATE
      * Validate again to check defaulted values from 'other' to 'base'.
      * If *IN81 and #RTCD = *NRF then <F3> was pressed last time
      * currency prompt was called so set flag to clear field to
      * stop call again on second validation.
     C                   IF        #RTCD = '*NRF   ' and *IN81
     C                   EVAL      #F3Curr = 'Y'
     C                   ENDIF
      * Clear old messages
 
     C                   EXSR      VALIDATE
     C/COPY OFCPYSRCZ,CFT147_012                                                              CFT147
 
     C                   IF        #Amendok = 'Y'
     C                   IF        #Ccyprompt <> 'Y'
 
     C                   UPDATE    FTPCHGD0
     C     *Loval        SETLL     FTPCHGL1
     C                   UNLOCK    FTPCHGL1
     C                   EVAL      #Amend = 'N'
     C                   ELSE
     C                   EVAL      #Ccyprompt = ' '
     C                   ENDIF
 
     C                   ELSE
 
     C/COPY OFCPYSRCZ,CFT147_013                                                              CFT147
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t2
 
     C     11            CHAIN     Sfl321s2                           96
     C                   EVAL      *In29 = *On
     C                   UPDATE    Sfl321s2
     C                   EVAL      *In29 = *Off
 
     C                   EXFMT     Ctl321c2
     C                   ENDIF
 
     C                   IF        *InkC
     C                   EVAL      #Amend = *blanks
     C                   LEAVE
     C                   EVAL      #End = 'Y'
     C                   ENDIF
 
     C                   IF        *Inke
     C                   EVAL      #Amenderr = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
     C/COPY OFCPYSRCZ,CFT147_014                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL1                           97
     C/COPY OFCPYSRCZ,CFT147_015                                                              CFT147
      * Clear old messages
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   IF        *InkL
     C                   EVAL      *In06 = *Off
     C                   EVAL      #Amenderr = *blanks
     C                   EVAL      #Amend = *blanks
     C                   MOVEA     '0000000000'  *IN(50)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
      * Clear old messages
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      Sfpos1 = Sfrrn1
     C                   EVAL      *In04 = *Off
 
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      Sflsl1 = *Blank
     C                   UPDATE    Sfl321s1
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * DELREC - Delete current record                                *
      *                                                               *
      * Called by: PRCSF1                                             *
      *                                                               *
      * Calls: CLRSF2 LOADSF2 *PSSR SNDMSG                            *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     DELREC        BEGSR
      *    ******
 
     C                   EVAL      *In06 = *On
     C                   EVAL      *In07 = *On
     C                   EVAL      #Delete = 'Y'
 
      * Display subfile records ready for delete
 
     C                   DOW       #Delete = 'Y'
 
     C                   EXSR      CLRSF2
     C                   EXSR      LOADSF2
 
     C                   EVAL      *In20 = *On
     C                   EVAL      *In22 = *On
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t4
     C                   EXFMT     Ctl321c2
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
     C                   WHEN      *In03 = *On
     C                   EVAL      #Delete = *blanks
     C                   EVAL      #End = 'Y'
 
     C                   WHEN      *In12 = *On
     C                   EVAL      #Delete = *blanks
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      Sflsl1= *blanks
     C                   EVAL      *In35 = *Off
     C                   UPDATE    Sfl321s1
 
     C                   WHEN      *In10
     C                   CALLB     'FTC0005'     P#0005
     C                   IF        Error =  'Y'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = Code_Type
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        Del_IN  <> 'Y'   And
     C                             Del_OT  <> 'Y'   And
     C                             Del_CP  <> 'Y'   And
     C                             Del_CC  <> 'Y'   And
     C                             Del_RF  <> 'Y'   And
     C                             Del_CT  <> 'Y'   And
     C                             Del_PC  <> 'Y'
     C/COPY OFCPYSRCZ,CFT147_016                                                              CFT147
     C     PYCHCD        CHAIN     FTPCHGL0                           97
     C/COPY OFCPYSRCZ,CFT147_017                                                              CFT147
     C                   IF        *In97 = *Off
     C                   DELETE    FTPCHGL1
     C                   EVAL      #Delete = *blanks
     C                   EVAL      Sflsl1= *blanks
     C                   EVAL      #Reload = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      Msgid = 'FTF3012'
     C                   EXSR      SNDMSG
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      Sfpos1 = Sfrrn1
     C                   EVAL      *In06 = *Off
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * ENQREC - Display current record details                       *
      *                                                               *
      * Called by: PRCSF1                                             *
      *                                                               *
      * Calls: CLRSF2 LOADSF2                                         *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     ENQREC        BEGSR
      *    ******
 
     C                   EVAL      *In02 = *On
     C                   EVAL      #Enquire = 'Y'
 
      * Display subfile records
 
     C                   DOW       #Enquire = 'Y'
 
     C                   EXSR      CLRSF2
     C                   EXSR      LOADSF2
 
     C                   EVAL      *In20 = *On
     C                   EVAL      *In22 = *On
 
     C                   WRITE     Msgctl
     C                   WRITE     Trl321t3
     C                   EXFMT     Ctl321c2
 
     C                   SELECT
 
     C                   WHEN      *In03 = *On
     C                   EVAL      #Enquire = *blanks
     C                   EVAL      #End = 'Y'
 
     C                   WHEN      *In05 = *On
 
     C                   WHEN      *In12 = *On
     C                   EVAL      #Enquire = *blanks
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      Sflsl1 = *blanks
     C                   EVAL      *In35 = *Off
     C                   UPDATE    Sfl321s1
 
     C                   OTHER
     C                   EVAL      #Enquire = *blanks
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      Sflsl1 = *blanks
     C                   EVAL      *In35 = *Off
     C                   UPDATE    Sfl321s1
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      Sfpos1 = Sfrrn1
     C                   EVAL      *In02 = *Off
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * CLRSF2 - Clear Subfile 2 - Charge definition detail           *
      *                                                               *
      * Called by: ADDREC AMDREC DELREC ENQREC                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     CLRSF2        BEGSR
      *    ******
 
      * Clear Subfile
 
     C                   EVAL      SPYCCD = *blanks
     C                   EVAL      SCHDSC = *blanks
     C                   EVAL      SCVTLB = *blanks
     C                   EVAL      SCMCMT = *blanks
 
     C                   SETON                                          2021
     C                   WRITE     CTL321C2
     C                   SETOFF                                         2021
 
      * Reset SFLRRN
     C                   EVAL      Sfrrn2 = *Zero
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * LOADSF2 - Load subfile data - detail record                   *
      *                                                               *
      * Called by: ADDREC AMDREC DELREC ENQREC                        *
      *                                                               *
      * Calls: MOVFIL CLRFLDS                                         *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     LOADSF2       BEGSR
      *    *******
 
      * Build subfile - 11 records always
 
     C                   DO        11            #C2
 
 
      * If action is add fill subfile with blank records
      * Else need to get data for Amend/delete/enquire
 
     C                   IF        #Act <> 'I'
     C                   EXSR      MOVFIL
     C                   ELSE
     C                   EXSR      CLRFLDS
     C                   ENDIF
 
     C                   IF        #C2 < 11
     C                   MOVE      #C2           Scran1
     C                   MOVE      #C2           Scran2
     C                   MOVE      #C2           Scran3
     C                   MOVE      #C2           Scran4
     C                   ELSE
     C                   EVAL      Scran1 = 'OB'
     C                   EVAL      Scran2 = 'OB'
     C                   EVAL      Scran3 = 'OB'
     C                   EVAL      Scran4 = 'OB'
     C                   ENDIF
 
     C                   EVAL      Sfrrn2 = #C2
 
     C                   IF        #C2 = 11
     C                   EVAL      *In29 = *On
     C                   ENDIF
 
     C                   IF        #C2 = 1
     C                   EVAL      *In80 = *On
     C                   ENDIF
 
     C                   Eval      SCTXT1 = 'Manual'                                          245708
     C                   Eval      SCTXT2 = 'Minimum Charge'                                  245708
     C                   Eval      SCTXT3 = 'Maximum Charge'                                  245708
     C                   Eval      SCTXT4 = 'Manual'                                          245708
     C                   Eval      SCTXT5 = 'Minimum Charge'                                  245708
     C                   Eval      SCTXT6 = 'Maximum Charge'                                  245708
     C                   Eval      SCTXT7 = 'STP'                                             245708
     C                   Eval      SCTXT8 = 'Minimum Charge'                                  245708
     C                   Eval      SCTXT9 = 'Maximum Charge'                                  245708
     C                   Eval      SCTXTA = 'STP'                                             245708
     C                   Eval      SCTXTB = 'Minimum Charge'                                  245708
     C                   Eval      SCTXTC = 'Maximum Charge'                                  245708
                                                                                              245708
     C                   WRITE     Sfl321s2
 
     C                   IF        #C2 = 11
     C                   EVAL      *In29 = *Off
     C                   ENDIF
 
     C                   IF        #C2 = 1
     C                   EVAL      *In80 = *Off
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      Sfpos2 = 1
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * MOVFIL  - Move file fields to screen fields                   *
      *                                                               *
      * Called by: LOADSF2                                            *
      *                                                               *
      * Calls: DECIMALS ZEDIT                                         *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     MOVFIL        BEGSR
      *    ******
 
     C                   SELECT
 
     C                   WHEN      #C2 = 1
 
      * Header fields
 
     C                   IF        #Act <> 'I'
     C                   EVAL      SPYCCD = PYCHCD
     C                   EVAL      SCHDSC = CHDESC
     C                   ENDIF
     C                   EVAL      SCVTLB = VATLIN
     C                   EVAL      SCMCMT = CALCMD
     C                   EVAL      SCSCMT = STPCMD
 
      * Manual base ccy fields SFL rec 1 (range 1)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 1 (range 1)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 1 (range 1)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 1 (range 1)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC01 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 2
 
      * Manual base ccy fields SFL rec 2 (range 2)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
 
     C                   IF        MIBC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 2 (range 2)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 2 (range 2)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 2 (range 2)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC02 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 3
 
      * Manual base ccy fields SFL rec 3 (range 3)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 3 (range 3)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 3 (range 3)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 3 (range 3)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC03 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 4
 
      * Manual base ccy fields SFL rec 4 (range 4)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 4 (range 4)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 4 (range 4)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 4 (range 4)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC04 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 5
 
      * Manual base ccy fields SFL rec 5 (range 5)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 5 (range 5)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 5 (range 5)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 5 (range 5)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC05 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 6
 
      * Manual base ccy fields SFL rec 6 (range 6)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 6 (range 6)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 6 (range 6)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 6 (range 6)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC06 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 7
 
      * Manual base ccy fields SFL rec 7 (range 7)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 7 (range 7)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 7 (range 7)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 7 (range 7)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC07 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 8
 
      * Manual base ccy fields SFL rec 8 (range 8)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 8 (range 8)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 8 (range 8)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 8 (range 8)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC08 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 9
 
      * Manual base ccy fields SFL rec 9 (range 9)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 9 (range 9)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC09 <> *ZEROS
     C                   MOVE      MIOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 9 (range 9)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 9 (range 9)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC09 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 10
 
      * Manual base ccy fields SFL rec 10 (range 10)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   IF        EABC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      EABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        MIBC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        MXBC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MXBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      RATE10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   IF        PMBC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      PMBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
      * Manual other currency  SFL rec 10 (range 10)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      STOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
 
     C                   IF        ENOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ENOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        MIOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MIOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        MAOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      MAOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 10 (range 10)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   IF        SSEC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSEC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SMIB10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SMAB10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SRAT10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   IF        SPMB10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SPMB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
      * STP other currency SFL rec 10 (range 10)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SSOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   IF        SEOC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SEOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SMIO10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMIO10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SMAC10 <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SMAC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   WHEN      #C2 = 11
 
      * Manual base ccy fields SFL rec 11 (range out of band)
 
     C                   EVAL      SCCCY1 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
 
     C                   IF        OPMAB <> *ZEROS
     C                   EVAL      A6NBDP = 8
     C                   Move      *Blanks       ZField
     C                   MOVE      OPMAB         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
     C                   IF        OMIBC <> *ZEROS
     C                   EXSR      Decimals
     C                   Move      *Blanks       ZField
     C                   MOVE      OMIBC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   IF        OMABC <> *ZEROS
     C                   EXSR      Decimals
     C                   Move      *Blanks       ZField
     C                   MOVE      OMABC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        ORBC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      ORBC          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
      * Manual other currency  SFL rec 11 (range out of band)
 
     C                   EVAL      SCCCY2 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        OMIOC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      OMIOC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
 
     C                   IF        OMAOC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      OMAOC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
      * STP base currency SFL rec 11 (range out of band)
 
     C                   EVAL      SCCCY3 =  #Basccy
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SOPMAB <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SOPMAB        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
     C                   EXSR      Decimals
     C                   IF        SOMIBC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SOMIBC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   IF        SOMABC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SOMABC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   EVAL      A6NBDP = 8
     C                   IF        SORBC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SORBC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
      * STP other currency SFL rec 11 (range out of band)
 
     C                   EVAL      SCCCY4 = OTHCCY
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SOMIOC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SOMIOC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   IF        SOMAOC <> *ZEROS
     C                   Move      *Blanks       ZField
     C                   MOVE      SOMAOC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * CLRFLDS  - Clear screen flds for input                        *
      *                                                               *
      * Called by: LOADSF2                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     CLRFLDS       BEGSR
      *    *******
 
      * Header fields
 
     C                   IF        #C2 = 1
 
     C                   EVAL      SPYCCD = *blanks
     C                   EVAL      SCHDSC = *blanks
     C                   EVAL      SCVTLB = *blanks
     C                   EVAL      SCMCMT = *blanks
     C                   EVAL      SCSCMT = *blanks
 
     C                   ENDIF
      * Sfl rec
 
     C                   CLEAR                   Sfl321s2
 
      * Set default data (Base Currency)
     C                   EVAL      SCCCY1 = #Basccy
     C                   EVAL      SCCCY3 = #Basccy
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * VALIDATE Data Items                                           *
      *                                                               *
      * Called by: ADDREC AMDREC                                      *
      *                                                               *
      * Calls: SNDMSG ZALIGN DECIMALS ZEDIT GETBAS OBALLOWED          *
      *                                                               *
      *****************************************************************
 
      *    ********
     C     VALIDATE      BEGSR
      *    ********
 
 
      * Clear error fields and set work fields
     C                   EVAL      #Amenderr = *blanks
     C                   EVAL      #Adderr   = *blanks
     C                   EVAL      #Amendok = *blanks
     C                   EVAL      #Addok = *blanks
     C                   EVAL      #Sf2pos = *blanks
     C                   EVAL      #Pmbase = *blanks
     C                   EVAL      #Rtbase = *blanks
     C                   EVAL      #Pmstp = *blanks
     C                   EVAL      #Rtstp = *blanks
     C                   EVAL      #Manother = *blanks
     C                   EVAL      #Stpother = *blanks
     C                   MOVE      '1'           #Diff1
     C                   MOVE      '1'           #Diff2
 
      * Clear error indicators for header
     C                   MOVEA     '000000'      *IN(50)
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
      * Payment charge code
 
     C                   IF        #Act = 'I'
 
     C                   IF        SPYCCD = *blanks
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1010'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      *In51 = *On
     C                   ENDIF
 
     C     Spyccd        SETLL     FTPCHGD0                               94
 
     C                   IF        *In94 = *On
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1005'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      *In51 = *On
     C                   ELSE
     C                   EVAL      PYCHCD = SPYCCD
     C                   ENDIF
 
     C                   ENDIF
 
      * Charge description
 
     C                   IF        SCHDSC = *blanks
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1006'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In52 = *On
     C                   ELSE
     C                   EVAL      CHDESC = SCHDSC
     C                   ENDIF
 
      * VAT liable indicator
 
     C                   IF        CFT010 = 'Y'
     C                   IF        SCVTLB <> *blanks and SCVTLB <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1007'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In53 = *On
     C                   ELSE
     C                   EVAL      VATLIN = SCVTLB
     C                   ENDIF
     C                   ENDIF
 
      * Calculation method
 
     C                   IF        SCMCMT <> 'T' and SCMCMT <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1008'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In54 = *On
     C                   ELSE
     C                   EVAL      CALCMD = SCMCMT
     C                   ENDIF
 
      * STP calculation method
 
     C                   IF        SCSCMT <> 'T' and SCSCMT <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1009'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In55 = *On
     C                   ELSE
     C                   EVAL      STPCMD = SCSCMT
     C                   ENDIF
 
     C                   DO        11            #C2
 
      * Clear error indicators sfl
     C                   MOVEA     '0000'        *IN(56)
     C                   MOVEA     '0000000000'  *IN(60)
     C                   MOVEA     '0000000000'  *IN(70)
     C                   MOVEA     '0'           *IN(80)
 
     C                   EVAL      Sfrrn2 = #C2
     C     Sfrrn2        CHAIN     Sfl321s2                           96
 
     C                   SELECT
 
     C                   WHEN      #C2 = 1
     C/COPY OFCPYSRCZ,CFT147_018                                                              CFT147
 
      * Range 1 - manual base range start
 
     C                   EVAL      *In80 = *On
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC01 <> *ZEROS
     C                   MOVE      SABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   ENDIF
 
      * Range 1 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC01 <> *ZEROS
     C                   MOVE      EABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        SABC01 >= EABC01 and SABC01 <> 0
     C                             and EABC01 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
      * Range 1 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC01 <> *ZEROS
     C                   MOVE      MIBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        SABC01 = *Zeros and EABC01 = *Zeros
     C                             and MIBC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
 
      * Range 1 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MXBC01 <> *ZEROS
     C                   MOVE      MXBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   IF        MIBC01 >  MXBC01 and MIBC01 <> 0 and +
     C                                       MXBC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SABC01 = *Zeros and EABC01 = *Zeros
     C                             and MXBC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 1 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
 
     C                   IF        RATE01 <> *ZEROS
     C                   MOVE      RATE01        ZFIELD
     C                   EVAL      A6NBDP = 8
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y' and RATE01 <> 0
     C                   IF        #Pmbase = 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SABC01 = *Zeros and EABC01 = *Zeros
     C                             and RATE01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 1 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC01 <> *ZEROS
     C                   MOVE      PMBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y' and PMBC01 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
 
     C                   IF        SABC01 = *Zeros and EABC01 = *Zeros
     C                             and PMBC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 1 - manual other currency
      * If #F3Curr = 'Y' then <F3> was pressed last time currency
      * prompt was called so clear this field so it is not called
      * again on second validation.
     C                   IF        #F3Curr = 'Y'
     C                   EVAL      SCCCY2 = *BLANKS
     C                   EVAL      #F3Curr = *BLANKS
     C                   ENDIF
 
     C                   IF        SCCCY2 <> *blanks
      * If currency prompt program called (*IN81) then set flag so     .
      * program returns to screen even if there are no errors.
     C     '?'           SCAN      SCCCY2                                 81
     C                   IF        *IN81
     C                   EVAL      #CcyPrompt = 'Y'
     C                   ENDIF
 
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        #RTCD <> *Blanks OR #CCYA = #Basccy
 
      * Allow for non select <F3> from currency prompt program
     C                   IF        #RTCD = '*NOSEL '
     C                   EVAL      OTHCCY = *blanks
     C                   EVAL      W#OTHCCY = *blanks
     C                   ELSE
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #Othmd  = A6MDIN
     C                   EVAL      #Othdec = A6NBDP
     C                   EVAL      #Othint = 13 - #Othdec
     C                   EVAL      ZADEC = #Othdec
     C                   EVAL      ZADIG = #Othint
     C                   EVAL      #Manother = 'Y'
     C                   EVAL      SCCCY2 = #Ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   MOVE      SCCCY2        W#OthCcy          3
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OTHCCY = *blanks
     C                   EVAL      W#OTHCCY = *blanks
     C                   ENDIF
 
      * Range 1 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC01
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC01 <> *ZEROS
     C                   MOVE      STOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        STOC01 <> 0 and #Manother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC01 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC01
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC01 <> *ZEROS
     C                   MOVE      SABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
      *                  Currency not set
     C                   ELSE
     C                   IF        STOC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
      * Range 1 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C     '?'           SCAN      SCCCY2                                 81
     C                   IF        *IN81 = *OFF
     C                   EVAL      #Ccya  =  SCCCY2
     C                   ENDIF
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC01
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        ENOC01 <> *ZEROS
     C                   MOVE      ENOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
      * If Manual other curreny entered for range 1 then
      * range end must be entered.
 
     C                   IF        ENOC01 = *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1025'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
      * Move pro mile amount
 
     C                   IF        STOC01 >= ENOC01 and STOC01 <> 0
     C                             and ENOC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ENOC01 <> 0 and #Manother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC01 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC01
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC01 <> *ZEROS
     C                   MOVE      EABC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      *                  Currency not set
     C                   ELSE
     C                   IF        ENOC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 1 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C     '?'           SCAN      SCCCY2                                 81
     C                   IF        *IN81 = *OFF
     C                   EVAL      #Ccya  =  SCCCY2
     C                   ENDIF
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC01
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MIOC01 <> *ZEROS
     C                   MOVE      MIOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        MIOC01 <> 0 and #Manother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC01 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC01
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC01 <> *ZEROS
     C                   MOVE      MIBC01        ZFIELD
     C                   EXSR      ZEDIT
      * Don't default base equivalent if error in that field.
     C                   IF        *IN60 = *OFF
     C                   MOVE      ZFIELD        SCMIC1
     C                   ENDIF
     C                   ELSE
      * Don't default base equivalent if error in that field.
     C                   IF        *IN60 = *OFF
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        MIOC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        STOC01 = *Zeros and ENOC01 = *Zeros
     C                             and MIOC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 1 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C     '?'           SCAN      SCCCY2                                 81
     C                   IF        *IN81 = *OFF
     C                   EVAL      #Ccya  =  SCCCY2
     C                   ENDIF
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC01
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MAOC01 <> *ZEROS
     C                   MOVE      MAOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
     C                   IF        MIOC01 >  MAOC01 and MIOC01 <> 0 and +
     C                                       MAOC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        MAOC01 <> 0 and #Manother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC01 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC01
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MXBC01 <> *ZEROS
     C                   MOVE      MXBC01        ZFIELD
     C                   EXSR      ZEDIT
      * Don't default base equivalent if error in that field.
     C                   IF        *IN61 = *OFF
     C                   MOVE      ZFIELD        SCMAC1
     C                   ENDIF
     C                   ELSE
      * Don't default base equivalent if error in that field.
     C                   IF        *IN61 = *OFF
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        MAOC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        STOC01 = *Zeros and ENOC01 = *Zeros
     C                             and MAOC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 1 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC01 <> *ZEROS
     C                   MOVE      SSBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
 
     C                   ENDIF
 
      * Range 1 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSEC01 <> *ZEROS
     C                   MOVE      SSEC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SSBC01 >= SSEC01 and SSBC01 <> 0
     C                             and SSEC01 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
      * Range 1 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMIB01 <> *ZEROS
     C                   MOVE      SMIB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        SSBC01 = *Zeros and SSEC01 = *Zeros
     C                             and SMIB01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 1 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMAB01 <> *ZEROS
     C                   MOVE      SMAB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
 
     C                   IF        SMIB01 >  SMAB01 and SMIB01 <> 0 and +
     C                                       SMAB01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SSBC01 = *Zeros and SSEC01 = *Zeros
     C                             and SMAB01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 1 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT01 <> *ZEROS
     C                   MOVE      SRAT01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y' and SRAT01 <> 0
     C                   IF        #Pmstp = 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SSBC01 = *Zeros and SSEC01 = *Zeros
     C                             and SRAT01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 1 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB01
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB01 <> *ZEROS
     C                   MOVE      SPMB01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y' and SPMB01 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
 
     C                   IF        SSBC01 = *Zeros and SSEC01 = *Zeros
     C                             and SPMB01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 1 - STP    other currency
 
     C     '?'           SCAN      SCCCY2                                 81
     C                   IF        *IN81 = *OFF
     C                   EVAL      SCCCY4 = SCCCY2
      * If manual other currency field still contains ? then
      * <F3> taken in currency selection so set STP other ccy
      * to blanks.
     C                   ELSE
     C                   EVAL      SCCCY4 = *BLANKS
     C                   ENDIF
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        #RTCD <> *Blanks
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      #Stpother = 'Y'
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      #Ccya  =  BJCYCD
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      OTHCCY = *blanks
     C                   ENDIF
 
      * Range 1 - STP    other range start
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC01
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SSOC01 <> *ZEROS
     C                   MOVE      SSOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        SSOC01 <> 0 and #Stpother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC01 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC01
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC01 <> *ZEROS
     C                   MOVE      SSBC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
      * Range 1 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ELSE
     C                   EVAL      ZADEC = 0
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC01
 
     C                   IF        #Stpother <> 'Y' and SEOC01 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SEOC01 <> *ZEROS
     C                   MOVE      SEOC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
      * If Manual other curreny entered for range 1 then
      * range end must be entered.
 
     C                   IF        SEOC01 = *ZEROS AND SSEC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1025'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        SSOC01 >= SEOC01 and SSOC01 <> 0
     C                             and SEOC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SEOC01 <> 0 and #Stpother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC01 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC01
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSEC01 <> *ZEROS
     C                   MOVE      SSEC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * Range 1 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO01
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SMIO01 <> *ZEROS
     C                   MOVE      SMIO01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        SMIO01 <> 0 and #Stpother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB01 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO01
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMIB01 <> *ZEROS
     C                   MOVE      SMIB01        ZFIELD
     C                   EXSR      ZEDIT
      * Don't default base value if error in that field.
     C                   IF        *IN72 = *OFF
     C                   MOVE      ZFIELD        SCMIC3
     C                   ENDIF
     C                   ELSE
      * Don't default base value if error in that field.
     C                   IF        *IN72 = *OFF
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SMIO01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SSOC01 = *Zeros and SEOC01 = *Zeros
     C                             and SMIO01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 1 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC01
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SMAC01 <> *ZEROS
     C                   MOVE      SMAC01        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
 
     C                   IF        SMIO01 >  SMAC01 and SMIO01 <> 0 and
     C                                       SMAC01 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SMAC01 <> 0 and #Stpother <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1016'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB01 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC01
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB01 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMAB01 <> *ZEROS
     C                   MOVE      SMAB01        ZFIELD
     C                   EXSR      ZEDIT
      * Don't default base value if error in that field.
     C                   IF        *IN73 = *OFF
     C                   MOVE      ZFIELD        SCMAC3
     C                   ENDIF
     C                   ELSE
      * Don't default base value if error in that field.
     C                   IF        *IN73 = *OFF
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SMAC01 <> *Zeros
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SSOC01 = *Zeros and SEOC01 = *Zeros
     C                             and SMAC01 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 2
 
      * Range 2 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC02 <> *ZEROS
     C                   MOVE      SABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
 
     C                   ENDIF
 
      * Range 2 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC02 <> *ZEROS
     C                   MOVE      EABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
 
     C                   IF        SABC02 >= EABC02 and SABC02 <> 0
     C                             and EABC02 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC02 <> EABC01 + #Diff1 and SABC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC02 = 0 and EABC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC02 = *Zeros and EABC02 = *Zeros
     C                             and PMBC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 2 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC02 <> *ZEROS
     C                   MOVE      MIBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the base minimum charge should not be allowed.
 
     C                   IF        SABC02 = *Zeros and EABC02 = *Zeros
     C                             and MIBC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 2 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MXBC02 <> *ZEROS
     C                   MOVE      MXBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
 
     C                   IF        MIBC02 > MXBC02 and MIBC02 <> 0 and
     C                                      MXBC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the base maximum charge should not be allowed.
 
     C                   IF        SABC02 = *Zeros and EABC02 = *Zeros
     C                             and MXBC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 2 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE02 <> *ZEROS
     C                   MOVE      RATE02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE02 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 2 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC02 <> *ZEROS
     C                   MOVE      PMBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC02 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the base rate should not be allowed.
 
     C                   IF        SABC02 = *Zeros and EABC02 = *Zeros
     C                             and RATE02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 2 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
 
      * Range 2 - manual other range start
 
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC02
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC02 <> *ZEROS
     C                   MOVE      STOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC02 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC02 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC02
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC02 <> *ZEROS
     C                   MOVE      SABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 2 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC02
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        ENOC02 <> *ZEROS
     C                   MOVE      ENOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC02 >= ENOC02 and STOC02 <> 0
     C                             and ENOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC02 <> ENOC01 + #Diff2 and STOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC02 = 0 and ENOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC02 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC02
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC02 <> *ZEROS
     C                   MOVE      EABC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
 
 
     C                   ENDIF
     C                   ELSE
     C                   IF        ENOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
      * Range 2 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC02
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MIOC02 <> *ZEROS
     C                   MOVE      MIOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
 
     C                   IF        *In66 = *Off and MIBC02 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC02
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC02 <> *ZEROS
     C                   MOVE      MIBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        SCCCY2 = *blanks and MIOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC02 = *Zeros and ENOC02 = *Zeros
     C                             and MIOC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 2 - manual other maximum charge
      *
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC02
 
     C                   IF        #Manother =  'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MAOC02 <> *ZEROS
     C                   MOVE      MAOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
 
     C                   IF        MIOC02 >  MAOC02 and MIOC02 <> 0 and +
     C                                       MAOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
     C                   IF        *In67 = *Off and MXBC02 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC02
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MXBC02 <> *ZEROS
     C                   MOVE      MXBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
     C                   IF        SCCCY2 = *blanks and MAOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC02 = *Zeros and ENOC02 = *Zeros
     C                             and MAOC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
 
      * Range 2 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC02 <> *ZEROS
     C                   MOVE      SSBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 2 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSEC02 <> *ZEROS
     C                   MOVE      SSEC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
 
     C                   IF        SSBC02 >= SSEC02 and SSBC02 <> 0
     C                             and SSEC02 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC02 <> SSEC01 + #Diff1 and SSBC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC02 = 0 and SSEC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC02 = *Zeros and SSEC02 = *Zeros
     C                             and SPMB02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 2 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMIB02 <> *ZEROS
     C                   MOVE      SMIB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC02 = *Zeros and SSEC02 = *Zeros
     C                             and SMIB02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 2 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMAB02 <> *ZEROS
     C                   MOVE      SMAB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB02 >  SMAB02 and SMIB02 <> 0 and +
     C                                       SMAB02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC02 = *Zeros and SSEC02 = *Zeros
     C                             and SMAB02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 2 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT02 <> *ZEROS
     C                   MOVE      SRAT02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT02 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 2 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB02 <> *ZEROS
     C                   MOVE      SPMB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB02 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC02 = *Zeros and SSEC02 = *Zeros
     C                             and SRAT02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 2 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 2 - STP    other range start
 
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC02
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC02 <> *ZEROS
     C                   MOVE      SSOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC02 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
 
     C                   IF        *In75 = *Off and SSBC02 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC02
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC02 <> *ZEROS
     C                   MOVE      SSBC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SSOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
 
     C                   ENDIF
 
      * Range 2 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC02
 
     C                   IF        #Stpother <> 'Y' and SEOC02 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SEOC02 <> *ZEROS
     C                   MOVE      SEOC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC02 >= SEOC02 and SSOC02 <> 0
     C                             and SEOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC02 <> SEOC01 + #Diff2 and SSOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC02 = 0 and SEOC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC02 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC02
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC02 <> *ZEROS
     C                   MOVE      SSEC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 2 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SMIO02 <> *ZEROS
     C                   MOVE      SMIO02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB02 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO02
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMIB02 <> *ZEROS
     C                   MOVE      SMIB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC02 = *Zeros and SEOC02 = *Zeros
     C                             and SMIO02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 2 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC02
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
 
     C                   IF        SMAC02 <> *ZEROS
     C                   MOVE      SMAC02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO02 >  SMAC02 and SMIO02 <> 0 and +
     C                                       SMAC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC02 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB02 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC02
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB02 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SMAB02 <> *ZEROS
     C                   MOVE      SMAB02        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC02 = *Zeros and SEOC02 = *Zeros
     C                             and SMAC02 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 3
 
      * Range 3 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC03 <> *ZEROS
     C                   MOVE      SABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC03 <> *ZEROS
     C                   MOVE      EABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC03 >= EABC03 and SABC03 <> 0
     C                             and EABC03 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC03 <> EABC02 + #Diff1 and SABC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC03 = 0 and EABC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC03 = *Zeros and EABC03 = *Zeros
     C                             and PMBC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 3 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC03 <> *ZEROS
     C                   MOVE      MIBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC03 = *Zeros and EABC03 = *Zeros
     C                             and MIBC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 3 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC03 <> *ZEROS
     C                   MOVE      MXBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC03 > MXBC03 and MIBC03 <> 0 and +
     C                                      MXBC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC03 = *Zeros and EABC03 = *Zeros
     C                             and MXBC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 3 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE03 <> *ZEROS
     C                   MOVE      RATE03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE03 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 3 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC03 <> *ZEROS
     C                   MOVE      PMBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC03 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC03 = *Zeros and EABC03 = *Zeros
     C                             and RATE03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 3 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
 
      * Range 3 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC03
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        STOC03 <> *ZEROS
     C                   MOVE      STOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC03 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC03 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC03
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SABC03 <> *ZEROS
     C                   MOVE      SABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC03
 
     C                   IF        #Manother <> 'Y' and ENOC03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        ENOC03 <> *ZEROS
     C                   MOVE      ENOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC03 >= ENOC03 and STOC03 <> 0
     C                             and ENOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC03 <> ENOC02 + #Diff2 and STOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC03 = 0 and ENOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC03 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC03
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        EABC03 <> *ZEROS
     C                   MOVE      EABC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC03
 
     C                   IF        #Manother <> 'Y' and MIOC03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MIOC03 <> *ZEROS
     C                   MOVE      MIOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC03 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC03
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        MIBC03 <> *ZEROS
     C                   MOVE      MIBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC03 = *Zeros and ENOC03 = *Zeros
     C                             and MIOC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 3 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC03
 
     C                   IF        #Manother <> 'Y' and MAOC03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
 
     C                   IF        MAOC03 <> *ZEROS
     C                   MOVE      MAOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC03 >  MAOC03 and MIOC03 <> 0 and +
     C                                       MAOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC03 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC03
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC03 <> *ZEROS
     C                   MOVE      MXBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC03 = *Zeros and ENOC03 = *Zeros
     C                             and MAOC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 3 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSBC03 <> *ZEROS
     C                   MOVE      SSBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
 
     C                   IF        SSEC03 <> *ZEROS
     C                   MOVE      SSEC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC03 >= SSEC03 and SSBC03 <> 0
     C                             and SSEC03 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC03 <> SSEC02 + #Diff1 and SSBC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC03 = 0 and SSEC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC03 = *Zeros and SSEC03 = *Zeros
     C                             and SPMB03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 3 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB03 <> *ZEROS
     C                   MOVE      SMIB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC03 = *Zeros and SSEC03 = *Zeros
     C                             and SMIB03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 3 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB03 <> *ZEROS
     C                   MOVE      SMAB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB03 >  SMAB03 and SMIB03 <> 0 and +
     C                                       SMAB03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC03 = *Zeros and SSEC03 = *Zeros
     C                             and SMAB03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 3 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT03 <> *ZEROS
     C                   MOVE      SRAT03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT03 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 3 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB03
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB03 <> *ZEROS
     C                   MOVE      SPMB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB03 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC03 = *Zeros and SSEC03 = *Zeros
     C                             and SRAT03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 3 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 3 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC03
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC03 <> *ZEROS
     C                   MOVE      SSOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC03 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC03 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC03
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC03 <> *ZEROS
     C                   MOVE      SSBC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC03
 
     C                   IF        #Stpother <> 'Y' and SEOC03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC03 <> *ZEROS
     C                   MOVE      SEOC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC03 >= SEOC03 and SSOC03 <> 0
     C                             and SEOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC03 <> SEOC02 + #Diff2 and SSOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC03 = 0 and SEOC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC03 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC03
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC03 <> *ZEROS
     C                   MOVE      SSEC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 3 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO03
 
     C                   IF        #Stpother <> 'Y' and SMIO03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO03 <> *ZEROS
     C                   MOVE      SMIO03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB03 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO03
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB03 <> *ZEROS
     C                   MOVE      SMIB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC03 = *Zeros and SEOC03 = *Zeros
     C                             and SMIO03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 3 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC03
 
     C                   IF        #Stpother <> 'Y' and SMAC03 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC03 <> *ZEROS
     C                   MOVE      SMAC03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO03 >  SMAC03 and SMIO03 <> 0 and +
     C                                       SMAC03 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB03 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC03
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB03 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB03 <> *ZEROS
     C                   MOVE      SMAB03        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC03 = *Zeros and SEOC03 = *Zeros
     C                             and SMAC03 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 4
 
      * Range 4 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC04 <> *ZEROS
     C                   MOVE      SABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC04 <> *ZEROS
     C                   MOVE      EABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC04 >= EABC04 and SABC04 <> 0
     C                             and EABC04 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC04 <> EABC03 + #Diff1 and SABC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC04 = 0 and EABC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC04 = *Zeros and EABC04 = *Zeros
     C                             and PMBC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 4 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC04 <> *ZEROS
     C                   MOVE      MIBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC04 = *Zeros and EABC04 = *Zeros
     C                             and MIBC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 4 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC04 <> *ZEROS
     C                   MOVE      MXBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC04 > MXBC04 and MIBC04 <> 0 and +
     C                                      MXBC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
 
     C                   IF        SABC04 = *Zeros and EABC04 = *Zeros
     C                             and MXBC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 4 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE04 <> *ZEROS
     C                   MOVE      RATE04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE04 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 4 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC04 <> *ZEROS
     C                   MOVE      PMBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC04 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC04 = *Zeros and EABC04 = *Zeros
     C                             and RATE04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 4 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 4 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC04
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC04 <> *ZEROS
     C                   MOVE      STOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC04 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC04 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC04
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC04 <> *ZEROS
     C                   MOVE      SABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC04
 
     C                   IF        #Manother <> 'Y' and ENOC04 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC04 <> *ZEROS
     C                   MOVE      ENOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC04 >= ENOC04 and STOC04 <> 0
     C                             and ENOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC04 <> ENOC03 + #Diff2 and STOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC04 = 0 and ENOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC04 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC04
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC04 <> *ZEROS
     C                   MOVE      EABC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - manual other minimum charge
      *
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC04 <> *ZEROS
     C                   MOVE      MIOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC04 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC04
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC04 <> *ZEROS
     C                   MOVE      MIBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC04 = *Zeros and ENOC04 = *Zeros
     C                             and MIOC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 4 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC04 <> *ZEROS
     C                   MOVE      MAOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC04 >  MAOC04 and MIOC04 <> 0 and +
     C                                       MAOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC04 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC04
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC04 <> *ZEROS
     C                   MOVE      MXBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC04 = *Zeros and ENOC04 = *Zeros
     C                             and MAOC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 4 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC04 <> *ZEROS
     C                   MOVE      SSBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC04 <> *ZEROS
     C                   MOVE      SSEC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC04 >= SSEC04 and SSBC04 <> 0
     C                             and SSEC04 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC04 <> SSEC03 + #Diff1 and SSBC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC04 = 0 and SSEC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC04 = *Zeros and SSEC04 = *Zeros
     C                             and SPMB04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 4 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB04 <> *ZEROS
     C                   MOVE      SMIB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC04 = *Zeros and SSEC04 = *Zeros
     C                             and SMIB04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 4 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB04 <> *ZEROS
     C                   MOVE      SMAB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB04 >  SMAB04 and SMIB04 <> 0 and +
     C                                       SMAB04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC04 = *Zeros and SSEC04 = *Zeros
     C                             and SMAB04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 4 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT04 <> *ZEROS
     C                   MOVE      SRAT04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT04 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 4 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB04 <> *ZEROS
     C                   MOVE      SPMB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB04 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC04 = *Zeros and SSEC04 = *Zeros
     C                             and SRAT04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 4 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 4 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC04
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC04 <> *ZEROS
     C                   MOVE      SSOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC04 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC04 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC04
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC04 <> *ZEROS
     C                   MOVE      SSBC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC04
 
     C                   IF        #Stpother <> 'Y' and SEOC04 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC04 <> *ZEROS
     C                   MOVE      SEOC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC04 >= SEOC04 and SSOC04 <> 0
     C                             and SEOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC04 <> SEOC03 + #Diff2 and SSOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC04 = 0 and SEOC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC04 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC04
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC04 <> *ZEROS
     C                   MOVE      SSEC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 4 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   IF        SMIO04 <> *ZEROS
     C                   EXSR      DECIMALS
     C                   MOVE      SMIO04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB04 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO04
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB04 <> *ZEROS
     C                   MOVE      SMIB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC04 = *Zeros and SEOC04 = *Zeros
     C                             and SMIO04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 4 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC04
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC04 <> *ZEROS
     C                   MOVE      SMAC04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO04 >  SMAC04 and SMIO04 <> 0 and +
     C                                       SMAC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC04 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB04 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC04
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB04 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB04 <> *ZEROS
     C                   MOVE      SMAB04        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC04 = *Zeros and SEOC04 = *Zeros
     C                             and SMAC04 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 5
 
      * Range 5 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC05 <> *ZEROS
     C                   MOVE      SABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC05 <> *ZEROS
     C                   MOVE      EABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC05 >= EABC05 and SABC05 <> 0
     C                             and EABC05 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC05 <> EABC04 + #Diff1 and SABC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC05 = 0 and EABC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC05 = *Zeros and EABC05 = *Zeros
     C                             and PMBC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 5 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC05 <> *ZEROS
     C                   MOVE      MIBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC05 = *Zeros and EABC05 = *Zeros
     C                             and MIBC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 5 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC05 <> *ZEROS
     C                   MOVE      MXBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC05 > MXBC05 and MIBC05 <> 0 and +
     C                                      MXBC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC05 = *Zeros and EABC05 = *Zeros
     C                             and MXBC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 5 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE05 <> *ZEROS
     C                   MOVE      RATE05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE05 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 5 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC05 <> *ZEROS
     C                   MOVE      PMBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC05 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC05 = *Zeros and EABC05 = *Zeros
     C                             and RATE05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 5 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 5 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC05
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC05 <> *ZEROS
     C                   MOVE      STOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC05 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC05 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC05
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC05 <> *ZEROS
     C                   MOVE      SABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   IF        #Manother <> 'Y' and ENOC05 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC05 <> *ZEROS
     C                   MOVE      ENOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
 
     C                   IF        STOC05 >= ENOC05 and STOC05 <> 0
     C                             and ENOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC05 <> ENOC04 + #Diff2 and STOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC05 = 0 and ENOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC05 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC05
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC05 <> *ZEROS
     C                   MOVE      EABC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC05 <> *ZEROS
     C                   MOVE      MIOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC05 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC05
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC05 <> *ZEROS
     C                   MOVE      MIBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC05 = *Zeros and ENOC05 = *Zeros
     C                             and MIOC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 5 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC05 <> *ZEROS
     C                   MOVE      MAOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC05 >  MAOC05 and MIOC05 <> 0 and +
     C                                       MAOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC05 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC05
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC05 <> *ZEROS
     C                   MOVE      MXBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC05 = *Zeros and ENOC05 = *Zeros
     C                             and MAOC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 5 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC05 <> *ZEROS
     C                   MOVE      SSBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC05 <> *ZEROS
     C                   MOVE      SSEC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC05 >= SSEC05 and SSBC05 <> 0
     C                             and SSEC05 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC05 <> SSEC04 + #Diff1 and SSBC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC05 = 0 and SSEC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC05 = *Zeros and SSEC05 = *Zeros
     C                             and SPMB05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 5 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB05 <> *ZEROS
     C                   MOVE      SMIB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC05 = *Zeros and SSEC05 = *Zeros
     C                             and SMIB05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 5 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB05 <> *ZEROS
     C                   MOVE      SMAB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB05 >  SMAB05 and SMIB05 <> 0 and +
     C                                       SMAB05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC05 = *Zeros and SSEC05 = *Zeros
     C                             and SMAB05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 5 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT05 <> *ZEROS
     C                   MOVE      SRAT05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT05 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 5 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB05 <> *ZEROS
     C                   MOVE      SPMB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB05 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC05 = *Zeros and SSEC05 = *Zeros
     C                             and SRAT05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 5 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 5 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC05
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC05 <> *ZEROS
     C                   MOVE      SSOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC05 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC05 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC05
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC05 <> *ZEROS
     C                   MOVE      SSBC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC05
 
     C                   IF        #Stpother <> 'Y' and SEOC05 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC05 <> *ZEROS
     C                   MOVE      SEOC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC05 >= SEOC05 and SSOC05 <> 0
     C                             and SEOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC05 <> SEOC04 + #Diff2 and SSOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC05 = 0 and SEOC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC05 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC05
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC05 <> *ZEROS
     C                   MOVE      SSEC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 5 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO05 <> *ZEROS
     C                   MOVE      SMIO05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB05 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO05
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB05 <> *ZEROS
     C                   MOVE      SMIB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC05 = *Zeros and SEOC05 = *Zeros
     C                             and SMIO05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 5 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC05
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC05 <> *ZEROS
     C                   MOVE      SMAC05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO05 >  SMAC05 and SMIO05 <> 0 and +
     C                                       SMAC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC05 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB05 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC05
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB05 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB05 <> *ZEROS
     C                   MOVE      SMAB05        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC05 = *Zeros and SEOC05 = *Zeros
     C                             and SMAC05 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 6
 
      * Range 6 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC06 <> *ZEROS
     C                   MOVE      SABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC06 <> *ZEROS
     C                   MOVE      EABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC06 >= EABC06 and SABC06 <> 0
     C                             and EABC06 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC06 <> EABC05 + #Diff1 and SABC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC06 = 0 and EABC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC06 = *Zeros and EABC06 = *Zeros
     C                             and PMBC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 6 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC06 <> *ZEROS
     C                   MOVE      MIBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC06 = *Zeros and EABC06 = *Zeros
     C                             and MIBC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 6 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC06 <> *ZEROS
     C                   MOVE      MXBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC06 > MXBC06 and MIBC06 <> 0 and +
     C                                      MXBC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC06 = *Zeros and EABC06 = *Zeros
     C                             and MXBC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 6 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE06 <> *ZEROS
     C                   MOVE      RATE06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE06 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 6 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC06 <> *ZEROS
     C                   MOVE      PMBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC06 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC06 = *Zeros and EABC06 = *Zeros
     C                             and RATE06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 6 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 6 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC06
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC06 <> *ZEROS
     C                   MOVE      STOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC06 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC06 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC06
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC06 <> *ZEROS
     C                   MOVE      SABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC06
 
     C                   IF        #Manother <> 'Y' and ENOC06 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC06 <> *ZEROS
     C                   MOVE      ENOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC06 >= ENOC06 and STOC06 <> 0
     C                             and ENOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC06 <> ENOC05 + #Diff2 and STOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC06 = 0 and ENOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC06 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC06
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC06 <> *ZEROS
     C                   MOVE      EABC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC06 <> *ZEROS
     C                   MOVE      MIOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC06 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC06
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC06 <> *ZEROS
     C                   MOVE      MIBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC06 = *Zeros and ENOC06 = *Zeros
     C                             and MIOC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 6 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC06 <> *ZEROS
     C                   MOVE      MAOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC06 >  MAOC06 and MIOC06 <> 0 and +
     C                                       MAOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC06 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC06
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC06 <> *ZEROS
     C                   MOVE      MXBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC06 = *Zeros and ENOC06 = *Zeros
     C                             and MAOC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 6 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC06 <> *ZEROS
     C                   MOVE      SSBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC06 <> *ZEROS
     C                   MOVE      SSEC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC06 >= SSEC06 and SSBC06 <> 0
     C                             and SSEC06 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC06 <> SSEC05 + #Diff1 and SSBC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC06 = 0 and SSEC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC06 = *Zeros and SSEC06 = *Zeros
     C                             and SPMB06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 6 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB06 <> *ZEROS
     C                   MOVE      SMIB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC06 = *Zeros and SSEC06 = *Zeros
     C                             and SMIB06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 6 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB06 <> *ZEROS
     C                   MOVE      SMAB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB06 >  SMAB06 and SMIB06 <> 0 and +
     C                                       SMAB06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC06 = *Zeros and SSEC06 = *Zeros
     C                             and SMAB06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 6 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT06 <> *ZEROS
     C                   MOVE      SRAT06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT06 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 6 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB06 <> *ZEROS
     C                   MOVE      SPMB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB06 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC06 = *Zeros and SSEC06 = *Zeros
     C                             and SRAT06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 6 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 6 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC06
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC06 <> *ZEROS
     C                   MOVE      SSOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC06 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC06 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC06
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC06 <> *ZEROS
     C                   MOVE      SSBC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC06
 
     C                   IF        #Stpother <> 'Y' and SEOC06 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC06 <> *ZEROS
     C                   MOVE      SEOC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC06 >= SEOC06 and SSOC06 <> 0
     C                             and SEOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC06 <> SEOC05 + #Diff2 and SSOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC06 = 0 and SEOC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC06 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC06
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC06 <> *ZEROS
     C                   MOVE      SSEC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 6 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO06 <> *ZEROS
     C                   MOVE      SMIO06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB06 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO06
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB06 <> *ZEROS
     C                   MOVE      SMIB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC06 = *Zeros and SEOC06 = *Zeros
     C                             and SMIO06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 6 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC06
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC06 <> *ZEROS
     C                   MOVE      SMAC06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO06 >  SMAC06 and SMIO06 <> 0 and +
     C                                       SMAC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC06 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB06 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC06
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB06 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB06 <> *ZEROS
     C                   MOVE      SMAB06        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC06 = *Zeros and SEOC06 = *Zeros
     C                             and SMAC06 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 7
 
      * Range 7 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC07 <> *ZEROS
     C                   MOVE      SABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC07 <> *ZEROS
     C                   MOVE      EABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC07 >= EABC07 and SABC07 <> 0
     C                             and EABC07 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC07 <> EABC06 + #Diff1 and SABC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC07 = 0 and EABC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC07 = *Zeros and EABC07 = *Zeros
     C                             and PMBC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 7 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC07 <> *ZEROS
     C                   MOVE      MIBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC07 = *Zeros and EABC07 = *Zeros
     C                             and MIBC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 7 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC07 <> *ZEROS
     C                   MOVE      MXBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC07 > MXBC07 and MIBC07 <> 0 and +
     C                                      MXBC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC07 = *Zeros and EABC07 = *Zeros
     C                             and MXBC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 7 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE07 <> *ZEROS
     C                   MOVE      RATE07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE07 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 7 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC07 <> *ZEROS
     C                   MOVE      PMBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC07 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC07 = *Zeros and EABC07 = *Zeros
     C                             and RATE07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 7 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 7 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC07
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC07 <> *ZEROS
     C                   MOVE      STOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC07 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC07 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC07
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC07 <> *ZEROS
     C                   MOVE      SABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC07
 
     C                   IF        #Manother <> 'Y' and ENOC07 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC07 <> *ZEROS
     C                   MOVE      ENOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC07 >= ENOC07 and STOC07 <> 0
     C                             and ENOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC07 <> ENOC06 + #Diff2 and STOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC07 = 0 and ENOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC07 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC07
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC07 <> *ZEROS
     C                   MOVE      EABC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC07 <> *ZEROS
     C                   MOVE      MIOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC07 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC07
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC07 <> *ZEROS
     C                   MOVE      MIBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC07 = *Zeros and ENOC07 = *Zeros
     C                             and MIOC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 7 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC07 <> *ZEROS
     C                   MOVE      MAOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC07 >  MAOC07 and MIOC07 <> 0 and +
     C                                       MAOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC07 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC07
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC07 <> *ZEROS
     C                   MOVE      MXBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC07 = *Zeros and ENOC07 = *Zeros
     C                             and MAOC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 7 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC07 <> *ZEROS
     C                   MOVE      SSBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC07 <> *ZEROS
     C                   MOVE      SSEC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC07 >= SSEC07 and SSBC07 <> 0
     C                             and SSEC07 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC07 <> SSEC06 + #Diff1 and SSBC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC07 = 0 and SSEC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC07 = *Zeros and SSEC07 = *Zeros
     C                             and SPMB07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 7 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB07 <> *ZEROS
     C                   MOVE      SMIB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC07 = *Zeros and SSEC07 = *Zeros
     C                             and SMIB07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 7 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB07 <> *ZEROS
     C                   MOVE      SMAB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB07 >  SMAB07 and SMIB07 <> 0 and +
     C                                       SMAB07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC07 = *Zeros and SSEC07 = *Zeros
     C                             and SMAB07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 7 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT07 <> *ZEROS
     C                   MOVE      SRAT07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT07 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 7 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB07 <> *ZEROS
     C                   MOVE      SPMB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB07 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC07 = *Zeros and SSEC07 = *Zeros
     C                             and SRAT07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 7 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 7 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC07
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC07 <> *ZEROS
     C                   MOVE      SSOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC07 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC07 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC07
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC07 <> *ZEROS
     C                   MOVE      SSBC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC07
 
     C                   IF        #Stpother <> 'Y' and SEOC07 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC07 <> *ZEROS
     C                   MOVE      SEOC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC07 >= SEOC07 and SSOC07 <> 0
     C                             and SEOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC07 <> SEOC06 + #Diff2 and SSOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC07 = 0 and SEOC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC07 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC07
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC07 <> *ZEROS
     C                   MOVE      SSEC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 7 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO07 <> *ZEROS
     C                   MOVE      SMIO07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB07 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO07
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB07 <> *ZEROS
     C                   MOVE      SMIB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC07 = *Zeros and SEOC07 = *Zeros
     C                             and SMIO07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 7 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC07
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC07 <> *ZEROS
     C                   MOVE      SMAC07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO07 >  SMAC07 and SMIO07 <> 0 and +
     C                                       SMAC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC07 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB07 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC07
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB07 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB07 <> *ZEROS
     C                   MOVE      SMAB07        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC07 = *Zeros and SEOC07 = *Zeros
     C                             and SMAC07 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 8
 
      * Range 8 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC08 <> *ZEROS
     C                   MOVE      SABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
 
      * Range 8 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC08 <> *ZEROS
     C                   MOVE      EABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC08 >= EABC08 and SABC08 <> 0
     C                             and EABC08 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC08 <> EABC07 + #Diff1 and SABC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC08 = 0 and EABC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC08 = *Zeros and EABC08 = *Zeros
     C                             and PMBC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 8 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC08 <> *ZEROS
     C                   MOVE      MIBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC08 = *Zeros and EABC08 = *Zeros
     C                             and MIBC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 8 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC08 <> *ZEROS
     C                   MOVE      MXBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC08 > MXBC08 and MIBC08 <> 0 and +
     C                                      MXBC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC08 = *Zeros and EABC08 = *Zeros
     C                             and MXBC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 8 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE08 <> *ZEROS
     C                   MOVE      RATE08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE08 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 8 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC08 <> *ZEROS
     C                   MOVE      PMBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC08 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC08 = *Zeros and EABC08 = *Zeros
     C                             and RATE08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 8 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 8 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC08
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC08 <> *ZEROS
     C                   MOVE      STOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC08 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC08 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC08
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC08 <> *ZEROS
     C                   MOVE      SABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 8 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC08
 
     C                   IF        #Manother <> 'Y' and ENOC08 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC08 <> *ZEROS
     C                   MOVE      ENOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC08 >= ENOC08 and STOC08 <> 0
     C                             and ENOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC08 <> ENOC07 + #Diff2 and STOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC08 = 0 and ENOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC08 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC08
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC08 <> *ZEROS
     C                   MOVE      EABC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 8 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC08 <> *ZEROS
     C                   MOVE      MIOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC08 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC08
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC08 <> *ZEROS
     C                   MOVE      MIBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC08 = *Zeros and ENOC08 = *Zeros
     C                             and MIOC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 8 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC08 <> *ZEROS
     C                   MOVE      MAOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC08 >  MAOC08 and MIOC08 <> 0 and +
     C                                       MAOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC08 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC08
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC08 <> *ZEROS
     C                   MOVE      MXBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC08 = *Zeros and ENOC08 = *Zeros
     C                             and MAOC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 8 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC08 <> *ZEROS
     C                   MOVE      SSBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 8 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC08 <> *ZEROS
     C                   MOVE      SSEC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC08 >= SSEC08 and SSBC08 <> 0
     C                             and SSEC08 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC08 <> SSEC07 + #Diff1 and SSBC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC08 = 0 and SSEC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC08 = *Zeros and SSEC08 = *Zeros
     C                             and SPMB08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 8 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB08 <> *ZEROS
     C                   MOVE      SMIB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC08 = *Zeros and SSEC08 = *Zeros
     C                             and SMIB08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 8 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB08 <> *ZEROS
     C                   MOVE      SMAB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB08 >  SMAB08 and SMIB08 <> 0 and +
     C                                       SMAB08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC08 = *Zeros and SSEC08 = *Zeros
     C                             and SMAB08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 8 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT08 <> *ZEROS
     C                   MOVE      SRAT08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT08 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 8 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB08 <> *ZEROS
     C                   MOVE      SPMB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB08 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC08 = *Zeros and SSEC08 = *Zeros
     C                             and SRAT08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 8 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 8 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC08
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC08 <> *ZEROS
     C                   MOVE      SSOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC08 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC08 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC08
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC08 <> *ZEROS
     C                   MOVE      SSBC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 8 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC08
 
     C                   IF        #Stpother <> 'Y' and SEOC08 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC08 <> *ZEROS
     C                   MOVE      SEOC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC08 >= SEOC08 and SSOC08 <> 0
     C                             and SEOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC08 <> SEOC07 + #Diff2 and SSOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC08 = 0 and SEOC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC08 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC08
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC08 <> *ZEROS
     C                   MOVE      SSEC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 8 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO08 <> *ZEROS
     C                   MOVE      SMIO08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB08 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO08
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB08 <> *ZEROS
     C                   MOVE      SMIB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC08 = *Zeros and SEOC08 = *Zeros
     C                             and SMIO08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 8 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC08
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC08 <> *ZEROS
     C                   MOVE      SMAC08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO08 >  SMAC08 and SMIO08 <> 0 and +
     C                                       SMAC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC08 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB08 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC08
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB08 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB08 <> *ZEROS
     C                   MOVE      SMAB08        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC08 = *Zeros and SEOC08 = *Zeros
     C                             and SMAC08 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 9
 
      * Range 9 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC09 <> *ZEROS
     C                   MOVE      SABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 9 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC09 <> *ZEROS
     C                   MOVE      EABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC09 >= EABC09 and SABC09 <> 0
     C                             and EABC09 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC09 <> EABC08 + #Diff1 and SABC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC09 = 0 and EABC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC09 = *Zeros and EABC09 = *Zeros
     C                             and PMBC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 9 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC09 <> *ZEROS
     C                   MOVE      MIBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC09 = *Zeros and EABC09 = *Zeros
     C                             and MIBC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 9 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC09 <> *ZEROS
     C                   MOVE      MXBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC09 > MXBC09 and MIBC09 <> 0 and +
     C                                      MXBC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC09 = *Zeros and EABC09 = *Zeros
     C                             and MXBC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 9 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE09 <> *ZEROS
     C                   MOVE      RATE09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE09 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 9 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC09 <> *ZEROS
     C                   MOVE      PMBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC09 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC09 = *Zeros and EABC09 = *Zeros
     C                             and RATE09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 9 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 9 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC09
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC09 <> *ZEROS
     C                   MOVE      STOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC09 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC09 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC09
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC09 <> *ZEROS
     C                   MOVE      SABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 9 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC09
 
     C                   IF        #Manother <> 'Y' and ENOC09 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC09 <> *ZEROS
     C                   MOVE      ENOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC09 >= ENOC09 and STOC09 <> 0
     C                             and ENOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC09 <> ENOC08 + #Diff2 and STOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC09 = 0 and ENOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC09 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC09
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC09 <> *ZEROS
     C                   MOVE      EABC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 9 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC09 <> *ZEROS
     C                   MOVE      MIOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC09 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC09
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC09 <> *ZEROS
     C                   MOVE      MIBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minumum charge should not be allowed.
 
     C                   IF        STOC09 = *Zeros and ENOC09 = *Zeros
     C                             and MIOC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 9 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC09 <> *ZEROS
     C                   MOVE      MAOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC09 >  MAOC09 and MIOC09 <> 0 and +
     C                                       MAOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC09 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC09
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC09 <> *ZEROS
     C                   MOVE      MXBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maxumum charge should not be allowed.
 
     C                   IF        STOC09 = *Zeros and ENOC09 = *Zeros
     C                             and MAOC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 9 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC09 <> *ZEROS
     C                   MOVE      SSBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 9 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC09 <> *ZEROS
     C                   MOVE      SSEC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC09 >= SSEC09 and SSBC09 <> 0
     C                             and SSEC09 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC09 <> SSEC08 + #Diff1 and SSBC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC09 = 0 and SSEC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC09 = *Zeros and SSEC09 = *Zeros
     C                             and SPMB09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 9 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB09 <> *ZEROS
     C                   MOVE      SMIB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC09 = *Zeros and SSEC09 = *Zeros
     C                             and SMIB09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 9 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB09 <> *ZEROS
     C                   MOVE      SMAB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB09 >  SMAB09 and SMIB09 <> 0 and +
     C                                       SMAB09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC09 = *Zeros and SSEC09 = *Zeros
     C                             and SMAB09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 9 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT09 <> *ZEROS
     C                   MOVE      SRAT09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT09 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 9 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB09 <> *ZEROS
     C                   MOVE      SPMB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB09 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC09 = *Zeros and SSEC09 = *Zeros
     C                             and SRAT09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 9 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 9 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC09
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC09 <> *ZEROS
     C                   MOVE      SSOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC09 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC09 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC09
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC09 <> *ZEROS
     C                   MOVE      SSBC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 9 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC09
 
     C                   IF        #Stpother <> 'Y' and SEOC09 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC09 <> *ZEROS
     C                   MOVE      SEOC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC09 >= SEOC09 and SSOC09 <> 0
     C                             and SEOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC09 <> SEOC08 + #Diff2 and SSOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC09 = 0 and SEOC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC09 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC09
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC09 <> *ZEROS
     C                   MOVE      SSEC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 9 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO09 <> *ZEROS
     C                   MOVE      SMIO09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB09 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO09
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB09 <> *ZEROS
     C                   MOVE      SMIB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC09 = *Zeros and SEOC09 = *Zeros
     C                             and SMIO09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 9 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC09
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC09 <> *ZEROS
     C                   MOVE      SMAC09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO09 >  SMAC09 and SMIO09 <> 0 and +
     C                                       SMAC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC09 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB09 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC09
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB09 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB09 <> *ZEROS
     C                   MOVE      SMAB09        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC09 = *Zeros and SEOC09 = *Zeros
     C                             and SMAC09 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 10
 
      * Range 10 - manual base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SABC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC10 <> *ZEROS
     C                   MOVE      SABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - manual base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        EABC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC10 <> *ZEROS
     C                   MOVE      EABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   IF        SABC10 >= EABC10 and SABC10 <> 0
     C                             and EABC10 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In57 = *On
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SABC10 <> EABC09 + #Diff1 and SABC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ELSE
     C                   IF        SABC10 = 0 and EABC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In56 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SABC10 = *Zeros and EABC10 = *Zeros
     C                             and PMBC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 10 - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIBC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC10 <> *ZEROS
     C                   MOVE      MIBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SABC10 = *Zeros and EABC10 = *Zeros
     C                             and MIBC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range 10 - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MXBC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC10 <> *ZEROS
     C                   MOVE      MXBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        MIBC10 > MXBC10 and MIBC10 <> 0 and +
     C                                      MXBC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SABC10 = *Zeros and EABC10 = *Zeros
     C                             and MXBC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range 10 - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        RATE10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        RATE10 <> *ZEROS
     C                   MOVE      RATE10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase <> 'Y' and #Pmbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and RATE10 <> 0
     C                   EVAL      #Rtbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and RATE10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range 10 - manual base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        PMBC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        PMBC10 <> *ZEROS
     C                   MOVE      PMBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmbase <> 'Y' and #Rtbase <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and PMBC10 <> 0
     C                   EVAL      #Pmbase = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and PMBC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SABC10 = *Zeros and EABC10 = *Zeros
     C                             and RATE10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
      * Range 10 - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
      * Range 10 - manual other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        STOC10
 
     C                   IF        #Manother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        STOC10 <> *ZEROS
     C                   MOVE      STOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST2
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST2
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        ENOC01 <> *ZEROS AND
     C                             SABC10 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        STOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In63 = *Off and SABC10 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = STOC10
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In63 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SABC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SABC10 <> *ZEROS
     C                   MOVE      SABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - manual other range end
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ENOC10
 
     C                   IF        #Manother <> 'Y' and ENOC10 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In64 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        ENOC10 <> *ZEROS
     C                   MOVE      ENOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN2
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN2
     C                   ENDIF
 
     C                   IF        STOC10 >= ENOC10 and STOC10 <> 0
     C                             and ENOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   EVAL      *In64 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        STOC10 <> ENOC09 + #Diff2 and STOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ELSE
     C                   IF        STOC10 = 0 and ENOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In63 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In64 = *Off and EABC10 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = ENOC10
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In64 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      EABC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        EABC10 <> *ZEROS
     C                   MOVE      EABC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN1
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - manual other minimum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MIOC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MIOC10 <> *ZEROS
     C                   MOVE      MIOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MIOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and MIBC10 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MIOC10
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MIBC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MIBC10 <> *ZEROS
     C                   MOVE      MIBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        STOC10 = *Zeros and ENOC10 = *Zeros
     C                             and MIOC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range 10 - manual other maximum charge
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAOC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        MAOC10 <> *ZEROS
     C                   MOVE      MAOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        MIOC10 >  MAOC10 and MIOC10 <> 0 and +
     C                                       MAOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and MAOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and MXBC10 = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = MAOC10
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      MXBC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        MXBC10 <> *ZEROS
     C                   MOVE      MXBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        STOC10 = *Zeros and ENOC10 = *Zeros
     C                             and MAOC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range 10 - STP    base range start
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSBC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC10 <> *ZEROS
     C                   MOVE      SSBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - STP    base range end
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSEC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In69 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC10 <> *ZEROS
     C                   MOVE      SSEC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   IF        SSBC10 >= SSEC10 and SSBC10 <> 0
     C                             and SSEC10 > 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   EVAL      *In69 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSBC10 <> SSEC09 + #Diff1 and SSBC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ELSE
     C                   IF        SSBC10 = 0 and SSEC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In68 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the pro mile should not be allowed.
 
     C                   IF        SSBC10 = *Zeros and SSEC10 = *Zeros
     C                             and SPMB10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3285'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 10 - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIB10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB10 <> *ZEROS
     C                   MOVE      SMIB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSBC10 = *Zeros and SSEC10 = *Zeros
     C                             and SMIB10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range 10 - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAB10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB10 <> *ZEROS
     C                   MOVE      SMAB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SMIB10 >  SMAB10 and SMIB10 <> 0 and +
     C                                       SMAB10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSBC10 = *Zeros and SSEC10 = *Zeros
     C                             and SMAB10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range 10 - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SRAT10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SRAT10 <> *ZEROS
     C                   MOVE      SRAT10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp <> 'Y' and #Pmstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SRAT10 <> 0
     C                   EVAL      #Rtstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SRAT10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range 10 - STP    base range pro mile
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SPMB10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SPMB10 <> *ZEROS
     C                   MOVE      SPMB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Pmstp <> 'Y' and #Rtstp <> 'Y'
     C                   IF        ZALIGNOK = 'Y' and SPMB10 <> 0
     C                   EVAL      #Pmstp = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #Rtstp = 'Y' and SPMB10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the range rate should not be allowed.
 
     C                   IF        SSBC10 = *Zeros and SSEC10 = *Zeros
     C                             and SRAT10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3284'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
      * Range 10 - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range 10 - STP    other range start
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRST4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SSOC10
 
     C                   IF        #Stpother = 'Y'
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SSOC10 <> *ZEROS
     C                   MOVE      SSOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST4
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST4
      *
      ** If range 1 tier is entered for other ccy, and the base ccy tier is
      ** entered for this range, other ccy tier must be entered
      *
     C                   IF        SEOC01 <> *ZEROS AND
     C                             SSBC10 <> *ZEROS
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3220'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        SSOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In75 = *Off and SSBC10 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SSOC10
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In75 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSBC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSBC10 <> *ZEROS
     C                   MOVE      SSBC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRST3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRST3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - STP    other range end
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCREN4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SEOC10
 
     C                   IF        #Stpother <> 'Y' and SEOC10 <> 0
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ENDIF
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In76 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SEOC10 <> *ZEROS
     C                   MOVE      SEOC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN4
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN4
     C                   ENDIF
 
     C                   IF        SSOC10 >= SEOC10 and SSOC10 <> 0
     C                             and SEOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1012'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   EVAL      *In76 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ZALIGNOK = 'Y'
     C                   IF        SSOC10 <> SEOC09 + #Diff2 and SSOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ELSE
     C                   IF        SSOC10 = 0 and SEOC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1015'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In75 = *On
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *In76 = *Off and SSEC10 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SEOC10
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In76 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SSEC10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SSEC10 <> *ZEROS
     C                   MOVE      SSEC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCREN3
     C                   ELSE
     C                   MOVE      *BLANKS       SCREN3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      * Range 10 - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMIO10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMIO10 <> *ZEROS
     C                   MOVE      SMIO10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMIO10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SMIB10 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMIO10
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMIB10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMIB10 <> *ZEROS
     C                   MOVE      SMIB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the minimum charge should not be allowed.
 
     C                   IF        SSOC10 = *Zeros and SEOC10 = *Zeros
     C                             and SMIO10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3282'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range 10 - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SMAC10
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SMAC10 <> *ZEROS
     C                   MOVE      SMAC10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SMIO10 >  SMAC10 and SMIO10 <> 0 and +
     C                                       SMAC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SMAC10 <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'                               2
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SMAB10 = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SMAC10
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SMAB10 = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SMAB10 <> *ZEROS
     C                   MOVE      SMAB10        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
      ** Check that the range start value is not zero - if it is, then
      ** a value for the maximum charge should not be allowed.
 
     C                   IF        SSOC10 = *Zeros and SEOC10 = *Zeros
     C                             and SMAC10 <> *Zeros
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3283'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   WHEN      #C2 = 11
 
      * Work out if Out of band is allowed - only if range end has
      * been entered.
 
     C                   EXSR      OBALLOWED
 
      * OUT OF BAND ===============================================
      * Range OB - manual base range pro mile
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
 
      * Range OB - manual base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        OMIBC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        OMIBC <> *ZEROS
     C                   MOVE      OMIBC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OMIBC <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
     C                   IF        OMIBC <> 0 and BasManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   ENDIF
 
      * Range OB - manual base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        OMABC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        OMABC <> *ZEROS
     C                   MOVE      OMABC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   IF        OMIBC >  OMABC and OMIBC <> 0 and +
     C                                      OMABC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In60 = *On
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
     C                   IF        OMABC <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OMABC <> 0 and BasManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In61 = *On
     C                   ENDIF
 
      * Range OB - manual base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        ORBC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        ORBC <> *ZEROS
     C                   MOVE      ORBC          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT1
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ORBC <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
     C                   IF        OPMAB <> 0 and ORBC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
     C                   IF        ORBC <> 0 and BasManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   ENDIF
 
     C                   IF        #Pmbase = 'Y' and ORBC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
 
 
      * Pro-Mile
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM1        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        OPMAB
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        OPMAB <> *ZEROS
     C                   MOVE      OPMAB         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM1
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        OPMAB <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
     C                   IF        OPMAB <> 0 and BasManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
     C                   IF        #Rtbase = 'Y' and OPMAB <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In58 = *On
     C                   EVAL      *In59 = *On
     C                   ENDIF
 
      * Range OB - manual other currency
 
     C                   EVAL      SCCCY2 =  W#OthCcy
 
     C                   IF        SCCCY2 <> *blanks and SCCCY2 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In62 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy2 = #ccya
     C                   EVAL      OTHCCY = SCCCY2
     C                   ENDIF
 
 
      * Range OB - manual other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        OMIOC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        OMIOC <> *ZEROS
     C                   MOVE      OMIOC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and OMIOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        OMIOC <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
     C                   IF        *In66 = *Off and OMIBC = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = OMIOC
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In66 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      OMIBC = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        OMIBC <> *ZEROS
     C                   MOVE      OMIBC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OMIOC <> 0 and OthManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   ENDIF
 
      * Range OB - manual other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   IF        SCCCY2 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC2        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        OMAOC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY2
     C                   EXSR      DECIMALS
     C                   IF        OMAOC <> *ZEROS
     C                   MOVE      OMAOC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC2
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC2
     C                   ENDIF
     C                   IF        OMIOC >  OMAOC and OMIOC <> 0 and +
     C                                      OMAOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In66 = *On
     C                   EVAL      *In67 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY2 = *blanks and OMAOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        OMAOC <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
     C                   IF        *In67 = *Off and OMABC = 0
     C                   IF        *In62 = *Off and SCCCY2 <> *blanks
 
     C                   EVAL      INPAMT = OMAOC
     C                   EVAL      FRMCCY = SCCCY2
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In67 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      OMABC = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        OMABC <> *ZEROS
     C                   MOVE      OMABC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC1
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC1
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OMAOC <> 0 and OthManOB <> 'Y'
     C                             and CALCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In67 = *On
     C                   ENDIF
 
      * Range OB - STP    base range pro mile
 
     C                   EVAL      ZADEC = #Basdec
     C                   EVAL      ZADIG = #basint
 
 
 
     C                   IF        #Rtstp = 'Y' and SOPMAB <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
     C                   IF        SOPMAB <> 0 and CALCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
     C                   IF        SOPMAB <> 0 and STPBasOb    <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      * Range OB - STP    base minimum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SOMIBC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SOMIBC <> *ZEROS
     C                   MOVE      SOMIBC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SOMIBC <> 0 and STPCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
     C                   IF        SOMIBC <> 0 and STPBasOb    <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   ENDIF
 
      * Range OB - STP    base maximum charge
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SOMABC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SOMABC <> *ZEROS
     C                   MOVE      SOMABC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   IF        SOMIBC >  SOMABC and SOMIBC <> 0 and +
     C                                       SOMABC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In72 = *On
     C                   EVAL      *In73 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SOMABC <> 0 and STPCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
     C                   IF        SOMABC <> 0 and STPBasOb    <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In73 = *On
     C                   ENDIF
 
      * Range OB - STP    base range rate
 
     C                   EVAL      ZADEC = 8
     C                   EVAL      ZADIG = 5
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRRT3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SORBC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ELSE
     C                   EVAL      A6NBDP = 8
     C                   IF        SORBC <> *ZEROS
     C                   MOVE      SORBC         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRRT3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRRT3
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SORBC <> 0 and STPCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
     C                   IF        SOPMAB <> 0 and SORBC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
     C                   IF        SORBC <> 0 and STPBasOb    <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   ENDIF
 
     C                   IF        #Pmstp = 'Y' and SORBC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1013'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In70 = *On
     C                   EVAL      *In71 = *On
     C                   ENDIF
 
      ** Pro-Mile
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCRPM3        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SOPMAB
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In71 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  #Basccy
     C                   EVAL      A6NBDP = 8
 
     C                   IF        SOPMAB <> *ZEROS
     C                   MOVE      SOPMAB        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCRPM3
     C                   ELSE
     C                   MOVE      *BLANKS       SCRPM3
     C                   ENDIF
     C                   ENDIF
 
      * Range OB - STP    other currency
 
     C                   EVAL      SCCCY4 = SCCCY2
 
     C                   IF        SCCCY4 <> *blanks and SCCCY4 <> OTHCCY
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1017'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In74 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      #Dec = A6NBDP
     C                   EVAL      #Int = 13 - #Dec
     C                   EVAL      ZADEC = #Dec
     C                   EVAL      ZADIG = #Int
     C                   EVAL      Scccy4 = #ccya
     C                   EVAL      OTHCCY = SCCCY4
     C                   ENDIF
 
      * Range OB - STP    other minimum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMIC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SOMIOC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SOMIOC <> *ZEROS
     C                   MOVE      SOMIOC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC4
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SOMIOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        SOMIOC <> 0 and STPCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
     C                   IF        *In78 = *Off and SOMIBC = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SOMIOC
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In78 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SOMIBC = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SOMIBC <> *ZEROS
     C                   MOVE      SOMIBC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMIC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMIC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SOMIOC <> 0 and STPOthOB <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   ENDIF
 
      * Range OB - STP    other maximum charge
 
     C                   IF        SCCCY4 <> *blanks
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   EVAL      ZADEC = A6NBDP
     C                   ENDIF
 
     C                   EVAL      ZFIELD = *blanks
     C                   MOVE      SCMAC4        ZFIELD
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        SOMAOC
 
     C                   IF        ZALIGNOK <> 'Y'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1011'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ELSE
     C                   EVAL      #Ccya  =  SCCCY4
     C                   EXSR      DECIMALS
     C                   IF        SOMAOC <> *ZEROS
     C                   MOVE      SOMAOC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC4
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC4
     C                   ENDIF
     C                   IF        SOMIOC > SOMAOC and SOMIOC <> 0 and +
     C                                      SOMAOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1014'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In78 = *On
     C                   EVAL      *In79 = *On
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SCCCY4 = *blanks and SOMAOC <> 0
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF3170'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        SOMAOC <> 0 and STPCMD <> 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1019'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   IF        *In79 = *Off and SOMABC = 0
     C                   IF        *In74 = *Off and SCCCY4 <> *blanks
 
     C                   EVAL      INPAMT = SOMAOC
     C                   EVAL      FRMCCY = SCCCY4
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   IF        OUTAMT > 9999999999999                                     251529
     C                   MoveL     OUTAMT        MsgDta                                       251529
     C                   EVAL      Msgid = 'FTF1026'                                          251529
     C                   EXSR      SNDMSG                                                     251529
     C                   EVAL      #Adderr = 'Y'                                              251529
     C                   EVAL      #Amenderr = 'Y'                                            251529
     C                   EVAL      *In79 = *On                                                251529
     C                   ELSE                                                                 251529
     C                   EVAL      SOMABC = OUTAMT
     C                   EVAL      #Ccya  =  #Basccy
     C                   EXSR      DECIMALS
     C                   IF        SOMABC <> *ZEROS
     C                   MOVE      SOMABC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SCMAC3
     C                   ELSE
     C                   MOVE      *BLANKS       SCMAC3
     C                   ENDIF
     C                   ENDIF                                                                251529
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SOMAOC <> 0 and STPOthOB <> 'Y'
     C                             and STPCMD = 'H'
     C                   EVAL      MsgDta = SflSl1
     C                   EVAL      Msgid = 'FTF1020'
     C                   EXSR      SNDMSG
     C                   EVAL      #Adderr = 'Y'
     C                   EVAL      #Amenderr = 'Y'
     C                   EVAL      *In79 = *On
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        #Amenderr = 'Y' or #Adderr = 'Y'
     C                   IF        #Sf2pos = *blanks
     C                   EVAL      Sfpos2 = #C2
     C                   EVAL      #Sf2pos = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   UPDATE    Sfl321s2
 
     C                   ENDDO
 
     C                   IF        #Act = 'I'
     C                   EVAL      #Amenderr = *blanks
     C                   ELSE
     C                   EVAL      #Adderr = *blanks
     C                   ENDIF
 
     C                   IF        #Adderr <> 'Y'
     C                   EVAL      #Addok = 'Y'
     C                   ENDIF
 
     C                   IF        #Amenderr <> 'Y'
     C                   EVAL      #Amendok = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * DECIMALS - Get number of decimal places for currency          *
      *                                                               *
      * Called by: MOVFIL *INZSR                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ********
     C     DECIMALS      BEGSR
      *    ********
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       #RTCD
     C                   PARM      '*KEY   '     #OPTN
     C                   PARM                    #ccyA
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * If #RTCD = *NRF then set decimals to 0 for screen formatting.
     C                   IF        #RTCD = '*NRF   '
     C                   EVAL      A6NBDP = 0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * ZEDIT   - Use ZEDIT routine                                   *
      *                                                               *
      * Called by: MOVFIL VALIDATE                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     ZEDIT         BEGSR
      *    *******
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
 
     C                   ENDSR
 
 
      *****************************************************************
      *                                                               *
      * ZALIGN  - Use ZALIGN routine                                  *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     ZALIGN        BEGSR
      *    ******
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * GETBAS - Get base ccy amount                                  *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETBAS        BEGSR
 
      *
      * Calculate base currency equivalent
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      FRMCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
      *
     C     *LIKE         DEFINE    A6NBDP        BASDEC
     C                   MOVEL     A6NBDP        BASDEC
     C     *LIKE         DEFINE    A6MDIN        BASMD
     C                   MOVEL     A6MDIN        BASMD
     C     *LIKE         DEFINE    A6SPRT        CVTRAT
     C                   MOVEL     A6SPRT        CVTRAT
      *
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TOCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
      *
     C     *like         DEFINE    A6NBDP        TODEC
     C                   MOVEL     A6NBDP        TODEC
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    INPAMT           15 0
     C                   PARM                    CVTRAT
     C                   PARM                    BASMD
     C                   PARM                    FRMCCY            3
     C                   PARM                    TOCCY             3
     C                   PARM                    BASDEC
     C                   PARM                    TODEC
     C/COPY OFCPYSRCZ,CFT147_046                                                              259785
     C                   PARM      *ZEROS        OUTAMT           15 0
     C/COPY OFCPYSRCZ,CFT147_019                                                              CFT147
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * OBALLOWED - OB only allowed if range end entered              *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    *********
     C     OBALLOWED     BEGSR
      *    *********
 
      * Manual Base
     C                   EVAL      BasManOB = 'Y'
      * Manual Other
     C                   EVAL      OthManOB = 'Y'
      * STP Base
     C                   EVAL      STPBasOb    = 'Y'
      * STP other
     C                   EVAL      STPOthOb    = 'Y'
 
     C                   DO        10            #C3
 
     C                   SELECT
 
     C                   WHEN      #C3 = 1
     C                   IF        EABC01 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        ENOC01 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSEC01 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SEOC01 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 2
     C                   IF        SABC02 <> 0 and EABC02 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC02 <> 0 and ENOC02 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC02 <> 0 and SSEC02 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC02 <> 0 and SEOC02 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 3
     C                   IF        SABC03 <> 0 and EABC03 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC03 <> 0 and ENOC03 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC03 <> 0 and SSEC03 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC03 <> 0 and SEOC03 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 4
     C                   IF        SABC04 <> 0 and EABC04 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC04 <> 0 and ENOC04 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC04 <> 0 and SSEC04 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC04 <> 0 and SEOC04 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 5
     C                   IF        SABC05 <> 0 and EABC05 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC05 <> 0 and ENOC05 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC05 <> 0 and SSEC05 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC05 <> 0 and SEOC05 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 6
     C                   IF        SABC06 <> 0 and EABC06 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC06 <> 0 and ENOC06 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC06 <> 0 and SSEC06 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC06 <> 0 and SEOC06 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 7
     C                   IF        SABC07 <> 0 and EABC07 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC07 <> 0 and ENOC07 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC07 <> 0 and SSEC07 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC07 <> 0 and SEOC07 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 8
     C                   IF        SABC08 <> 0 and EABC08 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC08 <> 0 and ENOC08 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC08 <> 0 and SSEC08 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC08 <> 0 and SEOC08 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 9
     C                   IF        SABC09 <> 0 and EABC09 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC09 <> 0 and ENOC09 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC09 <> 0 and SSEC09 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC09 <> 0 and SEOC09 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   WHEN      #C3 = 10
     C                   IF        SABC10 <> 0 and EABC10 = 0
     C                   EVAL      BasManOB = 'N'
     C                   ENDIF
     C                   IF        STOC10 <> 0 and ENOC10 = 0
     C                   EVAL      OthManOB = 'N'
     C                   ENDIF
     C                   IF        SSBC10 <> 0 and SSEC10 = 0
     C                   EVAL      STPBasOb    = 'N'
     C                   ENDIF
     C                   IF        SSOC10 <> 0 and SEOC10 = 0
     C                   EVAL      STPOthOb    = 'N'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * PYSR - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: SNDMSG                                                 *
      *                                                               *
      *****************************************************************
     C     PYSR          BEGSR
     C                   EVAL      PyLocked = 'N'
     C                   IF        PyStatus = Record_Locked
     C     Sfrrn1        CHAIN     Sfl321s1                           96
     C                   EVAL      *In35 = *Off
     C                   EVAL      SFLSL1 = ' '
     C                   UPDATE    Sfl321s1
     C                   EVAL      PyLocked = 'Y'
     C                   EVAL      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   EXSR      SNDMSG
     C                   EVAL      ReturnPt = '*GETIN'
     C                   ENDIF
     C                   ENDSR     ReturnPt
 
      *****************************************************************
      *                                                               *
      * SNDMSG - Send Program Message                                 *
      *                                                               *
      * Called by: PRCSF1 DELREC VALIDATE PYSR                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     SNDMSG        BEGSR
      *    ******
 
      * Only write message if requested
     C                   IF        Msgid <> *Blanks
     C                   CALLB     'AOCREPT'
     C                   PARM                    Msgid
     C                   PARM                    Msgf
     C                   PARM                    MsgLib
     C                   PARM                    MsgDta
     C                   PARM                    MsgRel
     C                   PARM                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   ENDIF
 
      * Reset message Id
 
     C                   RESET                   Msgds
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Initial processing                                 *
      *                                                               *
      * Calls: *PSSR DECIMALS                                         *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     *INZSR        BEGSR
      *    ******
 
     C                   Eval      #WrkSt = PsJobName
     C                   EVAL      #Pgm = PsProcPgm
     C/COPY OFCPYSRCZ,CFT147_047                                                              259785
 
      * Parameter List for FTC0005
     C     P#0005        PLIST
     C                   PARM                    PYCHCD
     C                   PARM      '*ALL '       Code_Type         5
     C                   PARM      *Blank        Del_IN            1
     C                   PARM      *Blank        Del_OT            1
     C                   PARM      *Blank        Del_CP            1
     C                   PARM      *Blank        Del_CC            1
     C                   PARM      *Blank        Del_RF            1
     C                   PARM      *Blank        Del_CT            1
     C                   PARM      *Blank        Del_PC            1
     C                   PARM      *Blank        Error             1
 
      * Access SAR details to see if CFT010 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFT010'      @Sard             6
     C     SCSARD        PARM      SCSARD        Dsfdy
 
      * Database error
 
     C                   IF        @Rtcd <> *BLANKS AND
     C                             @Rtcd <> '*NRF'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = 'CFT010'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @Rtcd = *BLANKS
     C                   MOVEL     'Y'           CFT010            1
     C                   EVAL      *In23 = *on
     C                   ELSE
     C                   MOVEL     'N'           CFT010
     C                   ENDIF
      *
     C/COPY OFCPYSRCZ,CFT147_020                                                              CFT147
 
      * Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ELSE
      * Base currency details
     C                   EVAL      #Ccya  =  BJCYCD
     C                   EXSR      DECIMALS
     C                   EVAL      #Basccy =  BJCYCD
     C                   EVAL      #Basdec = A6NBDP
     C                   EVAL      #Basint = 13 - #Basdec
     C                   EVAL      #Basmd = A6MDIN
     C                   ENDIF
 
     C                   EVAL      #Reload = 'Y'
     C/COPY OFCPYSRCZ,CFT147_021                                                              CFT147
 
      *********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
     C/COPY ZACPYSRC,PSSR_ILE
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
