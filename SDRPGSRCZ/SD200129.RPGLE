     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 7 Screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200129 - Midas SD Network Description Maintenance    *
      *                   (Details 7 Screen - Extended Narrative)     *
      *                                                               *
      *  Function : This module handles the input and the validation  *
      *             of the seventh screen fields of a Network record. *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23654           Date 01Apr09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23654 - No. of lines validation error for UNSD3           *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  Display Conditioning Indicators                              *
      *    01         Allow Use of the F10 Key                        *
      *    02         Display the warning mention '**DELETED**'       *
      *    36         Protect Fields - Prohibit Refresh and Default   *
      *                                                               *
      *  Error Indicators                                             *
      *                                                               *
      *    40         General Error Indicator                         *
      *    41         Field 86 Format                                 *
      *    42         Number of Linese                                *
      *    43         Line Length                                     *
      *    44         Line Separator                                  *
      *    45         Wrap Text                                       *
      *    46         Truncate Lines                                  *
      *    47         Merge Lines                                     *
      *    48         Keep Lines Separator                            *
      *    49         External Extract Program                        *
      *    50         External Formatting Program                     *
      *                                                               *
      *  (The DS IN40_TO_70 is used to cover the whole set of         *
      *  reserved error indicators)                                   *
      *                                                               *
      *  Subfile Management Indicators                                *
      *                                                               *
      *    23         SFLEND (Messages Subfile)                       *
      *                                                               *
      *  Action key Indicators                                        *
      *                                                               *
      *    KC         Exit Program                                    *
      *    KE         Refresh Screen                                  *
      *    KJ         Confirm Deletion                                *
      *    KL         Previous Screen                                 *
      *                                                               *
      *  Database Error Indicators                                    *
      *                                                               *
      *    U7         Abnormal Completion                             *
      *    U8         File Out of Balance                             *
      *    U7 + U8    Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFldDflt - Screen fields Defaulting                         *
      *  SRValidatSc - Validate the screen                            *
      *  SRWindow - Window Processing                                 *
      *  SRInitScreen - Format the screen according to the received   *
      *                action code                                    *
      *  SRClrErrSF - Clear Program Message Queue                     *
      *  SRExitMod - Exit from the module message Queue               *
      *  SRScrToFile - Move fields from the screen to file record     *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Network Details 7 screen Display
      *
     FSD200129DFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** New Network File Record (i.e. new state after amendments)
      *
     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      *
     D ScrLayout     E DS                  EXTNAME(SD200129DF:SD200129F7)
      *
      ** Rundat DS
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D                                     DTAARA(RUNDAT)
      *
     D Data            DS          1024
      *
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1A   DIM(31)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRetCodeOut     S             10A
     D PActCode        S              1A
     D PCallerIn       S             10A
     D PCallerOut      S             10A
      *
     D PKCOut          S              1A
     D PKJOut          S              1A
     D PKLOut          S              1A
      *
     D PWdwPgm         S             10A
     D PWdwKey         S              2A
     D PWdwAction      S              1A
     D PWdwRtcd        S              7A
     D PWdwSpare       S            256A
      *
     D PZaPgm          S             10A
     D PZaPgrl         S              5A
      *
     D PRetCodeIn      S             10A
     D PWdwActCode     S              1A
      *
     D WCpy            S             80A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   DOU       (*INKC = *ON) OR (*INKJ = *ON) OR
     C                             (*INKL = *ON) OR (*IN40 = *OFF)
      *
      ** Display the screen
      *
     C                   WRITE     SD200129H0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD200129F0
     C                   EXFMT     SD200129F7
      *
      ** Clear the program message queue and the error indicators
      *
     C                   EXSR      SRClrErrSf
     C                   MOVEA     *ZEROS        IN40_TO_70
     C                   EVAL      *IN40 = *ZEROS
      *
      ** Action keys management
      ** F3 - Exit program
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PRetcodeout = '*EXIT'
     C                   ITER
     C                   ENDIF
      *
      ** F5 - Refresh the screen
      *
     C                   IF        *INKE = *ON
     C                   EXSR      SRInitScreen
     C                   EVAL      *IN40 = *ON
     C                   ITER
     C                   ENDIF
      *
      ** F10 - Confirm deletion of the record
      *
     C                   IF        *INKJ = *ON
     C                   EVAL      PRetcodeout = '*DLTCONF'
     C                   ITER
     C                   ENDIF
      *
      ** F12 - Return to the previous screen
      *
     C                   IF        *INKL = *ON
     C                   EVAL      PRetcodeout = '*PRV'
     C                   ITER
     C                   ENDIF
      *
      ** Fields Defaulting
      *
     C                   EXSR      SRFldDflt
      *
      ** Validation
      *
     C                   EXSR      SRValidatSc
      *
      ** Window processing if no validation error
      *
     C                   IF        *IN40 = *OFF
     C                   EXSR      SRWindow
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Exit the Module
      *
     C                   EXSR      SRExitMod
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldDflt - Screen fields Defaulting                         *
      *                                                               *
      *  Called by : Main Processing,SRInitScreen                     *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRFldDflt     BEGSR
      *
      ** No defaulting if Delete or Enquire
      *
     C                   IF        PActCode = 'D' OR PActCode = 'E'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Default Field 86 format: 'SWIFT'
      *
     C                   IF        D7F86F = *BLANKS
     C                   EVAL      D7F86F = 'SWIFT'
     C                   ENDIF
      *
      ** Default Number of Lines and Line Length
      *
     C                   SELECT
      *
     C                   WHEN      D7F86F = 'SWIFT'
     C                   IF        D7NOLN = *ZEROS
     C                   EVAL      D7NOLN = 6
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 65
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD0'
     C                   IF        D7NOLN = *ZEROS
     C                   EVAL      D7NOLN = 14
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 27
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD1'
     C                   IF        D7NOLN = *ZEROS
     C                   EVAL      D7NOLN = 6
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 65
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD2'
     C                   IF        D7NOLN = *ZEROS
     C                   EVAL      D7NOLN = 10
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 32
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'UNSD3'
     C                   IF        D7NOLN = *ZEROS
     C**********         EVAL      D7NOLN = 11                                              BUG23654
     C                   EVAL      D7NOLN = 16                                              BUG23654
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 35
     C                   ENDIF
      *
     C                   WHEN      D7F86F = 'STRCT'
     C                   IF        D7NOLN = *ZEROS
     C                   EVAL      D7NOLN = 1
     C                   ENDIF
      *
     C                   IF        D7NCLN = *ZEROS
     C                   EVAL      D7NCLN = 387
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Default Wrap Text: 'N'
      *
     C                   IF        D7WTXT = *BLANKS
     C                   EVAL      D7WTXT = 'N'
     C                   ENDIF
      *
      ** Default Truncate Lines: 'N'
      *
     C                   IF        D7TRLN = *BLANKS
     C                   EVAL      D7TRLN = 'N'
     C                   ENDIF
      *
      ** Default Keep Line separators: 'Y'
      *
     C                   IF        D7KLSP = *BLANKS
     C                   EVAL      D7KLSP = 'Y'
     C                   ENDIF
      *
      ** Default External Extract Program '*NONE'
      *
     C                   IF        D7EXET = *BLANKS
     C                   EVAL      D7EXET = '*NONE'
     C                   ENDIF
      *
      ** Default External Formatting Program:'*NONE'
      *
     C                   IF        D7EXFM = *BLANKS
     C                   EVAL      D7EXFM = '*NONE'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidatSc - Validate the screen                            *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValidatSc   BEGSR
      *
      ** Call the details 7 screen validation module if Amend or Insert
      *
     C                   IF        PActCode = 'I' OR PActCode = 'A'
     C                   CALLB     'SD200149'
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM      PZaPgm        PCallerOut
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
     C                   ENDIF
      *
      ** Set up error indicators
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWindow - Window Processing                                 *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRWindow      BEGSR
      *
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SD200129'    PWdwPgm
     C                   PARM      *BLANKS       PWdwKey
     C                   PARM      PActcode      PWdwActCode
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWdwRtcd
     C                   PARM      *BLANKS       PWdwSpare
      *
      ** If the returncode isn't blank, always issue a roll back
      ** command to cancel the eventual changes made in the window(s),
      ** and set up appropriate action key
      *
     C                   IF        PWdwRtcd <> *BLANKS
     C                   ROLBK
      *
     C                   IF        PWdwRtcd <> 'USR0790'
     C                   EVAL      *INKC = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitScreen - Format the screen according to the received   *
      *                action code                                    *
      *                                                               *
      *  Called by : Main Processing,*INZSR                           *
      *                                                               *
      *  Calls : SRFldDflt                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRInitScreen  BEGSR
      *
      ** Setup the Fields Value
      *
     C                   EVAL      F0NWRK = EDNWRK
     C                   EVAL      D7F86F = EDF86F
     C                   EVAL      D7NOLN = EDNOLN
     C                   EVAL      D7NCLN = EDNCLN
     C                   EVAL      D7LSEP = EDLSEP
     C                   EVAL      D7WTXT = EDWTXT
     C                   EVAL      D7TRLN = EDTRLN
     C                   EVAL      D7MGLN = EDMGLN
     C                   EVAL      D7KLSP = EDKLSP
     C                   EVAL      D7EXET = EDEXET
     C                   EVAL      D7EXFM = EDEXFM
      *
      ** Fields defaulting
      *
     C                   EXSR      SRFldDflt
      *
      ** Protect Fields or not
      *
     C                   IF        PActcode = 'I' OR PActcode = 'A'
     C                   EVAL      *IN36 = *OFF
     C                   ELSE
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
      ** Allow F10 Key
      *
     C                   IF        PActCode = 'D'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
      *
      ** Display the warning mention '**Deleted**'
      *
     C                   IF        EDTYLC = 'D'
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrErrSF - Clear Program Message Queue                     *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRClrErrSF    BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    PZaPgm
     C                   PARM                    PZaPgrl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExitMod - Exit from the module                             *
      *                                                               *
      *  Called by : Main Processing,*INZSR,*PSSR                     *
      *                                                               *
      *  Calls : SRScrToFile                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRExitMod     BEGSR
      *
      ** Set up the file record layout to be returned if all's right
      ** and the current action is Insert or Amend
      *
     C                   IF        PRetCodeOut = *BLANKS OR
     C                             (PActcode = 'I' OR PActcode = 'A')
     C                   EXSR      SRScrToFile
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrToFile - Move fields from the screen to file record     *
      *                                                               *
      *  Called by : SRExitMod                                        *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRScrToFile   BEGSR
      *
     C                   EVAL      EDF86F = D7F86F
     C                   EVAL      EDNOLN = D7NOLN
     C                   EVAL      EDNCLN = D7NCLN
     C                   EVAL      EDLSEP = D7LSEP
     C                   EVAL      EDWTXT = D7WTXT
     C                   EVAL      EDTRLN = D7TRLN
     C                   EVAL      EDMGLN = D7MGLN
     C                   EVAL      EDKLSP = D7KLSP
     C                   EVAL      EDEXET = D7EXET
     C                   EVAL      EDEXFM = D7EXFM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : SRExitMod                                            *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeOut
     C                   PARM                    PActCode
     C                   PARM                    PCallerIn
     C                   PARM      *INKC         PKCOut
     C                   PARM      *INKJ         PKJOut
     C     *INKL         PARM      *INKL         PKLOut
     C                   PARM                    NewFilRcd
      *
      ** Initialize Copyright Array
      *
     C                   MOVEA     CPY@          WCpy
      *
      ** If No named caller,setup ZAPGM with the current program name
      *
     C                   IF        PCallerIn = *BLANKS
     C                   EVAL      ZAPGM = PSProcPgm
     C                   ELSE
     C                   EVAL      ZAPGM = PCallerIn
     C                   ENDIF
      *
     C                   EVAL      PZaPgm = ZAPGM
     C                   EVAL      PZaPgrl = '*SAME'
      *
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
      *
      ** Format the screen according to the received action code
      *
     C                   EXSR      SRInitScreen
      *
      ** Clear the return code
      *
     C                   EVAL      PRetCodeOut = *BLANKS
      *
      ** Process of screen7 will be done only when Extended Narrative
      ** flag is set to 'Y'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by : (**calling routines**)                           *
      *                                                               *
      *  Calls : SRExitMod                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   EVAL      PRetCodeOut = '*ERROR'
     C                   EXSR      SRExitMod
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
