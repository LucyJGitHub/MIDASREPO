     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*OVR *: OVRDBF FILE(SDSECSLR) TOFILE(SDSECSL0) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details retrieve')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDRTV - SECURITY CUSTOMER DETAILS RETRIEVE               *
      *              (WITH ACTION CODE VERSUS CUSTOMER NO. VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a securities client from    *
      *             the database. As it does so, it validates the     *
      *             action code and Customer number.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 03May13               *
      *  Prev Amend No. AR906833           Date 18Dec12               *
      *                 AR875962           Date 15Dec11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260292             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256870             Date 07Nov08               *
      *                 256564             Date 17Sep08               *
      *                 249076             Date 08Aug07               *
      *                 BUG14009           Date 02Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11828           Date 13Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10758           Date 07Mar06               *
      *                 CSE070             Date 15Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 09Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209762             Date 17Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 195852             Date 16Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR906833 - Allows deletion of Securities Trading Customers   *
      *             which are still needed by the system.             *
      *           - Created a single user message preventing the      *
      *             deletion of customer that is still being used     *
      *             by live and historic trades both from live and    *
      *             historic files.                                   *
      *           - Include the exemption of deletion among           *
      *             customers that are present on settled trades.     *
      *             Applied AR663084/A. (Child: AR906834)             *
      *  AR875962 - Customer not found when creating a new customer   *
      *  260292 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  256870 - Strange behaviour of Customer Maintenance function  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG14009 - To implement Close and Release functionality in   *
      *             Customer API.                                     *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10758 - Misleading error text                             *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Moved some processing from *INZSR to INIT subrou-  *
      *            tine                                               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE042 - Auto Feed of Trades and Movements (Recompile)       *
      *  CSE041 - DVP/RVP Processing (Recompile)                      *
      *  CSE039 - Automatic Settlement of Trades (Recompile)          *
      *  209762 - incorrect chain in CDEPC (key sometimes not filled) *
      *  195852 - Avoid SE Customer Details to go in Repair Queue if  *
      *           SD Customer Details not yet in PF/SDCUSTPD.         *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDSECDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDSECSD0:SDSECFOI)
 
     FSDSECSLR  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BFREDP:SECFMAT)
      * Securities Clients Details File by Customer Number
 
 
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBG:CUSTNUM)
      * Customer File by Customer Number
 
 
     FSDCUSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@CUSTD5:CUSTSNAME)
      * Customer File by Customer Shortname
 
 
     F***CDEPC**   IF   E           K DISK                                                  AR906833
      ***Midas*SE*Customer*Depot*Positions*by*Customer*Number**********                     AR906833
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG11828
      ** External DS for Switchable Feature Details                                         BUG11828
                                                                                            BUG11828
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D SecsFilFmt    E DS                  EXTNAME(SDSECSPD)
      ** Securities Clients Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
     D WRCSST          DS
     D  WRNUM                  1      6
     D  WRCHR                  7     10
      *                                                                                     AR906833
     D@UCDS2           DS           200                                                     AR906833
     D   @UD200                1    200                                                     AR906833
     D   @UD213               13     13                                                     AR906833
     D   @UD214               14     14                                                     AR906833
     D   @UD215               15     15                                                     AR906833
     D   @UD216               16     16                                                     AR906833
     D   @UD217               17     17                                                     AR906833
     D   @UD219               19     19                                                     AR906833
     D   @UD220               20     20                                                     AR906833
     D   @UD221               21     21                                                     AR906833
     D   @UD222               22     22                                                     AR906833
     D   @UD223               23     23                                                     AR906833
     D   @UD224               24     24                                                     AR906833
     D   @UD225               25     25                                                     AR906833
     D   @UD226               26     26                                                     AR906833
     D   @UD227               27     27                                                     AR906833
     D   @UD228               28     28                                                     AR906833
     D   @UD229               29     29                                                     AR906833
      *                                                                                     AR906833
     D@UCDS3           DS           200                                                     AR906833
     D   @UD400                1    200                                                     AR906833
     D   @UD401                1      1                                                     AR906833
     D   @UD402                2      2                                                     AR906833
     D   @UD403                3      3                                                     AR906833
     D   @UD404                4      4                                                     AR906833
     D   @UD405                5      5                                                     AR906833
     D   @UD406                6      6                                                     AR906833
     D   @UD407                7      7                                                     AR906833
     D   @UD408                8      8                                                     AR906833
     D   @UD409                9      9                                                     AR906833
     D   @UD410               10     10                                                     AR906833
      *                                                                                     MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @CUST           S              6                                                     AR906833
     D @0RTN           S              7                                                     AR906833
     D @QUIT           S              1                                                     AR906833
     D @ACTN           S              1                                                     AR906833
      *                                                                                     AR906833
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
     D PRetCode        S              7A                                                      CSD027
     D PSysValK1       S             20A                                                      CSD027
     D PSysVal1        S            200A                                                      CSD027
     D PSysValK2       S             20A                                                      CSD027
     D PSysVal2        S            200A                                                      CSD027
     D PSysValK3       S             20A                                                      CSD027
     D PSysVal3        S            200A                                                      CSD027
     D PSysValK4       S             20A                                                      CSD027
     D PSysVal4        S            200A                                                      CSD027
     D PSysValK5       S             20A                                                      CSD027
     D PSysVal5        S            200A                                                      CSD027
     D PSysValK6       S             20A                                                      CSD027
     D PSysVal6        S            200A                                                      CSD027
     D PSysValK7       S             20A                                                      CSD027
     D PSysVal7        S            200A                                                      CSD027
     D PSysValK8       S             20A                                                      CSD027
     D PSysVal8        S            200A                                                      CSD027
     D PSysValK9       S             20A                                                      CSD027
     D PSysVal9        S            200A                                                      CSD027
     D PSysValK10      S             20A                                                      CSD027
     D PSysVal10       S            200A                                                      CSD027
      *                                                                                       CSD027
      * For holding the system values                                                         CSD027
     DWCusAlphaAllow   S            200A                                                      CSD027
     DWCusAlphaSupNum  S            200A                                                      CSD027
      *                                                                                       CSD027
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
     D PCust           S              6A                                                      CSD027
     D PValid          S              6A                                                      CSD027
     D PCheckDigit     S              1A                                                      CSD027
                                                                                            BUG11828
      ** Access Object Parameters                                                           BUG11828
     D PRtcd           S              7A                                                    BUG11828
     D POptn           S              7A                                                    BUG11828
     D PSARD           S              6A                                                    BUG11828
                                                                                            BUG11828
      ** Switchable Features                                                                BUG11828
     D CSD031          S              1A                                                    BUG11828
      *                                                                                       260292
      ** Constant paramater for AOSVALR0                                                      260292
      *                                                                                       260292
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      260292
     D CurSysVal       DS           200                                                       260292
     D CurVal                  1      1                                                       260292
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * INITIALIZATION
      *
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE & CUSTOMER NUMBER
      *
     C                   IF        ModeofOp <> '*VU   '                                     AR875962
     C                   EXSR      VAL
     C                   ENDIF                                                              AR875962
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C     DDACTN        ANDNE     'I'
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      RTVSECD
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      RTVSECD
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      RTVSECD
     C                   EXSR      VALACD
     C                   END
      *
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKCUST        OREQ      'N'
     C                   RETURN
     C                   END
 
      * Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *                                                                                       260292
     C                   CALLB     'AOSVALR0'                                                 260292
     C                   PARM                    @RTCD             7                          260292
     C                   PARM      BRCUSR        @OP01            20                          260292
     C     CurSysVal     PARM                    @VL01           200                          260292
     C                   PARM                    @OP02            20                          260292
     C                   PARM                    @VL02           200                          260292
     C                   PARM                    @OP03            20                          260292
     C                   PARM                    @VL03           200                          260292
     C                   PARM                    @OP04            20                          260292
     C                   PARM                    @VL04           200                          260292
     C                   PARM                    @OP05            20                          260292
     C                   PARM                    @VL05           200                          260292
     C                   PARM                    @OP06            20                          260292
     C                   PARM                    @VL06           200                          260292
     C                   PARM                    @OP07            20                          260292
     C                   PARM                    @VL07           200                          260292
     C                   PARM                    @OP08            20                          260292
     C                   PARM                    @VL08           200                          260292
     C                   PARM                    @OP09            20                          260292
     C                   PARM                    @VL09           200                          260292
     C                   PARM                    @OP10            20                          260292
     C                   PARM                    @VL10           200                          260292
      *                                                                                       260292
     C                   IF        CurVal = 'Y'                                               260292
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'RE71070'     MsgIdArr(Ix)                                 256870
     C                   MOVEL     'RE71075'     MsgIdArr(Ix)                                 256870
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   END
     C                   END
     C                   ENDIF                                                                260292
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVSECD - RETRIEVE SECURITIES DETAILS IF ACTION CODE 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVSECD       BEGSR
 
      * Search by customer number
     C     DDCUSN        CHAIN     CUSTNUM                            99
 
      * Error if client not present on customer file
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0238'     MsgIdArr(Ix)
     C                   GOTO      EndRTV
     C                   ELSE
     C                   MOVEL     BBCSSN        WKCSSN
     C                   Eval      WKCRTN = BBCRTN
     C                   Eval      WKCRNM = BBCRNM
     C                   ENDIF
 
      * Access Securities Clients Details from Securities file
     C     DDCUSN        CHAIN     SECFMAT                            99
 
      * Securities clients details not found
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR4318'     MsgIdArr(Ix)
     C                   END
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'D'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS CUSTOMER WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     SDSECFOI                           99
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
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
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
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND CUSTOMER NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      * Action Code
      *  .. must be 'I','A','D' or 'E'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDA0001'     MsgIdArr(Ix)
     C                   GOTO      EVAL                                                       CSD027
     C                   ENDIF
 
      *
      *  Customer number or shortname required
      *
     C     DDCUSN        IFEQ      *BLANKS
     C     DDCUSN        OREQ      *ZEROS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR4319'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      *  If the Customer Number is not blank, check that it is numeric.
      *
     C                   TESTN                   DDCUSN               98
     C                   MOVE      DDCUSN        @1CUST            1
     C                   TESTZ                   @1CUST                   99
      *
      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 914                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C*****DDCUSN        IFNE      *BLANKS                                                    CSD027
     C******IN98         ANDEQ     '0'                                                        CSD027
     C*****DDCUSN        ORNE      *BLANKS                                                    CSD027
     C******IN99         ANDEQ     '0'                                                        CSD027
     C**********         MOVEL     'N'           OKCUST                                       CSD027
     C**********         ADD       1             Ix                                           CSD027
     C**********         MOVEL     'DDCUSN'      FldNameArr(Ix)                               CSD027
     C**********         MOVEL     'USR0822'     MsgIdArr(Ix)                        BUG10758 CSD027
     C**********         MOVEL     'USR4925'     MsgIdArr(Ix)                        BUG10758 CSD027
     C**********         GOTO      EVAL                                                       CSD027
     C**********         END                                                                  CSD027
      *                                                                                       CSD027
      * Check if Customer# is valid                                                           CSD027
     C                   If        DDCUSN = *BLANKS                                           CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'N' And                                  CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (DDACTN <> 'I' And                                         CSD027
     C                              WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              PValid = *BLANKS)                                         CSD027
      *                                                                                       CSD027
     C                   Else                                                                 CSD027
      * If invalid Customer#                                                                  CSD027
     C                   Eval      OKCUST = 'N'                                               CSD027
     C                   Add       1             Ix                                           CSD027
     C                   Eval      FldNameArr(Ix) = 'DDCUSN'                                  CSD027
     C                   If        WCusAlphaAllow = 'N'                                       CSD027
     C                   Eval      MsgIdArr(Ix) = 'S270003'                                   CSD027
     C                   Else                                                                 CSD027
     C                   Eval      MsgIdArr(Ix) = 'S270004'                                   CSD027
     C**********         eval      MsgDtaArr(Ix) = @Data                             249076 MD000091
     C                   EVAL      BLen = %Len(%Trim(@Data))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(@Data)                    MD000091
     C                   EndIf                                                                CSD027
     C                   Goto      EVAL                                                       CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
 
      * Access Customer details
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
                                                                                195852
     C     DDACTN        IFEQ      'I'                                          195852
     C     @RTCD         ANDNE     *BLANKS                                      195852
                                                                                195852
     C                   Z-ADD     1             WCOUNT            2 0          195852
     C     @RTCD         DOWNE     *BLANKS                                      195852
     C     WCOUNT        ANDLE     3                                            195852
                                                                                195852
      * Delay (10)                                                              195852
     C                   CALLB     'ZACDELAY'                                   195852
                                                                                195852
      * Access Customer details                                                 195852
     C                   CALLB     'AOCUSTR0'                                   195852
     C                   PARM      *BLANKS       @RTCD                          195852
     C                   PARM      '*KEY   '     @OPTN                          195852
     C                   PARM      DDCUSN        @CNUM            10            195852
     C                   PARM                    @CNST             7            195852
     C     SDCUST        PARM      SDCUST        DSSDY                          195852
                                                                                195852
     C                   ADD       1             WCOUNT                         195852
     C                   ENDDO                                                  195852
      *                                                                         195852
     C                   ENDIF                                                  195852
      *                                                                                     BUG14009
      *  When the Action is either 'Enquire' or 'Delete' and if the                         BUG14009
      *  Customer status is 'Closed' the 'Not Record Found' condition                       BUG14009
      *  was supressed since it is required to retrieve the details                         BUG14009
      *  from the database file if the Customer either has to be                            BUG14009
      *  'Released' or 'Deleted'.                                                           BUG14009
      *                                                                                     BUG14009
     C                   IF        DDACTN = 'E' OR                                          BUG14009
     C                             DDACTN = 'D'                                             BUG14009
      *                                                                                     BUG14009
     C     DDCUSN        CHAIN     SDCUSTL0                                                 BUG14009
      *                                                                                     BUG14009
     C                   IF        %FOUND(SDCUSTL0) AND                                     BUG14009
     C                             BBCLST = 'Y'                                             BUG14009
     C                   EVAL      @RTCD = *BLANKS                                          BUG14009
     C                   ENDIF                                                              BUG14009
      *                                                                                     BUG14009
     C                   ENDIF                                                              BUG14009
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C     BBDTDL        ORNE      *ZERO
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0238'     MsgIdArr(Ix)
     C                   END
      * Customer cannot be parent
     C     BBPAIN        IFEQ      'P'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0250'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
 
      *  If the Customer shortname entered
     C     WRCHR         IFNE      *BLANKS
      * Search customer file by shortname
     C     DDCSST        CHAIN     CUSTSNAME                          99
      ** If found
     C     *IN99         IFEQ      '1'
 
     C*****DDCUSN        OREQ      *ZEROS                                                     CSD027
     C     DDCUSN        OREQ      *BLANKS                                                    CSD027
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR4319'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ELSE
     C                   MOVEL     BBCUST        DDCUSN
     C                   END
     C                   END
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      * Search customer file by shortname
     C     DDCSST        CHAIN     CUSTSNAME                          99
 
      ** If found
     C     *IN99         IFEQ      '0'
 
      ** Search securities clients file by customer number
     C     BBCUST        CHAIN     SECFMAT                            99
 
      ** Error if present already
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
 
     C                   ELSE
     C                   Eval      DDCUSN = BBCUST
     C                   Eval      WKCSSN = BBCSSN
     C                   Eval      WKCRTN = BBCRTN
     C                   Eval      WKCRNM = BBCRNM
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF
 
      ** Not valid shortname, invalid customer number if > 6 digit length
     C                   IF        ModeofOp <> '*VU   '                                     AR875962
     C                   MOVE      DDCSST        WKLast4           4
     C                   IF        WKLast4 <> *BLANKS
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR4320'     MsgIdArr(Ix)
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF                                                              AR875962
 
      ** Otherwise, search customer file by customer number
     C     DDCUSN        CHAIN     CUSTNUM                            99
 
      ** If found
     C     *IN99         IFEQ      '0'
      *
      ** Search securities clients file by customer number
     C     DDCUSN        CHAIN     SECFMAT                            99
 
      ** Error if present already
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
 
      ** Not already on securities - OK
     C                   ELSE
     C                   Eval      WKCSSN = BBCSSN
     C                   Eval      WKCRTN = BBCRTN
     C                   Eval      WKCRNM = BBCRNM
     C                   END
 
      ** Not found on customer file - error
     C                   ELSE
     C                   IF        ModeofOp <> '*VU   '                                     AR875962
     C                   MOVEL     'N'           OKCUST
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUSN'      FldNameArr(Ix)
     C                   MOVEL     'USR4320'     MsgIdArr(Ix)
     C                   ENDIF                                                              AR875962
     C                   ENDIF
 
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      ***If*position*present,*delete*not*allowed***********************                     AR906833
 
     C*****ModeofOp      IFEQ      '*FRONT'                                          209762 AR906833
     C**********         MOVE      BFCUST        WKCUST            6 0                        CSD027
     C**********         MOVE      BFCUST        WKCUST            6                 CSD027 AR906833
     C**********         ELSE                                                        209762 AR906833
     C**********         MOVE      DDCUSN        WKCUST                              209762 AR906833
     C**********         END                                                         209762 AR906833
     C*****WKCUST        CHAIN     CDEPC                              99                    AR906833
     C**********         IF        *IN99 = '0'                                              AR906833
     C**********         MOVEL     'N'           OKACTN                                     AR906833
     C**********         ADD       1             Ix                                         AR906833
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C**********         MOVEL     'USR1515'     MsgIdArr(Ix)                               AR906833
     C**********         ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        ModeofOp = '*FRONT'                                      AR906833
     C                   EVAL      @CUST = BFCUST                                           AR906833
     C                   ELSE                                                               AR906833
     C                   EVAL      @CUST = DDCUSN                                           AR906833
     C                   ENDIF                                                              AR906833
 
     C                   CALL(E)   'SD0340U'                                                AR906833
     C                   PARM                    @CUST                                      AR906833
     C     @0RTN         PARM      *BLANK        @0RTN                                      AR906833
     C     @UCDS2        PARM      *BLANK        @UD200                                     AR906833
     C     @UCDS3        PARM      *BLANK        @UD400                                     AR906833
     C                   PARM      'N'           @QUIT                                      AR906833
     C                   PARM      'C'           @ACTN                                      AR906833
      *                                                                                     AR906833
     C                   IF        %ERROR                                                   AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'Y2U0032'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @0RTN = 'REJECT'                                         AR906833
      *                                                                                     AR906833
     C                   IF        @UD213 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR1515'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD214 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR4068'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD215 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR4068'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD216 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2227'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD217 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2227'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD220 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR4067'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD221 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR4067'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD222 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR4067'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD223 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2230'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD224 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2231'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD225 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2077'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD226 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2232'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD227 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2233'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD228 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2233'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   IF        @UD229 = 'F'                                             AR906833
     C                   MOVEL     'N'           OKACTN                                     AR906833
     C                   ADD       1             Ix                                         AR906833
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             AR906833
     C                   MOVEL     'USR2235'     MsgIdArr(Ix)                               AR906833
     C                   GOTO      EVALAD                                                   AR906833
     C                   ENDIF                                                              AR906833
      *                                                                                     AR906833
     C                   ENDIF                                                              AR906833
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      * CLEAR OUTPUTS
     C                   CLEAR                   SecsFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKCUST
 
     C                   Eval      DepotNo(1) = BVDR1                                        BUG3122
     C                   Eval      DepotNo(2) = BVDR2                                        BUG3122
     C                   Eval      DepotNo(3) = BVDR3                                        BUG3122
     C                   Eval      DepotNo(4) = BVDR4                                        BUG3122
     C                   Eval      DepotNo(5) = BVDR5                                        BUG3122
     C                   Eval      DepotNo(6) = BVDR6                                        BUG3122
     C                   Eval      DepotNo(7) = BVDR7                                        BUG3122
     C                   Eval      DepotNo(8) = BVDR8                                        BUG3122
     C                   Eval      DepotNo(9) = BVDR9                                        BUG3122
     C                   Eval      DepotNo(10) = BVDR10                                      BUG3122
                                                                                             BUG3122
      ** Get customer shortnames for each depot                                              BUG3122
                                                                                             BUG3122
     C                   Z-ADD     0             I                 2 0                       BUG3122
     C                   DO        10            I                                           BUG3122
     C                   IF        BVDR1 <> *BLANKS                                          BUG3122
     C     DepotNo(I)    CHAIN     CUSTNUM                            99                     BUG3122
     C                   IF        *IN99 = '0'                                               BUG3122
     C                   EVAL      DepotSn(I) = BBCSSN                                       BUG3122
     C                   ENDIF                                                               BUG3122
     C                   ENDIF                                                               BUG3122
     C                   ENDDO                                                               BUG3122
                                                                                             BUG3122
     C                   IF        DDCSST<> *BLANKS                                          BUG3122
     C                   MOVEL     DDCSST        WRCSST                                      BUG3122
     C                   IF        DDCUSN=*BLANKS                                            BUG3122
     C                   MOVEL     WRNUM         DDCUSN                                      BUG3122
     C                   END                                                                 BUG3122
     C                   END                                                                 BUG3122
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
      * (Midas) Customer number
     C                   PARM                    DDCUSN            6
      *
      * Key Screen customer number / shortname entry
     C                   PARM                    DDCSST           10
      *
      * OUTPUTS
      *
      * Securities Clients Details in File Format
     C                   PARM                    SecsFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCUST            1
      *
      ** Customer Shortname
     C                   PARM                    WKCSSN           10
 
      ** Customer Report Name
     C                   PARM                    WKCRNM           20
 
      ** Customer Report Town
     C                   PARM                    WKCRTN           10
 
      ** Depot Shortnames Array
     C                   PARM                    DepotSn
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Parameter list for calling AOSVALR0                                                  CSD027
     C     P_AOSVALR0    PList                                                                CSD027
      * Return Code (Output)                                                                  CSD027
     C                   Parm                    PRetCode                                     CSD027
      * System Value to be retrieved (Input)                                                  CSD027
     C                   Parm                    PSysValK1                                    CSD027
      * Value returned (Output)                                                               CSD027
     C                   Parm                    PSysVal1                                     CSD027
     C                   Parm                    PSysValK2                                    CSD027
     C                   Parm                    PSysVal2                                     CSD027
     C                   Parm                    PSysValK3                                    CSD027
     C                   Parm                    PSysVal3                                     CSD027
     C                   Parm                    PSysValK4                                    CSD027
     C                   Parm                    PSysVal4                                     CSD027
     C                   Parm                    PSysValK5                                    CSD027
     C                   Parm                    PSysVal5                                     CSD027
     C                   Parm                    PSysValK6                                    CSD027
     C                   Parm                    PSysVal6                                     CSD027
     C                   Parm                    PSysValK7                                    CSD027
     C                   Parm                    PSysVal7                                     CSD027
     C                   Parm                    PSysValK8                                    CSD027
     C                   Parm                    PSysVal8                                     CSD027
     C                   Parm                    PSysValK9                                    CSD027
     C                   Parm                    PSysVal9                                     CSD027
     C                   Parm                    PSysValK10                                   CSD027
     C                   Parm                    PSysVal10                                    CSD027
      *                                                                                       CSD027
      ** Parameter list for calling SDCUSTISO                                                 CSD027
     C     P_SDCUSTISO   PList                                                                CSD027
      ** Customer Number (Input)                                                              CSD027
     C                   Parm                    PCust                                        CSD027
      ** Validity Flags (Output)                                                              CSD027
     C                   Parm                    PValid                                       CSD027
      ** Check Digit (Output)                                                                 CSD027
     C                   Parm                    PCheckDigit                                  CSD027
     C                   Parm                    @Data             2                          249076
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSECDRTV'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      *
      ** Access Securities Clients Details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                            BUG11828
      ** Check if CSD031 is on.                                                             BUG11828
                                                                                            BUG11828
     C                   CALL      'AOSARDR0'                                               BUG11828
     C                   PARM      *BLANKS       PRtCd                                      BUG11828
     C                   PARM      '*VERIFY'     POptn                                      BUG11828
     C                   PARM      'CSD031'      PSARD                                      BUG11828
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd = *BLANKS                                          BUG11828
     C                   EVAL      CSD031 = 'Y'                                             BUG11828
     C                   ELSE                                                               BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd <> '*NRF   '                                       BUG11828
     C     *LOCK         IN        LDA                                                      BUG11828
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11828
     C                   EVAL      DBKey = POptn                                            BUG11828
     C                   EVAL      DBase = 101                                              BUG11828
     C                   OUT       LDA                                                      BUG11828
     C                   EXSR      *PSSR                                                    BUG11828
     C                   ENDIF                                                              BUG11828
                                                                                            BUG11828
     C                   ENDIF                                                              BUG11828
 
     C**********         Eval      DepotNo(1) = BVDR1                                        BUG3122
     C**********         Eval      DepotNo(2) = BVDR2                                        BUG3122
     C**********         Eval      DepotNo(3) = BVDR3                                        BUG3122
     C**********         Eval      DepotNo(4) = BVDR4                                        BUG3122
     C**********         Eval      DepotNo(5) = BVDR5                                        BUG3122
     C**********         Eval      DepotNo(6) = BVDR6                                        BUG3122
     C**********         Eval      DepotNo(7) = BVDR7                                        BUG3122
     C**********         Eval      DepotNo(8) = BVDR8                                        BUG3122
     C**********         Eval      DepotNo(9) = BVDR9                                        BUG3122
     C**********         Eval      DepotNo(10) = BVDR10                                      BUG3122
      *****************************************************************                      BUG3122
      ***Get*customer*shortnames*for*each*depot************************                      BUG3122
      *****************************************************************                      BUG3122
     C**********         Z-ADD     0             I                 2 0                       BUG3122
     C**********         DO        10            I                                           BUG3122
     C**********         IF        BVDR1 <> *BLANKS                                          BUG3122
     C*****DepotNo(I)    CHAIN     CUSTNUM                            99                     BUG3122
     C**********         IF        *IN99 = '0'                                               BUG3122
     C**********         EVAL      DepotSn(I) = BBCSSN                                       BUG3122
     C**********         ENDIF                                                               BUG3122
     C**********         ENDIF                                                               BUG3122
     C**********         ENDDO                                                               BUG3122
      *****************************************************************                      BUG3122
     C**********         IF        DDCSST<> *BLANKS                                          BUG3122
     C**********         MOVEL     DDCSST        WRCSST                                      BUG3122
     C**********         IF        DDCUSN=*BLANKS                                            BUG3122
     C**********         MOVEL     WRNUM         DDCUSN                                      BUG3122
     C**********         END                                                                 BUG3122
     C**********         END                                                                 BUG3122
 
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric'                        CSD027
     C                   Eval      PRetCode = *BLANKS                                         CSD027
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
     C                   Eval      PSysValK2 = 'CustAlphaSupNumeric'                          CSD027
     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
                                                                                            BUG11828
     C                   IF        CSD031 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *                                                                                       CSD027
      * If Error retrieving the System value                                                  CSD027
     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
     C                   Eval      DBASE = 913                                                CSD027
     C                   Eval      DBKEY = 'CustAlpha(Allow/SupNumeric)'                      CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
     C                   Eval      WCusAlphaSupNum = PSysVal2                                 CSD027
 
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
(c) Misys International Banking Systems Ltd. 2001
