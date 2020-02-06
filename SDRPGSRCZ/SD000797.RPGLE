     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Limit Utilisation Prompt')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000797 - Midas SD Limit Utilisation Prompt                 *
      *                                                               *
      *  Function:  This new prompt program enables the selection     *
      *             criteria for the limit utilisation report to be   *
      *             printed.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24935           Date 17Jul09               *
      *                 BUG24247           Date 09Jun09               *
      *                 BUG24574           Date 07Jul09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG23652A          Date 05Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG23652           Date 19May09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG23141           Date 27Feb09               *
      *                 BUG22795           Date 11Feb09               *
      *                 BUG22591           Date 03Feb09               *
      *                 BUG22592           Date 03Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24935 - Limit Utilisation Report shows a minus            *
      *             figure/incorrect Threshold Excess                 *
      *  BUG24247 - DBERRCTL encountered in Limit Utilisation Report  *
      *             printing - Applied BUG23652A fix                  *
      *  BUG24574 - Withholding Tax - R4 vs M+                        *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG23652A - Limit Utilisation Enquiry - Print Option         *
      *             Function Keys Validation                          *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG23652 - Limit Utilisation Enquiry - Print Option          *
      *             Function Keys Validation                          *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG23141 - Remove Tax Type E from Selection                  *
      *  BUG22795 - Enhance validation of Customer range selection    *
      *  BUG22591 - No Validation on Year                             *
      *  BUG22592 - Incorrect Tax Types selection                     *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *  *IN03  -  F3  pressed, exit program                          *
      *  *IN12  -  F12 pressed, exit program                          *
      *  *IN05  -  F05 pressed, refresh screen                        *
      *  *IN20  -  Error on field DDCUST                              *
      *  *IN21  -  Error on field DDCUSTF                             *
      *  *IN22  -  Error on field DDCUSTT                             *
      *  *IN24  -  Error on field DDTAXT                              *
      *  *IN25  -  Error on field DDACOF                              *
      *  *IN26  -  Error on field DDBRCA                              *
      *  *IN27  -  Error on field DDALL                               *
      *  *IN28  -  Error on field DDYEAR                              *
      *  *IN55  -  SFLEND control                                     *
      *  *IN75  -  General error indicator                            *
      *  *IN77  -  Working field for scan '?'                         *
      *                                                               *
      *  *INLR  -  End processing                                     *
      *  *INU7  -  Data-base                                          *
      *  *INU8  -  Error control                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  *INZSR     Initial processing                                *
      *  SRVals     Validate fields: 1 selection allowed              *
      *  SRCust     Validate Customer Number                          *
      *  SRCustf    Validate Customer Number from                     *
      *  SRCustt    Validate Customer Number to                       *
      *  SRTaxt     Validate Tax Type                                 *
      *  SRAcof     Validate Account Officer                          *
      *  SRBrca     Validate Branch Code                              *
      *  SRAll      Validate All                                      *
      *  SRYear     Validate Selected Year                            *
      *  SRZasnms   Send message to program's message queue           *
      *  *PSSR      Error subroutine                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSD000797DFCF   E             WORKSTN
      *
     FSDINPHL1  IF   E           K DISK    USROPN
      *
      *****************************************************************
     F/EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
     D ArrDer          S              1A   DIM(10)
      *
      ** Data area system *LDA
      *
     D SAVLDA          DS          1024
     D  LdaCus                 1      6
     D  LdaYea                 7      8
      *
      **  RCF parameter data structure
      *
     D PRparm          DS           246
     D  PCust                  1      6
     D  PCustf                 7     12
     D  PCustt                13     18
     D  PTaxt                 23     24
     D  PAcof                 25     26
     D  PBrca                 27     29
     D  PAll                  30     30
     D  PYear                 31     34
      *
      ** Parameters for access object
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey10          S             10A
     D PKyst           S              7A
     D PKey2           S              2A
     D PKey3           S              3A
      *
      ** Entery paramter List
      *
     D PRseq           S              5A
     D PRlev           S              1A
     D PRent           S              3A
     D PRact           S              1A
     D PRcmd           S              1A
      *
      ** Parameters for Y2SNMGC
      *
     D PZaPgmq         S             10A
     D PZaPgrl         S              5A
     D PZaMsid         S              7A
     D PZaMsgf         S             10A
     D PZaMsda         S            132A
     D PZaMstp         S              7A
      *
      ** Parameters for ZDATE9
      *
     D PZDayNo         S              5P 0
     D PZDate1         S              8S 0
     D PErrorFlag      S              1A
      *
      ** First DS for access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Account Officer
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** External DS for Customer Number
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Branch Code
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QDFAC        E                     EXTFLD(QQDFAC)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Country code details                                   BUG24935
      *                                                                                     BUG24935
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24935
      *                                                                                     BUG24935
      ** External data structures for Location Details                                      BUG24935
      *                                                                                     BUG24935
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24935
      *                                                                                     BUG24935
      ** Data structure for SR. ZDATE9 - field is WkVdt
      *
      * FKDTA Data Area                                                                     BUG23652
     D FKDTA           DS                  DTAARA(FKDTA)                                    BUG23652
     D  FKey                   1      3                                                     BUG23652
      *
     D                 DS
     D WkVdt                   1      8  0
     D WwCt                    1      2  0
     D WwYr                    1      4  0
     D WwZ71m                  5      6  0
     D WwZ71d                  7      8  0
      *
      ** Override history file
      *
     D***WOVRDB*         C                   'OVRDBF SDINPHL1 SDINPHL1'                     BUG24574
     D***WOVRDB*         C                   'OVRDBF SDINPHPD SDINPHPD'            BUG24574 BUG24935
     D WOVRDB          C                   'OVRDBF SDINPHL1 SDINPHL1 SDINPHL1'              BUG24935
      *
      ** Delete override history file
      *
     D WDLOVR          C                   'DLTOVR SDINPHL1'
      *
      ** Work variables
      *
     D WkRtn           S              1A
     D WkI             S              2P 0
     D WkJ             S              2P 0
     D WkLeap          S              1P 0
     D WkScustn        S              6A
     D WkDayn          S              5P 0
     D WkRday          S              5P 0
     D WkCts           S              3P 0
     D WkYear          S              4P 0
     D WkTesty         S              2A
     D WkRtcd          S              1A
     D*WkCmd****       S             30A                                                    BUG24935
     D WkCmd           S             40A                                                    BUG24935
     D WkLen           S             15P 5
     D WkResul         S              1P 0
     D WRun            S              1A
      *
      ** Index for loop
      *
     D Wi              S              3P 0
     D Wj              S              3P 0
      *                                                                                     BUG24935
     D WYrEndD         S              6A                                                    BUG24935
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **         P R O G R A M    S T A R T                           *
      *****************************************************************
      *
      ** Test if called from the 'Limit Utilisation Enquiry' (*LDA not
      ** empty) or from the menus (*LDA empty). If *LDA is not empty
      ** do not show the prompt screen, just fill the list parameters
      ** with the values of *LDA
      *
     C                   IF        LdaCus <> *BLANKS
      *
     C                   EVAL      PRparm = *BLANKS
     C                   EVAL      PCust = LdaCus
      *
     C                   IF        LdaYea <> *BLANKS
      *
     C                   MOVEL     WwCt          PYear
     C                   EVAL      PYear = LdaYea
      *
     C                   ENDIF
      *
      ** End program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
      ** Display screen
      *
     C                   DOW       *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             *IN75 = *ON
      *
     C                   WRITE     DMSGCTL
     C                   EXFMT     SD000797F0
      *
      ** Initialize program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         PZaPgmq
     C                   PARM      '*SAME'       PZaPgrl
      *
      ** If F3 was pressed send termination code of 'E' back to RCF
      *
     C                   IF        *IN03 = *ON
      *
     C                   EVAL      PRparm = *BLANKS
     C                   EVAL      PRcmd = 'E'
      *
     C                   ENDIF
      *
      ** If F12 was pressed send termination code of 'F' back to RCF
      *
     C                   IF        *IN12 = *ON
      *
     C                   EVAL      PRparm = *BLANKS
     C                   EVAL      PRcmd = 'F'
      *
     C                   ENDIF
      *
      ** If F5 was pressed refresh screen
      *
     C                   IF        *IN05 = *ON
      *
     C                   EVAL      PRparm = *BLANKS
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDCUSTT = *BLANKS
     C                   EVAL      DDCUSTF = *BLANKS
     C                   EVAL      DDTAXT = *BLANKS
     C                   EVAL      DDACOF = *BLANKS
     C                   EVAL      DDBRCA = *BLANKS
     C                   EVAL      DDALL = *BLANKS
     C                   EVAL      DDYEAR = *BLANKS
      *
     C                   ENDIF
      *
      ** Initialize indicator
      *
     C                   MOVEA     '0000000'     *IN(20)
     C                   MOVEA     '00'          *IN(27)
      *
      **  F12 and F3 and F5 not pressed
      *
     C                   IF        *IN03 = *OFF AND
     C                             *IN12 = *OFF AND
     C                             *IN05 = *OFF
      *
     C                   EVAL      *IN75 = *OFF
      *
      ** Only one selection allowed
      *
     C                   EXSR      SRVals
      *                                                                                     BUG22591
      ** Validate Year                                                                      BUG22591
      *                                                                                     BUG22591
     C                   EXSR      SRYear                                                   BUG22591
      *
      ** Validate fields
      *
     C                   IF        *IN75 = *OFF
      *
     C**********         EXSR      SRYear                                                   BUG22591
     C                   EXSR      SRCust
     C                   EXSR      SRCustf
     C                   EXSR      SRCustt
     C                   EXSR      SRTaxt
     C                   EXSR      SRAcof
     C                   EXSR      SRBrca
     C                   EXSR      SRAll
      *
     C                   ENDIF
      *
      ** No errors, setup parameter
      *
     C                   IF        *IN75 = *OFF
      *
     C                   EVAL      PRparm = *BLANKS
     C                   EVAL      PCust  = DDCUST
     C                   EVAL      PCustt = DDCUSTT
     C                   EVAL      PCustf = DDCUSTF
     C                   EVAL      PTaxt  = DDTAXT
     C                   EVAL      PAcof  = DDACOF
     C                   EVAL      PBrca  = DDBRCA
     C                   EVAL      PAll = DDALL
      *
     C                   IF        WkYear <> WwYr
     C                   EVAL      PYear = DDYEAR
     C                   ENDIF
      *
     C                   MONITOR                                                           BUG23652A
     C     *LOCK         IN        FKDTA                                                    BUG23652
     C                   ON-ERROR                                                          BUG23652A
     C                   GOTO      SKIP                                                    BUG23652A
     C                   ENDMON                                                            BUG23652A
     C                   EVAL      FKEY = 'FOK'                                             BUG23652
     C                   OUT       FKDTA                                                    BUG23652
     C     SKIP          TAG                                                               BUG23652A
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *****************************************************************
      **         P R O G R A M    E N D                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVals - one selection allowed                               *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRVals        BEGSR
      *
     C                   Z-ADD     *ZEROS        WkCts
     C                   MOVEA     *BLANKS       ArrDer
      *
     C                   IF        DDCUST <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
     C                   MOVEL     '1'           ArrDer(1)
      *
     C                   ENDIF
      *
     C                   IF        DDCUSTF <> *BLANKS OR
     C                             DDCUSTT <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
      *
     C                   IF        DDCUSTF <> *BLANKS
     C                   MOVEL     '1'           ArrDer(2)
     C                   ENDIF
     C                   IF        DDCUSTT <> *BLANKS
     C                   MOVEL     '1'           ArrDer(3)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDTAXT <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
     C                   MOVEL     '1'           ArrDer(5)
      *
     C                   ENDIF
      *
     C                   IF        DDACOF <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
     C                   MOVEL     '1'           ArrDer(6)
      *
     C                   ENDIF
      *
     C                   IF        DDBRCA <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
     C                   MOVEL     '1'           ArrDer(7)
      *
     C                   ENDIF
      *
     C                   IF        DDALL <> *BLANKS
      *
     C                   EVAL      WkCts = WkCts + 1
     C                   MOVEL     '1'           ArrDer(8)
      *
     C                   ENDIF
      *
      ** Only One selection allowed
      *
     C                   IF        WkCts > 1
      *
     C                   MOVEL     'SDC0001'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
      *
      ** Set error indicators
      *
     C                   EVAL      Wi = 1
     C                   DOW       Wi <= 8
      *
     C                   IF        ArrDer(Wi) = '1'
      *
     C                   EVAL      Wj = Wi + 19
     C                   MOVEL     '1'           *IN(Wj)
     C                   ENDIF
     C                   EVAL      Wi = Wi + 1
      *
     C                   ENDDO
      *
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
      ** Any selection, redisplay the screen
      *
     C                   IF        WkCts = *ZEROS
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRYear - Validate Selected Year                              *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRYear        BEGSR
      *
      ** Selected year : Default to current year
      *
     C                   IF        DDYEAR = *BLANKS
     C                   MOVEL     WwYr          DDYEAR
     C                   ENDIF
      *
     C                   MOVEL     DDYEAR        WkYear
     C                   IF        WkYear <> WwYr
      *
      ** Must be valid year
      *
     C                   TESTN                   DDYEAR               78
     C                   IF        *IN78 = *OFF
      *
     C                   MOVEL     'USR8250'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
      ** Must be a valid year prior current year
      *
     C                   IF        WkYear > WwYr
      *
     C                   MOVEL     'USR8251'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
      ** Check this year history file exists
      *
     C                   MOVE      DDYEAR        WkTesty
      *
     C                   CALL      'SDC000797'
     C                   PARM                    WkTesty
     C                   PARM      *BLANKS       WkRtcd
      *
     C                   IF        WkRtcd <> *BLANKS
      *
     C                   MOVEL     'USR8252'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCust - Validate Customer Number                            *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCust        BEGSR
      *
     C                   IF        DDCUST <> *BLANKS
      *
      ** Check if customer exists
      *
     C                   EVAL      WkResul = %SCAN('?':DDCUST)
      *
     C                   EVAL      *IN77 = *OFF                                             BUG22795
     C                   IF        WkResul >=  1
     C                   EVAL      *IN77 = *ON
     C                   MOVE      *BLANKS       DDCUST
     C                   MOVEL     '?'           DDCUST
      *
     C                   ENDIF
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUST        PKey10
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   MOVEL     'SDM0113'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN20 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   IF        *IN77 = *ON
      *
     C                   MOVEL     BBCUST        DDCUST
     C                   EVAL      *IN75 = *ON
      *
     C                   ENDIF
      *
      ** The selected customer must be exist in the History
      ** header file
      ** Retrieve the history file if exist (indicator 28)
      *
     C                   IF        WkYear <> WwYr AND
     C                             *IN28 = *OFF
      *
     C                   EVAL      WkCmd = WOVRDB + WkTesty
     C                   CALL      'QCMDEXC'
     C                   PARM                    WkCmd
     C**********         PARM      30            WkLen                                      BUG24935
     C                   PARM      40            WkLen                                      BUG24935
      *
     C                   ENDIF
      *
     C                   OPEN      SDINPHL1
      *
     C                   MOVE      DDCUST        WkScustn
     C     WkScustn      CHAIN     SDINPHL1
     C                   IF        NOT %FOUND(SDINPHL1)
      *
     C                   MOVEL     'USR8246'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN20 = *ON
     C                   EXSR      SRZasnms
      *
     C                   ENDIF
      *
     C                   CLOSE     SDINPHL1
      *
     C                   IF        WkYear <> WwYr AND
     C                             *IN28 = *OFF
      *
     C                   MOVEL(P)  WDLOVR        WkCmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    WkCmd
     C**********         PARM      30            WkLen                                      BUG24935
     C                   PARM      40            WkLen                                      BUG24935
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCustf - Validate Customer Number from                      *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
     C     SRCustf       BEGSR
      *
      ** If Customer Number from is blank and customer to is entered
      ** -> error The 2 customers must be entered or none
      *
     C                   IF        DDCUSTF = *BLANKS AND
     C                             DDCUSTT <> *BLANKS
      *
     C                   MOVEL     'USR8253'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   IF        DDCUSTF <> *BLANKS
      *
      ** Check if customer from  exists
      *
     C                   EVAL      WkResul = %SCAN('?':DDCUSTF)
     C                   EVAL      *IN77 = *OFF                                             BUG22795
     C                   IF        WkResul >= 1
      *
     C                   EVAL      *IN77 = *ON
     C                   MOVE      *BLANKS       DDCUSTF
     C                   MOVEL     '?'           DDCUSTF
      *
     C**********         ENDIF                                                              BUG22795
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUSTF       PKey10
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   MOVEL     'SDM0113'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *                                                                                     BUG22795
     C                   ENDIF                                                              BUG22795
      *
     C                   IF        *IN77 = *ON
      *
     C                   MOVEL     BBCUST        DDCUSTF
     C                   EVAL      *IN75 = *ON
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     END1          TAG
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCustt     Validate Customer Number to                      *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRCustt       BEGSR
      *
      ** If Customer Number to is blank and customer from is entered
      ** -> error The 2 customers must be entered or none
      *
     C                   IF        DDCUSTT = *BLANKS AND
     C                             DDCUSTF <> *BLANKS
      *
     C                   MOVEL     'USR8253'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   IF        DDCUSTT <> *BLANKS
      *
      ** Check if customer to exists
      *
     C                   EVAL      WkResul = %SCAN('?':DDCUSTT)
     C                   EVAL      *IN77 = *OFF                                             BUG22795
     C                   IF        WkResul >= 1
      *
     C                   EVAL      *IN77 = *ON
     C                   MOVE      *BLANKS       DDCUSTT
     C                   MOVEL     '?'           DDCUSTT
      *
     C**********         ENDIF                                                              BUG22795
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUSTT       PKey10
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   MOVEL     'SDM0113'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *                                                                                     BUG22795
     C                   ENDIF                                                              BUG22795
      *
     C                   IF        *IN77 = *ON
      *
     C                   MOVEL     BBCUST        DDCUSTT
     C                   EVAL      *IN75 = *ON
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Customer to must be greater or equal to Customer from
      *
     C                   IF        DDCUSTT < DDCUSTF
      *
     C                   MOVEL     'USR8254'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRTaxt - Validate Tax Type                                   *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTaxt        BEGSR
      *
      ** Optional.*if*entered*must*be*'E*'*'G*'*'N*'*'Z*'                                   BUG23141
      ** Optional. if entered must be 'S ' 'T ' 'D '                                        BUG23141
      *
     C**********         IF        DDTAXT <> 'E ' AND                                       BUG23141
     C**********                   DDTAXT <> 'G ' AND                                       BUG22592
     C**********                   DDTAXT <> 'N ' AND                                       BUG22592
     C**********                   DDTAXT <> 'Z ' AND                                       BUG22592
     C**********                   DDTAXT <> 'D ' AND                              BUG22592 BUG23141
     C                   IF        DDTAXT <> 'D ' AND                                       BUG23141
     C                             DDTAXT <> 'T ' AND                                       BUG22592
     C                             DDTAXT <> 'S ' AND                                       BUG22592
     C                             DDTAXT <> *BLANKS
      *
     C                   MOVEL     'USR8255'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRAcof - Validate Account Officer                            *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAcof        BEGSR
      *
     C                   IF        DDACOF <> *BLANKS
      *
      ** Check if account officer exists
      *
     C                   EVAL      WkResul = %SCAN('?':DDACOF)
     C                   IF        WkResul >= 1
      *
     C                   EVAL      *IN77 = *ON
     C                   MOVE      *BLANKS       DDACOF
     C                   MOVEL     '?'           DDACOF
     C                   ENDIF
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDACOF        PKey2
     C     SDACOF        PARM      SDACOF        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   MOVEL     'USR8256'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   IF        WkResul >= 1
      *
     C                   MOVEL     AZACOC        DDACOF
     C                   EVAL      *IN75 = *ON
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBrca - Validate Branch Code                                *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRBrca        BEGSR
      *
     C                   IF        DDBRCA <> *BLANKS
      *
      ** Check if Branch code exists
      *
     C                   EVAL      WkResul = %SCAN('?':DDBRCA)
     C                   EVAL      *IN77 = *OFF                                             BUG22795
     C                   IF        WkResul >= 1
      *
     C                   EVAL      *IN77 = *ON
     C                   MOVE      *BLANKS       DDBRCA
     C                   MOVEL     '?'           DDBRCA
     C                   ENDIF
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDBRCA        PKey3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   MOVEL     'USR8257'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN26 = *ON
     C                   EXSR      SRZasnms
     C                   LEAVESR
      *
     C                   ENDIF
      *
     C                   IF        *IN77 = *ON
      *
     C                   MOVEL     A8BRCD        DDBRCA
     C                   EVAL      *IN75 = *ON
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRAll - Validate All                                         *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: SRZasnms                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAll         BEGSR
      *
      ** Must be 'Y' or ' '
      *
     C                   IF        DDALL <> 'Y' AND
     C                             DDALL <> *BLANKS
      *
     C                   MOVEL     'USR8258'     PZaMsid
     C                   MOVEL     'GBSDUSRMSG'  PZaMsgf
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN27 = *ON
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Initial processing                                 *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define parameters list
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRseq
     C                   PARM                    PRlev
     C                   PARM                    PRent
     C                   PARM                    PRparm
     C                   PARM                    PRact
     C                   PARM                    PRcmd
      *
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDJOB = PSJObName
      *
      ** Access Withholding Tax Control data
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'SD000797'    DBPGM
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *                                                                                     BUG24935
      ** Access Location Code Details                                                       BUG24935
      *                                                                                     BUG24935
     C                   CALL      'AOLOCNR0'                                               BUG24935
     C                   PARM      *BLANKS       PRtCd                                      BUG24935
     C                   PARM      '*KEY'        POptn                                      BUG24935
     C                   PARM      BJSLCD        PLoCod            3                        BUG24935
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG24935
      *                                                                                     BUG24935
     C                   IF        PRtCd <> *BLANKS                                         BUG24935
     C     *LOCK         IN        LDA                                                      BUG24935
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG24935
     C                   EVAL      DBKEY  = PLoCod                                          BUG24935
     C                   EVAL      DBASE  = 002                                             BUG24935
     C                   OUT       LDA                                                      BUG24935
     C                   EXSR      *PSSR                                                    BUG24935
     C                   ENDIF                                                              BUG24935
      *                                                                                     BUG24935
      ** Access Country Code Details                                                        BUG24935
      *                                                                                     BUG24935
     C                   CALL      'AOCTRYR0'                                               BUG24935
     C                   PARM      *BLANKS       PRtCd                                      BUG24935
     C                   PARM      '*KEY'        POptn                                      BUG24935
     C                   PARM      DVCNCD        PCtCod            2                        BUG24935
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG24935
      *                                                                                     BUG24935
     C                   IF        PRtCd <> *BLANKS                                         BUG24935
     C     *LOCK         IN        LDA                                                      BUG24935
     C                   EVAL      DBFILE = 'SDCTRYPD'                                      BUG24935
     C                   EVAL      DBKEY  = PCtCod                                          BUG24935
     C                   EVAL      DBASE  = 003                                             BUG24935
     C                   OUT       LDA                                                      BUG24935
     C                   EXSR      *PSSR                                                    BUG24935
     C                   ELSE                                                               BUG24935
      *
     C**********         EVAL      WkDayn = BJRDNB                                          BUG24280
     C**********         EVAL      WkDayn = BJEYD                                  BUG24280 BUG24935
     C                   EVAL      WkDayn = BJRDNB                                          BUG24935
     C                   CALLB     'ZDATE9'
     C                   PARM      WkDayn        PZDayNo
     C                   PARM      *ZEROS        PZDate1
     C                   PARM      *BLANKS       PErrorFlag
      *
     C                   IF        PErrorFlag = '0'
     C                   MOVEL     PZDate1       WwYr
     C                   ENDIF
      *                                                                                     BUG24935
     C                   MOVE      WwYr          WYrEndD                                    BUG24935
     C                   MOVEL     A4ETXY        WYrEndD                                    BUG24935
      *                                                                                     BUG24935
     C                   CALLB     'ZDATE1'                                                 BUG24935
     C                   PARM                    WYrEndD                                    BUG24935
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24935
     C                   PARM                    BJDFIN                                     BUG24935
     C                   PARM      *BLANKS       PErrorFlag                                 BUG24935
     C                   Z-ADD     PZDAYNO       WETYear           5 0                      BUG24935
     C                   IF        WETYear <  BJRDNB                                        BUG24935
     C                   ADD       1             WwYr                                       BUG24935
     C                   ENDIF                                                              BUG24935
     C                   ENDIF                                                              BUG24935
      *
      ** Initialise general error indicator and return parameters
      *
     C                   EVAL      *IN75 = *ON
     C                   MOVE      *BLANKS       PRparm
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRZasnms - Send message to program's message queue           *
      *                                                               *
      *  Called by: SRCust, SRCustf, SRCustt, SRTaxt, SRBrca, SRAll   *
      *             SRYear                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRZasnms      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   IF        PZaPgmq = *BLANKS
     C                   MOVEL     DDPGM         PZaPgmq
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZaPgmq
     C                   PARM                    PZaPgrl
     C                   PARM                    PZaMsid
     C                   PARM                    PZaMsgf
     C                   PARM                    PZaMsda
     C                   PARM                    PZaMstp
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        PZaPgmq
     C                   MOVEL     *BLANK        PZaPgrl
     C                   MOVEL     *BLANK        PZaMsda
     C                   MOVEL     *BLANK        PZaMstp
     C                   MOVEL     *BLANK        PZaMsgf
     C                   MOVEL     *BLANK        PZaMsid
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: DBERRCTL                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
      ** Call DBERRCTL if Interactive program
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
      ** End program if DBERRCTL not called
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
