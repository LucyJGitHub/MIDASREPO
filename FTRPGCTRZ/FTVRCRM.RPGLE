     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP receivers charges remitted')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVRCRM   - Validate OP Receiver's Charges Remitted          *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24724           Date 03Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 200949             Date 05Oct06               *
      *                 CDL049             Date 06Jul06               *
      *                 208219             Date 27Apr06               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 13Jan04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CFT017             Date 19Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG24724 - Senders and receivers charge error                *
      *             (already applied by 208219)                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.(Recompile)     *
      *  200949 - Suppress FTM3244 if payment will not produce a      *
      *           MT103.  Applied core fix 197943.                    *
      *           Same fix as 208219.                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  208219 - MT103 mandatory fields.
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Allow charge to be zero.                            *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *                                                                                       CFT017
      ** Array of Fields with warnings.                                                       CFT017
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CFT017
      *                                                                                       CFT017
      ** Array of warning message IDs                                                         CFT017
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CFT017
      *                                                                                       CFT017
      ** Array of warning message data.                                                       CFT017
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CFT017
 
      ** Incoming Transaction (First screen level 1)
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Incoming Transaction (Fourth screen level 2)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADIG           S              2  0
     D ZADEC           S              1  0
     D CFT017          S              1                                                       CFT017
     D WVMIFF          S              1                                                       CFT017
     D BTMIFE          S             11P 0                                                    CFT017
     D Wx              S              3P 0                                                    CFT017
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
 
      ** Initialization
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      Wx = 0                                                     CFT017
 
      ** Receiver's Charges Remitted validation
 
     C                   ExSr      SrRcvChg
 
      ** If an error was found, set the return code appropriately
 
     C                   If        OKRCRM = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrRcvChg
      *****************************************************************
      *                                                               *
      * SR/SrRcvChg   - Validate Receiver's Charges Remitted          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZALIGN      - Validate and align fields.                      *
      * ZEDIT       - Converts numeric value to screen value.         *
      *                                                               *
      *****************************************************************
 
     C     SrRcvChg      BegSr
 
      ** Receiver's Charges Remitted is optional.
      ** If entered must be valid for payment currency details
 
     C                   Eval      @RCRM = *Zero
 
      ** Receiver's charges remitted entered while the Detail of Charges
      ** is 'BEN', or Detail of Charges is 'OUR' and the add/deduct indica
      ** tor is not 'A' or Details of Charges is 'SHA', error.
 
     C                   Move(P)   SRCRM         @RCRM                                        CAP084
     C                   If        SRCRM <> *Blank
     C                             And @RCRM <> *Zero                                         CAP084
     C                   If        (SDTCH = 'BEN') Or (SDTCH = 'SHA') Or
     C                             (SDTCH = 'OUR') And (SADDC <> 'A')
     C
     C                   Move      'N'           OKRCRM
     C                   Add       1             Idx
     C                   Movel     'SRCRM'       FldNamXAr(Idx)
     C                   Movel     'FTM3231'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   Eval      ZFIELD = *Blank
     C                   Eval      ZFIELD = SRCRM
     C                   Eval      ZADIG = 11 - @RCDP
     C                   Eval      ZADEC = @RCDP
 
     C                   CallB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
 
     C                   If        ZalignOK = 'N'
     C                   Move      'N'           OKRCRM
     C                   Add       1             Idx
     C                   Movel     'SRCRM'       FldNamXAr(Idx)
     C                   Movel     'FTM3232'     MsgIdXAr(Idx)
     C*****SPCCY         Cat       SRCRM         MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(SPCCY))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(SPCCY)                    MD000091
     C                   EVAL      BLen = %Len(%Trim(SRCRM))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(SRCRM)                    MD000091
     C                   Else
     C                   Move      ZFIELD        @RCRM
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Move      ZFIELD        SRCRM
      *                                                                                       CFT017
      ** Compare amount computed to Multilateral Inter-change Fee                             CFT017
      ** defined in FT ICD. Generate warning message if Receiver's                            CFT017
      ** charges is less than the Multilateral Interchange Fee.                               CFT017
      *                                                                                       CFT017
     C                   IF        CFT017 = 'Y' AND                                           CFT017
     C                             WVMIFF = 'Y' AND                                           CFT017
     C                             @RCRM < BTMIFE                                             CFT017
     C                   MOVE      'W'           OKRCRM                                       CFT017
     C                   ADD       1             Wx                                           CFT017
     C                   MOVEL     'SRCRM'       WFldNmXAr(Wx)                                CFT017
     C                   MOVEL     'FTM6000'     WMsgIdXAr(Wx)                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   EndIf
 
      ** If Receiver's charges is entered, instructed amount must not be
      ** zero
 
     C                   If        @PDAM = *Zero  And SPYTP <> 'RP'
     C                   If        @MT103='Y'                                                 208219
     C                             And (SSTTP <> '02')                                        208219
     C                   Move      'N'           OKRCRM
     C                   Add       1             Idx
     C                   Movel     'SRCRM'       FldNamXAr(Idx)
     C                   Movel     'FTM3244'     MsgIdXAr(Idx)
     C                   Endif                                                                208219
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CFT017
     C                   PARM                    WMsgIdXAr                                    CFT017
     C                   PARM                    WMsgDtXAr                                    CFT017
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    CFT017                                       CFT017
     C                   PARM                    WVMIFF                                       CFT017
     C                   PARM                    BTMIFE                                       CFT017
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
