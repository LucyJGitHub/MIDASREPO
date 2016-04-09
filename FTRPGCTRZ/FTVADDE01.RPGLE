     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate additional information')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVADDE01  - Validate Additional Information                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185696             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185696 - Line 1 may be blank without a code                  *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      ** Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * OK Flags for first screen - Header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
     D GenOkFlag3      S              1    Import
 
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Work fields for checking /CODE/(Text) formats                          CSW200
     D CheckField      S             35                                         CSW200
     D CheckFldErr     S              1                                         CSW200
     D FirstLine       S              1                                         CSW200
     D SlashPos        S              2  0                                      CSW200
     D AlphaPos        S              2  0                                      CSW200
                                                                                CSW200
      ** SWIFT 2000 flag                                                        CSW200
     D CSW200          S              1                                         CSW200
                                                                                CSW200
      ** Named constant - letters A to Z                                        CSW200
     D Alphabet        C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'         CSW200
                                                                                CSW200
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D Wr              S              3P 0                                                    CSW201
                                                                                              CSW201
      ** Named constant - alphanumeric                                                        CSW201
     D WAlphb          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ+                       CSW201
     D                                     0123456789'                                        CSW201
                                                                                              CSW201
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
     C                   Eval      GenOkFlag3 = 'Y'
 
      * Addtitional information must be formatted with a '/' in first line
      *  followed by a '/' in position 8.
      *  Lines 2 - 6 (if entered) must begin with '//'
 
     C                   If        PADNLI1 <> *Blanks
     C                   If        %Subst(PADNLI1:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      GenOkFlag3 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI2 <> *Blanks AND
     C                             %Subst(PADNLI2:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI2'                  CAP084
     C                   EVAL      OKADIN2   = 'N'
     C                   Endif
 
     C                   If        PADNLI3 <> *Blanks AND
     C                             %Subst(PADNLI3:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI3'                  CAP084
     C                   EVAL      OKADIN3   = 'N'
     C                   Endif
 
     C                   If        PADNLI4 <> *Blanks AND
     C                             %Subst(PADNLI4:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI4'                  CAP084
     C                   EVAL      OKADIN4   = 'N'
     C                   Endif
 
     C                   If        PADNLI5 <> *Blanks AND
     C                             %Subst(PADNLI5:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI5'                  CAP084
     C                   EVAL      OKADIN5   = 'N'
     C                   Endif
 
     C                   If        PADNLI6 <> *Blanks AND
     C                             %Subst(PADNLI6:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0376'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI6'                  CAP084
     C                   EVAL      OKADIN6   = 'N'
     C                   Endif
 
 
      * Check for invalid Swift characters
     C                   If        PADNLI1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKADIN1   = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI2 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI2       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI2'                  CAP084
     C                   EVAL      OKADIN2   = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI3 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI3       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI3'                  CAP084
     C                   EVAL      OKADIN3   = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI4 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI4       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI4'                  CAP084
     C                   EVAL      OKADIN4   = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI5 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI5       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*****************  Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI5'                  CAP084
     C                   EVAL      OKADIN5   = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PADNLI6 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PADNLI6       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PADNLI6'                  CAP084
     C                   EVAL      OKADIN6   = 'N'
     C                   Endif
     C                   Endif
                                                                                CSW200
      * If SWIFT 2000 is on the /CODE/(Text) format must be used.               CSW200
     C                   If        CSW200 = 'Y'                                 CSW200
                                                                                CSW200
     C                   If        PADNLI1   <> *Blanks                         185696
     C                   Eval      CheckField = PADNLI1                         CSW200
     C                   Eval      FirstLine  = 'Y'                             CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   Eval      FirstLine  = 'N'                             CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN1   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  185696
                                                                                CSW200
     C                   If        PADNLI2   <> *Blanks                         CSW200
     C                   Eval      CheckField = PADNLI2                         CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN2   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   If        PADNLI3   <> *Blanks                         CSW200
     C                   Eval      CheckField = PADNLI3                         CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN3   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   If        PADNLI4   <> *Blanks                         CSW200
     C                   Eval      CheckField = PADNLI4                         CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN4   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   If        PADNLI5   <> *Blanks                         CSW200
     C                   Eval      CheckField = PADNLI5                         CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN5   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   If        PADNLI6   <> *Blanks                         CSW200
     C                   Eval      CheckField = PADNLI6                         CSW200
     C                   ExSr      SrCode                                       CSW200
     C                   If        CheckFldErr = 'Y'                            CSW200
     C                   Eval      OKADIN6   = 'N'                              CSW200
     C                   Eval      RetCodeIn = 'Error'                          CSW200
     C                   EndIf                                                  CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
 
     C                   Return
      *****************************************************************
      /EJECT                                                                    CSW200
      *****************************************************************         CSW200
      *                                                               *         CSW200
      * SrCode - Validate /CODE/(Text) entries                        *         CSW200
      *                                                               *         CSW200
      * Called by: Main processing                                    *         CSW200
      *                                                               *         CSW200
      * Calls: None                                                   *         CSW200
      *                                                               *         CSW200
      *****************************************************************         CSW200
     C     SrCode        Begsr                                                  CSW200
                                                                                CSW200
      * Condition for 1st line: Entry must be of form '/CODE/(Text)'            CSW200
      * where CODE is one or more characters with no blanks; (Text)             CSW200
      * represents free-form optional text.                                     CSW200
      *                                                                         CSW200
      * Condition for subsequent lines: If entered, these must either           CSW200
      * begin '//(Text)' or follow the rules for the first line.                CSW200
                                                                                CSW200
     C                   Eval      CheckFldErr    =  'N'                        CSW200
                                                                                CSW200
      * If not 1st line check for '//(Text)'                                    CSW200
     C                   If        FirstLine = 'N'                              CSW200
                                                                                CSW200
     C                   If        %Subst(CheckField:1:2) = '//'                CSW200
                                                                                CSW200
     C                   If        %Subst(CheckField:3:1) = *Blanks             CSW200
     C                   Eval      CheckFldErr    =  'Y'                        CSW200
     C                   Eval      Idx            =  Idx + 1                    CSW200
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0382'                  CSW200
     C                   Eval      FldNamXAr(Idx) =  DDSName                    CSW200
     C                   EndIf                                                  CSW200
                                                                                CSW200
      * Else begins '/' but not '//' - validate for '/CODE/(Text)'              CSW200
      * format.                                                                 CSW200
     C                   Else                                                   CSW200
                                                                                CSW200
      ** Must be another '/' in the field                                       CSW200
     C     '/'           Scan      CheckField:2  SlashPos                       CSW200
                                                                                CSW200
     C                   If        SlashPos = *Zeros                            CSW200
     C                   Eval      CheckFldErr    =  'Y'                        CSW200
     C                   Eval      Idx            =  Idx + 1                    CSW200
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0383'                  CSW200
     C                   ENDIF                                                                CSW201
     C                   Eval      FldNamXAr(Idx) =  DDSName                    CSW200
     C                   Else                                                   CSW200
      *                                                                                       CSW201
      ** If CSW201 is on, allow entry of up to 8                                              CSW201
      ** alphanumeric characters                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      Wr = 2                                                     CSW201
      *                                                                                       CSW201
     C     WAlphb        CHECK     Checkfield:Wr Wr                                           CSW201
      *                                                                                       CSW201
     C                   IF        Wr >= 11                                                   CSW201
     C                   EVAL      CheckFldErr = 'Y'                                          CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   IF        %SUBST(CheckField:Wr:1) <> '/'                             CSW201
     C                   EVAL      CheckFldErr = 'Y'                                          CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                CSW200
      ** All positions between the slashes must contain capital letters         CSW200
     C     Alphabet      Check     CheckField:2  AlphaPos                       CSW200
                                                                                CSW200
     C                   If        AlphaPos < SlashPos  AND                     CSW200
     C                             AlphaPos <> *Zeros                           CSW200
     C                   Eval      CheckFldErr    =  'Y'                        CSW200
     C                   Eval      Idx            =  Idx + 1                    CSW200
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0383'                  CSW200
     C                   Eval      FldNamXAr(Idx) =  DDSName                    CSW200
     C                   EndIf                                                  CSW200
     C                   ENDIF                                                                CSW201
     C                   EndIf                                                  CSW200
                                                                                CSW200
     C                   EndIf                                                  CSW200
      *                  * End of 'If 1st 2 digits of CheckField = '//''        CSW200
                                                                                CSW200
      * Else this is the first field - validate for '/CODE/(Text)' format       CSW200
     C                   Else                                                   CSW200
                                                                                CSW200
      ** Must be another '/' in the field (but not in position 2)               CSW200
     C     '/'           Scan      CheckField:3  SlashPos                       CSW200
                                                                                CSW200
     C                   If        SlashPos = *Zeros                            CSW200
     C                   Eval      CheckFldErr    =  'Y'                        CSW200
     C                   Eval      Idx            =  Idx + 1                    CSW200
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0383'                  CSW200
     C                   ENDIF                                                                CSW201
     C                   Eval      FldNamXAr(Idx) =  DDSName                    CSW200
     C**********         EndIf                                                  CSW200        CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
      ** If CSW201 is on, allow entry of up to 8                                              CSW201
      ** alphanumeric characters                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      Wr = 2                                                     CSW201
      *                                                                                       CSW201
     C     WAlphb        CHECK     Checkfield:Wr Wr                                           CSW201
      *                                                                                       CSW201
     C                   IF        Wr >= 11                                                   CSW201
     C                   EVAL      CheckFldErr = 'Y'                                          CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   IF        %SUBST(CheckField:Wr:1) <> '/'                             CSW201
     C                   EVAL      CheckFldErr = 'Y'                                          CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0513'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                CSW200
      ** All positions between the slashes must contain capital letters         CSW200
     C     Alphabet      Check     CheckField:2  AlphaPos                       CSW200
                                                                                CSW200
     C                   If        AlphaPos < SlashPos  AND                     CSW200
     C                             AlphaPos <> *Zeros                           CSW200
     C                   Eval      CheckFldErr    =  'Y'                        CSW200
     C                   Eval      Idx            =  Idx + 1                    CSW200
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0383'                  CSW200
     C                   Eval      FldNamXAr(Idx) =  DDSName                    CSW200
     C                   EndIf                                                  CSW200
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                CSW200
     C                   EndIf                                                  CSW200
      *                  * End of 'If 1st FirstLine = 'N''                      CSW200
                                                                                CSW200
      * Reset work fields                                                       CSW200
     C                   Eval      CheckField = *Blanks                         CSW200
     C                   Eval      AlphaPos   = *Zeros                          CSW200
     C                   Eval      SlashPos   = *Zeros                          CSW200
                                                                                CSW200
     C                   EndSr                                                  CSW200
                                                                                CSW200
      *****************************************************************         CSW200
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
 
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
 
      ** Screen fields
     C                   Parm                    HdrRcdIn
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   PARM                    OKFlagHs2
 
      ** Check if SWIFT 2000 is applicable.                                     CSW200
                                                                                CSW200
     C                   CALLB     'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       RetCode7          7            CSW200
                                                                                CSW200
     C                   IF        RetCode7 <> *Blanks                          CSW200
     C                   EVAL      CSW200 = 'Y'                                 CSW200
     C                   ELSE                                                   CSW200
     C                   EVAL      CSW200 = 'N'                                 CSW200
     C                   ENDIF                                                  CSW200
                                                                                CSW200
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
