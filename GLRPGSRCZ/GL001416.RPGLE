     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retrieve Shadow Post. by Network Account')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001416 - Midas GL Retrieve Shadow Postings by Network A/c  *
      *                                                               *
      *  Function:  This program retrieves the Shadow postings        *
      *             by Network/Account/Message/Type/Destination.      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG009             Date 24Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD039029           Date 13Jul16               *
      *                 MD036398           Date 02Nov15               *
      *                 MD034442           Date 14Jul15               *
      *                 MD032299           Date 23Mar15               *
      *                 MD027587           Date 19Jun14               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25226           Date 28Aug09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG22995           Date 20Feb09               *
      *                 BUG22687           Date 06Feb09               *
      *                 BUG22558           Date 03Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 16Mar10               *
      *                 CAP204             Date 04Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 23May02               *
      *                 CGL013  *CREATE    Date 11Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG009 - MT942 without Forward Value Postings                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039029 - No MT942 generated even if there are shadow       *
      *             postings, for e.g. from Batch Postings, because   *
      *             no record is being written to GLPOSTPD.           *
      *  MD036398 - MT942 not sent. Use NTRAN instead of NTRAN1.      *
      *  MD034442 - Include Nostor Transfer.                          *
      *             Include IC  movements from Dealing and Lending.   *
      *  MD032299 - Include overnight movements from DL and LE.       *
      *             Amend process to generate MT94x only for FT       *
      *             Authorised Payments.                              *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25226 - Field 61 on MT942 is not showing correct data     *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG22995 - Wrong GVC code output in field 86                 *
      *  BUG22687 - Various error on MT94x generation                 *
      *  BUG22558 - Error on INPAY and OTPAY extended narratives      *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account               *
      *  CRE008 - Cash Management                                     *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FRSACMTL2  IF   E           K DISK    INCLUDE(RSACMTPO) INFSR(*PSSR)
      ** Midas GL Account Movements.

     FGLRSACL0  IF   E           K DISK                      INFSR(*PSSR)
      ** Midas GL MT94x Used Account Movement - Retieval.
     F                                     RENAME(GLRSACD0:GLRSACR0)
     F                                     PREFIX(US)

     FGLJENXL1  IF   E           K DISK                      INFSR(*PSSR)
      ** Midas GL Journal Entry - Add. Inf. - Retrieval.
      *                                                                                     BUG23284
     FGLJENPL1  IF   E           K DISK                      INFSR(*PSSR)                   BUG23284
      *                                                                                     BUG23284
      ** Midas GL Journal Entry - Trans Type  Retrieval.                                    BUG23284
      *                                                                                     BUG23284
                                                                                            BUG22558
     FINPAY     IF   E           K DISK                      INFSR(*PSSR)                   BUG22558
      ** Midas FT Incoming Payments Transactions.                                           BUG22558
                                                                                            BUG22558
     FOTPAY     IF   E           K DISK                      INFSR(*PSSR)                   BUG22558
      ** Midas FT Outgoing Payments Transactions.                                           BUG22558

     FGLPOSTPD  O  A E             DISK    COMMIT            INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages.
     F                                     PREFIX(GL)
                                                                                              CRE008
     FGLPSTZSL0 IF   E           K DISK                      INFSR(*PSSR)                     CRE008
      ** Midas GL ostings in Transit - Zero Bal/Sweep Exts                                    CRE008
                                                                                              216937
     FGLPSTGAL0 IF   E           K DISK                      INFSR(*PSSR)                     216937
      ** Midas GL ostings in Transit - Group Accounts                                         216937
     F/COPY WNCPYSRC,GLH00621

     FGLRSACPD  O  A E             DISK    COMMIT            INFSR(*PSSR)
      ** Midas GL MT94x Used Account Movement.
     F***NTRAN1**  IF   E           K DISK                      INFSR(*PSSR)       MD034442 MD036398
     FNTRAN     IF   E           K DISK                      INFSR(*PSSR)                   MD036398
      ** Midas FT Nostro Transfer Transactions.                                             MD034442
     F/COPY WNCPYSRC,GLH00394

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access Account Movement (LF/RSACMTL2)                             *
      * 28 - Access Used Account Movement (LF/GLRSACL0)                        *
      * 29 - Access ZS Postings in Transit Ext (LF/GLAPSTZSL0)                 *              CRE008
      * 30 - Access GA Postings in Transit Ext (LF/GLAPSTGAL0)                 *              216937
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

      ** Arrays and Data Structures
      ** --------------------------

     D GLMR94        E DS                  EXTNAME(GLMR94PD)
      **  Data Structure for GL MT941/942 Messages Requests.

     D DsUsedMvnt    E DS                  EXTNAME(GLRSACPD)
     D                                     PREFIX(US)
      **  Data structure for Used Movement.

     D DsCurrMvnt    E DS                  EXTNAME(RSACMTPD)
      **  Data structure for Current Movement.

     D DsCmpMvnt       DS
      ** Data Structure to compare with Used Movements
     D  CmpNWRK                            LIKE(MGNWRK)                         Network
     D  CmpNATY                            LIKE(MGNATY)                         Network
     D  CmpDSTN                            LIKE(MGDSTN)                         Destination
     D  CmpMTPY                            LIKE(MGMTPY)                         Message Type
     D  CmpDetail                          LIKE(DsCurrMvnt)                     RSACMTPD Detail

     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC)
      **  Data structure for Account Details.

     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      **  Data structure for Narrative Code.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
                                                                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)                       CRE008
      **  Data Structure for Switchable features descriptions.                                CRE008

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

     D                 DS
      **  Arrays containing Transaction Types and corresponding details.
     D*TransType******               50    DIM(60) CTDATA PERRCD(1)                           CRE008
     D*TransType*                    50    DIM(61) CTDATA PERRCD(1)                    CRE008 CAP204
     D/COPY WNCPYSRC,GLH00622
     D TransType                     50    DIM(63) CTDATA PERRCD(1)                           CAP204
     D/COPY WNCPYSRC,GLH00627
     D    TrType                      2    OVERLAY(TransType)                   Transaction Type
     D      TrFiller1                 1    OVERLAY(TransType:*NEXT)
     D    TrModule                    2    OVERLAY(TransType:*NEXT)             MIDAS Module
     D      TrFiller2                 1    OVERLAY(TransType:*NEXT)
     D    TrGETP                      1    OVERLAY(TransType:*NEXT)             Generated Entry Type
     D      TrFiller3                 1    OVERLAY(TransType:*NEXT)
     D    TrSPOS                      7    OVERLAY(TransType:*NEXT)             Source of Posting
     D      TrFiller4                 1    OVERLAY(TransType:*NEXT)
     D    TrDescrip                  34    OVERLAY(TransType:*NEXT)             Description

     D                 DS
      ** Data Structure to retrieve the Batch Number and the Item Number
     D GLSPOS                         7A                                        Source of Posting
     D  WBatchNb               1      3A                                        Batch Number
     D  WItemNb                4      6S 0                                      Item Number
     D/COPY WNCPYSRC,GLH00395

      ** Declared variables
      ** ------------------

     D KeyNWRK         S                   LIKE(MGNWRK)                         Network
     D KeyBRCH         S                   LIKE(ACBRCA)                         Branch
     D KeyCNUM         S                   LIKE(ACCNUM)                         Customer
     D KeyCCY          S                   LIKE(ACCCY)                          Currency
     D KeyACOD         S                   LIKE(ACACOD)                         Account Code
     D KeyACSQ         S                   LIKE(ACACSQ)                         Account Sequence
     D KeyNATY         S                   LIKE(MGNATY)                         Net. Account Type
     D KeyDSTN         S                   LIKE(MGDSTN)                         Destination
     D KeyMTPY         S                   LIKE(MGMTPY)                         Message Type
     D/COPY WNCPYSRC,GLH00396

     D P@RTCD          S              7                                         Return code
     D P@OPTN          S              7                                         Option
     D P@SARD          S              6                                         Sar           CRE008
     D P@ACNO          S             10                                         Retail Acc. Number
     D P@CUSN          S              6                                         Customer Number
     D P@CURR          S              3                                         Currency
     D*P@CODE***       S              4                                         Account Code  CGL029
     D P@CODE          S             10                                                       CGL029
     D P@SEQU          S              2                                         Account Sequence
     D P@BRCH          S              3                                         Branch
     D P@NVCD          S              2                                         Narrative Code

     D CRE008          S              6                                         CRE008 flag   CRE008
     D PrcAccnt        S              1                                         Process Account
     D PrcMvnt         S              1                                         Process Movement
     D TrIdx           S              5U 0                                      Trans. Type Index
     D WkTRYP          S                   LIKE(TRYP)                           Transaction Type
     D WkNARR          S                   LIKE(GLPNAR)                         Posting Narrative
     D CER031          S              1                                                     BUG22558

     D PRCGLPN         S              1                                         UpdGLPOSTPD MD032299
     D PRCRSMN         S              1                                         UpdGLRSACPD MD032299
     D CMG009          S              1                                         CMG009 flag   CMG009
      ** Input Specs
      ** -----------

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode                     Return code
     C                   PARM                    GLMR94                         Request Detail

     C                   EVAL      ReturnCode = *BLANKS                         Return code

      ** Load key fields

     C                   EVAL      KeyNWRK = MRNWRK                             Network
     C                   EVAL      KeyBRCH = MRBRCA                             Branch
     C                   EVAL      KeyCNUM = MRCNUM                             Customer
     C                   EVAL      KeyCCY  = MRCCY                              Currency
     C                   EVAL      KeyACOD = MRACCD                             Account Code
     C                   EVAL      KeyACSQ = MRACSQ                             Account Sequence
     C                   EVAL      KeyNATY = MRNATY                             Net. Account Type
     C                   EVAL      KeyDSTN = MRDSTN                             Destination
     C                   EVAL      KeyMTPY = MRMTPY                             Message Type

     C                   EVAL      PrcAccnt = 'Y'                               Process Account

      ** Retrieve Account details.

     C                   EXSR      $RtvAccNo

      ** If the account should not be treated, go to the end of processing.

     C                   IF        PrcAccnt = 'N'
     C                   GOTO      EndProc
     C                   ENDIF

      ** Read each Movement corresponding to Midas Account.

     C     KeyMvnt       SETLL     RSACMTPO
     C     KeyMvnt       READE     RSACMTPO                               27
     C                   DOW       NOT *IN27

     C                   EVAL      PrcMvnt = 'Y'                                Process Movement
     C                   EVAL      PRCGLPN = 'Y'                                UpdGLPOSTPD MD032299
     C                   EVAL      PRCRSMN = 'Y'                                UpdGLRSACPD MD032299

      ** Check if the movement has been already processed.

     C                   EXSR      $UsedMvnt

     C                   IF        PrcMvnt = 'Y'

      ** Retrieve Transaction Type Details

     C                   EXSR      $RtvTrType

      ** Load Posting fields

     C                   EXSR      $LoadFld

     C                   ENDIF

     C                   IF        PrcMvnt = 'Y'

     C                   IF        PRCGLPN = 'Y'                                            MD032299
      ** Add record in Posting file.

     C                   WRITE     GLPOSTD0
     C                   ENDIF                                                              MD032299

     C                   IF        PRCRSMN = 'Y'                                            MD032299
      ** Add record in Used Account Movement.

     C                   EVAL      MGNWRK   = MRNWRK                            Network
     C                   EVAL      MGNATY   = MRNATY                            Net. Account Type
     C                   EVAL      MGDSTN   = MRDSTN                            Destination
     C                   EVAL      MGMTPY   = MRMTPY                            Message Type
     C                   WRITE     GLRSACD0
     C                   COMMIT
     C                   ENDIF                                                              MD032299
     C                   ENDIF

      ** Read next Movement corresponding to Midas Account.

     C     KeyMvnt       READE     RSACMTPO                               27

     C                   ENDDO

     C     EndProc       TAG

     C                   EVAL      *INLR = *ON

      *========================================================================*
      * $RtvAccNo : Retrieve Retail Account Number                             *
      *------------------------------------------------------------------------*

     C     $RtvAccNo     BEGSR
      *    ---------     -----

     C                   EVAL      P@BRCH = MRBRCA
     C                   MOVEL(P)  MRCNUM        P@CUSN
     C                   EVAL      P@CURR = MRCCY
     C                   MOVEL     MRACCD        P@CODE
     C                   MOVEL     MRACSQ        P@SEQU

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@ACNO
     C                   PARM                    P@CUSN
     C                   PARM                    P@CURR
     C                   PARM                    P@CODE
     C                   PARM                    P@SEQU
     C                   PARM                    P@BRCH
     C     ACCNT         PARM      ACCNT         DSSDY

      ** If no record found in ACCNTAB, do not process the account.

     C     P@RTCD        IFNE      *BLANKS                                      Begin P@RTCD
     C                   EVAL      PrcAccnt = 'N'                               Process Account
     C                   EVAL      ReturnCode = 'Error'                         Return code
     C                   END                                                    End P@RTCD

      *    ---------     -----
     C     @RtvAccNo     ENDSR

      *========================================================================*
      * $UsedMvnt: Check if the Movement has been already processed.           *
      *------------------------------------------------------------------------*

     C     $UsedMvnt     BEGSR
      *    ---------     -----

      **  The processing retrieves only movements to post during this COB.

     C                   IF        PTDT >= BJDNWD
     C                   EVAL      PrcMvnt = 'N'
     C                   GOTO      @UsedMvnt
     C                   ENDIF

     C                   IF        CMG009 = 'Y'                                               CMG009
     C                             AND  PTDT =  BJRDNB                                        CMG009
     C                             AND  VUDT >  BJRDNB                                        CMG009
     C                   EVAL      PrcMvnt = 'N'                                              CMG009
     C                   GOTO      @UsedMvnt                                                  CMG009
     C                   ENDIF                                                                CMG009

      **  This routine verifies if the movement has been already processed.
      **  In fact, the processing checks if the movement is in LF/GLRSACL0.

     C                   EVAL      CmpNWRK  = MRNWRK                            Network
     C                   EVAL      CmpNATY  = MRNATY                            Net. Account Type
     C                   EVAL      CmpDSTN  = MRDSTN                            Destination
     C                   EVAL      CmpMTPY  = MRMTPY                            Message Type
     C                   EVAL      CmpDetail= DsCurrMvnt                        Current Movement

     C     KeyUseMvnt    SETLL     GLRSACL0
     C     KeyUseMvnt    READE     GLRSACL0                               28

     C                   DOW       NOT *IN28
     C                             AND PrcMvnt = 'Y'
     C                   IF        DsCmpMvnt = DsUsedMvnt
     C                   EVAL      PrcMvnt = 'N'
     C                   LEAVE
     C                   ENDIF

     C     KeyUseMvnt    READE     GLRSACL0                               28

     C                   ENDDO
      ** check if authorised Payment if FT
