     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Standing Settlement Instruction Retrieve')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSIR0  - Standing Settlement Instruction Retreive          *
      *                                                               *
      *  Function:  This module will retreive from file standard      *
      *             settlement instructions for the customer and      *
      *             for the book.                                     *
      *                                                               *
      ** +---------------------------------------------------------+ **
      *                                                               *
      *  Component of: SESSIR0  - Standard Settlement Additional      *
      *                           information                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE039             Date 07Mar03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210611             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 18Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE039 - Auto-settlement of trades                           *
      *  210611 - Pay From details missing                            *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Chain indicator for file STDSED                 *
      *    02         Chain indicator for file STDADSL2               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  Default    -  Operation type D - Default                     *
      *  CUSDftSTD  -  Default customer data standard                 *
      *  BOKDftSTD  -  Default book data standard                     *
      *  STDDftMove -  Move default standard data to data structure   *
      *  CUSDftADD  -  Default customer data additional               *
      *  BOKDftADD  -  Default book data additional                   *
      *  ADDDftMove -  Move dafault additional data to data structure *
      *                                                               *
      *  Template   -  Operation type T - Template                    *
      *  CUSTmpSTD  -  Template customer data standard                *
      *  BOKTmpSTD  -  Template book data standard                    *
      *  STDTmpMove -  Move template standard data to data structure  *
      *  CUSTmpADD  -  Template customer data additional              *
      *  BOKTmpADD  -  Template book data additional                  *
      *  ADDTmpMove -  Move template additional data to data structure*
      *                                                               *
      *  *PSSR      -  Error processing                               *
      *  *INZSR     -  Initialise                                     *
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
 
      ** Standard settlement instructions
     F*STDSED****IF***E           K DISK    INFSR(*PSSR)                                      CSE034
     FSTDSEL1   IF   E           K DISK    INFSR(*PSSR)                                       CSE034
     F                                     PREFIX(F1)
 
      ** Standard additional settlement instructions
     FSTDADSL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F2)
 
 
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      *
      ** Data structure for standard settlement instructions
      *
     D STD           E DS                  EXTNAME(STDSED)
     D                                     OCCURS(2)
      *
      ** Data structure for standard additional settlement details
      *
     D ADD           E DS                  EXTNAME(STDADSED)
     D                                     OCCURS(8)
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     DP1CUST           S                   LIKE(CSTM)
     DKBRCH            S                   LIKE(SBRA)
     DKCUST            S                   LIKE(CSTM)
     DKBOOK            S                   LIKE(SIBK)
     DKCCY             S                   LIKE(CYSI)
     DKMRKT            S                   LIKE(SMKT)                                         CSE034
     DKINTYP           S                   LIKE(ITSI)
     DKPOREF           S                   LIKE(SPTFR)
     DKADDTY           S                   LIKE(SATYPE)
     D@RUN             S              1
     DCUSSTDFND        S              1
     DBOKSTDFND        S              1
     DX                S              2P 0
     DY                S              2P 0
     DZ                S              2P 0
     DCSW206           S              1                                                      CSW206E
 
      *****************************************************************
 
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initial processing
 
     C                   EXSR      SRInit
 
      ** Operation type Default or Template
 
     C                   SELECT
     C                   WHEN      POPTYP = 'D'
     C                   EXSR      Default
     C                   WHEN      POPTYP = 'T'
     C                   EXSR      Template
     C                   ENDSL
 
      **  Return
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * Default - Operation type D = Default                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: CUSDftSTD CUSDftADD BOKDftSTD BOKDftADD                *
      *                                                               *
      *****************************************************************
 
     C     Default       BEGSR
 
      *
      ** Default customer data standard
      *
     C                   EXSR      CUSDftSTD
      *
      ** If default found for customer on STDSED now get data from
      ** STDADSED.
      *
     C                   IF        CUSSTDFND = 'Y'
     C                   EXSR      CUSDftADD
     C                   ENDIF
      *
      ** Default book data standard
      *
     C                   EXSR      BOKDftSTD
      *
      ** If default found for book on STDSED now get data from
      ** STDADSED.
      *
     C                   IF        BOKSTDFND = 'Y'
     C                   EXSR      BOKDftADD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CUSDftSTD - Default customer data (Standard)                  *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: STDDftMove                                             *
      *                                                               *
      *****************************************************************
 
     C     CUSDftSTD     BEGSR
 
 
     C**********         IF        P1CUST <> 0                                                CSD027
     C                   IF        P1CUST <> *BLANKS                                          CSD027
     C                   EVAL      KBRCH = PBRCH
     C                   EVAL      KCUST = P1CUST
     C                   EVAL      KBOOK = *BLANKS
     C                   EVAL      KCCY  = PCCY
     C                   EVAL      KMRKT = PMRKT                                              CSE034
     C                   EVAL      KINTYP = PINTYP
     C                   EVAL      KPOREF = PPOREF
 
      *
      ** Access STDSED with book blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
 
     C                   IF        *IN01 = *ON
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KPOREF = *BLANK
      *
      ** Access STDSED with book and porfolio ref blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
 
     C                   IF        *IN01 = *ON
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = *BLANK
      *
      ** Access STDSED with book, investment and porfolio ref blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
                                                                                              CSE034
     C                   IF        *IN01 = *ON                                                CSE034
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = PINTYP                                            CSE034
     C                   EVAL      KMRKT = *BLANKS                                            CSE034
                                                                                              CSE034
      ** Access STDSED with book, market and portfolio ref blank.                             CSE034
                                                                                              CSE034
     C     KSTD          CHAIN     STDSEDF                            01                      CSE034
                                                                                              CSE034
     C                   IF        *IN01 = *ON                                                CSE034
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = *BLANKS                                           CSE034
      *                                                                                       CSE034
      ** Access STDSED with book, market, investment and portfolio ref blank.                 CSE034
      *                                                                                       CSE034
     C     KSTD          CHAIN     STDSEDF                            01                      CSE034
     C                   ENDIF                                                                CSE034
     C                   ENDIF                                                                CSE034
     C                   ENDIF
     C                   ENDIF
 
      ** Passed customer field was not blank so searched file
     C                   IF        *IN01 = *ON
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      PTRCD = '*NCRF'
     C                   EVAL      CUSSTDFND = 'N'
     C                   ELSE
     C                   EVAL      CUSSTDFND = 'Y'
     C                   ENDIF
 
      ** Passed customer field was blank
     C                   ELSE
     C                   EVAL      PTRCD = '*NCRF'
     C                   EVAL      CUSSTDFND = 'N'
     C                   ENDIF
      *
      ** If cutomer data found then move to data structure STDSED
      ** occurence 2.
      *
     C                   IF        CUSSTDFND = 'Y'
     C                   EVAL      Z = 2
     C                   EXSR      STDDftMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BOKDftSTD - Default book data                                 *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: STDDftMove                                             *
      *                                                               *
      *****************************************************************
 
     C     BOKDftSTD     BEGSR
 
     C                   IF        PBOOK <> *BLANKS
     C                   EVAL      KBRCH = PBRCH
     C**********         EVAL      KCUST = 0                                                  CSD027
     C                   EVAL      KCUST = *BLANKS                                            CSD027
     C                   EVAL      KBOOK = PBOOK
     C                   EVAL      KCCY  = PCCY
     C                   EVAL      KMRKT = PMRKT                                              CSE034
     C                   EVAL      KINTYP = PINTYP
     C                   EVAL      KPOREF = *BLANKS
 
      *
      ** Access STDSED with customer and porfolio ref blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
 
     C                   IF        *IN01 = *ON
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = *BLANK
      *
      ** Access STDSED with customer,investment  and porfolio ref blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
                                                                                              CSE034
     C                   IF        *IN01 = *ON                                                CSE034
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = PINTYP                                            CSE034
     C                   EVAL      KMRKT = *BLANKS                                            CSE034
                                                                                              CSE034
      ** Access STDSED with customer, market and portfolio ref blank.                         CSE034
                                                                                              CSE034
     C     KSTD          CHAIN     STDSEDF                            01                      CSE034
                                                                                              CSE034
     C                   IF        *IN01 = *ON                                                CSE034
     C                             OR F1RECI = '*'                                            210611
     C                   EVAL      KINTYP = *BLANKS                                           CSE034
                                                                                              CSE034
      ** Access STDSED with customer, market, investment and portfolio ref blank.             CSE034
                                                                                              CSE034
     C     KSTD          CHAIN     STDSEDF                            01                      CSE034
     C                   ENDIF                                                                CSE034
     C                   ENDIF                                                                CSE034
     C                   ENDIF
 
      ** Passed book field was not blank so searched file
     C                   IF        *IN01 = *ON
     C                             OR F1RECI = '*'                                            210611
 
     C                   IF        PTRCD <> '*NCRF'
     C                   EVAL      PTRCD = '*NBRF'
     C                   ELSE
     C                   EVAL      PTRCD = '*NRF '
     C                   ENDIF
 
     C                   EVAL      BOKSTDFND = 'N'
     C                   ELSE
     C                   EVAL      BOKSTDFND = 'Y'
     C                   ENDIF
 
      ** Passed book field was blank
     C                   ELSE
 
     C                   IF        PTRCD <> '*NCRF'
     C                   EVAL      PTRCD = '*NBRF'
     C                   ELSE
     C                   EVAL      PTRCD = '*NRF '
     C                   ENDIF
 
     C                   EVAL      BOKSTDFND = 'N'
     C                   ENDIF
      *
      ** If book data found then move to data structure STDSED
      ** occurence 1.
      *
     C                   IF        BOKSTDFND = 'Y'
     C                   EVAL      Z = 1
     C                   EXSR      STDDftMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * STDDftMove - Move data from STDSED file to data structure STD *
      *           Book = occurence 1                                  *
      *           Customer = occurence 2                              *
      *                                                               *
      * Called by: CUSDftSTD BOKDftSTD                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     STDDftMove    BEGSR
 
     C                   DO
 
     C     Z             OCCUR     STD
     C                   EVAL      RECI = F1RECI
     C                   EVAL      SBRA = F1SBRA
     C                   EVAL      CSTM = F1CSTM
     C                   EVAL      CYSI = F1CYSI
     C                   EVAL      ITSI = F1ITSI
     C                   EVAL      SRSM = F1SRSM
     C                   EVAL      SRAC = F1SRAC
     C                   EVAL      SRAB = F1SRAB
     C                   EVAL      SRCB = F1SRCB
     C                   EVAL      SPSM = F1SPSM
     C                   EVAL      SPAT = F1SPAT
     C                   EVAL      SPBA = F1SPBA
     C                   EVAL      SPCB = F1SPCB
     C                   EVAL      SPFA = F1SPFA
     C                   EVAL      SPSI = F1SPSI
     C                   EVAL      SPCP = F1SPCP
     C                   EVAL      SPCS = F1SPCS
     C                   EVAL      SCLP = F1SCLP
     C                   EVAL      SCLS = F1SCLS
     C                   EVAL      SCLH = F1SCLH
     C                   EVAL      SDTO = F1SDTO
     C                   EVAL      SDFO = F1SDFO
     C                   EVAL      SDTT = F1SDTT
     C                   EVAL      SFAT = F1SFAT
     C                   EVAL      SDFT = F1SDFT
     C                   EVAL      SFAF = F1SFAF
     C                   EVAL      LCD  = F1LCD
     C                   EVAL      CHTP = F1CHTP
     C                   EVAL      TNLU = F1TNLU
     C                   EVAL      SCCY = F1SCCY
     C                   EVAL      ERII = F1ERII
     C                   EVAL      SKAC = F1SKAC
     C                   EVAL      SIBK = F1SIBK
     C                   EVAL      SPTFR = F1SPTFR
     C                   EVAL      SNEW = F1SNEW
     C                   EVAL      STFDM = F1STFDM
     C                   EVAL      SMKT = F1SMKT                                              CSE034
     C                   EVAL      SASI = F1SASI                                              CSE039
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CUSDftADD - Default customer data (Additional)                *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: ADDDftMove                                             *
      *                                                               *
      *****************************************************************
 
     C     CUSDftADD     BEGSR
 
      *
      ** Check for Trade Purchase record on STDADSED
      *
     C                   EVAL      KADDTY = 'P'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 5
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Trade Sale record on STDADSED
      *
     C                   EVAL      KADDTY = 'S'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 6
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Depot In record on STDADSED
      *
     C                   EVAL      KADDTY = 'I'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 7
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Depot Out record on STDADSED
      *
     C                   EVAL      KADDTY = 'O'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 8
     C                   EXSR      ADDDftMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BOKDftADD - Default book data (Additional)                    *
      *                                                               *
      * Called by: Default                                            *
      *                                                               *
      * Calls: ADDDftMove                                             *
      *                                                               *
      *****************************************************************
 
     C     BOKDftADD     BEGSR
 
      *
      ** Check for Trade Purchase record on STDADSED
      *
     C                   EVAL      KADDTY = 'P'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 1
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Trade Sale record on STDADSED
      *
     C                   EVAL      KADDTY = 'S'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 2
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Depot In record on STDADSED
      *
     C                   EVAL      KADDTY = 'I'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 3
     C                   EXSR      ADDDftMove
     C                   ENDIF
      *
      ** Check for Depot Out record on STDADSED
      *
     C                   EVAL      KADDTY = 'O'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 4
     C                   EXSR      ADDDftMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDDftMove - Move data from STDADSED file to data structure   *
      *           ADD                                                 *
      *           Book Trade Purchase = occurence 1                   *
      *           Book Trade Sale = occurence 2                       *
      *           Book Depot In = occurence 3                         *
      *           Book Depot Out = occurence 4                        *
      *           Customer Trade Purchase = occurence 5               *
      *           Customer Trade Sale = occurence 6                   *
      *           Customer Depot In = occurence 7                     *
      *           Customer Depot out = occurence 8                    *
      *                                                               *
      * Called by: CUSDftADD BOKDftADD                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ADDDftMove    BEGSR
 
     C                   DO
 
     C     Z             OCCUR     ADD
     C                   EVAL      SARECI = F2SARECI
     C                   EVAL      SABCH  = F2SABCH
     C                   EVAL      SACUST = F2SACUST
     C                   EVAL      SABK   = F2SABK
     C                   EVAL      SACCY  = F2SACCY
     C                   EVAL      SAINV  = F2SAINV
     C                   EVAL      SAPREF = F2SAPREF
     C                   EVAL      SATYPE = F2SATYPE
     C                   EVAL      SAGMES = F2SAGMES
     C                   EVAL      SACONG = F2SACONG
     C                   EVAL      SAINST = F2SAINST
     C                   EVAL      SAINSS = F2SAINSS
     C                   EVAL      SARPTY = F2SARPTY
     C                   EVAL      SAGDEL = F2SAGDEL
     C                   EVAL      SASROL = F2SASROL
     C                   EVAL      SAFIND = F2SAFIND
     C                   EVAL      SACCTN = F2SACCTN
     C                   EVAL      SADRSN = F2SADRSN
     C                   EVAL      SADRS1 = F2SADRS1
     C                   EVAL      SADRS2 = F2SADRS2
     C                   EVAL      SADRS3 = F2SADRS3
     C                   EVAL      SADRS4 = F2SADRS4
     C                   EVAL      SABSSN = F2SABSSN
     C                   EVAL      SABSS1 = F2SABSS1
     C                   EVAL      SABSS2 = F2SABSS2
     C                   EVAL      SAFIN1 = F2SAFIN1
     C                   EVAL      SAFIN2 = F2SAFIN2
     C                   EVAL      SARED1 = F2SARED1
     C                   EVAL      SARED2 = F2SARED2
     C                   EVAL      SANAS1 = F2SANAS1
     C                   EVAL      SANAS2 = F2SANAS2
     C                   EVAL      SAIMD1 = F2SAIMD1
     C                   EVAL      SAIMD2 = F2SAIMD2
     C**********         EVAL      SAIMD3 = F2SAIMD3                                         CSW206D
     C**********         EVAL      SAIMD4 = F2SAIMD4                                         CSW206D
     C**********         EVAL      SAIMD5 = F2SAIMD5                                         CSW206D
     C**********         EVAL      SAIMD6 = F2SAIMD6                                         CSW206D
     C**********         EVAL      SAIMD7 = F2SAIMD7                                         CSW206D
     C**********         EVAL      SAIMD8 = F2SAIMD8                                         CSW206D
     C**********         EVAL      SAIMD9 = F2SAIMD9                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMD3 = F2SAIMD3                                         CSW206E
     C                   EVAL      SAIMD4 = F2SAIMD4                                         CSW206E
     C                   EVAL      SAIMD5 = F2SAIMD5                                         CSW206E
     C                   EVAL      SAIMD6 = F2SAIMD6                                         CSW206E
     C                   EVAL      SAIMD7 = F2SAIMD7                                         CSW206E
     C                   EVAL      SAIMD8 = F2SAIMD8                                         CSW206E
     C                   EVAL      SAIMD9 = F2SAIMD9                                         CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      SAIMS1 = F2SAIMS1
     C                   EVAL      SAIMS2 = F2SAIMS2
     C**********         EVAL      SAIMS3 = F2SAIMS3                                         CSW206D
     C**********         EVAL      SAIMS4 = F2SAIMS4                                         CSW206D
     C**********         EVAL      SAIMS5 = F2SAIMS5                                         CSW206D
     C**********         EVAL      SAIMS6 = F2SAIMS6                                         CSW206D
     C**********         EVAL      SAIMS7 = F2SAIMS7                                         CSW206D
     C**********         EVAL      SAIMS8 = F2SAIMS8                                         CSW206D
     C**********         EVAL      SAIMS9 = F2SAIMS9                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMS3 = F2SAIMS3                                         CSW206E
     C                   EVAL      SAIMS4 = F2SAIMS4                                         CSW206E
     C                   EVAL      SAIMS5 = F2SAIMS5                                         CSW206E
     C                   EVAL      SAIMS6 = F2SAIMS6                                         CSW206E
     C                   EVAL      SAIMS7 = F2SAIMS7                                         CSW206E
     C                   EVAL      SAIMS8 = F2SAIMS8                                         CSW206E
     C                   EVAL      SAIMS9 = F2SAIMS9                                         CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      SAPSET = F2SAPSET
     C                   EVAL      SAAWIN = F2SAAWIN
     C                   EVAL      SAAWIL = F2SAAWIL
     C                   EVAL      SAAFPN = F2SAAFPN
     C                   EVAL      SAAFPL = F2SAAFPL
     C                   EVAL      SABOFN = F2SABOFN
     C                   EVAL      SABOF1 = F2SABOF1
     C                   EVAL      SABOF2 = F2SABOF2
     C                   EVAL      SASRL1 = F2SASRL1
     C                   EVAL      SASRL2 = F2SASRL2
     C                   EVAL      SASRL3 = F2SASRL3
     C                   EVAL      SANAC1 = F2SANAC1
     C                   EVAL      SANAC2 = F2SANAC2
     C                   EVAL      SASTMP = F2SASTMP
     C                   EVAL      SACHID = F2SACHID
     C                   EVAL      SATRRM = F2SATRRM
     C                   EVAL      SAMKT = F2SAMKT                                            CSE034
     C                   EVAL      SADIDN = F2SADIDN                                          CSW210
     C                   EVAL      SADAD1 = F2SADAD1                                          CSW210
     C                   EVAL      SADAD2 = F2SADAD2                                          CSW210
     C                   EVAL      SADAD3 = F2SADAD3                                          CSW210
     C                   EVAL      SADAD4 = F2SADAD4                                          CSW210
     C                   EVAL      SADLIN = F2SADLIN                                          CSW210
     C                   EVAL      SAQFIN = F2SAQFIN                                          CSW210
     C                   EVAL      SAPCLR = F2SAPCLR                                          CSW210
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Template - Operation type T = Template                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: CUSTmpSTD CUSTmpADD BOKTmpSTD BOKTmpADD                *
      *                                                               *
      *****************************************************************
 
     C     Template      BEGSR
 
      *
      ** Only need to do this if passed customer is not blank
      *
     C**********         IF        P1CUST <> 0                                                CSD027
     C                   IF        P1CUST <> *BLANKS                                          CSD027
      *
      ** Template customer data standard
      *
     C                   EXSR      CUSTmpSTD
      *
      ** If template found for customer on STDSED now get data from
      ** STDADSED.
      *
     C                   IF        CUSSTDFND = 'Y'
     C                   EXSR      CUSTmpADD
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Only need to do this if passed book is not blank
      *
     C                   IF        PBOOK <> *BLANKS
      *
      ** Template book data standard
      *
     C                   EXSR      BOKTmpSTD
      *
      ** If template found for book on STDSED now get data from
      ** STDADSED.
      *
     C                   IF        BOKSTDFND = 'Y'
     C                   EXSR      BOKTmpADD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CUSTmpSTD - Template customer data (Standard)                 *
      *                                                               *
      * Called by: Template                                          *
      *                                                               *
      * Calls: STDTmpMove                                             *
      *                                                               *
      *****************************************************************
 
     C     CUSTmpSTD     BEGSR
 
 
     C**********         IF        P1CUST <> 0                                                CSD027
     C                   IF        P1CUST <> *BLANKS                                          CSD027
     C                   EVAL      KBRCH = PBRCH
     C                   EVAL      KCUST = P1CUST
     C                   EVAL      KBOOK = *BLANKS
     C                   EVAL      KCCY  = PCCY
     C                   EVAL      KMRKT = PMRKT                                              CSE034
     C                   EVAL      KINTYP = PINTYP
     C                   EVAL      KPOREF = PPOREF
 
      *
      ** Access STDSED with book blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
 
      ** Passed customer field was not blank so searched file
     C                   IF        *IN01 = *ON
     C                   EVAL      PTRCD = '*NCRF'
     C                   EVAL      CUSSTDFND = 'N'
     C                   ELSE
     C                   EVAL      CUSSTDFND = 'Y'
     C                   ENDIF
 
      ** Passed customer field was blank
     C                   ELSE
     C                   EVAL      PTRCD = '*NCRF'
     C                   EVAL      CUSSTDFND = 'N'
     C                   ENDIF
      *
      ** If customer data found then move to data structure STDSED
      ** occurence 2.
      *
     C                   IF        CUSSTDFND = 'Y'
     C                   EVAL      Z = 2
     C                   EXSR      STDTmpMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BOKTmpSTD - Template customer data                            *
      *                                                               *
      * Called by: Template                                           *
      *                                                               *
      * Calls: STDTmpMove                                             *
      *                                                               *
      *****************************************************************
 
     C     BOKTmpSTD     BEGSR
 
     C                   IF        PBOOK <> *BLANKS
     C                   EVAL      KBRCH = PBRCH
     C**********         EVAL      KCUST = 0                                                  CSD027
     C                   EVAL      KCUST = *BLANKS                                            CSD027
     C                   EVAL      KBOOK = PBOOK
     C                   EVAL      KCCY  = PCCY
     C                   EVAL      KMRKT = PMRKT                                              CSE034
     C                   EVAL      KINTYP = PINTYP
     C                   EVAL      KPOREF = *BLANKS
 
      *
      ** Access STDSED with customer and porfolio ref blank
      *
     C     KSTD          CHAIN     STDSEDF                            01
 
      ** Passed book field was not blank so searched file
     C                   IF        *IN01 = *ON
     C                   EVAL      PTRCD = '*NBRF'
     C                   EVAL      BOKSTDFND = 'N'
     C                   ELSE
     C                   EVAL      BOKSTDFND = 'Y'
     C                   ENDIF
 
      ** Passed book field was blank
     C                   ELSE
     C                   EVAL      PTRCD = '*NBRF'
     C                   EVAL      BOKSTDFND = 'N'
     C                   ENDIF
      *
      ** If book data found then move to data structure STDSED
      ** occurence 1.
      *
     C                   IF        BOKSTDFND = 'Y'
     C                   EVAL      Z = 1
     C                   EXSR      STDTmpMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * STDTmpMove - Move data from STDSED file to data structure STD *
      *           Book = occurence 1                                  *
      *           Customer = occurence 2                              *
      *                                                               *
      * Called by: Customer and Book template processing              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     STDTmpMove    BEGSR
 
     C                   DO
 
     C     Z             OCCUR     STD
     C                   EVAL      RECI = F1RECI
     C                   EVAL      SBRA = F1SBRA
     C                   EVAL      CSTM = F1CSTM
     C                   EVAL      CYSI = F1CYSI
     C                   EVAL      ITSI = F1ITSI
     C                   EVAL      SRSM = F1SRSM
     C                   EVAL      SRAC = F1SRAC
     C                   EVAL      SRAB = F1SRAB
     C                   EVAL      SRCB = F1SRCB
     C                   EVAL      SPSM = F1SPSM
     C                   EVAL      SPAT = F1SPAT
     C                   EVAL      SPBA = F1SPBA
     C                   EVAL      SPCB = F1SPCB
     C                   EVAL      SPFA = F1SPFA
     C                   EVAL      SPSI = F1SPSI
     C                   EVAL      SPCP = F1SPCP
     C                   EVAL      SPCS = F1SPCS
     C                   EVAL      SCLP = F1SCLP
     C                   EVAL      SCLS = F1SCLS
     C                   EVAL      SCLH = F1SCLH
     C                   EVAL      SDTO = F1SDTO
     C                   EVAL      SDFO = F1SDFO
     C                   EVAL      SDTT = F1SDTT
     C                   EVAL      SFAT = F1SFAT
     C                   EVAL      SDFT = F1SDFT
     C                   EVAL      SFAF = F1SFAF
     C                   EVAL      LCD  = F1LCD
     C                   EVAL      CHTP = F1CHTP
     C                   EVAL      TNLU = F1TNLU
     C                   EVAL      SCCY = F1SCCY
     C                   EVAL      ERII = F1ERII
     C                   EVAL      SKAC = F1SKAC
     C                   EVAL      SIBK = F1SIBK
     C                   EVAL      SPTFR = F1SPTFR
     C                   EVAL      SNEW = F1SNEW
     C                   EVAL      STFDM = F1STFDM
     C                   EVAL      SMKT = F1SMKT                                              CSE034
     C                   EVAL      SASI = F1SASI                                              CSE039
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CUSTmpADD - Template customer data (Additional)               *
      *                                                               *
      * Called by: Template                                           *
      *                                                               *
      * Calls: ADDTmpMove                                             *
      *                                                               *
      *****************************************************************
 
     C     CUSTmpADD     BEGSR
 
      *
      ** Check for Trade Purchase record on STDADSED
      *
     C                   EVAL      KADDTY = 'P'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 5
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Trade Sale record on STDADSED
      *
     C                   EVAL      KADDTY = 'S'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 6
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Depot In record on STDADSED
      *
     C                   EVAL      KADDTY = 'I'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 7
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Depot Out record on STDADSED
      *
     C                   EVAL      KADDTY = 'O'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 8
     C                   EXSR      ADDTmpMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BOKTmpADD - Template book data (Additional)                   *
      *                                                               *
      * Called by: Template                                           *
      *                                                               *
      * Calls: ADDTmpMove                                             *
      *                                                               *
      *****************************************************************
 
     C     BOKTmpADD     BEGSR
 
      *
      ** Check for Trade Purchase record on STDADSED
      *
     C                   EVAL      KADDTY = 'P'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 1
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Trade Sale record on STDADSED
      *
     C                   EVAL      KADDTY = 'S'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 2
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Depot In record on STDADSED
      *
     C                   EVAL      KADDTY = 'I'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 3
     C                   EXSR      ADDTmpMove
     C                   ENDIF
      *
      ** Check for Depot Out record on STDADSED
      *
     C                   EVAL      KADDTY = 'O'
     C     KADD          CHAIN     STDADSD0                           02
     C                   IF        *IN02 = *OFF
     C                   EVAL      Z = 4
     C                   EXSR      ADDTmpMove
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDTmpMove - Move data from STDADSED file to data structure   *
      *           ADD                                                 *
      *           Book Trade Purchase = occurence 1                   *
      *           Book Trade Sale = occurence 2                       *
      *           Book Depot In = occurence 3                         *
      *           Book Depot Out = occurence 4                        *
      *           Customer Trade Purchase = occurence 5               *
      *           Customer Trade Sale = occurence 6                   *
      *           Customer Depot In = occurence 7                     *
      *           Customer Depot out = occurence 8                    *
      *                                                               *
      * Called by: CUSTmpADD BOKTmpADD                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ADDTmpMove    BEGSR
 
     C                   DO
 
     C     Z             OCCUR     ADD
     C                   EVAL      SARECI = F2SARECI
     C                   EVAL      SABCH  = F2SABCH
     C                   EVAL      SACUST = F2SACUST
     C                   EVAL      SABK   = F2SABK
     C                   EVAL      SACCY  = F2SACCY
     C                   EVAL      SAINV  = F2SAINV
     C                   EVAL      SAPREF = F2SAPREF
     C                   EVAL      SATYPE = F2SATYPE
     C                   EVAL      SAGMES = F2SAGMES
     C                   EVAL      SACONG = F2SACONG
     C                   EVAL      SAINST = F2SAINST
     C                   EVAL      SAINSS = F2SAINSS
     C                   EVAL      SARPTY = F2SARPTY
     C                   EVAL      SAGDEL = F2SAGDEL
     C                   EVAL      SASROL = F2SASROL
     C                   EVAL      SAFIND = F2SAFIND
     C                   EVAL      SACCTN = F2SACCTN
     C                   EVAL      SADRSN = F2SADRSN
     C                   EVAL      SADRS1 = F2SADRS1
     C                   EVAL      SADRS2 = F2SADRS2
     C                   EVAL      SADRS3 = F2SADRS3
     C                   EVAL      SADRS4 = F2SADRS4
     C                   EVAL      SABSSN = F2SABSSN
     C                   EVAL      SABSS1 = F2SABSS1
     C                   EVAL      SABSS2 = F2SABSS2
     C                   EVAL      SAFIN1 = F2SAFIN1
     C                   EVAL      SAFIN2 = F2SAFIN2
     C                   EVAL      SARED1 = F2SARED1
     C                   EVAL      SARED2 = F2SARED2
     C                   EVAL      SANAS1 = F2SANAS1
     C                   EVAL      SANAS2 = F2SANAS2
     C                   EVAL      SAIMD1 = F2SAIMD1
     C                   EVAL      SAIMD2 = F2SAIMD2
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMD3 = F2SAIMD3
     C                   EVAL      SAIMD4 = F2SAIMD4
     C                   EVAL      SAIMD5 = F2SAIMD5
     C                   EVAL      SAIMD6 = F2SAIMD6
     C                   EVAL      SAIMD7 = F2SAIMD7
     C                   EVAL      SAIMD8 = F2SAIMD8
     C                   EVAL      SAIMD9 = F2SAIMD9
     C                   ENDIF                                                               CSW206E
     C                   EVAL      SAIMS1 = F2SAIMS1
     C                   EVAL      SAIMS2 = F2SAIMS2
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      SAIMS3 = F2SAIMS3
     C                   EVAL      SAIMS4 = F2SAIMS4
     C                   EVAL      SAIMS5 = F2SAIMS5
     C                   EVAL      SAIMS6 = F2SAIMS6
     C                   EVAL      SAIMS7 = F2SAIMS7
     C                   EVAL      SAIMS8 = F2SAIMS8
     C                   EVAL      SAIMS9 = F2SAIMS9
     C                   ENDIF                                                               CSW206E
     C                   EVAL      SAPSET = F2SAPSET
     C                   EVAL      SAAWIN = F2SAAWIN
     C                   EVAL      SAAWIL = F2SAAWIL
     C                   EVAL      SAAFPN = F2SAAFPN
     C                   EVAL      SAAFPL = F2SAAFPL
     C                   EVAL      SABOFN = F2SABOFN
     C                   EVAL      SABOF1 = F2SABOF1
     C                   EVAL      SABOF2 = F2SABOF2
     C                   EVAL      SASRL1 = F2SASRL1
     C                   EVAL      SASRL2 = F2SASRL2
     C                   EVAL      SASRL3 = F2SASRL3
     C                   EVAL      SANAC1 = F2SANAC1
     C                   EVAL      SANAC2 = F2SANAC2
     C                   EVAL      SASTMP = F2SASTMP
     C                   EVAL      SACHID = F2SACHID
     C                   EVAL      SATRRM = F2SATRRM
     C                   EVAL      SAMKT = F2SAMKT                                            CSE034
     C                   EVAL      SADIDN = F2SADIDN                                          CSW210
     C                   EVAL      SADAD1 = F2SADAD1                                          CSW210
     C                   EVAL      SADAD2 = F2SADAD2                                          CSW210
     C                   EVAL      SADAD3 = F2SADAD3                                          CSW210
     C                   EVAL      SADAD4 = F2SADAD4                                          CSW210
     C                   EVAL      SADLIN = F2SADLIN                                          CSW210
     C                   EVAL      SAQFIN = F2SAQFIN                                          CSW210
     C                   EVAL      SAPCLR = F2SAPCLR                                          CSW210
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initial Processing                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *
      ** Move passed character field to numeric
      *
     C                   IF        PCUST = *BLANKS
     C**********         EVAL      P1CUST = 0                                                 CSD027
     C                   EVAL      P1CUST = *BLANKS                                           CSD027
     C                   ELSE
     C                   MOVE      PCUST         P1CUST
     C                   ENDIF
      *
      ** Clear STDSED data structure for book and customer
      *
     C                   EVAL      X = 1
     C                   EVAL      Y = 2
     C                   EVAL      Z = 0
 
     C     X             DO        Y             Z
     C     Z             OCCUR     STD
     C                   EVAL      STD = *BLANKS
     C                   ENDDO
      *
      ** Clear STDADSED data structure for book and customer
      *
     C                   EVAL      X = 1
     C                   EVAL      Y = 8
     C                   EVAL      Z = 0
 
     C     X             DO        Y             Z
     C     Z             OCCUR     ADD
     C                   EVAL      ADD = *BLANKS
     C                   ENDDO
                                                                                             CSW206E
      ** Check if SWIFT 2006 is installed                                                    CSW206E
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD             7                         CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   ENDSR
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
 
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * Operation type
     C                   PARM                    POPTYP            1
      *
      * Branch
     C                   PARM                    PBRCH             3
      *
      * Customer
     C                   PARM                    PCUST             6
      *
      * Book
     C                   PARM                    PBOOK             2
      *
      * Currency
     C                   PARM                    PCCY              3
      *                                                                                       CSE034
      * Market Centre                                                                         CSE034
     C                   PARM                    PMRKT             2                          CSE034
      *
      * Investment type
     C                   PARM                    PINTYP            3
      *
      * Portfolio reference
     C                   PARM                    PPOREF            4
      *
      * OUTPUT PARAMETERS
      *
      * Data structure for STDSED (Book and Customer)
     C                   PARM                    STD
      *
      * Data structure for STDADSED (Book and Customer)
      * (For trade Purchase)
      * (For trade Sale)
      * (For physical Depot IN)
      * (For physical Depot OUT)
     C                   PARM                    ADD
      *
      * Return code
     C                   PARM                    PTRCD             5
 
      *
      ** Define key lists for chaining to STDSED file
      *
 
     C     KSTD          KLIST
     C                   KFLD                    KBRCH
     C                   KFLD                    KCUST
     C                   KFLD                    KBOOK
     C                   KFLD                    KCCY
     C                   KFLD                    KMRKT                                        CSE034
     C                   KFLD                    KINTYP
     C                   KFLD                    KPOREF
 
      *
      ** Define key lists for chaining to STDADSL2 file
      *
 
     C     KADD          KLIST
     C                   KFLD                    KBRCH
     C                   KFLD                    KCUST
     C                   KFLD                    KBOOK
     C                   KFLD                    KCCY
     C                   KFLD                    KMRKT                                        CSE034
     C                   KFLD                    KINTYP
     C                   KFLD                    KPOREF
     C                   KFLD                    KADDTY
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
