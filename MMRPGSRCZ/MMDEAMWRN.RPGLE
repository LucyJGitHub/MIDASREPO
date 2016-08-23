     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MM Deal Amendments Display Warnings Module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMWRN - MM Deal Amendments Display Warnings Module       *
      *                                                               *
      *  Function:  This module will process warnings if a Fidu -     *
      *             ciary transaction is selected for insertion or    *
      *             deletion                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CDL006 - Dealing Fiduciary.                                  *
      *                                                               *
      *****************************************************************
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     FMMDELDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:MMDELP0)
 
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Fiduciary switchable feature
     D CDL006          S              1A   IMPORT
 
      ** Index for arrays of warning message ids
     D WIdx            S              3P 0
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Set up copyright parameter
 
     C                   MoveA     CPY@          CPY2@            80
 
      ** Receive parameter list
 
     C     *Entry        Plist
     C                   Parm                    PDlno             6 0
     C                   Parm                    PActn             1
     C                   Parm                    PAmdTyp           2
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
 
      ** Access related deal details if dealing fiduciary is installed
 
     C     CDL006        IfEq      'Y'
     C     PDlno         Chain     MMDEALLL                           30
 
      ** Insert
 
     C                   If        (PActn = 'I') and
     C                             (PAmdTyp = 'PI' or PAmdTyp = 'PD' or
     C                              PAmdTyp = 'SC') and
     C                             (HKTYPE = 'LP' or HKTYPE = 'DP')
 
     C     PDlno         SetLL     MMDELDL3
 
     C     PDlno         ReadE     MMDELDL3                               30
 
      ** Retrieve all the takings attached to the placing concern and
      ** send appropriate warning message to user('Warning ** Enter the deal
      ** amendment of the associated Fiduciary Taking & 1')
 
     C     *IN30         DoWEq     *Off
     C                   Add       1             WIdx
     C                   MoveL     HKDN38        WDealChar         6
     C                   Eval      WFldNamArr(WIdx) = 'HKLNKN'
     C                   Eval      WMsgIDArr(WIdx) = 'MMA0800'
     C                   Eval      WMsgDtaArr(WIdx) = WDealChar
     C                   ReadE     MMDELDL3                               30
     C                   EndDo
     C                   EndIf
 
      ** Delete (If conditions satisfied, sends a warning message - 'WARNING
      ** ** Deal Amendment of the associated Fiduciary deal must also be de
      ** leted')
 
     C                   If        (PActn = 'D') and
     C                             (HKTYPE = 'DP' or HKTYPE = 'DT' or
     C                              HKTYPE = 'LP' or HKTYPE = 'LT' or
     C                              HKTYPE = 'FL' or HKTYPE = 'FT')
     C                   Add       1             WIdx
     C                   Eval      WFldNamArr(WIdx) = 'HKDN38'
     C                   Eval      WMsgIDArr(WIdx) = 'MMA0801'
     C                   Endif
 
     C                   Endif
 
     C                   Return
 
      ********************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
