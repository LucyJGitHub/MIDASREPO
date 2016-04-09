     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Retrieve outgoing payments SSI details')      *
      **********************************************************************
      *                                                                    *
      *  Midas - API Funds Transfer Module                                 *
      *                                                                    *
      *  FTOPSIRTV - Outgoing Payments SSI Retrieval Module                *
      *                                                                    *
      *  Function:  This retieves details of Funds Transfer Outgoing       *
      *             Payments Standard Settlement Instructions and          *
      *             validates the action code against them.                *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2002                 *
      *                                                                    *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 217769             Date 09Jun03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217769 - OPSS - Can not Exit if invalid action entered            *
      *         - Changed the error message ID                             *
      *  CFT018 - Standard Settlement Instructions for Funds Transfer      *
      *           Outgoing Payments                                        *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FFTOSSIL0  IF   E           K DISK    INFSR(*PSSR)
      ** Outgoing Payments Standard Settlement Instructions Master File
      *
     FFTOSIXL0  IF   E           K DISK    PREFIX(X)
     F                                     RENAME(FTOSSID0: FTOSIXD0)
     F                                     INFSR(*PSSR)
      **  Unauthorised Outgoing Payments Standard Settlement Instructions
      *
      *
      *****************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
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
      *
     D SDRCY           S                   LIKE(OSDRCY)
     D SDRAC           S                   LIKE(OSDRAC)
     D SREF1           S                   LIKE(OSREF1)
     D SREF2           S                   LIKE(OSREF2)
     D SCRCY           S                   LIKE(OSCRCY)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIFileFmtX   E DS                  EXTNAME(FTOSIXPD)
     D                                     PREFIX(X)
      * Current Unauthorised Outgoing Payment SSI in File Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D  QQDRA1       E                     EXTFLD(QQDRAC)                                     CGL029
     D  QQORB1       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for currency codes
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB )
      * External data structure for currency codes
     D                                     PREFIX(AC)
      *
     D W@DRAC          DS
      * Data structure for debit acount
     D W@Retl                  1     10
     D*W@Blnks**              11     15                                                       CGL029
     D W@Blnks                11     21                                                       CGL029
     D W@Cust                  1      6
     D W@Acod                  7     16                                                       CGL029
     D W@Acsq                 17     18                                                       CGL029
     D W@Brch                 19     21                                                       CGL029
     D*W@Acod***               7     10                                                       CGL029
     D*W@Acsq***              11     12                                                       CGL029
     D*W@Brch***              13     15                                                       CGL029
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL029
      ** Account Code Parameter                                                               CGL029
     D PAcod           S             10A                                                      CGL029
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialisation
     C                   Exsr      INIT
      *
      ** Validate action code and return to calling program if any errors
     C                   Exsr      ValAction
     C     Ix            Ifne      *Zero
     C                   Return
     C                   Endif
      *
      ** Retrieve SSI details
     C                   Exsr      RtvSSIDtls
      *
      ** Validate SSI details and return to calling program if any errors
     C                   Exsr      ValSSIDtls
     C     Ix            Ifne      *Zero
     C                   Return
     C                   Endif
      *
      ** Validate key details if action is insert
     C     ACTION        Ifeq      'I'
     C                   Exsr      ValSSIKey
     C     Ix            Ifne      *Zero
     C                   Return
     C                   Endif
     C                   Endif
      *
      ** Check that user is authorised
     C     @RESPMODE     Ifeq      'S'
     C                   Exsr      ValSecurity
     C                   Endif
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      *****************************************************************
      * INIT - Initialisation Processing each time module is invoked
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Reset error message arrays and fields
     C                   Z-add     *Zero         Ix                3 0
     C                   Z-add     *Zero         WIdx
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      **  Clear all output
     C                   Clear                   SSIFileFmt
      *
      **  Reset error flag indicators
     C                   Movel     'Y'           OKACTION
     C                   Movel     'Y'           OKDRCY
     C                   Movel     'Y'           OKDRAC
     C                   Movel     'Y'           OKREF1
     C                   Movel     'Y'           OKREF2
     C                   Movel     'Y'           OKCRCY
     C                   Movel     'Y'           OKBRCA
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ValAction - Validate Action Code and Key Fields
      *****************************************************************
     C     ValAction     Begsr
      *
      **  Action code must be I,A,E,D,P or X
     C     ACTION        Ifne      'I'
     C     ACTION        andne     'A'
     C     ACTION        andne     'E'
     C     ACTION        andne     'D'
     C     ACTION        andne     'X'
     C     ACTION        andne     'P'
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C**********         Movel     'FTA0151'     MsgIdArr(Ix)                                 217769
     C                   Movel     'FTM1001'     MsgIdArr(Ix)                                 217769
     C                   Goto      EVALACT
     C                   Endif
      *
     C     EVALACT       Endsr
      /EJECT
      *****************************************************************
      * RtvSSIDtls  -  Retrieve SSI Details
      *****************************************************************
     C     RtvSSIDtls    Begsr
      *
      **  Reset file formats
     C                   Clear                   SSIFileFmt
     C                   Clear                   SSIFileFmtX
      *
      **  Retrieve SSI Details from main file
     C     K@OSSI        Chain     FTOSSIL0                           90
      *
      ** Retrieve unauthorised details if SSI is unauthorised
      ** and unauthroised details are flagged to be retrieved
     C     @RTVOSIX      Ifne      'N'
     C     OSSTAT        Ifeq      'C'
     C     OSSTAT        oreq      'R'
     C     K@OSSI        Chain     FTOSIXL0                           91
     C     *In91         Ifeq      *Off
     C                   Move      SSIFileFmtX   SSIFIleFmt
     C                   Endif
     C                   Endif
     C                   Endif
      *
      **  Set flag to indicate if record retrieved or not
     C     *In90         Ifeq      *Off
     C                   Move      'Y'           RcdRtvd           1
     C                   Else
     C                   Move      'N'           RcdRtvd
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ValSSIDtls - Validate SSI Details according to Action Code
      *****************************************************************
     C     ValSSIDtls    Begsr
      *
      ** If action is amend, enquire, delete or authorise details must exist
     C     ACTION        Ifeq      'A'
     C     ACTION        oreq      'E'
     C     ACTION        oreq      'D'
     C     ACTION        oreq      'X'
     C     ACTION        oreq      'P'
     C     RcdRtvd       Ifne      'Y'
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0161'     MsgIdArr(Ix)
     C                   Endif
     C                   Endif
      *
      *
      ** If action is insert details must not already exist
     C     ACTION        Ifeq      'I'
     C     RcdRtvd       andne     'N'
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0162'     MsgIdArr(Ix)
     C                   Endif
      *
      ** If action is authorise then details must be unauthorised
     C     ACTION        Ifeq      'X'
     C     RcdRtvd       andeq     'Y'
     C     OSSTAT        andne     'C'
     C     OSSTAT        andne     'R'
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0163'     MsgIdArr(Ix)
     C                   Endif
      *
      ** Deleted details may not only be enquired or printed
     C     ACTION        Ifne      'E'
     C     ACTION        andne     'P'
     C     RcdRtvd       andeq     'Y'
     C     OSSTAT        andeq     'D'
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0164'     MsgIdArr(Ix)
     C                   Endif
      *
      ** If action is authorise then must be different user to user
      ** who last actioned the transaction
     C     ACTION        Ifeq      'X'
     C     RcdRtvd       andeq     'Y'
     C     @RESPMODE     andeq     'S'
     C     @USRID        Ifeq      OSIUSR
     C     @BJRDNB       andeq     OSORED
     C     @USRID        oreq      OSAUSR
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FTA0168'     MsgIdArr(Ix)
     C                   Endif
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ValSSIKey - Validate Key Fields if Insert
      *****************************************************************
     C     ValSSIKey     Begsr
      *
      **  Debit Currency
     C                   Exsr      ValDRCY
      *
      **  Debit Account
     C                   Exsr      ValDRAC
      *
      **  Reference field 1
     C                   Exsr      ValREF1
      *
      **  Pay Currency
     C                   Exsr      ValCRCY
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ValSecurity -  Validate secuirty
      *****************************************************************
     C     ValSecurity   Begsr
      *
      * If not multi-branching, check authority to only action code
     C     @MBIN         Ifne      'Y'
     C                   Call      'ZVACTU'
     C                   Parm                    ACTION
     C                   Parm                    @@ERR             1 0
     C     @@ERR         Ifeq      1
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C                   Movel     'FXM0292'     MsgIdArr(Ix)
     C                   Endif
     C                   Endif
      *
      * If multi-branching check authority to booking branch for A,E,D,X
     C     @MBIN         Ifeq      'Y'
     C     ACTION        andne     'I'
     C                   Move      OSBRCA        ZBR
     C                   Call      'ZVACTBU'
     C                   Parm                    ACTION            1
     C                   Parm                    ZBR               3
     C                   Parm                    @@ERR
     C     @@ERR         Ifne      0
     C                   Move      'N'           OKACTION
     C                   Add       1             Ix
     C                   Movel     'SACTION'     FldNameArr(Ix)
     C     @@ERR         Ifeq      1
     C                   Movel     'FXM0290'     MsgIdArr(Ix)
     C                   Else
     C                   Movel     'FXM0291'     MsgIdArr(Ix)
     C                   Endif
     C                   Endif
     C                   Endif
      *
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * ValDRCY -  Validate Debit Currency
      *****************************************************************
     C     ValDRCY       Begsr
      *
      **  Debit Ccy must be entered
     C     SDRCY         Ifeq      *Blanks
     C                   Move      'N'           OKDRCY
     C                   Add       1             Ix
     C                   Movel     'SDRCY'       FldNameArr(Ix)
     C                   Movel     'FTA0152'     MsgIdArr(Ix)
     C                   Goto      EndValDRCY
     C                   Endif
      *
      **  Debit Ccy must be valid Midas currency code
     C                   Callb     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SDRCY         @CYCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
     C     @RTCD         Ifne      *Blanks
     C                   Move      'N'           OKDRCY
     C                   Add       1             Ix
     C                   Movel     'SDRCY'       FldNameArr(Ix)
     C                   Movel     'FTA0156'     MsgIdArr(Ix)
     C                   Goto      EndValDRCY
     C                   Endif
      *
      ** If '?' entered and selection made
     C     SDRCY         Ifeq      '?  '
     C     SDRCY         oreq      ' ? '
     C     SDRCY         oreq      '  ?'
     C     A6CYCD        Ifne      *blanks
     C                   Move      A6CYCD        SDRCY
     c                   Endif
     C                   Endif
      *
     C     EndValDRCY    Endsr
      /EJECT
      *****************************************************************
      * ValDRAC -  Validate Debit Account
      *****************************************************************
     C     ValDRAC       Begsr
      *
      **  Debit Account must be entered
     C     SDRAC         Ifeq      *Blanks
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0153'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  Determine if retail account number or Midas account reference
     C                   Movel     SDRAC         W@DRAC
     C     W@Blnks       Ifeq      *Blanks
     C                   Movel     W@Retl        @Retl
     C                   Movel     *Blanks       @Cust
     C                   Movel     *Blanks       @Cycd
     C**********         Movel     *Blanks       @Acod                                        CGL029
     C                   MOVE      *BLANKS       PAcod                                        CGL029
     C                   Movel     *Blanks       @Acsq
     C                   Movel     *Blanks       @Brch
     C                   Else
     C                   Movel     *Blanks       @Retl
     C                   Movel     W@Cust        @Cust
     C                   Movel     SDRCY         @Cycd
     C**********         Movel     W@Acod        @Acod                                        CGL029
     C                   MOVEL     W@Acod        PAcod                                        CGL029
     C                   Movel     W@Acsq        @Acsq
     C                   Movel     W@Brch        @Brch
     C                   Endif
      *
      **  Debit account must reference Midas Account
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY    '    @OPTN
     C                   Parm                    @Retl            10
     C                   Parm                    @Cust             6
     C                   Parm                    @Cycd             3
     C**********         Parm                    @Acod             4                          CGL029
     C                   PARM                    PAcod                                        CGL029
     C                   Parm                    @Acsq             2
     C                   Parm                    @Brch             3
     C     ACCNT         Parm      ACCNT         DSSDY
     C     @RTCD         Ifne      *Blanks
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0157'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  If retail account number entered must be same ccy as debit ccy
     C     W@RETL        Ifne      *Blanks
     C     ACCCY         andne     SDRCY
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0158'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  Must be a live account
     C     ACRECI        Ifne      'D'
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0159'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
     C     EndValDRAC    Endsr
      /EJECT
      *****************************************************************
      * ValREF1 -  Validate Debit Currency
      *****************************************************************
     C     ValREF1       Begsr
      *
      **  Reference field 1 must be entered
     C     SREF1         Ifeq      *Blanks
     C                   Move      'N'           OKREF1
     C                   Add       1             Ix
     C                   Movel     'SREF1'       FldNameArr(Ix)
     C                   Movel     'FTA0154'     MsgIdArr(Ix)
     C                   Goto      EndValREF1
     C                   Endif
      *
      *
     C     EndValREF1    Endsr
      /EJECT
      *****************************************************************
      * ValCRCY -  Validate Credit Currency
      *****************************************************************
     C     ValCRCY       Begsr
      *
      **  Default Credit Ccy to Debit Ccy if not entered
     C     SCRCY         Ifeq      *Blanks
     C     OKDRCY        andne     'N'
     C                   Move      SDRCY         SCRCY
     C                   Endif
      *
      **  Credit Ccy must be valid Midas currency code
     C                   Callb     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SCRCY         @CYCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
     C     @RTCD         Ifne      *Blanks
     C                   Move      'N'           OKCRCY
     C                   Add       1             Ix
     C                   Movel     'SCRCY'       FldNameArr(Ix)
     C                   Movel     'FTA0160'     MsgIdArr(Ix)
     C                   Goto      EndValCRCY
     C                   Endif
      *
      ** If '?' entered and selection made
     C     SCRCY         Ifeq      '?  '
     C     SCRCY         oreq      ' ? '
     C     SCRCY         oreq      '  ?'
     C     A6CYCD        Ifne      *blanks
     C                   Move      A6CYCD        SCRCY
     c                   Endif
     C                   Endif
      *
     C     EndValCRCY    Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Action Code
     C                   Parm                    Action
      *    Transaction key fields
     C                   Parm                    SDRCY                          Debit Ccy
     C                   Parm                    SDRAC                          Debit Account
     C                   Parm                    SREF1                          Reference I
     C                   Parm                    SREF2                          Reference II
     C                   Parm                    SCRCY                          Pay Ccy
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Ix
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      *
      **  Key list to access LF/FTOSSIL0
     C     K@OSSI        Klist
     C                   Kfld                    SDRCY
     C                   Kfld                    SDRAC
     C                   Kfld                    SREF1
     C                   Kfld                    SREF2
     C                   Kfld                    SCRCY
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
