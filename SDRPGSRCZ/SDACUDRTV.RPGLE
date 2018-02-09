     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Retrieve')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUDRTV - Additional Customer Details Retrieve             *
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and customer number.                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26917A          Date 27Jan10               *
      *                 BUG26917           Date 20Jan10               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22174           Date 13Jan09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260292             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 06Jul07               *
      *                 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11936           Date 21Aug06               *
      *                 BUG11879           Date 10Aug06               *
      *                 CSD027A            Date 03May06               *
      *                 BUG10069           Date 25Jan06               *
      *                 CSD029             Date 22Aug05               *
      *                 234613             Date 12Jul05               *
      *                 233468             Date 12May05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26917A - Reverse fix for bug26917                         *
      *  BUG26917 - COB error when customer is declared as taxable    *
      *           w/ German features installed and no additional      *
      *           customers information is set up                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22174 - Database error if Customer is already deleted     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  260292 - Create new system values to check the branch/user   *
      *           authority.                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG11936 - Error message displayed when trying to select     *
      *             customer                                          *
      *  BUG11879 - During validation of customer number, take        *
      *             into account if CSD027 feature is enabled.        *
      *             Retrieve system value CustAlphaAllow etc.         *
      *             Pattern fix after coding in SDCUSDRTV.            *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  CSD029 - Customer Details Additional Fields (Recompile)      *
      *  234613 - The action code delete is not working               *
      *  233468 - F9 key on Additional Customer Details Maintenance.  *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Additional Customer Details Retrieval
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Details Retrieval
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
                                                                                            BUG10069
      ** Transaction File by Front Office Id
     FSDCUSDL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTD0:SDCUSTFOID)
 
      ** Transaction File by Customer Shortname
     FSDCUSTL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@CUSTF3:SDCUSTCSSN)
 
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
 
      ** Depot shortnames array
     D DepotSn         S             10    DIM(10)
 
      ** Depot customer numbers array
     D DepotNo         S              6    DIM(10)
 
      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Switchable Feature Details                                         BUG10069
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG10069
                                                                                            BUG10069
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for Securities ICD Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** External DS for Custoter Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Transaction Details in File Format
     D TranFilFmt    E DS                  EXTNAME(SDACUSPD)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for *Entry
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D FOTRID          S             20A
     D DDCUST          S              6A
     D PSDACUDENQ      S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
 
     ** Parameter for Access Objects
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey1           S             10A
     D PKySt           S              7A
     D PSARD           S              6A                                                    BUG10069
     D POP01           S             20A                                                    BUG10069
     D PVL01           S            200A                                                    BUG10069
     D POP02           S             20A                                                    BUG10069
     D PVL02           S            200A                                                    BUG10069
     D POP03           S             20A                                                    BUG10069
     D PVL03           S            200A                                                    BUG10069
     D POP04           S             20A                                                    BUG10069
     D PVL04           S            200A                                                    BUG10069
     D POP05           S             20A                                                    BUG10069
     D PVL05           S            200A                                                    BUG10069
     D POP06           S             20A                                                    BUG10069
     D PVL06           S            200A                                                    BUG10069
     D POP07           S             20A                                                    BUG10069
     D PVL07           S            200A                                                    BUG10069
     D POP08           S             20A                                                    BUG10069
     D PVL08           S            200A                                                    BUG10069
     D POP09           S             20A                                                    BUG10069
     D PVL09           S            200A                                                    BUG10069
     D POP10           S             20A                                                    BUG10069
     D PVL10           S            200A                                                    BUG10069
 
     ** Parameter for ZVACTBU
     D ZACTN           S              1A
     D ZBR             S              3A
     D ERR             S              1P 0
     D
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Switchable Features                                                                BUG10069
     D CSD012          S              1A   INZ('N')                                         BUG10069
                                                                                            BUG10069
      ** Other Variables
     D SubForCUST      S              2P 0
     D @1CUST          S              1A
     D WAuthReq        S              1A   INZ('N')                                         BUG10069
                                                                                            BUG11879
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                 BUG11879
     D PRetCode        S              7A                                                    BUG11879
     D PSysValK1       S             20A                                                    BUG11879
     D PSysVal1        S            200A                                                    BUG11879
     D PSysValK2       S             20A                                                    BUG11879
     D PSysVal2        S            200A                                                    BUG11879
     D PSysValK3       S             20A                                                    BUG11879
     D PSysVal3        S            200A                                                    BUG11879
     D PSysValK4       S             20A                                                    BUG11879
     D PSysVal4        S            200A                                                    BUG11879
     D PSysValK5       S             20A                                                    BUG11879
     D PSysVal5        S            200A                                                    BUG11879
     D PSysValK6       S             20A                                                    BUG11879
     D PSysVal6        S            200A                                                    BUG11879
     D PSysValK7       S             20A                                                    BUG11879
     D PSysVal7        S            200A                                                    BUG11879
     D PSysValK8       S             20A                                                    BUG11879
     D PSysVal8        S            200A                                                    BUG11879
     D PSysValK9       S             20A                                                    BUG11879
     D PSysVal9        S            200A                                                    BUG11879
     D PSysValK10      S             20A                                                    BUG11879
     D PSysVal10       S            200A                                                    BUG11879
      *                                                                                     BUG11879
      * For holding the system values                                                       BUG11879
     DWCusAlphaAllow   S            200A                                                    BUG11879
     DWCusAlphChksum   S            200A                                                    BUG11879
     DWCusAlphaSupNum  S            200A                                                    BUG11879
      *                                                                                     BUG11879
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                        BUG11879
     D PCust           S              6A                                                    BUG11879
     D PValid          S              6A                                                    BUG11879
     D PCheckDigit     S              1A                                                    BUG11879
      *                                                                                       260292
      ** Constant paramater for AOSVALR0                                                      260292
      *                                                                                       260292
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                      260292
     D CurSysVal       DS           200                                                       260292
     D CurVal                  1      1                                                       260292
      *                                                                                       CER034
     D CER048          S              1A                                                      CER034
     D WIx             S              3P 0                                                    CER034
      *                                                                                       CER034
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ****************************************************************
      /EJECT
      ****************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      SRVFrnt
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code & Transaction Number
 
     C                   EXSR      SRVal
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' or
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Access Security Checking
 
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *Blanks and
     C                             RESPMODE = 'S'
     C                   EXSR      SRAcsSeS
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *Blanks and
     C                             DDACTN <> 'I' and
     C                             RESPMODE = 'S'
     C                   EXSR      SRAcsSeM
     C                   ENDIF
     C                   ENDIF
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Validation for Action Code 'I'
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SRValACI
     C                   ENDIF
 
      ** Validation for Action Code 'E'
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      SRRtvAcus
     C                   ENDIF
 
      ** Validation for Action Code 'A'
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      SRRtvAcus
     C                   ENDIF
 
      ** Validation for Action Code 'D'
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      SRRtvAcus
     C                   ENDIF
      *                                                                                     BUG23518
      ** Validation for Action Code 'C'                                                     BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C'                                             BUG23518
     C                   EXSR      SRRtvAcus                                                BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** Validation for Action Code 'R'                                                     BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'R'                                             BUG23518
     C                   EXSR      SRRtvAcus                                                BUG23518
     C                   ENDIF                                                              BUG23518
 
      **  Carry out no further validation if errors occurred
 
     C                   IF        OKACTN = 'N' or
     C                             OKCUST = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAcsSeS - Access Security Checking - Single Branching
      *****************************************************************
     C     SRAcsSeS      BEGSR
 
      **  Check user's authority for the action.
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    ERR
 
      **  If action invalid for user
 
     C                   IF        ERR = 1
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN = 'E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRAcsSeM - Access Security Checking - Multi-Branching
      *****************************************************************
     C     SRAcsSeM      BEGSR
 
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
      *                                                                                       260292
      **  Check user's authority for the action & Booking Branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      DBRN          ZBR
     C                   PARM                    ERR
 
      **   If action invalid for user
 
     C                   IF        ERR = 1
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN = 'E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='C'                                               BUG23518
     C                   MOVEL     'USR0638'     MsgIdArr(Ix)                               BUG23518
     C                   WHEN      DDACTN='R'                                               BUG23518
     C                   MOVEL     'USR0639'     MsgIdArr(Ix)                               BUG23518
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                260292
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRRtvAcus - Retrieve Transaction Details
      *             If Action Code 'A', 'E' OR 'D'
      ****************************************************************
     C     SRRtvAcus     BEGSR
 
      ** The front office can send us both Front Office ID and transaction ID;
      ** When the RTV is called in the back office the transaction ID must be valid
 
     C                   IF        (DDCUST <> *BLANK AND SubForCUST = 0)
     C                             OR ModeofOp <> '*FRONT'
     C     DDCUST        CHAIN     SDACUSL1                           99
 
      ** Transaction details not found
 
     C                   IF        *IN99 = *ON
     C                   IF        ModeofOp = '*FRONT' AND                                    232543
     C                             DDACTN = 'A'                                               232543
     C                   EVAL      DDACTN = 'I'                                               232543
     C                   ELSE                                                                 232543
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR4779'     MsgIdArr(Ix)
     C                   ENDIF                                                                232543
     C                   ENDIF
      *                                                                                     BUG23518
      ** Transaction details if found, but already Closed / Deleted                         BUG23518
      *                                                                                     BUG23518
     C                   IF        *IN99 = *OFF                                             BUG23518
      *                                                                                     BUG23518
      ** If Closure requested on an already Closed / Deleted record                         BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C'                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'C'                                             BUG23518
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR0568'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'D'                                             BUG23518
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR0342'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** If Amend requested on an already Closed / Deleted record                           BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'A'                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'C'                                             BUG23518
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR9236'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'D'                                             BUG23518
     C*****DDCUST        CHAIN     SDCUSTL1                                       BUG26917 BUG26917A
     C**********         IF        %FOUND(SDCUSTL1) AND                           BUG26917 BUG26917A
     C**********                   BBTAIN = 'Y' AND                               BUG26917 BUG26917A
     C**********                   CER048 = 'Y'                                   BUG26917 BUG26917A
     C**********         EVAL      OKACTN = 'Y'                                   BUG26917 BUG26917A
     C**********         ELSE                                                     BUG26917 BUG26917A
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR0342'     MsgIdArr(Ix)                               BUG23518
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** If Release requested on an already Active record                                   BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'R'                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC <> 'C'                                            BUG23518
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR0569'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   EVAL      PKey1 = DDCUST                                           BUG23518
     C                   CALL      'AOCUSTR0'                                               BUG23518
     C                   PARM      *BLANKS       PRtcd                                      BUG23518
     C                   PARM      '*KEY   '     POptn                                      BUG23518
     C                   PARM                    PKey1                                      BUG23518
     C                   PARM                    PKySt                                      BUG23518
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23518
                                                                                            BUG23518
     C                   IF        PRtcd = '*CUSDEL'                                        BUG23518
     C                             OR PRtcd = '*NRF'                                        BUG23518
     C                   EVAL      OKCUST = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR9474'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      ** If Delete requested on an already Deleted Record                                   BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'D'                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        E5TYLC = 'D'                                             BUG23518
     C                   EVAL      OKACTN = 'N'                                             BUG23518
     C                   ADD       1             Ix                                         BUG23518
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                             BUG23518
     C                   MOVEL     'USR7536'     MsgIdArr(Ix)                               BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
      *                                                                                     BUG23518
      ***If*Delete*requested*on*an*Active*Taxable*Record*                         BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        DDACTN = 'D' AND                               BUG26917 BUG26917A
     C**********                   CER048 = 'Y'                                   BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         IF        E5TYLC <> 'D' OR                               BUG26917 BUG26917A
     C**********                   E5TYLC <> 'C'                                  BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C*****DDCUST        CHAIN     SDCUSTL1                                       BUG26917 BUG26917A
     C**********         IF        %FOUND(SDCUSTL1) AND                           BUG26917 BUG26917A
     C**********                   BBTAIN = 'Y'                                   BUG26917 BUG26917A
     C**********         EVAL      OKACTN = 'N'                                   BUG26917 BUG26917A
     C**********         ADD       1             Ix                               BUG26917 BUG26917A
     C**********         MOVEL     'DDACTN'      FldNameArr(Ix)                   BUG26917 BUG26917A
     C**********         MOVEL     'USR4824'     MsgIdArr(Ix)                     BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
      **********                                                                  BUG26917 BUG26917A
     C**********         ENDIF                                                    BUG26917 BUG26917A
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVFrnt - Validation For Front Office Transaction Interface
      *****************************************************************
     C     SRVFrnt       BEGSR
 
      ** Error if Action Code is not 'I','A','E' OR 'D'
 
     C                   IF        DDACTN <> 'I' and
     C                             DDACTN <> 'A' and
     C                             DDACTN <> 'E' and
     C**********                   DDACTN <> 'D'                                            BUG23518
     C                             DDACTN <> 'C' AND                                        BUG23518
     C                             DDACTN <> 'R'                                            BUG23518
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        FOTRID = *Blanks
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFrnt
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     FOTRID        CHAIN     SDCUSDL0                           99
 
      ** If Insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFrnt
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFrnt
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVFrnt        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVal - Validation of Action Code and Transaction Number
      *****************************************************************
     C     SRVal         BEGSR
 
      ** Action Code
      **  .. must be 'A' or 'E'
 
     C                   SELECT
 
