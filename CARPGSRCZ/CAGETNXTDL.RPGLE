     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CA Get next neal number (for MM & FX)')          *
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  CAGETNXTDL - Get next available deal number                  *
      *                                                               *
      *  Function:  This module obtains the next available deal       *
      *             number from the file CADLFALL.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR665113           Date 28Nov12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 203337             Date 26Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190336             Date 27Feb01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 10Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR665113 - Check if deal no. is used for rollover of deals.  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
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
      *           authorising it.Recompile due to changes in FXDEALPP *
      *  203337 - Check if next available deal number already exists  *
      *  190336 - program looping when error in deal nbr generation   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     FCADLFALL  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** All deals                                                                            203337
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)                                       203337
     F                                     PREFIX(DL_)                                        203337
     FDEALSCL1  IF   E           K DISK    INFSR(*PSSR)                                     AR665113
     F                                     RENAME(DEALSDCF:DEALSRCF)                        AR665113
                                                                                              203337
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Return code from CA0040
     D @TERM           S              1A
 
      ** Input Deal Number
     D DDDLNO          S              6A
 
      ** Redefine external field as a Zoned decimal to prevent errors
     D FKDN38          S              6S 0
 
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      **  Check for a live record on CADLFALL.
     C     *IN65         DOUEQ     '0'
     C     1             SETLL     CADLFALL
     C                   READ      CADLFALL                               65
 
      **  If a live record is found, delete it.
     C     *IN65         IFEQ      '0'
     C                   DELETE    CADLFAP0
 
      **  Otherwise, call the regeneration program.
     C                   ELSE
     C                   CALL      'CA0040'
     C                   PARM                    @TERM
 
      **  If an error occurs in the called program, pass the error back
     C     @TERM         IFEQ      'E'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0145'     Msgid1
     C                   EVAL      *IN65 = '0'                                                190336
     C                   ENDIF
 
     C                   ENDIF
 
      **  If no error, set up the Alpha deal number
     C     ErrorFound    IFNE      'Y'
     C     *IN65         ANDEQ     *OFF                                                       203337
                                                                                              203337
      ** Get the next available deal number, if the deal number found                         203337
      ** was already used                                                                     203337
                                                                                              203337
     C     FKDN38        CHAIN     DEALSALL                           80                      203337
      *                                                                                     AR665113
      ** Check if deal number is used in rollover of deals                                  AR665113
      *                                                                                     AR665113
     C                   IF        *IN80 = *ON                                              AR665113
     C     FKDN38        CHAIN     DEALSCL1                           80                    AR665113
     C                   ENDIF                                                              AR665113
      *                                                                                     AR665113
     C                   IF        *IN80 = *ON                                                203337
     C                   MOVE      FKDN38        DDDLNO
     C                   ELSE                                                                 203337
     C                   EVAL      *IN65 = *ON                                                203337
     C                   ENDIF                                                                203337
                                                                                              203337
     C                   END
 
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDDLNO
     C                   PARM                    FKDN38
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
