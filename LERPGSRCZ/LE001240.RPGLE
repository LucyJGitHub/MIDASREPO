     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Cust risk weighted assets balances update')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LE001240 - Customer Lending Risk Weighted Assets Balances    *
      *             Update Program                                    *
      *                                                               *
      *  Function:  This module will call the calculation program to  *
      *             calculate the Risk Weighted Balance for all loans *
      *             in the system apart from Participation Sold       *
      *             (processing types 66, 67) and Guarantees issued   *
      *             (processing type 70).  The Risk Weighted Asset    *
      *             Balance LE file will be updated.                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242239             Date 18Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 219691             Date 27Jul03               *
      *                 CGL018  *CREATE    Date 17Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  242239 - Update Risk Weighted Asset and Balance in MXBLLELPD.*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  219691 - Participation sold should be taken into calculation *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *    01         EOF for SDRWASL1                                *
      *    02         EOF for CLOANL7                                 *
      *    03         EOF for LERWABPD                                *
      *    04         EOF for MXBLLELL0                               *                       242239
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      **
     FLERWABL0  O    E           K DISK
     FLERWABL1  UF   E           K DISK
     F                                     RENAME(LERWABP0:LERWABP1)
     FCLOANL7   IF   E           K DISK    INFSR(*PSSR)
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     FMXBLLELL0 UF   E           K DISK                                                       242239
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
 
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *DTAARA       DEFINE                  RUNDAT                                       242239
     C                   IN        RUNDAT                                                     242239
                                                                                              242239
     C                   EXSR      MAIN
 
     C                   EVAL      *INLR = *ON
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MAIN          BEGSR
      *
      **  Read Risk Weighted Assets File
      *
     C                   READ      SDRWASL1                               01
 
     C     *IN01         DOWEQ     '0'
 
     C     RWRECI        IFNE      '*'
 
     C                   MOVE      RWSETN        WWSetNum
     C                   MOVE      RWCALC        WWCalcMet
 
     C                   EVAL      Count = Count + 1
 
     C                   EXSR      GETLOAN
 
     C                   MOVE      '1'           *IN20
 
     C                   ENDIF
 
     C                   READ      SDRWASL1                               01
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETLOAN - Get loans of the system                             *
      *                                                               *
      * Calls: LE001241                                               *
      *                                                               *
      *****************************************************************
 
     C     GETLOAN       BEGSR
      *
      **  Read CLOANL7
      **  Pointer needs to be on the very first record again for the next
      **  Set Number record from SDRWASL1
      *
     C     *IN20         IFEQ      '1'
     C     *LOVAL        SETLL     CLOANL7
     C                   ENDIF
 
     C                   READ      CLOANL7                                02
 
     C     *IN02         DOWEQ     '0'
 
     C                   MOVEL     LNRF          WWLoanRef
     C                   MOVE      CCY           WWLoanCcy
     C                   Z-ADD     CPAM          WWAsetBal        15 0
     C                   MOVEL     'Y'           WWWrtRWAR         1                          242239
      *                                                                                       219691
      *  Sub participation sold amount from current principal                                 219691
      *                                                                                       219691
     C     PSAM          IFNE      0                                                          219691
     C     WWAsetbal     SUB       PSAM          WWAsetbal                                    219691
     C                   ENDIF                                                                219691
      *                                                                                       219691
 
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     PTYP          OREQ      71
 
     C     RCSI          IFEQ      'Y'
     C                   MOVEL     CNUM          WWCust
     C                   ELSE
     C                   MOVEL     OLNO          WWCust
     C                   ENDIF
      *
      **  For Processing Types other than 64, 65, 68 or 71
      *
     C                   ELSE
     C                   MOVEL     CNUM          WWCust            6
 
     C                   ENDIF
      *
      ** Call Customer Lending Risk Weighted Assets Allocation Program
      *
     C                   CALLB     'LE001241'
     C                   PARM                    WWLoanRef
     C                   PARM                    WWLoanCcy
     C                   PARM                    WWAsetBal
     C                   PARM                    WWCust
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
     C                   PARM                    WWWrtRWAR                                    242239
      *
      ** Update Loans Value Date Balances File from the returned Risk
      ** Weighted Asset Balance figure
      *
     C                   EXSR      UPDATRWALE
 
      ** Initialise RWA Balance variable for the next call
      *
     C                   Z-ADD     *ZERO         WWRiskWABal
 
     C                   READ      CLOANL7                                02
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATRWALE - Updates LERWABL0 for this Loan Reference         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATRWALE    BEGSR
      *
      **  Move field values for accessing record in the Loans Risk Weighted
      **  Assets Balances File
      *
     C                   MOVEL     LNRF          WXLnrf
 
     C     WXLnrf        CHAIN     LERWABP1                           03
 
     C     *IN03         IFEQ      '0'
 
     C                   SELECT
     C     Count         WHENEQ    2
     C                   MOVE      WWSetNum      LBSET02
     C                   Z-ADD     WWRiskWABal   LBAB02
 
     C     Count         WHENEQ    3
     C                   MOVE      WWSetNum      LBSET03
     C                   Z-ADD     WWRiskWABal   LBAB03
 
     C     Count         WHENEQ    4
     C                   MOVE      WWSetNum      LBSET04
     C                   Z-ADD     WWRiskWABal   LBAB04
 
     C     Count         WHENEQ    5
     C                   MOVE      WWSetNum      LBSET05
     C                   Z-ADD     WWRiskWABal   LBAB05
 
     C     Count         WHENEQ    6
     C                   MOVE      WWSetNum      LBSET06
     C                   Z-ADD     WWRiskWABal   LBAB06
 
     C     Count         WHENEQ    7
     C                   MOVE      WWSetNum      LBSET07
     C                   Z-ADD     WWRiskWABal   LBAB07
 
     C     Count         WHENEQ    8
     C                   MOVE      WWSetNum      LBSET08
     C                   Z-ADD     WWRiskWABal   LBAB08
 
     C     Count         WHENEQ    9
     C                   MOVE      WWSetNum      LBSET09
     C                   Z-ADD     WWRiskWABal   LBAB09
 
     C     Count         WHENEQ    10
     C                   MOVE      WWSetNum      LBSET10
     C                   Z-ADD     WWRiskWABal   LBAB10
 
     C     Count         WHENEQ    11
     C                   MOVE      WWSetNum      LBSET11
     C                   Z-ADD     WWRiskWABal   LBAB11
 
     C     Count         WHENEQ    12
     C                   MOVE      WWSetNum      LBSET12
     C                   Z-ADD     WWRiskWABal   LBAB12
 
     C     Count         WHENEQ    13
     C                   MOVE      WWSetNum      LBSET13
     C                   Z-ADD     WWRiskWABal   LBAB13
 
     C     Count         WHENEQ    14
     C                   MOVE      WWSetNum      LBSET14
     C                   Z-ADD     WWRiskWABal   LBAB14
 
     C     Count         WHENEQ    15
     C                   MOVE      WWSetNum      LBSET15
     C                   Z-ADD     WWRiskWABal   LBAB15
 
     C     Count         WHENEQ    16
     C                   MOVE      WWSetNum      LBSET16
     C                   Z-ADD     WWRiskWABal   LBAB16
 
     C     Count         WHENEQ    17
     C                   MOVE      WWSetNum      LBSET17
     C                   Z-ADD     WWRiskWABal   LBAB17
 
     C     Count         WHENEQ    18
     C                   MOVE      WWSetNum      LBSET18
     C                   Z-ADD     WWRiskWABal   LBAB18
 
     C     Count         WHENEQ    19
     C                   MOVE      WWSetNum      LBSET19
     C                   Z-ADD     WWRiskWABal   LBAB19
 
     C     Count         WHENEQ    20
     C                   MOVE      WWSetNum      LBSET20
     C                   Z-ADD     WWRiskWABal   LBAB20
 
     C     Count         WHENEQ    21
     C                   MOVE      WWSetNum      LBSET21
     C                   Z-ADD     WWRiskWABal   LBAB21
 
     C     Count         WHENEQ    22
     C                   MOVE      WWSetNum      LBSET22
     C                   Z-ADD     WWRiskWABal   LBAB22
 
     C     Count         WHENEQ    23
     C                   MOVE      WWSetNum      LBSET23
     C                   Z-ADD     WWRiskWABal   LBAB23
 
     C     Count         WHENEQ    24
     C                   MOVE      WWSetNum      LBSET24
     C                   Z-ADD     WWRiskWABal   LBAB24
 
     C     Count         WHENEQ    25
     C                   MOVE      WWSetNum      LBSET25
     C                   Z-ADD     WWRiskWABal   LBAB25
 
     C     Count         WHENEQ    26
     C                   MOVE      WWSetNum      LBSET26
     C                   Z-ADD     WWRiskWABal   LBAB26
 
     C     Count         WHENEQ    27
     C                   MOVE      WWSetNum      LBSET27
     C                   Z-ADD     WWRiskWABal   LBAB27
 
     C     Count         WHENEQ    28
     C                   MOVE      WWSetNum      LBSET28
     C                   Z-ADD     WWRiskWABal   LBAB28
 
     C     Count         WHENEQ    29
     C                   MOVE      WWSetNum      LBSET29
     C                   Z-ADD     WWRiskWABal   LBAB29
 
     C     Count         WHENEQ    30
     C                   MOVE      WWSetNum      LBSET30
     C                   Z-ADD     WWRiskWABal   LBAB30
 
     C     Count         WHENEQ    31
     C                   MOVE      WWSetNum      LBSET31
     C                   Z-ADD     WWRiskWABal   LBAB31
 
     C     Count         WHENEQ    32
     C                   MOVE      WWSetNum      LBSET32
     C                   Z-ADD     WWRiskWABal   LBAB32
 
     C     Count         WHENEQ    33
     C                   MOVE      WWSetNum      LBSET33
     C                   Z-ADD     WWRiskWABal   LBAB33
 
     C     Count         WHENEQ    34
     C                   MOVE      WWSetNum      LBSET34
     C                   Z-ADD     WWRiskWABal   LBAB34
 
     C     Count         WHENEQ    35
     C                   MOVE      WWSetNum      LBSET35
     C                   Z-ADD     WWRiskWABal   LBAB35
 
     C                   OTHER
     C                   MOVE      WWSetNum      LBSET36
     C                   Z-ADD     WWRiskWABal   LBAB36
 
     C                   ENDSL
 
     C                   UPDATE    LERWABP1
                                                                                              242239
     C                   EXSR      UPDATMXBL                                                  242239
      *
      ** If no record in LERWABPD for this loan yet (this must be the first
      ** set so write the values in 01 fields)
      *
     C                   ELSE
 
     C                   MOVE      'D'           LBRECI
     C                   MOVEL     WWLoanRef     LBLNRF
     C                   MOVE      WWSetNum      LBSET01
     C                   Z-ADD     WWRiskWABal   LBAB01
 
     C                   MOVEL     *BLANKS       LBSET02
     C                   MOVEL     *BLANKS       LBSET03
     C                   MOVEL     *BLANKS       LBSET04
     C                   MOVEL     *BLANKS       LBSET05
     C                   MOVEL     *BLANKS       LBSET06
     C                   MOVEL     *BLANKS       LBSET07
     C                   MOVEL     *BLANKS       LBSET08
     C                   MOVEL     *BLANKS       LBSET09
     C                   MOVEL     *BLANKS       LBSET10
     C                   MOVEL     *BLANKS       LBSET11
     C                   MOVEL     *BLANKS       LBSET12
     C                   MOVEL     *BLANKS       LBSET13
     C                   MOVEL     *BLANKS       LBSET14
     C                   MOVEL     *BLANKS       LBSET15
     C                   MOVEL     *BLANKS       LBSET16
     C                   MOVEL     *BLANKS       LBSET17
     C                   MOVEL     *BLANKS       LBSET18
     C                   MOVEL     *BLANKS       LBSET19
     C                   MOVEL     *BLANKS       LBSET20
     C                   MOVEL     *BLANKS       LBSET21
     C                   MOVEL     *BLANKS       LBSET22
     C                   MOVEL     *BLANKS       LBSET23
     C                   MOVEL     *BLANKS       LBSET24
     C                   MOVEL     *BLANKS       LBSET25
     C                   MOVEL     *BLANKS       LBSET26
     C                   MOVEL     *BLANKS       LBSET27
     C                   MOVEL     *BLANKS       LBSET28
     C                   MOVEL     *BLANKS       LBSET29
     C                   MOVEL     *BLANKS       LBSET30
     C                   MOVEL     *BLANKS       LBSET31
     C                   MOVEL     *BLANKS       LBSET32
     C                   MOVEL     *BLANKS       LBSET33
     C                   MOVEL     *BLANKS       LBSET34
     C                   MOVEL     *BLANKS       LBSET35
     C                   MOVEL     *BLANKS       LBSET36
 
     C                   Z-ADD     *ZERO         LBAB02
     C                   Z-ADD     *ZERO         LBAB03
     C                   Z-ADD     *ZERO         LBAB04
     C                   Z-ADD     *ZERO         LBAB05
     C                   Z-ADD     *ZERO         LBAB06
     C                   Z-ADD     *ZERO         LBAB07
     C                   Z-ADD     *ZERO         LBAB08
     C                   Z-ADD     *ZERO         LBAB09
     C                   Z-ADD     *ZERO         LBAB10
     C                   Z-ADD     *ZERO         LBAB11
     C                   Z-ADD     *ZERO         LBAB12
     C                   Z-ADD     *ZERO         LBAB13
     C                   Z-ADD     *ZERO         LBAB14
     C                   Z-ADD     *ZERO         LBAB15
     C                   Z-ADD     *ZERO         LBAB16
     C                   Z-ADD     *ZERO         LBAB17
     C                   Z-ADD     *ZERO         LBAB18
     C                   Z-ADD     *ZERO         LBAB19
     C                   Z-ADD     *ZERO         LBAB20
     C                   Z-ADD     *ZERO         LBAB21
     C                   Z-ADD     *ZERO         LBAB22
     C                   Z-ADD     *ZERO         LBAB23
     C                   Z-ADD     *ZERO         LBAB24
     C                   Z-ADD     *ZERO         LBAB25
     C                   Z-ADD     *ZERO         LBAB26
     C                   Z-ADD     *ZERO         LBAB27
     C                   Z-ADD     *ZERO         LBAB28
     C                   Z-ADD     *ZERO         LBAB29
     C                   Z-ADD     *ZERO         LBAB30
     C                   Z-ADD     *ZERO         LBAB31
     C                   Z-ADD     *ZERO         LBAB32
     C                   Z-ADD     *ZERO         LBAB33
     C                   Z-ADD     *ZERO         LBAB34
     C                   Z-ADD     *ZERO         LBAB35
     C                   Z-ADD     *ZERO         LBAB36
 
     C                   WRITE     LERWABP0
                                                                                              242239
     C                   EXSR      UPDATMXBL                                                  242239
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************                       242239
      *                                                               *                       242239
      * UPDATMXBL - Updates MXBLLELL0.                                *                       242239
      *                                                               *                       242239
      * Called by: UPDATRWALE                                         *                       242239
      *                                                               *                       242239
      * Calls: None                                                   *                       242239
      *                                                               *                       242239
      *****************************************************************                       242239
                                                                                              242239
     C     UPDATMXBL     BEGSR                                                                242239
                                                                                              242239
     C     KLnRun        CHAIN     MXBLLELP0                          04                      242239
                                                                                              242239
     C     *IN04         IFEQ      '0'                                                        242239
     C                   MOVE      LBSET01       MLSET01                                      242239
     C                   MOVE      LBSET02       MLSET02                                      242239
     C                   MOVE      LBSET03       MLSET03                                      242239
     C                   MOVE      LBSET04       MLSET04                                      242239
     C                   MOVE      LBSET05       MLSET05                                      242239
     C                   MOVE      LBSET06       MLSET06                                      242239
     C                   MOVE      LBSET07       MLSET07                                      242239
     C                   MOVE      LBSET08       MLSET08                                      242239
     C                   MOVE      LBSET09       MLSET09                                      242239
     C                   MOVE      LBSET10       MLSET10                                      242239
     C                   MOVE      LBSET11       MLSET11                                      242239
     C                   MOVE      LBSET12       MLSET12                                      242239
     C                   MOVE      LBSET13       MLSET13                                      242239
     C                   MOVE      LBSET14       MLSET14                                      242239
     C                   MOVE      LBSET15       MLSET15                                      242239
     C                   MOVE      LBSET16       MLSET16                                      242239
     C                   MOVE      LBSET17       MLSET17                                      242239
     C                   MOVE      LBSET18       MLSET18                                      242239
     C                   MOVE      LBSET19       MLSET19                                      242239
     C                   MOVE      LBSET20       MLSET20                                      242239
     C                   MOVE      LBSET21       MLSET21                                      242239
     C                   MOVE      LBSET22       MLSET22                                      242239
     C                   MOVE      LBSET23       MLSET23                                      242239
     C                   MOVE      LBSET24       MLSET24                                      242239
     C                   MOVE      LBSET25       MLSET25                                      242239
     C                   MOVE      LBSET26       MLSET26                                      242239
     C                   MOVE      LBSET27       MLSET27                                      242239
     C                   MOVE      LBSET28       MLSET28                                      242239
     C                   MOVE      LBSET29       MLSET29                                      242239
     C                   MOVE      LBSET30       MLSET30                                      242239
     C                   MOVE      LBSET31       MLSET31                                      242239
     C                   MOVE      LBSET32       MLSET32                                      242239
     C                   MOVE      LBSET33       MLSET33                                      242239
     C                   MOVE      LBSET34       MLSET34                                      242239
     C                   MOVE      LBSET35       MLSET35                                      242239
     C                   MOVE      LBSET36       MLSET36                                      242239
     C                   Z-ADD     LBAB01        MLAB01                                       242239
     C                   Z-ADD     LBAB02        MLAB02                                       242239
     C                   Z-ADD     LBAB03        MLAB03                                       242239
     C                   Z-ADD     LBAB04        MLAB04                                       242239
     C                   Z-ADD     LBAB05        MLAB05                                       242239
     C                   Z-ADD     LBAB06        MLAB06                                       242239
     C                   Z-ADD     LBAB07        MLAB07                                       242239
     C                   Z-ADD     LBAB08        MLAB08                                       242239
     C                   Z-ADD     LBAB09        MLAB09                                       242239
     C                   Z-ADD     LBAB10        MLAB10                                       242239
     C                   Z-ADD     LBAB11        MLAB11                                       242239
     C                   Z-ADD     LBAB12        MLAB12                                       242239
     C                   Z-ADD     LBAB13        MLAB13                                       242239
     C                   Z-ADD     LBAB14        MLAB14                                       242239
     C                   Z-ADD     LBAB15        MLAB15                                       242239
     C                   Z-ADD     LBAB16        MLAB16                                       242239
     C                   Z-ADD     LBAB17        MLAB17                                       242239
     C                   Z-ADD     LBAB18        MLAB18                                       242239
     C                   Z-ADD     LBAB19        MLAB19                                       242239
     C                   Z-ADD     LBAB20        MLAB20                                       242239
     C                   Z-ADD     LBAB21        MLAB21                                       242239
     C                   Z-ADD     LBAB22        MLAB22                                       242239
     C                   Z-ADD     LBAB23        MLAB23                                       242239
     C                   Z-ADD     LBAB24        MLAB24                                       242239
     C                   Z-ADD     LBAB25        MLAB25                                       242239
     C                   Z-ADD     LBAB26        MLAB26                                       242239
     C                   Z-ADD     LBAB27        MLAB27                                       242239
     C                   Z-ADD     LBAB28        MLAB28                                       242239
     C                   Z-ADD     LBAB29        MLAB29                                       242239
     C                   Z-ADD     LBAB30        MLAB30                                       242239
     C                   Z-ADD     LBAB31        MLAB31                                       242239
     C                   Z-ADD     LBAB32        MLAB32                                       242239
     C                   Z-ADD     LBAB33        MLAB33                                       242239
     C                   Z-ADD     LBAB34        MLAB34                                       242239
     C                   Z-ADD     LBAB35        MLAB35                                       242239
     C                   Z-ADD     LBAB36        MLAB36                                       242239
                                                                                              242239
     C                   UPDATE    MXBLLELP0                                                  242239
                                                                                              242239
     C                   ENDIF                                                                242239
                                                                                              242239
      ** Update all previous records for the loan too.                                        242239
                                                                                              242239
     C                   Z-ADD     *ZERO         WWRiskWAbal                                  242239
     C     KLnRun        SETLL     MXBLLELP0                                                  242239
     C     Lnrf          READPE    MXBLLELP0                              04                  242239
                                                                                              242239
     C     *IN04         DOWEQ     '0'                                                        242239
     C                   Z-ADD     BAL           WWAsetBal                                    242239
     C                   MOVEL     'N'           WWWrtRWAR                                    242239
                                                                                              242239
      ** Call Lending Risk Weighted Assets Allocation Program                                 242239
                                                                                              242239
     C                   CALLB     'LE001241'                                                 242239
     C                   PARM                    WWLoanRef                                    242239
     C                   PARM                    WWLoanCcy                                    242239
     C                   PARM                    WWAsetBal                                    242239
     C                   PARM                    WWCust                                       242239
     C                   PARM                    WWSetNum                                     242239
     C                   PARM                    WWCalcMet                                    242239
     C                   PARM                    WWRiskWABal                                  242239
     C                   PARM                    WWWrtRWAR                                    242239
                                                                                              242239
     C                   SELECT                                                               242239
     C     Count         WHENEQ    1                                                          242239
     C                   MOVE      WWSetNum      MLSET01                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB01                                       242239
                                                                                              242239
     C     Count         WHENEQ    2                                                          242239
     C                   MOVE      WWSetNum      MLSET02                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB02                                       242239
                                                                                              242239
     C     Count         WHENEQ    3                                                          242239
     C                   MOVE      WWSetNum      MLSET03                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB03                                       242239
                                                                                              242239
     C     Count         WHENEQ    4                                                          242239
     C                   MOVE      WWSetNum      MLSET04                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB04                                       242239
                                                                                              242239
     C     Count         WHENEQ    5                                                          242239
     C                   MOVE      WWSetNum      MLSET05                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB05                                       242239
                                                                                              242239
     C     Count         WHENEQ    6                                                          242239
     C                   MOVE      WWSetNum      MLSET06                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB06                                       242239
                                                                                              242239
     C     Count         WHENEQ    7                                                          242239
     C                   MOVE      WWSetNum      MLSET07                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB07                                       242239
                                                                                              242239
     C     Count         WHENEQ    8                                                          242239
     C                   MOVE      WWSetNum      MLSET08                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB08                                       242239
                                                                                              242239
     C     Count         WHENEQ    9                                                          242239
     C                   MOVE      WWSetNum      MLSET09                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB09                                       242239
                                                                                              242239
     C     Count         WHENEQ    10                                                         242239
     C                   MOVE      WWSetNum      MLSET10                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB10                                       242239
                                                                                              242239
     C     Count         WHENEQ    11                                                         242239
     C                   MOVE      WWSetNum      MLSET11                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB11                                       242239
                                                                                              242239
     C     Count         WHENEQ    12                                                         242239
     C                   MOVE      WWSetNum      MLSET12                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB12                                       242239
                                                                                              242239
     C     Count         WHENEQ    13                                                         242239
     C                   MOVE      WWSetNum      MLSET13                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB13                                       242239
                                                                                              242239
     C     Count         WHENEQ    14                                                         242239
     C                   MOVE      WWSetNum      MLSET14                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB14                                       242239
                                                                                              242239
     C     Count         WHENEQ    15                                                         242239
     C                   MOVE      WWSetNum      MLSET15                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB15                                       242239
                                                                                              242239
     C     Count         WHENEQ    16                                                         242239
     C                   MOVE      WWSetNum      MLSET16                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB16                                       242239
                                                                                              242239
     C     Count         WHENEQ    17                                                         242239
     C                   MOVE      WWSetNum      MLSET17                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB17                                       242239
                                                                                              242239
     C     Count         WHENEQ    18                                                         242239
     C                   MOVE      WWSetNum      MLSET18                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB18                                       242239
                                                                                              242239
     C     Count         WHENEQ    19                                                         242239
     C                   MOVE      WWSetNum      MLSET19                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB19                                       242239
                                                                                              242239
     C     Count         WHENEQ    20                                                         242239
     C                   MOVE      WWSetNum      MLSET20                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB20                                       242239
                                                                                              242239
     C     Count         WHENEQ    21                                                         242239
     C                   MOVE      WWSetNum      MLSET21                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB21                                       242239
                                                                                              242239
     C     Count         WHENEQ    22                                                         242239
     C                   MOVE      WWSetNum      MLSET22                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB22                                       242239
                                                                                              242239
     C     Count         WHENEQ    23                                                         242239
     C                   MOVE      WWSetNum      MLSET23                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB23                                       242239
                                                                                              242239
     C     Count         WHENEQ    24                                                         242239
     C                   MOVE      WWSetNum      MLSET24                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB24                                       242239
                                                                                              242239
     C     Count         WHENEQ    25                                                         242239
     C                   MOVE      WWSetNum      MLSET25                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB25                                       242239
                                                                                              242239
     C     Count         WHENEQ    26                                                         242239
     C                   MOVE      WWSetNum      MLSET26                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB26                                       242239
                                                                                              242239
     C     Count         WHENEQ    27                                                         242239
     C                   MOVE      WWSetNum      MLSET27                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB27                                       242239
                                                                                              242239
     C     Count         WHENEQ    28                                                         242239
     C                   MOVE      WWSetNum      MLSET28                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB28                                       242239
                                                                                              242239
     C     Count         WHENEQ    29                                                         242239
     C                   MOVE      WWSetNum      MLSET29                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB29                                       242239
                                                                                              242239
     C     Count         WHENEQ    30                                                         242239
     C                   MOVE      WWSetNum      MLSET30                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB30                                       242239
                                                                                              242239
     C     Count         WHENEQ    31                                                         242239
     C                   MOVE      WWSetNum      MLSET31                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB31                                       242239
                                                                                              242239
     C     Count         WHENEQ    32                                                         242239
     C                   MOVE      WWSetNum      MLSET32                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB32                                       242239
                                                                                              242239
     C     Count         WHENEQ    33                                                         242239
     C                   MOVE      WWSetNum      MLSET33                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB33                                       242239
                                                                                              242239
     C     Count         WHENEQ    34                                                         242239
     C                   MOVE      WWSetNum      MLSET34                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB34                                       242239
                                                                                              242239
     C     Count         WHENEQ    35                                                         242239
     C                   MOVE      WWSetNum      MLSET35                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB35                                       242239
                                                                                              242239
     C     Count         WHENEQ    36                                                         242239
     C                   MOVE      WWSetNum      MLSET36                                      242239
     C                   Z-ADD     WWRiskWABal   MLAB36                                       242239
                                                                                              242239
     C                   ENDSL                                                                242239
                                                                                              242239
     C                   UPDATE    MXBLLELP0                                                  242239
     C                   Z-ADD     *ZERO         WWRiskWABal                                  242239
                                                                                              242239
     C     Lnrf          READPE    MXBLLELP0                              04                  242239
                                                                                              242239
     C                   ENDDO                                                                242239
                                                                                              242239
     C                   ENDSR                                                                242239
      /EJECT                                                                                  242239
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
 
     C     *LIKE         DEFINE    LNRF          WWLoanRef
     C     *LIKE         DEFINE    CCY           WWLoanCcy
     C     *LIKE         DEFINE    LBLNRF        WXLnrf
     C     *LIKE         DEFINE    RWSETN        WWSetNum
     C     *LIKE         DEFINE    RWCALC        WWCalcMet
     C     *LIKE         DEFINE    LBAB01        WWRiskWABal
 
     C                   MOVE      '0'           *IN20
     C                   Z-ADD     *ZERO         Count             2 0
                                                                                              242239
     C     KLnRun        KLIST                                                                242239
     C                   KFLD                    LNRF                                         242239
     C                   KFLD                    AGRDNB                                       242239
 
     C                   ENDSR
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