b1   C                   Select                                                             MD032299
b1    ** If Dealing Overnight movement for today                                            MD032299
      * ETYP is Blank for Input cycle input and Value date can be in the past.              MD034442
b1   C                   When      CMod = 'DL'     And                                      MD032299
b1   C**********                   Etyp <> *Blanks And                             MD032299 MD034442
b1   C**********                   VuDt >= BjRdnb  And                             MD032299 MD034442
b1   C                             VuDt <  BjDnwd                                           MD032299
     C                   Eval      PRCGLPN = 'Y'                                            MD032299
     C                   Eval      PRCRSMN = 'Y'                                            MD032299
b1    ** If Lending overnight movement for today                                            MD032299
      * ETYP is Blank for Input cycle input and Value date can be in the past.              MD034442
b1   C                   When      CMod = 'LE'     And                                      MD032299
b1   C**********                   Etyp <> *Blanks And                             MD032299 MD034442
b1   C**********                   VuDt >= BjRdnb  And                             MD032299 MD034442
b1   C                             VuDt <  BjDnwd                                           MD032299
     C                   Eval      PRCGLPN = 'Y'                                            MD032299
     C                   Eval      PRCRSMN = 'Y'                                            MD032299
b1   C                   When      FUND <> *BLANKS                                          MD032299
b1   C                   When      FUND <> *BLANKS                                          MD032299
     C                   EVAL      GLPREF  = FUND                                           MD032299
     C     GLPREF        CHAIN     INPAY                              99                    MD032299
