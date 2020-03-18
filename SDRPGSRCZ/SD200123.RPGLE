     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 3 Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200123 - Midas SD Network Description Maintenance    *
      *                   (Details 3 Screen Display - MT941)          *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the third screen of fields of a Network record.*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL178             Date 04Aug16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.       *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL178 - Generate MT942 based on MT950.                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNW94L0  UF   E           K DISK    INFSR(*PSSR) COMMIT
      ** Midas GL Network Accounts - MT94x
      *

     FSD200123DFCF   E             WORKSTN
      ** Midas SD Networks Details 3 Screen Display
      *

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Display Conditioning Indicators                                        *
      *                                                                        *
      * 01 - Allow Use of the F10 Key                                          *
      * 02 - Display the warning mention '**DELETED**'                         *
      * 36 - Protect Fields - Prohibit Refresh and Default                     *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Allow MT941 Generation on Manual Request                          *
      * 42 - Default Message Status for Manual Request                         *
      * 43 - Allow MT941 Generation on Schedule                                *
      * 44 - Default Message Status for Schedule                               *
      * 45 - Allow MT941 Generation on External Request                        *
      * 46 - Default Message Status for External Request                       *
      * 47 - MT941 Maximum Message Length                                      *
      * 48 - Generate MT941 if no Movement                                     *
      * 49 - MT941 Re-Extract Shadow Postings                                  *
      * 50 - MT941 Re-Extract Real Postings since Last MT940                   *
      * 51 - Default MT941 Message Level Information to Account Owner (1)      *
      * 52 - Default MT941 Message Level Information to Account Owner (2)      *
      * 53 - Default MT941 Message Level Information to Account Owner (3)      *
      * 54 - Default MT941 Message Level Information to Account Owner (4)      *
      * 55 - Default MT941 Message Level Information to Account Owner (5)      *
      * 56 - Default MT941 Message Level Information to Account Owner (6)      *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Subfile Management Indicators                                          *
      *                                                                        *
      * 23 - SFLEND (Messages Subfile)                                         *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KJ - Confirm Deletion                                                  *
      * KL - Previous Screen                                                   *
      *                                                                        *
      * Function Key Indicators                                                *
      *                                                                        *
      * KK - Default the message level information to the network account level*
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

      ** Data to be passed to the window controller
      *
      /COPY QWINDSRC,SD200123DT

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(SD200123DF:SD200123F3)
      ** Details 3 Screen Layout
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

      ** Declared variables
      ** ------------------
      *
     D CGL178          S              1A                                                      CGL178

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM      *INKC         KCOut             1
     C                   PARM      *INKJ         KJOut             1
     C     *INKL         PARM      *INKL         KLOut             1
     C                   PARM                    NewFilRcd

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Main loop until F3 or F10 or F12 or no error
      *  ============================================
 B1  C                   DOU       *INKC OR *INKJ OR *INKL OR NOT *IN40

      ** If CGL178 is on and MT940 is not to be generated but MT941 is to be generated        CGL178
      ** then set on 57 to display '... from last MT950'                                      CGL178
     C                   If        CGL178 = 'Y'                                               CGL178
     C                   If        EDM940 = 'N' and EDM941 ='Y'                               CGL178
     C                   Eval      *IN57 = *On                                                CGL178
     C                   Endif                                                                CGL178
     C                   Endif                                                                CGL178
                                                                                              CGL178
      ** -- Display the screen
      *     ------------------
     C                   WRITE     SD200123H0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD200123F0
     C                   EXFMT     SD200123F3

      ** -- Clear the program message queue and the error indicators
      *     --------------------------------------------------------
     C                   EXSR      $ClrErrSF
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)

      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit program
      *
 B2  C                   IF        *INKC
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   ITER
 E2  C                   ENDIF

      ** ---- F5 ==> Refresh the screen
      *
 B2  C                   IF        *INKE
     C                   EXSR      $IniScreen
     C                   EVAL      *IN40 = *On
     C                   ITER
 E2  C                   ENDIF

      ** ---- F10 ==> Confirm deletion of the record
      *
 B2  C                   IF        *INKJ
     C                   MOVEL(P)  '*DLTCONF'    RetCodeOut
     C                   ITER
 E2  C                   ENDIF

      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
 E2  C                   ENDIF

      ** -- Validate the screen
      *     -------------------
      ** ---- Fields defaulting (if Insert or Amend)
      *
     C                   EXSR      $FldDflt

      ** ---- Validation
      *
     C                   EXSR      $ValidatSc

      ** -- Function keys management if no validation error
      *     ------------------------
      ** ---- F11 ==> Default information to the network account level
      **      (The screen will be redisplayed with an information msg)
      *
 B2  C                   IF        NOT *IN40 AND *INKK
     C                   EXSR      $DftMsgInf
 E2  C                   ENDIF

      ** -- Window processing if no validation error
      *     -----------------
 B2  C                   IF        NOT *IN40
     C                   EXSR      $Window
 E2  C                   ENDIF

 E1  C                   ENDDO

      ** Exit module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $FldDflt  : Screen fields defaulting                                   *
      *------------------------------------------------------------------------*
     C     $FldDflt      BEGSR
      *    ----------    ------
      ** No defaulting if Delete or Enquire
      *
     C                   IF        ActionCode = 'D' OR ActionCode = 'E'
     C                   GOTO      @FldDflt
     C                   ENDIF

      ** Allow MT941 Generation on Manual Request: default is 'N'
      *
     C                   IF        F31AMR = *Blank
     C                   EVAL      F31AMR = 'N'
     C                   ENDIF

      ** Default Message Status for Manual Request: default is 'R' if
      ** "Allow MT941 Generation on Manual Request" is 'Y'
      *
     C                   IF        F31SMR = *Blank AND F31AMR = 'Y'
     C                   EVAL      F31SMR = 'R'
     C                   ENDIF

      ** Allow MT941 Generation on Schedule: default is 'N'
      *
     C                   IF        F31AGS = *Blank
     C                   EVAL      F31AGS = 'N'
     C                   ENDIF

      ** Default Message Status for Schedule: default is 'R' if
      ** "Allow MT941 Generation on Schedule" is 'Y'
      *
     C                   IF        F31SGS = *Blank AND F31AGS = 'Y'
     C                   EVAL      F31SGS = 'R'
     C                   ENDIF

      ** Allow MT941 Generation on External Request: default is 'N'
      *
     C                   IF        F31AER = *Blank
     C                   EVAL      F31AER = 'N'
     C                   ENDIF

      ** Default Message Status for External Request: default is 'R' if
      ** "Allow MT941 Generation on External Request" is 'Y'
      *
     C                   IF        F31SER = *Blank AND F31AER = 'Y'
     C                   EVAL      F31SER = 'R'
     C                   ENDIF

      ** Generate MT941 if no Movement: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F31GNM = *Blank

     C                   IF        EDPROT = '*SWIFT'
     C                   EVAL      F31GNM = 'Y'
     C                   ELSE
     C                   EVAL      F31GNM = 'N'
     C                   ENDIF

     C                   ENDIF

      ** MT941 Re-Extract Shadow Postings: default is 'N'
      *
     C                   IF        F31RSP = *Blank
     C                   EVAL      F31RSP = 'N'
     C                   ENDIF

      ** MT941 Re-Extract Real Postings since Last MT940: default is 'N'
      *
     C                   IF        F31RPL = *Blank
     C                   EVAL      F31RPL = 'N'
     C                   ENDIF
      *    ----------    ------
     C     @FldDflt      ENDSR

      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the details 3 screen validation module if Amend or Insert
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   CALLB     'SD200143'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
     C                   ENDIF

      ** Set up error indicators
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
      *    ----------    ------
     C     @ValidatSc    ENDSR

      *========================================================================*
      * $DftMsgInf: Default message information to the linked network accounts *
      *------------------------------------------------------------------------*
     C     $DftMsgInf    BEGSR
      *    ----------    ------
      ** Loop on the linked network accounts and defaut the "MT941 message level
      ** information" with the screen values
      *
     C     EDNWRK        SETLL     GLNW94D0
     C     EDNWRK        READE     GLNW94D0                               99

     C                   DOW       NOT *IN99
     C                   EVAL      N41MI1 = F31MI1
     C                   EVAL      N41MI2 = F31MI2
     C                   EVAL      N41MI3 = F31MI3
     C                   EVAL      N41MI4 = F31MI4
     C                   EVAL      N41MI5 = F31MI5
     C                   EVAL      N41MI6 = F31MI6
     C                   UPDATE    GLNW94D0
     C     EDNWRK        READE     GLNW94D0                               99
     C                   ENDDO

      ** Display an information message
      *
     C                   MOVE      'USR3977'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
      *    ----------    ------
     C     @DftMsgInf    ENDSR

      *========================================================================*
      * $Window   : Window processing                                          *
      *------------------------------------------------------------------------*
     C     $Window       BEGSR
      *    ----------    ------
      ** Hook to enable the set up of data for the window controller
      *
      /COPY WNCPYSRC,SD200123MV

      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SD200123'    WdwPgm           10
     C                   PARM      *Blanks       WdwKey            2
     C                   PARM      ActionCode    WdwAction         1
     C                   PARM                    Data
     C                   PARM      *Blanks       WdwRtCd           7
     C                   PARM      *Blanks       WdwSpare        256

      ** If the returncode isn't blank, always issue a roll back command to
      ** cancel the eventual changes made in the window(s), and set up the
      ** appropriate action key (nothing to do for F12, any other value is
      ** considered as F3)
      *
 B1  C                   IF        WdwRtCd <> *Blanks
     C                   ROLBK

 B2  C                   IF        WdwRtCd <> 'USR0790'
     C                   EVAL      *INKC = *On
 E2  C                   ENDIF

 E1  C                   ENDIF
      *    ----------    ------
     C     @Window       ENDSR

      *========================================================================*
      * $IniScreen: Format the screen according to the received action code    *
      *------------------------------------------------------------------------*
     C     $IniScreen    BEGSR
      *    ----------    ------
      ** Fields value
      *
     C                   EVAL      F0NWRK = EDNWRK

     C                   EVAL      F31AMR = ED1AMR
     C                   EVAL      F31SMR = ED1SMR
     C                   EVAL      F31AGS = ED1AGS
     C                   EVAL      F31SGS = ED1SGS
     C                   EVAL      F31AER = ED1AER
     C                   EVAL      F31SER = ED1SER
     C                   EVAL      F31MXL = ED1MXL
     C                   EVAL      F31GNM = ED1GNM
     C                   EVAL      F31RSP = ED1RSP
     C                   EVAL      F31RPL = ED1RPL
     C                   EVAL      F31MI1 = ED1MI1
     C                   EVAL      F31MI2 = ED1MI2
     C                   EVAL      F31MI3 = ED1MI3
     C                   EVAL      F31MI4 = ED1MI4
     C                   EVAL      F31MI5 = ED1MI5
     C                   EVAL      F31MI6 = ED1MI6

      ** Fields defaulting
      *
     C                   EXSR      $FldDflt

      ** Protect fields or not
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   EVAL      *IN36 = *Off
     C                   ELSE
     C                   EVAL      *IN36 = *On
     C                   ENDIF

      ** Allow F10 key
      *                                                               >><<==
     C     ActionCode    COMP      'D'                                    01

      ** Display the warning mention '**DELETED**'
      *                                                               >><<==
     C     EDTYLC        COMP      'D'                                    02
      *    ----------    ------
     C     @IniScreen    ENDSR

      *========================================================================*
      * $ClrErrSF : Clear program message queue                                *
      *------------------------------------------------------------------------*
     C     $ClrErrSF     BEGSR
      *    ----------    ------
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
      *    ----------    ------
     C     @ClrErrSF     ENDSR

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Set up the file record layout to be returned if all's right
      ** and the current action is Insert or Amend
      *
     C                   IF        RetCodeOut = *Blanks AND
     C                             (ActionCode = 'I' OR ActionCode = 'A')
     C                   EXSR      $ScrToFile
     C                   ENDIF

     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * $ScrToFile: Move fields from the screen to the file record             *
      *========================================================================*
     C     $ScrToFile    BEGSR
      *    ----------    ------
     C                   EVAL      ED1AMR = F31AMR
     C                   EVAL      ED1SMR = F31SMR
     C                   EVAL      ED1AGS = F31AGS
     C                   EVAL      ED1SGS = F31SGS
     C                   EVAL      ED1AER = F31AER
     C                   EVAL      ED1SER = F31SER
     C                   EVAL      ED1MXL = F31MXL
     C                   EVAL      ED1GNM = F31GNM
     C                   EVAL      ED1RSP = F31RSP
     C                   EVAL      ED1RPL = F31RPL
     C                   EVAL      ED1MI1 = F31MI1
     C                   EVAL      ED1MI2 = F31MI2
     C                   EVAL      ED1MI3 = F31MI3
     C                   EVAL      ED1MI4 = F31MI4
     C                   EVAL      ED1MI5 = F31MI5
     C                   EVAL      ED1MI6 = F31MI6
      *    ----------    ------
     C     @ScrToFile    ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF

     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT

      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen
      *                                                                                       CGL178
      ** Check if CGL178 is installed                                                         CGL178
      *                                                                                       CGL178
     C                   MOVEL     'N'           CGL178                                       CGL178
     C                   CALLB     'AOSARDR0'                                                 CGL178
     C                   PARM      *BLANKS       PRtCd             7                          CGL178
     C                   PARM      '*VERIFY'     POptn             7                          CGL178
     C                   PARM      'CGL178'      @SARD                                        CGL178
                                                                                              CGL178
     C                   IF        PRtCd = *BLANKS                                            CGL178
     C                   MOVEL     'Y'           CGL178                                       CGL178
     C                   ENDIF                                                                CGL178
      *                                                                                       CGL178

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

      ** If the MT941 generation is not allowed by the current network, simply
      ** clear the screen, move the screen fields to the file and exit
      *
     C                   IF        EDM941 <> 'Y'
     C                   CLEAR                   SD200123F3
     C                   EXSR      $ExitMod
     C                   ENDIF
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
