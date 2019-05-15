     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Business day convention cross ccy valid')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCBDYVAL - Business Day Conventions Cross Ccy Validation    *
      *                                                               *
      *  Function:  This module will allow the business day convention*
      *             fields to be validated.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
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
      *  MD046248 - Finastra Rebranding                               *
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
 
     D ValidDeal     E DS                  EXTNAME(IRVCIRSPD)
      ** Valid Cross Currency Interest Rate Swap
 
     D PScrData      E DS                  EXTNAME(IRCBDYPD)
      ** Business Day Convention Format Definition File
     D  WCcy2                  1     30
     D  WCcy1                 35     64
     D  WCcy4                 65     94
     D  WCcy3                 99    128
 
     D OKIRCBSDY     E DS                  EXTNAME(IRECIRSPD)
      ** Error File for IRS Cross Currency
     D   OkFlagDS2            53     62
     D   OkFlagPD1            63     63
     D   OkFlagAC1            64     64
     D   OkFlagDS1            65     74
     D   OkFlagDS4            75     84
     D   OkFlagPD2            85     85
     D   OkFlagAC2            86     86
     D   OkFlagDS3            87     96
 
     D POkFlag         DS
     D   OkFlags1              1     10
     D   OkFlags2             11     20
     D   OkFlags3             21     21
     D   OkFlags4             22     22
     D   OkFlags5             23     32
     D   OkFlags6             33     42
     D   OkFlags7             43     43
     D   OkFlags8             44     44
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D E               S              2  0
     D C               S              2  0
     D X               S              2  0
     D Idx             S              2  0
     D WIdx            S              2  0
 
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
 
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 0
 
      /COPY WNCPYSRC,IRCIRSV105
      *  *-------------------------------*
      *  * Validate Convention Ccy (OUR) *
      *  *-------------------------------*
     C                   Exsr      SrORCcy
      /COPY WNCPYSRC,IRCIRSV106
 
      /COPY WNCPYSRC,IRCIRSV107
      *  *---------------------------------------------*
      *  * Validate Payment Date and Amount Code (OUR) *
      *  *---------------------------------------------*
     C                   Exsr      SrOPyDt
      /COPY WNCPYSRC,IRCIRSV108
 
      /COPY WNCPYSRC,IRCIRSV109
      *  *---------------------------------*
      *  * Validate Convention Ccy (THEIR) *
      *  *---------------------------------*
     C                   Exsr      SrTRCcy
      /COPY WNCPYSRC,IRCIRSV110
 
      /COPY WNCPYSRC,IRCIRSV111
      *  *-----------------------------------------------*
      *  * Validate Payment Date and Amount Code (THEIR) *
      *  *-----------------------------------------------*
     C                   Exsr      SrTPyDt
      /COPY WNCPYSRC,IRCIRSV112
 
     C                   MoveL     OkFlagDS1     OkFlags1
     C                   MoveL     OkFlagDS2     OkFlags2
     C                   MoveL     OkFlagPD1     OKFlags3
     C                   MoveL     OkFlagAC1     OkFlags4
     C                   MoveL     OkFlagDS3     OkFlags5
     C                   MoveL     OkFlagDS4     OkFlags6
     C                   MoveL     OkFlagPD2     OkFlags7
     C                   MoveL     OkFlagAC2     OkFlags8
 
      ** Place validated fields to valid file.
 
     C                   If        Idx = 0
     C                   Exsr      SrValid
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrORCcy - Validates Convention Ccy (Our)                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrRFCcy                                                *
      *                                                               *
      *****************************************************************
 
     C     SrORCcy       Begsr
 
     C                   MoveL     WCcy1         PRCcy
     C                   MoveL     WCcy2         PPCcy
     c                   MoveL     'O'           WLeg              1
 
     C                   Exsr      SrRFCcy
 
     C                   MoveL     PRCcy         WCcy1
     C                   MoveL     PPCcy         WCcy2
     C                   MoveL     OkFlag1       OkFlagDS1
     C                   MoveL     OkFlag2       OkFlagDS2
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTRCcy - Validates Convention Ccy (Their)                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrRFCcy                                                *
      *                                                               *
      *****************************************************************
 
     C     SrTRCcy       Begsr
 
     C                   MoveL     WCcy3         PRCcy
     C                   MoveL     WCcy4         PPCcy
     c                   MoveL     'T'           WLeg              1
 
     C                   Exsr      SrRFCcy
 
     C                   MoveL     PRCcy         WCcy3
     C                   MoveL     PPCcy         WCcy4
     C                   MoveL     OkFlag1       OkFlagDS3
     C                   MoveL     OkFlag2       OkFlagDS4
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOPyDt - Validates Payment Date and Amount Code (Our)        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrPayDt                                                *
      *                                                               *
      *****************************************************************
 
     C     SrOPyDt       Begsr
 
     C                   MoveL     SPDC1         PPyDt
     C                   MoveL     SAMC1         PAmCd
 
     C                   Exsr      SrPayDt
 
     C                   MoveL     PPyDt         SPDC1
     C                   MoveL     PAmCd         SAMC1
     C                   MoveL     OkFlagPD      OkFlagPD1
     C                   MoveL     OkFlagAM      OkFlagAC1
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTPyDt - Validates Payment Date and Amount Code (Their)      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrPayDt                                                *
      *                                                               *
      *****************************************************************
 
     C     SrTPyDt       Begsr
 
     C                   MoveL     SPDC2         PPyDt
     C                   MoveL     SAMC2         PAmCd
 
     C                   Exsr      SrPayDt
 
     C                   MoveL     PPyDt         SPDC2
     C                   MoveL     PAmCd         SAMC2
     C                   MoveL     OkFlagPD      OkFlagPD2
     C                   MoveL     OkFlagAM      OkFlagAC2
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRFCcy - Validates Convention Currencies                     *
      *                                                               *
      * Called by: SrORCcy, SrTRCcy                                   *
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
     C                   If        WLeg = 'O'
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '1'
     C                   Else
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '2'
     C                   Endif
     C                   Eval      X = X + 1
     C                   Enddo
 
     C                   Eval      X = 1
     C                   DoW       WMsgIdAr(X) <> *Blanks
     C                   Eval      WIdx = WIdx + 1
     C                   Eval      WMsgIdArr(WIdx) = WMsgIdAr(X)
     C                   If        WLeg = 'O'
     C                   Eval      WFldNamArr(WIdx) = %Trim(WFldNamAr(X)) +
     C                                               '1'
     C                   Else
     C                   Eval      WFldNamArr(WIdx) = %Trim(WFldNamAr(X)) +
     C                                               '2'
     C                   Endif
     C                   Eval      X = X + 1
     C                   Enddo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPayDt - Validates Payment Date and Amount Code              *
      *                                                               *
      * Called by: SROPyDt, SRTPyDt                                   *
      *                                                               *
      * Calls: IRVPYAMCNV                                             *
      *                                                               *
      *****************************************************************
 
     C     SrPayDt       Begsr
 
      * Reset variables updated by each module before each call
     C                   Exsr      RESETERRS
 
     C                   CallB     'IRVPAMCNV'
     C                   Parm                    ReturnCode
     C                   Parm                    PPyDt             2
     C                   Parm                    PAmCd             2
     C                   Parm                    OkFlagPD          1
     C                   Parm                    OkFlagAM          1
     C                   Parm                    MsgIdAr
     C                   Parm                    FldNameAr
 
     C                   Eval      X = 1
     C                   DoW       MsgIdAr(X) <> *Blanks
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDArr(Idx) = MsgidAr(X)
     C                   If        WLeg = 'O'
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '1'
     C                   Else
     C                   Eval      FldNameArr(Idx) = %Trim(FldNameAr(X)) +
     C                                               '2'
     C                   Endif
     C                   Eval      X = X + 1
     C                   Enddo
 
     C                   Endsr
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
     C                   MoveL     SC1R1         RXC1R1
     C                   MoveL     SC2R1         RXC2R1
     C                   MoveL     SC3R1         RXC3R1
     C                   MoveL     SC4R1         RXC4R1
     C                   MoveL     SC5R1         RXC5R1
     C                   MoveL     SC6R1         RXC6R1
     C                   MoveL     SC7R1         RXC7R1
     C                   MoveL     SC8R1         RXC8R1
     C                   MoveL     SC9R1         RXC9R1
     C                   MoveL     SC0R1         RXC0R1
     C                   MoveL     SC1P1         RXC1P1
     C                   MoveL     SC2P1         RXC2P1
     C                   MoveL     SC3P1         RXC3P1
     C                   MoveL     SC4P1         RXC4P1
     C                   MoveL     SC5P1         RXC5P1
     C                   MoveL     SC6P1         RXC6P1
     C                   MoveL     SC7P1         RXC7P1
     C                   MoveL     SC8P1         RXC8P1
     C                   MoveL     SC9P1         RXC9P1
     C                   MoveL     SC0P1         RXC0P1
     C                   MoveL     SPDC1         RXPDC1
     C                   MoveL     SAMC1         RXAMC1
 
      ** Leg 2
     C                   MoveL     SC1R2         RXC1R2
     C                   MoveL     SC2R2         RXC2R2
     C                   MoveL     SC3R2         RXC3R2
     C                   MoveL     SC4R2         RXC4R2
     C                   MoveL     SC5R2         RXC5R2
     C                   MoveL     SC6R2         RXC6R2
     C                   MoveL     SC7R2         RXC7R2
     C                   MoveL     SC8R2         RXC8R2
     C                   MoveL     SC9R2         RXC9R2
     C                   MoveL     SC0R2         RXC0R2
     C                   MoveL     SC1P2         RXC1P2
     C                   MoveL     SC2P2         RXC2P2
     C                   MoveL     SC3P2         RXC3P2
     C                   MoveL     SC4P2         RXC4P2
     C                   MoveL     SC5P2         RXC5P2
     C                   MoveL     SC6P2         RXC6P2
     C                   MoveL     SC7P2         RXC7P2
     C                   MoveL     SC8P2         RXC8P2
     C                   MoveL     SC9P2         RXC9P2
     C                   MoveL     SC0P2         RXC0P2
     C                   MoveL     SPDC2         RXPDC2
     C                   MoveL     SAMC2         RXAMC2
 
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
