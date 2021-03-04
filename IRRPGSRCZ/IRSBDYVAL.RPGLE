     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Business day convention single ccy vald')     *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSBDYVAL - Business Day Conventions Single Ccy Validation   *
      *                                                               *
      *  Function:  This module will allow the business day convention*
      *             fields to be validated.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CIR017             Date 10Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005  *CREATE    Date 21Jan00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
      /EJECT
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
      **    False      logical = *off (for indcator processing)
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

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @EI             S              1    DIM(60)
     D MsgidAr         S                   LIKE(MsgIdArr) DIM(ArrayMax)
     D FldNameAr       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D WMsgidAr        S                   LIKE(MsgIdArr) DIM(ArrayMax)
     D WFldNamAr       S                   LIKE(FldNameArr) DIM(ArrayMax)

      ** External DS for SAR Details                                                          CIR017
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR017
                                                                                              CIR017
      ** Short DS for access programs                                                         CIR017
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR017
                                                                                              CIR017
     D ValidDeal     E DS                  EXTNAME(IRVSIRSPD)
      ** Valid Single Currency Interest Rate Swap

     D PScrData      E DS                  EXTNAME(IRSBDYPD)
      ** Business Day Convention Format Definition File
     D  PPCcy                  1     30
     D  PRCcy                 35     64
     D  PConv                 31     34                                                       CIR017
      **                                                                                      CIR017
      ** Business Day Convention for Leg2 Currency Details                                    CIR017
     D  Leg2Dtls              65    128                                                       CIR017
     D  PPCcy2                65     94                                                       CIR017
     D  PRCcy2                99    128                                                       CIR017
     D  PConv2                95     98                                                       CIR017

     D OKIRSBSDY     E DS                  EXTNAME(IRESIRSPD)
      ** Error File for IRS Single Currency
      ** Redefine layout to match file layout IRESIRSPD                                       CIR017
     D***OkFlag2              46     55                                                       CIR017
     D***OkFlagPD             56     56                                                       CIR017
     D***OkFlagAM             57     57                                                       CIR017
     D***OkFlag1              58     67                                                       CIR017
     D   OkFlag2              54     63                                                       CIR017
     D   OkFlagPD             64     64                                                       CIR017
     D   OkFlagAM             65     65                                                       CIR017
     D   OkFlag1              66     75                                                       CIR017
                                                                                              CIR017
      ** Error File for IRS Single Currency - Leg 2                                           CIR017
      ** Pay CCY, Payment Convention, Amount Convention, Rate Fix CCY                         CIR017
     D   Ok2Flag2             87     96                                                       CIR017
     D   Ok2FlagPD            97     97                                                       CIR017
     D   Ok2FlagAM            98     98                                                       CIR017
     D   Ok2Flag1             99    108                                                       CIR017

     D POKFlag         DS
     D   OkFlags1              1     10
     D   OkFlags2             11     20
     D   OKFlags3             21     21
     D   OKFlags4             22     22
                                                                                              CIR017
      ** Error flags for Leg2 -  Pay CCY, Fix CCY, SPDC2 and SAMC2 respectively               CIR017
     D   Ok2Flags1            23     32                                                       CIR017
     D   Ok2Flags2            33     42                                                       CIR017
     D   OK2Flags3            43     43                                                       CIR017
     D   OK2Flags4            44     44                                                       CIR017

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D E               S              2  0
     D C               S              2  0
     D X               S              2  0
     D Idx             S              2  0
     D WIdx            S              2  0

     D PRTCD           S              7A                                                      CIR017
     D POPTN           S              7A                                                      CIR017
     D PSARD           S              6A                                                      CIR017
     D CIR017          S              1A                                                      CIR017
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** If CIR017 is on, save out RetCodeIn to indicate where                                CIR017
      ** call was done from. Then clear out RetCodeIn                                         CIR017
                                                                                              CIR017
     C                   If        CIR017 = 'Y'                                               CIR017
     C                   Eval      WCallFunc = RetCodeIn                                      CIR017
     C                   Eval      RetCodeIn = *Blanks                                        CIR017
     C                   EndIf                                                                CIR017
                                                                                              CIR017
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 0

      /COPY WNCPYSRC,IRSIRSV095
      *  *-------------------------*
      *  * Validate Convention Ccy *
      *  *-------------------------*
     C                   Exsr      SrRFCcy
      /COPY WNCPYSRC,IRCIRSV096

      /COPY WNCPYSRC,IRCIRSV097
      *  *---------------------------------------*
      *  * Validate Payment Date and Amount Code *
      *  *---------------------------------------*
     C                   Exsr      SrPayDt
      /COPY WNCPYSRC,IRSIRSV098
                                                                                              CIR017
     C                   If        CIR017 = 'Y' And WcallFunc = '*SIRS'                       CIR017
                                                                                              CIR017
      ** If no errors in Leg 1 validation and Leg 2 details are blank                         CIR017
      ** default Leg 1 details to Leg 2 fields and skip validation                            CIR017
                                                                                              CIR017
     C                   If        Idx = 0 AND Leg2Dtls = *Blanks                             CIR017
     C                   Eval      PPCcy2 = PPCcy                                             CIR017
     C                   Eval      PRCcy2 = PRCcy                                             CIR017
     C                   Eval      PConv2 = PConv                                             CIR017
     C                   ELSE                                                                 CIR017
                                                                                              CIR017
      ** Validate Leg 2 Convention Currency                                                   CIR017
     C                   Exsr      Sr2RFCcy                                                   CIR017
                                                                                              CIR017
      ** Validate Leg 2 Payment Date and Amount Code                                          CIR017
                                                                                              CIR017
     C                   Exsr      Sr2PayDt                                                   CIR017
                                                                                              CIR017
      ** If default value of 'A' is returned for Amt Convention and errors exist              CIR017
      ** in Leg 1 and Leg2 Currencies are blank, reset to blank to allow                      CIR017
      ** Our details to default to Their values                                               CIR017
                                                                                              CIR017
     C                   If        Idx > 0  AND SAMC2 = 'A ' AND                              CIR017
     C                             PPCcy2 = *Blanks AND PRCcy2 = *Blanks                      CIR017
     C                   EVAL      SAMC2 = *Blanks                                            CIR017
     C                   EndIf                                                                CIR017
     C                   EndIf                                                                CIR017
                                                                                              CIR017
      ** If Feature OFF or validation not called from SIRS - Single CCY Swap                  CIR017
      ** set Leg 2 Currency fields to blanks                                                  CIR017
     C                   Else                                                                 CIR017
     C                   Eval      PPCcy2 =  *Blanks                                          CIR017
     C                   Eval      PRCcy2 =  *Blanks                                          CIR017
     C                   Eval      PConv2 =  *Blanks                                          CIR017
     C                   EndIf                                                                CIR017

     C                   MoveL     OkFlag1       OkFlags1
     C                   MoveL     OkFlag2       OkFlags2
     C                   MoveL     OkFlagPD      OkFlags3
     C                   MoveL     OkFlagAM      OkFlags4
                                                                                              CIR017
     C                   If        CIR017 = 'Y' And WcallFunc = '*SIRS'                       CIR017
     C                   MoveL     Ok2Flag1      Ok2Flags1                                    CIR017
     C                   MoveL     Ok2Flag2      Ok2Flags2                                    CIR017
     C                   MoveL     Ok2FlagPD     Ok2Flags3                                    CIR017
     C                   MoveL     Ok2FlagAM     Ok2Flags4                                    CIR017
     C                   EndIf                                                                CIR017

      ** Place validated fields to valid file.

     C                   If        Idx = 0
     C                   Exsr      SrValid
     C                   Endif

     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRFCcy - Validates Convention Currencies                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: IRVBSDYCCY                                             *
      *                                                               *
      *****************************************************************

     C     SrRFCcy       Begsr

      * Reset variables updated by each module before each call
     C                   Exsr      RESETERRS

     C                   CallB     'IRVBDYCCY'
     C                   Parm                    ReturnCode
     C                   Parm      'B'           PCode             1
     C                   Parm                    PLCcy             3
     C                   Parm                    PRCcy            30
     C                   Parm                    PPCcy            30
     C                   Parm                    OkFlag1          10
     C                   Parm                    OkFlag2          10
     C                   Parm                    MsgIdAr
     C                   Parm                    FldNameAr
     C                   Parm                    WMsgIdAr
     C                   Parm                    WFldNamAr

     C                   Eval      X = 1
     C                   DoW       MsgIdAr(X) <> *Blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = MsgIdAr(X)
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '1'
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Eval      X = 1
     C                   DoW       WMsgIdAr(X) <> *Blanks
     C                   Eval      WIdx = WIdx + 1
     C                   Eval      WMsgIdArr(WIdx) = WMsgIdAr(X)
     C                   Eval      WFldNamArr(WIdx) = %Trim(WFldNamAr(X)) +
     C                                               '1'
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CIR017
      * Sr2RFCcy - Validates Convention Currencies - Leg 2            *                       CIR017
      *                                                               *                       CIR017
      * Called by: Main processing                                    *                       CIR017
      *                                                               *                       CIR017
      * Calls: IRVBSDYCCY                                             *                       CIR017
      *                                                               *                       CIR017
      *****************************************************************                       CIR017
     C     Sr2RFCcy      Begsr                                                                CIR017
                                                                                              CIR017
     C                   Exsr      RESETERRS                                                  CIR017
                                                                                              CIR017
     C                   CallB     'IRVBDYCCY'                                                CIR017
     C                   Parm      '*SIRS'       ReturnCode                                   CIR017
     C                   Parm      'B'           PCode                                        CIR017
     C                   Parm                    PLCcy                                        CIR017
     C                   Parm                    PRCcy2                                       CIR017
     C                   Parm                    PPCcy2                                       CIR017
     C                   Parm                    Ok2Flag1                                     CIR017
     C                   Parm                    Ok2Flag2                                     CIR017
     C                   Parm                    MsgIdAr                                      CIR017
     C                   Parm                    FldNameAr                                    CIR017
     C                   Parm                    WMsgIdAr                                     CIR017
     C                   Parm                    WFldNamAr                                    CIR017
                                                                                              CIR017
     C                   Eval      X = 1                                                      CIR017
     C                   DoW       MsgIdAr(X) <> *Blanks                                      CIR017
     C                   Eval      Idx = Idx + 1                                              CIR017
     C                   Eval      MsgIdArr(Idx) = MsgIdAr(X)                                 CIR017
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) + '2'                CIR017
     C                   Eval      X = X + 1                                                  CIR017
     C                   Enddo                                                                CIR017
                                                                                              CIR017
     C                   Eval      X = 1                                                      CIR017
     C                   DoW       WMsgIdAr(X) <> *Blanks                                     CIR017
     C                   Eval      WIdx = WIdx + 1                                            CIR017
     C                   Eval      WMsgIdArr(WIdx) = WMsgIdAr(X)                              CIR017
     C                   Eval      WFldNamArr(WIdx) = %Trim(WFldNamAr(X)) + '2'               CIR017
     C                   Eval      X = X + 1                                                  CIR017
     C                   Enddo                                                                CIR017
                                                                                              CIR017
     C                   Endsr                                                                CIR017
      *****************************************************************                       CIR017
      /EJECT                                                                                  CIR017
      *****************************************************************                       CIR017
      *                                                               *
      * SrPayDt - Validates Payment Date and Amount Code              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: IRVPYAMCNV                                             *
      *                                                               *
      *****************************************************************

     C     SrPayDt       Begsr

      * Reset variables updated by each module before each call
     C                   Exsr      RESETERRS

     C                   CallB     'IRVPAMCNV'
     C                   Parm                    ReturnCode
     C                   Parm                    SPDC1
     C                   Parm                    SAMC1
     C                   Parm                    OkFlagPD          1
     C                   Parm                    OkFlagAM          1
     C                   Parm                    MsgIdAr
     C                   Parm                    FldNameAr

     C                   Eval      X = 1
     C                   DoW       MsgIdAr(X) <> *Blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDArr(Idx) = MsgidAr(X)
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '1'
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Endsr
      *****************************************************************                       CIR017
      /EJECT                                                                                  CIR017
      *****************************************************************                       CIR017
      *                                                               *                       CIR017
      * Sr2PayDt - Validates Payment Date and Amount Code - Leg 2     *                       CIR017
      *                                                               *                       CIR017
      * Called by: Main Processing                                    *                       CIR017
      *                                                               *                       CIR017
      * Calls: IRVPYAMCNV                                             *                       CIR017
      *                                                               *                       CIR017
      *****************************************************************                       CIR017
     C     Sr2PayDt      Begsr                                                                CIR017
                                                                                              CIR017
     C                   Exsr      RESETERRS                                                  CIR017
                                                                                              CIR017
     C                   CallB     'IRVPAMCNV'                                                CIR017
     C                   Parm                    ReturnCode                                   CIR017
     C                   Parm                    SPDC2                                        CIR017
     C                   Parm                    SAMC2                                        CIR017
     C                   Parm                    Ok2FlagPD                                    CIR017
     C                   Parm                    Ok2FlagAM                                    CIR017
     C                   Parm                    MsgIdAr                                      CIR017
     C                   Parm                    FldNameAr                                    CIR017
                                                                                              CIR017
     C                   Eval      X = 1                                                      CIR017
                                                                                              CIR017
     C                   DoW       MsgIdAr(X) <> *Blanks                                      CIR017
     C                   Eval      Idx = Idx + 1                                              CIR017
     C                   Eval      MsgIDArr(Idx) = MsgidAr(X)                                 CIR017
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) + '2'                CIR017
     C                   Eval      X = X + 1                                                  CIR017
     C                   Enddo                                                                CIR017
                                                                                              CIR017
     C                   Endsr                                                                CIR017
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValid - Moves all validated fields to valid file            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrValid       Begsr

      ** Leg 1
     C                   MoveL     SC1R1         RSC1R1
     C                   MoveL     SC2R1         RSC2R1
     C                   MoveL     SC3R1         RSC3R1
     C                   MoveL     SC4R1         RSC4R1
     C                   MoveL     SC5R1         RSC5R1
     C                   MoveL     SC6R1         RSC6R1
     C                   MoveL     SC7R1         RSC7R1
     C                   MoveL     SC8R1         RSC8R1
     C                   MoveL     SC9R1         RSC9R1
     C                   MoveL     SC0R1         RSC0R1
     C                   MoveL     SC1P1         RSC1P1
     C                   MoveL     SC2P1         RSC2P1
     C                   MoveL     SC3P1         RSC3P1
     C                   MoveL     SC4P1         RSC4P1
     C                   MoveL     SC5P1         RSC5P1
     C                   MoveL     SC6P1         RSC6P1
     C                   MoveL     SC7P1         RSC7P1
     C                   MoveL     SC8P1         RSC8P1
     C                   MoveL     SC9P1         RSC9P1
     C                   MoveL     SC0P1         RSC0P1
     C                   MoveL     SPDC1         RSPDC1
     C                   MoveL     SAMC1         RSAMC1
                                                                                              CIR017
      ** Leg 2 if CIR017 ON and function called from Single CCY Swap                          CIR017
     C                   If        CIR017 = 'Y' And WcallFunc = '*SIRS'                       CIR017
     C                   MoveL     SC1R2         RSC1R2                                       CIR017
     C                   MoveL     SC2R2         RSC2R2                                       CIR017
     C                   MoveL     SC3R2         RSC3R2                                       CIR017
     C                   MoveL     SC4R2         RSC4R2                                       CIR017
     C                   MoveL     SC5R2         RSC5R2                                       CIR017
     C                   MoveL     SC6R2         RSC6R2                                       CIR017
     C                   MoveL     SC7R2         RSC7R2                                       CIR017
     C                   MoveL     SC8R2         RSC8R2                                       CIR017
     C                   MoveL     SC9R2         RSC9R2                                       CIR017
     C                   MoveL     SC0R2         RSC0R2                                       CIR017
     C                   MoveL     SC1P2         RSC1P2                                       CIR017
     C                   MoveL     SC2P2         RSC2P2                                       CIR017
     C                   MoveL     SC3P2         RSC3P2                                       CIR017
     C                   MoveL     SC4P2         RSC4P2                                       CIR017
     C                   MoveL     SC5P2         RSC5P2                                       CIR017
     C                   MoveL     SC6P2         RSC6P2                                       CIR017
     C                   MoveL     SC7P2         RSC7P2                                       CIR017
     C                   MoveL     SC8P2         RSC8P2                                       CIR017
     C                   MoveL     SC9P2         RSC9P2                                       CIR017
     C                   MoveL     SC0P2         RSC0P2                                       CIR017
     C                   MoveL     SPDC2         RSPDC2                                       CIR017
     C                   MoveL     SAMC2         RSAMC2                                       CIR017
     C                   EndIf                                                                CIR017

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: SrRFCcy, SrPayDt                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     RESETERRS     Begsr

     C                   Reset                   MsgIdAr
     C                   Reset                   FldNameAr
     C                   Reset                   WMsgIdAr
     C                   Reset                   WFldNamAr

     C                   Eval      ReturnCode = *Blanks

     C                   Endsr
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

     C     *INZSR        Begsr

     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    PActCode          1
     C                   Parm                    PLCcy             3
     C                   Parm                    POkFlag
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WFldNamArr
     C                   Parm                    PScrData

      ** Check if CIR017 - Separate Business Day Convention for SIRS                          CIR017
                                                                                              CIR017
     C                   CALL      'AOSARDR0'                                                 CIR017
     C                   PARM      *BLANKS       PRTCD                                        CIR017
     C                   PARM      '*VERIFY'     POPTN                                        CIR017
     C                   PARM      'CIR017'      PSARD                                        CIR017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR017
                                                                                              CIR017
     C                   IF        PRTCD <> *BLANKS AND                                       CIR017
     C                             PRTCD <> '*NRF   '                                         CIR017
     C     *LOCK         IN        LDA                                                        CIR017
     C                   EVAL      DBASE = 1                                                  CIR017
     C                   EVAL      DBKEY = 'CIR017'                                           CIR017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR017
     C                   OUT       LDA                                                        CIR017
     C                   EXSR      *PSSR                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   IF        PRTCD = *BLANKS                                            CIR017
     C                   EVAL      CIR017 = 'Y'                                               CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      CIR017 = 'N'                                               CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C     *Like         Define    RetCodeIn     WCallFunc                                    CIR017
                                                                                              CIR017
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C/COPY ZACPYSRC,DBFIELDS

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
