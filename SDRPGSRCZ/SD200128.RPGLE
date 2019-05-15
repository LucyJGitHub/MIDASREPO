     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 8 Screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200128 - Midas SD Network Description Maintenance    *
      *                   (Details 8 Screen - Multicash Network)      *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the eighth screen fields of a Network record.  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG22654           Date 04Feb09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22654 - Incorrect spelling of multicash (Recompile)       *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Display Conditioning Indicators                              *
      *    01         Allow Use of the F10 Key                        *
      *    02         Display the warning message '**DELETED**'       *
      *    36         Protect Fields - Prohibit Refresh and Default   *
      *                                                               *
      *  Error Indicators                                             *
      *                                                               *
      *    40         General Error Indicator                         *
      *    41         GVC Default Value - Debit                       *
      *    42         GVC Default Value - Credit                      *
      *    43         Field Separator                                 *
      *    44         Fixed Transaction Ref No.                       *
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
      *  SRValidatSc - Validate the screen                            *
      *  SRWindow - Window Processing                                 *
      *  SRIniScreen - Format the screen according to the receive     *
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
      ** Midas SD Network Details 8 screen Display
      *
     FSD200128DFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
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
     D ScrLayout     E DS                  EXTNAME(SD200128DF:SD200128F8)
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
     D PKCOut          S              1A
     D PKJOut          S              1A
     D PKLOut          S              1A
     D PWdwPgm         S             10A
     D PWdwKey         S              2A
     D PWdwAction      S              1A
     D PWdwRtcd        S              7A
     D PWdwSpare       S            256A
     D PZaPgm          S             10A
     D PZaPgrl         S              5A
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
     C                   DOU       (*INKC = *ON) OR (*INKJ = *ON ) OR
     C                             (*INKL = *ON) OR (*IN40 = *OFF)
      *
      ** Display the screen
      *
     C                   WRITE     SD200128H0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD200128F0
     C                   EXFMT     SD200128F8
      *
      ** Clear the program message queue and the error indicators
      *
     C                   EXSR      SRClrErrSF
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
     C                   EXSR      SRIniScreen
     C                   EVAL      *IN40 = *ON
     C                   ITER
     C                   ENDIF
      *
      ** F10 - Confirm Deletion of the record
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
      ** Call the details 8 screen validation module if Amend or Insert
      *
     C                   IF        PActCode = 'I' OR PActCode = 'A'
     C                   CALLB     'SD200148'
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
     C                   PARM      'SD200128'    PWdwPgm
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
      *  SRIniScreen - Format the screen according to the received    *
      *                action code                                    *
      *                                                               *
      *  Called by : Main Processing,*INZSR                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRIniScreen   BEGSR
      *
      ** Setup the Fields Value
      *
     C                   EVAL      F0NWRK = EDNWRK
     C                   EVAL      D8GVCD = EDGVCD
     C                   EVAL      D8GVCC = EDGVCC
     C                   EVAL      D8FSEP = EDFSEP
     C                   EVAL      D8FTRN = EDFXTR
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
      ** Display the warning message '**Deleted**'
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
     C                   IF        PRetCodeOut = *BLANKS AND
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
     C                   EVAL      EDGVCD = D8GVCD
     C                   EVAL      EDGVCC = D8GVCC
     C                   EVAL      EDFSEP = D8FSEP
     C                   EVAL      EDFXTR = D8FTRN
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
     C                   EXSR      SRIniScreen
      *
      ** Clear the return code
      *
     C                   EVAL      PRetCodeOut = *BLANKS
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
