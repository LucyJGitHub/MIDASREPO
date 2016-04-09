     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Screen Display Function Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLNDSP - GL Collateral Narrative Display Function Module  *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of the complete API program and      *
      *             will be made switchable under enhancement number  *
      *             CGL011.                                           *
      *                                                               *
      *  Called By: GLCOLNSIN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. 176609             Date 21Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  176609 - Narrative should allow 999 lines.                   *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************
 
     FGLCOLNDDF CF   E             WORKSTN SFILE(GLCOLNS0:SRLRN)
     FGLCOLNL1  IF   E           K DISK    INFSR(*PSSR)
 
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
     D GLCOLN        E DS                  EXTNAME(GLSCLNPD)
 
      ** Collateral Narrative Screen Errors Format
     D CNESFL        E DS                  EXTNAME(GLECLNPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Screen Fields Data Structure
     D ScrnFlds        DS
     D  SRlrn                  1      3  0
     D  SActn                  4      4
     D  SNarr                  5     83
 
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
 
      ** Initialise header and protect indicators and load messages to sub-
      ** file message queue using ZA0340 and ZA0350.
 
     C                   ExSr      SrInzHdr
 
      ** Build Subfile
 
     C     SFLAction     CasEq     'BS'          SrBldSfl
 
      ** Redisplay subfile
 
     C     SFLAction     CasEq     'RS'          SrRdsSfl
 
      ** Read subfile record
 
     C     SFLAction     CasEq     'RD'          SrRdSfl
 
      ** Read next subfile record
 
     C     SFLAction     CasEq     'RN'          SrRNxSfl
     C                   EndCs
 
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
     C                   Parm                    RetCodeOut
     C                   Parm                    PColRef          10
     C                   Parm                    GLCOLN
     C                   Parm                    SFLAction         2
     C                   Parm                    CNESFL
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    P@INKC            1
     C                   Parm                    P@INKL            1
     C                   Parm                    P@INKP            1
     C                   Parm                    P@INKQ            1
     C                   Parm                    Writeonly
     C                   Parm                    SFLEOF            1
     C                   Parm                    PNarActn          1
 
      ** Format Program Details
 
     C                   Eval      DbPgm = 'GLCOLNDSP'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   MoveL     'SDBANKPD'    DbFile                         ************
     C                   Z-Add     001           Dbase                          * DBERR 01 *
     C                   MoveL     @Optn         DbKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Initialise subfile program queue and message file
 
     C                   MoveL     '*'           DDPGMQ
     C                   MoveL     'GLUSRMSG'    WZMsgFile
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SRInzHdr: Initialisation of header and work indicators     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrInzHdr      BegSr
 
      ** Format header and sub header
 
     C                   Eval      SJob = PsJobName
     C                   Eval      SUser = PsUser
     C                   Eval      SMrdt = BJMRDT
     C                   Eval      SColRef = PColRef
 
      ** Seton protect indicator
 
     C                   If        WriteOnly = 'Y'
     C                   Eval      *IN31 = *On
     C                   EndIf
 
      ** Initialise Subfile control indicators and Subfile next change
 
     C                   Move      *Off          *IN30
     C                   MoveA     '000'         *IN(41)
 
      ** Write error messages to subfile when error or warning messages
      ** found
 
     C                   Z-Add     1             C                 2 0
     C     C             DowLe     ArrayMax
     C     MsgIdArr(C)   AndNe     *Blank
     C                   MoveL     MsgIdArr(C)   WMsgId            7
     C                   MoveL     MsgDtaArr(C)  WMsgDta          45
     C                   If        WMsgDta = *Blanks
     C                   ExSr      SrErrId
     C                   Else
     C                   ExSr      SrErrDta
     C                   EndIf
     C                   Add       1             C
     C                   EndDo
 
     C                   Z-Add     1             C                 2 0
     C     C             DowLe     ArrayMax
     C     WMsgIdArr(C)  AndNe     *Blank
     C                   MoveL     WMsgIdArr(C)  WMsgId
     C                   MoveL     WMsgDtaArr(C) WMsgDta
     C                   If        WMsgDta = *Blanks
     C                   ExSr      SrErrId
     C                   Else
     C                   ExSr      SrErrDta
     C                   EndIf
     C                   Add       1             C
     C                   EndDo
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrBldSfl: Initial SFL build processing                     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrBldPag - Build subfile page                                 *
      * SrExTrTn - Exit processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SrBldSfl      BegSr
 
      ** Initialise last relative record no. and WErrPtr workfields
 
     C                   Z-Add     0             SRlrn
     C                   Z-Add     0             WLrcd             3 0
     C                   Z-Add     0             WErrPtr           4 0
 
      ** Clear subfile
 
     C                   Move      *On           *IN41
     C                   Write     GLCOLNC0
     C                   Move      *Off          *IN41
 
      ** Reset Collateral reference file to top of file
 
     C     PColRef       Setll     GLCOLND0                               50
 
      ** Setup action code screen field for insert if no record matched,
      ** else setup field for amend (WriteOnly = 'N')
 
     C                   If        WriteOnly = 'N'
     C                   If        *IN50 = *Off
     C                   Eval      SActn = 'I'
     C                   Eval      PNarActn = 'I'
     C                   Else
     C                   Eval      SActn = 'A'
     C                   Eval      PNarActn = 'A'
     C                   EndIf
 
     C                   Else
 
      ** Setup field for Enquiry or Delete
 
     C                   Eval      SActn = PNarActn
     C                   EndIf
 
     C                   Move      'N'           W@Exit            1
 
      ** Build subfile page until request to exit has been made
 
     C     W@Exit        DoWEq     'N'
     C                   ExSr      SrBldPag
     C                   Write     GLCOLNH0
     C                   Write     GLCOLNF0
     C                   ExFmt     GLCOLNC0
 
      ** Rollup pressed, build subfile
 
     C                   If        *IN43 = *On
     C                   Eval      W@Exit = 'N'
     C                   Else
 
      ** F3, F12, F15, F16 and Enter pressed
 
     C                   Eval      W@Exit = 'Y'
     C                   EndIf
 
     C                   EndDo
     C                   Exsr      SrExTrTn
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrBldPag: Build a page of subfile                          *
      *                                                               *
      * Called By: SrBldSfl subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrBldPag      BegSr
 
      ** Initialise Subfile and Array record counter
 
     C                   Z-Add     1             WRCtr             4 0
     C                   Z-Add     WLrcd         SRlrn
 
      ** Initialize Display indicator
 
     C                   Eval      *IN44 = *On
 
      ** Retrieve record
 
     C     PColRef       ReadE     GLCOLND0                               50
 
      ** If Enquiry or Delete mode and no record matched, set *Off display
      ** indicator
 
     C                   If        WriteOnly = 'Y' and *IN50 = *On
     C                   Eval      *IN44 = *Off
     C                   EndIf
 
      ** Load records to subfile until the whole of subfile page is filled
 
     C     WRCtr         DoWLe     16
     C     WriteOnly     AndEq     'N'
     C     SRlrn         AndLt     999                                          176609
     C     WRCtr         OrLE      16
     C     WriteOnly     AndEq     'Y'
     C     *IN50         AndEq     *Off
     C     SRlrn         AndLt     999                                          176609
 
      ** Insert mode
 
     C     *IN50         IfEq      *On
     C                   Eval      SNarr = *Blank
 
      ** Enable field for input
 
     C                   Eval      *IN31 = *Off
     C                   Else
 
      ** Move file narrative to subfile narrative(Amend/Enquire/Delete Mode)
 
     C                   Eval      SNarr = CNNARR
 
      ** Protect non-input capable fields for Amend, else Protect all for En
      ** quiry and delete mode
 
     C                   If        WriteOnly = 'N'
     C                   Move      *Off          *IN31
     C                   Else
     C                   Move      *On           *IN31
     C                   EndIf
     C                   EndIf
 
      ** Write record to subfile
 
     C                   Add       1             WRCtr
     C                   Add       1             SRlrn
 
     C                   Write     GLCOLNS0
 
     C                   If        *IN50 = *Off
     C     PColRef       ReadE     GLCOLND0                               50
     C                   EndIf
     C                   EndDo
 
      ** Enable subfile end for action 'E' or 'D' if End of File reached
      ** or action 'I' or 'A' and maximum limit (999 lines) is reached          176609
 
     C                   If        (WriteOnly = 'Y') And (*IN50 = *On)
     C                             Or (SRlrn >= 999)                            176609
     C                   Eval      *IN42 = *On
     C                   Else
     C                   Eval      *IN42 = *Off
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   If        *IN50 = *Off
     C     PColRef       ReadPE    GLCOLND0                               50
     C                   EndIf
     C                   EndIf
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-Add     SRlrn         WLrcd
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrExTrTn: Exit Processing                                  *
      *                                                               *
      * Called By: SrBldSfl subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrExTrTn      BegSr
 
     C                   Select
 
      ** Function key F3 pressed
 
     C     *IN03         WhenEq    *On
     C                   Eval      P@INKC = '1'
 
      ** Function key F12 pressed
 
     C     *IN12         WhenEq    *On
     C                   Eval      P@INKL = '1'
 
      ** Function key F15 pressed
 
     C     *IN15         WhenEq    *On
     C                   Eval      P@INKP = '1'
 
      ** Function key F16 pressed
 
     C     *IN16         WhenEq    *On
     C                   Eval      P@INKQ = '1'
     C                   EndSl
 
     C                   Return
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrRdSSfl: Redisplay Subfile                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrBldPag  - Build subfile                                     *
      * SrExTrTn  - Exit processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRdSSfl      BegSr
 
     C                   Z-Add     0             WErrPtr
 
     C                   Eval      W@Exit = 'N'
 
      ** Redisplay subfile until request to exit has been made
 
     C     W@Exit        DowEq     'N'
     C                   Write     GLCOLNH0
     C                   Write     GLCOLNF0
     C                   Write     GLCOLNC1
     C                   ExFmt     GLCOLNC0
 
      ** Process subfile (Rollup is pressed)
 
     C                   If        *IN43 = *On
     C                   ExSr      SrBldPag
     C                   Eval      W@Exit = 'N'
     C                   Else
 
      ** F3, F12, F15, F16 and Enter pressed
 
     C                   Eval      W@Exit = 'Y'
     C                   EndIf
     C                   EndDo
     C                   Exsr      SrExTrTn
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrRdSfl: Read Subfile record                               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrRnxSfl   - Read next subfile record                         *
      *                                                               *
      *****************************************************************
 
     C     SrRdSfl       BegSr
 
      ** Set subfile pointer to top of file
 
     C                   Z-Add     1             SRlRn
     C                   ExSr      SrRNxSfl
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrRNxSfl: Read next Subfile record                         *
      *                                                               *
      * Called By: Main Routine and SrRdSfl subroutine                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRNxSfl      BegSr
 
     C                   ReadC     GLCOLNS0                               51
 
     C                   If        *IN51 = *On
     C                   Eval      SFLEOF = '1'
     C                   Else
     C                   Eval      SFLEOF = '0'
     C                   Eval      GLCOLN = ScrnFlds
     C                   EndIf
 
     C                   Return
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrErrDta: Output error messages with data                  *
      *                                                               *
      * Called By: SrInzHdr subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZA0340   - Add messages to pgm subfile message queue          *
      *                                                               *
      *****************************************************************
 
     C     SrErrDta      BegSr
 
     C                   Eval      WZMsgId = *Blank
     C                   Eval      WZMsgId = WMsgId
 
     C                   Call      'ZA0350'
     C                   Parm                    WZMsgFile        10
     C                   Parm                    WZMsgId          10
     C                   Parm      WMsgDta       WZMsgData        45
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrErrId: Output error message without data                 *
      *                                                               *
      * Called By: SrInzHdr subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZA0340   - Add messages to pgm subfile message queue          *
      *                                                               *
      *****************************************************************
 
     C     SrErrId       BegSr
 
     C                   Eval      WZMsgId = *Blank
     C                   Eval      WZMsgId = WMsgId
 
     C                   Call      'ZA0340'
     C                   Parm                    WZMsgFile
     C                   Parm                    WZMsgId
 
     C                   EndSr
 
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
