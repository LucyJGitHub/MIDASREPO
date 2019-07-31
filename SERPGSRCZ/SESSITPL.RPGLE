     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Set-up Default Template')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSITPL - Set-up Default Template                           *
      *                                                               *
      *  Function:  This module will be called by SESSISIN to get     *
      *             information from an existing standard settlement  *
      *             and use it as a template to create a new          *
      *             settlement instruction or to change an existing   *
      *             instruction.                                      *
      *                                                               *
      *  Component of: SESSISIN - Standard Settlement Additional      *
      *                           Information                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 22Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Record not found                                *
      *                                                               *
      *    20         Error on branch                                 *
      *    21         Error on customer                               *
      *    22         Error on book                                   *
      *    23         Error on currency                               *
      *    24         Error on investment type                        *
      *    25         Error on portfolio reference                    *
      *    26         Error on override existing details              *
      *                                                               *
      *    50         Display customer (if off, display book)         *
      *    51         Display portfolio reference                     *
      *    52         Display override existing details               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  SRDefault  -  Setup default template                         *
      *  SRRetrieve -  Retrieve existing details                      *
      *  SRSetScnFld-  Set-up display fields                          *
      *  SRDisplay  -  Display additional SSI for swift               *
      *  SRValidate -  Validate screen fields                         *
      *  SRUpdate   -  Update additional standard settlement          *
      *                instructions                                   *
      *  SRReturn   -  Return to calling program                      *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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

     FSESSITPDF CF   E             WORKSTN

      ** Investment Type Details
     FINVTP     IF   E           K DISK    INFSR(*PSSR)

      ** Portfolio Definition Details
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.

     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY includes the MM standard declares:

     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.

     D/COPY ZACPYSRC,MSGHNDDCL

      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.

     D/COPY ZACPYSRC,APICTLARR

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

      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             02     02
     D  ErrOnBrch             20     20
     D  ErrOnCust             21     21
     D  ErrOnBook             22     22
     D  ErrOnCcy              23     23
     D  ErrOnInvT             24     24
     D  ErrOnPorR             25     25
     D  ErrOnOvrX             26     26
     D  DspCustomer           50     50
     D  DspPortF              51     51
     D  DspOvrEx              52     52
     D  PrtFlds               53     53

     D WInzIndArr      S              1    DIM(7) CTDATA PERRCD(7)
     D WInzOkFlag      S              1    DIM(7) CTDATA PERRCD(7)

     D WErrIndArr      S              1    DIM(7)

      ** External DS branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029

      ** External DS security customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)

      ** External DS for book code details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)

      ** External DS for currency code details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for trade purchase
     D PTradeP       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TP:2)

      ** DS for trade sale
     D PTradeS       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TS:2)

      ** DS for depot in
     D PDepotI       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DI:2)

      ** DS for depot out
     D PDepotO       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DO:2)

      ** DS for customer/book standard settlement instruction
      **  to be passed to SESSIR0
     D PCBStd        E DS                  EXTNAME(STDSED)
     D                                     Prefix(ST)
     D                                     OCCURS(2)

      ** Data structure for standard additional settlement details
      ** for customer/book to be passed to SESSIR0
     D PCBStdAd      E DS                  EXTNAME(STDADSED)
     D                                     Prefix(AD:2)
     D                                     OCCURS(8)

      ** OK Flags
     D OkFlags         DS             7
     D  BrchOK                 1      1
     D  CustOK                 2      2
     D  BookOK                 3      3
     D  CcyOK                  4      4
     D  InvTOK                 5      5
     D  PorROK                 6      6
     D  OvrdOK                 7      7

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     ** Entry Parameter
     D PBranch         S              3A
     D PCustomer       S              6A
     D*PCustNum*       S              6S 0                                                    CSD027
     D PCustNum        S              6A                                                      CSD027
     D PCustKey        S             10A
     D PKeySts         S              7A
     D PBook           S              2A
     D PCcy            S              3A
     D PMktCtr         S              2A                                                      CSE034
     D PInvType        S              3A
     D PPorRef         S              4A
     D PDescrptn       S             20A
     D PBJMRDT         S              7A
     D PBGPFMG         S              1A
     D PBGN4ST         S              1A

     D PMode           S              1A
     D POType          S              1A
     D PCBInd          S              1A
     D POvrXDet        S              1A
     D PRetCode        S                   LIKE(ReturnCode)


      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WCtr1           S              3P 0
     D WCtr2           S              3P 0

     D WCtr3           S              3P 0

     D WCsChar         S              1A
     D WCust           S              6A

      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))

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

      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************

      ** Initial processing

     C                   EXSR      SRInit

      ** Do while screen: Main Details

     C                   DOW       PMode = 'D'
     C                   EXSR      SRDisplay
     C                   ENDDO

      ** Do while update

     C                   DOW       PMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDDO

      **  Return

     C                   IF        PMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************

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

      ** Condition display/non-display of customer or book field,
      ** only one field should appear

     C                   IF        PCBInd = 'C'
     C                   EVAL      DspCustomer = True
     C                   ELSE
     C                   EVAL      DspCustomer = False
     C                   ENDIF

      ** Condition display/non-diplay of "Portfolio" field

     C                   IF        PBGPFMG = 'Y' OR PBGN4ST = 'Y'
     C                   EVAL      DspPortF = True
     C                   ELSE
     C                   EVAL      DspPortF = False
     C                   ENDIF

      ** Condition display/non-diplay of 'Override exisitng detail on file'

     C                   IF        ActionCode = 'A'
     C                   EVAL      DspOvrEx  = True
     C                   ELSE
     C                   EVAL      DspOvrEx  = False
     C                   ENDIF

     C                   EVAL      #1BRCH = PBranch
     C                   EVAL      #1CUST = PCustomer
     C                   EVAL      #1BOOK = PBook
     C                   EVAL      #1DESC = PDescrptn
     C                   EVAL      #1CCY  = PCcy
     C                   EVAL      #1MKCT = PMktCtr                                           CSE034
     C                   EVAL      #1INVT = PInvType
     C                   EVAL      #1PORF = PPorRef

     C                   EXSR      SRSetScnFld
     C                   EVAL      PMode = 'D'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetScnFld - Set-up display fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRSetScnFld   BEGSR

     C                   EVAL      #1BRH2 = *BLANKS
     C                   EVAL      #1CST2 = *BLANKS
     C                   EVAL      #1BOK2 = *BLANKS
     C                   EVAL      #1CCY2 = *BLANKS
     C                   EVAL      #1INV2 = *BLANKS
     C                   IF        PBGPFMG = 'Y' OR PBGN4ST = 'Y'
     C                   EVAL      #1POR2 = *BLANKS
     C                   ENDIF

     C                   EVAL      #1OVRD = 'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display additional SSI for swift                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR

      ** Move 'OK' flags into array for checking

     C                   MOVEA     OkFlags       WErrIndArr

      ** Set screen error indicators according to status of 'OK' flags


     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     20            WCtr2

     C                   DOU       WCtr1 > 7
     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF

     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1
     C                   ENDDO

      ** The following /COPY line includes processing for the error and
      ** warning messages.

      /COPY ZACPYSRC,MSGHNDDSP1

      ** Write message subfile, details and footer screen

     C                   WRITE     SESSITPF2
     C                   WRITE     SESSITPC1
     C                   WRITE     SESSITPF1

      ** Read details screen

     C                   READ      SESSITPF1

      ** Clear message subfile

     C                   CALL      'ZA0250'

      ** Reset error fields

     C                   EVAL      Idx = 0
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr

      ** Set screen error indicators off

     C                   MOVEA     WInzIndArr    *IN(20)
     C                   MOVEA     WInzOkFlag    OkFlags

      ** Select processing type

     C                   SELECT

      ** F3 Pressed

     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = 'SE10000'
     C                   EVAL      PMode = 'R'

      ** F12 Pressed

     C                   WHEN      *INKL = *ON
     C                   EVAL      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'R'

      ** F5 Pressed

     C                   WHEN      *INKE = *ON
     C                   EXSR      SRSetScnFld

      ** All input fields are blank

     C                   WHEN      #1BRH2 = *BLANKS AND
     C                             #1CST2 = *BLANKS AND
     C                             #1BOK2 = *BLANKS AND
     C                             #1CCY2 = *BLANKS AND
     C                             #1INV2 = *BLANKS AND
     C                             #1POR2 = *BLANKS

     C                   EVAL      PRetCode = '*NTUSE'
     C                   EVAL      PMode = 'R'

     C                   OTHER

      ** Validate inputs

     C                   EXSR      SRValidate

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate screen fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR

      ** Branch must be on SDBRCHPD

     C                   IF        #1BRH2 = *BLANKS

     C                   EVAL      BrchOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BRH2'
     C                   EVAL      MsgIdArr(Idx) = 'BBM0080'

     C                   ELSE

     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    #1BRH2
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029

     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      BrchOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BRH2'
     C                   EVAL      MsgIdArr(Idx) = 'SE06006'
     C                   ENDIF

     C                   ENDIF

      ** Validate Customer or book code

     C                   SELECT

     C                   WHEN      #1CST2 <> *BLANKS AND #1BOK2 <> *BLANKS

     C                   EVAL      CustOK = 'N'
     C                   EVAL      BookOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CST2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10034'

     C                   WHEN      #1CST2 = *BLANKS AND #1BOK2 = *BLANKS

     C                   EVAL      CustOK = 'N'
     C                   EVAL      BookOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CST2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10035'

     C                   OTHER

      ** Validate customer if entered.
     C                   IF        #1CST2 <> *BLANKS

     C                   MOVEL     #1CST2        WCsChar

      ** Bypass call to AOCUSTR0 if user enters '?'

     C                   IF        WCsChar = '?'
     C                   MOVEL     WCsChar       WCust

     C                   ELSE

     C                   MOVEL     #1CST2        PCustKey

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustKey
     C                   PARM                    PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      CustOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CST2'
     C                   EVAL      MsgIdArr(Idx) = 'SEM1050'
     C                   ELSE
     C                   EVAL      WCust = BBCUST
     C                   ENDIF
     C                   ENDIF

      ** Check if customer is a valid security customer

     C                   IF        CustOK <> 'N' OR WCsChar = '?'

     C                   EVAL      #1CST2 = WCust

     C                   CALLB     'AOSECSR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    WCust
     C     SDSECS        PARM      SDSECS        DSSDY

     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      CustOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CST2'
     C                   EVAL      MsgIdArr(Idx) = 'SEM1050'
     C                   ELSE
     C                   EVAL      #1CST2 = BFCUST
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Validate book if entered.
     C                   IF        #1BOK2 <> *BLANKS

     C                   CALLB     'AOBOOKR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    #1BOK2
     C     SDBOOK        PARM      SDBOOK        DSFDY

     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      BookOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1BOK2'
     C                   EVAL      MsgIdArr(Idx) = 'SE06002'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSL

      ** Validate currency

     C                   IF        #1CCY2 = *BLANKS

     C                   EVAL      CcyOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CCY2'
     C                   EVAL      MsgIdArr(Idx) = 'ABM0010'

     C                   ELSE

     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    #1CCY2
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      CcyOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1CCY2'
     C                   EVAL      MsgIdArr(Idx) = 'SEM1058'
     C                   ENDIF

     C                   ENDIF

      ** Validate investment type

     C                   IF        #1INV2 <> *BLANKS

     C     KInvTp        CHAIN     INVTP                              02

     C                   IF        RecNotFnd = True

     C                   EVAL      InvtOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1INV2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10027'

     C                   ELSE

     C                   IF        RECI = '*'
     C                   EVAL      InvtOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1INV2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10027'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Validate portfolio reference

     C                   IF        DspPortF = True AND
     C                             #1POR2 <> *BLANKS

     C                   IF        #1BOK2 <> *BLANKS

     C                   EVAL      PorROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1POR2'
     C                   EVAL      MsgIdArr(Idx) = 'MMA0157'

     C                   ELSE

     C                   MOVE      #1CST2        PCustNum
     C     KPRef         CHAIN     PMPORTPD                           02

     C                   IF        RecNotFnd = True
     C                   EVAL      PorROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1POR2'
     C                   EVAL      MsgIdArr(Idx) = 'SE10036'
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Validate override existing details

     C                   IF        #1OVRD <> 'Y' AND #1OVRD <> 'N'
     C                   EVAL      OvrdOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1OVRD'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EXSR      SRRetrieve
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetrieve - Retrieve existing details                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR

     C*******************CALL      'SESSIR0'                                                  CSE034
     C                   CALLB     'SESSIR0'                                                  CSE034

      ** Input Parameters
      ** ================
      ** Operation Type
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference

     C                   PARM      'T'           POType
     C                   PARM                    #1BRH2
     C                   PARM                    #1CST2
     C                   PARM                    #1BOK2
     C                   PARM                    #1CCY2
     C                   PARM                    #1SMKT                                       CSE034
     C                   PARM                    #1INV2
     C                   PARM                    #1POR2

      ** Output Parameters
      ** =================
      ** Standard Settlement Instructions DS (Book/Customer)
      ** Standard Additional Settlement Details DS (Book/Customer)
      ** Return Code

     C                   PARM                    PCBStd
     C                   PARM                    PCBStdAd
     C                   PARM      *BLANKS       PRetCode

      ** If no default template found, then display error message.
     C                   IF        PRetCode <> *BLANKS

     C                   EVAL      BrchOK = 'N'
     C                   EVAL      CcyOK  = 'N'

     C                   IF        #1CST2 <> *BLANKS
     C                   EVAL      CustOK = 'N'
     C                   ELSE
     C                   EVAL      BookOK = 'N'
     C                   ENDIF

     C                   IF        #1INV2 <> *BLANKS
     C                   EVAL      InvTOK = 'N'
     C                   ENDIF

     C                   IF        DspPortF = True AND
     C                             #1POR2 <> *BLANKS
     C                   EVAL      PorROK = 'N'
     C                   ENDIF

     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WFldNamArr(Idx) = '*ANY'
     C                   EVAL      WMsgIdArr(Idx) = 'SE10003'

     C                   ELSE

     C                   EVAL      PMode = 'U'

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update additional standard settlement instructions*
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR

      ** Set output parameters based on customer or book processing.
     C                   SELECT

      ** Customer
     C                   WHEN      PCBInd = 'C'

     C                   EVAL      WCtr3 = 5
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PTradeP = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 6
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PTradeS = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 7
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PDepotI = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 8
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PDepotO = PCBStdAd
     C                   ENDDO

      ** Book
     C                   WHEN      PCBInd = 'B'

     C                   EVAL      WCtr3 = 1
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PTradeP = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 2
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PTradeS = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 3
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PDepotI = PCBStdAd
     C                   ENDDO

     C                   EVAL      WCtr3 = 4
     C                   DO
     C     WCtr3         OCCUR     PCBStdAd
     C                   EVAL      PDepotO = PCBStdAd
     C                   ENDDO

     C                   ENDSL

      ** Setup key fields for output.

     C                   EVAL      TPBCH  = #1BRCH
     C                   MOVEL     #1CUST        TPCUST
     C                   EVAL      TPBK   = #1BOOK
     C                   EVAL      TPCCY  = #1CCY
     C                   EVAL      TPMKT  = #1MKCT                                            CSE034
     C                   EVAL      TPINV  = #1INVT
     C                   EVAL      TPPREF = #1PORF

     C                   EVAL      TSBCH  = #1BRCH
     C                   MOVEL     #1CUST        TSCUST
     C                   EVAL      TSBK   = #1BOOK
     C                   EVAL      TSCCY  = #1CCY
     C                   EVAL      TSMKT  = #1MKCT                                            CSE034
     C                   EVAL      TSINV  = #1INVT
     C                   EVAL      TSPREF = #1PORF

     C                   EVAL      DIBCH  = #1BRCH
     C                   MOVEL     #1CUST        DICUST
     C                   EVAL      DIBK   = #1BOOK
     C                   EVAL      DICCY  = #1CCY
     C                   EVAL      DIMKT  = #1MKCT                                            CSE034
     C                   EVAL      DIINV  = #1INVT
     C                   EVAL      DIPREF = #1PORF

     C                   EVAL      DOBCH  = #1BRCH
     C                   MOVEL     #1CUST        DOCUST
     C                   EVAL      DOBK   = #1BOOK
     C                   EVAL      DOCCY  = #1CCY
     C                   EVAL      DOMKT  = #1MKCT                                            CSE034
     C                   EVAL      DOINV  = #1INVT
     C                   EVAL      DOPREF = #1PORF

     C                   EVAL      POvrXDet = #1OVRD
     C                   EVAL      PMode = 'R'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to calling program                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      RetCodeOut = PRetCode
     C                   ELSE
     C                   EVAL      RetCodeOut = *BLANKS
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.

     C/COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Receive entry parameters.

     C     *ENTRY        PLIST

      ** Input Parameters
      ** ================
      ** Action code
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Customer/Book indicator

     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM                    PCBInd

      ** SDBANKPD
      ** ========
      ** Rundate

     C                   PARM                    PBJMRDT

      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking

     C                   PARM                    PBGPFMG
     C                   PARM                    PBGN4ST

      ** Output Parameters
      ** -----------------
      ** Override existing details (Y/N)
      ** Data Structure for Trade Purchase
      ** Data Structure for Trade Sale
      ** Data Structure for Depot In
      ** Data Structure for Depot Out
      ** Return code

     C                   PARM                    POvrXDet
     C                   PARM                    PTradeP
     C                   PARM                    PTradeS
     C                   PARM                    PDepotI
     C                   PARM                    PDepotO
     C                   PARM                    RetCodeOut

      ** Move workstation ID to screen field.

     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WID  = PsJobName
     C                   EVAL      #1DATE = PBJMRDT

      ** Initialise the fixed parameters for ZAMSGHNDLE.

     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'

      ** Set up the prime and secondary message files for
      ** finding message IDs.

     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'

      ** Message subfile control

     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'

      ** Define key list for chaining to INVTPD

     C     KInvTp        KLIST
     C                   KFLD                    #1CCY2
     C                   KFLD                    #1INV2

      ** Define key list for chaining to PMPORTPD

     C     KPref         KLIST
     C                   KFLD                    PCustNum
     C                   KFLD                    #1POR2

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************

**  CPY@
(c) Finastra International Limited 2001
** WInzIndArr
0000000
** WInzOkFlag
YYYYYYY