rgc   ** Action Code must be 'A' or 'E'.
 
     C                   WHEN      PSDACUDENQ = *Blanks and DDACTN <> 'A' and
     C**********                   DDACTN <> 'E' and DDACTN <> 'I'                          234613
     C                             DDACTN <> 'E' and DDACTN <> 'I' and                      234613
     C**********                   DDACTN <> 'D'                                     234613 BUG23518
     C                             DDACTN <> 'D' AND DDACTN <> 'C' AND                      BUG23518
     C                             DDACTN <> 'R'                                            BUG23518
rgc  C                   EVAL      OKACTN = 'N'
rgc  C                   ADD       1             Ix
rgc  C                   MOVEL     'DDACTN'      FldNameArr(Ix)
rgc  C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   GOTO      EVal
     C                   ENDSL
rgc
      **  Transaction number required
 
     C                   IF        DDCUST = *Blanks or
     C                             DDCUST = *Zeros
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR4312'     MsgIdArr(Ix)
     C                   GOTO      EVal
     C                   ENDIF
 
      **  If the Transaction Number is not blank, check that it is numeric.
 
     C                   TESTN                   DDCUST               98
     C                   MOVE      DDCUST        @1CUST
     C                   TESTZ                   @1CUST                   99
      *                                                                                     BUG11936
      ** Skip calling SDCUSTISO module when DDCUST = '?'                                    BUG11936
      *                                                                                     BUG11936
     C                   If        DDCUST <> '?'                                            BUG11936
                                                                                            BUG11879
      ** If Alphanumeric Customer Numbers are enabled                                       BUG11879
     C                   If        WCusAlphaAllow = 'Y'                                     BUG11879
     C                   Eval      PCust = DDCUST                                           BUG11879
     C                   Eval      PValid = *BLANKS                                         BUG11879
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                BUG11879
      * If Error                                                                            BUG11879
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                  BUG11879
     C                   Eval      DBFILE = 'SDCUSTISO'                                     BUG11879
     C                   Eval      DBASE = 913                                              BUG11879
     C                   Eval      DBKEY = PCust                                            BUG11879
     C                   ExSr      *PSSR                                                    BUG11879
     C                   EndIf                                                              BUG11879
      *                                                                                     BUG11879
     C                   EndIf                                                              BUG11879
      *                                                                                     BUG11879
     C*******************IF        DDCUST <> *Blanks and                                    BUG11879
     C*******************          *IN98 = *OFF or                                          BUG11879
     C*******************          DDCUST <> *Blanks and                                    BUG11879
     C*******************          *IN99 = *OFF                                             BUG11879
     C*******************EVAL      OKCUST = 'N'                                             BUG11879
     C*******************ADD       1             Ix                                         BUG11879
     C*******************MOVEL     'DDCUST'      FldNameArr(Ix)                             BUG11879
     C*******************MOVEL     'USR0822'     MsgIdArr(Ix)                               BUG11879
     C*******************GOTO      Eval                                                     BUG11879
     C*******************ENDIF                                                              BUG11879
      *                                                                                     BUG11879
      * Check if Customer# is valid                                                         BUG11879
     C                   If        (WCusAlphaAllow = 'N' And                                BUG11879
     C                              *IN98 = *ON And *IN99 = *ON)                            BUG11879
     C                             Or                                                       BUG11879
     C                             (DDACTN <> 'I' And                                       BUG11879
     C                              WCusAlphaAllow = 'Y' And                                BUG11879
     C                              WCusAlphaSupNum = 'Y' And                               BUG11879
     C                              *IN98 = *ON And *IN99 = *ON)                            BUG11879
     C                             Or                                                       BUG11879
     C                             (WCusAlphaAllow = 'Y' And                                BUG11879
     C                              PValid = *BLANKS)                                       BUG11879
      *                                                                                     BUG11879
     C                   Else                                                               BUG11879
      * If invalid Customer#                                                                BUG11879
     C                   Eval      OKCUST = 'N'                                             BUG11879
     C                   Add       1             Ix                                         BUG11879
     C                   Eval      FldNameArr(Ix) = 'DDCUST'                                BUG11879
     C                   If        WCusAlphaAllow = 'N'                                     BUG11879
     C                   Eval      MsgIdArr(Ix) = 'S270003'                                 BUG11879
     C                   Else                                                               BUG11879
     C                   Eval      MsgIdArr(Ix) = 'S270004'                                 BUG11879
     C                   add       1             Ix                                           249076
     C                   eval      MsgDtaArr(Ix) = @Data                                      249076
     C                   EndIf                                                              BUG11879
     C                   Goto      EVAL                                                     BUG11879
      *                                                                                     BUG11879
     C                   EndIf                                                              BUG11879
     C                   EndIf                                                              BUG11936
 
      ** Check if record still existing and valid (not closed or deleted)
 
     C                   IF        DDACTN = 'A'
     C                             OR (DDACTN = 'I' AND DDCUST <> *BLANKS)                    233468
     C                   EVAL      PKey1 = DDCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
      *                                                                                     BUG11936
      **  Move Customer that was selected on SD0010S to DDCUST                              BUG11936
      *                                                                                     BUG11936
     C                   If        BBCUST <> *Blanks                                        BUG11936
     C                   Eval      DDCUST = BBCUST                                          BUG11936
     C                   Else                                                               BUG11936
     C                   Eval      OKCUST = 'N'                                             BUG11936
     C                   Eval      Ix = Ix + 1                                              BUG11936
     C                   Eval      FldNameArr(Ix) = 'DDCUST'                                BUG11936
     C                   Eval      MsgIdArr(Ix) = 'USR4312'                                 BUG11936
     C                   Goto      Eval                                                     BUG11936
     C                   EndIf                                                              BUG11936
      *                                                                                     BUG11936
     C                   IF        PRTCD = '*NRF   '
     C                             OR PRTCD = '*CUSDEL'                                     BUG22174
                                                                                            BUG10069
     C                   IF        CSD012 = 'Y' AND                                         BUG10069
     C                             WAuthReq = 'Y'                                           BUG10069
                                                                                            BUG10069
      ** Check the shadow file.                                                             BUG10069
                                                                                            BUG10069
     C     DDCUST        CHAIN     SDCDSHL1                                                 BUG10069
                                                                                            BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C                   EVAL      OKCUST = 'N'                                             BUG10069
     C                   ADD       1             Ix                                         BUG10069
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)                             BUG10069
     C                   MOVEL     'SDM0113'     MsgIdArr(Ix)                               BUG10069
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   LEAVESR                                                            BUG10069
                                                                                            BUG10069
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR4778'     MsgIdArr(Ix)
     C                   GOTO      EVal
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER034
     C**********         IF        CER048 = 'Y' AND DDACTN = 'D'                     CER034 BUG23518
     C**********         EXSR      SRChkSts                                          CER034 BUG23518
     C**********         ENDIF                                                       CER034 BUG23518
 
     C     EVal          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValACI - Validation of Action Code 'I'
      *****************************************************************
     C     SRValACI      BEGSR
 
      ** Access Transaction from the Transactions file
 
     C     DDCUST        CHAIN     SDACUSL1                           44
 
      ** Error if present already
 
     C                   IF        *IN44 = *OFF
     C                   IF        ModeofOp = '*FRONT'                                        232543
     C                   EVAL      DDACTN = 'A'                                               232543
     C                   ELSE                                                                 232543
     C                   EVAL      OKCUST = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDCUST'      FldNameArr(Ix)
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)
     C                   ENDIF                                                                232543
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *****************************************************************              CER034 BUG23518
      ***SRChkSts*-*Check*if*Customer*is*Taxable*when*Action*is*Delete*              CER034 BUG23518
      *****************************************************************              CER034 BUG23518
      ***Called*By:*SRVal**********************************************              CER034 BUG23518
      *****************************************************************              CER034 BUG23518
      ***Calls:*None***************************************************              CER034 BUG23518
      *****************************************************************              CER034 BUG23518
      *****************************************************************              CER034 BUG23518
     C*****SRChkSts      BEGSR                                                       CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         EVAL      PKey1 = DDCUST                                    CER034 BUG23518
      **********                                                                     CER034 BUG23518
      ***Retrieve*Taxable*Flag*value*from*Customer*Details                           CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         CALLB     'AOCUSTR0'                                        CER034 BUG23518
     C**********         PARM      *Blanks       PRtcd                               CER034 BUG23518
     C**********         PARM      '*KEY   '     POptn                               CER034 BUG23518
     C**********         PARM                    PKey1                               CER034 BUG23518
     C**********         PARM                    PKySt                               CER034 BUG23518
     C*****SDCUST        PARM      SDCUST        DSSDY                               CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         IF        PRTCD <> *BLANKS                                  CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         EVAL      DBFILE = 'SDCUSTPD'                               CER034 BUG23518
     C**********         EVAL      DBASE  =  901                                     CER034 BUG23518
     C**********         EVAL      DBKEY  =  POptn                                   CER034 BUG23518
     C**********         EXSR      *PSSR                                             CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         ENDIF                                                       CER034 BUG23518
      **********                                                                     CER034 BUG23518
      ***If*Customer*is*Taxable,*display*warning                                     CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         IF        PRTCD  = *BLANKS                                  CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         IF        BBTAIN = 'Y'                                      CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         EVAL      OKCUST = 'W'                                      CER034 BUG23518
     C**********         EVAL      WIx = WIx + 1                                     CER034 BUG23518
     C**********         EVAL      WFldNamArr(WIx) = 'DDCUST'                        CER034 BUG23518
     C**********         EVAL      WMsgIDArr(WIx)  = 'USR6501'                       CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         ENDIF                                                       CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         ENDIF                                                       CER034 BUG23518
      **********                                                                     CER034 BUG23518
     C**********         ENDSR                                                       CER034 BUG23518
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKCUST = 'Y'
 
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
 
     C                   IF        GHSUBS <> *Blanks
     C     GHSUBS        SCAN      DDCUST        SubForCUST
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** Action Code
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    FOTRID
 
      ** (Midas) Transaction number
     C                   PARM                    DDCUST
 
