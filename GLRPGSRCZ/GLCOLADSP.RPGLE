     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Screen display function maintenance')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLADSP - GL Collateral Allocation Display Function Module *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of the complete API program and      *
      *             will be made switchable under enhancement number  *
      *             CGL011.                                           *
      *                                                               *
      *  Called By: GLCOLASIN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 13Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Recompiled over changed GLCOLAPD format.            *
      *  CGL011 - Collateral Processing for Midas.                    *
      *                                                               *
      *****************************************************************
 
     FGLCOLADDF CF   E             WORKSTN SFILE(GLCOLAS0:SRLRN)
     FGLCOLAL2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Collateral Allocation File Format
     D CrCAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
      ** Collateral Allocation Screen Format(Current)
     D GLCOLA        E DS                  EXTNAME(GLSCLAPD)
 
      ** Collateral Allocation Screen Errors Format
     D CAESFL        E DS                  EXTNAME(GLECLAPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Screen Fields Data Structure
     D ScrnFlds        DS
     D  SActn                  1      1
     D  SBrca                  2      4
     D  SCusN                  5     14
     D  SModI                 15     16
     D  SPrSq                 17     19
     D  SFcty                 20     30
     D  SFcty1                20     25
     D  SFcty2                26     28
     D  SFcty3                29     30
     D  SLnLm                 31     36
     D**SReAc***              37     54                                                       CGL029
     D**SAMPC***              55     55                                                       CGL029
     D**SAmnt***              56     71                                                       CGL029
     D**SPrct***              72     77                                                       CGL029
     D  SReAc                 37     60                                                       CGL029
     D  SAMPC                 61     61                                                       CGL029
     D  SAmnt                 62     77                                                       CGL029
     D  SPrct                 78     83                                                       CGL029
 
      ** Current screen excluding action code(use to determine changes from
      ** the previous screen)
     D**WCurScrn               2     77                                                       CGL029
     D  WCurScrn               2     83                                                       CGL029
 
      ** Array to save previous screen excluding action code
     D*SvPrvScrn       S             76A   DIM(100)                                           CGL029
     D SvPrvScrn       S             82A   DIM(100)                                           CGL029
 
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
 
      ** Read Change in subfile
 
     C     SFLAction     CasEq     'RC'          SrRdChg
 
      ** Update current subfile and read next change
 
     C     SFLAction     CasEq     'UC'          SrUpdRcg
 
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
     C                   Parm                    PColCur           3
     C                   Parm                    PPctAlo          11
     C                   Parm                    PLenVal          16
     C                   Parm                    OLenVal          16
     C                   Parm                    PTotAlo          16
     C                   Parm                    GLCOLA
     C                   Parm                    SFLAction         2
     C                   Parm                    CAESFL
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
     C                   Parm                    SBlank            1
     C                   Parm                    WChgDel           1
 
      ** Format Program Details
 
     C                   Eval      DbPgm = 'GLCOLADSP'
 
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
      *
      ** Call SDRTVTXT pgm to access text for a field used in the SFL
      *
      ** Separator Line
     C                   MOVEL     'ZZN0852'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM006
      *
      ** Action
     C                   MOVEL     'ZZN7179'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM007
      *
      ** Branch
     C                   MOVEL     'ZZM0031'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM008
      *
      ** Customer
     C                   MOVEL     'ZZN3942'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM009
      *
      ** Module
     C                   MOVEL     'ZZN7180'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM010
      *
      ** Priority
     C                   MOVEL     'ZZN7181'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM011
      *
      ** Facility
     C                   MOVEL     'ZZN7182'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM012
      *
      ** Loan/Limit
     C                   MOVEL     'ZZN7183'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM013
      *
      ** A/c
     C                   MOVEL     'ZZN7184'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM014
      *
      ** Amount/Percentage
     C                   MOVEL     'ZZN7185'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM015
      *
      ** Amount
     C                   MOVEL     'ZZM0081'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM016
      *
      ** Percentage
     C                   MOVEL     'ZZN7186'     MSGDNB
     C                   EXSR      SrRtvTxt
     C                   MOVEL     MSGTXT        ZZM017
      *
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
     C                   Eval      SLenVal = PLenVal
     C                   Eval      SOLenVl = OLenVal
     C                   Eval      SPerAlo = PPctAlo
     C                   Eval      STotAlo = PTotAlo
 
      ** Seton protect indicators from *IN30 to *IN40
 
     C                   If        WriteOnly = 'Y'
     C                   MoveA     '11111111111' *IN(30)
     C                   EndIf
 
      ** Initialise Subfile control indicators and Subfile next change
 
     C                   MoveA     '0000'        *IN(41)
 
      ** Initialise subfile error indicators
 
     C                   MoveA     '00000000000' *IN(50)
 
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
      * SR/SrBldSfl: Initial SFL build and converse processing        *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrBldPag - Build subfile page                                 *
      * SrExTrTn - Exit processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SrBldSfl      BegSr
 
      ** Clear subfile
 
     C                   Move      *On           *IN41
     C                   Write     GLCOLAC0
     C                   Move      *Off          *IN41
 
      ** Initialise last relative record no. and WErrPtr workfields
 
     C                   Z-Add     0             SRC
     C                   Z-Add     0             WLrcd             4 0
     C                   Z-Add     0             WErrPtr           4 0
 
      ** Reset Collateral reference file to top of file
 
     C     PColRef       Setll     GLCOLAD0                               61
 
     C                   Move      'N'           W@Exit            1
 
      ** Build subfile page until request to exit has been made
 
     C     W@Exit        DoWEq     'N'
     C                   ExSr      SrBldPag
     C                   Write     GLCOLAH0
     C                   Write     GLCOLAF0
     C                   ExFmt     GLCOLAC0
 
      ** Rollup pressed, build subfile
 
     C                   If        *IN44 = *On
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
      * Calls:                                                        *
      * SrRstFld   - Reset screen fields to blanks                    *
      * GLCOLACVT  - Convert module                                   *
      *                                                               *
      *****************************************************************
 
     C     SrBldPag      BegSr
 
      ** Initialise Subfile and Array record counter
 
     C                   Z-Add     1             WRCtr             4 0
     C                   Z-Add     WLrcd         SRlrn
 
      ** Initialize Display indicator
 
     C                   Eval      *IN45 = *On
 
      ** Retrieve record
 
     C     PColRef       ReadE     GLCOLAD0                               61
 
      ** If Enquiry or Delete mode and no record matched, set *Off display
      ** indicator
 
     C                   If        WriteOnly = 'Y' and *IN61 = *On
     C                   Eval      *IN45 = *Off
     C                   EndIf
 
     C     WRCtr         DoWLE     4
     C     WriteOnly     AndEq     'N'
     C     SRlRn         AndLe     100
     C     WRCtr         OrLE      4
     C     WriteOnly     AndEq     'Y'
     C     *IN61         AndEq     *Off
 
     C     *IN61         IfEq      *On
     C                   ExSr      SrRstFld
     C                   Eval      SBlank = 'Y'
 
      ** Enable all fields for input, excluding action code field
 
     C                   MoveA     '10000000000' *IN(30)
     C                   Else
 
      ** Convert file fields to screen field
 
     C                   CallB     'GLCOLACVT'
     C                   Parm      *Blank        RetCodeOut
     C                   Parm                    CrCAFilFmt
     C                   Parm                    GLCOLA
     C                   Parm                    PColCur
     C
     C                   Eval      ScrnFlds = GLCOLA
     C                   Eval      SBlank = 'N'
 
      ** Load Screen fields to array SvPrvScrn, excluding action code
 
     C                   Add       1             SRC
     C                   Move      ScrnFlds      SvPrvScrn(SRC)
 
      ** Protect non-input capable fields for Amend, else Protect all for En
      ** quiry and delete mode
 
     C                   If        WriteOnly = 'N'
     C                   MoveA     '01110111000' *IN(30)
     C                   Else
     C                   MoveA     '11111111111' *IN(30)
     C                   EndIf
     C                   EndIf
 
      ** Write record to subfile
 
     C                   Add       1             WRCtr
     C                   Add       1             SRlrn
 
     C                   Write     GLCOLAS0
 
     C                   If        *IN61 = *Off
     C     PColRef       ReadE     GLCOLAD0                               61
     C                   EndIf
     C                   EndDo
 
      ** Enable subfile end for action 'E' or 'D' if End of File reached
      ** or for Amend/Insert if record exceeds the limit 100
 
     C                   If        (WriteOnly = 'Y') And (*IN61 = *On) Or
     C                             (WriteOnly = 'N') And (SRlrn >= 100)
     C                   Eval      *IN43 = *On
     C                   Else
     C                   Eval      *IN43 = *Off
 
      ** Set the record pointer to the previous record being retrieved by
      ** READPE if not yet end of file
 
     C                   If        *IN61 = *Off
     C     PColRef       ReadPE    GLCOLAD0                               61
     C                   EndIf
     C                   EndIf
 
      ** Save last relative record number to workfield
 
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
      * SR/SrRdChg: Read Change in Subfile                            *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrRdSflChg  - Read subfile change                             *
      *                                                               *
      *******************b*********************************************
 
     C     SrRdChg       BegSr
 
      ** Reposition subfile pointer to top of subfile
 
     C                   Z-Add     1             SRlRn
 
      ** Read changes in subfile
 
     C                   ExSr      SrRdSflChg
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrRdSflChg: Request to read subfile changed record         *
      *                                                               *
      * Called By: SrRdChg and SrUpdRcg subroutines                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRdSflChg    BegSr
 
     C                   ReadC     GLCOLAS0                               62
 
     C                   If        *IN62 = *On
     C                   Eval      SFLEOF = '1'
     C                   Else
     C                   Eval      SFLEOF = '0'
     C                   Eval      GLCOLA = ScrnFlds
 
     C                   If        (SBlank = 'Y') And (SActn = *Blank) And
     C                             (WCurScrn <> *Blanks)
     C                   Eval      SACTN = 'I'
     C                   Eval      ADACTN = 'I'
     C                   Else
 
     C                   If        (ADACTN = *Blank) And (SActn = *Blank) And
     C                             (WCurScrn <> *Blanks)
     C                   Eval      SACTN = 'A'
     C                   Eval      ADACTN = 'A'
     C                   EndIf
     C                   EndIf
 
      ** Action is 'D' and a change in record occurs
 
     C                   If        (SActn = 'D') And
     C                             (WCurScrn <> SvPrvScrn(SRC))
     C                   Eval      WChgDel = 'Y'
     C                   Else
     C                   Eval      WChgDel = 'N'
     C                   EndIf
 
     C                   EndIf
 
     C                   Return
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrUpdRcg: Update curr slf rec and read next change         *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrRdSflChg - Read subfile change                              *
      *                                                               *
      *****************************************************************
 
     C     SrUpdRcg      BegSr
 
      ** WChgDel is 'Y', put back the previous screen
 
     C                   If        WChgDel = 'Y'
     C                   Move      SvPrvScrn(SRC)ScrnFlds
     C                   Else
 
      ** Copy validated fields from GLSCLAPD to screen fields
 
     C                   Eval      ScrnFlds = GLCOLA
     C                   EndIf
 
      ** Enable all fields for input, excluding action code field
 
     C                   If        SBlank = 'Y'
     C                   MoveA     '10000000000' *IN(30)
     C                   EndIf
 
      ** Enable input fields for amend mode
 
     C                   If        SBlank = 'N'
     C                   MoveA     '01110111000' *IN(30)
     C                   EndIf
 
      ** Check If screen fields from CAESFL are all OK
 
     C                   If        OkActn <> 'Y'
     C                   Eval      *IN50 = *On
     C                   EndIf
     C                   If        OkBrca <> 'Y'
     C                   Eval      *IN51 = *On
     C                   EndIf
     C                   If        OkCusn <> 'Y'
     C                   Eval      *IN52 = *On
     C                   EndIf
     C                   If        OkModi <> 'Y'
     C                   Eval      *IN53 = *On
     C                   EndIf
     C                   If        OkPrsq <> 'Y'
     C                   Eval      *IN54 = *On
     C                   EndIf
     C                   If        OkFcty <> 'Y'
     C                   Eval      *IN55 = *On
     C                   EndIf
     C                   If        OkLnLM <> 'Y'
     C                   Eval      *IN56 = *On
     C                   EndIf
     C                   If        OkReac <> 'Y'
     C                   Eval      *IN57 = *On
     C                   EndIf
     C                   If        OkAmpc <> 'Y'
     C                   Eval      *IN58 = *On
     C                   EndIf
     C                   If        OkAmnt <> 'Y'
     C                   Eval      *IN59 = *On
     C                   EndIf
     C                   If        OkPrct <> 'Y'
     C                   Eval      *IN60 = *On
     C                   EndIf
     C                   Eval      *IN42 = *On
     C                   Update    GLCOLAS0
     C                   Eval      *IN42 = *Off
 
      ** Error on screen fields
 
     C                   If        (CAESFL <> 'YYYYYYYYYYY') And
     C                             (WErrPtr = 0)
     C                   Eval      WErrPtr = SRlRn
     C                   EndIf
 
      ** Initialise ok flags
 
     C                   Eval      CAESFL = 'YYYYYYYYYYY'
 
     C                   ExSr      SrRdSflChg
 
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
 
      ** If WErrPtr is not zero, set subfile relative record no. by WErrPtr
 
     C                   If        WErrPtr <> 0
     C                   Eval      SRlrn = WErrPtr
     C                   EndIf
 
     C                   Z-Add     0             WErrPtr
 
     C                   Eval      W@Exit = 'N'
 
      ** Redisplay subfile until request to exit has been made
 
     C     W@Exit        DowEq     'N'
     C                   Write     GLCOLAH0
     C                   Write     GLCOLAF0
     C                   Write     GLCOLAC1
     C                   ExFmt     GLCOLAC0
 
      ** Process subfile
 
     C                   If        *IN44 = *On
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
      * Called By: Main Routine, SrRdchg and SrUpdRcg subroutines     *
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
 
     C                   ReadC     GLCOLAS0                               62
 
     C                   If        *IN62 = *On
     C                   Eval      SFLEOF = '1'
     C                   Else
     C                   Eval      SFLEOF = '0'
     C                   Eval      GLCOLA = ScrnFlds
 
     C                   If        (SBlank = 'Y') And (SActn = *Blank) And
     C                             (WCurScrn <> *Blanks)
     C                   Eval      SACTN = 'I'
     C                   Eval      ADACTN = 'I'
     C                   Else
 
     C                   If        (ADACTN = *Blank) And (SActn = *Blank) And
     C                             (WCurScrn <> *Blanks)
     C                   Eval      SACTN = 'A'
     C                   Eval      ADACTN = 'A'
     C                   EndIf
     C                   EndIf
 
      ** Action is 'D' and a change in record occurs
 
     C                   If        (SActn = 'D') And
     C                             (WCurScrn <> SvPrvScrn(SRC))
     C                   Eval      WChgDel = 'Y'
     C                   Else
     C                   Eval      WChgDel = 'N'
     C                   EndIf
 
     C                   EndIf
 
     C                   Return
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrRstFld: Reset Screen Fields to blanks                    *
      *                                                               *
      * Called By: SrBldPag subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRstFld      BegSr
 
     C                   Eval      SActn = *Blanks
     C                   Eval      SBrca = *Blanks
     C                   Eval      SCusN = *Blanks
     C                   Eval      SModI = *Blanks
     C                   Eval      SPrSq = *Blanks
     C                   Eval      SFcty  = *Blanks
     C                   Eval      SLnLm  = *Blanks
     C                   Eval      SReAc  = *Blanks
     C                   Eval      SAMPC  = *Blanks
     C                   Eval      SAmnt = *Blanks
     C                   Eval      SPrct  = *Blanks
 
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
      *                                                               *
      *  SrRtvTxt - Retrieve text narrative for subfile               *
      *                                                               *
      *****************************************************************
     C     SrRtvTxt      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
      *
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
(c) Finastra International Limited 2001
