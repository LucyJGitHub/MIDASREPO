     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Sub-Type')
 
 
      *  Midas - Standard subprograms                                 *
 
      *  FTVSTST01  - Validate Sub-Type                               *
 
      *  (c) Finastra International Limited 2001                      *
 
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
 
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CDL038             Date 10May05               *
      *                 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184167             Date 27Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                    Date ddmmmyy               *
 
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184167 - Transaction type/sub type combination validation    *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FSDDLSTL1  IF   E           K DISK
     FFDDTSTL1  IF   E           K DISK                                         184167
 
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D P@FMT         E DS                  EXTNAME(SDDLSTPD)
      * @ASRECO - Deal Sub-types record format data structure
 
     D GenOkFlag       S              1    Import
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Klist fields                                                           184167
     D K_DTPE11        S                   LIKE(DTPE11)                         184167
     D K_DLST11        S                   LIKE(DLST11)                         184167
                                                                                184167
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
 
     C                   CallB     'AODLSTR0'
     C                   Parm                    P@RTCD            7
     C                   Parm      '*VERIFY'     P@OPTN            7
     C                   Parm                    PPYST
     C                   Parm                    P@FMT
 
     C     P@RTCD        Ifne      *Blanks
     C                   Eval      GenOkFlag = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0006'
     C                   Eval      RetCodeIn = 'Error'
     C                   Endif
                                                                                184167
     C                   Eval      K_DTPE11 = PPTYP                             184167
     C                   Eval      K_DLST11 = PPYST                             184167
                                                                                184167
     C     Kfddtstl1     Setll     FDDTSTPD                               94    184167
     C                                                                          184167
                                                                                184167
     C                   If        *IN94 = *Off                                 184167
     C                   Eval      GenOkFlag = 'N'                              184167
     C                   Eval      Idx = Idx + 1                                184167
     C                   Eval      FldNamXAr(Idx) = DDSName                     184167
     C                   Eval      MsgIdXAr(Idx) = 'RFV0386'                    184167
     C                   Eval      RetCodeIn = 'Error'                          184167
     C                   Endif                                                  184167
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
     C                   PARM                    HdrRcdIn
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
     C                   Parm                    DDSName          10
 
      *                                                                         184167
      * Key list for Deal type/subtype                                          184167
     C     Kfddtstl1     KLIST                                                  184167
     C                   KFLD                    K_DTPE11                       184167
     C                   KFLD                    K_DLST11                       184167
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
