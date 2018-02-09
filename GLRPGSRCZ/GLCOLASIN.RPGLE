     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Screen input function module')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLASIN - GL Collateral Allocation Screen Input Function   *
      *              Module                                           *
      *                                                               *
      *  Function:  This API module will serve as the screen input    *
      *             function module of the complete API program and   *
      *             will be made switchable under enhancement number  *
      *             CGL011.                                           *
      *                                                               *
      *  Called By: GLCOLLSIN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CGL072             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 20Aug03               *
      *                 CGL018             Date 27Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CGL072 - Allow GL Accounts as Collateral                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *         - Remove unused KLIST for old version of GLCOLARTV    *
      *  CGL018 - Risk Weighted Assets                                *
      *  CGL011 - Collateral Processing for Midas DBA.                *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ! Automatically included D-specs       !
      ** ! ==============================       !
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ! End of automatically included D-specs!
      ** ! =====================================!
      ** +--------------------------------------+
 
      ** Collateral Allocation File Format
     D CrCAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
      ** Collateral Allocation Old File Format
     D OldCAFilFmt   E DS                  EXTNAME(GLCOLAPD)
     D                                     PREFIX(O)
 
      ** Collateral Allocation Screen Format(Current)
     D CrCAScnFmt    E DS                  EXTNAME(GLSCLAPD)
 
      ** Collateral Allocation Screen Errors Format
     D CAESFL        E DS                  EXTNAME(GLECLAPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** SAR descriptions                                                                     CGL018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL018
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Object Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Response mode, for SPF validation
     D RespMode        S              1A   INZ('S')
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Program process indicator
     D WScrn           S              1A
 
      ** General Work indicators
     D W@TotAmt        S             15P 0
     D W@LeVal         S             15P 0
     D W@TotPct        S             10P 7
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** !                                                                !
      ** ! Initial processing is performed automatically: the *INZSR is   !
      ** ! executed at program activation.                                !
      ** !                                                                !
      ** +----------------------------------------------------------------+
 
      ** Maintenance mode
 
     C     WScrn         DowEq     'M'
     C                   ExSr      SrScrnM
     C                   EndDo
 
      ** Update mode
 
     C                   If        WScrn = 'U'
     C                   ExSr      SrUpdate
     C                   EndIf
 
      ** Terminate mode
 
     C                   If        WScrn = 'T'
     C                   Eval      *INLR = *On
     C                   Return
     C                   EndIf
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      * SrConvAmt- Convert amount of collateral statistics            *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    PRetCode          7
     C                   Parm                    PAloActn          1
     C                   Parm                    PColRef          10
     C                   Parm                    PColCur           3
     C                   Parm                    PPctAlo          11
     C                   Parm                    PLenVal          16
     C                   Parm                    OLenVal          16
     C                   Parm                    PTotAlo          16
     C                   Parm                    PGenAloUpd        1
     C                   Parm                    PNarSelec         1
     C                   Parm                    PF3Taken          1
     C                   Parm                    PRWASEL           1                          CGL018
 
      ** Parameter list for GLCOLADSP
 
     C     PGlColaDsp    PList
     C                   Parm      *Blank        RetCodeOut
     C                   Parm                    PColRef
     C                   Parm                    PColCur
     C                   Parm                    PPctAlo
     C                   Parm                    PLenVal
     C                   Parm                    OLenVal
     C                   Parm                    PTotAlo
     C                   Parm                    CrCAScnFmt
     C                   Parm                    SFLAction         2
     C                   Parm                    CAESFL
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm      '0'           W@INKC            1
     C                   Parm      '0'           W@INKL            1
     C                   Parm      '0'           W@INKP            1
     C                   Parm      '0'           W@INKQ            1
     C                   Parm                    Writeonly
     C                   Parm                    SFLEOF            1
     C                   Parm                    SBlank            1
     C                   Parm                    WchgDel           1
     C                   Parm      '0'           W@INKR            1                          CGL018
 
      ** Parameter list for GLCOLAVAL
 
     C     PGlColaVal    PList
     C                   Parm                    RespMode
     C                   Parm                    CrCAScnFmt
     C                   Parm                    CAESFL
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WmsgIdArr
     C                   Parm                    WmsgDtaArr
     C                   Parm                    Widx
     C                   Parm                    CrCAFilFmt
     C                   Parm                    PColRef
     C                   Parm                    PColCur
     C                   Parm                    SBlank
     C                   Parm                    WchgDel
     C                   Parm                    CGL072                                       CGL072
 
      ** Parameter list for GLCOLAUPD
 
     C     PGlColaUpd    PList
     C                   Parm                    RetCode           7
     C                   Parm                    CrCAFilFmt
     C                   Parm                    PColCur
 
      ***Parameter*list*for GLCOLARTV                                                         CAP084
      ******                                                                                  CAP084
     C*****PGlColaRtv    PList                                                                CAP084
     C******             Parm      *Blank        RetCode           7                          CAP084
     C******             Parm                    CrCAFilFmt                                   CAP084
     C******             Parm                    OldCAFilFmt                                  CAP084
 
      ** Parameter list for ZA0840
 
     C     PZA0840       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    W@ALPH           16
     C                   Parm                    W@IDP             3 0
     C                   Parm                    W@IINT            3 0
     C                   Parm                    W@MTID            1
     C                   Parm                    W@ERCD            1 0
     C                   Parm                    W@AMT            15 0
     C                   Parm                    BNDCSP
 
      ** Parameter list for ZA0921
 
     C     PZA0921       PList
     C                   Parm                    RetCodeOut
     C                   Parm                    WAMOUNT          15 0
     C                   Parm                    W@CDP             1 0
     C                   Parm                    BNDCSP
     C                   Parm                    W@AMTP           16
     C                   Parm                    W@AMTD           17
 
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CGL018
     C                   Z-ADD     7             DBASE                          * DBERR 07 *  CGL018
     C                   MOVEL     'CGL018'      DBKEY                          ************  CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      ** Access SAR details file to determine if CGL072 is on.                                CGL072
      *                                                                                       CGL072
     C                   CALLB     'AOSARDR0'                                                 CGL072
     C                   PARM      *BLANKS       @RTCD                                        CGL072
     C                   PARM      '*VERIFY'     @OPTN                                        CGL072
     C                   PARM      'CGL072'      @SARD                                        CGL072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL072
      *                                                                                       CGL072
     C     @RTCD         IFEQ      *BLANK                                                     CGL072
     C                   MOVE      'Y'           CGL072            1                          CGL072
     C                   ELSE                                                                 CGL072
     C                   MOVE      'N'           CGL072                                       CGL072
     C                   END                                                                  CGL072
      ** Program Name
 
     C                   Eval      DbPgm = 'GLCOLASIN'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *Lock         In        LDA
     C                   Move      *ON           *INU7
     C                   Move      *ON           *INU8                          ************
     C                   MoveL     'SDBANKPD'    DbFile                         * DBERR 01 *
     C                   Z-Add     001           Dbase                          ************
     C                   MoveL     @Optn         DbKey
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Maintenance
 
     C                   Eval      WScrn =  'M'
 
      ** Build Subfile
 
     C                   Eval      SflAction = 'BS'
 
     C                   If        (PAloActn = 'E') Or (PAloActn = 'D') Or
     C                             (PAloActn = 'X')
     C                   Eval      WriteOnly = 'Y'
     C                   Else
     C                   Eval      WriteOnly = 'N'
     C                   Endif
 
      ** Convert collateral statistics
 
     C                   Movel     'N'           WConvert          1
     c                   ExSr      SrConvAmt
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrScrnM: Maintenance Processing Routine                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * GLCOLADSP - Screen Display Function Module                    *
      *                                                               *
      *****************************************************************
 
     C     SrScrnM       BegSr
 
      ** Write/Read Display Screen
 
     C                   CallB     'GLCOLADSP'   PGlColaDsp
 
      ** Reset Error fields
 
     C                   ExSr      SRResetErr
 
     C                   If        (W@INKC = *On) Or (W@INKL = *On) Or
     C                             (W@INKP = *On) Or (W@INKQ = *On) Or
     C                             (Writeonly = 'Y')
     C                   ExSr      SrEndPr
     C                   Else
     C                   If        Writeonly = 'N'
     C                   ExSr      SrVal
     C                   EndIf
     C                   Endif
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrEndPr:  Termination Routine                              *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrEndPr       BegSr
 
     C                   Eval      WScrn = 'T'
     C                   Eval      PGenAloUpd = 'N'
 
     C                   If        W@INKC = '1'
     C                   Eval      PRetCode = 'Y2U9999'
     C                   Eval      PF3Taken = 'Y'
     C                   Eval      PNarSelec = 'N'
     C                   Endif
 
     C                   If        W@INKL = '1'
     C                   Eval      PRetCode = 'USR0790'
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PNarSelec = 'N'
     C                   Endif
 
     C                   If        W@INKP = '1'
     C                   Eval      PRetCode = *Blanks
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PNarSelec = 'N'
     C                   Endif
 
     C                   If        W@INKQ = '1'
     C                   Eval      PRetCode = *Blanks
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PNarSelec = 'Y'
     C                   Endif
 
     C                   If        W@INKR = '1'                                               CGL018
     C                   Eval      PRetCode = *Blanks                                         CGL018
     C                   Eval      PF3Taken = 'N'                                             CGL018
     C                   Eval      PRWASEL = 'Y'                                              CGL018
     C                   Endif                                                                CGL018
 
     C                   ROLBK
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrVal:  Validation Processing                              *
      *                                                               *
      * Called By: SrScrnM subroutine                                 *
      *                                                               *
      * Calls:                                                        *
      * GLCOLADSP - Screen Display Function Module                    *
      * GLCOLAVAL - Validation Module                                 *
      *                                                               *
      *****************************************************************
 
     C     SrVal         BegSr
 
      ** Reset Screen Field Error Indicators
 
     C                   Eval      CAESFL = 'YYYYYYYYYYY'
     C                   Z-Add     *Zero         Idx
     C                   Z-Add     *Zero         WIdx
 
      ** Retrieve one record from subfile ("RC" Read Change)
 
     C                   Eval      SFLAction = 'RC'
 
     C                   CallB     'GLCOLADSP'   PGlColaDsp
 
      ** Validate Record retrieved from subfile until SFLEOF equal 1
 
     C     SFLEOF        DoWEq     '0'
 
      ** Call validation module only if screen not blank
 
     C                   If        CrCAScnFmt <> *Blank
     C                   CallB     'GLCOLAVAL'   PGlColaVal
     C                   EndIf
 
      ** Retrieve one record from subfile ("UC" Read Next Change)
 
     C                   Eval      SFLAction = 'UC'
 
     C                   CallB     'GLCOLADSP'   PGlColaDsp
 
     C                   EndDo
 
      ** If Warning messages appears already, do not redisplay messages
 
     C                   If        (Idx = 0) And (WIdx <> 0)
     C                   If        WCount = 1
     C                   Movel     'N'           WDspWrn           1
     C                   Else
     C                   Movel     'Y'           WDspWrn
     C                   EndIf
     C                   EndIf
 
      ** Error found on validation routine ("RS" Redisplay Subfile)
 
     C                   If        (Idx <> 0) Or
     C                             (Idx = 0) And (WIdx <> 0) And
     C                             (WDspWrn = 'Y')
     C                   Eval      SFLAction = 'RS'
 
     C                   If        (Idx = 0) And (WIdx <> 0)
     C                   Add       1             WCount            1 0
     C                   Else
     C                   Z-Add     0             WCount
     C                   EndIf
 
     C                   Else
     C                   Eval      WScrn = 'U'
     C                   Eval      SFLAction = 'RD'
     C                   Endif
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrUpdate: Update Processing Routine                        *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * GLCOLADSP - Screen Display Function Module                    *
      * GLCOLAVAL - Validation Module                                 *
      * GLCOLAUPD - Update Module                                     *
      * SrConvAmt - Amount conversion of Collateral Statistics        *
      * SrUpdSt   - Update of collateral statistics                   *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BegSr
 
      ** Retrieve one record from subfile
 
     C                   CallB     'GLCOLADSP'   PGlColaDsp
 
      ** Update Allocation file format via validate module
 
     C     SFLEOF        DoWEq     '0'
 
      ** Call validation module only if screen not blank, otherwise skip
 
     C                   If        CrCAScnFmt <> *Blank
     C                   CallB     'GLCOLAVAL'   PGlColaVal
 
      ** Insert/Update one record to Allocation file
 
     C                   CallB     'GLCOLAUPD'   PGlColaUpd
 
     C                   If        RetCode <> *Blank
     C                   Eval      PRetCode = 'Y2U0032'
     C                   Eval      PGenAloUpd = 'N'
     C                   Eval      WScrn = 'T'
     C                   Eval      SFLEOF = '1'
     C                   Else
 
      ** Retrieve one record from subfile ("RN" Read next sfl entry)
 
     C                   Eval      SFLAction = 'RN'
 
     C                   CallB     'GLCOLADSP'   PGlColaDsp
 
     C                   EndIf
 
      ** Screen Blanks, skip record
 
     C                   Else
     C                   Eval      SFLAction = 'RN'
     C                   CallB     'GLCOLADSP'   PGlColaDsp
     C                   EndIf
 
     C                   EndDo
 
      ** No error found on update/insert
 
     C                   If        Idx = 0
      *
     C                   CALLB     'GLCOLAUPS'
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    PColRef
     C                   PARM                    W@LEVAL
     C                   PARM      0             W@TotAmt
     C                   PARM      0             W@TotPct
      *
     C     RetCodeOut    IFNE      *Blanks
      *
     C                   SELECT
      *
     C     RetCodeOut    WHENEQ    'COL0128'
     C                   Eval      Idx = 1
     C                   Eval      MsgIdArr(Idx) = 'COL0128'
     C                   Eval      FldNameArr(Idx) = '*ANY'
     C                   Eval      WScrn = 'M'
     C                   Eval      SFLAction = 'RS'
      *
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLAPD'    DbFile                         ************
     C                   Z-ADD     991           Dbase                          * DBERR 01 *
     C                   MOVEL     PColRef       DbKey                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   Eval      WScrn = 'T'
     C                   Eval      PGenAloUpd = 'Y'
     C                   Eval      PRetCode = *Blanks
     C                   Eval      WConvert = 'C'
     C                   ExSr      SrConvAmt
      *
     C                   ENDIF
      *
     C                   Endif
 
     C                   Endsr
 
      *****************************************************************
      *                                                               *
      * SR/SrConvAmt: Amount conversion of Collateral Statistics      *
      *                                                               *
      * Called By: *INZSR and SrUpdate subroutines                    *
      *                                                               *
      * Calls:                                                        *
      * AOCURRR0   Access Object                                      *
      * AODEALR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     SrConvAmt     BegSr
 
      ** Get currency number of decimal places
 
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm      PColCur       WAjcd             3
     C     SdCurr        Parm      SdCurr        Dssdy
 
     C     @Rtcd         IfNe      *BLANK
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     002           DBase                          ************
     C                   MoveL     'SDCURRPD'    DBFile                         * DBERR 02 *
     C                   MoveL     PCOlCur       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Access Dealing ICD
 
     C**********         Call      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   Parm      '*DBERR '     @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @Rtcd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     003           DBase                          ************
     C                   MoveL     'SDDEALPD'    DBFile                         * DBERR 03 *
     C                   MoveL     '*FIRST'      DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     ** Convert amount to numeric
 
     C                   If        WConvert = 'N'
 
      ** Set up parameter for ZA0840
 
     C                   Z-Add     A6NBDP        W@IDP
     C     15            Sub       W@IDP         W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     PLenVal       W@ALPH
     C                   Move      'N'           W@MTID
 
      ** Convert lending value amount field from char to numeric
 
     C                   CallB     'ZA0840'      PZA0840
 
      ** No error found on conversion
 
     C                   If        W@ERCD = 0
     C                   Z-Add     W@AMT         W@LEVAL
     C                   Else
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     004           DBase                          ************
     C                   MoveL     'ZA0840  '    DBFile                         * DBERR 04 *
     C                   MoveL     PLenVal       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Convert Total allocated amount field from char to numeric
 
     C                   Move      *Blanks       W@ALPH
     C                   Movel     PTotAlo       W@ALPH
 
     C                   CallB     'ZA0840'      PZA0840
 
      ** No error found on conversion
 
     C                   If        W@ERCD = 0
     C                   Z-Add     W@AMT         W@TOTAMT
     C                   Else
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     005           DBase                          ************
     C                   MoveL     'ZA0840  '    DBFile                         * DBERR 05 *
     C                   MoveL     PTotAlo       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Convert Allocation percentage field from char to numeric
 
     C                   Z-Add     7             W@IDP
     C                   Z-ADD     3             W@IINT
     C                   Move      *Blanks       W@ALPH
     C                   Movel     PPctAlo       W@ALPH
 
     C                   CallB     'ZA0840'      PZA0840
 
      ** No error found on conversion
 
     C                   If        W@ERCD = 0
     C     W@AMT         Div       10000000      W@TotPct
     C                   Else
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Z-Add     006           DBase                          ************
     C                   MoveL     'ZA0840  '    DBFile                         * DBERR 06 *
     C                   MoveL     PPctAlo       DBKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
     C                   EndIf
 
      ** Convert from numeric to char
 
     C                   If        WConvert = 'C'
 
      ** Set up parameter for ZA0921
 
     C                   Z-Add     A6NBDP        W@CDP
 
      ** Lending Value
 
     C                   Eval      WAMOUNT = W@LEVAL
 
     C                   CallB     'ZA0921'      PZA0921
 
     C                   Eval      PLenVal = W@AMTP
 
      ** Total Allocated
 
     C                   Eval      WAMOUNT = W@TOTAMT
 
     C                   CallB     'ZA0921'      PZA0921
 
     C                   Eval      PTotAlo = W@AMTP
 
      ** Percentage Allocation
 
     C     W@TotPct      Mult      10000000      W@PCT5           15 0
     C                   Eval      WAMOUNT = W@PCT5
     C                   Z-Add     7             W@CDP
 
     C                   CallB     'ZA0921'      PZA0921
 
     C                   Move      W@AMTP        PPctAlo
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrResetErr: Reset Error fields.                            *
      *                                                               *
      * Called By: SrScrnM and SrUpdate subroutines                   *
      *                                                               *
      *****************************************************************
     C     SRRESETERR    BEGSR
 
     C                   Eval      FldNameArr = *Blanks
     C                   Eval      MsgIdArr = *Blanks
     C                   Eval      MsgDtaArr = *Blanks
     C                   Eval      WFldNamArr = *Blanks
     C                   Eval      WMsgIdArr = *Blanks
     C                   Eval      WmsgDtaArr = *Blanks
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2002
