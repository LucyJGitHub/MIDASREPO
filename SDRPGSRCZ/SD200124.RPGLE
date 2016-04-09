     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 4 Screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200124 - Midas SD Network Description Maintenance    *
      *                   (Details 4 Screen Display - MT942)          *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the fourth screen of fields of a Network       *
      *             record.                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26741           Date 11Nov09               *
      *                 BUG25800           Date 02Sep09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26741 - value of MT940/MT942 Allow subfield 4 of Field 61 *
      *             is not saved after insert.                        *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test                                *
      *  CER030 - Multicash German Feature                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLNW94L0  UF   E           K DISK    INFSR(*PSSR) COMMIT
      ** Midas GL Network Accounts - MT94x
      *
 
     FSD200124DFCF   E             WORKSTN
      ** Midas SD Networks Details 4 Screen Display
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
      * 41 - Allow MT942 Generation on Manual Request                          *
      * 42 - Default Message Status for Manual Request                         *
      * 43 - Allow MT942 Generation on Schedule                                *
      * 44 - Default Message Status for Schedule                               *
      * 45 - Allow MT942 Generation on External Request                        *
      * 46 - Default Message Status for External Request                       *
      * 47 - MT942 Maximum Message Length                                      *
      * 48 - Generate MT942 if no Movement                                     *
      * 49 - Fix Number of Items per Message                                   *
      * 50 - Number of Items per Message                                       *
      * 51 - MT942 Re-Extract Shadow Postings                                  *
      * 52 - MT942 Re-Extract Real Postings since Last MT940                   *
      * 53 - Default MT942 Message Level Information to Account Owner (1)      *
      * 54 - Default MT942 Message Level Information to Account Owner (2)      *
      * 55 - Default MT942 Message Level Information to Account Owner (3)      *
      * 56 - Default MT942 Message Level Information to Account Owner (4)      *
      * 57 - Default MT942 Message Level Information to Account Owner (5)      *
      * 58 - Default MT942 Message Level Information to Account Owner (6)      *
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
      /COPY QWINDSRC,SD200124DT
 
     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(SD200124DF:SD200124F4)
      ** Details 4 Screen Layout
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
      ** External DS for SAR Details                                                        BUG25800
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG25800
                                                                                            BUG25800
      ** DS for access objects - short data structure                                       BUG25800
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG25800
                                                                                            BUG25800
      ** Declared variables
      ** ------------------
      *
     D PRtCd           S              7A                                                    BUG25800
     D POptn           S              7A                                                    BUG25800
     D PSard           S              6A                                                    BUG25800
     D CER030          S              1A                                                    BUG25800
 
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
 
      ** -- Display the screen
      *     ------------------
     C                   WRITE     SD200124H0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD200124F0
     C                   EXFMT     SD200124F4
 
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
 
      ** Allow MT942 Generation on Manual Request: default is 'N'
      *
     C                   IF        F42AMR = *Blank
     C                   EVAL      F42AMR = 'N'
     C                   ENDIF
 
      ** Default Message Status for Manual Request: default is 'R' if
      ** "Allow MT942 Generation on Manual Request" is 'Y'
      *
     C                   IF        F42SMR = *Blank AND F42AMR = 'Y'
     C                   EVAL      F42SMR = 'R'
     C                   ENDIF
 
      ** Allow MT942 Generation on Schedule: default is 'N'
      *
     C                   IF        F42AGS = *Blank
     C                   EVAL      F42AGS = 'N'
     C                   ENDIF
 
      ** Default Message Status for Schedule: default is 'R' if
      ** "Allow MT942 Generation on Schedule" is 'Y'
      *
     C                   IF        F42SGS = *Blank AND F42AGS = 'Y'
     C                   EVAL      F42SGS = 'R'
     C                   ENDIF
 
      ** Allow MT942 Generation on External Request: default is 'N'
      *
     C                   IF        F42AER = *Blank
     C                   EVAL      F42AER = 'N'
     C                   ENDIF
 
      ** Default Message Status for External Request: default is 'R' if
      ** "Allow MT942 Generation on External Request" is 'Y'
      *
     C                   IF        F42SER = *Blank AND F42AER = 'Y'
     C                   EVAL      F42SER = 'R'
     C                   ENDIF
 
      ** Generate MT942 if no Movement: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F42GNM = *Blank
 
     C                   IF        EDPROT = '*SWIFT'
     C                   EVAL      F42GNM = 'Y'
     C                   ELSE
     C                   EVAL      F42GNM = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Fix Number of Items per Message: default is 'N'
      *
     C                   IF        F42FNI = *Blank
     C                   EVAL      F42FNI = 'N'
     C                   ENDIF
 
      ** MT942 Re-Extract Shadow Postings: default is 'N'
      *
     C                   IF        F42RSP = *Blank
     C                   EVAL      F42RSP = 'N'
     C                   ENDIF
 
      ** MT942 Re-Extract Real Postings since Last MT940: default is 'N'
      *
     C                   IF        F42RPL = *Blank
     C                   EVAL      F42RPL = 'N'
     C                   ENDIF
      *                                                                                       CER030
      ** Default MT942 subfield 4 of field 61 structure: Default is 'N'                       CER030
      *                                                                                       CER030
     C                   IF        D42F61 = *Blanks                                           CER030
     C**********                   or ActionCode = 'I' and CER030 = 'Y'            BUG25800 BUG26741
     C                   EVAL      D42F61 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *    ----------    ------
     C     @FldDflt      ENDSR
 
      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the details 4 screen validation module if Amend or Insert
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   CALLB     'SD200144'
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
      ** Loop on the linked network accounts and defaut the "MT942 message level
      ** information" with the screen values
      *
     C     EDNWRK        SETLL     GLNW94D0
     C     EDNWRK        READE     GLNW94D0                               99
 
     C                   DOW       NOT *IN99
     C                   EVAL      N42MI1 = F42MI1
     C                   EVAL      N42MI2 = F42MI2
     C                   EVAL      N42MI3 = F42MI3
     C                   EVAL      N42MI4 = F42MI4
     C                   EVAL      N42MI5 = F42MI5
     C                   EVAL      N42MI6 = F42MI6
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
      /COPY WNCPYSRC,SD200124MV
 
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SD200124'    WdwPgm           10
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
 
     C                   EVAL      F42AMR = ED2AMR
     C                   EVAL      F42SMR = ED2SMR
     C                   EVAL      F42AGS = ED2AGS
     C                   EVAL      F42SGS = ED2SGS
     C                   EVAL      F42AER = ED2AER
     C                   EVAL      F42SER = ED2SER
     C                   EVAL      F42MXL = ED2MXL
     C                   EVAL      F42GNM = ED2GNM
     C                   EVAL      F42FNI = ED2FNI
     C                   EVAL      F42NIM = ED2NIM
     C                   EVAL      F42RSP = ED2RSP
     C                   EVAL      F42RPL = ED2RPL
     C                   EVAL      F42MI1 = ED2MI1
     C                   EVAL      F42MI2 = ED2MI2
     C                   EVAL      F42MI3 = ED2MI3
     C                   EVAL      F42MI4 = ED2MI4
     C                   EVAL      F42MI5 = ED2MI5
     C                   EVAL      F42MI6 = ED2MI6
     C                   EVAL      D42F61 = ED2F61                                            CER030
 
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
     C                   EVAL      ED2AMR = F42AMR
     C                   EVAL      ED2SMR = F42SMR
     C                   EVAL      ED2AGS = F42AGS
     C                   EVAL      ED2SGS = F42SGS
     C                   EVAL      ED2AER = F42AER
     C                   EVAL      ED2SER = F42SER
     C                   EVAL      ED2MXL = F42MXL
     C                   EVAL      ED2GNM = F42GNM
     C                   EVAL      ED2FNI = F42FNI
     C                   EVAL      ED2NIM = F42NIM
     C                   EVAL      ED2RSP = F42RSP
     C                   EVAL      ED2RPL = F42RPL
     C                   EVAL      ED2MI1 = F42MI1
     C                   EVAL      ED2MI2 = F42MI2
     C                   EVAL      ED2MI3 = F42MI3
     C                   EVAL      ED2MI4 = F42MI4
     C                   EVAL      ED2MI5 = F42MI5
     C                   EVAL      ED2MI6 = F42MI6
     C                   EVAL      ED2F61 = D42F61                                            CER030
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
                                                                                            BUG25800
     C                   CALLB     'AOSARDR0'                                               BUG25800
     C                   PARM      *BLANKS       PRTCD                                      BUG25800
     C                   PARM      '*VERIFY'     POPTN                                      BUG25800
     C                   PARM      'CER030'      PSARD                                      BUG25800
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG25800
                                                                                            BUG25800
      ** Database error                                                                     BUG25800
                                                                                            BUG25800
     C                   IF        (PRtCd <> *Blanks) and                                   BUG25800
     C                             (PRtCd <> '*NRF   ')                                     BUG25800
     C                   EVAL      DBKEY = 'CER030'                                         BUG25800
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG25800
     C                   EVAL      DBASE = 001                                              BUG25800
     C                   EXSR      *PSSR                                                    BUG25800
     C                   ENDIF                                                              BUG25800
                                                                                            BUG25800
     C                   IF        PRtCd = *Blanks                                          BUG25800
     C                   EVAL      CER030 = 'Y'                                             BUG25800
     C                   ELSE                                                               BUG25800
     C                   EVAL      CER030 = 'N'                                             BUG25800
     C                   ENDIF                                                              BUG25800
 
      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** If the MT942 generation is not allowed by the current network, simply
      ** clear the screen, move the screen fields to the file and exit
      *
     C                   IF        EDM942 <> 'Y'
     C                   CLEAR                   SD200124F4
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
(c) Misys International Banking Systems Ltd. 2002
