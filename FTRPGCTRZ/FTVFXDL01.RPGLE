     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate FX Deal Reference')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVFXDL01  - Validate FX Deal Reference                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207A            Date 29Jul07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221761             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - Swift 2007 fix                                     *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various RFTD validation errors              *
      *           Here, add validation to detect invalid SWIFT        *
      *           characters.                                         *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D RespMode        S              1
     D DDSName         S             10
 
      ** Index for FxDrefArr array
     D X               S              2P 0
 
      ** Index for ScanFxDref array
     D Y               S              2P 0
 
      ** Work index
     D Z               S              2P 0
                                                                                              CSW207
      ** SWIFT 2007 switchable feature                                                        CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** Return code when calling SWIF2001                                                    CSW201
     D PRTCD           S              7A                                                      CSW201
                                                                                              CSW201
      ** Transfer Amount work variable                                                        CSW201
     D WTrnAmt         S             16A                                                      CSW201
                                                                                              CSW201
      ** Array index                                                                          CSW201
     D Win             S              2P 0                                                    CSW201
                                                                                              CSW201
      ** Transfer Amount work array                                                           CSW201
     D WTrnArr         S              1A   DIM(16)                                            CSW201
 
      ** Array to break FXDREF into individual characters
     D FXDRefArr       S              1    DIM(16)
 
      ** Array to return characters of FXDREF that contain a '/'
     D ScanFXDref      S              2  0 DIM(16)
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKFXDF     = 'Y'
 
     C                   EXSR      Validate
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate fields                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Validate      BEGSR
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Outgoing Request for Transfers,                       CSW201
      ** entry to FX Deal Reference is prohibited when Transfer Amount                        CSW201
      ** is zero                                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND PPTYP = 'RO'                              CSW201
     C                             AND OKTRAM <> 'N' AND OKTRCY <> 'N'                        CSW201
     C**********                   OR (CSW207 = 'Y' AND PPTYP = 'RO'                  CSW207 CSW207A
     C                             OR (CSW207 = 'Y'                                          CSW207A
     C                             AND OKTRAM <> 'N' AND OKTRCY <> 'N')                       CSW207
      *                                                                                       CSW201
      ** Check if Transfer Amount is zero                                                     CSW201
      *                                                                                       CSW201
     C                   MOVEA     PTRNAMT       WTrnArr                                      CSW201
     C                   EVAL      Win = *ZERO                                                CSW201
      *                                                                                       CSW201
     C                   DOW       Win <> 16                                                  CSW201
     C                   EVAL      Win = Win + 1                                              CSW201
     C                   IF        WTrnArr(Win) = '.' OR WTrnArr(Win) = ' '                   CSW201
     C                   EVAL      WTrnArr(Win) = '0'                                         CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDDO                                                                CSW201
      *                                                                                       CSW201
     C                   MOVEA     WTrnArr       WTrnAmt                                      CSW201
     C                   IF        CSW207 = 'Y'                                              CSW207A
                                                                                             CSW207A
      ** If Transfer Amount is zero and none of of instruction is equal to EQUI              CSW207A
      ** entry to FX Deal Reference is prohibited                                            CSW207A
                                                                                             CSW207A
     C                   IF        WTrnAmt = *ZEROS AND PFXDREF <> *BLANKS                   CSW207A
     C                             AND (PINSCA4 <> 'EQUI'                                    CSW207A
     C                             OR PINSCB4 <> 'EQUI' OR PINSCC4 <> 'EQUI'                 CSW207A
     C                             OR PINSCD4 <> 'EQUI' OR PINSCE4 <> 'EQUI')                CSW207A
     C                   EVAL      OKFxDF = 'N'                                              CSW207A
     C                   EVAL      Idx = Idx + 1                                             CSW207A
     C                   EVAL      FldNamXAr(Idx) = DDSName                                  CSW207A
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0941'                                 CSW207A
     C                   GOTO      EndValidate                                               CSW207A
     C                   ENDIF                                                               CSW207A
     C                   ELSE                                                                CSW207A
      *                                                                                       CSW201
      ** If Transfer Amount is zero,                                                          CSW201
      ** entry to FX Deal Reference is prohibited                                             CSW201
      *                                                                                       CSW201
     C                   IF        WTrnAmt = *ZEROS AND PFXDREF <> *BLANKS                    CSW201
     C**********                   AND CSW201 = 'Y'                                   CSW207 CSW207A
     C                   EVAL      OKFxDF = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0501'                                  CSW201
     C                   GOTO      EndValidate                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                               CSW207A
      *****************************************************************               CSW207 CSW207A
      ***If*Transfer*Amount*is*zero*and*none*of*of*instruction*is*equal to EQUI       CSW207 CSW207A
      ***entry*to*FX*Deal*Reference*is*prohibited**********************               CSW207 CSW207A
      *****************************************************************               CSW207 CSW207A
     C**********         IF        WTrnAmt = *ZEROS AND PFXDREF <> *BLANKS            CSW207 CSW207A
     C**********                   AND CSW207 = 'Y' AND (PINSCA4 <> 'EQUI'            CSW207 CSW207A
     C**********                   OR PINSCB4 <> 'EQUI' OR PINSCC4 <> 'EQUI'          CSW207 CSW207A
     C**********                   OR PINSCD4 <> 'EQUI' OR PINSCE4 <> 'EQUI')         CSW207 CSW207A
     C**********         EVAL      OKFxDF = 'N'                                       CSW207 CSW207A
     C**********         EVAL      Idx = Idx + 1                                      CSW207 CSW207A
     C**********         EVAL      FldNamXAr(Idx) = DDSName                           CSW207 CSW207A
     C**********         EVAL      MsgIdXAr(Idx) = 'RFV0941'                          CSW207 CSW207A
     C**********         GOTO      EndValidate                                        CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        PTOOAMT <> *Blanks
      *
      ** If Original Amount has been entered and
      ** FX Deal Ref has been left blank, default to 'NONREF'.
     C                   IF        PFXDREF = *Blanks
      *                                                                                       CSW201
      ** If CSW201 is on and Transaction Amount is blank or zero,                             CSW201
      ** entry to FX Deal Reference is prohibited (bypass default                             CSW201
      ** to 'NONREF').                                                                        CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             CSW201 = 'Y' AND WTrnAmt <> *ZEROS                         CSW201
     C                   EVAL      PFXDREF = 'NONREF'
     C                   ENDIF                                                                CSW201
      *
      ** If Original Amount has been entered and
      ** FX Deal Ref has been entered then it must not begin or end
      ** with a slash or contain two consecutive /'s
      *
     C                   ELSE
      *
      ** Leading blanks are not allowed.
      *
     C                   MOVEA     PFXDREF       FXDrefArr
      *
     C                   IF        FXDrefArr(1) = '/' or FXDRefArr(1) = ' '
     C                   MOVE      'N'           OKFxDF
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0359'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Must not end with '/'.
      *
     C     '/'           SCAN      PFxDref       ScanFXDref
     C                   EVAL      Y = 1
      *
      ** (Determine the position of the last '/' and put it in X)
     C     *Zeros        LOOKUP    ScanFXDref(Y)                          89
     C                   IF        *IN89 = *ON  and  Y > 1
     C                   EVAL      Z = (Y - 1)
     C                   EVAL      X = ScanFXDref(Z)
     C                   EVAL      X = (X + 1)
      *
      ** (Check characters after last '/'.  If all are blank - error.)
      *
     C                   DOW       X < 17
     C                   IF        FXDrefArr(X) = *Blanks
     C                   EVAL      X = (X + 1)
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        X = 17
     C                   MOVE      'N'           OKFxdf
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0360'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Must not contain the string '//'.
      *
     C     '//'          SCAN      PFXDref:2                              81
      *
     C                   IF        *IN81 = *On
     C                   MOVE      'N'           OKFXdf
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0361'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C*  Entry must not conatin invalid SWIFT characters                                      226083
     C                   Movel(P)  PFXDref       Swift_Text                                   226083
     C                   CallB     'FTVSFTX01'                                                226083
     C                   Parm                    RetCdeIn         10                          226083
     C                   Parm                    Swift_Text       50                          226083
     C                   If        RetCdeIn = 'Error'                                         226083
     C                   Eval      Idx            =   Idx+1                                   226083
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'                                226083
     C                   Eval      FldNamXAr(Idx) =  DDSName                                  226083
     C                   Eval      OKFXdf = 'N'                                               226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   ENDIF
      *
     C**********         ENDSR                                                                CSW201
     C     EndValidate   ENDSR                                                                CSW201
      *
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
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
     C                   PARM                    OKFlags
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
      *                                                                                       CSW207
     C                   IF        PRTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
 
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
