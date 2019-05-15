     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased Retr + Act/Deal Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPRTV - LOANS/DEPOSITS RETRIEVE                          *
      *              (WITH ACTION CODE VERSUS DEAL NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves an NA Purchase deal from    *
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
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 14May13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR996631           Date 28Jun12               *
      *                 259924A            Date 28May09               *
      *                 259924             Date 10May09               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185             Date 21Apr06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 04May04               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 BUG4422            Date 01Oct04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 208100             Date 05Aug02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 176841             Date 09May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 11Mar97               *
      *                 CAP002  *CREATE    Date 10Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL098 - Cancelled Deal Numbers                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR996631 - System should not validate deal number range      *
      *             if PEA indicator is on                            *
      *  259924A- Amended so that system will validate front office   *
      *           ID that came from Meridian.                         *
      *  259924 - Amended so that program will check front office ID  *
      *           in all deals.                                       *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CAP185 - MQ Series Interface                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  BUG4422- Authorisation Error on NASP.  Retrieve contents of  *
      *           DTAARA/ZMUSER for each user authorisation check.    *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
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
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  208100 - Check for further errors in subroutine VALAX.       *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  176841 - User should be able to re-authorise a deal if       *
      *           'MM Authorisation Required' is 'N' and              *
      *           'MM Reauthorise Amended deals' is 'Y'.              *
      *  CAP006 - Do not check for MMM0164 if deal number has been    *
      *           generated through APIs                              *
      *         - Amend incorrect error messages                      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDENBP0)
     F                                     RENAME(MMDENBP0:MMDELFOI)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
     FDLCANCI0  IF   E           K DISK    INFSR(*PSSR)                                       CDL098
      *                                                                                       CDL098
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP2)
                                                                                              CAS004
      ** Midas AS Hedge Transation Fike                                                       CAS004
     FASHTRNLA  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
                                                                                              CAS004
      ** Midas AS Hedge Linkage File                                                          CAS004
     FASHGLKL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     PREFIX(LK:2)                                       CAS004
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
     FDLFEEDL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS009
                                                                                              CAP185
      ** Midas AP API Configuration                                                           CAP185
     FAPICFGL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP185
     FFRNTOFCL1 IF   E           K DISK    INFSR(*PSSR)                                       259924
     F                                     RENAME(MMDELDP0:MMDELDX0)                          259924
     F                                     RENAME(MMDENBP0:MMDENBX0)                          259924
     F                                     RENAME(MMDENSP0:MMDENSX0)                          259924
     F                                     RENAME(ABDEALP0:ABDEALX0)                          259924
     F                                     RENAME(FXDEALP0:FXDEALX0)                          259924
     F                                     RENAME(DEALSDGF:DEALSGX0)                          259924
 
     F/COPY WNCPYSRC,MMNASPIF01
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
 
      **  Data structure for file status of MM deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS004
     D  SCLCD        E                     EXTFLD(LCD)                                        CAS004
      ** External DS for Switchable Features Details                                          CAS004
                                                                                              CAS004
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** External DS for Watch List Checking Details                                          CSD015
                                                                                              CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
      ** 24X7 status data area                                                                CSD015
                                                                                              CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
      ** SD data area                                                                         CSD015
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DealFilFmt    E DS                  EXTNAME(MMDENBPP)
      ** Deal in File Format
                                                                                              CAS004
     D                 DS                                                                     CAS004
     D FSHEDI                  1      6  0                                                    CAS004
     D FSHEDI_Char             1      6                                                       CAS004
     D/COPY WNCPYSRC,MMH00086
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      **  Data structure for date in, to change format.
     D                 DS
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
                                                                                              CAS004
     D PRetCode        S              7A                                                      CAS004
     D POption         S              7A                                                      CAS004
     D PSard           S              6A                                                      CAS004
                                                                                              CAS004
     D CAS004          S              1A                                                      CAS004
     D CAS009          S              1A                                                      CAS009
                                                                                              CAS004
     D KMod            S              2A                                                      CAS004
     D*KDlNo****       S              6  0                                             CAS004 CLE148
     D KDlNo           S              6                                                       CLE148
                                                                                              CAS004
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
      *
      **  AOWLCCR0 Function Code Parameter.                                                   CSD015
     D  PFuncCode      S              8                                                       CSD015
                                                                                              CSD015
      **  Compliance Watch Enhancement Indicator.                                             CSD015
     D  CSD015         S              1    INZ('N')                                           CSD015
                                                                                              CSD015
      ** Cancelled Deal Numbers                                                               CDL098
     D  CDL098         S              1    INZ('N')                                           CDL098
                                                                                              CDL098
      ** 24X7 Midas Availability Indicator                                                    CSD015
     D CSC011          S              1    INZ('N')                                           CSD015
                                                                                              CSD015
      **  Compliance Watch Hit List Key Fields.                                               CSD015
     D  KFuncType      S              8                                                       CSD015
     D  KIden          S             40                                                       CSD015
     D  KBranch        S              3                                                       CSD015
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CSD015
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
     D/COPY WNCPYSRC,MMH00087
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
     C                   EXSR      INIT
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        ModeofOp = '      '                                        CAP086
     C                   EVAL      HLAUTH = *BLANKS                                           CAP086
     C                   ENDIF                                                                CAP086
 
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
     C     ModeofOp      IFEQ      '*FRONT'
     C     ModeofOp      OREQ      ' '                                                       259924A
     C     FOTRID        ANDNE     ' '                                                       259924A
     C     DDACTN        ANDEQ     'I'                                                       259924A
     C                   EXSR      VFRNT
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
     C/COPY WNCPYSRC,MMH00088
     C                   END
 
      **  Validate Action code & deal number
     C                   EXSR      VAL
 
      **  Carry out no further validation if errors have occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'X'
     C                   EXSR      VALACX
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if the deal no. is not to be generated.)
     C     DDACTN        IFEQ      'I'
     C     DDDLNO        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'A'
     C                   EXSR      VALACA
     C                   END
 
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
     C/COPY WNCPYSRC,MMH00089
 
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKDLNO        OREQ      'N'
     C                   RETURN
     C                   END
 
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
 
     C/COPY WNCPYSRC,MMNASPIC01
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      * ERROR IF ACTION CODE IS NOT 'I', 'A, 'D' or 'X'
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
 
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
 
      ** ACCESS DEAL WITH FRONT OFFICE TRANSACTION ID
     C*****FOTRID        CHAIN     MMDELFOI                           99                      259924
     C     FOTRID        CHAIN     FRNTOFCL1                          99                      259924
 
      ** IF INSERT
     C     DDACTN        IFEQ      'I'
 
      ** FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
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
 
     C                   ELSE
 
      ** IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
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
 
      ** IF NOT INSERT, UPDATE MIDAS DEAL NUMBER
     C                   MOVEL     HLDN38        DDDLNO
 
     C                   END
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VAL - VALIDATION OF ACTION CODE AND DEAL NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      **  Check that the action code is valid; if authorizations are
      **  not in the system, then action code X is not allowed.
 
     C     BNMMAU        IFEQ      'N'
     C     BNMMRA        ANDEQ     'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0161'     MsgIdArr(Ix)
     C                   END
     C                   ELSE                                                                 176841
 
     C*****BNMMAU        IFNE      'N'                                                        176841
     C     DDACTN        IFNE      *BLANK                                                     176841
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMM0160'     MsgIdArr(Ix)
     C                   END
     C                   END                                                                  176841
 
      **  If the deal number is not blank, check that it is numeric.
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     DDDLNO        ORNE      *BLANKS
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0162'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
 
      **  Set up the deal number as a numeric field.
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
 
      **  If there is no valid record on MMDEALLL, it is an error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDENBP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HLDLTF        ORNE      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   ELSE
 
      **  If the deal status is not C,A, R or M, it is an error.
     C     HLDSTS        IFNE      'C'
     C     HLDSTS        ANDNE     'A'
     C     HLDSTS        ANDNE     'R'
     C     HLDSTS        ANDNE     'M'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0168'     MsgIdArr(Ix)
     C                   GOTO      EVALAE
     C                   END
     C                   END
 
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - VALIDATION OF ACTION CODE 'X'
      *****************************************************************
     C     VALACX        BEGSR
 
     C**  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDENBP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HLDLTF        ORNE      *BLANK
     C     HLDDLT        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0165'     MsgIdArr(Ix)
     C                   GOTO      EVALAX
     C                   ELSE
 
      **  If the deal status is not C or R, it is an error.
     C     HLDSTS        IFNE      'C'
     C     HLDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0171'     MsgIdArr(Ix)
     C                   GOTO      EVALAX                                                     208100
     C                   END
     C                   END
 
      ** Retrieve latest content of DTAARA/ZMUSER                                            BUG4422
      *                                                                                      BUG4422
     C                   IN        ZMUSER                                                    BUG4422
     C                   UNLOCK    ZMUSER                                                    BUG4422
                                                                                             BUG4422
      ** Determine whether program is running interactively or in batch                       CAP185
      **  ( 0 = batch 1 = interactive)                                                        CAP185
      *                                                                                       CAP185
     C                   CALLB     'ZARTVJOBA'                                                CAP185
     C                   PARM                    @Return           6                          CAP185
     C                   PARM                    @Type             1                          CAP185
      *                                                                                       CAP185
     C                   IF        CAP185 = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'N' OR                                            CAP185
     C                             CAP185 = 'Y' AND                                           CAP185
     C                             @AUTHO = 'Y' AND                                           CAP185
     C                             @TYPE = '1'                                                CAP185
      *                                                                                       CDL010
      ** User cannot authorise an authorised deal or deal requires                            CDL010
      ** double authorisation.                                                                CDL010
      *                                                                                       CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C     HLUSER        ANDEQ     ZUSER                                                      CDL010
     C                   MOVE      'N'           OKDLNO                                       CDL010
     C                   ADD       1             Ix                                           CDL010
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CDL010
     C                   MOVEL     'MMM0702'     MsgIdArr(Ix)                                 CDL010
     C                   END                                                                  CDL010
      *                                                                                       CDL010
     C                   ENDIF                                                                CAP185
                                                                                              CAP185
                                                                                              CSD015
      ** If Compliance Watch is enabled, check for pending cases.                             CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
                                                                                              CSD015
      ** Check if NAP details are being reviewed.                                             CSD015
     C                   EVAL      KFuncType = *BLANKS                                        CSD015
     C                   EVAL      KIden = *BLANKS                                            CSD015
     C                   EVAL      KBranch = *BLANKS                                          CSD015
                                                                                              CSD015
     C                   MOVEL     'MMDENBPP'    KFuncType                                    CSD015
     C                   MOVEL     HLDN38        KIden                                        CSD015
     C                   MOVEL     HLBRCA        KBranch                                      CSD015
                                                                                              CSD015
     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
     C                             W3TREL <> 'Y'                                              CSD015
     C                   EVAL      OKACTN = 'N'                                               CSD015
     C                   EVAL      OKDLNO = 'N'                                               CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   EVAL      FldNameArr(Ix) = 'DDDLNO'                                  CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
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
 
      **  Check that the deal does not exist on any Deals File
      **  Midas or DRS. If it does it's an error.
     C     @@DLNO        SETLL     DEALSALL                               65
     C     *IN65         IFEQ      '1'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0163'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END
      *                                                                                       CDL098
     C     CDL098        IFeq      'Y'                                                        CDL098
     C     @@DLNO        Setll     DLCANCI0                               65                  CDL098
      *                                                                                       CDL098
     C     *IN65         IFeq      '1'                                                        CDL098
     C                   Move      'N'           OKDLNO                                       CDL098
     C                   Add       1             Ix                                           CDL098
     C                   MoveL     'DDDLNO'      FldNameArr(Ix)                               CDL098
     C                   MoveL     'FXM7004'     MsgIdArr(Ix)                                 CDL098
     C                   GOTO      EVALAI                                                     CDL098
     C                   Endif                                                                CDL098
     C                   Endif                                                                CDL098
 
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      **  Check that the deal number is in the allowed range.
      ** (do not check if deal number generated through APIs)                   CAP006
     C     @@DLNO        IFLT      NORDLN
     C     @@DLNO        OREQ      999999
     C     ModeofOp      IFNE      '*FRONT'                                     CAP006
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0164'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   END                                                    CAP006
     C                   END
     C                   ENDIF                                                              AR996631
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDENBP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HLDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
      **  If the deal has been deleted, then it may not be amended.
     C     HLDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0172'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
     C*
     C**  Check if deal past maturity.
     C*
     C                   Z-ADD     HLMDYY        @@YY
     C                   Z-ADD     HLMDMM        @@MM
     C                   Z-ADD     HLMDDD        @@DD
     C     DateIn        IFNE      0
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C     ZZMDNO        IFLT      BJRDNB
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C*******            MOVEL     'MMM0166'     MsgIdArr(Ix)                   CAP006
     C                   MOVEL     'ABM0201'     MsgIdArr(Ix)                   CAP006
     C                   GOTO      EVALAA
     C                   END
     C                   END
 
      **  If the record exists, its status must be C,A or R.
     C     HLDSTS        IFNE      'C'
     C     HLDSTS        ANDNE     'A'
     C     HLDSTS        ANDNE     'R'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0166'     MsgIdArr(Ix)
     C                   GOTO      EVALAA
     C                   END
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      **  If the deal number is blank, it is an error.
     C     DDDLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0111'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  If there is no valid, undeleted record on MMDEALLL, it is an
      **  error.
     C     @@DLNO        CHAIN     MMDEALLL                           65
 
      **  Check that the correct record format has been accessed.
     C     RECORD        IFNE      'MMDENBP0'
     C     *IN65         ANDEQ     '0'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0158'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  Check for a valid record.
     C     *IN65         IFEQ      '1'
     C     HLDLTF        ORNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0167'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      **  If a valid record exists and the deal deleted indicator is
      **  not blank, it is an error.
     C     HLDDLT        IFNE      *BLANK
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0172'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C*
     C**  Check if deal past maturity.
     C*
     C                   Z-ADD     HLMDYY        @@YY
     C                   Z-ADD     HLMDMM        @@MM
     C                   Z-ADD     HLMDDD        @@DD
     C     DateIn        IFNE      0
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C     ZZMDNO        IFLT      BJRDNB
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C*******            MOVEL     'MMM0166'     MsgIdArr(Ix)                   CAP006
     C                   MOVEL     'ABM0201'     MsgIdArr(Ix)                   CAP006
     C                   GOTO      EVALAD
     C                   END
     C                   END
 
      ** the deal status must be C,A,R or E
     C     HLDSTS        IFNE      'C'
     C     HLDSTS        ANDNE     'A'
     C     HLDSTS        ANDNE     'R'
     C     HLDSTS        ANDNE     'E'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0169'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
 
      ** Cannot delete a deal if a live deal amendment exists on MMDEAMLL.
     C     @@DLNO        SETLL     MMDEAMLL                           65
     C     *IN65         DOWEQ     '0'
     C     @@DLNO        READE     MMDEAMLL                               65
     C     *IN65         IFEQ      '0'
     C     HNDDLT        IFNE      'D'
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0170'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Cannot delete a deal if a live associated deal exists
      ** If deal is parcelled the associated deal number, HLDADN, will
      ** be blank (b'cos one NA purchased may be sold by several NA
      ** sold trades)
      *
     C     HLDADN        IFNE      *BLANKS
     C                   MOVE      HLDADN        @WK6              6 0
     C     @WK6          CHAIN     MMDEALLL                           65
     C     *IN65         IFEQ      '0'
     C     HMDDLT        IFEQ      *BLANKS
     C     HMDLTF        ANDEQ     *BLANKS
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0174'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C                   END
     C                   END
      *
      ** Code for parcelled NA's purchased, must chk for partial sales
      ** separately b'cos associated deal number is blank.
      ** (note cannot trust HLSLDB, HLSOLD fields unfortunately)
     C     HLPCLI        IFEQ      'P'
      *
      ** HLAMNP may be -ve but HLOPUP is always +ve.
     C     *LIKE         DEFINE    HLAMNP        @AMNPW
     C     HLAMNP        IFLT      *ZERO
     C                   Z-SUB     HLAMNP        @AMNPW
     C                   ELSE
     C                   Z-ADD     HLAMNP        @AMNPW
     C                   END
      *
      ** During CoB (ie DL0280) Purchase price is reduced by sold parcels
      ** amt, so compare current Purchase price of NAB with Original amt.
     C     HLOPUP        IFNE      @AMNPW
      *
      ** During day as parcels are sold the Purchase price on NAB is not
      ** updated but the No. sold field is. This is reduced at CoB
      ** (ie DL0280) to remove the No. parcels sold so it is reset to
      ** zero.
     C     HLOPUP        OREQ      @AMNPW
     C     HLNSLD        ANDNE     *ZERO
      *
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)
     C                   MOVEL     'MMM0174'     MsgIdArr(Ix)
     C                   GOTO      EVALAD
     C                   END
     C                   END
                                                                                              CAS004
      ** Issue warning if deal to be deleted is a hedged item                                 CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   MOVE      DDDLNO        KDlNo                                        CAS004
                                                                                              CAS004
      ** Check if Hedge Transaction file for the Deal                                         CAS004
                                                                                              CAS004
     C     KTran         SETLL     ASHTRNLA                                                   CAS004
     C     KTran         READE     ASHTRNLA                                                   CAS004
                                                                                              CAS004
      ** Check for the Hedge Linkage if Effective or Discontinued                             CAS004
                                                                                              CAS004
     C                   DOW       NOT %EOF(ASHTRNLA)                                         CAS004
                                                                                              CAS004
     C     FSHEDI        CHAIN     ASHGLKL0                                                   CAS004
                                                                                              CAS004
      ** If record is not found, database error                                               CAS004
                                                                                              CAS004
     C                   IF        NOT %FOUND(ASHGLKL0)                                       CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'ASHGLKPD'                                        CAS004
     C                   EVAL      DBKEY = FSHEDI_Char                                        CAS004
     C                   EVAL      DBASE = 906                                                CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** If Hedge Linkage is effective or discontinued, issue warning message                 CAS004
                                                                                              CAS004
     C                   IF        FSHTID = 'D' AND LKRECI = 'D' OR                           CAS004
     C                             FSHTID = 'D' AND LKRECI = 'X'                              CAS004
     C                   EVAL      WIdx = WIdx + 1                                            CAS004
     C                   EVAL      WFldNamArr(WIdx) = 'DDDLNO'                                CAS004
     C                   EVAL      WMsgIdArr(WIdx)  = 'MMM3400'                               CAS004
     C                   GOTO      EVALAD                                                     CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     KTran         READE     ASHTRNLA                                                   CAS004
     C                   ENDDO                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
      *
      **  Check if a lived adjustment to yield fee is attached to the deal. If yes,           CAS009
      **  send an error message.                                                              CAS009
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
      *                                                                                       CAS009
     C     @@DLNO        CHAIN     DLFEEDL1                           89                      CAS009
     C                   DOW       *IN89 = *OFF                                               CAS009
     C                   IF        DFRECI = 'D'                                               CAS009
     C                             AND DFADJY = 'Y'                                           CAS009
      *                                                                                       CAS009
     C                   MOVE      'N'           OKDLNO                                       CAS009
     C                   ADD       1             Ix                                           CAS009
     C                   MOVEL     'DDDLNO'      FldNameArr(Ix)                               CAS009
     C                   MOVEL     'DLM1026'     MsgIdArr(Ix)                                 CAS009
     C                   GOTO      EVALAD                                                     CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C     @@DLNO        READE     DLFEEDL1                               89                  CAS009
     C                   ENDDO                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - ACCESS SECURITY CHECKING
      *****************************************************************
     C     ACSSEC        BEGSR
 
      * If not multi-branching, check authority to only action code
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
 
      * If multi-branching, check authority to booking branch
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        IFEQ      'I'
     C     DDBRCA        IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   MOVE      BRC           DDBRCA
     C                   ELSE
     C                   MOVE      DDBRCA        ZBR
     C                   END
     C                   ELSE
     C                   MOVE      HLBRCA        ZBR
     C                   END
     C     DDACTN        IFEQ      'I'
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'MMM0115'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   ELSE
     C                   MOVEL     A8BRCD        ZBR
     C                   MOVEL     A8BRCD        DDBRCA
     C                   END
     C                   END
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
 
      ** (If Insert then highlight branch field else deal number)
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           OKBRCA
     C                   ELSE
     C                   MOVE      'N'           OKDLNO
     C                   END
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
 
      * Check authority to originating branch
     C     BKOBUV        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'I'
     C                   CALL      'ZVOBU'
     C                   PARM      HLORBR        ZOBRX             3
     C                   PARM                    @@ERR             1 0
     C     @@ERR         IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C     @@ERR         IFEQ      2
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKDLNO
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   GOTO      EACSSE
     C                   END
     C                   END
     C                   END
 
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
     C                   CLEAR                   DealFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKDLNO
     C                   MOVEL     'Y'           OKBRCA
     C                   EVAL      WIdx = *ZEROS                                              CAS004
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      * Booking branch
     C                   PARM                    DDBRCA            3            ??
 
      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1            ??
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
 
      ** Initialize program name
 
     C                   MOVEL     'MMNASPRTV'   DBPGM
 
      * Key Lists
     C     @DEAMK        KLIST
     C                   KFLD                    @DEAMN            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
 
      ** Compliance Watch Hit List Key                                                        CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CSD015
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS GENERAL LEDGER DETAILS
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** ACCESS DEALING DETAILS
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
 
      ** ACCESS DEAL NUMBER RECORD
     C     1             CHAIN     FDDLNMLL                           99
 
      * DATABASE ERROR
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
                                                                                              CAS004
      ** Check if Hedge Accounting is installed                                               CAS004
                                                                                              CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRetCode                                     CAS004
     C                   PARM      '*VERIFY'     POption                                      CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRetCode = *BLANKS                                         CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   IF        PRetCode <> '*NRF   '                                      CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY  = 'CAS004'                                          CAS004
     C                   EVAL      DBASE  = 905                                               CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Klist for Hedge Transaction File                                                     CAS004
                                                                                              CAS004
     C     KTran         KLIST                                                                CAS004
     C                   KFLD                    KMod                                         CAS004
     C                   KFLD                    KDlNo                                        CAS004
                                                                                              CAS004
     C                   EVAL      KMod = 'DL'                                                CAS004
 
      **    Check if Dealing Transaction Authorisation is installed                           CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       @RTCD                                        CDL010
     C                   PARM      '*VERIFY'     @OPTN                                        CDL010
     C                   PARM      'CDL010'      @SARD             6                          CDL010
     C                   PARM                    DSFDY                                        CDL010
      *                                                                                       CDL010
     C     @RTCD         IFEQ      *BLANK                                                     CDL010
     C                   MOVE      'Y'           CDL010            1                          CDL010
     C                   ELSE                                                                 CDL010
     C     @RTCD         IFEQ      '*NRF'                                                     CDL010
     C                   MOVE      'N'           CDL010                                       CDL010
     C                   ELSE                                                                 CDL010
      *                                                                                       CDL010
      **    Database error processing                                                         CDL010
      *                                                                                       CDL010
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CDL010
     C                   MOVEL     '905'         DBASE                          * DBERR 905 * CDL010
     C                   MOVEL     'CDL010'      DBKEY                          ************* CDL010
     C                   EXSR      *PSSR                                                      CDL010
     C                   END                                                                  CDL010
     C                   END                                                                  CDL010
      *                                                                                       CDL010
      ** Check if CAS009 is installed                                                         CAS009
                                                                                              CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   CALL      'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRetCode                                     CAS009
     C                   PARM      '*VERIFY'     POption                                      CAS009
     C                   PARM      'CAS009'      PSard                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
                                                                                              CAS009
     C                   IF        PRetCode = *BLANKS                                         CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   ELSE                                                                 CAS009
     C                   IF        PRetCode <> '*NRF   '                                      CAS009
     C     *LOCK         IN        LDA                                                        CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBKEY  = 'CAS009'                                          CAS009
     C                   EVAL      DBASE  = 909                                               CAS009
     C                   OUT       LDA                                                        CAS009
     C                   EXSR      *PSSR                                                      CAS009
     C                   ENDIF                                                                CAS009
     C                   ENDIF                                                                CAS009
      **  GET ZMUSER to access default branch.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      **  Access the SDSTAT Data Area.                                                        CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      PSARD                                        CSD015
     C     SCSARD        PARM      *BLANKS       DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 905                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM      'DEALING '    PFuncCode                                    CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSC011 is switched on.                                 CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSC011'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSC011'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Cancelled Deal Numbers Enhancement (CDL098) is on.                          CDL098
                                                                                              CDL098
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
                                                                                              CAP185
      ** Check if CAP185 is installed                                                         CAP185
     C                   CALLB     'AOSARDR0'                                                 CAP185
     C                   PARM      *BLANKS       @RTCD             7                          CAP185
     C                   PARM      '*VERIFY'     @OPTN             7                          CAP185
     C                   PARM      'CAP185'      @SARD             6                          CAP185
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP185
     C*                                                                                       CAP185
     C                   IF        @RTCD = *BLANK                                             CAP185
     C                   MOVE      'Y'           CAP185            1                          CAP185
      *                                                                                       CAP185
      ** Determine if Auto-authorise                                                          CAP185
     C     *LIKE         DEFINE    APNAME        @APINAME                                     CAP185
     C                   MOVEL     'NASP'        @APINAME                                     CAP185
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
     C/COPY WNCPYSRC,MMH00090
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 910                                                CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CAP185
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
     C                   IF        @RTCD =  *BLANKS                                         AR996631
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
     C/COPY WNCPYSRC,MMNASPIC02
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
