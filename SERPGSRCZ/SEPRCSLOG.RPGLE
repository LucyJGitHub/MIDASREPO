     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Market Prices Support Log Setup Module')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEPRCSLOG - Market Prices Support Log Setup Module           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 222373             Date 22Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSD010             Date 03May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income                          *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *           (Recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Prices - Detail file
     D PRCSFilFmt    E DS                  EXTNAME(PRICED)
 
      ** API PRCS format definition file
     D PRCSScnFmt    E DS                  EXTNAME(SEPRCSPD)
 
      ** Extra data layout file for prices
     D PRCSExtDta    E DS                  EXTNAME(SEPREXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
 
      ** Entry Parameters for SEPRCSCVT
     D PTranStat       S              8A
     D PRetCode        S             10A
     D PBookCde        S              2A
     D PPrice          S             15  8
     D CSD010          S              1A                                                      222373
     D HBDPR           S                   LIKE(PRBDPR)                                       222373
     D HOFPR           S                   LIKE(PROFPR)                                       222373
     D HCLPR           S                   LIKE(PRCLPR)                                       222373
                                                                                              CGL031
      ** Access Object                                                                        CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
     D PSard           S              6A                                                      CGL031
     D CGL031          S              1A                                                      CGL031
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Detail Processing                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SEPRCSCVT - Securities Prices Details Conversion      *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise Transaction Detail Record
 
     C                   EVAL      TRANSDTL = *Blanks
     C                   EVAL      DDACTN = CHTP
     C                   EVAL      DDPSSN = PSSN
     C                   EVAL      DDPPRT = PPRT
     C                   EVAL      DDPMKT = PMKT
     C                   EVAL      DDPBRA = PBRA
     C                   EVAL      DDPBOK = PBOK
     C                   EVAL      DDPTFR = PTFR
     C                   EVAL      PBookCde = PBOK
     C**********         IF        PCNM <> *ZEROS                                             CSD027
     C                   IF        PCNM <> *BLANKS                                            CSD027
     C                   MOVEL     PCNM          DDPCNM
     C                   ELSE
     C                   EVAL      DDPCNM = *Blanks
     C                   ENDIF
 
     C                   CALLB     'SEPRCSCVT'
     C                   PARM                    PTranStat
     C                   PARM                    PRetCode
     C                   PARM                    PRCSFilFmt
     C                   PARM                    PBookCde
     C                   PARM                    CGL031                                       CGL031
     C                   PARM                    PRCSScnFmt
     C                   PARM                    PPrice
     C                   PARM                    HBDPR                                        222373
     C                   PARM                    HOFPR                                        222373
     C                   PARM                    HCLPR                                        222373
     C                   PARM                    CSD010                                       222373
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      TRANSDTL = PRCSScnFmt + PRCSExtDta
     C                   ELSE
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Prices Detail File Format
 
     C                   PARM                    PRCSFilFmt
 
      ** Transaction Detail - Screen Format
 
     C                   PARM                    TRANSDTL
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '001'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
