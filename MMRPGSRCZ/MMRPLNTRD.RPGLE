     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Temporary Repo Loan/Deposit read')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPLNTRD - MM Read Temporary Repo Loan/Deposit file         *
      *                                                               *
      *  Function: This Program reads a record from MMTRPLNPD         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248773             Date 28Jun07               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239469             Date 13Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248773 - Decimal data error when Repo is repaired. Recompile.*
      *  247785 - Recompile on MMTRPLNPD.                             *
      *  239469 - Different record format of MMVLDNIPD and MMTRPLNPD  *
      *           and led field mismatched.                           *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing                              *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************

     FMMTRPLNL0 IF   E           K DISK
     F                                     INFSR(*PSSR)

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


      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D**  Data structure of Loan/Deposit
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD) PREFIX(NW)

     D**  Data structure of Temporary Loan/Deposit
     D MMTRPLN       E DS                  EXTNAME(MMTRPLNPD)

     D**  Temporary data structure of Temporary Loan Deposit
     D XXTRPLN       E DS                  EXTNAME(MMTRPLNPD) PREFIX(XX)

     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D**  Associated Front Office ID Transaction Number
     D @@AFRT          S             20A

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     @@AFRT        CHAIN     MMTRPLND0                          89
     C
     C     *IN89         IFEQ      *OFF
     C                   MOVE      MMTRPLN       XXTRPLN
     C                   ENDIF
     C
     C     @@AFRT        READE     MMTRPLND0                              89
     C
     C     *IN89         IFEQ      *OFF
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C*********          MOVE      XXTRPLN       NwDlFilFmt                                   239469
     C                   MOVEL     XXTRPLN       NwDlFilFmt                                   239469
     C                   RETURN
     C********************************************************************
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

     C     *ENTRY        PLIST
     C                   PARM                    @RTCD
     C                   PARM                    @@AFRT
     C                   PARM                    NwDlFilFmt
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMRPLNTRD'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
