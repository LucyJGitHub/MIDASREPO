     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for FT - Driver')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003860 - Midas CG Retail Advice for FT - Driver            *
      *                                                               *
      *  Function:  This program drives the Retail Advice for         *
      *             FT - Extract                                      *
      *                                                               *
      *  Called By: REC000881 in Input Cycle                          *
      *             REC000079 in Close of Business                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP205             Date 23Feb10               *
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
 
     FRERSACL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv by FUND
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas Retail Interest and Charges File
 
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
 
     D WKeySysVal1     C                   CONST('IncomingPayments    ')
     D WKeySysVal2     C                   CONST('Out/RegularPayments ')
     D WKeySysVal3     C                   CONST('ChequesToBePaid     ')
     D WKeySysVal4     C                   CONST('ChequesToBeCollected')
     D WKeySysVal5     C                   CONST('InRequestForTransfer')
     D WKeySysVal6     C                   CONST('CustCreditTransfer  ')
     D WKeySysVal7     C                   CONST('NostroTransfer      ')
 
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
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WSeqnNum              70     72A
 
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
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSVal2          S            200A
     D PSValK3         S             20A
     D PSVal3          S            200A
     D PSValK4         S             20A
     D PSVal4          S            200A
     D PSValK5         S             20A
     D PSVal5          S            200A
     D PSValK6         S             20A
     D PSVal6          S            200A
     D PSValK7         S             20A
     D PSVal7          S            200A
     D PSValK8         S             20A
     D PSVal8          S            200A
     D PSValK9         S             20A
     D PSVal9          S            200A
     D PSValK0         S             20A
     D PSVal0          S            200A
 
      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
 
      ** Work Variables
     D WCounter        S              5P 0
     D WFTRef          S             21A
 
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
     C                   ENDIF
 
      ** Audit processing
 
     C                   EXSR      SRAudit
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
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
      ** with Transaction Maintenance Program equal to Control Program.
 
     C     PInp_CtlPgm   SETLL     READVCL0
     C     PInp_CtlPgm   READE     READVCL0                               10
 
     C                   DOW       *IN10 = *OFF
 
     C                   EVAL      WFTRef = RREFNO
 
      ** Process only those records on Movements File which refer to
      ** the Transaction read.
 
     C     WFTRef        SETGT     RERSACL1
     C     WFTRef        READPE    RERSACL1                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WDelete = '*'
     C                   IF        RSEQNO = WSeqnNum
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WDelete <> '*'
 
     C                   IF        RSEQNO = WSeqnNUm
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
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
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
      ** Increment the count of RERSACPD records processed.
 
     C                   ADD       1             WCounter
 
      ** Call the Extract Program.
 
     C                   CALL      'CG003861'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM      'I'           PChgType
 
     C                   IF        PRtnCode <> *BLANKS
 
     C                   EXSR      SRAudit
 
     C                   EVAL      W0File = 'CG003861'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 02
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record until EOF or end of processing for the
      ** transaction read.
 
     C     WFTRef        READPE    RERSACL1                               11
 
     C                   IF        *IN11 = *OFF AND
     C                             WDelete = '*'
     C                   IF        RSEQNO = WSeqnNum
     C                   LEAVE
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
 
      ** Read all records in Midas RE Account Movements for Online Printing Advice.
 
     C     *LOVAL        SETLL     RERSACL1
     C                   READ      RERSACL1                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WModule = 'G'
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
     C                   MOVEL     WDsRsac       WRsacDetls
 
      ** Initialise the first system value key
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'IN'
     C                   EVAL      PSValK1 = WKeySysVal1
 
     C                   WHEN      TRYP = 'OP' or
     C                             TRYP = 'RP'
     C                   EVAL      PSValK1 = WKeySysVal2
 
     C                   WHEN      TRYP = 'CP'
     C                   EVAL      PSValK1 = WKeySysVal3
 
     C                   WHEN      TRYP = 'CC'
     C                   EVAL      PSValK1 = WKeySysVal4
 
     C                   WHEN      TRYP = 'RI' or
     C                             TRYP = 'RO'
     C                   EVAL      PSValK1 = WKeySysVal5
 
     C                   WHEN      TRYP = 'BI' or
     C                             TRYP = 'BO'
     C                   EVAL      PSValK1 = WKeySysVal6
 
     C                   WHEN      TRYP = 'NT'
     C                   EVAL      PSValK1 = WKeySysVal7
 
     C                   ENDSL
 
      * Retrieve the system value
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRtnCode
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
 
      ** If the system value is not found then issue a database error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   IF        PSVal0 = '*NRF'
     C                   EVAL      W0Key  = PSValK0
     C                   ENDIF
     C                   IF        PSVal9 = '*NRF'
     C                   EVAL      W0Key  = PSValK9
     C                   ENDIF
     C                   IF        PSVal8 = '*NRF'
     C                   EVAL      W0Key  = PSValK8
     C                   ENDIF
     C                   IF        PSVal7 = '*NRF'
     C                   EVAL      W0Key  = PSValK7
     C                   ENDIF
     C                   IF        PSVal6 = '*NRF'
     C                   EVAL      W0Key  = PSValK6
     C                   ENDIF
     C                   IF        PSVal5 = '*NRF'
     C                   EVAL      W0Key  = PSValK5
     C                   ENDIF
     C                   IF        PSVal4 = '*NRF'
     C                   EVAL      W0Key  = PSValK4
     C                   ENDIF
     C                   IF        PSVal3 = '*NRF'
     C                   EVAL      W0Key  = PSValK3
     C                   ENDIF
     C                   IF        PSVal2 = '*NRF'
     C                   EVAL      W0Key  = PSValK2
     C                   ENDIF
     C                   IF        PSVal1 = '*NRF'
     C                   EVAL      W0Key  = PSValK1
     C                   ENDIF
     C                   EVAL      W0File = 'SDSVALPD'
     C                   EVAL      W0ErNb = 03
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
     C                   EVAL      W0ErNb = 04
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
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
      ** Increment the count of RERSACPD records processed.
 
     C                   ADD       1             WCounter
 
      ** Call the Extract Program.
 
     C                   CALL      'CG003861'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM      'I'           PChgType
 
     C                   IF        PRtnCode <> *BLANKS
 
     C                   EXSR      SRAudit
 
     C                   EVAL      W0File = 'CG003861'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 05
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF.
 
     C                   READ      RERSACL1                               11
 
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Calls CGZAUDIT to do auditing.                     *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRAudit   '  @STK(Q)
 
      ** Output the count of records read
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003860 '   I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
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
     C                   MOVEL     'CG003860'    I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
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
     C                   EVAL      W0ErNb = 06
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
     C                   MOVEL     'CG003860AU'  I#SPLN
     C                   MOVEL     'CG003860  '  I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
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
