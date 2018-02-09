     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MM Risk Weighted Assets Balances Update Pgm')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  DL001240 - Momey Market Weighted Assets Balances Update Pgm  *
      *                                                               *
      *  Function:  This module will call the calculation program to  *
      *             calculate the Risk Weighted Balance for MM deals  *
      *             in the system with types IP, TI, and CL and all   *
      *             Negotiable Assets Purchased types. The DL Risk    *
      *             Weighted Asset Balance new file will be updated.  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242239             Date 15Sep06               *
      *                 226861             Date 06Jun06               *
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CGL018  *CREATE    Date 25Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  242239 - Update Risk Weighted Asset and Balance in MXBLDLPD. *
      *  226861 - For Negotiable Assets Purchased, use the "Issued    *
      *           by Customer" number field to get the weighted risk  *
      *           instead of the "Bought from Customer" number.       *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *    01         EOF for SDRWASL1                                *
      *    02         EOF for DEALSL3                                 *
      *    03         EOF for DLRWABPD                                *
      *    04         EOF for MXBLDLPD                                *                       242239
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
     FDLRWABL0  O    E           K DISK
     FDLRWABL1  UF   E           K DISK
     F                                     RENAME(DLRWABP0:DLRWABP1)
     FDEALSL3   IF   E           K DISK    INFSR(*PSSR)
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     FMXBLDLL1  UF   E           K DISK                                                       242239
 
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
 
     C                   EXSR      GETDEALS
 
     C                   MOVE      '1'           *IN20
 
     C                   ENDIF
 
     C                   READ      SDRWASL1                               01
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * GETDEALS - Get deals of the system                            *
      *                                                               *
      * Calls: DL001241                                               *
      *                                                               *
      *****************************************************************
 
     C     GETDEALS      BEGSR
      *
      **  Read DEALSL3
      **  Pointer needs to be on the very first record again for the next
      **  Set Number record from SDRWASL1
      *
     C     *IN20         IFEQ      '1'
     C     *LOVAL        SETLL     DEALSL3
     C                   ENDIF
 
     C                   READ      DEALSL3                                02
 
     C     *IN02         DOWEQ     '0'
 
     C                   MOVEL     DLNO          WWDealRef
     C                   MOVE      CCY           WWDealCcy
      *                                                                                       226861
     C     DTYP          IFEQ      'IP'                                                       226861
     C     DTYP          OREQ      'TI'                                                       226861
     C     DTYP          OREQ      'CL'                                                       226861
     C                   MOVEL     CNUM          WWCust            6
     C                   MOVEL     'Y'           WWWrtRWAR         1                          242239
     C                   ELSE                                                                 226861
     C                   MOVEL     ISCN          WWCust                                       226861
     C                   ENDIF                                                                226861
 
     C     DTYP          IFEQ      'IP'
     C     DTYP          OREQ      'TI'
     C     DTYP          OREQ      'CL'
 
     C                   Z-ADD     PCPL          WWAsetBal        15 0
      *
      **  For NAP Deal Types
      *
     C                   ELSE
     C                   Z-ADD     FVAL          WWAsetBal
 
     C                   ENDIF
      *
      ** Call Dealing Risk Weighted Assets Allocation Program
      *
     C                   CALLB     'DL001241'
     C                   PARM                    WWDealRef
     C                   PARM                    WWDealCcy
     C                   PARM                    WWAsetBal
     C                   PARM                    WWCust
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
     C                   PARM                    WWWrtRWAR                                    242239
      *
      ** Update Deals Value Date Balances File from the returned Risk
      ** Weighted Asset Balance figure
      *
     C                   EXSR      UPDATRWADL
 
      ** Initialise RWA Balance variable for the next call
      *
     C                   Z-ADD     *ZERO         WWRiskWABal
 
     C                   READ      DEALSL3                                02
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATRWADL - Updates DLRWABL0 for this Deal Reference         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATRWADL    BEGSR
      *
      **  Move field values for accessing record in the Deals Risk Weighted
      **  Assets Balances File
      *
     C                   MOVEL     DLNO          WXDlno
 
     C     WXDlno        CHAIN     DLRWABP1                           03
 
     C     *IN03         IFEQ      '0'
 
     C                   SELECT
     C     Count         WHENEQ    2
     C                   MOVE      WWSetNum      DBSET02
     C                   Z-ADD     WWRiskWABal   DBAB02
 
     C     Count         WHENEQ    3
     C                   MOVE      WWSetNum      DBSET03
     C                   Z-ADD     WWRiskWABal   DBAB03
 
     C     Count         WHENEQ    4
     C                   MOVE      WWSetNum      DBSET04
     C                   Z-ADD     WWRiskWABal   DBAB04
 
     C     Count         WHENEQ    5
     C                   MOVE      WWSetNum      DBSET05
     C                   Z-ADD     WWRiskWABal   DBAB05
 
     C     Count         WHENEQ    6
     C                   MOVE      WWSetNum      DBSET06
     C                   Z-ADD     WWRiskWABal   DBAB06
 
     C     Count         WHENEQ    7
     C                   MOVE      WWSetNum      DBSET07
     C                   Z-ADD     WWRiskWABal   DBAB07
 
     C     Count         WHENEQ    8
     C                   MOVE      WWSetNum      DBSET08
     C                   Z-ADD     WWRiskWABal   DBAB08
 
     C     Count         WHENEQ    9
     C                   MOVE      WWSetNum      DBSET09
     C                   Z-ADD     WWRiskWABal   DBAB09
 
     C     Count         WHENEQ    10
     C                   MOVE      WWSetNum      DBSET10
     C                   Z-ADD     WWRiskWABal   DBAB10
 
     C     Count         WHENEQ    11
     C                   MOVE      WWSetNum      DBSET11
     C                   Z-ADD     WWRiskWABal   DBAB11
 
     C     Count         WHENEQ    12
     C                   MOVE      WWSetNum      DBSET12
     C                   Z-ADD     WWRiskWABal   DBAB12
 
     C     Count         WHENEQ    13
     C                   MOVE      WWSetNum      DBSET13
     C                   Z-ADD     WWRiskWABal   DBAB13
 
     C     Count         WHENEQ    14
     C                   MOVE      WWSetNum      DBSET14
     C                   Z-ADD     WWRiskWABal   DBAB14
 
     C     Count         WHENEQ    15
     C                   MOVE      WWSetNum      DBSET15
     C                   Z-ADD     WWRiskWABal   DBAB15
 
     C     Count         WHENEQ    16
     C                   MOVE      WWSetNum      DBSET16
     C                   Z-ADD     WWRiskWABal   DBAB16
 
     C     Count         WHENEQ    17
     C                   MOVE      WWSetNum      DBSET17
     C                   Z-ADD     WWRiskWABal   DBAB17
 
     C     Count         WHENEQ    18
     C                   MOVE      WWSetNum      DBSET18
     C                   Z-ADD     WWRiskWABal   DBAB18
 
     C     Count         WHENEQ    19
     C                   MOVE      WWSetNum      DBSET19
     C                   Z-ADD     WWRiskWABal   DBAB19
 
     C     Count         WHENEQ    20
     C                   MOVE      WWSetNum      DBSET20
     C                   Z-ADD     WWRiskWABal   DBAB20
 
     C     Count         WHENEQ    21
     C                   MOVE      WWSetNum      DBSET21
     C                   Z-ADD     WWRiskWABal   DBAB21
 
     C     Count         WHENEQ    22
     C                   MOVE      WWSetNum      DBSET22
     C                   Z-ADD     WWRiskWABal   DBAB22
 
     C     Count         WHENEQ    23
     C                   MOVE      WWSetNum      DBSET23
     C                   Z-ADD     WWRiskWABal   DBAB23
 
     C     Count         WHENEQ    24
     C                   MOVE      WWSetNum      DBSET24
     C                   Z-ADD     WWRiskWABal   DBAB24
 
     C     Count         WHENEQ    25
     C                   MOVE      WWSetNum      DBSET25
     C                   Z-ADD     WWRiskWABal   DBAB25
 
     C     Count         WHENEQ    26
     C                   MOVE      WWSetNum      DBSET26
     C                   Z-ADD     WWRiskWABal   DBAB26
 
     C     Count         WHENEQ    27
     C                   MOVE      WWSetNum      DBSET27
     C                   Z-ADD     WWRiskWABal   DBAB27
 
     C     Count         WHENEQ    28
     C                   MOVE      WWSetNum      DBSET28
     C                   Z-ADD     WWRiskWABal   DBAB28
 
     C     Count         WHENEQ    29
     C                   MOVE      WWSetNum      DBSET29
     C                   Z-ADD     WWRiskWABal   DBAB29
 
     C     Count         WHENEQ    30
     C                   MOVE      WWSetNum      DBSET30
     C                   Z-ADD     WWRiskWABal   DBAB30
 
     C     Count         WHENEQ    31
     C                   MOVE      WWSetNum      DBSET31
     C                   Z-ADD     WWRiskWABal   DBAB31
 
     C     Count         WHENEQ    32
     C                   MOVE      WWSetNum      DBSET32
     C                   Z-ADD     WWRiskWABal   DBAB32
 
     C     Count         WHENEQ    33
     C                   MOVE      WWSetNum      DBSET33
     C                   Z-ADD     WWRiskWABal   DBAB33
 
     C     Count         WHENEQ    34
     C                   MOVE      WWSetNum      DBSET34
     C                   Z-ADD     WWRiskWABal   DBAB34
 
     C     Count         WHENEQ    35
     C                   MOVE      WWSetNum      DBSET35
     C                   Z-ADD     WWRiskWABal   DBAB35
 
     C                   OTHER
     C                   MOVE      WWSetNum      DBSET36
     C                   Z-ADD     WWRiskWABal   DBAB36
 
     C                   ENDSL
 
     C                   UPDATE    DLRWABP1
 
     C                   EXSR      UPDATMXBL                                                  242239
      *
      ** If no record in DLRWABPD for this deal yet (this must be the first
      ** set so write the values in 01 fields)
      *
     C                   ELSE
 
     C                   MOVE      'D'           DBRECI
     C                   MOVEL     WWDealRef     DBDLNO
     C                   MOVE      WWSetNum      DBSET01
     C                   Z-ADD     WWRiskWABal   DBAB01
 
     C                   MOVEL     *BLANKS       DBSET02
     C                   MOVEL     *BLANKS       DBSET03
     C                   MOVEL     *BLANKS       DBSET04
     C                   MOVEL     *BLANKS       DBSET05
     C                   MOVEL     *BLANKS       DBSET06
     C                   MOVEL     *BLANKS       DBSET07
     C                   MOVEL     *BLANKS       DBSET08
     C                   MOVEL     *BLANKS       DBSET09
     C                   MOVEL     *BLANKS       DBSET10
     C                   MOVEL     *BLANKS       DBSET11
     C                   MOVEL     *BLANKS       DBSET12
     C                   MOVEL     *BLANKS       DBSET13
     C                   MOVEL     *BLANKS       DBSET14
     C                   MOVEL     *BLANKS       DBSET15
     C                   MOVEL     *BLANKS       DBSET16
     C                   MOVEL     *BLANKS       DBSET17
     C                   MOVEL     *BLANKS       DBSET18
     C                   MOVEL     *BLANKS       DBSET19
     C                   MOVEL     *BLANKS       DBSET20
     C                   MOVEL     *BLANKS       DBSET21
     C                   MOVEL     *BLANKS       DBSET22
     C                   MOVEL     *BLANKS       DBSET23
     C                   MOVEL     *BLANKS       DBSET24
     C                   MOVEL     *BLANKS       DBSET25
     C                   MOVEL     *BLANKS       DBSET26
     C                   MOVEL     *BLANKS       DBSET27
     C                   MOVEL     *BLANKS       DBSET28
     C                   MOVEL     *BLANKS       DBSET29
     C                   MOVEL     *BLANKS       DBSET30
     C                   MOVEL     *BLANKS       DBSET31
     C                   MOVEL     *BLANKS       DBSET32
     C                   MOVEL     *BLANKS       DBSET33
     C                   MOVEL     *BLANKS       DBSET34
     C                   MOVEL     *BLANKS       DBSET35
     C                   MOVEL     *BLANKS       DBSET36
 
     C                   Z-ADD     *ZERO         DBAB02
     C                   Z-ADD     *ZERO         DBAB03
     C                   Z-ADD     *ZERO         DBAB04
     C                   Z-ADD     *ZERO         DBAB05
     C                   Z-ADD     *ZERO         DBAB06
     C                   Z-ADD     *ZERO         DBAB07
     C                   Z-ADD     *ZERO         DBAB08
     C                   Z-ADD     *ZERO         DBAB09
     C                   Z-ADD     *ZERO         DBAB10
     C                   Z-ADD     *ZERO         DBAB11
     C                   Z-ADD     *ZERO         DBAB12
     C                   Z-ADD     *ZERO         DBAB13
     C                   Z-ADD     *ZERO         DBAB14
     C                   Z-ADD     *ZERO         DBAB15
     C                   Z-ADD     *ZERO         DBAB16
     C                   Z-ADD     *ZERO         DBAB17
     C                   Z-ADD     *ZERO         DBAB18
     C                   Z-ADD     *ZERO         DBAB19
     C                   Z-ADD     *ZERO         DBAB20
     C                   Z-ADD     *ZERO         DBAB21
     C                   Z-ADD     *ZERO         DBAB22
     C                   Z-ADD     *ZERO         DBAB23
     C                   Z-ADD     *ZERO         DBAB24
     C                   Z-ADD     *ZERO         DBAB25
     C                   Z-ADD     *ZERO         DBAB26
     C                   Z-ADD     *ZERO         DBAB27
     C                   Z-ADD     *ZERO         DBAB28
     C                   Z-ADD     *ZERO         DBAB29
     C                   Z-ADD     *ZERO         DBAB30
     C                   Z-ADD     *ZERO         DBAB31
     C                   Z-ADD     *ZERO         DBAB32
     C                   Z-ADD     *ZERO         DBAB33
     C                   Z-ADD     *ZERO         DBAB34
     C                   Z-ADD     *ZERO         DBAB35
     C                   Z-ADD     *ZERO         DBAB36
 
     C                   WRITE     DLRWABP0
                                                                                              242239
     C                   EXSR      UPDATMXBL                                                  242239
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************                       242239
      *                                                               *                       242239
      * UPDATMXBL - Updates MXBLDLL1.                                 *                       242239
      *                                                               *                       242239
      * Called by: UPDATRWADL                                         *                       242239
      *                                                               *                       242239
      * Calls: None                                                   *                       242239
      *                                                               *                       242239
      *****************************************************************                       242239
                                                                                              242239
     C     UPDATMXBL     BEGSR                                                                242239
                                                                                              242239
     C     KDlRun        CHAIN     MXBLDLP0                           04                      242239
                                                                                              242239
     C     *IN04         IFEQ      '0'                                                        242239
     C                   MOVE      DBSET01       MDSET01                                      242239
     C                   MOVE      DBSET02       MDSET02                                      242239
     C                   MOVE      DBSET03       MDSET03                                      242239
     C                   MOVE      DBSET04       MDSET04                                      242239
     C                   MOVE      DBSET05       MDSET05                                      242239
     C                   MOVE      DBSET06       MDSET06                                      242239
     C                   MOVE      DBSET07       MDSET07                                      242239
     C                   MOVE      DBSET08       MDSET08                                      242239
     C                   MOVE      DBSET09       MDSET09                                      242239
     C                   MOVE      DBSET10       MDSET10                                      242239
     C                   MOVE      DBSET11       MDSET11                                      242239
     C                   MOVE      DBSET12       MDSET12                                      242239
     C                   MOVE      DBSET13       MDSET13                                      242239
     C                   MOVE      DBSET14       MDSET14                                      242239
     C                   MOVE      DBSET15       MDSET15                                      242239
     C                   MOVE      DBSET16       MDSET16                                      242239
     C                   MOVE      DBSET17       MDSET17                                      242239
     C                   MOVE      DBSET18       MDSET18                                      242239
     C                   MOVE      DBSET19       MDSET19                                      242239
     C                   MOVE      DBSET20       MDSET20                                      242239
     C                   MOVE      DBSET21       MDSET21                                      242239
     C                   MOVE      DBSET22       MDSET22                                      242239
     C                   MOVE      DBSET23       MDSET23                                      242239
     C                   MOVE      DBSET24       MDSET24                                      242239
     C                   MOVE      DBSET25       MDSET25                                      242239
     C                   MOVE      DBSET26       MDSET26                                      242239
     C                   MOVE      DBSET27       MDSET27                                      242239
     C                   MOVE      DBSET28       MDSET28                                      242239
     C                   MOVE      DBSET29       MDSET29                                      242239
     C                   MOVE      DBSET30       MDSET30                                      242239
     C                   MOVE      DBSET31       MDSET31                                      242239
     C                   MOVE      DBSET32       MDSET32                                      242239
     C                   MOVE      DBSET33       MDSET33                                      242239
     C                   MOVE      DBSET34       MDSET34                                      242239
     C                   MOVE      DBSET35       MDSET35                                      242239
     C                   MOVE      DBSET36       MDSET36                                      242239
     C                   Z-ADD     DBAB01        MDAB01                                       242239
     C                   Z-ADD     DBAB02        MDAB02                                       242239
     C                   Z-ADD     DBAB03        MDAB03                                       242239
     C                   Z-ADD     DBAB04        MDAB04                                       242239
     C                   Z-ADD     DBAB05        MDAB05                                       242239
     C                   Z-ADD     DBAB06        MDAB06                                       242239
     C                   Z-ADD     DBAB07        MDAB07                                       242239
     C                   Z-ADD     DBAB08        MDAB08                                       242239
     C                   Z-ADD     DBAB09        MDAB09                                       242239
     C                   Z-ADD     DBAB10        MDAB10                                       242239
     C                   Z-ADD     DBAB11        MDAB11                                       242239
     C                   Z-ADD     DBAB12        MDAB12                                       242239
     C                   Z-ADD     DBAB13        MDAB13                                       242239
     C                   Z-ADD     DBAB14        MDAB14                                       242239
     C                   Z-ADD     DBAB15        MDAB15                                       242239
     C                   Z-ADD     DBAB16        MDAB16                                       242239
     C                   Z-ADD     DBAB17        MDAB17                                       242239
     C                   Z-ADD     DBAB18        MDAB18                                       242239
     C                   Z-ADD     DBAB19        MDAB19                                       242239
     C                   Z-ADD     DBAB20        MDAB20                                       242239
     C                   Z-ADD     DBAB21        MDAB21                                       242239
     C                   Z-ADD     DBAB22        MDAB22                                       242239
     C                   Z-ADD     DBAB23        MDAB23                                       242239
     C                   Z-ADD     DBAB24        MDAB24                                       242239
     C                   Z-ADD     DBAB25        MDAB25                                       242239
     C                   Z-ADD     DBAB26        MDAB26                                       242239
     C                   Z-ADD     DBAB27        MDAB27                                       242239
     C                   Z-ADD     DBAB28        MDAB28                                       242239
     C                   Z-ADD     DBAB29        MDAB29                                       242239
     C                   Z-ADD     DBAB30        MDAB30                                       242239
     C                   Z-ADD     DBAB31        MDAB31                                       242239
     C                   Z-ADD     DBAB32        MDAB32                                       242239
     C                   Z-ADD     DBAB33        MDAB33                                       242239
     C                   Z-ADD     DBAB34        MDAB34                                       242239
     C                   Z-ADD     DBAB35        MDAB35                                       242239
     C                   Z-ADD     DBAB36        MDAB36                                       242239
                                                                                              242239
     C                   UPDATE    MXBLDLP0                                                   242239
                                                                                              242239
     C                   ENDIF                                                                242239
                                                                                              242239
      ** Update all previous records for the deal too.                                        242239
                                                                                              242239
     C                   Z-ADD     *ZERO         WWRiskWAbal                                  242239
     C     KDlRun        SETLL     MXBLDLP0                                                   242239
     C     Dlno          READPE    MXBLDLP0                               04                  242239
                                                                                              242239
     C     *IN04         DOWEQ     '0'                                                        242239
     C                   Z-ADD     BAL           WWAsetBal                                    242239
     C                   MOVEL     'N'           WWWrtRWAR                                    242239
                                                                                              242239
      ** Call Dealing Risk Weighted Assets Allocation Program                                 242239
                                                                                              242239
     C                   CALLB     'DL001241'                                                 242239
     C                   PARM                    WWDealRef                                    242239
     C                   PARM                    WWDealCcy                                    242239
     C                   PARM                    WWAsetBal                                    242239
     C                   PARM                    WWCust                                       242239
     C                   PARM                    WWSetNum                                     242239
     C                   PARM                    WWCalcMet                                    242239
     C                   PARM                    WWRiskWABal                                  242239
     C                   PARM                    WWWrtRWAR                                    242239
                                                                                              242239
     C                   SELECT                                                               242239
     C     Count         WHENEQ    1                                                          242239
     C                   MOVE      WWSetNum      MDSET01                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB01                                       242239
                                                                                              242239
     C     Count         WHENEQ    2                                                          242239
     C                   MOVE      WWSetNum      MDSET02                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB02                                       242239
                                                                                              242239
     C     Count         WHENEQ    3                                                          242239
     C                   MOVE      WWSetNum      MDSET03                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB03                                       242239
                                                                                              242239
     C     Count         WHENEQ    4                                                          242239
     C                   MOVE      WWSetNum      MDSET04                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB04                                       242239
                                                                                              242239
     C     Count         WHENEQ    5                                                          242239
     C                   MOVE      WWSetNum      MDSET05                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB05                                       242239
                                                                                              242239
     C     Count         WHENEQ    6                                                          242239
     C                   MOVE      WWSetNum      MDSET06                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB06                                       242239
                                                                                              242239
     C     Count         WHENEQ    7                                                          242239
     C                   MOVE      WWSetNum      MDSET07                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB07                                       242239
                                                                                              242239
     C     Count         WHENEQ    8                                                          242239
     C                   MOVE      WWSetNum      MDSET08                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB08                                       242239
                                                                                              242239
     C     Count         WHENEQ    9                                                          242239
     C                   MOVE      WWSetNum      MDSET09                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB09                                       242239
                                                                                              242239
     C     Count         WHENEQ    10                                                         242239
     C                   MOVE      WWSetNum      MDSET10                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB10                                       242239
                                                                                              242239
     C     Count         WHENEQ    11                                                         242239
     C                   MOVE      WWSetNum      MDSET11                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB11                                       242239
                                                                                              242239
     C     Count         WHENEQ    12                                                         242239
     C                   MOVE      WWSetNum      MDSET12                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB12                                       242239
                                                                                              242239
     C     Count         WHENEQ    13                                                         242239
     C                   MOVE      WWSetNum      MDSET13                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB13                                       242239
                                                                                              242239
     C     Count         WHENEQ    14                                                         242239
     C                   MOVE      WWSetNum      MDSET14                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB14                                       242239
                                                                                              242239
     C     Count         WHENEQ    15                                                         242239
     C                   MOVE      WWSetNum      MDSET15                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB15                                       242239
                                                                                              242239
     C     Count         WHENEQ    16                                                         242239
     C                   MOVE      WWSetNum      MDSET16                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB16                                       242239
                                                                                              242239
     C     Count         WHENEQ    17                                                         242239
     C                   MOVE      WWSetNum      MDSET17                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB17                                       242239
                                                                                              242239
     C     Count         WHENEQ    18                                                         242239
     C                   MOVE      WWSetNum      MDSET18                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB18                                       242239
                                                                                              242239
     C     Count         WHENEQ    19                                                         242239
     C                   MOVE      WWSetNum      MDSET19                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB19                                       242239
                                                                                              242239
     C     Count         WHENEQ    20                                                         242239
     C                   MOVE      WWSetNum      MDSET20                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB20                                       242239
                                                                                              242239
     C     Count         WHENEQ    21                                                         242239
     C                   MOVE      WWSetNum      MDSET21                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB21                                       242239
                                                                                              242239
     C     Count         WHENEQ    22                                                         242239
     C                   MOVE      WWSetNum      MDSET22                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB22                                       242239
                                                                                              242239
     C     Count         WHENEQ    23                                                         242239
     C                   MOVE      WWSetNum      MDSET23                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB23                                       242239
                                                                                              242239
     C     Count         WHENEQ    24                                                         242239
     C                   MOVE      WWSetNum      MDSET24                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB24                                       242239
                                                                                              242239
     C     Count         WHENEQ    25                                                         242239
     C                   MOVE      WWSetNum      MDSET25                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB25                                       242239
                                                                                              242239
     C     Count         WHENEQ    26                                                         242239
     C                   MOVE      WWSetNum      MDSET26                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB26                                       242239
                                                                                              242239
     C     Count         WHENEQ    27                                                         242239
     C                   MOVE      WWSetNum      MDSET27                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB27                                       242239
                                                                                              242239
     C     Count         WHENEQ    28                                                         242239
     C                   MOVE      WWSetNum      MDSET28                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB28                                       242239
                                                                                              242239
     C     Count         WHENEQ    29                                                         242239
     C                   MOVE      WWSetNum      MDSET29                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB29                                       242239
                                                                                              242239
     C     Count         WHENEQ    30                                                         242239
     C                   MOVE      WWSetNum      MDSET30                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB30                                       242239
                                                                                              242239
     C     Count         WHENEQ    31                                                         242239
     C                   MOVE      WWSetNum      MDSET31                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB31                                       242239
                                                                                              242239
     C     Count         WHENEQ    32                                                         242239
     C                   MOVE      WWSetNum      MDSET32                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB32                                       242239
                                                                                              242239
     C     Count         WHENEQ    33                                                         242239
     C                   MOVE      WWSetNum      MDSET33                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB33                                       242239
                                                                                              242239
     C     Count         WHENEQ    34                                                         242239
     C                   MOVE      WWSetNum      MDSET34                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB34                                       242239
                                                                                              242239
     C     Count         WHENEQ    35                                                         242239
     C                   MOVE      WWSetNum      MDSET35                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB35                                       242239
                                                                                              242239
     C     Count         WHENEQ    36                                                         242239
     C                   MOVE      WWSetNum      MDSET36                                      242239
     C                   Z-ADD     WWRiskWABal   MDAB36                                       242239
                                                                                              242239
     C                   ENDSL                                                                242239
                                                                                              242239
     C                   UPDATE    MXBLDLP0                                                   242239
     C                   Z-ADD     *ZERO         WWRiskWABal                                  242239
                                                                                              242239
     C     Dlno          READPE    MXBLDLP0                               04                  242239
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
 
     C     *LIKE         DEFINE    DLNO          WWDealRef
     C     *LIKE         DEFINE    CCY           WWDealCcy
     C     *LIKE         DEFINE    DBDLNO        WXDlno
     C     *LIKE         DEFINE    RWSETN        WWSetNum
     C     *LIKE         DEFINE    RWCALC        WWCalcMet
     C     *LIKE         DEFINE    DBAB01        WWRiskWABal
 
     C                   MOVE      '0'           *IN20
     C                   Z-ADD     *ZERO         Count             2 0
                                                                                              242239
     C     KDlRun        KLIST                                                                242239
     C                   KFLD                    DLNO                                         242239
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
