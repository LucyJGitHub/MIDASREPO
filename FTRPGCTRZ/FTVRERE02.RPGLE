     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Regulatory Reporting-Header')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRERE02 - Validate Regulatory Reporting Header             *
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
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      *                 184047             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
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
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD)
 
     D OKFlags       E DS                  EXTNAME(FTE102H2PD)
 
      * Country file
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                    184047
                                                                                184047
     D P@FMT         E DS                  EXTNAME(DSSDY)                       184047
      * Work variables                                                          184047
     D P@Rtcd          S              7                                         184047
     D P@Optn          S              7                                         184047
     D P@Country       S              2                                         184047
 
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
                                                                                            MD000091
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
 
     C                   Eval      OKRGRP1 = 'Y'
     C                   Eval      OKRGRP2 = 'Y'
     C                   Eval      OKRGRP3 = 'Y'
 
     C                   If        PREGRP1 <> *Blanks
 
     C                   Eval      O#Pos = %Scan('ORDERRES':PREGRP1)
     C                   Eval      B#Pos = %Scan('BENEFRES':PREGRP1)
 
     C                   If        O#Pos <> 0                                   184047
     C                   If        %Subst(PREGRP1:1:10) <> '/ORDERRES/'         184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0057'                 184047
     C                   Eval      FldNamXAr(Idx) =   DDSName                   184047
     C**********         Eval      MsgDtaXAr(Idx) =   %Subst(PREGRP1:1:12)           184047 MD000091
     C                   Eval      MsgDtaTmp = %Subst(PREGRP1:1:12)                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   Eval      OKRGRP1 = 'N'                                184047
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
     C                   Eval      MsgDtaTmp = %Subst(PREGRP1:1:12)                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   Eval      OKRGRP1 = 'N'                                184047
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
     C                   Eval      OKRGRP1 = 'N'                                184047
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
     C                   Eval      OKRGRP1 = 'N'                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Endif                                                  184047
                                                                                184047
      * The second and third lines may continue the information                 184047
      *  each preceded by a double slash, '//'.                                 184047
     C                   If        PREGRP2 <> *Blanks          AND              184047
     C                             %Subst(PREGRP2:1:2) <> '//'                  184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0060'                 184047
     C****************** Eval      FldNamXAr(Idx) =   DDSName             184047CAP084
     C                   Eval      FldNamXAr(Idx) =   'PREGRP2'                 CAP084
     C                   Eval      OKRGRP2 = 'N'                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   If        PREGRP3 <> *Blanks          AND              184047
     C                             %Subst(PREGRP3:1:2) <> '//'                  184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0060'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName             184047CAP084
     C                   Eval      FldNamXAr(Idx) =   'PREGRP3'                 CAP084
     C                   Eval      OKRGRP3 = 'N'                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Else                                                   184047
                                                                                184047
      * Else the first line is empty.  The other 2 lines must be too.           184047
     C                   If        PREGRP2 <> *Blanks  OR                       184047
     C                             PREGRP3 <> *Blanks                           184047
     C                   Eval      Idx            =   Idx+1                     184047
     C                   Eval      RetCodeIn      =   'Error'                   184047
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0182'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName             184047CAP084
     C                   If        PREGRP2 <> *Blanks                           CAP084
     C                   Eval      FldNamXAr(Idx) =   'PREGRP2'                 CAP084
     C                   ELSE                                                   CAP084
     C                   Eval      FldNamXAr(Idx) =   'PREGRP3'                 CAP084
     C                   ENDIF                                                  CAP084
     C                   Eval      OKRGRP2 = 'N'                                184047
     C                   Eval      OKRGRP3 = 'N'                                184047
     C                   Endif                                                  184047
                                                                                184047
     C                   Endif                                                  184047
     C*******************If        O#Pos <> 0 OR                                184047
     C*******************          B#Pos <> 0                                   184047
      *******************                                                       184047
     C*******************If        %Subst(PREGRP1:1:2)  <> '//' OR              184047
     C*******************          %Subst(PREGRP1:11:1) <> '/'                  184047
      *******************                                                       184047
     C*******************Eval      Idx            =   Idx+1                     184047
     C*******************Eval      RetCodeIn      =   'Error'                   184047
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0057'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   184047
     C*******************Eval      MsgDtaXAr(Idx) =   %Subst(PREGRP1:1:11)      184047
     C*******************Eval      OKRGRP1 = 'N'                                184047
     C*******************Return                                                 184047
     C*******************Endif                                                  184047
     C*******************Endif                                                  184047
                                                                                184047
      **The*second*and*third lines may continue the information                 184047
      ***each*preceded*by a double slash, '//'.                                 184047
     C*******************If        PREGRP2 <> *Blanks           AND             184047
     C*******************          %Subst(PREGRP2:1:2) <> '//'  AND             184047
     C*******************          O#Pos <> 0                   OR              184047
     C*******************          PREGRP2 <> *Blanks           AND             184047
     C*******************          %Subst(PREGRP2:1:2) <> '//'  AND             184047
     C*******************          B#Pos <> 0                                   184047
     C*******************Eval      Idx            =   Idx+1                     184047
     C*******************Eval      RetCodeIn      =   'Error'                   184047
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0060'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   184047
     C*******************Eval      OKRGRP2 = 'N'                                184047
     C*******************Endif                                                  184047
      *******************                                                       184047
     C*******************If        PREGRP3 <> *Blanks           AND             184047
     C*******************          %Subst(PREGRP3:1:2) <> '//'  AND             184047
     C*******************          O#Pos <> 0                   OR              184047
     C*******************          PREGRP3 <> *Blanks           AND             184047
     C*******************          %Subst(PREGRP3:1:2) <> '//'  AND             184047
     C*******************          B#Pos <> 0                                   184047
     C*******************Eval      Idx            =   Idx+1                     184047
     C*******************Eval      RetCodeIn      =   'Error'                   184047
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0060'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   184047
     C*******************Eval      OKRGRP3 = 'N'                                184047
     C*******************Endif                                                  184047
      *******************                                                       184047
     C*******************Else                                                   184047
      *******************                                                       184047
      **Else*the*first*line is empty.  The other 2 lines must be too.           184047
     C*******************If        PREGRP2 <> *Blanks  OR                       184047
     C*******************          PREGRP3 <> *Blanks                           184047
     C*******************Eval      Idx            =   Idx+1                     184047
     C*******************Eval      RetCodeIn      =   'Error'                   184047
     C*******************Eval      MsgIdXAr(Idx)  =   'RFV0182'                 184047
     C*******************Eval      FldNamXAr(Idx) =   DDSName                   184047
     C*******************Eval      OKRGRP2 = 'N'                                184047
     C*******************Eval      OKRGRP3 = 'N'                                184047
     C*******************Endif                                                  184047
      *******************                                                       184047
     C*******************Endif                                                  184047
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PREGRP1 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PREGRP1       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   Eval      OKRGRP1 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PREGRP2 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PREGRP2       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREGRP2'                  CAP084
     C                   Eval      OKRGRP2 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PREGRP3 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PREGRP3       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREGRP3'                  CAP084
     C                   Eval      OKRGRP3 = 'N'
     C                   Endif
     C                   Endif
 
     C                   Return
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        Begsr
 
     C     *Entry        PLIST
 
      ** INPUTS
 
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
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
     C                   Parm                    OkFlags
 
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