rgc   ** Value is 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
rgc  C                   PARM                    PSDACUDENQ
 
 
      ** Outputs
      ** Transaction Details in File Format
     C                   PARM                    TranFilFmt
 
      ** OK - Action code
     C                   PARM                    OKACTN
 
      ** OK - Transaction Number
     C                   PARM                    OKCUST
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
      *                                                                                       CER034
     C                   PARM                    WIx                                          CER034
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACUDRTV'
 
      **  GET RUNDAT to access MULTI-BRANCHING flag.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER034
      ** Call AOSARDR0 to check for CER048                                                    CER034
      *                                                                                       CER034
     C                   CALLB     'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtCd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER048'      PSARD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtCd = *BLANKS                                            CER034
     C                   EVAL      CER048 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      CER048 = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   IF        PRtCd <> '*NRF' and                                        CER034
     C                             PRtCd <> *BLANKS                                           CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKey = 'CER048'                                           CER034
     C                   EVAL      DBase = 008                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
                                                                                            BUG10069
      ** Check if CSD012 is enabled.                                                        BUG10069
                                                                                            BUG10069
     C                   CALLB     'AOSARDR0'                                               BUG10069
     C                   PARM      *BLANKS       PRtCd                                      BUG10069
     C                   PARM      '*VERIFY'     POptn                                      BUG10069
     C                   PARM      'CSD012'      PSARD                                      BUG10069
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10069
                                                                                            BUG10069
     C                   IF        PRtCd = *BLANKS                                          BUG10069
     C                   EVAL      CSD012 = 'Y'                                             BUG10069
     C                   ELSE                                                               BUG10069
                                                                                            BUG10069
     C                   IF        PRtCd <> '*NRF   '                                       BUG10069
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG10069
     C                   EVAL      DBKey = POptn                                            BUG10069
     C                   EVAL      DBase = 101                                              BUG10069
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      *PSSR                                                    BUG10069
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
      ** Check System Values.                                                               BUG10069
                                                                                            BUG10069
     C                   EVAL      POP01 ='AuthReqCustomerMaint'                            BUG10069
                                                                                            BUG10069
     C                   CALL      'AOSVALR0'                                               BUG10069
     C                   PARM      *BLANKS       PRtCd                                      BUG10069
     C                   PARM                    POP01                                      BUG10069
     C                   PARM                    PVL01                                      BUG10069
     C                   PARM                    POP02                                      BUG10069
     C                   PARM                    PVL02                                      BUG10069
     C                   PARM                    POP03                                      BUG10069
     C                   PARM                    PVL03                                      BUG10069
     C                   PARM                    POP04                                      BUG10069
     C                   PARM                    PVL04                                      BUG10069
     C                   PARM                    POP05                                      BUG10069
     C                   PARM                    PVL05                                      BUG10069
     C                   PARM                    POP06                                      BUG10069
     C                   PARM                    PVL06                                      BUG10069
     C                   PARM                    POP07                                      BUG10069
     C                   PARM                    PVL07                                      BUG10069
     C                   PARM                    POP08                                      BUG10069
     C                   PARM                    PVL08                                      BUG10069
     C                   PARM                    POP09                                      BUG10069
     C                   PARM                    PVL09                                      BUG10069
     C                   PARM                    POP10                                      BUG10069
     C                   PARM                    PVL10                                      BUG10069
                                                                                            BUG10069
     C                   IF        PRtCd = *BLANKS                                          BUG10069
                                                                                            BUG10069
     C                   MOVEL     PVL01         WAuthReq                                   BUG10069
                                                                                            BUG10069
     C                   ELSE                                                               BUG10069
                                                                                            BUG10069
     C                   SELECT                                                             BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL01 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP01                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL02 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP02                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL03 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP03                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL04 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP04                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL05 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP05                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL06 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP06                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL07 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP07                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL08 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP08                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL09 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP09                                            BUG10069
                                                                                            BUG10069
     C                   WHEN      PVL10 = '*NRF'                                           BUG10069
     C                   EVAL      DBKey = POP10                                            BUG10069
                                                                                            BUG10069
     C                   ENDSL                                                              BUG10069
                                                                                            BUG10069
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFile = 'SDSVALPD'                                      BUG10069
     C                   EVAL      DBase = 102                                              BUG10069
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      *PSSR                                                    BUG10069
                                                                                            BUG10069
     C                   ENDIF                                                              BUG10069
      ** Parameter list for calling AOSVALR0                                                BUG11879
     C     P_AOSVALR0    PList                                                              BUG11879
      * Return Code (Output)                                                                BUG11879
     C                   Parm                    PRetCode                                   BUG11879
      * System Value to be retrieved (Input)                                                BUG11879
     C                   Parm                    PSysValK1                                  BUG11879
      * Value returned (Output)                                                             BUG11879
     C                   Parm                    PSysVal1                                   BUG11879
     C                   Parm                    PSysValK2                                  BUG11879
     C                   Parm                    PSysVal2                                   BUG11879
     C                   Parm                    PSysValK3                                  BUG11879
     C                   Parm                    PSysVal3                                   BUG11879
     C                   Parm                    PSysValK4                                  BUG11879
     C                   Parm                    PSysVal4                                   BUG11879
     C                   Parm                    PSysValK5                                  BUG11879
     C                   Parm                    PSysVal5                                   BUG11879
     C                   Parm                    PSysValK6                                  BUG11879
     C                   Parm                    PSysVal6                                   BUG11879
     C                   Parm                    PSysValK7                                  BUG11879
     C                   Parm                    PSysVal7                                   BUG11879
     C                   Parm                    PSysValK8                                  BUG11879
     C                   Parm                    PSysVal8                                   BUG11879
     C                   Parm                    PSysValK9                                  BUG11879
     C                   Parm                    PSysVal9                                   BUG11879
     C                   Parm                    PSysValK10                                 BUG11879
     C                   Parm                    PSysVal10                                  BUG11879
      *                                                                                     BUG11879
      ** Parameter list for calling SDCUSTISO                                               BUG11879
     C     P_SDCUSTISO   PList                                                              BUG11879
      ** Customer Number (Input)                                                            BUG11879
     C                   Parm                    PCust                                      BUG11879
      ** Validity Flags (Output)                                                            BUG11879
     C                   Parm                    PValid                                     BUG11879
      ** Check Digit (Output)                                                               BUG11879
     C                   Parm                    PCheckDigit                                BUG11879
     C                   Parm                    @Data             2                          249076
      *                                                                                     BUG11879
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric' &                    BUG11879
      *                       'CustAlphaChecksum'                                           BUG11879
      *                                                                                     BUG11879
     C                   Eval      PRetCode = *BLANKS                                       BUG11879
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                             BUG11879
     C                   Eval      PSysVal1 = *BLANKS                                       BUG11879
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'                          BUG11879
     C                   Eval      PSysVal2 = *BLANKS                                       BUG11879
     C                   Eval      PSysValK3 = 'CustAlphaSupNumeric'                        BUG11879
     C                   Eval      PSysVal3 = *BLANKS                                       BUG11879
     C                   CallB(E)  'AOSVALR0'    P_AOSVALR0                                 BUG11879
      *                                                                                     BUG11879
      * If Error retrieving the System value                                                BUG11879
     C                   If        %Error Or PRetCode <> *BLANKS                            BUG11879
     C                             Or (*INU7 = *ON And *INU8 = *ON)                         BUG11879
     C                   Eval      DBFILE = 'SDSVALPD'                                      BUG11879
     C                   Eval      DBASE = 914                                              BUG11879
     C                   Eval      DBKEY = 'CustAlpha(Allow/Chk/SupNum)'                    BUG11879
     C                   ExSr      *PSSR                                                    BUG11879
     C                   EndIf                                                              BUG11879
      *                                                                                     BUG11879
     C                   Eval      WCusAlphaAllow  = PSysVal1                               BUG11879
     C                   Eval      WCusAlphChksum  = PSysVal2                               BUG11879
     C                   Eval      WCusAlphaSupNum = PSysVal3                               BUG11879
      *                                                                                     BUG11879
 
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
** CTDATA CPY@
(c) Finastra International Limited 2004
