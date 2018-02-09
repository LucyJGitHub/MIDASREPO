     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate destination address')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVDNAD01 -Validate Destination address                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 221760             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 09Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  226083 - Correct RFTD validation errors.                     *
      *           Here, system accepts a customer without BIC!        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer inclusion of MT101 messages          *
      *           messages                                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D GenOkFlag       S              1    Import
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External Data structure for customer details.
 
 
      *Work Fields
     D @Type                               Like(@RTCD)
 
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
 
      ** Initialization
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      GenOkFlag = 'Y'
 
      * Can only be entered in 'RO'
     C                   If        PPTYP = 'RI'
     C                   If        PRFTDST <> *Blanks
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0356'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
     C                   Return
     C                   Endif
 
      * Must be entered as a SWIFT BIC, Customer number or Shortname that
      *  has a BIC defined.
     C                   Eval      Char18 = PRFTDST
 
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   If        @Type = '*BIC'
     C                   Return
     C                   Endif
 
      * Customer number or shortname with BIC defined
     C                   Movel     PRFTDST       KeyVal
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
 
     C                   If        @Type <> '*CSHT  ' AND
     C***********                  @Type <> '*CNUM  ' AND                                     226083
     C                             @Type <> '*CNUM  ' OR                                      226083
     C*                                                                                       226083
     C                             @Type =  '*CSHT  ' AND                                     226083
     C                             BBCSID = *BLANKS   OR
     C*                                                                                       226083
     C                             @Type =  '*CNUM  ' AND                                     226083
     C                             BBCSID = *BLANKS   OR                                      226083
     C*                                                                                       226083
     C                             @Type = '*CSHT  '  AND                                     226083
     C                             %Subst(PRFTDST:11:25) <> *Blanks  OR                       226083
     C*                                                                                       226083
     C                             @Type = '*CNUM  '  AND                                     226083
     C                             %Subst(PRFTDST:7:29) <> *Blanks  OR                        226083
     C*                                                                                       226083
     C                             @RTCD <> *BLANKS
     C*                                                                                       226083
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0357'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif
 
     C                   If        @Type = '*CSHT  '  AND
     C                             BBCSID <> *Blank   AND                                     226083
     C                             RetCodeIn = '*NOBIC'                                       226083
     C***********                  %Subst(PRFTDST:11:1) <> *Blanks                            226083
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0362'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif
 
     C                   If        @Type = '*CNUM  '  AND
     C                             BBCSID <> *Blank   AND                                     226083
     C                             RetCodeIn = '*NOBIC'                                       226083
     C***********                  %Subst(PRFTDST:7:1))<>>*Blankss                            226083
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      MsgIdXAr(Idx)   =  'RFV0363'
     C                   Eval      FldNamXAr(Idx)  =  DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
