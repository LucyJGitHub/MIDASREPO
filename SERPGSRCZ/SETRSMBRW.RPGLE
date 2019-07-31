     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements maintenance browse')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMBRW - Trade Settlements Maintenance Browse             *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - Displays a list of Trade Settlement Details      *
      *              for selection.                                   *
      *            - Picks off the selection made.                    *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BG13275            Date 12Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP182  *CREATE    Date 24Feb03               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *             (Recompile)                                       *
      *  AR656294 - HATS issue (Recompile)                            *
      *  BG13275 - Subfile error caused by missing EOF indicator      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         Use for numeric validation                      *
      *    95-96      Use for chaining to file                        *
      *    98         Use for subfile manipulation                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrVKeyIn   - Validate entry on key fields.                   *
      *  SrBldSfl   - Controlling subroutine for subfile building.    *
      *  SrBldSfl1  - Build Subfile by Midas Security shortname.      *
      *  SrBldSfl2  - Build Subfile by Front Office Id                *
      *  SrRdSfl    - Read Subfile Record                             *
      *  SrChkOption- Check if an option has been selected            *
      *  SrChkAut   - Check for user authority if not multi-branching *
      *  SrRdSetled - Read a valid Security Trade Settlement File     *
      *  SrFmtDet   - Format details for output to the subfile        *
      *  SrZDate1   - Validate and convert date to day number         *
      *  SrZDate2   - Convert Midas Date into DDMMYY or MMDDYY        *
      *  SrInit     - Initialisation Processing                       *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
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
      ** Browse screen
     FSETRSMBRDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SETRSMBRS0:W_Rrn)
     F                                     SFILE(SETRSMBRS1:W_Rrn)
      *
      ** Security Trade Settlement Details by Front Office ID
     FSETSFL1   IF   E           K DISK    INFSR(*PSSR)
      *
     FSETLEL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED1)
     FSETLEL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED2)
     FSETLEL3   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED3)
     FSETLEL4   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED4)
     FSETLEL5   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED5)
     FSETLEL6   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED6)
     FSETLEL7   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED7)
     FSETLEL8   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED8)
     FSETLEL9   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED9)
     FSETLEL10  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED10)
     FSETLEL11  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED11)
      *
     FSETLEL12  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SETLEDF:SETLED12)
      *
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *ON (for indicator processing)
      **    False      logical = *OFF (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Securities Clients File                                              CSE010
     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                  CSE010
                                                                                              CSE010
      ** Short DS for access program
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  NumericI1             90     90
     D  RecNotFnd             95     95
     D  EndOfFile             96     96
      *
      ** Key-in subfile record key pointer
     D KeyLists        DS
     D  SWTRAD
     D  SWSECS
     D  SWCLNT
     D  KWMVDT                             LIKE(SWMVDT)
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Parameter list for ZDATE1
     D PDateAIn        S              6A
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZDATE2
     D PDateNIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for AOCUSTR0
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Work parameters
     D PINKC           S              1A
     D PINKL           S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D POpSel          S              1A
     D PActn           S              1A
     D PError          S              1P 0
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D PErrMS          S              7A
     D BJMRDT          S              7A
     D PTRADSel        S              6A
     D PMVDTSel        S              6A
     D PFSETSel        S              1A
     D PREVESel        S              1A
     D PSEQNSel        S              3  0
      *
      ** Work variables
     D KeyFrmBRW       S              1A
     D OptSelected     S              1A
     D WPrvOrd         S              1A
     D W_Cnt           S              3P 0
     D WLCD            S              5P 0
     D W_Rrn           S              5P 0
     D WOrderOf        S              4A
      *
      ** Key fields
     D KTRAD           S              6A
     D KSECS           S             10A
     D KCLNT           S              6A
     D KMVDT           S              5  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialisation.
     C                   Exsr      SrInit
      *
      ** Build subfile.
     C                   If        PBdSfl = 'Y'
      *
      ** Validate key entry.
     C                   Exsr      SrVKeyIn

     C                   Exsr      SrBldSfl

     C                   EndIf
      *
      ** Read subfile record.
      *
     C                   If        PRdSfl = 'Y'
     C                   Exsr      SrRdSfl
     C                   EndIf
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVKeyIn - Validate entry on key fields.                     *
      *                                                               *
      *****************************************************************
     C     SrVKeyIn      BEGSR
      *
      ** Validate Movement date entered.
     C                   Eval      KWMVDT = *Blanks
      *
     C                   If        SWMVDT <> *BLANKS

     C                   If        SWMVDT = *ALL'9'
     C                   Z-Add     99999         KMVDT
     C                   Move      '999999'      KWMVDT
     C                   Else

     C                   TESTN                   SWMVDT               90

     C                   If        NumericI1 = False
     C                   Eval      PErrorFlag = 'Y'
     C                   Else
     C                   Eval      PDateAIn = SWMVDT
     C                   Exsr      SrZDate1
     C                   If        PErrorFlag <> 'Y'
     C                   Z-Add     PDaynoOut     KMVDT
     C                   Move      SWMVDT        KWMVDT
     C                   EndIf
     C                   EndIf
      *
      ** If error in movement date, do not display browse screen.
     C                   If        PErrorFlag = 'Y'
     C                   If        KeyFrmBRW <> 'Y'
     C                   Eval      PErrMs = 'USR2031'
     C                   RETURN
     C                   Else
     C                   Eval      KWMVDT = *Blanks
     C                   Eval      MsgIdArr(1)  = 'USR2031'
     C                   Eval      FldNameArr(1)= '*ANY'
     C                   Eval      *IN61        = *ON
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1

     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
      *
      ** Validate the Client number
      *
     C                   If        SWCLNT <> *Blanks
      *
      ** Check to see if Shortname or ? have been entered
     C                   Eval      PKeyC = *Blanks
     C                   Movel     SWCLNT        PKeyC
     C                   CallB     'AOCUSTR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PKeyC            10
     C                   Parm      *BLANKS       PKyst             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        PRtcd = *Blanks
     C                   CallB     'AOSECSR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      BBCUST        PKey6             6
     C     SDSECS        Parm      SDSECS        DSFDY
     C                   EndIf
      *
     C                   If        PRtcd = *Blanks
     C                   Eval      SWCLNT = *Blanks
     C                   Movel     BBCUST        SWCLNT
     C                   EndIF
      *
     C                   EndIF
      *
      ** Validate Security Shortname
     C                   If        SWSECS <> *Blanks
      *
     C     '?'           SCAN      SWSECS                                 31                  CSE010
      *                                                                                       CSE010
     C                   If        *IN31 = *ON                                                CSE010
     C                   Move      SWSECS        KSESN                                        CSE010
     C                   Call      'SE0043'                                                   CSE010
     C                   Parm      'E'           KActn             1                          CSE010
     C                   Parm                    KSESN            10                          CSE010
     C                   Eval      SWSECS = *Blanks
     C                   If        KSESN <> *Blanks                                           CSE010
     C                   MoveL     KSESN         SWSECS                                       CSE010
     C                   EndIf                                                                CSE010
     C                   EndIf                                                                CSE010
      *                                                                                       CSE010
     C                   EndIF                                                                CSE010
      *
     C                   Eval      KTRAD = SWTRAD
     C                   Eval      KSECS = SWSECS
     C                   Eval      KCLNT = SWCLNT
     C                   Eval      WOrderOf = *BLANKS
      *
     C                   SELECT
      *
      ** T-Trade Number      S-Security Shortname
      *  C-Client            D-Movement Date
      *
     C                   When      KeyLists = *BLANKS
     C                   Eval      WOrderOf = 'DT  '
     C     *HIVAL        SETGT     SETLEL12
      *
     C                   When      SWTRAD <> *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'TSCD'

     C                   When      SWTRAD <> *Blanks And SWSECS = *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'TSCD'
     C                   Eval      KSECS = *LOVAL
     C                   Eval      KCLNT = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD <> *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'TSCD'
     C                   Eval      KCLNT = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD <> *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'TSCD'
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD <> *Blanks And SWSECS = *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'TCDS'
     C                   Eval      KSECS = *LOVAL

     C                   When      SWTRAD <> *Blanks And SWSECS = *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'TCSD'
     C                   Eval      KSECS = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD <> *Blanks And SWSECS = *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'TDSC'
     C                   Eval      KSECS = *LOVAL
     C                   Eval      KCLNT = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'SCDT'
     C                   Eval      KTRAD = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'SCTD'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'SDTC'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KCLNT = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS = *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'CDTS'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KSECS = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS <> *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'STCD'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KCLNT = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS = *Blanks
     C                             And SWCLNT <> *Blanks And SWMVDT = *Blanks
     C                   Eval      WOrderOf = 'CTSD'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KSECS = *LOVAL
     C                   Eval      KMVDT = *LOVAL

     C                   When      SWTRAD = *Blanks And SWSECS = *Blanks
     C                             And SWCLNT = *Blanks And SWMVDT <> *Blanks
     C                   Eval      WOrderOf = 'DTSC'
     C                   Eval      KTRAD = *LOVAL
     C                   Eval      KSECS = *LOVAL
     C                   Eval      KCLNT = *LOVAL

     C                   EndSl

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Controlling subroutine for subfile building.      *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
      *
      ** If first time in or subfile by backoffice key was previously
      ** being run, then build subfile keyed on Midas trade number.
      ** Stay in loop while toggle key (F11) is used.
      *
     C                   If        WPrvOrd <> 'F'

     C                   DOU       *INKK = *OFF

     C                   Exsr      SrBldSfl1
      *
      ** If F11, switch to subfile by front office id.
     C                   If        *INKK = *ON
     C                   Exsr      SrBldSfl2
     C                   EndIf

     C                   EndDo

     C                   Else
      *
      ** If the subfile by front office identifier was previously
      ** being run, then build subfile keyed on front office id.
      ** Stay in loop while toggle key (F11) is used.
     C                   DOU       *INKK = *OFF

     C                   Exsr      SRBldSfl2
      *
      ** If F11, switch to subfile by security short name.
     C                   If        *INKK = *ON
     C                   Exsr      SRBldSfl1
     C                   EndIf

     C                   EndDo

     C                   EndIf

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl1 - Build Subfile by Midas Security Trade Number.    *
      *                                                               *
      *****************************************************************
     C     SrBldSfl1     BEGSR
      *
      ** Set flag for Trade Number, SE Shortname, Client and Movement Date.
      *
     C                   Eval      WPrvOrd = 'B'
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   If        BJSBRC <> *Blanks
     C                   Exsr      SrChkAut
     C                   EndIf
      *
      ** Initialise subfile relative record number.
     C                   Z-Add     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
     C                   Eval      *IN97 = *ON
     C                   Write     SETRSMBRC0
     C                   Eval      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
     C                   Write     SETRSMBRF0
      *
      ** Set record pointer to key field used.
     C                   SELECT
     C                   When      WOrderOf = 'TSCD'
     C     KeyTSCD       Setll     SETLEL1
     C                   When      WOrderOf = 'TCDS'
     C     KeyTCDS       Setll     SETLEL2
     C                   When      WOrderOf = 'TCSD'
     C     KeyTCSD       Setll     SETLEL3
     C                   When      WOrderOf = 'TDSC'
     C     KeyTDSC       Setll     SETLEL4
     C                   When      WOrderOf = 'SCDT'
     C     KeySCDT       Setll     SETLEL5
     C                   When      WOrderOf = 'SCTD'
     C     KeySCTD       Setll     SETLEL6
     C                   When      WOrderOf = 'SDTC'
     C     KeySDTC       Setll     SETLEL7
     C                   When      WOrderOf = 'CDTS'
     C     KeyCDTS       Setll     SETLEL8
     C                   When      WOrderOf = 'STCD'
     C     KeySTCD       Setll     SETLEL9
     C                   When      WOrderOf = 'CTSD'
     C     KeyCTSD       Setll     SETLEL10
     C                   When      WOrderOf = 'DTSC'
     C     KeyDTSC       Setll     SETLEL11
     C                   ENDSL
      *
      ** Read Security Trade Settlement Details from File
     C                   Exsr      SrRdSetled
      *
      ** If no record read, set up an error message.
     C                   If        EndOfFile = True
      *
      ** If keys are blank, display 'No Trade Settlement Details to display.'.
     C                   If        KeyLists = *BLANKS
     C                   Eval      PErrMs = 'USR2051'
     C                   Else
      *
      ** Else, display 'No Trade Settlement Details to display for the
      ** selection made.'.
     C                   Eval      PErrMs = 'USR2052'
     C                   EndIf

     C                   RETURN

     C                   EndIf
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   Eval      *IN98 = *ON
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *ON  OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-Add     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile = False And
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
     C                   Add       1             W_Rrn
     C                   Add       1             W_Cnt
      *
      ** Format fields for output.
     C                   Exsr      SrFmtDet
      *
      ** Write the Trade Settlement details to subfile.
     C                   Eval      SSELC = *BLANK
     C                   Z-Add     W_Rrn         SSFRN
     C                   Write     SETRSMBRS0
      *
      ** Read next record.
     C                   EXSR      SrRdSetled
      *
     C                   EndDo
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
     C                   EXFMT     SETRSMBRC0
      *
      ** If F3, bypass further processing for this module.
     C                   If        *INKC = *ON
     C                   Eval      PINKC = '1'
     C                   Eval      *INLR = *ON
     C                   RETURN
     C                   EndIf
      *
      ** If F11, bypass further processing for this loop.
     C                   If        *INKK = *ON
     C                   GoTo      ESrBldSfl1
     C                   EndIf
      *
      ** If F12, bypass further processing this module.
     C                   If        *INKL = *ON
     C                   Eval      PINKL = '1'
     C                   CLEAR                   KeyLists
     C                   Eval      *IN61 = *OFF
     C                   RETURN
     C                   EndIf
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a record to subfile.
     C                   If        *IN98 <> *ON
      *
      ** Check if a valid option has been selected.
      *
     C                   Exsr      SrChkOption
      *
      ** No option has been selected, process key/selection fields.
      *
     C                   If        OptSelected <> 'Y'
      *
      ** Clear message subfile and reset error indicators.
     C                   Call      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   Eval      *IN61 = *OFF

     C                   Eval      KeyFrmBRW = 'Y'
      *
      ** Validate entry
     C                   Exsr      SrVKeyIn
      *
     C                   SELECT
     C                   When      WOrderOf = 'TSCD'
     C     KeyTSCD       Setll     SETLEL1
     C                   When      WOrderOf = 'TCDS'
     C     KeyTCDS       Setll     SETLEL2
     C                   When      WOrderOf = 'TCSD'
     C     KeyTCSD       Setll     SETLEL3
     C                   When      WOrderOf = 'TDSC'
     C     KeyTDSC       Setll     SETLEL4
     C                   When      WOrderOf = 'SCDT'
     C     KeySCDT       Setll     SETLEL5
     C                   When      WOrderOf = 'SCTD'
     C     KeySCTD       Setll     SETLEL6
     C                   When      WOrderOf = 'SDTC'
     C     KeySDTC       Setll     SETLEL7
     C                   When      WOrderOf = 'CDTS'
     C     KeyCDTS       Setll     SETLEL8
     C                   When      WOrderOf = 'STCD'
     C     KeySTCD       Setll     SETLEL9
     C                   When      WOrderOf = 'CTSD'
     C     KeyCTSD       Setll     SETLEL10
     C                   When      WOrderOf = 'DTSC'
     C     KeyDTSC       Setll     SETLEL11
     C                   ENDSL

     C                   Exsr      SrRdSetled
      *
      ** The key/selection fields refer to a record, set pointer and rebuild
      ** sub-file page.  Else, display corresponding error message.
      *
     C                   If        EndOfFile = False
     C                   Z-Add     0             W_Rrn
     C                   Eval      *IN97 = *ON
     C                   WRITE     SETRSMBRC0
     C                   Eval      *IN97 = *OFF

     C                   Else

     C                   Eval      MsgIdArr(1) = 'USR2052'
     C                   Eval      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
     C                   EndIf
      *
      ** Write message sub-file for error messages.
      *
     C                   WRITE     SETRSMBRC2

     C                   EndIf

     C                   EndIf

     C                   EndDo

     C     ESrBldSfl1    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl2 - Build Subfile by Front Office Id                 *
      *                                                               *
      *****************************************************************
     C     SrBldSfl2     BEGSR
      *
      ** Set flag for front office id key used.
     C                   Eval      WPrvOrd = 'F'
      *
      ** Check for user authority to browse if not multi-branch environment.
     C                   If        BJSBRC <> *BLANKS
     C                   Exsr      SrChkAut
     C                   EndIf
      *
      ** Initialise subfile relative record number.
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
     C                   Eval      *IN97 = *ON
     C                   WRITE     SETRSMBRC1
     C                   Eval      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
     C                   WRITE     SETRSMBRF0
      *
      ** Set record pointer to key record used with priority to first key.
     C                   Select
     C                   When      SWFRNT <> *BLANKS
     C     SWFRNT        Setll     SETSFL1
     C                   When      WOrderOf = 'TSCD' And KeyLists <> *BLANKS
     C     KeyTSCD       Setll     SETLEL1
     C                   When      WOrderOf = 'TCDS' And KeyLists <> *BLANKS
     C     KeyTCDS       Setll     SETLEL2
     C                   When      WOrderOf = 'TCSD' And KeyLists <> *BLANKS
     C     KeyTCSD       Setll     SETLEL3
     C                   When      WOrderOf = 'TDSC' And KeyLists <> *BLANKS
     C     KeyTDSC       Setll     SETLEL4
     C                   When      WOrderOf = 'SCDT' And KeyLists <> *BLANKS
     C     KeySCDT       Setll     SETLEL5
     C                   When      WOrderOf = 'SCTD' And KeyLists <> *BLANKS
     C     KeySCTD       Setll     SETLEL6
     C                   When      WOrderOf = 'SDTC' And KeyLists <> *BLANKS
     C     KeySDTC       Setll     SETLEL7
     C                   When      WOrderOf = 'CDTS' And KeyLists <> *BLANKS
     C     KeyCDTS       Setll     SETLEL8
     C                   When      WOrderOf = 'STCD' And KeyLists <> *BLANKS
     C     KeySTCD       Setll     SETLEL9
     C                   When      WOrderOf = 'CTSD' And KeyLists <> *BLANKS
     C     KeyCTSD       Setll     SETLEL10
     C                   When      WOrderOf = 'DTSC' And KeyLists <> *BLANKS
     C     KeyDTSC       Setll     SETLEL11
     C                   Other
     C     *LOVAL        Setll     SETSFL1
     C                   EndSl
      *
      ** Read a record from file.
     C                   Exsr      SrRdSetled
      *
      ** If no record read, set up an error message.
     C                   If        EndOfFile = True
      *
      ** If keys are blank, display 'No Trade Settlement Details to display'
     C                   If        KeyLists = *BLANKS
     C                   Eval      PErrMs = 'USR2051'
     C                   Else
      *
      ** Else, display 'No Trade Settlement Details to display for the selection
      ** made.'.
     C                   Eval      PErrMs = 'USR2052'
     C                   EndIf

     C                   RETURN

     C                   EndIf
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   Eval      *IN98 = *ON
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *ON OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile = False And
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Format fields for output.
     C                   Exsr      SrFmtDet
      *
      ** Write the security details to subfile.
     C                   Eval      SSELC = *BLANK
     C                   Z-Add     W_Rrn         SSFRN
     C                   Write     SETRSMBRS1
      *
      ** Read next record.
     C                   Exsr      SrRdSetled
      *
     C                   EndDo
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
     C                   EXFMT     SETRSMBRC1
      *
      ** If F3, bypass further processing for this module.
     C                   If        *INKC = *ON
     C                   Eval      PINKC = '1'
     C                   Eval      *INLR = *ON
     C                   RETURN
     C                   EndIf
      *
      ** If F11, bypass further processing for this loop.
     C                   If        *INKK = *ON
     C                   GoTo      ESrBldSfl2
     C                   EndIf
      *
      ** If F12, bypass further processing for this module.
     C                   If        *INKL = *ON
     C                   Eval      PINKL = '1'
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
     C                   Eval      *IN61 = *OFF
     C                   RETURN
     C                   EndIf

     C                   Exsr      SrChkOption
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a record to subfile.
      *
     C                   If        *IN98 <> *ON AND OptSelected <> 'Y'
      *
      ** Clear message subfile and reset error indicators.
     C                   CALL      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   Eval      *IN61 = *OFF

     C                   Eval      KeyFrmBRW = 'Y'
      *
      ** Validate entry.
     C                   EXSR      SrVKeyIn

     C                   Select
     C                   When      SWFRNT <> *BLANKS
     C     SWFRNT        Setll     SETSFL1
     C                   When      WOrderOf = 'TSCD' And KeyLists <> *BLANKS
     C     KeyTSCD       Setll     SETLEL1
     C                   When      WOrderOf = 'TCDS' And KeyLists <> *BLANKS
     C     KeyTCDS       Setll     SETLEL2
     C                   When      WOrderOf = 'TCSD' And KeyLists <> *BLANKS
     C     KeyTCSD       Setll     SETLEL3
     C                   When      WOrderOf = 'TDSC' And KeyLists <> *BLANKS
     C     KeyTDSC       Setll     SETLEL4
     C                   When      WOrderOf = 'SCDT' And KeyLists <> *BLANKS
     C     KeySCDT       Setll     SETLEL5
     C                   When      WOrderOf = 'SCTD' And KeyLists <> *BLANKS
     C     KeySCTD       Setll     SETLEL6
     C                   When      WOrderOf = 'SDTC' And KeyLists <> *BLANKS
     C     KeySDTC       Setll     SETLEL7
     C                   When      WOrderOf = 'CDTS' And KeyLists <> *BLANKS
     C     KeyCDTS       Setll     SETLEL8
     C                   When      WOrderOf = 'STCD' And KeyLists <> *BLANKS
     C     KeySTCD       Setll     SETLEL9
     C                   When      WOrderOf = 'CTSD' And KeyLists <> *BLANKS
     C     KeyCTSD       Setll     SETLEL10
     C                   When      WOrderOf = 'DTSC' And KeyLists <> *BLANKS
     C     KeyDTSC       Setll     SETLEL11
     C                   Other
     C     *LOVAL        Setll     SETSFL1
     C                   EndSl
      *
     C                   Exsr      SrRdSetled

     C                   If        EndOfFile = False
     C                   Z-Add     0             W_Rrn
     C                   Eval      *IN97 = *ON
     C                   WRITE     SETRSMBRC1
     C                   Eval      *IN97 = *OFF

     C                   Else

     C                   Eval      MsgIdArr(1) = 'USR2051'
     C                   Eval      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
     C                   EndIf

     C                   Write     SETRSMBRC2

     C                   EndIf

     C                   EndDo

     C     ESrBldSfl2    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdSfl - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
     C     SrRdSfl       BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C                   DOU       *IN99 = *ON OR
     C                             SSELC <> *BLANK

     C                   If        WPrvOrd <> 'F'
     C                   READC     SETRSMBRS0                             99
     C                   Else
     C                   READC     SETRSMBRS1                             99
     C                   EndIf

     C                   EndDo
      *
      ** Return the selected record.
     C                   If        *IN99 <> *ON And
     C                             SSELC <> *BLANK

     C                   Eval      POpSel = 'E'

     C                   Eval      PTRADSel = STRAD
     C                   Eval      PMVDTSel = SMVDT
     C                   Eval      PFSETSel = SFSET
     C                   Eval      PREVESel = SREVE
     C                   Move      SSEQN         PSEQNSel
      *
     C                   EndIf

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkOption - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
     C     SrChkOption   BEGSR
      *
      ** Read subfile if an option has been selected.
      *
     C                   DOU       *IN99 = *ON Or SSELC <> *BLANK

     C                   If        WPrvOrd = 'B'
     C                   READC     SETRSMBRS0                             99
     C                   Else
     C                   READC     SETRSMBRS1                             99
     C                   EndIf

     C                   EndDo
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
      *
     C                   If        *IN99 = *OFF

     C                   Eval      *IN93 = *ON
     C                   If        WPrvOrd = 'B'
     C                   UPDATE    SETRSMBRS0
     C                   Else
     C                   UPDATE    SETRSMBRS1
     C                   EndIf
     C                   Eval      *IN93 = *OFF

     C                   If        WPrvOrd = 'B'
     C                   WRITE     SETRSMBRC0
     C                   Else
     C                   WRITE     SETRSMBRC1
     C                   EndIf

     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists

     C                   Eval      OptSelected = 'Y'

     C                   Else

     C                   Eval      OptSelected = 'N'

     C                   EndIf

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
     C     SrChkAut      BEGSR

     C                   Call      'ZVACTU'
     C                   Parm      'E'           PActn
     C                   Parm      *ZERO         PError
      *
      ** Return error message.
     C                   If        PError = 1
     C                   Eval      PErrMs = 'FXM0292'
     C                   RETURN
     C                   EndIf

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdSetled - Read a valid Security Trade Settlement File     *
      *                                                               *
      *****************************************************************
     C     SrRdSetled    BEGSR
      *
      ** Read the file initially - if EndOfFile is set on, then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
     C                   DOU       EndOfFile = True OR
     C                             PError = *Zero
      *
      ** Read the file by back office or front office key.
      *
     C                   If        WPrvOrd = 'B'

     C                   Select
     C                   When      WOrderOf = 'TSCD'
     C******             Read      SETLEL1                                                   BG13275
     C                   Read      SETLEL1                                96                 BG13275
     C                   When      WOrderOf = 'TCDS'
     C******             Read      SETLEL2                                                   BG13275
     C                   Read      SETLEL2                                96                 BG13275
     C                   When      WOrderOf = 'TCSD'
     C******             Read      SETLEL3                                                   BG13275
     C                   Read      SETLEL3                                96                 BG13275
     C                   When      WOrderOf = 'TDSC'
     C******             Read      SETLEL4                                                   BG13275
     C                   Read      SETLEL4                                96                 BG13275
     C                   When      WOrderOf = 'SCDT'
     C******             Read      SETLEL5                                                   BG13275
     C                   Read      SETLEL5                                96                 BG13275
     C                   When      WOrderOf = 'SCTD'
     C******             Read      SETLEL6                                                   BG13275
     C                   Read      SETLEL6                                96                 BG13275
     C                   When      WOrderOf = 'SDTC'
     C******             Read      SETLEL7                                                   BG13275
     C                   Read      SETLEL7                                96                 BG13275
     C                   When      WOrderOf = 'CDTS'
     C******             Read      SETLEL8                                                   BG13275
     C                   Read      SETLEL8                                96                 BG13275
     C                   When      WOrderOf = 'STCD'
     C******             Read      SETLEL9                                                   BG13275
     C                   Read      SETLEL9                                96                 BG13275
     C                   When      WOrderOf = 'CTSD'
     C******             Read      SETLEL10                                                  BG13275
     C                   Read      SETLEL10                               96                 BG13275
     C                   When      WOrderOf = 'DTSC'
     C******             Read      SETLEL11                                                  BG13275
     C                   Read      SETLEL11                               96                 BG13275
     C                   When      WOrderOf = 'DT  '
     C******             Read      SETLEL12                                                  BG13275
     C                   Read      SETLEL12                               96                 BG13275
     C                   Endsl

     C                   Else

     C                   Select
     C                   When      SWFRNT <> *BLANKS
     C                   Read      SETSFL1                                96
     C                   When      WOrderOf = 'TSCD' And KeyLists <> *Blanks
     C                   Read      SETLEL1                                96
     C                   When      WOrderOf = 'TCDS' And KeyLists <> *Blanks
     C                   Read      SETLEL2                                96
     C                   When      WOrderOf = 'TCSD' And KeyLists <> *Blanks
     C                   Read      SETLEL3                                96
     C                   When      WOrderOf = 'TDSC' And KeyLists <> *Blanks
     C                   Read      SETLEL4                                96
     C                   When      WOrderOf = 'SCDT' And KeyLists <> *Blanks
     C                   Read      SETLEL5                                96
     C                   When      WOrderOf = 'SCTD' And KeyLists <> *Blanks
     C                   Read      SETLEL6                                96
     C                   When      WOrderOf = 'SDTC' And KeyLists <> *Blanks
     C                   Read      SETLEL7                                96
     C                   When      WOrderOf = 'CDTS' And KeyLists <> *Blanks
     C                   Read      SETLEL8                                96
     C                   When      WOrderOf = 'STCD' And KeyLists <> *Blanks
     C                   Read      SETLEL9                                96
     C                   When      WOrderOf = 'CTSD' And KeyLists <> *Blanks
     C                   Read      SETLEL10                               96
     C                   When      WOrderOf = 'DTSC' And KeyLists <> *Blanks
     C                   Read      SETLEL11                               96
     C                   Other
     C                   Read      SETSFL1                                96
     C                   EndSl

     C                   EndIf

     C                   If        EndOfFile = False
      *
      ** If a record was read, check whether user can see it.
     C                   If        BJSBRC = *Blanks
     C                   Call      'ZVACTBU'
     C                   Parm      'E'           PActn
     C                   Parm                    PDBRN
     C                   Parm      *ZERO         PError
     C                   EndIf

     C                   EndIf
      *
     C                   EndDo

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtDet - Format details for output to the subfile          *
      *                                                               *
      *****************************************************************
     C     SrFmtDet      BEGSR
      *
      ** Trade Reference Number
     C                   Eval      STRAD = STDR
      *
      ** Security shortname
     C                   Eval      SSECS = SSSN
      *
      ** Security Reportname
     C     SSSN          Chain     SECTYDF                            31
     C                   If        *IN31 = *OFF
     C                   Eval      SSRPN = SE_SRPN
     C                   Else
     C                   Eval      SSRPN = *Blanks
     C                   EndIf
      *
      ** Client
     C                   Eval      SCLNT = SCPN
      *
      ** Settlement Sequence Number
     C                   Move      SSQN          SSEQN
      *
      ** Full Settlement
     C                   Eval      SFSET = SFSI
      *
      ** Reversal
     C                   If        SRIN <> *Blanks
     C                   Eval      SREVE = SRIN
     C                   Else
     C                   Eval      SREVE = 'N'
     C                   EndIf
      *
      ** Front office transaction number
     C                   Eval      SFRNT = FRNT
      *
      ** Movement Date
     C                   If        SEDE <> *Zeros
     C                   Z-Add     SEDE          PDateNIn
     C                   Exsr      SrZDate2
     C                   Movel     PDateOut      SMVDT
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR

     C                   CallB     'ZDATE1'
     C                   Parm                    PDateAIn
     C                   Parm      *ZERO         PDaynoOut
     C                   Parm                    BJDFIN
     C                   Parm      *Blanks       PErrorFlag

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR

     C                   CallB     'ZDATE2'
     C                   Parm                    PDateNIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *Blanks       PADateOut

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
      *
      ** Clear output.
      *
     C                   Eval      PINKC = '0'
     C                   Eval      PINKL = '0'
     C                   Eval      PErrMs = *BLANKS
     C                   Eval      POpSel = *BLANKS
     C                   Eval      PTRADSel = *BLANKS
     C                   Eval      PMVDTSel = *BLANKS
     C                   Eval      PFSETSel = *BLANKS
     C                   Eval      PREVESel = *BLANKS
     C                   Z-Add     *Zeros        PSEQNSel

     C                   Eval      OptSelected = 'N'
     C                   Eval      KeyFrmBRW = 'N'
      *
      ** Initialize error indicators
     C                   Move      *OFF          *IN60
     C                   Move      *OFF          *IN61
      *
      ** Clear message subfile and reset error indicators.
     C                   Call      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   Write     SETRSMBRC2

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                             *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Build subfile
     C                   PARM                    PBdSfl
      *
      ** Read subfile record
     C                   PARM                    PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Key fields selected
      **  Trade Reference Number
      **  Movement Date
      **  Full Settlement
      **  Reversal
      **  Sequence Number
     C                   PARM                    PTRADSel
     C                   PARM                    PMVDTSel
     C                   PARM                    PFSETSel
     C                   PARM                    PREVESel
     C                   PARM                    PSEQNSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL

     C                   Eval      SUSER = PsUser
     C                   Eval      SWSID = PsJobName
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   Eval      ModuleID     = 'SE'
     C                   Eval      APRPRLOCN    = 'S'
     C                   Eval      APCNFVALFO   = 'N'
     C                   Eval      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
     C                   Eval      #MsgFile     = 'SEUSRMSG'
     C                   Eval      MsgFArray(1) = 'DRSMM'
     C                   Eval      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
     C                   Move      *ON           *IN97
     C                   Movel     '*'           SPGMQ
      *
      *
      ** Key lists for Security Trade Settlement Details.
      *
     C     KeyTSCD       KLIST
     C                   KFLD                    KTRAD
     C                   KFLD                    KSECS
     C                   KFLD                    KCLNT
     C                   KFLD                    KMVDT

     C     KeyTCDS       KLIST
     C                   KFLD                    KTRAD
     C                   KFLD                    KCLNT
     C                   KFLD                    KMVDT
     C                   KFLD                    KSECS

     C     KeyTCSD       KLIST
     C                   KFLD                    KTRAD
     C                   KFLD                    KCLNT
     C                   KFLD                    KSECS
     C                   KFLD                    KMVDT

     C     KeyTDSC       KLIST
     C                   KFLD                    KTRAD
     C                   KFLD                    KMVDT
     C                   KFLD                    KSECS
     C                   KFLD                    KCLNT

     C     KeySCDT       KLIST
     C                   KFLD                    KSECS
     C                   KFLD                    KCLNT
     C                   KFLD                    KMVDT
     C                   KFLD                    KTRAD

     C     KeySCTD       KLIST
     C                   KFLD                    KSECS
     C                   KFLD                    KCLNT
     C                   KFLD                    KTRAD
     C                   KFLD                    KMVDT

     C     KeySDTC       KLIST
     C                   KFLD                    KSECS
     C                   KFLD                    KMVDT
     C                   KFLD                    KTRAD
     C                   KFLD                    KCLNT

     C     KeyCDTS       KLIST
     C                   KFLD                    KCLNT
     C                   KFLD                    KMVDT
     C                   KFLD                    KTRAD
     C                   KFLD                    KSECS

     C     KeySTCD       KLIST
     C                   KFLD                    KSECS
     C                   KFLD                    KTRAD
     C                   KFLD                    KCLNT
     C                   KFLD                    KMVDT

     C     KeyCTSD       KLIST
     C                   KFLD                    KCLNT
     C                   KFLD                    KTRAD
     C                   KFLD                    KSECS
     C                   KFLD                    KMVDT

     C     KeyDTSC       KLIST
     C                   KFLD                    KMVDT
     C                   KFLD                    KTRAD
     C                   KFLD                    KSECS
     C                   KFLD                    KCLNT

      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2003