b2   C                   IF        NOT *IN99                                                MD032299
b3   C                   IF        AUIN = 'Y'                                               MD032299
     C                   EVAL      PRCGLPN = 'Y'                                            MD032299
     C                   EVAL      PRCRSMN = 'Y'                                            MD032299
x3   C                   ELSE                                                               MD032299
     C                   EVAL      PRCGLPN = 'N'                                            MD032299
     C                   EVAL      PRCRSMN = 'N'                                            MD032299
e3   C                   ENDIF                                                              MD032299
x2   C                   ELSE                                                               MD032299
     C     GLPREF        CHAIN     OTPAY                              99                    MD032299
b3   C                   IF        NOT *IN99                                                MD032299
b4   C                   IF        AUIN = 'Y'                                               MD032299
     C                   EVAL      PRCGLPN = 'Y'                                            MD032299
     C                   EVAL      PRCRSMN = 'Y'                                            MD032299
x4   C                   ELSE                                                               MD032299
     C                   EVAL      PRCGLPN = 'N'                                            MD032299
     C                   EVAL      PRCRSMN = 'N'                                            MD032299
e4   C                   ENDIF                                                              MD032299
      *  If Not found on INPAY AND OPAY  check NTRAN1                                       MD034442
x3   C                   ELSE                                                               MD034442
     C*****GLPREF        CHAIN     NTRAN1                             99           MD034442 MD036398
     C     GLPREF        CHAIN     NTRAN                              99                    MD036398
      *  If found on OPAY                                                                   MD034442
