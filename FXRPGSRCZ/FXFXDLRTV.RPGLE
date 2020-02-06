     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal Retrieve + Act/Deal Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Foriegn Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLRTV - FX DEAL RETRIEVE                                 *
      *              (WITH ACTION CODE VERSUS DEAL NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves an FX deal from             *
      *             the database. As it does so, it validates the     *
      *             action code and deal number.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL098             Date 06Oct17               *      
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 30May14               *
      *                 MD000091           Date 07May13               *
      *                 AR585869           Date 07Nov12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSW212             Date 03May12               *
      *                 AR996631           Date 28Jun12               *
      *                 259924A            Date 29May09               *
      *                 259924             Date 10May09               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      *                 BUG27841           Date 09Aug10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247266             Date 21Jun07               *
      *                 247124             Date 17Apr07               *
      *                 BUG13208           Date 03Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CGL058             Date 30Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 237063             Date 20Nov05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 BUG5517            Date 19Jan05               *
      *                 BUG4422            Date 01Oct04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      *                 176841             Date 09May00               *
      *                 180687             Date 11Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 144816             Date 07Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006  *CREATE    Date 04Mar97               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL098 - Cancelled Deal Numbers                              *      
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions (Recompile)*
      *  MD000091 - Event Codes Substitution                          *
      *  AR585869 - Reversal of another leg of a swap causes double   *
      *             postings. Reverse BUG13208 (Child: AR585870)      *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  AR996631 - System should not validate deal number range      *
      *             if PEA indicator is on                            *
      *  259924A- Amended so that system will validate front office   *
      *           ID that came from Meridian.                         *
      *  259924 - Amended so that program will check front office ID  *
      *           in all deals.                                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG27841 - Status changes to Requires Reauthorisation        *
      *             during Delete Action                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247266 - When deal is reversed, saved it as unauthorised.    *
      *  247124 - If branch code does not exist, do same process      *
      *           as for MM deal.                                     *
      *  BUG13208 - Cannot delete far leg of swap deal                *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL058 - Default Branch Code                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  BUG4422- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER for each user authorisation check.    *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDL008 - Continuous Linked Settlement (Recompile)            *
      *  176841 - User should be able to re-authorise a deal if       *
      *           'FX Authorisation Required' is 'N' and              *
      *           'FX Reauthorise Amended deals' is 'Y'.              *
      *  180687 - On insert OT timestamp being populated by OP value  *
      *  CAP051 - Authomatic Authorisation (FX Part)                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXDEALPP               *
      *  144816 - Deletion of options not allowed if deleted takedowns*
      *  CAP006 - Do not check for FXM0164 if deal number has been    *
      *           generated through APIs                              *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDELFOI)
     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDEALXX)
     FDLCANCI0  IF   E           K DISK    INFSR(*PSSR)                                       CDL098
      *                                                                                       CDL098
     FFXTDOPLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXTDOPL0)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
 
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
                                                                                              CAP185
     FFRNTOFCL1 IF   E           K DISK    INFSR(*PSSR)                                       259924
     F                                     RENAME(MMDELDP0:MMDELDX0)                          259924
     F                                     RENAME(MMDENBP0:MMDENBX0)                          259924
     F                                     RENAME(MMDENSP0:MMDENSX0)                          259924
     F                                     RENAME(ABDEALP0:ABDEALX0)                          259924
     F                                     RENAME(FXDEALP0:FXDEALX0)                          259924
     F                                     RENAME(DEALSDGF:DEALSGX0)                          259924
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features File

      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16

     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)
      ** Deal in File Format

     D/COPY WNCPYSRC,FXFXDLID01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0

      ** Variables introduced by CAS004                                                       CAS004
     D PRTCD           S              7                                                       CAS004
     D POPTN           S              7                                                       CAS004
     D PSARD           S              6                                                       CAS004
     D CAS004          S              1                                                       CAS004
     D*KFSDLN***       S              6S 0                                             CAS004 CLE148
     D KFSDLN          S              6A                                                      CLE148
     D KFSMOD          S              2                                                       CAS004
     D WI              S              3P 0                                                    CAS004
                                                                                              CAS004
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D CDL098          S              1                                                       CDL098
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D PRetCode        S              7A                                                      CSD015
     D POption         S              7A                                                      CSD015
     D PFunc           S              8A                                                      CSD015
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
     D P@OP01          S             20A                                                    AR996631
     D P@VL01          S            200A                                                    AR996631
     D P@OP02          S             20A                                                    AR996631
     D P@VL02          S            200A                                                    AR996631
     D P@OP03          S             20A                                                    AR996631
     D P@VL03          S            200A                                                    AR996631
     D P@OP04          S             20A                                                    AR996631
     D P@VL04          S            200A                                                    AR996631
     D P@OP05          S             20A                                                    AR996631
     D P@VL05          S            200A                                                    AR996631
     D P@OP06          S             20A                                                    AR996631
     D P@VL06          S            200A                                                    AR996631
     D P@OP07          S             20A                                                    AR996631
     D P@VL07          S            200A                                                    AR996631
     D P@OP08          S             20A                                                    AR996631
     D P@VL08          S            200A                                                    AR996631
     D P@OP09          S             20A                                                    AR996631
     D P@VL09          S            200A                                                    AR996631
     D P@OP10          S             20A                                                    AR996631
     D P@VL10          S            200A                                                    AR996631
     D WPEAInd         S              1A                                                    AR996631
     D CSC054          S              1A                                                    AR996631
      *                                                                                     AR996631
     D/COPY WNCPYSRC,FXH00047

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
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     ModeofOp      OREQ      ' '                                                       259924A
     C     FOTRID        ANDNE     ' '                                                       259924A
     C     DDACTN        ANDEQ     'I'                                                       259924A
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,FXH00048
     C                   END
      *
      * VALIDATE ACTION CODE & DEAL NUMBER
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,FXFXDLIC01
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the deal no. is not to be generated.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDDLNO        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
     C/COPY WNCPYSRC,FXH00049
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ACSSEM
     C                   END
     C                   END
                                                                                CAP051
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'                     CAP051
      * DO AUTHORISATION ARE REQUIRED                                           CAP051
     C     ModeofOp      IFEQ      '      '                                     CAP051
     C                   MOVE      *BLANKS       FHAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0100'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS DEAL WITH FRONT OFFICE TRANSACTION ID
      *
     C*****FOTRID        CHAIN     FXDELFOI                           99                      259924
     C     FOTRID        CHAIN     FRNTOFCL1                          99                      259924
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE MIDAS DEAL NUMBER
      *
     C                   MOVEL     FHDN38        DDDLNO

     C                   END
      *
      * IF FRONT OFFICE ASSOCIATED TRANSACTION ID IS NOT BLANK
      *
     C     FOASID        IFNE      *BLANK
      *
      * ERROR IF DEAL NOT FOUND
      *
     C     FOASID        CHAIN     FXDELFOI                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      ** If insert then clear assoc office id tran timestamp                    180687
     C                   IF        DDACTN = 'I'                                 180687
     C                   CLEAR                   FHTMST                         180687
     C                   ENDIF                                                  180687
      *                                                                         180687
      * UPDATE MIDAS ASSOCIATED DEAL NUMBER
      *
     C                   MOVEL     FHDN38        DDSDNO
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Check action code is valid. If authorizations are not in
      ** the system, then action code X is not allowed
      *
     C     BNFXAU        IFEQ      'N'
     C     BNFXRA        ANDEQ     'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0161'     MsgIdArr(Ix)
     C                   END
     C                   ELSE                                                                 176841
     C*****BNFXAU        IFNE      'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0160'     MsgIdArr(Ix)
     C                   END
     C                   END                                                                  176841
      *
      * Deal Number can't be 0's or all 9's
      *
     C     DDDLNO        IFEQ      '000000'
     C     DDDLNO        OREQ      '999999'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0111'     MsgIdArr(Ix)
     C                   END
      *
      ** Check that the deal number has been entered
      ** (unless action code is insert)
      *
     C     DDACTN        IFNE      'I'
     C     DDDLNO        ANDEQ     *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0111'     MsgIdArr(Ix)
     C                   END
      *
      ** Check that the deal number is numeric if it is defined
      *
     C                   TESTN                   DDDLNO               9899
     C     DDDLNO        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0162'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      **  Set up the deal number as a numeric field.
      *
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ** Check record exists on LF/FXDEALLL and is live
      *
     C     @@DLNO        CHAIN     FXDEALLL                           99
     C     *IN99         IFEQ      '1'
     C     FHDLTF        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0167'     MsgIdArr(Ix)
      *
      ** else the deal status must be C,A,R or E
      *
     C                   ELSE
     C     FHDSTS        IFNE      'C'
     C     FHDSTS        ANDNE     'A'
     C     FHDSTS        ANDNE     'R'
     C     FHDSTS        ANDNE     'E'
     C     FHDSTS        ANDNE     'M'
     C/COPY WNCPYSRC,FXFXDLIC02
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0168'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR
      *
      ** Check a live record exists
      *
     C     @@DLNO        CHAIN     FXDEALLL                           99
     C     *IN99         IFEQ      '1'
     C     FHDLTF        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0165'     MsgIdArr(Ix)
      *
      ** else the deal status must be C,or R
      *
     C                   ELSE
     C     FHDSTS        IFNE      'C'
     C     FHDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0171'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** if the deal is deleted then it is invalid
      *
     C     FHDDLT        IFNE      ' '
     C*****FHTYPE        ANDNE     'SW'                                            BUG13208 AR585869
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0172'     MsgIdArr(Ix)
     C                   END
     C                   END
      **************                                                                BUG4422  BUG5517
      ***Retrieve*latest content of DTAARA/ZMUSER                                   BUG4422  BUG5517
      **************                                                                BUG4422  BUG5517
     C**************     IN        ZMUSER                                           BUG4422  BUG5517
     C**************     UNLOCK    ZMUSER                                           BUG4422  BUG5517
      *                                                                                       CDL010
      ** User cannot authorise an authorised deal or deal requires                            CDL010
      ** double authorisation.                                                                CDL010
      *                                                                                       CDL010
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C     CAP185        IFEQ      'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'N'                                                        CAP185
     C     CAP185        OREQ      'Y'                                                        CAP185
     C     @AUTHO        ANDEQ     'Y'                                                        CAP185
     C     @TYPE         ANDEQ     '1'                                                        CAP185
     C*****CDL010        IFEQ      'Y'                                                 CDL010 247266
     C*****FHUSER        ANDEQ     ZUSER                                               CDL010 247266
     C**********         MOVE      'N'           OKDLNO                                CDL010 247266
     C**********         ADD       1             Ix                                    CDL010 247266
     C**********         MOVEL     'DDDLNO'      FldNameArr(Ix)                        CDL010 247266
     C**********         MOVEL     'FXM0702'     MsgIdArr(Ix)                          CDL010 247266
     C**********         END                                                           CDL010 247266
     C     CDL010        IFEQ      'Y'                                                      BUG27841
     C     FHUSER        ANDEQ     ZUSER                                                    BUG27841
     C                   MOVE      'N'           OKDLNO                                     BUG27841
     C                   ADD       1             Ix                                         BUG27841
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                             BUG27841
     C                   MOVEL     'FXM0702'     MsgIdArr(Ix)                               BUG27841
     C                   END                                                                BUG27841
                                                                                              CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CDL010
     C/COPY WNCPYSRC,FXFXDLIC03
     C                   END
      *
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN) AND OKDLNO <> 'N'                       CSD015
                                                                                              CSD015
      ** If the FRA transaction exists, setup error message                                   CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'FXDEALPP'                                     CSD015
     C                   MOVEL     FHDN38        WIdntifier                                   CSD015
     C                   EVAL      WBranch = FHMBCA                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                         CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   EVAL      FldNameArr(Ix) = 'DDDLNO'                                  CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** Check deal does not exist on LF/DEALSALL
      *
     C     @@DLNO        SETLL     DEALSALL                               99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0163'     MsgIdArr(Ix)
     C                   GOTO      EVALAI                                                     CDL098
     C                   ELSE
      *                                                                                       CDL098
     C     CDL098        IFeq      'Y'                                                        CDL098
     C     @@DLNO        Setll     DLCANCI0                               99                  CDL098
      *                                                                                       CDL098
     C     *IN99         IFeq      '1'                                                        CDL098
     C                   Move      'N'           OKDLNO                                       CDL098
     C                   Add       1             Ix                                           CDL098
     C                   MoveL     'DDDLNO'      FldNameArr(Ix)                               CDL098
     C                   MoveL     'FXM7004'     MsgIdArr(Ix)                                 CDL098
     C                   GOTO      EVALAI                                                     CDL098
     C                   Endif                                                                CDL098
     C                   Endif                                                                CDL098
      *                                                                                       CDL098
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      *
      ** check deal number is in allowed range
      ** (do not check if deal number generated through APIs)                   CAP006
      *
     C     @@DLNO        IFLT      NORDLN
     C     ModeofOp      ANDNE     '*FRONT'                                     CAP006
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0164'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   ENDIF                                                              AR996631
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ** Check that the record exists
      *
     C     @@DLNO        CHAIN     FXDEALLL                           99
     C     *IN99         IFEQ      '1'
     C     FHDLTF        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0167'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** If deleted then it is invalid
      *
     C     FHDDLT        IFNE      ' '
     C*****FHTYPE        ANDNE     'SW'                                            BUG13208 AR585869
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0172'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** if the record exists the status must be C A or R
      *
     C     FHDSTS        IFNE      'C'
     C     FHDSTS        ANDNE     'A'
     C     FHDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0166'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Deal must exist
      *
     C     @@DLNO        CHAIN     FXDEALLL                           99
     C     *IN99         IFEQ      '1'
     C     FHDLTF        ORNE      ' '
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0167'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** The delete indicator must be blank
      *
     C     FHDDLT        IFNE      ' '
     C*****FHTYPE        ANDNE     'SW'                                            BUG13208 AR585869
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0172'     MsgIdArr(Ix)
     C                   ELSE
      *
      *  Deal status must be C, A or E
      *
     C     FHDSTS        IFNE      'C'
     C     FHDSTS        ANDNE     'A'
     C     FHDSTS        ANDNE     'E'
     C*****FHDSTS        ANDNE     'R'                                               247266 BUG27841
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0169'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
      ** Deletion not permitted if deal is included in a net.
     C     CDL002        IFEQ      'Y'
      *
     C     FHNBRF        IFNE      *BLANKS
     C     FHNSRF        ORNE      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C     FHNBRF        IFNE      *BLANKS
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM5026'     MsgIdArr(Ix)
     C**********         MOVEL(P)  FHNBRF        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL(P)  FHNBRF        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C     FHNSRF        IFNE      *BLANKS
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM5026'     MsgIdArr(Ix)
     C**********         MOVEL(P)  FHNSRF        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL(P)  FHNSRF        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the deal is an option,
      ** Check that no option takedowns exist for it
      *
     C     OKDLNO        IFNE      'N'
     C     FHTYPE        ANDEQ     'OP'
      *
     C     FXTDOK        SETLL     FXTDOPLL
     C     FXTDOK        READE     FXTDOPLL                               99    *
      *
     C     *IN99         DOWEQ     '0'
      *
     C*****FHDLTF        IFNE      ' '                                          144816
     C*****FHDDLT        ORNE      ' '                                          144816
     C     FHDLTF        IFEQ      ' '                                          144816
     C     FHDDLT        ANDEQ     ' '                                          144816
     C                   MOVE      '1'           *IN99
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'FXM0170'     MsgIdArr(Ix)
     C                   ELSE
     C     FXTDOK        READE     FXTDOPLL                               99    *
     C                   END
      *
     C                   END                                                    *IN99 DOWEQ '0'
      *
      * Re-access FX deal
      *
     C     @@DLNO        CHAIN     FXDEALLL                           99
     C                   END
                                                                                              CAS004
      ** Issue warning if record to be deleted is a hedged item                               CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C**********         EVAL      KFSDLN = @@DLNO                                     CAS004 CLE148
     C                   MOVEL     @@DLNO        KFSDLN                                       CLE148
                                                                                              CAS004
     C     KASHTRN       SETLL     ASHTRNLA                                                   CAS004
     C     KASHTRN       READE     ASHTRNLA                                                   CAS004
                                                                                              CAS004
     C                   DOW       NOT %EOF(ASHTRNLA)                                         CAS004
                                                                                              CAS004
     C     FSHEDI        CHAIN     ASHGLKL1                                                   CAS004
                                                                                              CAS004
      ** If record is not found, database error                                               CAS004
                                                                                              CAS004
     C                   IF        NOT %FOUND(ASHGLKL1)                                       CAS004
     C                   EVAL      DBFILE = 'ASHGLKPD'                                        CAS004
     C                   MOVEL     FSHEDI        DBKEY                                        CAS004
     C                   EVAL      DBASE = 907                                                CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        FSHTID = 'D' and FSRECI = 'D' or                           CAS004
     C                             FSHTID = 'D' and FSRECI = 'X'                              CAS004
     C                   MOVE      'W'           OKDLNO                                       CAS004
     C                   ADD       1             WI                                           CAS004
     C                   MOVEL     'DDDLNO'      WFldNamArr(WI)                               CAS004
     C                   MOVEL     'FXM5060'     WMsgIdArr(WI)                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     KASHTRN       READE     ASHTRNLA                                                   CAS004
     C                   ENDDO                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      * This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** If insertion
      ** Set up the booking branch code field with default value
      *
     C     DDACTN        IFEQ      'I'
      *
     C     DDBRSN        IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
      *                                                                                       CGL058
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   MOVE      BRC           DDBRSN
     C                   END                                                                  CGL058
      *                                                                                       CGL058
     C                   ELSE
     C                   MOVE      DDBRSN        ZBR
     C                   END
      *
      ** Else, Set up the booking branch code field with value from deal
      *
     C                   ELSE
     C                   MOVE      FHMBCA        ZBR
     C                   END
      *
      ** If insertion
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Check that the branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
      *                                                                                       CGL058
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRSN        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C                   ELSE                                                                 CGL058
     C                   CALL      'AOBRCHR1'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*KEY   '     @OPTN                                        CGL058
     C                   PARM      ZBR           @BRCA                                        CGL058
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL058
     C                   END                                                                  CGL058
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBRSN
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRSN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0115'     MsgIdArr(Ix)
     C                   GOTO      EACSSE                                                     247124
     C                   ELSE
      *                                                                                       CGL058
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   MOVEL     A8BRCD        DDBRSN
     C                   END                                                                  CGL058
     C                   MOVEL     A8BRCD        ZBR
     C                   END
     C                   END
      *
      ** If valid branch on insert then check user authority to
      ** action/branch, also if not insert.
      *
     C     DDACTN        IFEQ      'I'
     C     @RTCD         ANDEQ     *BLANKS
     C     DDACTN        ORNE      'I'
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    ERR               1 0
      *
      * no valid action codes for user/branch combination
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           OKACTN
      *
      ** If insert, then branch is in error else deal number
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRSN
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   END
      *
      * this action code invalid for user/branch combination
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           OKACTN
      *
      ** If insert, then branch is in error else deal number
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRSN
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ** By now the booking branch must be valid so if originating
      ** branch is blank, default it to the booking branch
      *
     C     DDORBR        IFEQ      *BLANKS
     C                   MOVE      DDBRSN        DDORBR
     C                   END
      *
      ** Originating branch code validation only when
      ** originating branch used flag is YES and originating
      ** branch has been entered (or set to booking branch above)
      *
     C     BKOBRU        IFEQ      'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
      ** Check that originating branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
      *                                                                                       CGL058
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDORBR        @BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *                                                                                       CGL058
     C                   ELSE                                                                 CGL058
     C                   CALL      'AOBRCHR1'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*KEY   '     @OPTN                                        CGL058
     C                   PARM      ZBR           @BRCA                                        CGL058
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL058
     C                   END                                                                  CGL058
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Ix
     C                   MOVEL     'DDORBR'      FldNameArr(Ix)
     C                   MOVEL     'FXM0289'     MsgIdArr(Ix)
     C                   GOTO      EACSSE                                                     247124
     C                   ELSE
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   MOVEL     A8BRCD        DDORBR
     C                   END                                                                  CGL058
     C                   END
     C                   END
      *
      **  If action code not E, do user/originating branch validation
      *
     C     DDACTN        IFNE      'E'
     C     BKOBUV        ANDEQ     'Y'
     C/COPY WNCPYSRC,FXFXDLIC06
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C/COPY WNCPYSRC,FXFXDLIC07
     C                   MOVE      FHORBR        ZOBRX
     C                   ELSE
     C     CGL058        IFEQ      'N'                                                        CGL058
     C                   MOVE      DDORBR        ZOBRX
     C                   ELSE                                                                 CGL058
     C                   MOVE      ZBR           ZOBRX                                        CGL058
     C                   END                                                                  CGL058
     C                   END
      *
     C                   CALL      'ZVOBU'
     C                   PARM                    ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      * no valid origination branches for this user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   END
      *
      * this originating branch invalid for user
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
     C**********         ENDSR                                                                247124
     C     EACSSE        ENDSR                                                                247124
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   DealFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKBRSN
     C                   MOVEL     'Y'           OKORBR
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO            6
      *
      * Booking branch
     C                   PARM                    DDBRSN            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM                    OKBRSN            1
      *
      * OK - Originating branch
     C                   PARM                    OKORBR            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM                    WI                                           CAS004
                                                                                              CAS004
     C/COPY WNCPYSRC,FXFXDLIC04
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLRTV'   DBPGM
      *
      * Key Lists
      *
     C     FXTDOK        KLIST
     C                   KFLD                    DDDLNO
                                                                                              CAS004
     C     KASHTRN       KLIST                                                                CAS004
     C                   KFLD                    KFSMOD                                       CAS004
     C                   KFLD                    KFSDLN                                       CAS004
                                                                                              CAS004
     C                   EVAL      KFSMOD = 'DL'                                              CAS004
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS DEAL NUMBER RECORD
      *
     C     1             CHAIN     FDDLNMLL                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C*
     C**    Check if FX Netting is installed
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CDL002'      @SARD             6
     C                   PARM                    DSFDY
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CDL002            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CDL002
     C                   ELSE
     C*
     C**    Database error processing
     C*
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *
     C                   MOVEL     'CDL002'      DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                              CAS004
      ** Check if Hedge Accounting is installed                                               CAS004
                                                                                              CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRTCD                                        CAS004
     C                   PARM      '*VERIFY'     POPTN                                        CAS004
     C                   PARM      'CAS004'      PSARD                                        CAS004
     C                   PARM                    DSFDY                                        CAS004
                                                                                              CAS004
      ** Database error processing                                                            CAS004
                                                                                              CAS004
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                    CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE = 906                                                CAS004
     C                   EVAL      DBKEY = 'CAS004'                                           CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        PRTCD = *BLANKS                                            CAS004
     C                   MOVE      'Y'           CAS004                                       CAS004
     C                   ELSE                                                                 CAS004
     C                   MOVE      'N'           CAS004                                       CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       @RTCD             7                          CDL010
     C                   PARM      '*VERIFY'     @OPTN             7                          CDL010
     C                   PARM      'CDL010'      @SARD             6                          CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C*                                                                                       CDL010
     C     @RTCD         IFEQ      *BLANK                                                     CDL010
     C                   MOVE      'Y'           CDL010            1                          CDL010
     C                   ELSE                                                                 CDL010
     C     @RTCD         IFEQ      '*NRF'                                                     CDL010
     C                   MOVE      'N'           CDL010                                       CDL010
     C                   ELSE                                                                 CDL010
     C*                                                                                       CDL010
     C**    Database error processing                                                         CDL010
     C*                                                                                       CDL010
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CDL010
     C                   MOVEL     '906'         DBASE                          * DBERR 906 * CDL010
     C                   MOVEL     'CDL010'      DBKEY                          ************* CDL010
     C                   EXSR      *PSSR                                                      CDL010
     C                   END                                                                  CDL010
     C                   END                                                                  CDL010
      *                                                                                       CDL010
      *                                                                                       CGL058
      ** Check if Default Branch is installed                                                 CGL058
      *                                                                                       CGL058
     C                   CALL      'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*VERIFY'     @OPTN                                        CGL058
     C                   PARM      'CGL058'      @SARD                                        CGL058
     C                   PARM                    DSFDY                                        CGL058
      *                                                                                       CGL058
     C     @RTCD         IFEQ      *BLANK                                                     CGL058
     C                   MOVE      'Y'           CGL058            1                          CGL058
     C                   ELSE                                                                 CGL058
     C     @RTCD         IFEQ      '*NRF'                                                     CGL058
     C                   MOVE      'N'           CGL058                                       CGL058
     C                   ELSE                                                                 CGL058
      *                                                                                       CGL058
      **    Database error processing                                                         CGL058
      *                                                                                       CGL058
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CGL058
     C                   MOVEL     '908'         DBASE                          * DBERR 908 * CGL058
     C                   MOVEL     'CGL058'      DBKEY                          ************* CGL058
     C                   EXSR      *PSSR                                                      CGL058
     C                   END                                                                  CGL058
     C                   END                                                                  CGL058
     C/COPY WNCPYSRC,FXFXDLIC05
      *************                                                                          BUG5517
      ****GET*ZMUSER to access default branch.                                               BUG5517
      *************                                                                          BUG5517
     C******DTAARA*      DEFINE                  ZMUSER                                      BUG5517
     C*************      IN        ZMUSER                                                    BUG5517
     C*************      UNLOCK    ZMUSER                                                    BUG5517
      *
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   If        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'FXDL'        @APINAME                                     CAP185
     C     @APINAME      CHAIN     APICFGL0                                                   CAP185
     C                   IF        %FOUND(APICFGL0)                                           CAP185
     C                   MOVE      APAUT         @AUTHO            1                          CAP185
     C                   ENDIF                                                                CAP185
      *                                                                                       CAP185
     C                   ELSE                                                                 CAP185
     C                   IF        @RTCD = '*NRF'                                             CAP185
     C                   MOVE      'N'           CAP185                                       CAP185
     C                   ELSE                                                                 CAP185
     C*                                                                                       CAP185
     C**    Database error processing                                                         CAP185
     C*                                                                                       CAP185
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CAP185
     C                   MOVEL     '185'         DBASE                          * DBERR 185 * CAP185
     C                   MOVEL     'CAP185'      DBKEY                          ************* CAP185
     C                   EXSR      *PSSR                                                      CAP185
     C                   END                                                                  CAP185
     C                   END                                                                  CAP185
      *                                                                                       CAP185
                                                                                              CSD015
      ** Check if CSC011 is installed                                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *Blanks                                         CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSC011 = 'N'                                               CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSC011'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 903                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancment (CSD015) is on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS AND                                    CSD015
     C                             PRetCode <> '*NRF   '                                      CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF'                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 909                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Check if Cancelled Deal Numbers Enhancement (CDL098) is on.                          CDL098
                                                                                              CDL098
     C                   EVAL      CDL098 = 'N'                                               CDL098
     C                   CALLB     'AOSARDR0'                                                 CDL098
     C                   PARM      *BLANKS       PRetCode                                     CDL098
     C                   PARM      '*VERIFY'     POption                                      CDL098
     C                   PARM      'CDL098'      PSard                                        CDL098
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL098
                                                                                              CDL098
      ** Database error                                                                       CDL098
                                                                                              CDL098
     C                   IF        (PRetCode <> *BLANKS) and                                  CDL098
     C                             (PRetCode <> '*NRF   ')                                    CDL098
     C     *LOCK         IN        LDA                                                        CDL098
     C                   EVAL      DBKEY = 'CDL098'                                           CDL098
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL098
     C                   EVAL      DBASE = 910                                                CDL098
     C                   OUT       LDA                                                        CDL098
     C                   EXSR      *PSSR                                                      CDL098
     C                   ENDIF                                                                CDL098
      *                                                                                       CDL098
     C                   IF        PRetCode = *BLANKS                                         CDL098
     C                   EVAL      CDL098 = 'Y'                                               CDL098
     C                   ENDIF                                                                CDL098
      *                                                                                       CDL098
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       @RTCD                                      AR996631
     C                   PARM      '*VERIFY'     @OPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
      *                                                                                     AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
      *                                                                                     AR996631
     C                   IF        @RTCD <> *BLANKS                                         AR996631
     C                             AND @RTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        @RTCD = *BLANKS                                          AR996631
     C                   EVAL      CSC054 = 'Y'                                             AR996631
      *                                                                                     AR996631
     C                   CALL      'AOSVALR0'                                               AR996631
     C                   PARM      *BLANKS       PRetCode                                   AR996631
     C                   PARM      PSysVal1      P@OP01                                     AR996631
     C                   PARM      *BLANKS       P@VL01                                     AR996631
     C                   PARM      *BLANKS       P@OP02                                     AR996631
     C                   PARM      *BLANKS       P@VL02                                     AR996631
     C                   PARM      *BLANKS       P@OP03                                     AR996631
     C                   PARM      *BLANKS       P@VL03                                     AR996631
     C                   PARM      *BLANKS       P@OP04                                     AR996631
     C                   PARM      *BLANKS       P@VL04                                     AR996631
     C                   PARM      *BLANKS       P@OP05                                     AR996631
     C                   PARM      *BLANKS       P@VL05                                     AR996631
     C                   PARM      *BLANKS       P@OP06                                     AR996631
     C                   PARM      *BLANKS       P@VL06                                     AR996631
     C                   PARM      *BLANKS       P@OP07                                     AR996631
     C                   PARM      *BLANKS       P@VL07                                     AR996631
     C                   PARM      *BLANKS       P@OP08                                     AR996631
     C                   PARM      *BLANKS       P@VL08                                     AR996631
     C                   PARM      *BLANKS       P@OP09                                     AR996631
     C                   PARM      *BLANKS       P@VL09                                     AR996631
     C                   PARM      *BLANKS       P@OP10                                     AR996631
     C                   PARM      *BLANKS       P@VL10                                     AR996631
      *                                                                                     AR996631
     C                   IF        PRetCode  <> *BLANKS                                     AR996631
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR996631
     C                   EVAL      DBKEy = '*KEY   '                                        AR996631
     C                   EVAL      DBase = 4                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   MOVEL     P@VL01        WPEAInd                                    AR996631
      *                                                                                     AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
