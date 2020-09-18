     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate detail account servicing inst')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVDEAC01  - Validate Account Servicing Institution (detail) *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221761             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT006  *CREATE    Date 28Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various RFTD validation errors              *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CSW200 - SWIFT 2000 enhancements                             *
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
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
      * OK Flags for first screen
     D OKFlags       E DS                  EXTNAME(FTE101S1PD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  226083
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     226083
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *                                                                                       226083
      ** Alphabetic array                                                                     226083
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)                          226083
      *                                                                                       226083
      ** Numeric array                                                                        226083
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)                          226083
      *                                                                                       226083
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D BicRetCode      S                   Like(RetCodeIn)
     D  ClrOrAcc       S             35
     D  BicCSname      S             11
     D P@IBAN          S             34                                                       226083
     D CFT004          S              1                                                       226083
 
     D  DDSName        S             10
 
     D  RESPMODE       S              1
 
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
     C                   Eval      OKAS35 = 'Y'
     C                   Eval      OKAS11 = 'Y'
 
     C                   If        PASI35 <> *Blanks   or
     C                             PACC11 <> *Blanks
 
      ** If Acc. Servicing Inst. is entered, it cannot have been entered
      ** on the header record.
     C                   If        PHACSV1 <> *Blanks  or
     C                             PHACSV2 <> *Blanks
     C                   Eval      Idx            =   Idx + 1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0143'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKAS35 = 'N'
     C                   Eval      OKAS11 = 'N'
     C                   Endif
 
      * If the detail intermediary field is entered, then the AWI 35 field
      *  must not contain //FW, //CP, //SC, //AU, //RT
     C                   If        PINSTA <> *Blanks  OR
     C                             PINST1 <> *Blanks  OR
     C                             PINST2 <> *Blanks  OR
     C                             PINST3 <> *Blanks  OR
     C                             PINST3 <> *Blanks  OR
     C                             PINST4 <> *Blanks
     C                   If        %Subst(PASI35:1:4) = '//FW' OR
     C                             %Subst(PASI35:1:4) = '//CP' OR
     C                             %Subst(PASI35:1:4) = '//SC' OR
     C                             %Subst(PASI35:1:4) = '//AU' OR
     C                             %Subst(PASI35:1:4) = '//RT'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0299'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKAS35 = 'N'
     C                   Endif
     C                   Endif
 
      ** 35-long field must begin with a '/'.
     C                   If        %Subst(PASI35:1:1) <> '/'  AND
     C                             PASI35 <> *Blank
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0049'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKAS35 = 'N'
     C                   Return
     C                   Endif
 
      ** Call module FTVBCCC01 to validate the clearing and BIC codes.
 
     C                   CallB     'FTVBCCC01'
     C                   Parm      'DETAIL'      BicRetCode
     C*******************Parm      *Blanks       ClrOrAcc                       CSW200
     C                   Parm      PASI35        ClrOrAcc                       CSW200
     C                   Parm      PACC11        BicCSname
     C                   Parm                    DDSName                        CSW200
 
     C                   Select
 
     C                   When      BicRetCode     =   '*INVALIDCC'  or
     C                             BicRetCode     =   '*DIGITERR'
 
      **Check*to*see*if*valid*clearing*code********************                 CSW200
     C*******************CallB     'FTVBCCC01'                                  CSW200
     C*******************Parm      'DETAIL'      BicRetCode                     CSW200
     C*******************Parm      PASI35        ClrOrAcc                       CSW200
     C*******************Parm      *Blanks       BicCSname                      CSW200
 
 
     C                   If        %Subst(PASI35:2:1) = '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   BicRetCode
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0184'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKAS35 = 'N'
     C                   Endif
 
     C                   When      BicRetCode     =   '*11ERROR'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   BicRetCode
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0145'
     C****************** Eval      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   Eval      FldNamXAr(Idx) =   'PACC11'                  CAP084
     C                   Eval      OKAS11 = 'N'
 
     C                   When      BicRetCode     =   '*BLANKERR'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   BicRetCode
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0366'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKAS35 = 'N'
 
     C                   Endsl
 
     C                   Endif
      *                                                                                       226083
      * Check if entry is valid IBAN format (external IBAN check)                             226083
     C                   If        CFT004 = 'Y'  AND                                          226083
     C                             %subst(PASI35:1:1) = '/' AND                               226083
     C                             %subst(PASI35:2:1) <> '/'                                  226083
     C*                                                                                       226083
     C                   EVAL      PIBAN    = *blanks                                         226083
     C                   EVAL      PIBAN    = %Subst(PASI35:2)                                226083
                                                                                              226083
      *  Format field, removing blanks and IBAN prefix                                        226083
                                                                                              226083
     C                   CALL      'AOIBANR3'                                                 226083
     C                   PARM                    @Rcode            7                          226083
     C                   PARM                    PIBAN            47                          226083
     C                   PARM                    POWith           47                          226083
     C     P@IBAN        PARM                    PONobl           34                          226083
                                                                                              226083
      *  If first four characters are 'AANN', proceed with IBAN validn                        226083
                                                                                              226083
     C     1             SUBST     P@IBAN:1      IBCTY1            1                          226083
     C     1             SUBST     P@IBAN:2      IBCTY2            1                          226083
     C     1             SUBST     P@IBAN:3      IBCHK1            1                          226083
     C     1             SUBST     P@IBAN:4      IBCHK2            1                          226083
     C     IBCTY1        LOOKUP    ALPH                                   94                  226083
     C   94IBCTY2        LOOKUP    ALPH                                   94                  226083
     C   94IBCHK1        LOOKUP    NUMC                                   94                  226083
     C   94IBCHK2        LOOKUP    NUMC                                   94                  226083
     C*                                                                                       226083
     C                   If        *IN94 = *ON                                                226083
     C*                                                                                       226083
     C                   CallB     'AOIBANR5'                           90                    226083
     C                   Parm      *Blanks       @RTCD                                        226083
     C                   Parm                    P@IBAN                                       226083
                                                                                              226083
     C                   IF        *IN90 = *Off and @RTCD  = *Blanks                          226083
     C*                                                                                       226083
     C                   ELSE                                                                 226083
                                                                                              226083
      *  Warnings:                                                                            226083
                                                                                              226083
     C                   Eval      WIx             =   WIx+1                                  226083
     C                   Eval      RetCodeIn        =   'Error'                               226083
     C                   Eval      WFldNmXAr(WIx) =  DDSName                                  226083
     C                   Eval      OKAS35    = 'W'                                            226083
                                                                                              226083
     C                   SELECT                                                               226083
                                                                                              226083
      *  Invalid ISO country code                                                             226083
     C                   WHEN      @RTCD  = '      1'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                                 226083
      *  Invalid BBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      2'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                                 226083
      *  Invalid character                                                                    226083
     C                   WHEN      @RTCD  = '      3'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                                 226083
      *  Invalid IBAN length                                                                  226083
     C                   WHEN      @RTCD  = '      4'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                                 226083
      *  Invalid check digit                                                                  226083
     C                   WHEN      @RTCD  = '      5'                                         226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                                 226083
      *  Other/non-specific warning                                                           226083
     C                   OTHER                                                                226083
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                                 226083
     C                   ENDSL                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                                226083
     C*                                                                                       226083
     C                   Endif                                                  End IBAN chk  226083
 
      * Now validate that all data entered is OK for SWIFT
     C                   If        PASI35  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PASI35        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      OKAS35 = 'N'
     C                   Endif
     C                   Endif
 
 
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
                                                                                              226083
     C                   CALLB     'AOSARDR0'                                                 226083
     C                   Parm      *BLANKS       @RTCD             7                          226083
     C                   Parm      '*VERIFY'     @OPTN             7                          226083
     C                   Parm      'CFT004'      @SARD             6                          226083
     C     SCSARD        Parm      SCSARD        DSFDY                                        226083
                                                                                              226083
     C                   Select                                                               226083
     C                   When      @RTCD <> *Blanks and                                       226083
     C                             @RTCD <> '*NRF   '                                         226083
     C                   Eval      DbFile =  'SCSARDPD'                                       226083
     C                   Eval      DBase =  2                                                 226083
     C                   Eval      DBKey = 'CFT004'                                           226083
     C                   Exsr      *PSSR                                                      226083
                                                                                              226083
     C                   When      @RTCD = *Blanks                                            226083
     C                   Move      'Y'           CFT004            1                          226083
                                                                                              226083
     C                   When      @RTCD = '*NRF   '                                          226083
     C                   Eval      @RTCD = *Blanks                                            226083
     C                   Eval      CFT004 = 'N'                                               226083
                                                                                              226083
     C                   Endsl                                                                226083
 
 
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
