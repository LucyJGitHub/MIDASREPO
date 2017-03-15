     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for RE - Driver')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003820 - Midas CG Retail Advice for RE - Driver            *
      *                                                               *
      *  Function:  This program drives the Retail Advice for         *
      *             RE - Extract                                      *
      *                                                               *
      *  Called By: REC000881 in Input Cycle                          *
      *             REC000079 in Close of Business                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
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
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
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
 
     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv by TNMR/TRYP
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas Retail Interest and Charges File
 
     FSTAND     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(STANDSBF)
      ** Midas RE Standing Orders
 
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
 
     D WKeySysVal1     C                   CONST('StandingOrders      ')
     D WKeySysVal2     C                   CONST('CustomerExchange    ')
 
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
 
      ** Retail Transaction Type Details Data Structure
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
 
      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for GL Accounts master detail
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  BRCA_ACCNT   E                     EXTFLD(BRCA)
     D  LCD_ACCNT    E                     EXTFLD(LCD)
 
      ** External DS for  GL Account Movements
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
     D  WNarratv              29     57A
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WDebCreInd           125    127A
 
      ** DS for data to be passed to the Extract Program
     D*PDsRetRsac      DS           155                                                       CAP204
     D PDsRetRsac      DS           175                                                       CAP204
     D  WRetailNum             1     10
     D**WRsacDetls            11    155                                                       CAP204
     D  WRsacDetls            11    175                                                       CAP204
 
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
     D PTranType       S              5A
     D PSARD           S              6A
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
 
      ** Key List Fields for RERSACPD
     D KTnmr           S              6A
     D KTryp           S              2A
 
      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
 
      ** Work Variables
     D WCounter        S              5P 0
     D WReversal       S              1A
     D WStor           S              5S 0
     D WPrintAdv       S              1A
     D WIter           S              1P 0
     D S01466          S              1A
     D WrkDC           S              1S 0
 
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
 
      ** Initialize the flag.
 
     C                   EVAL      WReversal = *BLANKS
 
      ** Set the key to be used to access Account Movements File.
 
     C                   IF        RTRTYP = 'CE'
     C                   EVAL      KTnmr = RREFNO
     C                   ENDIF
 
     C                   IF        RTRTYP = 'SO'
     C                   EVAL      %SUBST(KTnmr:1:1) = *BLANK
     C                   EVAL      %SUBST(KTnmr:2:5) = RREFNO
     C                   ENDIF
 
     C                   EVAL      KTryp = RTRTYP
     C                   EVAL      WrkDC = 9
 
      ** Process only those records on Movements File which refer to
      ** the Transaction read.
 
     C     KReRsac       SETGT     RERSACL0
     C     KReRsac       READPE    RERSACL0                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   EVAL      WPrintAdv = 'N'
 
 
     C                   IF        RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'I' AND
     C                             WDelete <> '*' OR
 
     C                             RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'A' OR
 
     C                             RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'D' AND
     C                             WrkDC <> DORC OR
 
     C                             RPRGMN = 'RE0150' AND
     C                             RSEQNO = WDebCreInd
 
     C                   EVAL      WrkDC = DORC
     C                   EVAL      WIter = WIter + 1
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
 
      ** Set Narrative Description
 
     C                   IF        NRTD     = *BLANKS
     C                   EVAL      WNarratv = 'RETAIL TRANSACTION'
     C                   ENDIF
      *
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
 
     C                   EVAL      WPrintAdv = 'Y'
 
      ** For Standing Order Transactions, Transaction Type must
      ** allow printing of Transaction Advices.
 
     C                   IF        RPRGMN = 'RE0253' AND
     C                             S01466 = 'Y'
 
     C                   EVAL      WPrintAdv = 'N'
 
     C                   MOVE      KTnmr         WStor
     C     WStor         CHAIN     STAND                              12
 
     C                   IF        *IN12 = *ON
 
     C                   EVAL      W0File = 'STANDSB'
     C                   EVAL      W0Key = KTnmr
     C                   EVAL      W0ErNb = 02
     C                   EVAL      W0MsgD = 'MEM5004'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ELSE
 
     C                   EVAL      PTranType = TRAT
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PTranType
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WPrintAdv = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AORETRR0'
     C                   EVAL      W0Key = PTranType
     C                   EVAL      W0ErNb = 03
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Print Transaction Advice.
 
     C                   IF        WPrintAdv = 'Y'
 
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
 
     C                   CALL      'CG003821'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EXSR      SRAudit
     C                   EVAL      W0File = 'CG003821'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 04
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** At this point, we already got the a/c movement record for RE0150.
 
     C                   IF        RPRGMN = 'RE0150'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        RPRGMN = 'RE0253'
 
      ** Loop 4 times if the current change type = 'A'.
 
     C                   IF        RCHTYP = 'A'
     C                   IF        WIter = 4
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
      ** Loop 2 times if the current change type = 'I' or 'D'.
 
     C                   IF        RCHTYP = 'I' OR
     C                             RCHTYP = 'D'
     C                   IF        WIter = 2
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     KReRsac       READPE    RERSACL0                               11
 
 
     C                   ENDDO
 
      ** Set the Retail Settlement Advice Print Indicator to 'Y'.
 
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
 
     C     *LOVAL        SETLL     RERSACL0
     C                   READ      RERSACL0                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WModule = 'R'
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
 
     C                   EVAL      NRTD = 'RETAIL TRANSACTION'
     C                   MOVEL     WDsRsac       WRsacDetls
 
      ** Initialise the first system value key
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'SO'
     C                   EVAL      PSValK1 = WKeySysVal1
 
     C                   WHEN      TRYP = 'CE'
     C                   EVAL      PSValK1 = WKeySysVal2
 
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
     C                   EVAL      W0ErNb = 05
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
     C                   EVAL      W0ErNb = 06
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
 
     C                   EVAL      WPrintAdv = 'Y'
 
      ** For Standing Order Transactions, Transaction Type must
      ** allow printing of Transaction Advices.
 
     C                   IF        TRYP = 'SO' AND
     C                             S01466 = 'Y'
 
     C                   EVAL      WPrintAdv = 'N'
 
     C                   MOVE      TNMR          WStor
     C     WStor         CHAIN     STAND                              12
 
     C                   IF        *IN12 = *ON
 
     C                   EVAL      W0File = 'STANDSB'
     C                   EVAL      W0Key = TNMR
     C                   EVAL      W0ErNb = 07
     C                   EVAL      W0MsgD = 'MEM5004'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ELSE
 
     C                   EVAL      PTranType = TRAT
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PTranType
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WPrintAdv = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AORETRR0'
     C                   EVAL      W0Key = PTranType
     C                   EVAL      W0ErNb = 08
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Print Transaction Advice.
 
     C                   IF        WPrintAdv = 'Y'
 
      ** Set Narrative Description
 
 
      ** Increment the count of RERSACPD records processed.
 
     C                   ADD       1             WCounter
 
      ** Call the Extract Program.
 
     C                   CALL      'CG003821'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM      'I'           PChgType
 
     C                   IF        PRtnCode <> *BLANKS
 
     C                   EXSR      SRAudit
 
     C                   EVAL      W0File = 'CG003821'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 09
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF.
 
     C                   READ      RERSACL0                               11
 
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
     C                   MOVEL     'CG003820 '   I#REF
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
     C                   MOVEL     'CG003820'    I#REF
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
 
      ** Key list for RERSACL0
 
     C     KReRsac       KLIST
     C                   KFLD                    KTnmr
     C                   KFLD                    KTryp
 
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
     C                   EVAL      W0ErNb = 10
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Check if Standing Order Transaction Types is on.
 
     C                   EVAL      S01466 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'S01466'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtnCode <> *Blanks  and
     C                             PRtnCode <> '*NRF'
     C                   EVAL      W0File = 'AOSARDR0'
     C                   EVAL      W0Key = POption
     C                   EVAL      W0ErNb = 11
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      S01466 = 'Y'
     C                   ENDIF
 
      ** Reset @STK index
 
     C                   Z-ADD     0             Q
 
      ** Initialize the counter.
 
     C                   Z-ADD     *ZERO         WCounter
 
      ** Open the Audit Print file
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003820AU'  I#SPLN
     C                   MOVEL     'CG003820  '  I#REF
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