b4   C                   If        NOT *IN99                                                MD034442
      *  Test if authorised                                                                 MD034442
b5   C                   IF        AUIN = 'Y'                                               MD034442
     C                   EVAL      PRCGLPN = 'Y'                                            MD034442
     C                   EVAL      PRCRSMN = 'Y'                                            MD034442
x5   C                   ELSE                                                               MD034442
     C                   EVAL      PRCGLPN = 'N'                                            MD034442
     C                   EVAL      PRCRSMN = 'N'                                            MD034442
e5   C                   ENDIF                                                              MD034442
x4   C                   ELSE                                                               MD034442
      *  If Not found on INPAY AND OPAY  and NTRAN1                                         MD034442
     C                   EVAL      PRCGLPN = 'N'                                            MD034442
     C                   EVAL      PRCRSMN = 'N'                                            MD034442
e4   C                   ENDIF                                                              MD034442
e3   C                   ENDIF                                                              MD032299
e2   C                   ENDIF                                                              MD032299
x1   C                   Other                                                              MD032299
     C**********         EVAL      PRCGLPN = 'N'                                   MD032299 MD039029
     C                   EVAL      PRCGLPN = 'Y'                                            MD039029
     C                   EVAL      PRCRSMN = 'Y'                                            MD032299
e1   C                   Endsl                                                              MD032299


      *    ---------     -----
     C     @UsedMvnt     ENDSR

      *========================================================================*
      * $RtvTrType: Retrieve Transaction Type Detail                           *
      *------------------------------------------------------------------------*

     C     $RtvTrType    BEGSR
      *    ----------    -----

     C                   EVAL      TrIdx = 1

      ** Load search argument according transaction type.

     C                   SELECT
     C                   WHEN      %SUBST(XRFI:1:2) = 'ZS'                      CM Zero Bal   CRE008
     C                   EVAL      WkTRYP = 'ZS'                                              CRE008
     C/COPY WNCPYSRC,GLH00623
     C                   WHEN      %SUBST(TRYP:1:1) = 'H'                       Loan Type
     C                   EVAL      WkTRYP = 'Hx'
     C                   WHEN      %SUBST(TRYP:1:1) = 'J'                       Loan Type
     C                   EVAL      WkTRYP = 'Jx'
     C                   WHEN      %SUBST(TRYP:1:1) = 'K'                       Loan Type
     C                   EVAL      WkTRYP = 'Kx'
     C                   WHEN      TRYP = 'OP'                                  FT Outgoing
     C                             AND FUND <> *BLANKS                          Payment
     C                   EVAL      WkTRYP = 'OF'
     C                   OTHER
     C                   EVAL      WkTRYP = TRYP
     C                   ENDSL

      ** Retrieve Transaction Type details.

     C     WkTRYP        LOOKUP    TrType(TrIdx)                          99

      *    ----------    -----
     C     @RtvTrType    ENDSR

      *========================================================================*
      * $LoadFld  : Load Posting fields                                        *
      *------------------------------------------------------------------------*

     C     $LoadFld      BEGSR
      *    --------      -----

     C                   CLEAR                   GLPOSTD0

     C                   EVAL      GLRECI  = 'S'                                Record Id
     C                   EVAL      GLCNUM  = CUSN                               Customer number
     C                   EVAL      GLCCY   = CCYD                               Currency code
     C                   EVAL      GLACOD  = ACDE                               Account code
     C                   EVAL      GLACSQ  = ASNC                               Account sequence num
     C                   EVAL      GLACNO  = ACACNO                             Retail account numbe
     C                   EVAL      GLPSTD  = PTDT                               Posting date
     C                   EVAL      GLVALD  = VUDT                               Value date
     C                   IF        TrModule(TrIdx) = 'GL'
     C                             AND NRTC <> *BLANKS
     C                             AND NRTC <> '00'
     C                   EXSR      $RtvPosNar                                   Rtv.Posting Narr.
     C                   EVAL      GLPNAR  = WkNARR                             Posting narrative
     C                   ELSE
     C                   EVAL      GLPNAR  = NRTD                               Posting narrative
     C                   ENDIF
     C                   EVAL      GLPSTA  = MVAM                               Posting amount
     C                   EVAL      GLDRCR  = DORC                               Debit/credit indicat
     C                   EVAL      GLCHQN  = CQNR                               Cheque number
     C                   IF        TrModule(TrIdx) = 'GL'                       General Ledger Mod.
     C                             And TRYP <> 'L'                                         CAP204
     C                   EVAL      GLSPOS  = TNMR                               Source of posting
     C                   ELSE                                                  Other Module
     C                   EVAL      GLSPOS  = TrSPOS(TrIdx)                      Source of posting
     C                   ENDIF
     C                   EVAL      GLBRCA  = BRCA                               Branch Code - Alpha
     C                   EVAL      GLGETP  = TrGETP(TrIdx)                      Generated entry type
     C                   IF        TRYP = 'CE'                                  Customer Exchange
     C                   EVAL      GLRINO  = TNMR                               Retail Input Number
     C                   ENDIF
     C                   SELECT
     C                   WHEN      TrModule(TrIdx) = 'DL'                       Dealing Module
     C                   EVAL      GLDLREF = 'D' + TNMR                         deal reference
     C                   WHEN      TrModule(TrIdx) = 'LE'                       Lending Module
     C                   EVAL      GLDLREF = 'L' + TNMR                         loan reference
     C                   ENDSL
     C                   EVAL      GLPREF  = FUND                               PAYMENT REF
     C                   IF        TrModule(TrIdx) = 'FT'                       FT Module
     C                   EVAL      GLOTRF  = FUND                               Origional transactio
                                                                                            BUG22558
     C                   IF        CER031 = 'Y'                                             BUG22558
                                                                                            BUG22558
     C                   IF        TrType(TrIdx) = 'IN'                                     BUG22558
     C     GLPREF        CHAIN     INPAY                              99                    BUG22558
     C                   IF        NOT *IN99                                                BUG22558
     C                   MOVE      IRTTY         GLTRAT                                     BUG22995
     C                   EVAL      GLMGADI1 = IEXT1                                         BUG22558
     C                   EVAL      GLMGADI2 = IEXT2                                         BUG22558
     C                   EVAL      GLMGADI3 = IEXT3                                         BUG22558
     C                   EVAL      GLMGADI4 = IEXT4                                         BUG22558
     C                   EVAL      GLMGADI5 = IEXT5                                         BUG22558
     C                   EVAL      GLMGADI6 = IEXT6                                         BUG22558
     C                   ENDIF                                                              BUG22558
     C                   ENDIF                                                              BUG22558
     C                   IF        TrType(TrIdx) = 'OF'                                     BUG22558
     C*****GLPREF        CHAIN     OTPAY                                           BUG22558 BUG22687
     C     GLPREF        CHAIN     OTPAY                              99                    BUG22687
     C                   IF        NOT *IN99                                                BUG22558
     C                   MOVE      OPRTTY        GLTRAT                                     BUG22995
     C                   IF        GLDRCR = 0                                               BUG22558
     C                   EVAL      GLMGADI1 = OPEXT1                                        BUG22558
     C                   EVAL      GLMGADI2 = OPEXT2                                        BUG22558
     C                   EVAL      GLMGADI3 = OPEXT3                                        BUG22558
     C                   EVAL      GLMGADI4 = OPEXT4                                        BUG22558
     C                   EVAL      GLMGADI5 = OPEXT5                                        BUG22558
     C                   EVAL      GLMGADI6 = OPEXT6                                        BUG22558
     C                   ELSE                                                               BUG22558
     C                   EVAL      GLMGADI1 = OPEXC1                                        BUG22558
     C                   EVAL      GLMGADI2 = OPEXC2                                        BUG22558
     C                   EVAL      GLMGADI3 = OPEXC3                                        BUG22558
     C                   EVAL      GLMGADI4 = OPEXC4                                        BUG22558
     C                   EVAL      GLMGADI5 = OPEXC5                                        BUG22558
     C                   EVAL      GLMGADI6 = OPEXC6                                        BUG22558
     C                   ENDIF                                                              BUG22558
     C                   ENDIF                                                              BUG22558
     C                   ENDIF                                                              BUG22558
                                                                                            BUG22558
     C                   ENDIF                                                              BUG22558
      *                                                                                     BUG22558
     C                   ELSE                                                   Other Modules
     C                   IF        TRYP = 'L'                                                 CAP204
     C                   EVAL      GLOTRF  = OTR1                                             CAP204
     C                   ELSE                                                                 CAP204
     C                   EVAL      GLOTRF  = TNMR                               Origional transactio
     C                   ENDIF                                                                CAP204
     C                   ENDIF
     C                   EVAL      GLOTTP  = TRYP                               Origional transactio
     C/COPY WNCPYSRC,GLH00397
     C                   IF        TrModule(TrIdx) = 'GL'
     C/COPY WNCPYSRC,GLH00398
      *                                                                                     BUG23284
     C     KeyAddInf1    CHAIN     GLJENPL1                           99                    BUG23284
     C                   IF        NOT *IN99                                                BUG23284
     C                   MOVE      BTTRTY        GLTRAT                                     BUG23284
     C                   MOVE      BTSWCR        GLSWCR                                     BUG25226
     C                   ENDIF                                                              BUG23284
      *                                                                                     BUG23284
     C     KeyAddInf     CHAIN     GLJENXL1                           99
     C                   IF        NOT *IN99
     C                   EVAL      GLMGADI1 = BAADI1                            Additional Inf. 1
     C                   EVAL      GLMGADI2 = BAADI2                            Additional Inf. 2
     C                   EVAL      GLMGADI3 = BAADI3                            Additional Inf. 3
     C                   EVAL      GLMGADI4 = BAADI4                            Additional Inf. 4
     C                   EVAL      GLMGADI5 = BAADI5                            Additional Inf. 5
     C                   EVAL      GLMGADI6 = BAADI6                            Additional Inf. 6
     C                   EVAL      GLMGAERI = BAAERI                            ERI Indicator
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00624
     C                   EVAL      GLMGNWRK = MRNWRK                            Network
     C                   EVAL      GLMGNATY = MRNATY                            Net. Account Type
     C                   EVAL      GLMGDSTN = MRDSTN                            Destination
     C                   EVAL      GLMGMTPY = MRMTPY                            Message type
     C                   EVAL      GLMGPROC = *BLANKS                           Processed Indicator
                                                                                              CRE008
      *  If Load subfield 61 details if posting is zero balancing/sweeping                    CRE008
     C                   If        CRE008 = 'Y'                                               CRE008
     C                   Exsr      SRZSLOAD                                                   CRE008
     C                   Exsr      SRGALOAD                                                   216937
     C                   Endif                                                                CRE008

     C     @LoadFld      ENDSR
      *    --------      -----
     C/COPY WNCPYSRC,GLH00399

      *========================================================================*
      * $RtvPosNar: Retrieve Posting Narrative                                 *
      *------------------------------------------------------------------------*

     C     $RtvPosNar    BEGSR
      *    ----------    -----

     C                   EVAL      WkNARR = *BLANKS

     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      NRTC          P@NVCD
     C     SDNARR        PARM      SDNARR        DSFDY

     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WkNARR = ALDON
     C                   ENDIF

      *    ----------    -----
     C     @RtvPosNar    ENDSR

      *========================================================================*
      * SRZSLOAD - Load Zero Blancing/Sweeping fld 61 details                  *              CRE008
      *------------------------------------------------------------------------*              CRE008
                                                                                              CRE008
     C     SRZSLOAD      BEGSR                                                                CRE008
      *    ----------    -----                                                                CRE008
                                                                                              CRE008
     C                   If        XRFI = 'ZS '                                               CRE008
     C     KeyGLPZS      Chain     GLPSTZSL0                          29                      CRE008
     C                   If        *IN29 = *Off                                               CRE008
     C                   EVAL      GLMGZ616 = AZF616                                          CRE008
     C                   EVAL      GLMGZ617 = AZF617                                          CRE008
     C                   EVAL      GLMGZ618 = AZF618                                          CRE008
     C                   EVAL      GLMGZ619 = AZF619                                          CRE008
     C                   EVAL      GLMGZ861 = AZF861                                          CRE008
     C                   EVAL      GLMGZ862 = AZF862                                          CRE008
     C                   EVAL      GLMGZ863 = AZF863                                          CRE008
     C                   EVAL      GLMGZ865 = AZF864                                          CRE008
     C                   EVAL      GLMGZ865 = AZF865                                          CRE008
     C                   EVAL      GLMGZ866 = AZF866                                          CRE008
     C                   Endif                                                                CRE008
     C                   Endif                                                                CRE008
                                                                                              CRE008
      *    ----------    -----                                                                CRE008
     C     @SRZSLOAD     ENDSR                                                                CRE008
                                                                                              CRE008
      *========================================================================*              216937
      * SRGALOAD - Load Group Accounting source account                        *              216937
      *------------------------------------------------------------------------*              216937
                                                                                              216937
     C     SRGALOAD      BEGSR                                                                216937
      *    ----------    -----                                                                216937
                                                                                              216937
     C                   EVAL      GLMGSRCA = *blanks                                         216937
                                                                                              216937
     C                   If        XRFI = 'GA '                                               216937
     C     KeyGLPZS      Chain     GLPSTGAL0                          30                      216937
     C                   If        *IN30 = *Off                                               216937
     C                   If        AGSRNO <> 0                                                216937
     C                   Movel     AGSRNO        WWSRNO           10                          216937
     C                   Eval      GLMGSRCA = 'ORIGINATING ACCOUNT ' + WWSRNO                 216937
     C                   Else                                                                 216937
     C                   Movel     AGSCUS        WWSCUS            6                          216937
     C**********         Movel     AGSACD        WWSACD            4                   216937 CGL029
     C                   Movel     AGSACD        WWSACD           10                          CGL029
     C                   Movel     AGSASN        WWSASN            2                          216937
     C                   EVAL      GLMGSRCA = 'ORIGINATING ACCOUNT ' + AGSBRC +               216937
     C                                        WWSCUS + AGSCCY + WWSACD + WWSASN               216937
     C                   Endif                                                                216937
     C/COPY WNCPYSRC,GLH00400
     C                   Endif                                                                216937
     C/COPY WNCPYSRC,GLH00412
     C                   Endif                                                                216937
                                                                                              216937
      *    ----------    -----                                                                216937
     C     @SRGALOAD     ENDSR                                                                216937
                                                                                              216937
      *========================================================================*              216937
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBpgm = PSProcPgm
     C                   OUT       LDA
                                                                                              CRE008
     C/COPY WNCPYSRC,GLH00401
      ** Check if feature CRE008 (Cash Management feature) is installed                       CRE008
                                                                                              CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
                                                                                              CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CRE008
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CRE008
     C                   PARM      'CRE008 '     P@SARD                         Feature Ref.  CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
     C                   IF        P@RTCD = *BLANKS                                           CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ENDIF                                                                CRE008
     C/COPY WNCPYSRC,GLH00625
                                                                                            BUG22558
      ** Check if CER031 is switched on                                                     BUG22558
                                                                                            BUG22558
     C                   CALLB     'AOSARDR0'                                               BUG22558
     C                   PARM      *BLANKS       P@RTCD                                     BUG22558
     C                   PARM      '*VERIFY'     P@OPTN                                     BUG22558
     C                   PARM      'CER031'      P@SARD                                     BUG22558
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22558
                                                                                            BUG22558
     C                   IF        P@RTCD = *BLANKS                                         BUG22558
     c                   EVAL      CER031 = 'Y'                                             BUG22558
     C                   ELSE                                                               BUG22558
     c                   EVAL      CER031 = 'N'                                             BUG22558
     c                   ENDIF                                                              BUG22558
                                                                                            BUG22558
      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Check if Switchable Feature CAP204 is installed.                                     CAP204
      *                                                                                       CAP204
     C                   MOVEL     'N'           CAP204            1                          CAP204
     C                   CALL      'AOSARDR0'                                                 CAP204
     C                   PARM      *BLANKS       P@RTCD                                       CAP204
     C                   PARM      '*VERIFY'     P@OPTN                                       CAP204
     C                   PARM      'CAP204'      P@SARD                                       CAP204
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP204
                                                                                              CAP204
     C                   IF        P@RTCD = *BLANKS                                           CAP204
     C                   EVAL      CAP204 = 'Y'                                               CAP204
     C                   ENDIF                                                                CAP204
      *                                                                                       CAP204
     C                   IF        P@RTCD <> *BLANK AND                                       CAP204
     C                             P@RTCD <> '*NRF   '                                        CAP204
     C                   SETON                                        U7U8LR                  CAP204
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP204
     C                   MOVEL     P@RTCD        DBKEY                                        CAP204
     C                   Z-ADD     1             DBASE                                        CAP204
     C                   EXSR      *PSSR                                                      CAP204
     C                   END                                                                  CAP204
      *                                                                                       CAP204
      ** Check if feature CMG009 (MT942 without Forward Value Postings) is installed          CMG009
                                                                                              CMG009
     C                   EVAL      CMG009 = 'N'                                               CMG009
                                                                                              CMG009
     C                   CALLB     'AOSARDR0'                                                 CMG009
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CMG009
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CMG009
     C                   PARM      'CMG009 '     P@SARD                         Feature Ref.  CMG009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG009
                                                                                              CMG009
     C                   IF        P@RTCD = *BLANKS                                           CMG009
     C                   EVAL      CMG009 = 'Y'                                               CMG009
     C                   ENDIF                                                                CMG009
      ** Key List to access Movements LF/RSACMTL2

     C     KeyMvnt       KLIST
     C                   KFLD                    KeyBRCH
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACOD
     C                   KFLD                    KeyACSQ

      ** Key List to access Used Movements LF/GLRSACL0

     C     KeyUseMvnt    KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCH
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACOD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    KeyDSTN
     C                   KFLD                    KeyMTPY

      ** Key List to access the Batch Item Additional Information.

     C     KeyAddInf     KLIST
     C                   KFLD                    PTDT
     C                   KFLD                    WBatchNb
     C                   KFLD                    WItemNb
                                                                                              CRE008
     C     KeyAddInf1    KLIST                                                              BUG23284
     C                   KFLD                    WBatchNb                                   BUG23284
     C                   KFLD                    WItemNb                                    BUG23284
      ** Key List to access the Posting in Transit Extension file                             CRE008
                                                                                              CRE008
     C     KeyGLPZS      KLIST                                                                CRE008
     C                   KFLD                    XRFI                                         CRE008
     C                   KFLD                    XRFN                                         CRE008

     C/COPY WNCPYSRC,GLH00402
      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    ----------    ------

     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      ReturnCode = 'PSSR_Error'
     C                   ENDIF

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**CTDATA CPY@
(c) Finastra International Limited 2002
**CTDATA TransType
XX XX X   XXXXX Transaction Type Not Found
CE CE E   GE-CE Customer Exchange
NX DL D   GE-DL Nostro Transfer
FR DL D   GE-DL Future Rate Agreements
RS DL D   GE-DL Single Curr. Inter. Rate Swaps
RX DL D   GE-DL Cross Curr. Inter. Rate Swaps
RP DL D   GE-DL Interest Rate Caps
RR DL D   GE-DL Interest Rate Collars
RF DL D   GE-DL Interest Rate Floors
FS DL D   GE-DL Foreign Exchange Sold
FP DL D   GE-DL Foreign Exchange Purchased
CX DL D   GE-DL Cross Deal
OP DL D   GE-DL Option
OT DL D   GE-DL Option Takedown
SW DL D   GE-DL Swap Deal
SI DL D   GE-DL Sale Covering Interest
PI DL D   GE-DL Purchase Covering Interest
IT DL D   GE-DL Interbank Taking
IP DL D   GE-DL Interbank Placing
TD DL D   GE-DL Time Deposit
TI DL D   GE-DL Time Loan
CI DL D   GE-DL CD Issued
CD DL D   GE-DL Call/Notice Deposit Taken
CL DL D   GE-DL Call/Notice Deposit Placed
DL DL D   GE-DL Demand Loan
C1 DL D   GE-DL Primary CD
C2 DL D   GE-DL Secondary CD
BP DL D   GE-DL Bond
BD DL D   GE-DL Bill
TB DL D   GE-DL Tresury Bill
DA DL D   GE-DL Bank Acceptance
TA DL D   GE-DL Trade Acceptance
CS DL D   GE-DL Primary or Secondary CD sold
BS DL D   GE-DL Bond Sold
BR DL D   GE-DL Bill Sold
TS DL D   GE-DL Treasury Bill Sold
RA DL D   GE-DL Bank Acceptance Sold
TR DL D   GE-DL Trade Acceptance Sold
PI DL D   GE-DL Principal Increase
PD DL D   GE-DL Principal Decrease
SC DL D   GE-DL Rate Change
SI DL D   GE-DL Settle Interest
CI DL D   GE-DL Capitalize Interest
IN FT G   GE-FT Incoming Payment
OF FT G   GE-FT Outgoing Payment
CC FT G   GE-FT Cheque to be collected
CP FT G   GE-FT Cheque to be paid
NT FT G   GE-FT Nostro Transfer
RP FT G   GE-FT Regular Outgoing Payments
ME GL           Manual Entry
F1 LE U   GE-LE Fee on Loan
F2 LE U   GE-LE Fee on Facility
Hx LE U   GE-LE Lending Module
Jx LE U   GE-LE Lending Module
Kx LE U   GE-LE Lending Module
SO SO O   GE-SO Standing Orders
TP ST S   GE-ST Trade Purchased
TS ST S   GE-ST Trade Saled
TT TT N   GE-TT Teller Transaction
CO DL T   GE-DL Interest Rate Floors
ZS RE     GE-CX Cash Mgt Zero Bal/Sweeping                                                    CRE008
YT TX L   GE-TX Account Transfer (Single Currency)                                            CAP204
XT TX L   GE-TX Account Transfer (Cross Currency)                                             CAP204
     X/COPY WNCPYSRC,GLH00626
