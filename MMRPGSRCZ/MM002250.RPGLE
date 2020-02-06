     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Adjustment to Amortisation Input')            *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM002250 - Midas MM Adjustment to Amortisation Input         *
      *                                                               *
      *  Function:  This program caters adjustments of the amortised  *
      *             amount for a particular deal                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 12Dec13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *  03 - F3 is pressed                                           *
      *  05 - F5 is pressed                                           *
      *  40 - Error in Deal Number                                    *
      *  41 - Error in Customer Number                                *
      *  42 - Error in Adjustment Amount                              *
      *  43 - Error in Amount Sign                                    *
      *  44 - Error in Currency                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrReset    - Clears Input Screen                             *
      *  SrClear    - Clear Program Message File                      *
      *  SrValidate - Validate Input                                  *
      *  SrValAuth  - Validate Authorities                            *
      *  SrUpdate   - Update of Database file                         *
      *  SrCurr     - Calls to AOCURRR0                               *
      *  SrSndMsg   - Send Error Message                              *
      *  SrInit     - Initialise fields                               *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas MM Adjustment to Authorisation Input
     FMM002250DFCF   E             WORKSTN INFSR(*PSSR)
 
      ** Midas MM Deals File
     FDEALS     UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
 
      ** Midas MM Effective Interest Rate Details EATRAN/EASTDT
     FMMEIRDL0  UF   E           K DISK    INFSR(*PSSR) COMMIT
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
     D DLARR@          S              2    DIM(14) CTDATA PERRCD(1)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Layout for the RUNDAT data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for Currency Details File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Data Structure to retrieve DEALING ICD details                                       245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D QQACC1        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
      ** External data structure for Customer Details File
     D DealFmt       E DS                  EXTNAME(DEALSDD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZALIGNOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D PRetCode        S              7A
     D POption         S              7A
     D PAction         S              1A
     D PBranch         S              3A
     D PErrCode        S              1P 0
     D PKey            S             10A
     D PStatus         S              7A
     D PCurr           S              3A
 
     D PMsgFile        S             10A   INZ('DRSMM')
     D PMsgId          S             10A
 
     D WCUST           S             10A
     D*WCNUM****       S              6S 0                                                    CSD027
     D WCNUM           S              6A                                                      CSD027
     D WDLNO           S              6S 0
     D WAMNT           S             15P 0
 
     D WErrFlgs        S              5A   INZ(*BLANKS)
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialise fields
 
     C                   EXSR      SrInit
 
     C                   DOW       *IN03 <> *ON
 
     C                   IF        WErrFlgs = '00000' OR *IN05 = *ON
     C                   EXSR      SrReset
     C                   ENDIF
 
      ** Write Message Control, Header and Footer
 
     C                   WRITE     MM002250C0
     C                   WRITE     MM002250F0
     C                   WRITE     MM002250F2
 
      ** Execute format Detail Screen
 
     C                   EXFMT     MM002250F1
 
      ** Clear Program Message File
 
     C                   EXSR      SrClear
 
     C                   IF        *IN03 <> *ON AND *IN05 <> *ON
     C                   EXSR      SrValidate
     C                   ENDIF
 
     C                   ENDDO
 
      ** End of Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReset - Clears Input Screen                                 *
      *                                                               *
      *****************************************************************
 
     C     SrReset       BEGSR
 
      ** Clear Error Indicators
 
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
 
      ** Clear Input Fields
 
     C                   EVAL      #1DLNO = *BLANKS
     C                   EVAL      #1CUST = *BLANKS
     C                   EVAL      #1AMNT = *BLANKS
     C                   EVAL      #1SIGN = *BLANKS
     C                   EVAL      #1CURR = *BLANKS
 
      ** Clear Program Messages
 
     C                   EXSR      SrClear
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClear - Clear Program Message File                          *
      *                                                               *
      *****************************************************************
 
     C     SrClear       BEGSR
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidate - Validate Input                                   *
      *                                                               *
      *****************************************************************
 
     C     SrValidate    BEGSR
 
      ** Clear Error Indicators
 
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   CLEAR                   DealFmt
 
      ** Validate Deal Number from DEALSDC and DEALSDD (Money Market
      ** and Negotiable Assets)
 
     C                   MOVE      #1DLNO        WDLNO
 
      ** Validate Deal Number
      ** Check if Deal Number exists on the deals file
 
     C     WDLNO         CHAIN     DEALS
     C                   IF        %FOUND(DEALS)
      *
     C     DTYP          LOOKUP    DLARR@                                 85
 
     C                   SELECT
     C                   WHEN      AGRDNB <= VDAT
     C                             OR RECI = 'R'
 
      ** Display "The entry does not reference a current deal"
 
     C                   EVAL      PMsgId = 'DLM1025'
     C                   EVAL      *IN40 = *ON
 
     C                   WHEN      AGRDNB > MDAT AND MDAT <> *ZERO
     C                             OR RECI = 'E'
 
      ** Display "The entry does not reference a current deal"
 
     C                   EVAL      PMsgId = 'DLM1025'
     C                   EVAL      *IN40 = *ON
 
     C                   WHEN      *IN85 = *OFF
 
      ** Display "Adj. is only allowed in deal types: ....'
 
     C                   EVAL      PMsgId = 'DLM1027'
     C                   EVAL      *IN40 = *ON
 
     C                   OTHER
     C                   EXSR      SrValAuth
     C                   ENDSL
 
      ** Display "The entry does not reference a current deal"
 
     C                   IF        *IN40 = *ON
     C                   EXSR      SrSndMsg
     C                   ENDIF
 
     C                   ELSE
 
      ** Display "The entry is not a valid entry on the Deals file"
 
     C                   EVAL      PMsgId = 'DLM1024'
     C                   EVAL      *IN40 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ENDIF
 
      ** Validate Customer
      ** Check if Customer exists on the deals file
 
     C                   MOVE      #1CUST        WCUST
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WCUST         PKey
     C                   PARM      *BLANKS       PStatus
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*KEY' AND
     C                             PRetCode <> '*NRF' AND
     C                             PRetCode <> '*NOSEL'
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDCUSTPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = '*NRF' OR
     C                             PRetCode = '*KEY' OR
     C                             PRetCode = '*NOSEL'
 
      ** Display "Customer must be a number or shortname which exists
      ** on file"
 
     C                   EVAL      PMsgId = 'FXM0205'
     C                   EVAL      *IN41 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ELSE
 
     C                   MOVE      BBCUST        WCNUM
     C                   IF        CNUM <> WCNUM
 
      ** Display "The customer number or shortname is not the deal
      ** customer"
 
     C                   EVAL      PMsgId = 'MMM0699'
     C                   EVAL      *IN41 = *ON
     C                   EXSR      SrSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
      ** If user entered '?', load up Shortname from file
 
     C                   IF        #1CUST = '?' AND PRetCode <> '*NOSEL'
     C                   EVAL      #1CUST = BBCSSN
     C                   ENDIF
 
      ** Validate Amount
      ** Check if Amount entered is blank
 
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      #1AMNT        @@ALPH                                       245692
     C                   MOVE      *BLANKS       @@MTID                                       245692
     C**********         EVALR     ZField = #1AMNT                                            245692
 
     C**********         IF        ZField <> *BLANKS                                          245692
     C                   IF        @@ALPH <> *BLANKS                                          245692
 
      ** Get number of decimal places from AOCURRR0
 
     C                   EVAL      PCurr = CCY
     C                   EXSR      SrCurr
     C**********         EVAL      ZADIG = 13 - A6NBDP                                        245692
     C                   Z-ADD     A6NBDP        @@IDP                                        245692
     C     13            SUB       @@IDP         @@IINT                                       245692
 
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM      *BLANKS       ZALIGNok                                     245692
     C**********         PARM                    ZField                                       245692
     C**********         PARM      A6NBDP        ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
     C**********         IF        ZALIGNok <> 'Y'                                            245692
     C                   IF        @@ERCD <> 0                                                245692
 
      ** Display "The entry is not a valid amount"
 
     C                   EVAL      PMsgId = 'MMA0574'
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ELSE
 
     C                   EVAL      WAMNT = *ZEROS
     C**********         MOVE      ZField        WAMNT                                        245692
     C                   MOVE      @@AMT         WAMNT                                        245692
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZField        #1AMNT
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Display "Adjustment Amount must be entered"
 
     C                   EVAL      PMsgId = 'FXM0026'
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SrSndMsg
     C                   ENDIF
 
      ** Validate Sign
 
     C                   SELECT
 
     C                   WHEN      #1SIGN = *BLANKS
 
      ** Display "Sign must be entered"
 
     C                   EVAL      PMsgId = 'FXM0027'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SrSndMsg
 
     C                   WHEN      #1SIGN <> '+' AND #1SIGN <> '-'
 
      ** Display "The entry is not '+' or '-'"
 
     C                   EVAL      PMsgId = 'FXM0028'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ENDSL
 
      ** Validate Currency
      ** Check if Currency entered is blank
 
     C                   IF        #1CURR <> *BLANKS
 
      ** Check if currency exists in AOCURRR0
 
     C                   EVAL      PCurr = #1CURR
 
     C                   EXSR      SrCurr
 
      ** If user entered '?', load up Currency from file
 
     C                   IF        #1CURR = '?' AND PRetCode <> '*NOSEL'
     C                   EVAL      #1CURR = A6CYCD
     C                   ENDIF
 
     C                   IF        CCY <> #1CURR AND
     C                             PRetCode <> '*NOSEL'
 
      ** Display "Currency entered does not match currency of the deal"
 
     C                   EVAL      PMsgId = 'DLM0110'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ELSE
 
     C                   IF        PRetCode = '*NRF'
 
      ** Display "The entry is not a valid currency"
 
     C                   EVAL      PMsgId = 'MMM0202'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ENDIF
 
     C                   IF        PRetCode = '*NOSEL'
 
      ** Display "Currency must be entered"
 
     C                   EVAL      PMsgId = 'MMM0142'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SrSndMsg
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Display "Currency must be entered"
 
     C                   EVAL      PMsgId = 'MMM0142'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SrSndMsg
     C                   ENDIF
 
     C                   MOVEA     *IN(40)       WErrFlgs
 
     C                   IF        WErrFlgs = '00000'
     C                   EXSR      SrUpdate
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAuth - Validate Authorities                              *
      *                                                               *
      *****************************************************************
 
     C     SrValAuth     BEGSR
 
     C                   EVAL      PAction = 'A'
     C                   EVAL      PErrCode = *ZERO
 
     C                   IF        AGMBIN = 'Y'
 
      ** If multi-branching, check if Amend is authorised for branch
 
     C                   EVAL      PBranch = BRCA
 
      ** Midas SF validate action code for branch
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    PAction
     C                   PARM                    PBranch
     C                   PARM                    PErrCode
 
     C                   SELECT
 
     C                   WHEN      PErrCode = 1
 
      ** Display "No valid action codes for user/branch combination"
 
     C                   EVAL      PMsgId = 'FXM0290'
     C                   EVAL      *IN40 = *ON
 
     C                   WHEN      PErrCode = 2
 
      ** Display "Action code invalid for user/branch combination"
 
     C                   EVAL      PMsgId = 'FXM0291'
     C                   EVAL      *IN40 = *ON
 
      ** If Error Code is 0, Check Authority on Originating Branch
 
     C                   WHEN      BKOBUV = 'Y' AND BKOBRU = 'Y'
 
      ** Midas SF validate original branch/user
 
     C                   CALL      'ZVOBU'
     C                   PARM                    PBranch
     C                   PARM                    PErrCode
 
     C                   SELECT
 
     C                   WHEN      PErrCode = 1
 
      ** Display "No valid originating branches for user"
 
     C                   EVAL      PMsgId = 'FXM0287'
     C                   EVAL      *IN40 = *ON
 
     C                   WHEN      PErrCode = 2
 
      ** Display "Originating branch invalid for user"
 
     C                   EVAL      PMsgId = 'FXM0288'
     C                   EVAL      *IN40 = *ON
     C                   ENDSL
 
     C                   ENDSL
 
     C                   ELSE
 
      ** Midas SF validate action code
 
     C                   CALL      'ZVACTU'
     C                   PARM                    PAction
     C                   PARM                    PErrCode
 
     C                   IF        PErrCode <> 0
 
      ** Display "Action code invalid for user"
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PMsgId = 'FXM0292'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdate - Update of Database file                            *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BEGSR
 
     C                   IF        #1SIGN = '+'
     C                   EVAL      ANADJ = ANADJ + WAMNT
     C                   ELSE
     C                   EVAL      ANADJ = ANADJ - WAMNT
     C                   ENDIF
 
     C                   IF        RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   ENDIF
 
     C                   IF        RCDT = 'D'
     C                   UPDATE    DEALSDDF
     C                   ENDIF
 
     C     DLNO          CHAIN     MMEIRDL0
     C                   IF        %FOUND(MMEIRDL0) AND EIRCAL <> 'Y'
     C                   EVAL      EIRCAL = 'Y'
     C                   UPDATE    MMEIRDD0
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurr - Calls to AOCURRR0                                    *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** If Deal is read with no Currency, produce dump
 
     C                   IF        PRetCode <> *BLANKS AND
     C                             PRetCode <> '*NOSEL' AND
     C                             PRetCode <> '*NRF' OR
     C                             PRetCode = '*NRF' AND CCY = *BLANKS
     C                             AND DLNO <> *ZEROS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDCURRPD'
     C                   EVAL      Dbase = 2
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSndMsg - Send Error Message                                 *
      *                                                               *
      *****************************************************************
 
     C     SrSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Initialise fields                                    *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey = *BLANKS
     C                   EVAL      DbPGM = *BLANKS
     C                   EVAL      DbPGM = 'MM002250'
     C                   EVAL      Dbase = *ZERO
     C                   OUT       LDA
 
     C                   IN        RUNDAT
 
     C                   EVAL      #0RUND = AGMRDT
     C                   EVAL      #0USER = PSUSER
     C                   EVAL      #0WSID = PSJOBNAME
     C                   EVAL      #0PGM = PSPROCMOD
 
      ** Clear Program Message File
 
     C                   EXSR      SrClear
 
     C**********         CALLB     'AOGELRR0'                                                 CAS011
     C                   CALLB     'AOGELRR1'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CAS011
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS011
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDGELRPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       245692
     C                   CALLB     'AODEALR1'                                                 245692
     C                   PARM      *BLANKS       PRetCode                                     245692
     C                   PARM      '*FIRST '     POption                                      245692
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        245692
                                                                                              245692
     C                   IF        PRetCode <> *BLANKS                                        245692
     C     *LOCK         IN        LDA                                                        245692
     C                   EVAL      DbFile = 'SDDEALPD'                                        245692
     C                   EVAL      Dbase = 2                                                  245692
     C                   EVAL      DbKey = POption                                            245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
      *                                                                                       245692
 
     C                   EXSR      SrReset
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
** DLARR@
IP
TI
CL
DL
IT
TD
CI
CD
C2
BP
BD
TB
DA
TA
