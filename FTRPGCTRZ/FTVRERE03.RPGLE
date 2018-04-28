     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Regulatory Reporting-Detail')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRERE03 - Validate Regulatory Reporting - Detail Screen    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 06May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184047             Date 22Sep00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 03Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  184047 - Amend validation on ORDERRES and BENEFRES           *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record datastructure
     D DTlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
     D OKFlagHS1     E DS                  EXTNAME(FTE102H1PD)
 
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
     D OKFlagDS1     E DS                  EXTNAME(FTE102S1PD)
 
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * Country file
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                    184047
                                                                                184047
     D P@FMT         E DS                  EXTNAME(DSSDY)                       184047
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D O#Pos           S              5U 0
     D B#Pos           S              5U 0
 
      * Work variables                                                          184047
     D P@Rtcd          S              7                                         184047
     D P@Optn          S              7                                         184047
     D P@Country       S              2                                         184047
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
 
      *
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
      *
      ** Initialise detail screen flags
      *
     C                   EVAL      OKRrp1 = 'Y'
     C                   EVAL      OKRrp2 = 'Y'
     C                   EVAL      OKRrp3 = 'Y'
      *
      ** Validate field
      *
     C                   EXSR      VALIDATE
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PRegRp1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRegRp1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OKRrp1 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PRegRp2 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRegRp2       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREGRP2'                  CAP084
     C                   EVAL      OKRrp2 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PRegRp3 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRegRp3       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREGRP3'                  CAP084
     C                   EVAL      OKRrp3 = 'N'
     C                   Endif
     C                   Endif
 
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate field                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     Validate      BEGSR
      *
      ** Test to see if equivalent field has been entered in general
      ** details section
      *
     C                   IF        HPRegRp1 <> *Blanks
      *
      ** If header regulatory reporting field has been entered then
      ** equivalent detail fields must be blank
      *
     C                   IF        PRegRp1 <> *Blanks
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0246'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C**********         EVAL      MsgDtaXAr(Idx) =   %Subst(PREGRP1:1:11)                  MD000091
     C                   EVAL      MsgDtaTmp = %Subst(PREGRP1:1:11)                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   EVAL      OKRrp1 = 'N'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        PRegRp1 <> *Blanks
 
     C                   EVAL      O#Pos = %Scan('ORDERRES':PRegRp1)
     C                   EVAL      B#Pos = %Scan('BENEFRES':PRegRp1)
 
     C                   If        O#Pos <> 0                                   184047
     C                   If        %Subst(PREGRP1:1:10) <> '/ORDERRES/'         184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0057'                 184047
     C                   Eval      FldNamXAr(Idx) =   DDSName                   184047
     C**********         Eval      MsgDtaXAr(Idx) =   %Subst(PREGRP1:1:12)           184047 MD000091
     C                   EVAL      MsgDtaTmp = %Subst(PREGRP1:1:12)                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   Eval      OKRrp1  = 'N'                                184047
     C                   Return                                                 184047
     C                   Endif                                                  184047
     C                   Endif                                                  184047
                                                                                184047
     C                   If        B#Pos <> 0                                   184047
     C                   If        %Subst(PREGRP1:1:10) <> '/BENEFRES/'         184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0057'                 184047
     C                   Eval      FldNamXAr(Idx) =   DDSName                   184047
     C**********         Eval      MsgDtaXAr(Idx) =   %Subst(PREGRP1:1:12)           184047 MD000091
     C                   EVAL      MsgDtaTmp = %Subst(PREGRP1:1:12)                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   Eval      OKRrp1  = 'N'                                184047
     C                   Return                                                 184047
     C                   Endif                                                  184047
     C                   Endif                                                  184047
                                                                                184047
      * If ORDERRES or BENEFRES entered ensure that the characters 11 and 12    184047
      *  form a valid country code                                              184047
     C                   If        O#Pos <> 0 OR                                184047
     C                             B#Pos <> 0                                   184047
     C                   If        %Subst(PREGRP1:11:2) = *Blanks               184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0700'                 184047
     C                   Eval      FldNamXAr(Idx) =   DDSName                   184047
     C                   Eval      MsgDtaXAr(Idx) =   *Blanks                   184047
     C                   Eval      OKRrp1  = 'N'                                184047
     C                   Return                                                 184047
     C                   Else                                                   184047
     C                   Eval      P@Country = %Subst(PREGRP1:11:2)             184047
     C                   Call      'AOCTRYR0'                                   184047
     C                   Parm      *Blanks       P@Rtcd                         184047
     C                   Parm      '*KEY'        P@Optn                         184047
     C                   Parm                    P@Country                      184047
     C     SDCTRY        Parm                    P@Fmt                          184047
                                                                                184047
      * Ensure that a valid country code                                        184047
     C                   If        P@Rtcd <> *Blanks                            184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0701'                 184047
     C                   Eval      FldNamXAr(Idx) =   DDSName                   184047
     C**********         Eval      MsgDtaXAr(Idx) =   P@Country                      184047 MD000091
     C                   EVAL      BLen = %Len(%Trim(P@Country))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(P@Country)                MD000091
     C                   Eval      OKRrp1  = 'N'                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Endif                                                  184047
     C*******************IF        O#Pos <> 0 OR                                184047
     C*******************          B#Pos <> 0                                   184047
      *******************                                                       184047
     C*******************IF        %Subst(PRegRp1:1:2)  <> '//' OR              184047
     C*******************          %Subst(PRegRp1:11:1) <> '/'                  184047
      *******************                                                       184047
     C*******************EVAL      Idx            =   Idx+1                     184047
     C*******************EVAL      RetCodeIn      =   'Error'                   184047
     C*******************EVAL      MsgIdXAr(Idx)  =   'RFV0247'                 184047
     C*******************EVAL      FldNamXAr(Idx) =   DDSName                   184047
     C*******************EVAL      MsgDtaXAr(Idx) =   %Subst(PRegRp1:1:11)      184047
     C*******************EVAL      OKRGRP1 = 'N'                                184047
     C*******************RETURN                                                 184047
     C*******************ENDIF                                                  184047
     C*******************ENDIF                                                  184047
      *
      ** The second and third lines may continue the information
      ** each preceded by a double slash, '//'.
      *
     C                   IF        PRegRp2 <> *Blanks and
     C                             %Subst(PRegRp2:1:2) <> '//'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0060'
     C****************** EVAL      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   EVAL      FldNamXAr(Idx) =   'PREGRP2'                 CAP084
     C                   EVAL      OKRRP2 = 'N'
     C                   ENDIF
      *
     C                   IF        PRegRp3 <> *Blanks and
     C                             %Subst(PRegRp3:1:2) <> '//'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0060'
     C*******************EVAL      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   EVAL      FldNamXAr(Idx) =   'PREGRP3'                 CAP084
     C                   EVAL      OKRrp3 = 'N'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Else the first line is empty.  The other 2 lines must be too.
      *
     C                   IF        PRegRp2 <> *Blanks  OR
     C                             PRegRp3 <> *Blanks
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0182'
     C****************** EVAL      FldNamXAr(Idx) =   DDSName                   CAP084
     C                   IF        PRegRp2 <> *Blanks                           CAP084
     C                   EVAL      OKRrp2 = 'N'
     C                   EVAL      FldNamXAr(Idx) =   'PREGRP2'                 CAP084
     C                   ELSE                                                   CAP084
     C                   EVAL      OKRrp3 = 'N'
     C                   EVAL      FldNamXAr(Idx) =   'PREGRP3'                 CAP084
     C                   ENDIF                                                  CAP084
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OkFlagDS1
     C                   PARM                    OkFlagDs2
     C                   PARM                    OkFlagHS1
     C                   PARM                    OkFlagHs2
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
