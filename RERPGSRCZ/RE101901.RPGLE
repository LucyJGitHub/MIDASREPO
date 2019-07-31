     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group account overdraft limit check')         *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101901  - Group Account Overdraft Limit Check              *
      *                                                               *
      *  Function: This program will check the overdraft limit of     *
      *            an account.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR685449           Date 08Dec10               *
      *                 AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CRE022             Date 08Jun05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR685449 - Apply fix 225096                                  *
      *  225096 - Wrong calculation of available funds. Overdraft     *
      *           limit is in whole units of currency                 *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE022 - Change in Cash Management - Apply Group Limit Only  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *     LR        Last Record Indicator (Program Termination)     *
      *     U7 and U8 DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess - Subroutine to update the cleared balances on file *
      * SRAudit   - Subroutine to Output Audit Report                 *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** RE Group Account Hierarchy Links
     FREGAHLJ0  IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Accounts Master File
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
 
      ** RE Shadow Balances by Account Details
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Group Account (Inter-Company) Cleared Balances
     FREGACBL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Live Group Account Member Extension                                               CRE022
     FRELGAMXL1 IF   E           K DISK    INFSR(*PSSR)                                       CRE022
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              225096
      ** Currency Details                                                                     225096
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  225096
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** GL Account ID Break Down
     D GLAccntID       DS
     D  GLBranch               1      3
     D**GLCust**               4      9  0                                                    CSD027
     D  GLCust                 4      9                                                       CSD027
     D  GLCurr                10     12
     D***GLACode               13     16  0                                                   CGL029
     D***GLASeqN               17     18  0                                                   CGL029
     D  GLACode               13     22  0                                                    CGL029
     D  GLASeqN               23     24  0                                                    CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRetCode        S              7
     D POption         S              7
     D PErrMsg         S             30
     D PInBranch       S              3
     D*PInCust**       S              6  0                                                    CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3
     D***PInACode        S              4  0                                                  CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0
     D PDebAmnt        S             15  0
     D POutBranch      S              3
     D*POutCust*       S              6  0                                                    CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3
     D***POutACode       S              4  0                                                  CGL029
     D POutACode       S             10  0                                                    CGL029
     D POutASeqN       S              2  0
     D POutRetNo       S             10  0
     D PHierID         S              9  0
     D PHType          S              2
     D PBranch         S              3
     D*PCustNo**       S              6  0                                                    CSD027
     D PCustNo         S              6                                                       CSD027
     D PCurr           S              3
     D***PACode          S              4  0                                                  CGL029
     D PACode          S             10  0                                                    CGL029
     D PASeqNo         S              2  0
     D****PGLAcctID       S             18    DIM(99)                                         CGL029
     D PGLAcctID       S             24    DIM(99)                                            CGL029
     D PRetailNo       S             10    DIM(99)
     D PAcctStat       S              1    DIM(99)
     D PProfCent       S              4    DIM(99)
     D PAcctSec        S              2    DIM(99)
     D POverDraf       S             15S 0 DIM(99)
     D PBalAvail       S              1    DIM(99)
     D PThresBal       S             15S 0 DIM(99)
     D PCount          S              2  0
 
      ** Key Fields
     D KBranch         S              3
     D*KCustNo**       S              6  0                                                    CSD027
     D KCustNo         S              6                                                       CSD027
     D KCurr           S              3
     D***KACode          S              4  0                                                  CGL029
     D KACode          S             10  0                                                    CGL029
     D KASeqNo         S              2  0
 
     D WkAvailBal      S             16  0
     D Idx             S              3  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
 
      ** Initialise Output Parameters
 
     C                   EVAL      PRetCode   = *Blanks
     C                   EVAL      POutBranch = *Blanks
     C**********         EVAL      POutCust   = *Zeros                                        CSD027
     C                   EVAL      POutCust   = *Blanks                                       CSD027
     C                   EVAL      POutCurr   = *Blanks
     C                   EVAL      POutACode  = *Zeros
     C                   EVAL      POutASeqN  = *Zeros
     C                   EVAL      POutRetNo  = *Zeros
 
      ** Set up Key List
 
     C                   EVAL      KBranch = PInBranch
     C                   EVAL      KCustNo = PInCust
     C                   EVAL      KCurr   = PInCurr
     C                   EVAL      KACode  = PInACode
     C                   EVAL      KASeqNo = PInASeqN
 
      ** Access the Group Account Hierarrchy Links and details join file
 
     C     KyMemos       CHAIN     REGAHLJ0                           89
 
      ** If the access fails, the account does not belong to a group account
      ** hierarchy
 
     C                   IF        *IN89 = *On
     C                   GOTO      EndPgm
     C                   ENDIF
 
      ** Retrieve RE Live Group Account Member Extension detail.                              CRE022
      *                                                                                       CRE022
     C                   MOVE      'N'           W_ApGrpLmt        1                          CRE022
     C                   IF        CRE022 = 'Y'                                               CRE022
     C     KyMemos       CHAIN     RELGAMXL1                                                  CRE022
     C                   IF        %FOUND(RELGAMXL1)                                          CRE022
     C                   MOVE      GMAGLO        W_ApGrpLmt        1                          CRE022
     C                   ENDIF                                                                CRE022
     C                   ENDIF                                                                CRE022
 
      ** Access the account details for the input account
 
     C     KyMemos       CHAIN     ACCNTABF                           88
 
      ** If account does not exist or account is closed, exit function
 
     C                   IF        *IN88 = *On or RECI = 'C'
     C                   GOTO      EndPgm
     C                   ENDIF
 
      ** Set up the Parent Account
 
     C                   EVAL      PBranch = CLPBRC
     C                   EVAL      PCustNo = CLPCUS
     C                   EVAL      PCurr   = CLPCCY
     C                   EVAL      PACode  = CLPACD
     C                   EVAL      PASeqNo = CLPASN
     C                   EVAL      PHierID = CLHIER
 
      ** Call module 'Construct a Cash Management Hierarchy Chain'
 
     C                   CALLB     'RE100604'
 
      ** Return Code
      ** Error Message
 
     C                   PARM      *Blanks       PRetCode
     C                   PARM                    PErrMsg
 
      ** Hierarchy ID
      ** Hierarchy Type
 
     C                   PARM                    PHierID
     C                   PARM                    PHType
 
      ** Parent branch
      ** Parent customer
      ** Parent currency
      ** Parent a/c code
      ** Parent a/c seq.
 
     C                   PARM                    PBranch
     C                   PARM                    PCustNo
     C                   PARM                    PCurr
     C                   PARM                    PACode
     C                   PARM                    PASeqNo
 
      ** OUTPUTS
      ** CHAINS FOR:
      ** GL Account ID
      ** Retail A/c No.
      ** A/c Status
      ** Profit Centre
      ** A/c Section
      ** Overdraft
      ** Balance Available for I/C Overdraft
      ** I/C Threshold Balance
 
     C                   PARM                    PGLAcctID
     C                   PARM                    PRetailNo
     C                   PARM                    PAcctStat
     C                   PARM                    PProfCent
     C                   PARM                    PAcctSec
     C                   PARM                    POverDraf
     C                   PARM                    PBalAvail
     C                   PARM                    PThresBal
 
      ** Count in chain
 
     C                   PARM                    PCount
 
     C                   IF        PRetCode = '*NOREC' and PErrMsg <> *Blanks or
     C                             PRetCode = '*TOP'
     C                   GOTO      EndPgm
     C                   ENDIF
 
     C                   IF        PRetCode = '*ERROR'
     C                   EVAL      X_ERMS = 'Error encountered on call to +
     C                             RE100604'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** For the input account ID, access LF/MEMOS
 
     C     KyMemos       CHAIN     MEMOSL1
 
      ** Adjust overdraft limit with currency decimal places                                  225096
                                                                                              225096
     C                   CALLB     'ZAACSCURR'                                                225096
     C                   PARM                    CCY                                          225096
     C                   PARM                    SDCURR                                       225096
                                                                                              225096
     C                   SELECT                                                               225096
     C     A6NBDP        WHENEQ    0                                                          225096
     C     1             MULT      ODLN          WOdlnNum         15 0                        225096
     C     A6NBDP        WHENEQ    1                                                          225096
     C     10            MULT      ODLN          WOdlnNum                                     225096
     C     A6NBDP        WHENEQ    2                                                          225096
     C     100           MULT      ODLN          WOdlnNum                                     225096
     C     A6NBDP        WHENEQ    3                                                          225096
     C     1000          MULT      ODLN          WOdlnNum                                     225096
     C                   ENDSL                                                                225096
                                                                                              225096
      ** Calculate the Inter-Company Available Balance
 
     C**********         EVAL      WkAvailBal = ODLN - CLBLN - PDebAmnt                       225096
     C                   EVAL      WkAvailBal = WOdlnNum - CLBLN - PDebAmnt                   225096
 
     C                   IF        WkAvailBal < 0
      *                                                                                       CRE022
      ** If Apply Group Limit Only, do not send an error.                                     CRE022
      *                                                                                       CRE022
     C                   IF        CRE022 <> 'Y' OR                                           CRE022
     C                             W_ApGrpLmt <> 'Y'                                          CRE022
      *                                                                                       CRE022
     C                   EVAL      PRetCode   = '*ODLMTX'
     C                   EVAL      POutBranch = PInBranch
     C                   EVAL      POutCust   = PInCust
     C                   EVAL      POutCurr   = PInCurr
     C                   EVAL      POutACode  = PInACode
     C                   EVAL      POutASeqN  = PInASeqN
     C                   EVAL      POutRetNo  = ACNO
     C                   GOTO      EndPgm
      *                                                                                       CRE022
     C                   ENDIF                                                                CRE022
      *                                                                                       CRE022
     C                   ENDIF
 
      ** Check each of the account from GLAI chain
      ** Initialize Index
 
     C                   EVAL      Idx = 1
 
      ** If Apply Group Limit Only, check only the top Company available balance              CRE022
      ** => Check only the last account.                                                      CRE022
      *                                                                                       CRE022
     C                   IF        CRE022 = 'Y' AND                                           CRE022
     C                             W_ApGrpLmt = 'Y'                                           CRE022
     C                   Z-ADD     Idx           W_Idx             3 0                        CRE022
     C                   DOW       W_Idx <= 99 and PGlAcctID(W_Idx) <> *Blanks                CRE022
     C                             and PAcctStat(W_Idx) <> 'C'                                CRE022
     C                   EVAL      Idx   = W_Idx                                              CRE022
     C                   EVAL      W_Idx = W_Idx + 1                                          CRE022
     C                   ENDDO                                                                CRE022
     C                   ENDIF                                                                CRE022
 
     C                   DOW       Idx <= 99 and PGlAcctID(Idx) <> *Blanks and
     C                             PAcctStat(Idx) <> 'C'
 
     C                   EVAL      GLAccntID = PGlAcctID(Idx)
     C                   EVAL      KBranch = GLBranch
     C                   EVAL      KCustNo = GLCust
     C                   EVAL      KCurr   = GLCurr
     C                   EVAL      KACode  = GLACode
     C                   EVAL      KASeqNo = GLASeqN
                                                                                              225096
      ** Adjust overdraft limit with currency decimal places                                  225096
                                                                                              225096
     C                   SELECT                                                               225096
     C     A6NBDP        WHENEQ    0                                                          225096
     C     1             MULT      POverDraf(Idx)WOdlnNum         15 0                        225096
     C     A6NBDP        WHENEQ    1                                                          225096
     C     10            MULT      POverDraf(Idx)WOdlnNum                                     225096
     C     A6NBDP        WHENEQ    2                                                          225096
     C     100           MULT      POverDraf(Idx)WOdlnNum                                     225096
     C     A6NBDP        WHENEQ    3                                                          225096
     C     1000          MULT      POverDraf(Idx)WOdlnNum                                     225096
     C                   ENDSL                                                                225096
 
     C     KAccnt        CHAIN     REGACBL0                           87
 
      ** Calculate Inter Company Available Balance
 
     C                   EVAL      WkAvailBal = *Zeros
     C**********         EVAL      WkAvailBal = POverDraf(Idx) - GCICCB -                     225096
     C**********                   PDebAmnt                                                   225096
     C                   EVAL      WkAvailBal = WOdlnNum - GCICCB - PDebAmnt                  225096
 
      ** Check if Available Balance is less than zero
 
     C                   IF        WkAvailBal < *Zeros
     C                   EVAL      GLAccntID  = PGLAcctID(Idx)
     C                   EVAL      PRetCode   = '*ODLMTX'
     C                   EVAL      POutBranch = GLBranch
     C                   EVAL      POutCust   = GLCust
     C                   EVAL      POutCurr   = GLCurr
     C                   EVAL      POutACode  = GLACode
     C                   EVAL      POutASeqN  = GLASeqN
     C                   MOVE      PRetailNo(Idx)POutRetNo
     C                   LEAVE
     C                   ENDIF
 
     C                   EVAL      Idx = Idx + 1
 
     C                   ENDDO
 
      ** End Program
 
     C     EndPgm        Tag
 
     C                   RETURN
 
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
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
      ** Branch
      ** Customer
      ** Account Code
      ** Account Sequence
      ** Debit Amount
 
     C                   PARM                    PRetCode
     C                   PARM                    PInBranch
     C                   PARM                    PInCust
     C                   PARM                    PInCurr
     C                   PARM                    PInACode
     C                   PARM                    PInASeqN
     C                   PARM                    PDebAmnt
 
      ** Output Parameters
      ** Branch
      ** Customer
      ** Account Code
      ** Account Sequence
      ** Retail Account No. of account in error
 
     C                   PARM                    POutBranch
     C                   PARM                    POutCust
     C                   PARM                    POutCurr
     C                   PARM                    POutACode
     C                   PARM                    POutASeqN
     C                   PARM                    POutRetNo
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     KAccnt        KLIST
     C                   KFLD                    KBranch
     C                   KFLD                    KCustNo
     C                   KFLD                    KCurr
     C                   KFLD                    KACode
     C                   KFLD                    KASeqNo
 
     C     KyMemos       KLIST
     C                   KFLD                    KCustNo
     C                   KFLD                    KCurr
     C                   KFLD                    KACode
     C                   KFLD                    KASeqNo
     C                   KFLD                    KBranch
 
     C                   MOVE      'N'           CRE022            1                          CRE022
     C                   CALLB     'AOSARDR0'                                                 CRE022
     C                   PARM      *Blanks       PRetCode                                     CRE022
     C                   PARM      '*VERIFY'     POption                                      CRE022
     C                   PARM      'CRE022'      PSard             6                          CRE022
     C                   PARM                    DSFDY                                        CRE022
     C                   IF        PRetCode = *Blanks                                         CRE022
     C                   EVAL      CRE022 = 'Y'                                               CRE022
     C                   ENDIF                                                                CRE022
 
     C                   ENDSR
 
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
