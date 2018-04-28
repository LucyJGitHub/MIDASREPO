     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Screen Input Function Module')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLNSIN - GL Collateral Narrative Screen Input Function    *
      *              Module                                           *
      *                                                               *
      *  Function:  This API module will serve as the screen input    *
      *             function module of the complete API program and   *
      *             will be made switchable under enhancement number  *
      *             CGL011.                                           *
      *                                                               *
      *  Called By: GLCOLLSIN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************
 
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
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Collateral Narrative File Format
     D CrCNFilFmt    E DS                  EXTNAME(GLCOLNPD)
 
      ** Collateral Narrative Screen Format(Current)
     D CrCNScnFmt    E DS                  EXTNAME(GLSCLNPD)
 
      ** Collateral Narrative Screen Errors Format
     D CNESFL        E DS                  EXTNAME(GLECLNPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Response mode, for SPF validation
     D RespMode        S              1A   INZ('S')
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Program process indicator
     D WScrn           S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
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
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    PRetCode          7
     C                   Parm                    PNarActn          1
     C                   Parm                    PColRef          10
     C                   Parm                    PGenInd           1
     C                   Parm                    PNarUpd           1
     C                   Parm                    PAloSelec         1
     C                   Parm                    PF3Taken          1
 
      ** Parameter list for GLCOLNDSP
 
     C     PGlColnDsp    PList
     C                   Parm      *Blank        RetCodeOut
     C                   Parm                    PColRef
     C                   Parm                    CrCNScnFmt
     C                   Parm                    SFLAction         2
     C                   Parm                    CNESFL
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
     C                   Parm                    PNarActn
 
      ** Parameter list for GLCOLNVAL
 
     C     PGlColnVal    PList
     C                   Parm                    RespMode
     C                   Parm                    CrCNScnFmt
     C                   Parm                    CNESFL
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WmsgIdArr
     C                   Parm                    WmsgDtaArr
     C                   Parm                    Widx
     C                   Parm                    CrCNFilFmt
     C                   Parm                    PColRef
 
      ** Parameter list for GLCOLNUPD
 
     C     PGlColnUpd    PList
     C                   Parm                    RetCode           7
     C                   Parm                    CrCNFilFmt
     C                   Parm                    WNarRlrn          3 0
 
      ** Program Name
 
     C                   Eval      DbPgm = 'GLCOLNSIN'
 
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
 
     C                   If        (PNarActn = 'E') Or (PNarActn = 'D') Or
     C                             (PNarActn = 'X')
     C                   Eval      WriteOnly = 'Y'
     C                   Else
     C                   Eval      WriteOnly = 'N'
     C                   Endif
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrScrnM: Maintenance Processing Routine                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * GLCOLNDSP - Screen Display Function Module                    *
      *                                                               *
      *****************************************************************
 
     C     SrScrnM       BegSr
 
      ** Write/Read Display Screen
 
     C                   CallB     'GLCOLNDSP'   PGlColnDsp
 
      ** Reset Error fields
 
     C                   Eval      FldNameArr = *Blanks
     C                   Eval      MsgIdArr = *Blanks
     C                   Eval      MsgDtaArr = *Blanks
     C                   Eval      WFldNamArr = *Blanks
     C                   Eval      WMsgIdArr = *Blanks
     C                   Eval      WmsgDtaArr = *Blanks
     C                   Eval      Idx = *Zero
     C                   Eval      WIdx = *Zero
 
     C                   If        (W@INKC = *On) Or (W@INKL = *On) Or
     C                             (W@INKP = *On) Or (W@INKQ = *On) Or
     C                             (Writeonly = 'Y')
     C                   ExSr      SrEndPr
     C                   Else
 
     C                   If        Writeonly = 'N'
     C                   Eval      WScrn = 'U'
     C                   Eval      SFLACtion = 'RD'
     C                   If        (PNarActn = 'I')
     C                   Z-Add     1             WNarRlrn
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
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
 
      ** Error encountered upon pressing F15, redisplay subfile
 
     C                   If        (W@INKP = '1') And (PGenInd <> 'G')
     C                   Z-Add     1             Idx
     C                   Eval      FldNameArr(Idx) = *Blank
     C                   Eval      MsgIdArr(Idx) = 'GLM0240'
     C                   Eval      SFLAction = 'RS'
     C                   Else
 
     C                   Eval      WScrn = 'T'
     C                   Eval      PNarUpd = 'N'
 
     C                   If        W@INKC = '1'
     C                   Eval      PRetCode = 'Y2U9999'
     C                   Eval      PF3Taken = 'Y'
     C                   Eval      PAloSelec = 'N'
     C                   Endif
 
     C                   If        W@INKL = '1'
     C                   Eval      PRetCode = 'USR0790'
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PAloSelec = 'N'
     C                   Endif
 
     C                   If        W@INKP = '1'
     C                   Eval      PRetCode = *Blanks
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PAloSelec = 'Y'
     C                   Endif
 
     C                   If        W@INKQ = '1'
     C                   Eval      PRetCode = *Blanks
     C                   Eval      PF3Taken = 'N'
     C                   Eval      PAloSelec = 'N'
     C                   Endif
     C                   Endif
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrUpdate: Update Processing Routine                        *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * GLCOLNDSP - Screen Display Function Module                    *
      * GLCOLNVAL - Validation Module                                 *
      * GLCOLNUPD - Update Module                                     *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BegSr
 
      ** Retrieve one record from subfile
 
     C                   CallB     'GLCOLNDSP'   PGlColnDsp
 
      ** Update Narrative file format via validate module
 
     C     SFLEOF        DoWEq     '0'
     C                   CallB     'GLCOLNVAL'   PGlColnVal
 
      ** Insert/Update one record to Narrative file
 
     C                   CallB     'GLCOLNUPD'   PGlColnUpd
 
     C                   If        RetCode <> *Blank
     C                   Eval      PRetCode = 'Y2U0032'
     C                   Eval      PNarUpd = 'N'
     C                   Eval      WScrn = 'T'
     C                   Eval      SFLEOF = '1'
     C                   Else
 
      ** Retrieve one record from subfile
 
     C                   CallB     'GLCOLNDSP'   PGlColnDsp
 
     C                   EndIf
     C                   EndDo
 
      ** No error found on update/insert
 
     C                   If        Idx = 0
     C                   Eval      WScrn = 'T'
     C                   Eval      PNarUpd = 'Y'
     C                   Eval      PRetCode = *Blanks
     C                   Endif
 
     C                   Endsr
 
      ****************************************************************
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
(c) Misys International Banking Systems Ltd. 2001
