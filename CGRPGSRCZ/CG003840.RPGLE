     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for LE - Driver')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003840 - Midas CG Retail Advice for LE - Driver            *
      *                                                               *
      *  Function:  This program drives the Retail Advice for         *
      *             LE - Extract                                      *
      *                                                               *
      *  Called By: REC000881 in Input Cycle                          *
      *             REC000079 in Close of Business                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020  *CREATE    Date 20Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMainIC  - Controls main flow of program if called from IC  *
      *  SRMainCOB - Controls main flow of program if called from COB *
      *  SRAudit   - Calls CGZAUDIT to do auditing                    *
      *  *INZSR    - Initialise                                       *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE Settled Transaction Index File
 
     FRERSACL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Re)
      ** Midas RETAIL INTEREST & CHARGES FILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WKeySysVal1     C                   CONST('LoansPartPrchPartSld')
     D WKeySysVal2     C                   CONST('LoanAmendments      ')
     D WKeySysVal3     C                   CONST('ManualRepayments    ')
     D WKeySysVal4     C                   CONST('RepaymentSchedules  ')
     D WKeySysVal5     C                   CONST('Fees                ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for access objects, first DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for access objects, second DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for GL Accounts master detail
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  BRCA_ACCNT   E                     EXTFLD(BRCA)
 
      ** External DS for  GL Account Movements
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
     D  WNarratv              29     57A
     D  WNarratv28            29     56A
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WSeqnNum             125    127A
     D  WCustomer            125    130A
 
      ** DS for data to be passed to the Extract Program
     D*PDsRetRsac      DS           155                                                       CAP204
     D*PDsRetRsac      DS           175                                                CAP204 CAP205
     D PDsRetRsac      DS           182                                                       CAP205
     D  WRetailNum             1     10
     D**WRsacDetls            11    155                                                       CAP204
     D**WRsacDetls            11    175                                                CAP204 CAP205
     D  WRsacDetls            11    182                                                       CAP205
 
      ** Data structure for AOSVALR0 string
     D WSVal1          DS           200
     D  PSVal1                 1    200
     D  WSVal1_1               1      1
 
      ** Data structure for AOSVALR0 string
     D WF2RefNo        DS            11
     D  PF2Cust                1      6
     D  PF2Fact                7     11
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter fields
     D PInp_Commit     S              3A
     D PInp_CtlPgm     S             10A
     D CCG015          S              1A
 
      ** Parameter fields
     D POption         S              7A
     D PRtnCode        S              7A
     D PSequence       S              5A
     D PRetail         S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D PAccd           S             10A
     D PAcsq           S              2A
     D PBrca           S              3A
     D PChgType        S              1A
     D PSValK1         S             20
     D PSValK2         S             20
     D PSVal2          S            200
     D PSValK3         S             20
     D PSVal3          S            200
     D PSValK4         S             20
     D PSVal4          S            200
     D PSValK5         S             20
     D PSVal5          S            200
     D PSValK6         S             20
     D PSVal6          S            200
     D PSValK7         S             20
     D PSVal7          S            200
     D PSValK8         S             20
     D PSVal8          S            200
     D PSValK9         S             20
     D PSVal9          S            200
     D PSValK0         S             20
     D PSVal0          S            200
 
      ** Key List Fields for RERSACPD
     D KTnmr           S              6A
     D KTryp           S              2A
     D KVudt           S              5S 0
 
      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
 
      ** Work Variables
     D WCounter        S              5P 0
     D KDlno           S              6P 0
     D WReversal       S              1A
 
      ** Fields, data structures, arrays definition for CG error processing
     D/COPY CGCPYSRC,SRERRDLE
 
      ** Fields, data structures, arrays definition for CG audit processing
     D/COPY CGCPYSRC,CGAUDTDLE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'Main      '  @STK(Q)
 
      ** Execute main subroutine
 
     C                   IF        PInp_CtlPgm = 'REC000079'
     C                   EXSR      SRMainCOB
     C                   ELSE
     C                   EXSR      SRMainIC
     C                   END
 
      ** Audit processing
 
     C                   EXSR      SRAudit
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  SRMainIC - Controls main flow of program for Input Cycle     *
      *                                                               *
      *****************************************************************
     C     SRMainIC      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRMainIC  '  @STK(Q)
 
      ** Process all the records from RE Settled Transaction Index File
      ** with Transaction Maintenance Program equal to Control Program
 
     C     PInp_CtlPgm   SETLL     READVCL0
     C     PInp_CtlPgm   READE     READVCL0                               10
 
     C                   DOW       *IN10 = *OFF
 
      ** Initialize the flag.
 
     C                   EVAL      WReversal = *BLANKS
 
      ** Set the key to be used to access Account Movements File.
 
     C                   IF        RTRTYP = 'F2'
     C                   EVAL      WF2RefNo = RREFNO
     C                   EVAL      KTnmr = *BLANKS
     C                   MOVE      PF2Fact       KTnmr
     C                   ELSE
     C                   EVAL      KTnmr = RREFNO
     C                   ENDIF
 
     C                   EVAL      KTryp = RTRTYP
     C                   EVAL      KVudt = RVUDT
 
      ** Process only those records on Movements File which refer to
      ** the Index File Record read.
 
     C     KReRsac       SETGT     RERSACL3
     C     KReRsac       READPE    RERSACL3                               11
 
      ** Set the Reversal Flag to 'Y' if the record read from the
      ** Account Movements File has '*' on position 30 of the narrative.
      ** (Reversal Record)
 
      ** If the Change Type is insert and the record read from the
      ** Account Movements File has '*' on position 30 of the narrative,
      ** No record will be processed for this Index File record.
 
     C                   IF        *IN11 = *OFF AND RENARR = WNarratv
     C                             AND ((PF2Cust = WCustomer AND RTRTYP = 'F2')
     C                             OR (RSEQNO = WSeqnNum AND RTRTYP <> 'F2'))
     C                             AND WDelete = '*'
 
     C                   EVAL      WReversal = 'Y'
 
     C                   IF        RCHTYP = 'I'
     C                   EVAL      *IN11 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   DOW       *IN11 = *OFF
 
 
     C                   IF        RENARR = WNarratv
     C                             AND ((PF2Cust = WCustomer AND RTRTYP = 'F2')
     C                             OR (RSEQNO = WSeqnNum AND RTRTYP <> 'F2'))
 
      ** Set Narrative Description
 
     C                   IF        WNarratv28 = *BLANKS
     C                   EVAL      WNarratv28 = 'LENDING TRANSACTION'
     C                   ENDIF
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   MOVEL     WDsRsac       WRsacDetls
 
      ** The account must refer to a Retail Account.
 
     C                   MOVEL     CUSN          PCnum
     C                   EVAL      PCucd = CCYD
     C                   MOVEL     ACDE          PAccd
     C                   MOVEL     ASNC          PAcsq
     C                   EVAL      PBrca = BRCA
 
     C                   CALL      'AOACCTR0'
     C                   PARM      '*MSG'        PRtnCode
     C                   PARM      '*KEY  '      POption
     C                   PARM      *BLANK        PRetail
     C                   PARM                    PCnum
     C                   PARM                    PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      W0File = 'AOACCTR0'
     C                   EVAL      W0Key = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      W0ErNb = 01
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** Move Retail Account number to an alphanumeric variable.
 
     C                   MOVEL     ACNO          WRetailNum
 
      ** The account must allow printing of Transaction Advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND RePTRA = 'Y'
 
      ** If the record read from the Account Movement File has '*' on
      ** position 30 if the narrative field, set Change Type to 'R'.
      ** (REVERSAL).  Else set if to Change Type Value from Settled
      ** Transaction Index File.
 
     C                   IF        WDelete = '*'
     C                   EVAL      PChgType = 'R'
     C                   ELSE
     C                   EVAL      PChgType = RCHTYP
     C                   ENDIF
 
      ** Increment the count of RERSACPD records processed.
 
     C                   ADD       1             WCounter
 
      ** Call the Extract Program.
 
     C                   CALL      'CG003841'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType
 
     C                   IF        PRtnCode <> *BLANKS
 
     C                   EXSR      SRAudit
 
     C                   EVAL      W0File = 'CG003841'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 02
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF or end of processing for the
      ** Settled Transaction Index File record read.
 
     C     KReRsac       READPE    RERSACL3                               11
 
     C                   IF        *IN11 = *OFF AND RENARR = WNarratv
     C                             AND ((PF2Cust = WCustomer AND RTRTYP = 'F2')
     C                             OR (RSEQNO = WSeqnNum AND RTRTYP <> 'F2'))
 
     C                   IF        (WReversal = 'Y' AND WDelete = ' ')
     C                             OR (RCHTYP = 'I' AND WDelete = '*')
     C                   EVAL      *IN11 = *ON
     C                   ELSE
     C                   IF        WDelete = '*'
     C                   EVAL      WReversal = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no error occurred, set the Retail Settlement Advice Print Indicator
      ** to 'Y'.
 
     C                   EVAL      RSAPIN = 'Y'
     C                   UPDATE    READVCD0
 
     C                   COMMIT
 
     C     PInp_CtlPgm   READE     READVCL0                               10
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainCOB - Controls main flow of program for Input Cycle    *
      *                                                               *
      *****************************************************************
     C     SRMainCOB     BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRMainCOB '  @STK(Q)
 
      ** Read all records in Midas RE Account Movements for Online Printing Adv
 
     C     *LOVAL        SETLL     RERSACL3
     C                   READ      RERSACL3                               11
 
     C                   DOW       *IN11 = *OFF
 
      ** Set Narrative Description
 
     C                   EVAL      WNarratv28 = 'LENDING TRANSACTION'
 
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   MOVEL     WDsRsac       WRsacDetls
 
     C                   IF        WModule = 'U'
 
      * Clear all the AOSVALR0 input parameters
 
     C                   CLEAR                   PSValK1
 
      * Initialise the first system value key
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'HT' OR TRYP = 'HD' OR TRYP = 'HC'
     C                             OR TRYP = 'HG' OR TRYP = 'HZ' OR TRYP = 'HP'
     C                             OR TRYP = 'HA' OR TRYP = 'HB' OR TRYP = 'HF'
     C                             OR TRYP = 'HU' OR TRYP = 'HL' OR TRYP = 'HS'
     C                             OR TRYP = 'HR' OR TRYP = 'HE' OR TRYP = 'HH'
     C                             OR TRYP = 'HM' OR TRYP = 'HO'
     C                   EVAL      PSValK1 = WKeySysVal1
 
     C                   WHEN      TRYP = 'PI'
     C                   EVAL      PSValK1 = WKeySysVal2
 
     C                   WHEN      TRYP = 'MR'
     C                   EVAL      PSValK1 = WKeySysVal3
 
     C                   WHEN      TRYP = 'RE'
     C                   EVAL      PSValK1 = WKeySysVal4
 
     C                   WHEN      TRYP = 'F1' or
     C                             TRYP = 'F2' or
     C                             TRYP = 'LN'
     C                   EVAL      PSValK1 = WKeySysVal5
 
     C                   ENDSL
 
      * Retrieve the system value
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PSValK1
     C                   PARM                    PSVal1
     C                   PARM                    PSValK2
     C                   PARM                    PSVal2
     C                   PARM                    PSValK3
     C                   PARM                    PSVal3
     C                   PARM                    PSValK4
     C                   PARM                    PSVal4
     C                   PARM                    PSValK5
     C                   PARM                    PSVal5
     C                   PARM                    PSValK6
     C                   PARM                    PSVal6
     C                   PARM                    PSValK7
     C                   PARM                    PSVal7
     C                   PARM                    PSValK8
     C                   PARM                    PSVal8
     C                   PARM                    PSValK9
     C                   PARM                    PSVal9
     C                   PARM                    PSValK0
     C                   PARM                    PSVal0
 
      * If the system value is not found then issue a database error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   IF        PSVal0 = '*NRF'
     C                   EVAL      W0Key = PSValK0
     C                   ENDIF
     C                   IF        PSVal9 = '*NRF'
     C                   EVAL      W0Key = PSValK9
     C                   ENDIF
     C                   IF        PSVal8 = '*NRF'
     C                   EVAL      W0Key = PSValK8
     C                   ENDIF
     C                   IF        PSVal7 = '*NRF'
     C                   EVAL      W0Key = PSValK7
     C                   ENDIF
     C                   IF        PSVal6 = '*NRF'
     C                   EVAL      W0Key = PSValK6
     C                   ENDIF
     C                   IF        PSVal5 = '*NRF'
     C                   EVAL      W0Key = PSValK5
     C                   ENDIF
     C                   IF        PSVal4 = '*NRF'
     C                   EVAL      W0Key = PSValK4
     C                   ENDIF
     C                   IF        PSVal3 = '*NRF'
     C                   EVAL      W0Key = PSValK3
     C                   ENDIF
     C                   IF        PSVal2 = '*NRF'
     C                   EVAL      W0Key = PSValK2
     C                   ENDIF
     C                   IF        PSVal1 = '*NRF'
     C                   EVAL      W0Key = PSValK1
     C                   ENDIF
     C                   EVAL      W0File = 'SDSVALPD'
     C                   EVAL      W0ErNb = 04
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        WSVal1_1 =  'Y'
 
     C                   MOVEL     CUSN          PCnum
     C                   EVAL      PCucd = CCYD
     C                   MOVEL     ACDE          PAccd
     C                   MOVEL     ASNC          PAcsq
     C                   EVAL      PBrca = BRCA
 
     C                   CALL      'AOACCTR0'
     C                   PARM      '*MSG'        PRtnCode
     C                   PARM      '*KEY  '      POption
     C                   PARM      *BLANK        PRetail
     C                   PARM                    PCnum
     C                   PARM                    PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      W0File = 'AOACCTR0'
     C                   EVAL      W0Key = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      W0ErNb = 05
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** Move Retail Account number to an alphanumeric variable.
 
     C                   MOVEL     ACNO          WRetailNum
 
      ** The account must allow printing of Transaction Advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND RePTRA = 'Y'
 
      ** Set Change Type to 'I'.
 
     C                   EVAL      PChgType = 'I'
 
      ** Increment the count of RERSACPD records processed.
 
     C                   ADD       1             WCounter
 
      ** Call the Extract Program.
 
     C                   CALL      'CG003841'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType
 
     C                   IF        PRtnCode <> *BLANKS
 
     C                   EXSR      SRAudit
 
     C                   EVAL      W0File = 'CG003841'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 06
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF.
 
     C                   READ      RERSACL3                               11
 
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit -  Calls CGZAUDIT to do auditing.                    *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRAudit   '  @STK(Q)
 
      ** Output the count of records read
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003840'    I#REF
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     *BLANKS       I#SUB
     C                   MOVEL     'RSACMTPD'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WCounter      I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
 
      ** Write line of text
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*LINE   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
 
      ** Skip a line
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*SKIP   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
 
      ** Close Audit Printer file
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003840'    I#REF
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CAD1008'     I#TEXT
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    PInp_Commit
     C                   PARM                    PInp_CtlPgm
     C                   PARM                    CCG015
 
      ** Key list for RERSACL3
 
     C     KReRsac       KLIST
     C                   KFLD                    KTnmr
     C                   KFLD                    KTryp
     C                   KFLD                    KVudt
 
      ** Key list for REIAC
 
     C     KReiac        KLIST
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      W0File = 'AOBANKR0'
     C                   EVAL      W0Key = POption
     C                   EVAL      W0ErNb = 07
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Reset @STK index
 
     C                   Z-ADD     0             Q
 
      ** Initialize the counter.
 
     C                   Z-ADD     *ZERO         WCounter
 
      ** Open the Audit Print file
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003840AU'  I#SPLN
     C                   MOVEL     'CG003840'    I#REF
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************
