     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retail Advice for SE - Driver')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003850 - Midas CG Retail Advice for SE - Driver            *
      *                                                               *
      *  Function:  This program drives the Retail Advice for         *
      *             SE - Driver                                       *
      *                                                               *
      *  Called By: REC000881 in Input Cycle                          *
      *             REC000079 in Close of Business                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
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

     FRERSACL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv by FUND

     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RSACMTPO:RSACMTL0F)
      ** Midas RE Account Movements for Online Printing Adv by TNMR

     FRERSACL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RSACMTPO:RSACMTL2F)
      ** Midas RE Account Movements for Online Printing Adv

     FTRADBLK   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:TRADBLKF)
      ** Midas SE Trades by Bulk Reference

     FTRADS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trades by Bulk Reference

     FDPTMVR    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trades by Bulk Reference

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

     D WKeySysVal1     C                   CONST('PositionSettlement  ')
     D WKeySysVal2     C                   CONST('SecuritiesTrades    ')
     D WKeySysVal3     C                   CONST('BulkTrades          ')
     D WKeySysVal4     C                   CONST('DepotMovements      ')
     D WKeySysVal5     C                   CONST('DepotMovementsWalkIn')
     D WKeySysVal6     C                   CONST('DepotMovementWalkOut')

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

      ** Data structure for Transaction Ref No.
     D RREFNO          DS            30
     D  KTrRef                 1      6
     D  KSec                   1     10
     D  KCParty               11     16
     D  KBranch               17     19
     D  KDDate                20     24
     D  KType                 25     26

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

      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A

      ** Work Variables
     D WCounter        S              5P 0
     D WSETran         S              1A
     D WDDate          S              5S 0
     D WSec            S             21A
     D KTrTyp          S              2A
     D WTNLU           S              5A

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
     C                   EXSR      SRChkAdv

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

     C     *LOVAL        SETLL     RERSACL1
     C                   READ      RERSACL1                               11

     C                   DOW       *IN11 = *OFF

      ** Store GL Account Movement Details to a work variable.

     C                   MOVEL     WDsRsac       WRsacDetls

     C                   SELECT

      ** Projection is not from Securities Module

     C                   WHEN      WModule <> 'S'
     C                   EVAL      WSETran = 'N'

      ** Projection is Position Settlement

     C                   WHEN      TRYP = 'CP' or
     C                             TRYP = 'DV' or
     C                             TRYP = 'MT' or
     C                             TRYP = 'PP' or
     C                             TRYP = 'MP' or
     C                             TRYP = 'RC' or
     C                             TRYP = 'PS'
     C                   EVAL      PSValK1 = WKeySysVal1
     C                   EVAL      WSETran = 'Y'

      ** Projection is Trade Purchased or Sale

     C                   WHEN      TRYP = 'TP' or
     C                             TRYP = 'TS'
     C     TNMR          CHAIN     TRADBLK

      ** Trade inserted via Trades Input

     C                   IF        NOT %FOUND(TRADBLK)
     C     TNMR          CHAIN     TRADS
     C                   IF        %FOUND(TRADS)
     C                   EVAL      PSValK1 = WKeySysVal2
     c                   EVAL      WSETran = 'Y'
     C                   ENDIF

      ** Trade inserted via Bulk Input

     C                   ELSE
     C                   EVAL      PSValK1 = WKeySysVal3
     C                   EVAL      WSETran = 'Y'
     C                   ENDIF

      ** Projection is Depot Movement charges

     C                   WHEN      TRYP = 'WI' or
     C                             TRYP = 'WO' or
     C                             TRYP = 'DT' or
     C                             TRYP = 'BL' or
     C                             TRYP = 'BB' or
     C                             TRYP = 'RP' or
     C                             TRYP = 'RR' or
     C                             TRYP = 'PL'
     C     TNMR          CHAIN     DPTMVR
     C                   IF        %FOUND(DPTMVR)
     C                   IF        TRYP = 'WI'
     C                   EVAL      PSValK1 = WKeySysVal5
     C                   ELSE
     C                   IF        TRYP = 'WO'
     C                   EVAL      PSValK1 = WKeySysVal6
     C                   ELSE
     C                   EVAL      PSValK1 = WKeySysVal4
     C                   ENDIF
     C                   ENDIF
     c                   EVAL      WSETran = 'Y'
     C                   ENDIF

     C                   ENDSL

     C                   IF        WSETRan = 'Y'
     C                   EVAL      WSETran = 'N'

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

     C                   IF        *IN11 = *OFF AND PTRA = 'Y'

      ** Increment the count of RERSACPD records processed.

     C                   ADD       1             WCounter

      ** Set change type

     C                   EVAL      PChgType = 'I'

      ** Call the Extract Program.

     C                   CALL      'CG003851'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType

     C                   IF        PRtnCode <> *BLANKS

     C                   EXSR      SRAudit

     C                   EVAL      W0File = 'CG003851'
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
      *  SRChkAdv - Calls CGZAUDIT to do auditing.                    *
      *                                                               *
      *****************************************************************
     C     SRChkAdv      BEGSR

     C                   SELECT

      ** Process only those records on Movements File which refer to
      ** the Transaction read.  If this is called from a Trade/Bulk Input
      ** or Depot Movement Input.

     C                   WHEN      RPRGMN = 'SETRADUPD' or
     C                             RPRGMN = 'SEDPMVUPD' or
     C                             RPRGMN = 'SE0070   '
     C                   EVAL      KTrTyp = RTRTYP
     C     KRersacl0     SETGT     RERSACL0
     C     KRersacl0     READPE    RERSACL0                               11

      ** If this is called from Position Settlement Input.

     C                   WHEN      RPRGMN = 'SE0170'
     C                   MOVE      KDDate        WDDate
     C                   MOVEL     KSec          WSec
     C                   MOVEL     RENARR        WTNLU
     C                   MOVE      WTNLU         WSec
     C     KRersacl2     SETGT     RERSACL2
     C     KRersacl2     READPE    RERSACL2                               11

     C                   ENDSL

     C                   DOW       *IN11 = *OFF

      ** Stop Processing if insertion and record from RSACMTPD is reversal

     C                   IF        RCHTYP = 'I' and
     C                             WDelete = '*'
     C                   LEAVESR
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

     C                   IF        *IN11 = *OFF AND PTRA = 'Y'

      ** Increment the count of RERSACPD records processed.

     C                   ADD       1             WCounter

      ** Check if projection is reversal

     C                   IF        WDelete = '*'
     C                   EVAL      PChgType = 'R'
     C                   ELSE
     C                   EVAL      PChgType = RCHTYP
     C                   ENDIF

      ** Call the Extract Program.

     C                   CALL      'CG003851'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInp_Commit
     C                   PARM                    PDsRetRsac
     C                   PARM                    CCG015
     C                   PARM                    PChgType

     C                   IF        PRtnCode <> *BLANKS

     C                   EXSR      SRAudit

     C                   EVAL      W0File = 'CG003851'
     C                   EVAL      W0Key = PRtnCode
     C                   EVAL      W0ErNb = 02
     C                   EVAL      W0MsgD = 'MEM5003'
     C                   EVAL      W0MsgF = 'MIDAS'
     C                   EXSR      SRERR

     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Stop Processing if necessary

     C                   IF        *IN11 = *OFF and
     C                             WDelete = '*'
     C                   LEAVESR
     C                   ENDIF

      ** Read next record until EOF or end of processing for the
      ** transaction read.

     C                   SELECT
     C                   WHEN      RPRGMN = 'SETRADUPD' or
     C                             RPRGMN = 'SEDPMVUPD' or
     C                             RPRGMN = 'SE0070   '
     C     KRersacl0     READPE    RERSACL0                               11

     C                   WHEN      RPRGMN = 'SE0170'
     C     KRersacl2     READPE    RERSACL2                               11
     C                   ENDSL

     C                   ENDDO

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
     C                   MOVEL     'CG003850 '   I#REF
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
     C                   MOVEL     'CG003850'    I#REF
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

      ** Key list for REIAC

     C     KReiac        KLIST
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca

      ** Key list for RERSACL0

     C     KRersacl0     KLIST
     C                   KFLD                    KTrRef
     C                   KFLD                    KTrTyp

      ** Key list for RERSACL2

     C     KRersacl2     KLIST
     C                   KFLD                    WSec
     C                   KFLD                    KCParty
     C                   KFLD                    KBranch
     C                   KFLD                    WDDate
     C                   KFLD                    KType
     C

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

     C                   MOVEL     ##PGM         DBPGM

      ** Reset @STK index

     C                   Z-ADD     0             Q

      ** Initialize the counter.

     C                   Z-ADD     *ZERO         WCounter

      ** Open the Audit Print file

     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003850AU'  I#SPLN
     C                   MOVEL     'CG003850  '  I#REF
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
