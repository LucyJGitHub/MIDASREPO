     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate RFT Credit Detail screen 1')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1013VL - Validate MT101 Credit detail screen 1            *
      *                                                               *
      *  Function: This Program Validates screen 1 of the RFT Credit  *
      *            transaction maintenance function (FTM1011DP).      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      *                 CAP084             Date 15Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178183             Date 26Apr00               *
      *                 CFT006  *CREATE    Date 13Oct99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  178751 - Auto generation of references                       *
      *  178183 - Reassign a duplicate record                         *
      *  CFT006 - Swift Messages MT101/MT102                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PCUSTRF_H    E                     EXTFLD(PCUSTRF)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for first screen
     D OKFlagDS      E DS                  EXTNAME(FTE101S1PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
     D #I              S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FT101CV001
 
      **************   Call Validation Modules in Sequence   **************
 
      ** Request for Transfer Id (only in 'Reassign' mode)
 
     C                   IF        ActionCode = 'R'
      /COPY WNCPYSRC,FT101CV002
 
     C                   EXSR      @RFTId
      *                                                                         178751
      ***Transaction*Reference****************************************    178183178751
      *                                                                         178183
     C*******************EXSR      @TrnsRef                               178183178751
      *                                                                         178183
 
     C                   Else
      /COPY WNCPYSRC,FT101CV003
 
      ** Transaction Reference
 
      /COPY WNCPYSRC,FT101CV004
 
     C                   EXSR      @TrnsRef
 
      /COPY WNCPYSRC,FT101CV005
 
      ** Beneficiary
 
      /COPY WNCPYSRC,FT101CV006
 
     C                   EXSR      @Benef
 
      /COPY WNCPYSRC,FT101CV007
 
      ** Account with institution
 
      /COPY WNCPYSRC,FT101CV008
 
     C                   EXSR      @AWI
 
      /COPY WNCPYSRC,FT101CV009
 
      * Field Intermediary
 
      /COPY WNCPYSRC,FT101CV010
 
     C                   Exsr      @Inter
 
      /COPY WNCPYSRC,FT101CV011
 
      * Field Instructing Party
 
      /COPY WNCPYSRC,FT101CV012
 
     C                   Exsr      @InsPty
 
      /COPY WNCPYSRC,FT101CV013
 
      * Field Ordering Customer
 
      /COPY WNCPYSRC,FT101CV014
 
     C                   Exsr      @OrdCust
 
      /COPY WNCPYSRC,FT101CV015
 
      * Field Account Servicing Institution
 
      /COPY WNCPYSRC,FT101CV016
 
     C                   Exsr      @ASI
 
     C                   Endif
      /COPY WNCPYSRC,FT101CV017
 
      * Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @RFTId - Validate RFT Id
      *****************************************************************
     C     @RFTID        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PRFTHDR'
 
      ** Validate
     C                   CALLB     'FTVRFRF01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @TrnsRef - Validate Transaction Reference
      *****************************************************************
     C     @TrnsRef      BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PTRNSID'
 
      ** Validate
     C                   CALLB     'FTVTRRF01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @Benef - Validate Beneficiary
      *****************************************************************
     C     @Benef        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C*******************Eval      DDSName = 'TBNA35'                           CAP084
     C                   Eval      DDSName = 'PBNA35'                           CAP084
 
      ** Validate ALL beneficiary fields at once.  If an error in any field,
      ** only TBNA35 is highlighted.
 
     C                   CALLB     'FTVBEBE01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @AWI - Validate Account with Institution
      *****************************************************************
     C     @AWI          BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PACA35'
 
      ** Validate ALL 6 fields at once.
 
     C                   CALLB     'FTVACIS01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @Inter - Validate Intermediary
      *****************************************************************
     C     @Inter        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PINST1'
 
      ** Validate ALL 6 fields at once.
 
     C                   CALLB     'FTVIYIY01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @InsPty - Validate Instructing Party
      *****************************************************************
     C     @InsPty       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PINPTY'
 
      ** Validate
 
     C                   CALLB     'FTVDEPY01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @OrdCust - Validate Ordering Customer
      *****************************************************************
     C     @OrdCust      BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'POCUS1'
 
      ** Validate all 5 fields at once
 
     C                   CALLB     'FTVORCS01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** @ASI - Validate Account Servicing Institution
      *****************************************************************
     C     @ASI          BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C                   Eval      DDSName = 'PASI35'
 
      ** Validate both fields at once
 
     C                   CALLB     'FTVDEAC01'   P#List
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCodeIn        10
      * Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    ActionCode        1
 
      * Header information (DS) from source system in screen format
     C                   PARM                    HdrRcdIn
      * Detail information (DS) from source system in screen format
     C                   PARM                    DtlRcdIn
 
      * OK Flags Data Structure - Screen 1 only
     C                   PARM                    OkFlagDS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIx
 
 
      ** Set up the name of the MSGF from which the message handler
      ** will get the messages.
     C                   Eval      #MsgFile = 'FTUSRMSG'
 
      ** General parameter list.
     C     P#List        PLIST
      * INPUTS
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode
      *  Header record in screen format
      *  Detail record in screen format
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset work error arrays.  Called before each      *
      *             low-level validation module (CTR modules).        *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      DDSName = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *             from each validation module.                      *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
      *
      * Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
      *
      * Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIx = #I - 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
