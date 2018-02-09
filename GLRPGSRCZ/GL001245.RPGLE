     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('GL Risk Weighted Assets Balances Update Pgm')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL001245 - General Ledger Risk Weighted Assets Balances      *
      *             Update Program                                    *
      *                                                               *
      *  Function:  This module will call the calculation program to  *
      *             calculate the Risk Weighted Balance for all accnts*
      *             in the system. This risk weighted asset balance   *
      *             will be updated on the new GL RWA Balance file if *
      *             the a/c is a RE a/c.                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 258536             Date 21Jan09               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242239             Date 18Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 26Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  258536 - Recompiled due to COB failure.                      *
      *  242239 - Update Risk Weighted Asset and Balance in MXBLGLPD. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *    01         EOF for SDRWASL1                                *
      *    02         EOF for GLRACCL1                                *
      *    03         EOF for GLNETGL5                                *
      *    04         EOF for ACCNTL0                                 *
      *    05         EOF for GLRWABL0                                *
      *    06         EOF for MXBLGLL0                                *                       242239
      *                                                               *
      *    20         Reset file pointer                              *
      *    21         Bypass "Secondary" record in GLNETGPD           *
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
     FGLRWABL0  O    E           K DISK
     FGLRWABL1  UF   E           K DISK
     F                                     RENAME(GLRWABP0:GLRWABP1)
     FGLRACCL1  IF   E           K DISK    INFSR(*PSSR)
     FACCNTL10  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(J1)
     F                                     RENAME(ACCNTABF:ACCNTAB2)
     FGLNETGL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(TG)
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     FMXBLGLL0  UF   E           K DISK                                                       242239
 
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
 
     D                 DS
      ** Data Structure Redefining Accnt Key Fields
 
     D***AKEYF                  1     18                                                      CGL029
     D  AKEYF                  1     24                                                       CGL029
     D**NCust***               1      6  0                                                    CSD027
     D  NCust                  1      6                                                       CSD027
     D  NCusta                 1      6
     D  NCcy                   7      9
     D***NAcod**               10     13  0                                                   CGL029
     D***NAcoda*               10     13                                                      CGL029
     D***NAcsq**               14     15  0                                                   CGL029
     D***NAcsqa*               14     15                                                      CGL029
     D***NBrca**               16     18                                                      CGL029
     D  NAcod                 10     19  0                                                    CGL029
     D  NAcoda                10     19                                                       CGL029
     D  NAcsq                 20     21  0                                                    CGL029
     D  NAcsqa                20     21                                                       CGL029
     D  NBrca                 22     24                                                       CGL029
 
     D @RUN            S              1
 
      ** Data area for message file to use
     D ZADFMF        E DS                  EXTNAME(Y2MGFLA)
 
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
      **  Read Risk Weighted Assets SETS File
      *
     C                   READ      SDRWASL1                               01
 
     C     *IN01         DOWEQ     '0'
 
     C     RWRECI        IFNE      '*'
 
     C                   MOVE      RWSETN        WWSetNum
     C                   MOVE      RWCALC        WWCalcMet
 
     C                   EVAL      Count = Count + 1
      *
      **  Check if the GL Accounts are to be included in the processing
      *
     C                   EXSR      CHKFIRST
      *
      **  If returned parm is 'N' only process the Retail Accounts
      *
     C     WYorN         IFEQ      'N'
     C                   EXSR      DORETAIL
     C                   ELSE
      *
      **  else process GL and RE Accounts
     C                   EXSR      DOBOTH
     C                   ENDIF
 
     C                   MOVE      '1'           *IN20
 
     C                   ENDIF
 
     C                   READ      SDRWASL1                               01
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKFIRST - Checks if GL Accounts are to be processed          *
      *                                                               *
      * Calls: AOSVALR0                                               *
      *                                                               *
      *****************************************************************
 
     C     CHKFIRST      BEGSR
      *
      ** Clear variables for the next call
      *
     C                   MOVEL     *BLANKS       P@RTCD
     C                   MOVEL     *BLANKS       P@OP01
     C                   MOVEL     *BLANKS       P@VL01
      *
      ** To find out if GL Accounts are to be processed, call the access
      ** object program with the proper narrative as the second parameter.
      *
     C                   EVAL      P@OP01 = 'RiskWeightAssetIncGL'
 
     C                   CALLB     'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
 
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     'USR1241'     WMSGI
     C                   MOVEL     'SDUSRMSG'    WMSGF
     C                   EXSR      SRMSGF
     C                   ENDIF
      *
      ** If Return Code is blank, save returned parameters
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     P@VL01        WYorN
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * DORETAIL - Get Retail Accounts of the system                  *
      *                                                               *
      * Calls: GL001246                                               *
      *                                                               *
      *****************************************************************
 
     C     DORETAIL      BEGSR
      *
      **  Read GLRACCL1
      **  Pointer needs to be on the very first record again for the next
      **  Set Number record from SDRWASL1
      *
     C     *IN20         IFEQ      '1'
     C     *LOVAL        SETLL     GLRACCL1
     C                   ENDIF
 
     C                   READ      GLRACCL1                               02
 
     C     *IN02         DOWEQ     '0'
 
     C     LDBL          IFGT      *ZERO
 
     C**********         Z-ADD     CNUM          NCust                                        CSD027
     C                   EVAL      NCust = CNUM                                               CSD027
     C                   MOVEL     CNUM          NCusta
     C                   MOVE      CCY           NCcy
     C                   Z-ADD     ACOD          NAcod
     C                   MOVEL     ACOD          NAcoda
     C                   Z-ADD     ACSQ          NAcsq
     C                   MOVEL     ACSQ          NAcsqa
     C                   MOVE      BRCA          NBrca
     C                   Z-ADD     LDBL          NLdbl
     C                   MOVE      '0'           *IN21
 
     C     KNETREC       CHAIN     GLNETGL5                           03
      *
      **  If record not found, use Ledger Balance from GLRACCL1 for
      **  Asset Balance
      *
     C     *IN03         IFEQ      '1'
     C                   Z-ADD     NLdbl         WGrpBal
     C                   MOVE      '1'           *IN21
     C                   ENDIF
      *
      **  If record found, it should be a Primary record.  Secondary records
      **  are not processed. Use Primary A/c Balance as Asset Balance.
      *
     C     *IN03         IFEQ      '0'
     C     TGRWPRIM      ANDEQ     'P'
     C                   Z-ADD     TGRWPBAL      WGrpBal          15 0
     C                   MOVE      '1'           *IN21
     C                   ENDIF
      *
      ** Only do the rest if *IN21 = 1 (Bypass Secondary) else, get next A/c
      *
     C     *IN21         IFEQ      '1'
      *
      ** Call Accounts Risk Weighted Assets Allocation Program
      *
     C                   MOVEL     AKEYF         WWAcctRef
     C                   Z-ADD     WGrpBal       WWAsetBal
     C                   MOVE      'RE'          WWGLREind
     C                   MOVE      'Y'           WWWrtRWAR         1                          242239
      *
     C                   CALLB     'GL001246'
     C                   PARM                    WWAcctRef
     C                   PARM                    WWAsetBal
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
     C                   PARM                    WWGLREind
     C                   PARM                    WWWrtRWAR                                    242239
      *
      ** Update GL RWA Balances File from the returned Risk Weighted
      ** Asset Balance figure
      *
     C                   EXSR      UPDATRWAGL
 
      ** Initialise RWA Balance variable for the next call
      *
     C                   Z-ADD     *ZERO         WWRiskWABal
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      GLRACCL1                               02
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * DOBOTH - Get Retail or Other Accounts of the system           *
      *                                                               *
      * Calls: GL001246                                               *
      *                                                               *
      *****************************************************************
 
     C     DOBOTH        BEGSR
      *
      **  Read ACCNTL10 (live accounts)
      **  Pointer needs to be on the very first record again for the next
      **  Set Number record from SDRWASL1
      *
     C     *IN20         IFEQ      '1'
     C     *LOVAL        SETLL     ACCNTL10
     C                   ENDIF
 
     C                   READ      ACCNTL10                               04
 
     C     *IN04         DOWEQ     '0'
 
     C**********         Z-ADD     J1CNUM        NCust                                        CSD027
     C                   EVAL      NCust = J1CNUM                                             CSD027
     C                   MOVEL     J1CNUM        NCusta
     C                   MOVE      J1CCY         NCcy
     C                   Z-ADD     J1ACOD        NAcod
     C                   MOVEL     J1ACOD        NAcoda
     C                   Z-ADD     J1ACSQ        NAcsq
     C                   MOVEL     J1ACSQ        NAcsqa
     C                   MOVE      J1BRCA        NBrca
     C                   Z-ADD     J1LDBL        NLdbl
     C                   MOVE      J1ATYP        WActTyp           1
     C                   MOVE      '0'           *IN21
      *
      **  Find the record in Netting Group File
      *
     C     KNETREC       CHAIN     GLNETGL5                           03
      *
      **  If record not found, use Ledger Balance from ACCNTL0 for
      **  Asset Balance
      *
     C     *IN03         IFEQ      '1'
     C                   Z-ADD     NLdbl         WGrpBal
     C                   MOVE      '1'           *IN21
     C                   ENDIF
      *
      **  If record found, it should be a Primary record.  Secondary records
      **  are not processed. Use Primary A/c Balance as Asset Balance.
      *
     C     *IN03         IFEQ      '0'
     C     TGRWPRIM      ANDEQ     'P'
     C                   Z-ADD     TGRWPBAL      WGrpBal
     C                   MOVE      '1'           *IN21
     C                   ENDIF
      *
      ** Only do the rest if *IN21 = 1 (Bypass Secondary) else, get next A/c
      *
     C     *IN21         IFEQ      '1'
      *
      ** Set Account Type for the GL/RE Indicator to be passed
      *
     C     WActTyp       IFEQ      'R'
     C                   MOVE      'RE'          WWGLREind
     C                   ELSE
     C                   MOVE      'GL'          WWGLREind
     C                   ENDIF
      *
      ** Call Accounts Risk Weighted Assets Allocation Program
      *
     C                   MOVEL     AKEYF         WWAcctRef
     C                   Z-ADD     WGrpBal       WWAsetBal
     C                   MOVE      'Y'           WWWrtRWAR                                    242239
      *
     C                   CALLB     'GL001246'
     C                   PARM                    WWAcctRef
     C                   PARM                    WWAsetBal
     C                   PARM                    WWSetNum
     C                   PARM                    WWCalcMet
     C                   PARM                    WWRiskWABal
     C                   PARM                    WWGLREind
     C                   PARM                    WWWrtRWAR                                    242239
      *
      ** Update GL RWA Balances File from the returned Risk Weighted
      ** Asset Balance figure
      *
     C                   EXSR      UPDATRWAGL
 
      ** Initialise RWA Balance variable for the next call
      *
     C                   Z-ADD     *ZERO         WWRiskWABal
 
     C                   ENDIF
 
     C                   READ      ACCNTL10                               04
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATRWAGL - Updates GLRWABL0 for this Account                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATRWAGL    BEGSR
      *
      **  Move field values for accessing record in the Accounts Risk
      **  Weighted Assets Balances File
      *
 
     C     KRWAGL        CHAIN     GLRWABP1                           05
 
     C     *IN05         IFEQ      '0'
 
     C                   SELECT
     C     Count         WHENEQ    2
     C                   MOVE      WWSetNum      RBSET02
     C                   Z-ADD     WWRiskWABal   RBAB02
 
     C     Count         WHENEQ    3
     C                   MOVE      WWSetNum      RBSET03
     C                   Z-ADD     WWRiskWABal   RBAB03
 
     C     Count         WHENEQ    4
     C                   MOVE      WWSetNum      RBSET04
     C                   Z-ADD     WWRiskWABal   RBAB04
 
     C     Count         WHENEQ    5
     C                   MOVE      WWSetNum      RBSET05
     C                   Z-ADD     WWRiskWABal   RBAB05
 
     C     Count         WHENEQ    6
     C                   MOVE      WWSetNum      RBSET06
     C                   Z-ADD     WWRiskWABal   RBAB06
 
     C     Count         WHENEQ    7
     C                   MOVE      WWSetNum      RBSET07
     C                   Z-ADD     WWRiskWABal   RBAB07
 
     C     Count         WHENEQ    8
     C                   MOVE      WWSetNum      RBSET08
     C                   Z-ADD     WWRiskWABal   RBAB08
 
     C     Count         WHENEQ    9
     C                   MOVE      WWSetNum      RBSET09
     C                   Z-ADD     WWRiskWABal   RBAB09
 
     C     Count         WHENEQ    10
     C                   MOVE      WWSetNum      RBSET10
     C                   Z-ADD     WWRiskWABal   RBAB10
 
     C     Count         WHENEQ    11
     C                   MOVE      WWSetNum      RBSET11
     C                   Z-ADD     WWRiskWABal   RBAB11
 
     C     Count         WHENEQ    12
     C                   MOVE      WWSetNum      RBSET12
     C                   Z-ADD     WWRiskWABal   RBAB12
 
     C     Count         WHENEQ    13
     C                   MOVE      WWSetNum      RBSET13
     C                   Z-ADD     WWRiskWABal   RBAB13
 
     C     Count         WHENEQ    14
     C                   MOVE      WWSetNum      RBSET14
     C                   Z-ADD     WWRiskWABal   RBAB14
 
     C     Count         WHENEQ    15
     C                   MOVE      WWSetNum      RBSET15
     C                   Z-ADD     WWRiskWABal   RBAB15
 
     C     Count         WHENEQ    16
     C                   MOVE      WWSetNum      RBSET16
     C                   Z-ADD     WWRiskWABal   RBAB16
 
     C     Count         WHENEQ    17
     C                   MOVE      WWSetNum      RBSET17
     C                   Z-ADD     WWRiskWABal   RBAB17
 
     C     Count         WHENEQ    18
     C                   MOVE      WWSetNum      RBSET18
     C                   Z-ADD     WWRiskWABal   RBAB18
 
     C     Count         WHENEQ    19
     C                   MOVE      WWSetNum      RBSET19
     C                   Z-ADD     WWRiskWABal   RBAB19
 
     C     Count         WHENEQ    20
     C                   MOVE      WWSetNum      RBSET20
     C                   Z-ADD     WWRiskWABal   RBAB20
 
     C     Count         WHENEQ    21
     C                   MOVE      WWSetNum      RBSET21
     C                   Z-ADD     WWRiskWABal   RBAB21
 
     C     Count         WHENEQ    22
     C                   MOVE      WWSetNum      RBSET22
     C                   Z-ADD     WWRiskWABal   RBAB22
 
     C     Count         WHENEQ    23
     C                   MOVE      WWSetNum      RBSET23
     C                   Z-ADD     WWRiskWABal   RBAB23
 
     C     Count         WHENEQ    24
     C                   MOVE      WWSetNum      RBSET24
     C                   Z-ADD     WWRiskWABal   RBAB24
 
     C     Count         WHENEQ    25
     C                   MOVE      WWSetNum      RBSET25
     C                   Z-ADD     WWRiskWABal   RBAB25
 
     C     Count         WHENEQ    26
     C                   MOVE      WWSetNum      RBSET26
     C                   Z-ADD     WWRiskWABal   RBAB26
 
     C     Count         WHENEQ    27
     C                   MOVE      WWSetNum      RBSET27
     C                   Z-ADD     WWRiskWABal   RBAB27
 
     C     Count         WHENEQ    28
     C                   MOVE      WWSetNum      RBSET28
     C                   Z-ADD     WWRiskWABal   RBAB28
 
     C     Count         WHENEQ    29
     C                   MOVE      WWSetNum      RBSET29
     C                   Z-ADD     WWRiskWABal   RBAB29
 
     C     Count         WHENEQ    30
     C                   MOVE      WWSetNum      RBSET30
     C                   Z-ADD     WWRiskWABal   RBAB30
 
     C     Count         WHENEQ    31
     C                   MOVE      WWSetNum      RBSET31
     C                   Z-ADD     WWRiskWABal   RBAB31
 
     C     Count         WHENEQ    32
     C                   MOVE      WWSetNum      RBSET32
     C                   Z-ADD     WWRiskWABal   RBAB32
 
     C     Count         WHENEQ    33
     C                   MOVE      WWSetNum      RBSET33
     C                   Z-ADD     WWRiskWABal   RBAB33
 
     C     Count         WHENEQ    34
     C                   MOVE      WWSetNum      RBSET34
     C                   Z-ADD     WWRiskWABal   RBAB34
 
     C     Count         WHENEQ    35
     C                   MOVE      WWSetNum      RBSET35
     C                   Z-ADD     WWRiskWABal   RBAB35
 
     C                   OTHER
     C                   MOVE      WWSetNum      RBSET36
     C                   Z-ADD     WWRiskWABal   RBAB36
 
     C                   ENDSL
 
     C                   UPDATE    GLRWABP1
 
     C                   EXSR      UPDATMXBL                                                  242239
      *
      ** If no record in GLRWABPD for this accnt yet (this must be the first
      ** set so write the values in 01 fields)
      *
     C                   ELSE
 
     C                   MOVE      'D'           RBRECI
     C                   MOVEL     NBrca         RBBRCA
     C                   MOVEL     NCust         RBCUST
     C                   MOVEL     NCcy          RBCCY
     C                   MOVEL     NAcod         RBACOD
     C                   MOVEL     NAcsq         RBACSQ
     C                   MOVEL     WWSetNum      RBSET01
     C                   Z-ADD     WWRiskWABal   RBAB01
 
     C                   MOVEL     *BLANKS       RBSET02
     C                   MOVEL     *BLANKS       RBSET03
     C                   MOVEL     *BLANKS       RBSET04
     C                   MOVEL     *BLANKS       RBSET05
     C                   MOVEL     *BLANKS       RBSET06
     C                   MOVEL     *BLANKS       RBSET07
     C                   MOVEL     *BLANKS       RBSET08
     C                   MOVEL     *BLANKS       RBSET09
     C                   MOVEL     *BLANKS       RBSET10
     C                   MOVEL     *BLANKS       RBSET11
     C                   MOVEL     *BLANKS       RBSET12
     C                   MOVEL     *BLANKS       RBSET13
     C                   MOVEL     *BLANKS       RBSET14
     C                   MOVEL     *BLANKS       RBSET15
     C                   MOVEL     *BLANKS       RBSET16
     C                   MOVEL     *BLANKS       RBSET17
     C                   MOVEL     *BLANKS       RBSET18
     C                   MOVEL     *BLANKS       RBSET19
     C                   MOVEL     *BLANKS       RBSET20
     C                   MOVEL     *BLANKS       RBSET21
     C                   MOVEL     *BLANKS       RBSET22
     C                   MOVEL     *BLANKS       RBSET23
     C                   MOVEL     *BLANKS       RBSET24
     C                   MOVEL     *BLANKS       RBSET25
     C                   MOVEL     *BLANKS       RBSET26
     C                   MOVEL     *BLANKS       RBSET27
     C                   MOVEL     *BLANKS       RBSET28
     C                   MOVEL     *BLANKS       RBSET29
     C                   MOVEL     *BLANKS       RBSET30
     C                   MOVEL     *BLANKS       RBSET31
     C                   MOVEL     *BLANKS       RBSET32
     C                   MOVEL     *BLANKS       RBSET33
     C                   MOVEL     *BLANKS       RBSET34
     C                   MOVEL     *BLANKS       RBSET35
     C                   MOVEL     *BLANKS       RBSET36
 
     C                   Z-ADD     *ZERO         RBAB02
     C                   Z-ADD     *ZERO         RBAB03
     C                   Z-ADD     *ZERO         RBAB04
     C                   Z-ADD     *ZERO         RBAB05
     C                   Z-ADD     *ZERO         RBAB06
     C                   Z-ADD     *ZERO         RBAB07
     C                   Z-ADD     *ZERO         RBAB08
     C                   Z-ADD     *ZERO         RBAB09
     C                   Z-ADD     *ZERO         RBAB10
     C                   Z-ADD     *ZERO         RBAB11
     C                   Z-ADD     *ZERO         RBAB12
     C                   Z-ADD     *ZERO         RBAB13
     C                   Z-ADD     *ZERO         RBAB14
     C                   Z-ADD     *ZERO         RBAB15
     C                   Z-ADD     *ZERO         RBAB16
     C                   Z-ADD     *ZERO         RBAB17
     C                   Z-ADD     *ZERO         RBAB18
     C                   Z-ADD     *ZERO         RBAB19
     C                   Z-ADD     *ZERO         RBAB20
     C                   Z-ADD     *ZERO         RBAB21
     C                   Z-ADD     *ZERO         RBAB22
     C                   Z-ADD     *ZERO         RBAB23
     C                   Z-ADD     *ZERO         RBAB24
     C                   Z-ADD     *ZERO         RBAB25
     C                   Z-ADD     *ZERO         RBAB26
     C                   Z-ADD     *ZERO         RBAB27
     C                   Z-ADD     *ZERO         RBAB28
     C                   Z-ADD     *ZERO         RBAB29
     C                   Z-ADD     *ZERO         RBAB30
     C                   Z-ADD     *ZERO         RBAB31
     C                   Z-ADD     *ZERO         RBAB32
     C                   Z-ADD     *ZERO         RBAB33
     C                   Z-ADD     *ZERO         RBAB34
     C                   Z-ADD     *ZERO         RBAB35
     C                   Z-ADD     *ZERO         RBAB36
 
     C                   WRITE     GLRWABP0
                                                                                              242239
     C                   EXSR      UPDATMXBL                                                  242239
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************                       242239
      *                                                               *                       242239
      * UPDATMXBL - Updates MXBLGLL0.                                 *                       242239
      *                                                               *                       242239
      * Called by: UPDATRWAGL                                         *                       242239
      *                                                               *                       242239
      * Calls: None                                                   *                       242239
      *                                                               *                       242239
      *****************************************************************                       242239
                                                                                              242239
     C     UPDATMXBL     BEGSR                                                                242239
                                                                                              242239
     C     KaccRun       CHAIN     MXBLGLP0                           06                      242239
                                                                                              242239
     C     *IN06         IFEQ      '0'                                                        242239
     C                   MOVE      RBSET01       MGSET01                                      242239
     C                   MOVE      RBSET02       MGSET02                                      242239
     C                   MOVE      RBSET03       MGSET03                                      242239
     C                   MOVE      RBSET04       MGSET04                                      242239
     C                   MOVE      RBSET05       MGSET05                                      242239
     C                   MOVE      RBSET06       MGSET06                                      242239
     C                   MOVE      RBSET07       MGSET07                                      242239
     C                   MOVE      RBSET08       MGSET08                                      242239
     C                   MOVE      RBSET09       MGSET09                                      242239
     C                   MOVE      RBSET10       MGSET10                                      242239
     C                   MOVE      RBSET11       MGSET11                                      242239
     C                   MOVE      RBSET12       MGSET12                                      242239
     C                   MOVE      RBSET13       MGSET13                                      242239
     C                   MOVE      RBSET14       MGSET14                                      242239
     C                   MOVE      RBSET15       MGSET15                                      242239
     C                   MOVE      RBSET16       MGSET16                                      242239
     C                   MOVE      RBSET17       MGSET17                                      242239
     C                   MOVE      RBSET18       MGSET18                                      242239
     C                   MOVE      RBSET19       MGSET19                                      242239
     C                   MOVE      RBSET20       MGSET20                                      242239
     C                   MOVE      RBSET21       MGSET21                                      242239
     C                   MOVE      RBSET22       MGSET22                                      242239
     C                   MOVE      RBSET23       MGSET23                                      242239
     C                   MOVE      RBSET24       MGSET24                                      242239
     C                   MOVE      RBSET25       MGSET25                                      242239
     C                   MOVE      RBSET26       MGSET26                                      242239
     C                   MOVE      RBSET27       MGSET27                                      242239
     C                   MOVE      RBSET28       MGSET28                                      242239
     C                   MOVE      RBSET29       MGSET29                                      242239
     C                   MOVE      RBSET30       MGSET30                                      242239
     C                   MOVE      RBSET31       MGSET31                                      242239
     C                   MOVE      RBSET32       MGSET32                                      242239
     C                   MOVE      RBSET33       MGSET33                                      242239
     C                   MOVE      RBSET34       MGSET34                                      242239
     C                   MOVE      RBSET35       MGSET35                                      242239
     C                   MOVE      RBSET36       MGSET36                                      242239
     C                   Z-ADD     RBAB01        MGAB01                                       242239
     C                   Z-ADD     RBAB02        MGAB02                                       242239
     C                   Z-ADD     RBAB03        MGAB03                                       242239
     C                   Z-ADD     RBAB04        MGAB04                                       242239
     C                   Z-ADD     RBAB05        MGAB05                                       242239
     C                   Z-ADD     RBAB06        MGAB06                                       242239
     C                   Z-ADD     RBAB07        MGAB07                                       242239
     C                   Z-ADD     RBAB08        MGAB08                                       242239
     C                   Z-ADD     RBAB09        MGAB09                                       242239
     C                   Z-ADD     RBAB10        MGAB10                                       242239
     C                   Z-ADD     RBAB11        MGAB11                                       242239
     C                   Z-ADD     RBAB12        MGAB12                                       242239
     C                   Z-ADD     RBAB13        MGAB13                                       242239
     C                   Z-ADD     RBAB14        MGAB14                                       242239
     C                   Z-ADD     RBAB15        MGAB15                                       242239
     C                   Z-ADD     RBAB16        MGAB16                                       242239
     C                   Z-ADD     RBAB17        MGAB17                                       242239
     C                   Z-ADD     RBAB18        MGAB18                                       242239
     C                   Z-ADD     RBAB19        MGAB19                                       242239
     C                   Z-ADD     RBAB20        MGAB20                                       242239
     C                   Z-ADD     RBAB21        MGAB21                                       242239
     C                   Z-ADD     RBAB22        MGAB22                                       242239
     C                   Z-ADD     RBAB23        MGAB23                                       242239
     C                   Z-ADD     RBAB24        MGAB24                                       242239
     C                   Z-ADD     RBAB25        MGAB25                                       242239
     C                   Z-ADD     RBAB26        MGAB26                                       242239
     C                   Z-ADD     RBAB27        MGAB27                                       242239
     C                   Z-ADD     RBAB28        MGAB28                                       242239
     C                   Z-ADD     RBAB29        MGAB29                                       242239
     C                   Z-ADD     RBAB30        MGAB30                                       242239
     C                   Z-ADD     RBAB31        MGAB31                                       242239
     C                   Z-ADD     RBAB32        MGAB32                                       242239
     C                   Z-ADD     RBAB33        MGAB33                                       242239
     C                   Z-ADD     RBAB34        MGAB34                                       242239
     C                   Z-ADD     RBAB35        MGAB35                                       242239
     C                   Z-ADD     RBAB36        MGAB36                                       242239
                                                                                              242239
     C                   UPDATE    MXBLGLP0                                                   242239
                                                                                              242239
     C                   ENDIF                                                                242239
                                                                                              242239
      ** Update all previous records for the account too.                                     242239
                                                                                              242239
     C                   Z-ADD     *ZERO         WWRiskWABal                                  242239
     C     KAccrun       SETLL     MXBLGLP0                                                   242239
     C     KRWAGL        READPE    MXBLGLP0                               04                  242239
                                                                                              242239
     C     *IN04         DOWEQ     '0'                                                        242239
     C                   Z-ADD     BAL           WWAsetBal                                    242239
     C                   MOVEL     'N'           WWWrtRWAR                                    242239
                                                                                              242239
      ** Call Accounts Risk Weighted Assets Allocation Program                                242239
                                                                                              242239
     C                   CALLB     'GL001246'                                                 242239
     C                   PARM                    WWAcctRef                                    242239
     C                   PARM                    WWAsetBal                                    242239
     C                   PARM                    WWSetNum                                     242239
     C                   PARM                    WWCalcMet                                    242239
     C                   PARM                    WWRiskWABal                                  242239
     C                   PARM                    WWGLREind                                    242239
     C                   PARM                    WWWrtRWAR                                    242239
                                                                                              242239
     C                   SELECT                                                               242239
     C     Count         WHENEQ    1                                                          242239
     C                   MOVE      WWSetNum      MGSET01                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB01                                       242239
                                                                                              242239
     C     Count         WHENEQ    2                                                          242239
     C                   MOVE      WWSetNum      MGSET02                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB02                                       242239
                                                                                              242239
     C     Count         WHENEQ    3                                                          242239
     C                   MOVE      WWSetNum      MGSET03                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB03                                       242239
                                                                                              242239
     C     Count         WHENEQ    4                                                          242239
     C                   MOVE      WWSetNum      MGSET04                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB04                                       242239
                                                                                              242239
     C     Count         WHENEQ    5                                                          242239
     C                   MOVE      WWSetNum      MGSET05                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB05                                       242239
                                                                                              242239
     C     Count         WHENEQ    6                                                          242239
     C                   MOVE      WWSetNum      MGSET06                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB06                                       242239
                                                                                              242239
     C     Count         WHENEQ    7                                                          242239
     C                   MOVE      WWSetNum      MGSET07                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB07                                       242239
                                                                                              242239
     C     Count         WHENEQ    8                                                          242239
     C                   MOVE      WWSetNum      MGSET08                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB08                                       242239
                                                                                              242239
     C     Count         WHENEQ    9                                                          242239
     C                   MOVE      WWSetNum      MGSET09                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB09                                       242239
                                                                                              242239
     C     Count         WHENEQ    10                                                         242239
     C                   MOVE      WWSetNum      MGSET10                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB10                                       242239
                                                                                              242239
     C     Count         WHENEQ    11                                                         242239
     C                   MOVE      WWSetNum      MGSET11                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB11                                       242239
                                                                                              242239
     C     Count         WHENEQ    12                                                         242239
     C                   MOVE      WWSetNum      MGSET12                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB12                                       242239
                                                                                              242239
     C     Count         WHENEQ    13                                                         242239
     C                   MOVE      WWSetNum      MGSET13                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB13                                       242239
                                                                                              242239
     C     Count         WHENEQ    14                                                         242239
     C                   MOVE      WWSetNum      MGSET14                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB14                                       242239
                                                                                              242239
     C     Count         WHENEQ    15                                                         242239
     C                   MOVE      WWSetNum      MGSET15                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB15                                       242239
                                                                                              242239
     C     Count         WHENEQ    16                                                         242239
     C                   MOVE      WWSetNum      MGSET16                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB16                                       242239
                                                                                              242239
     C     Count         WHENEQ    17                                                         242239
     C                   MOVE      WWSetNum      MGSET17                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB17                                       242239
                                                                                              242239
     C     Count         WHENEQ    18                                                         242239
     C                   MOVE      WWSetNum      MGSET18                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB18                                       242239
                                                                                              242239
     C     Count         WHENEQ    19                                                         242239
     C                   MOVE      WWSetNum      MGSET19                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB19                                       242239
                                                                                              242239
     C     Count         WHENEQ    20                                                         242239
     C                   MOVE      WWSetNum      MGSET20                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB20                                       242239
                                                                                              242239
     C     Count         WHENEQ    21                                                         242239
     C                   MOVE      WWSetNum      MGSET21                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB21                                       242239
                                                                                              242239
     C     Count         WHENEQ    22                                                         242239
     C                   MOVE      WWSetNum      MGSET22                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB22                                       242239
                                                                                              242239
     C     Count         WHENEQ    23                                                         242239
     C                   MOVE      WWSetNum      MGSET23                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB23                                       242239
                                                                                              242239
     C     Count         WHENEQ    24                                                         242239
     C                   MOVE      WWSetNum      MGSET24                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB24                                       242239
                                                                                              242239
     C     Count         WHENEQ    25                                                         242239
     C                   MOVE      WWSetNum      MGSET25                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB25                                       242239
                                                                                              242239
     C     Count         WHENEQ    26                                                         242239
     C                   MOVE      WWSetNum      MGSET26                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB26                                       242239
                                                                                              242239
     C     Count         WHENEQ    27                                                         242239
     C                   MOVE      WWSetNum      MGSET27                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB27                                       242239
                                                                                              242239
     C     Count         WHENEQ    28                                                         242239
     C                   MOVE      WWSetNum      MGSET28                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB28                                       242239
                                                                                              242239
     C     Count         WHENEQ    29                                                         242239
     C                   MOVE      WWSetNum      MGSET29                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB29                                       242239
                                                                                              242239
     C     Count         WHENEQ    30                                                         242239
     C                   MOVE      WWSetNum      MGSET30                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB30                                       242239
                                                                                              242239
     C     Count         WHENEQ    31                                                         242239
     C                   MOVE      WWSetNum      MGSET31                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB31                                       242239
                                                                                              242239
     C     Count         WHENEQ    32                                                         242239
     C                   MOVE      WWSetNum      MGSET32                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB32                                       242239
                                                                                              242239
     C     Count         WHENEQ    33                                                         242239
     C                   MOVE      WWSetNum      MGSET33                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB33                                       242239
                                                                                              242239
     C     Count         WHENEQ    34                                                         242239
     C                   MOVE      WWSetNum      MGSET34                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB34                                       242239
                                                                                              242239
     C     Count         WHENEQ    35                                                         242239
     C                   MOVE      WWSetNum      MGSET35                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB35                                       242239
                                                                                              242239
     C     Count         WHENEQ    36                                                         242239
     C                   MOVE      WWSetNum      MGSET36                                      242239
     C                   Z-ADD     WWRiskWABal   MGAB36                                       242239
                                                                                              242239
     C                   ENDSL                                                                242239
                                                                                              242239
     C                   UPDATE    MXBLGLP0                                                   242239
     C                   Z-ADD     *ZERO         WWRiskWABal                                  242239
                                                                                              242239
     C     KRWAGL        READPE    MXBLGLP0                               04                  242239
                                                                                              242239
     C                   ENDDO                                                                242239
                                                                                              242239
     C                   ENDSR                                                                242239
      /EJECT                                                                                  242239
      *****************************************************************
      *                                                               *
      * SRMSGF - Message Handling Subroutine                          *
      *                                                               *
      * Called by: CHKFIRST                                           *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMSGF        BEGSR
      *
     C     WMSGF         IFEQ      *BLANKS
     C                   MOVE      ZADFMF        WMSGF
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    WMSGF
     C                   PARM                    WMSGI
 
     C                   MOVE      *BLANKS       WMSGF
 
     C                   ENDSR
 
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
 
     C     *LIKE         DEFINE    AKEYF         WWAcctRef
     C     *LIKE         DEFINE    RWSETN        WWSetNum
     C     *LIKE         DEFINE    RWCALC        WWCalcMet
     C     *LIKE         DEFINE    RBAB01        WWRiskWABal
     C     *LIKE         DEFINE    LDBL          NLdbl
 
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      *BLANKS       WMSGI            10
     C                   MOVE      *BLANKS       WMSGF            10
     C                   MOVE      *BLANKS       WYorN             1
     C                   Z-ADD     *ZERO         WWAsetBal        15 0
     C                   Z-ADD     *ZERO         Count             2 0
     C                   MOVE      *BLANKS       WWGLREind         2
 
     C     KNETREC       KLIST
     C                   KFLD                    NBrca
     C                   KFLD                    NCust
     C                   KFLD                    NCcy
     C                   KFLD                    NAcod
     C                   KFLD                    NAcsq
 
     C     KRWAGL        KLIST
     C                   KFLD                    NBrca
     C                   KFLD                    NCust
     C                   KFLD                    NCcy
     C                   KFLD                    NAcod
     C                   KFLD                    NAcsq
 
     C     KAccRun       KLIST                                                                242239
     C                   KFLD                    NBrca                                        242239
     C                   KFLD                    NCust                                        242239
     C                   KFLD                    NCcy                                         242239
     C                   KFLD                    NAcod                                        242239
     C                   KFLD                    NAcsq                                        242239
     C                   KFLD                    AGRDNB                                       242239
                                                                                              242239
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
