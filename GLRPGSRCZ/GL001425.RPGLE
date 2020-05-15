     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retrieve Postings by Network Account')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001425 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Function:  This program retrieves the End of Day postings    *
      *             by Network/Account/Message/Type/Destination.      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. EML104             Date 04Feb20               *
      *  Prev Amend No. EML102             Date 22Nov19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD026965           Date 16May14               *
      *                 CGL135A            Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22979A          Date 12Mar09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 23May02               *
      *                 CGL013  *CREATE    Date 11Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade of EML010 to FBM2.1 SP21                    *
      *       EML010 - Structured field :86:                          *
      *             Use hook: GLH00520                                *
      *             Amend hooks: EML102_019 EML102_011 EML102_021     *
      *                          EML102_013                           *
      *             Add hooks: EML104_002 EML104_003                  *
      *  EML102 - Upgrade of UNL007, EML004 to FB2.1 SP21             *
      *       EML004 - Extended Narrative                             *
      *             Add Hooks: EML102_019 EML102_020 EML102_021       *
      *                        EML102_022                             *
      *       UNL007 - Extended Narratives                            *
      *             Add Hooks: EML102_010 EML102_011 EML102_012       *
      *                        EML102_013                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD026965 - MT940 COB Extract Issue                           *
      *             Amended hook: CGL135_019                          *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_018, CGL135_019, CGL135_020    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22979A - Wrong extended narratives output in MT940        *
      *  CER030 - Multicash German Feature                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account               *
      *  CRE008 - Cash Management                                     *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNWACL3  IF   E           K DISK    INFDS(@INFDS1) INFSR(*PSSR)
      ** Midas GL Network Accounts - By Account Number.

     FGLEODPL1  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL End of Day Postings.

     FEODPOPPD  IF   E           K DISK    PREFIX(EX)     INFSR(*PSSR)
      ** Midas GL COB Posting Detail Extension.

     FGLJENXL1  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Journal Entry - Add. Inf. - Retrieval Ind.
                                                                                              CRE008
     FGLAPSZSL0 IF   E           K DISK                      INFSR(*PSSR)                     CRE008
      ** Midas GL Postings - Zero Bal/Sweep Exts                                              CRE008
                                                                                              216937
     FGLAPSGAL0 IF   E           K DISK                      INFSR(*PSSR)                     216937
      ** Midas GL Postings - Group Accounts Exts                                              216937

     F/COPY WNCPYSRC,GLH00628
     FGLPOSTPD  O  A E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages.

      /COPY WNCPYSRC,EML102_010                                                               EML102
      *                                                                                       EML102
     FGLUCTLPD  UF A E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas GL Update Control file.
     F/COPY WNCPYSRC,GLH00518

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access Network Account (LF/GLNWACL3)                              *
      * 28 - Access Network Account (LF/GLNWACL3)                              *
      * 29 - Access Posting (LF/GLEODPL1)                                      *
      * 30 - Access ZS Postings  Ext (LF/GLAPSTZSL0)                           *              CRE008
      * 31 - Access GA Postings  Ext (LF/GLAPSTGAL0)                           *              216937
      *                                                                        *
      * 71 - Process Network Account                                           *
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
     D/COPY WNCPYSRC,GLH00519

     D @INFDS1       E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure.

     D LastAccnt     E DS                  EXTNAME(GLUCTLPD)
      ** Data structure to keep the last commited account.
                                                                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)                       CRE008
      **  Data Structure for Switchable features descriptions.                                CRE008
                                                                                              CRE008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE008
      **  Second DS for access programs, short data structure.                                CRE008
     D/COPY WNCPYSRC,GLH00520

     D CurrAccnt       DS
      ** Data structure to keep the current account processed.
     D  NwAcBRCH                      3A                                        Branch
     D**NwAcCNUM                      6S 0                                      Customer      CSD027
     D  NwAcCNUM                      6A                                        Customer      CSD027
     D  NwAcCCY                       3A                                        Currency
     D**NwAcACOD                      4S 0                                      Account Code  CGL029
     D  NwAcACOD                     10S 0                                                    CGL029
     D  NwAcACSQ                      2S 0                                      Account Sequence

     D NwAcDtl         DS                  OCCURS (9999)
      ** Multi-occurence data structure keep Network, Message Type and Destination
      ** detail to process by Midas Account.
     D  NwAcNWRK                      6A                                        Network
     D  NwAcNATY                      1A                                        Net. Account Type
     D  NwAcDSTN                     11A                                        Destination
     D  NwAcMTPY                      3A                                        Message Type

     D                 DS
      ** Data Structure to retrieve the Batch Number and the Item Number
     D SPOS                           7A                                        Source of Posting
     D  WBatchNb               1      3A                                        Batch Number
     D  WItemNb                4      6S 0                                      Item Number

     D                 DS
      ** Data Structure to avoid decimal error
     D NITMS                          5P 0                                      Number of items
     D WNITMS                  1      3A
     D                 DS
      ** Data Structure to avoid decimal error
     D CHGA                          13P 0                                      Charge amount
     D WCHGA                   1      7A
     D                 DS
      ** Data Structure to avoid decimal error
     D ORAMT                         13P 0                                      Original Amt - Giro
     D WORAMT                  1      7A
     D/COPY WNCPYSRC,GLH00403

     D/COPY WNCPYSRC,EML102_019                                                               EML102
      ** Declared variables
      ** ------------------

     D KeyBRCH         S                   LIKE(BRCA)                           Branch
     D KeyCNUM         S                   LIKE(CNUM)                           Customer
     D KeyCCY          S                   LIKE(CCY)                            Currency
     D KeyACOD         S                   LIKE(ACOD)                           Account Code
     D KeyACSQ         S                   LIKE(ACSQ)                           Account Sequence

     D NbNwAC          S              5U 0 INZ(0)                               Number of Occurance
     D X               S              5U 0 INZ(0)                               Working Field
     D CRE008          S              6                                         CRE008 flag   CRE008
     D P@RTCD          S              7                                         Return code   CRE008
     D P@OPTN          S              7                                         Option        CRE008
     D P@SARD          S              6                                         Sar           CRE008
     D/COPY WNCPYSRC,GLH00461
      *                                                                                       CER030
     D CER031          S              1                                                       CER030
     D PRtcd           S              7                                                       CER030
     D POptn           S              7                                                       CER030
     D PSard           S              6                                                       CER030
     D/COPY WNCPYSRC,GLH00783
      *                                                                                      CGL135A
      /COPY OFCPYSRCZ,CGL135_020                                                             CGL135A
      *                                                                                       CER030
      /COPY WNCPYSRC,EML102_011                                                               EML102

      ** Input Specs
      ** -----------

     IGLNWACD0
      ** Rename key fields
     I              NABRCH                      NwAcBRCH
     I              NACNUM                      NwAcCNUM
     I              NACCY                       NwAcCCY
     I              NAACOD                      NwAcACOD
     I              NAACSQ                      NwAcACSQ

     IGLNW94D0
      ** Rename key fields
     I              N4BRCA                      NwAcBRCH
     I              N4CNUM                      NwAcCNUM
     I              N4CCY                       NwAcCCY
     I              N4ACCD                      NwAcACOD
     I              N4ACSQ                      NwAcACSQ

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Position on account (restart)

     C                   EXSR      $PosAccnt

      ** Read each Network Account

     C                   READ      GLNWACL3                               27
     C                   DOW       NOT *IN27

      ** Load key fields

     C                   EVAL      KeyBRCH = NwAcBRCH
     C                   EVAL      KeyCNUM = NwAcCNUM
     C                   EVAL      KeyCCY  = NwAcCCY
     C                   EVAL      KeyACOD = NwAcACOD
     C                   EVAL      KeyACSQ = NwAcACSQ

      ** Check if a posting exists for the Midas Account corresponding to the Network Account

     C     KeyPost       SETLL     GLEODPL1                               71

      ** Retrieve all Network Accounts corresponding to the Midas Account

     C   71              EXSR      $RtvNwrAcc

      ** For each posting corresponding to Midas Account, add a record in GLPOSTPD
      ** for each Network Account / Message Type / Destination.

     C   71              EXSR      $LoadPsts

      ** Update control file with the last account processed.

     C                   EXSR      $LoadCtl

     C                   COMMIT

      ** Position to the Network Account corresponding to the next Midas Account.

     C     KeyPost       SETGT     GLNWACL3
     C                   READ      GLNWACL3                               27
     C                   ENDDO

     C                   EVAL      *INLR = *On
     C                   RETURN
      *

      *========================================================================*
      * $RtvNwrAcc : Retrieve Network/Message Type/Destination to process by   *
      *              Midas Account                                             *
      *------------------------------------------------------------------------*

     C     $RtvNwrAcc    BEGSR
      *    ----------    -----

      ** Clear the detail corresponding to previous account.

     C                   IF        NbNwAC > 0
     C     1             DO        NbNwAC        X
     C     X             OCCUR     NwAcDtl
     C                   CLEAR                   NwAcDtl
     C                   ENDDO
     C                   ENDIF

     C                   EVAL      NbNwAC = 0                                   Number occurence

      ** For each Network Account corresponding to the Midas account,
      ** load the Multi-occurence data structure with:
      ** - Network
      ** - Message Type
      ** - Destination

     C                   DOU       *IN28

     C                   SELECT

      ** If the Network Account comes from GLNWACPD => MT950 detail

     C                   WHEN      @1FFM = 'GLNWACD0'

      ** Generate MT950

     C                   IF        NAG950 = 'Y'                                 Generate MT950 flag
     C                   EVAL      NbNwAC = NbNwAC + 1
     C     NbNwAC        OCCUR     NwAcDtl
     C                   EVAL      NwAcNWRK = NANWRK                            Network
     C                   EVAL      NwAcNATY = NANATY                            Net. Account Type
     C                   EVAL      NwAcDSTN = *BLANKS                           Destination
     C                   EVAL      NwAcMTPY = '950'                             Message Type
     C                   ENDIF


      ** If the Network Account comes from GLNW94PD => MT94x detail

     C                   WHEN      @1FFM = 'GLNW94D0'

      ** Generate MT940

     C                   IF        N4G940 = 'Y'                                 Generate MT940 flag
     C                   EVAL      NbNwAC = NbNwAC + 1
     C     NbNwAC        OCCUR     NwAcDtl
     C                   EVAL      NwAcNWRK = N4NWRK                            Network
     C                   EVAL      NwAcNATY = N4NATY                            Net. Account Type
     C                   EVAL      NwAcDSTN = N4DSTN                            Destination
     C                   EVAL      NwAcMTPY = '940'                             Message Type
     C                   ENDIF

      ** Generate MT941

     C                   IF        N4G941 = 'Y'                                 Generate MT941 flag
     C                   EVAL      NbNwAC = NbNwAC + 1
     C     NbNwAC        OCCUR     NwAcDtl
     C                   EVAL      NwAcNWRK = N4NWRK                            Network
     C                   EVAL      NwAcNATY = N4NATY                            Net. Account Type
     C                   EVAL      NwAcDSTN = N4DSTN                            Destination
     C                   EVAL      NwAcMTPY = '941'                             Message Type
     C                   ENDIF

      ** Generate MT942

     C                   IF        N4G942 = 'Y'                                 Generate MT942 flag
     C                   EVAL      NbNwAC = NbNwAC + 1
     C     NbNwAC        OCCUR     NwAcDtl
     C                   EVAL      NwAcNWRK = N4NWRK                            Network
     C                   EVAL      NwAcNATY = N4NATY                            Net. Account Type
     C                   EVAL      NwAcDSTN = N4DSTN                            Destination
     C                   EVAL      NwAcMTPY = '942'                             Message Type
     C                   ENDIF
     C                   ENDSL

     C     KeyPost       READE     GLNWACL3                               28
     C                   ENDDO

      *    ----------    -----
     C     @RtvNwrAcc    ENDSR

      *========================================================================*
      * $LoadPsts : Load Postings by Account/Network/Message Type/Destination *
      *------------------------------------------------------------------------*

     C     $LoadPsts     BEGSR
      *    ---------     -----

      ** Read the first Posting corresponding to the Midas account of
      ** Network Account

     C     KeyPost       READE     GLEODPL1                               29
     C                   DOW       NOT *IN29
     C/COPY WNCPYSRC,GLH00784
                                                                                             CGL135A
     C/COPY OFCPYSRCZ,CGL135_019                                                             CGL135A

      ** Correct the invalid fields

     C                   EXSR      $CorrFld

      ** Manage the Additional Fields

     C                   EXSR      $AddInf
     C/COPY WNCPYSRC,EML102_020                                                               EML102

      *  Load subfield 61 details if posting is zero balancing/sweeping                       CRE008
     C                   If        CRE008 = 'Y'                                               CRE008
     C                   Exsr      SRZSLOAD                                                   CRE008
     C                   Exsr      SRGALOAD                                                   216937
     C                   Endif                                                                CRE008
     C/COPY WNCPYSRC,EML104_002                                                               EML104

      ** For each Network, Message Type, Destination of the Midas Account,
      ** duplicate the posting in PF/GLPOSTPD.

     C     1             DO        NbNwAC        X
     C     X             OCCUR     NwAcDtl
     C                   EVAL      MGNWRK = NwAcNWRK                            Network
     C                   EVAL      MGNATY = NwAcNATY                            Net. Account Type
     C                   EVAL      MGDSTN = NwAcDSTN                            Destination
     C                   EVAL      MGMTPY = NwAcMTPY                            Message Type
     C                   EVAL      MGPROC = *BLANKS                             Not Processed
     C/COPY WNCPYSRC,EML104_003                                                               EML104
     C                   WRITE     GLPOSTD0
     C                   ENDDO

     C/COPY WNCPYSRC,GLH00785
      ** Read the next posting corresponding to Midas account.

     C     KeyPost       READE     GLEODPL1                               29
     C                   ENDDO

      *    ---------     -----
     C     @LoadPsts     ENDSR

      *========================================================================*
      * $CorrFld  : Manage the invalid fields (Invalid decimal error)          *
      *------------------------------------------------------------------------*

     C     $CorrFld      BEGSR
      *    --------      -----

     C                   MOVE      WNITMS        WNITMS                   99
     C   99              EVAL      NITMS = *ZEROS
     C                   MOVE      WCHGA         WCHGA                    99
     C   99              EVAL      CHGA = *ZEROS
     C                   MOVE      WORAMT        WORAMT                   99
     C   99              EVAL      ORAMT = *ZEROS

      *    --------      -----
     C     @CorrFld      ENDSR

      *========================================================================*
      * $AddInf   : Manage the Additional Information fields                   *
      *------------------------------------------------------------------------*

     C     $AddInf       BEGSR
      *    -------       -----

      ** Clear COB Posting Detail Extension.

     C                   EVAL      OCCY = *BLANKS                               Original Currency
     C                   EVAL      OAMT = *ZEROS                                Original amount

      ** Clear Additional fields

     C                   EVAL      MGADI1 = *BLANKS                             Additional Inf. 1
     C                   EVAL      MGADI2 = *BLANKS                             Additional Inf. 2
     C                   EVAL      MGADI3 = *BLANKS                             Additional Inf. 3
     C                   EVAL      MGADI4 = *BLANKS                             Additional Inf. 4
     C                   EVAL      MGADI5 = *BLANKS                             Additional Inf. 5
     C                   EVAL      MGADI6 = *BLANKS                             Additional Inf. 6
     C                   EVAL      MGAERI = *BLANKS                             ERI Indicator

      ** If Extension File Reference access the COB Posting Detail Extension.

     C                   IF        XRFI <> *BLANKS
     C                             AND XRFN <> *ZEROS
     C     KeyCOBExt     CHAIN     EODPOPPD                           99
     C                   IF        NOT *IN99
     C                   EVAL      OCCY = EXOCCY                                Original Currency
     C                   EVAL      OAMT = EXOAMT                                Original Amount
     C                   IF        CER031 = 'Y'                                            BUG22979A
      *                                                                                    BUG22979A
     C                   EVAL      MGADI1 = EXPSNAR1                                       BUG22979A
     C                   EVAL      MGADI2 = EXPSNAR2                                       BUG22979A
     C                   EVAL      MGADI3 = EXPSNAR3                                       BUG22979A
     C                   EVAL      MGADI4 = EXPSNAR4                                       BUG22979A
     C                   EVAL      MGADI5 = EXPSNAR5                                       BUG22979A
     C                   EVAL      MGADI6 = EXPSNAR6                                       BUG22979A
      *                                                                                    BUG22979A
     C                   ENDIF                                                             BUG22979A
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00404

      ** If the Posting is a Batch Input Item, the field SPOS contains the Batch Item
      ** and the Batch Number,
      ** Otherwise, the field contains 5 characters code corresponding to the Midas module.
      ** Thus, if the 6 first characters is numeric, it is a batch item posting.

     C/COPY WNCPYSRC,GLH00405
     C     '0123456789'  CHECK     SPOS          X
     C                   IF        X = 7
     C/COPY WNCPYSRC,GLH00406

      **  Retrieve the Batch Item Additional Information.
      **  The key are the Posting Date, Batch Number and Item Number.

     C     KeyAddInf     CHAIN     GLJENXL1                           99
     C                   IF        NOT *IN99
     C                   EVAL      MGADI1 = BAADI1                              Additional Inf. 1
     C                   EVAL      MGADI2 = BAADI2                              Additional Inf. 2
     C                   EVAL      MGADI3 = BAADI3                              Additional Inf. 3
     C                   EVAL      MGADI4 = BAADI4                              Additional Inf. 4
     C                   EVAL      MGADI5 = BAADI5                              Additional Inf. 5
     C                   EVAL      MGADI6 = BAADI6                              Additional Inf. 6
     C                   EVAL      MGAERI = BAAERI                              ERI Indicator
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER030
     C**********         IF        CER031 = 'Y'                                     CER030 BUG22979A
      *                                                                                       CER030
     C**********         EVAL      MGADI1 = *BLANKS                                 CER030 BUG22979A
     C**********         EVAL      MGADI2 = *BLANKS                                 CER030 BUG22979A
     C**********         EVAL      MGADI3 = *BLANKS                                 CER030 BUG22979A
     C**********         EVAL      MGADI4 = *BLANKS                                 CER030 BUG22979A
     C**********         EVAL      MGADI5 = *BLANKS                                 CER030 BUG22979A
     C**********         EVAL      MGADI6 = *BLANKS                                 CER030 BUG22979A
      *                                                                                       CER030
     C**********         EVAL      MGADI1 = EXPSNAR1                                CER030 BUG22979A
     C**********         EVAL      MGADI2 = EXPSNAR2                                CER030 BUG22979A
     C**********         EVAL      MGADI3 = EXPSNAR3                                CER030 BUG22979A
     C**********         EVAL      MGADI4 = EXPSNAR4                                CER030 BUG22979A
     C**********         EVAL      MGADI5 = EXPSNAR5                                CER030 BUG22979A
     C**********         EVAL      MGADI6 = EXPSNAR6                                CER030 BUG22979A
      *                                                                                       CER030
     C**********         ENDIF                                                      CER030 BUG22979A
     C/COPY WNCPYSRC,GLH00629

      /COPY WNCPYSRC,EML102_012                                                               EML102
      *                                                                                       EML102
      *    -------       -----
     C     @AddInf       ENDSR

     C/COPY WNCPYSRC,GLH00407
     C/COPY WNCPYSRC,EML102_021                                                               EML102
      *========================================================================*
      * $LoadCtl  : Load Control file.                                         *
      *------------------------------------------------------------------------*

     C     $LoadCtl      BEGSR
      *    --------      -----

      ** To avoid to restart to process for all accounts in case of problem, the
      ** PF/GLUCTLPD hold the last account processed.
      ** By this way, the processing can restart from the next account following
      ** the saved one.

     C     1             CHAIN     GLUCTLD0                           99
     C                   EVAL      LastAccnt = CurrAccnt                         Load Current Accnt
     C   99              WRITE     GLUCTLD0
     C  N99              UPDATE    GLUCTLD0

      *    --------      -----
     C     @LoadCtl      ENDSR

      *========================================================================*
      * $PosAccnt : Position on account.                                       *
      *------------------------------------------------------------------------*

     C     $PosAccnt     BEGSR
      *    ---------     -----

      ** To avoid to restart to process for all accounts in case of problem, the
      ** PF/GLUCTLPD hold the last account processed.
      ** By this way, the processing can restart from the next account following
      ** the saved one.

     C     1             CHAIN     GLUCTLD0                           99
     C                   IF        *IN99                                        First run.
     C     *LOVAL        SETLL     GLNWACL3
     C                   ELSE                                                   Next run.
     C                   EVAL      KeyBRCH = CTBRCH                             Branch
     C                   EVAL      KeyCNUM = CTCNUM                             Customer
     C                   EVAL      KeyCCY  = CTCCY                              Currency
     C                   EVAL      KeyACOD = CTACOD                             Account Code
     C                   EVAL      KeyACSQ = CTACSQ                             Account Sequence
     C     KeyPost       SETGT     GLNWACL3
     C                   ENDIF

      *    ---------     -----
     C     @PosAccnt     ENDSR

      *========================================================================*
      * SRZSLOAD - Load Zero Blancing/Sweeping fld 61 details                  *              CRE008
      *------------------------------------------------------------------------*              CRE008
                                                                                              CRE008
     C     SRZSLOAD      BEGSR                                                                CRE008
      *    ----------    -----                                                                CRE008
                                                                                              CRE008
     C                   If        XRFI = 'ZS '                                               CRE008
     C     KeyCOBExt     Chain     GLAPSZSL0                          30                      CRE008
     C                   If        *IN30 = *Off                                               CRE008
     C                   EVAL      MGZ616 = AZF616                                            CRE008
     C                   EVAL      MGZ617 = AZF617                                            CRE008
     C                   EVAL      MGZ618 = AZF618                                            CRE008
     C                   EVAL      MGZ619 = AZF619                                            CRE008
     C                   EVAL      MGZ861 = AZF861                                            CRE008
     C                   EVAL      MGZ862 = AZF862                                            CRE008
     C                   EVAL      MGZ863 = AZF863                                            CRE008
     C                   EVAL      MGZ865 = AZF864                                            CRE008
     C                   EVAL      MGZ865 = AZF865                                            CRE008
     C                   EVAL      MGZ866 = AZF866                                            CRE008
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
     C                   EVAL      MGSRCA = *blanks                                           216937
                                                                                              216937
     C                   If        XRFI = 'GA '                                               216937
     C     KeyCOBExt     Chain     GLAPSGAL0                          31                      216937
     C                   If        *IN31 = *Off                                               216937
     C                   If        AGSRNO <> 0                                                216937
     C                   Movel     AGSRNO        WWSRNO           10                          216937
     C                   Eval      MGSRCA   = 'ORIGINATING ACCOUNT ' + WWSRNO                 216937
     C                   Else                                                                 216937
     C                   Movel     AGSCUS        WWSCUS            6                          216937
     C**********         Movel     AGSACD        WWSACD            4                   216937 CGL029
     C                   Movel     AGSACD        WWSACD           10                          CGL029
     C                   Movel     AGSASN        WWSASN            2                          216937
     C                   EVAL      MGSRCA   = 'ORIGINATING ACCOUNT ' + AGSBRC +               216937
     C                                        WWSCUS + AGSCCY + WWSACD + WWSASN               216937
     C                   Endif                                                                216937
     C                   Endif                                                                216937
     C/COPY WNCPYSRC,GLH00408
     C                   Endif                                                                216937
     C/COPY WNCPYSRC,GLH00409
                                                                                              216937
      *    ----------    -----                                                                216937
     C     @SRGALOAD     ENDSR                                                                216937
                                                                                              216937
      *========================================================================*              CRE008
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA
     C/COPY WNCPYSRC,GLH00786
                                                                                              CRE008
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
      *                                                                                       CER030
      ** Check if feature CRE031 is installed                                                 CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031 '     PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF'                                            CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                      CGL135A
     C/COPY OFCPYSRCZ,CGL135_018                                                             CGL135A
      *                                                                                      CGL135A
     C/COPY WNCPYSRC,GLH00410

      ** Key List to access Postings in LF/GLEODPL1
      **          or to access Network Account in LF/GLNWACL3.

     C     KeyPost       KLIST
     C                   KFLD                    KeyBRCH
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACOD
     C                   KFLD                    KeyACSQ

      ** Key List to access COB Posting Detail Extension.        .

     C     KeyCOBExt     KLIST
     C                   KFLD                    XRFI
     C                   KFLD                    XRFN

      ** Key List to access the Batch Item Additional Information.

     C     KeyAddInf     KLIST
     C                   KFLD                    PSTD
     C                   KFLD                    WBatchNb
     C                   KFLD                    WItemNb
     C/COPY WNCPYSRC,EML102_022                                                               EML102
     C/COPY WNCPYSRC,GLH00411
     C/COPY WNCPYSRC,EML102_013                                                               EML102
      *                                                                                       EML102
      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    ----------    ------

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
