     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retrieve FF Shadow Post. by Network Acc')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001417 - Midas GL Retrieve FF Shadow Postings by           *
      *             Network Account                                   *
      *                                                               *
      *  Function:  This program retrieves the Shadow postings        *
      *             by Network/Account/Message/Type/Destination.      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG009             Date 24Nov19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CGL013  *CREATE    Date 16Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG009 - MT942 without Forward Value Postings                *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account (recompile)   *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FFFACMV2   IF   E           K DISK                      INFSR(*PSSR)
      ** Midas FF Account Movements.

     FGLFFAML0  IF   E           K DISK                      INFSR(*PSSR)
      ** Midas GL MT94x Used FF Account Movement - Retieval.
     F                                     RENAME(GLFFAMD0:GLFFAMR0)
     F                                     PREFIX(US)

     FGLPOSTPD  O  A E             DISK    COMMIT            INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages.
     F                                     PREFIX(GL)

     FGLFFAMPD  O  A E             DISK    COMMIT            INFSR(*PSSR)
      ** Midas GL MT94x Used FF Account Movement.

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access Account Movement (LF/FFACMV2)                             *
      * 28 - Access Used Account Movement (LF/GLFFAML0)                        *
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

     D DsUsedMvnt    E DS                  EXTNAME(GLFFAMPD)
     D                                     PREFIX(US)
      **  Data structure for Used Movement.

     D DsCurrMvnt    E DS                  EXTNAME(FFACMVD)
      **  Data structure for Current Movement.

     D DsCmpMvnt       DS
      ** Data Structure to compare with Used Movements
     D  CmpNWRK                            LIKE(MGNWRK)                         Network
     D  CmpNATY                            LIKE(MGNATY)                         Net. Account Type
     D  CmpDSTN                            LIKE(MGDSTN)                         Destination
     D  CmpMTPY                            LIKE(MGMTPY)                         Message Type
     D  CmpDetail                          LIKE(DsCurrMvnt)                     FFACMVD Detail

     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC)
      **  Data structure for Account Details.

     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      **  Data structure for Narrative Code.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
                                                                                              CMG009
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CMG009
      **  Data Structure for Switchable features descriptions.                                CMG009

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

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

     D P@RTCD          S              7                                         Return code
     D P@OPTN          S              7                                         Option
     D P@SARD          S              6                                                       CMG009
     D P@ACNO          S             10                                         Retail Acc. Number
     D P@CUSN          S              6                                         Customer Number
     D P@CURR          S              3                                         Currency
     D*P@CODE***       S              4                                         Account Code  CGL029
     D P@CODE          S             10                                                       CGL029
     D P@SEQU          S              2                                         Account Sequence
     D P@BRCH          S              3                                         Branch
     D P@NVCD          S              2                                         Narrative Code

     D PrcAccnt        S              1                                         Process Account
     D PrcMvnt         S              1                                         Process Movement
     D WkNARR          S                   LIKE(GLPNAR)                         Posting Narrative
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

     C     KeyMvnt       SETLL     FFACMVDF
     C     KeyMvnt       READE     FFACMVDF                               27
     C                   DOW       NOT *IN27

     C                   EVAL      PrcMvnt = 'Y'                                Process Movement

      ** Check if the movement has been already processed.

     C                   EXSR      $UsedMvnt

     C                   IF        PrcMvnt = 'Y'

      ** Load Posting fields

     C                   EXSR      $LoadFld

      ** Add record in Posting file.

     C                   WRITE     GLPOSTD0

      ** Add record in Used Account Movement.

     C                   EVAL      MGNWRK   = MRNWRK                            Network
     C                   EVAL      MGNATY   = MRNATY                            Net. Account Type
     C                   EVAL      MGDSTN   = MRDSTN                            Destination
     C                   EVAL      MGMTPY   = MRMTPY                            Message Type
     C                   WRITE     GLFFAMD0
     C                   COMMIT
     C                   ENDIF

      ** Read next Movement corresponding to Midas Account.

     C     KeyMvnt       READE     FFACMVDF                               27

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
      **  In fact, the processing checks if the movement is in LF/GLFFAML0.

     C                   EVAL      CmpNWRK  = MRNWRK                            Network
     C                   EVAL      CmpNATY  = MRNATY                            Net. Account Type
     C                   EVAL      CmpDSTN  = MRDSTN                            Destination
     C                   EVAL      CmpMTPY  = MRMTPY                            Message Type
     C                   EVAL      CmpDetail= DsCurrMvnt                        Current Movement

     C     KeyUseMvnt    SETLL     GLFFAML0
     C     KeyUseMvnt    READE     GLFFAML0                               28

     C                   DOW       NOT *IN28
     C                             AND PrcMvnt = 'Y'
     C                   IF        DsCmpMvnt = DsUsedMvnt
     C                   EVAL      PrcMvnt = 'N'
     C                   LEAVE
     C                   ENDIF

     C     KeyUseMvnt    READE     GLFFAML0                               28

     C                   ENDDO

      *    ---------     -----
     C     @UsedMvnt     ENDSR

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
     C                   IF        NRTC <> *ZEROS
     C                   EXSR      $RtvPosNar                                   Rtv.Posting Narr.
     C                   EVAL      GLPNAR  = WkNARR                             Posting narrative
     C                   ELSE
     C                   EVAL      GLPNAR  = NRTD                               Posting narrative
     C                   ENDIF
     C                   EVAL      GLPSTA  = MVAM                               Posting amount
     C                   EVAL      GLDRCR  = DORC                               Debit/credit indicat
     C                   EVAL      GLCHQN  = CQNR                               Cheque number
     C                   EVAL      GLSPOS  = '  GE-FF'                          Source of posting
     C                   EVAL      GLBRCA  = BRCA                               Branch Code - Alpha
     C                   EVAL      GLGETP  = 'T'                                Generated entry type
     C                   EVAL      GLOTRF  = TNMR                               Origional transactio
     C                   EVAL(R)   GLOTTP  = TRYP                               Origional transactio
     C                   EVAL      GLMGNWRK = MRNWRK                            Network
     C                   EVAL      GLMGNATY = MRNATY                            Net. Account Type
     C                   EVAL      GLMGDSTN = MRDSTN                            Destination
     C                   EVAL      GLMGMTPY = MRMTPY                            Message type
     C                   EVAL      GLMGPROC = *BLANKS                           Processed Indicator

     C     @LoadFld      ENDSR
      *    --------      -----

      *========================================================================*
      * $RtvPosNar: Retrieve Posting Narrative                                 *
      *------------------------------------------------------------------------*

     C     $RtvPosNar    BEGSR
      *    ----------    -----

     C                   MOVE      NRTC          P@NVCD                         Narrative Code
     C                   EVAL      WkNARR = *BLANKS

     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@NVCD
     C     SDNARR        PARM      SDNARR        DSFDY

     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WkNARR = ALDON
     C                   ENDIF

      *    ----------    -----
     C     @RtvPosNar    ENDSR

      *========================================================================*
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

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

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
