     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade display - SWIFT details screen')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  SETRADEDSP - SECURITIES TRADES DISPLAY - Swift Detail Screen *
      *                                                               *
      *  Function:  This module displays the Swift details screen of  *
      *             the Securites input function.                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR689705           Date 03Jan11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CSE045             Date 24Mar03               *
      *                 CAP084             Date 24Mar03               *
      *                 221557             Date 22Sep03               *
      *                 213037             Date 09Dec02               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212772             Date 12Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208195             Date 08Aug02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205667             Date 09May02               *
      *                 204833             Date 03May02               *
      *                 CSE034             Date 19Apr02               *
      *                 201429             Date 03Jan01               *
      *                 CAP067             Date 24Sep01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSW201             Date 02May01               *
      *                 CSE022             Date 29Mar01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 175216             Date 12Sep00               *
      *                 178487             Date 08May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 140951             Date 19AUG98               *
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement.                                     *
      *  CAP084 - Synchronous calling of APIs (correct error).        *
      *  221557 - Error in display of CSE028 fields                   *
      *  213037 - Decimal data error on SETRADEDSP.                   *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  212772 - DB Error on trades enquiry via ENQY/TRAN/TRDT.      *
      *           This is due to *INLR not being set on when F12 is   *
      *           pressed.                                            *
      *  208195 - Database Error occured when client number is blank. *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  205667 - Incorrect SSi picked up for Market Centre.          *
      *  204833 - For Bulk transactions, correct display of SSI.      *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  CAP067 - Repurchase Agreements API.                          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CSE016 - Extended Security Descriptions                      *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change.                *
      *  178487 - Program SE1806 creating TRADSDX2 records without    *
      *           trades reference.                                   *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over changes to /COPY       *
      *           MSGHNDDCL.                                          *
      *  140951 - Addition of F14 key to access Ext. Settlements.     *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSETRADEDF CF   E             WORKSTN
                                                                                              199797
     FSECTY     IF   E           K DISK    INFSR(*pssr)                                       199797
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       61  Non-Display Fungibility Code & Fungible Trade Ind.  *
      *       62  Non-Display Ins.Type, Ins. Sub-Type etc             *
      *       63  Non-Display Conf message req, cust/c'party ind etc  *
      *       64  Non-Display C'party Euroclear/Clearstream code      *                       CSE034
      *       70  Protect trade detail fields                         *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
     D @EI             S              1    DIM(60)
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS                             140951
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                    140951
                                                                                140951
      ** EXTERNAL DS FOR SECURITIES CUSTOMER DETAILS
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TrSeco        E DS                  EXTNAME(SETRSEPD)                    140951
     D TrSett        E DS                  EXTNAME(SETRSTPD)
     D P_DDCLTY      E                     EXTFLD(DDCLTY)
     D TrSwft        E DS                  EXTNAME(SETRSWPD)
     D TrExts        E DS                  EXTNAME(SETESDPD)                                  CSE045
 
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
 
     D*TCNR*****       S              6S 0                                                    CSD027
     D*DELF*****       S              6S 0                                                    CSD027
     D*DELT*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
     D DELF            S              6A                                                      CSD027
     D DELT            S              6A                                                      CSD027
 
      * OK Flags for Extension Screen
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  CSE045
 
     D*TRAWX2***       DS          1190                                                140951 CSW210
     D TRAWX2          DS          1780                                                       CSW210
     D PDATA         E DS                  EXTNAME(SE50DT)                      140951
                                                                                140951
 
      ** DS for customer/book standard settlement instruction                                 CSE028
      **  to be passed to SESSIR0                                                             CSE028
     D PCBStd        E DS                  EXTNAME(STDSED)                                    CSE028
     D                                     Occurs(2)                                          CSE028
                                                                                              CSE028
      ** Data structure for standard additional settlement details                            CSE028
      ** for customer/book to be passed to SESSIR0                                            CSE028
     D PCBStdAd      E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Occurs(8)                                          CSE028
                                                                                              CSE028
      ** DS for trade purchase                                                                CSE028
     D PTradeP       E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Prefix(TP:2)                                       CSE028
                                                                                              CSE028
      ** DS for trade sale                                                                    CSE028
     D PTradeS       E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Prefix(TS:2)                                       CSE028
                                                                                              CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
                                                                                              CSD015
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PMode           S              1A                                                      CSE028
     D PRetCode        S              5A                                                      CSE028
     D WCust           S              1A                                                      CSE028
     D WBook           S              1A                                                      CSE028
     D WDftFlg         S              1A                                                      CSE028
     D WErrFlg         S              1A                                                      CSE028
                                                                                              CSW202
     D CSW202          S              1A                                                      CSW202
     D CSE029          S              1A                                                      CSW202
     D CSE045          S              1A                                                      CSE045
     D PCALL           S              3A                                                      CSE045
     D PRtCd           S              7A                                                      CSW202
     D POptn           S              7A                                                      CSW202
     D PSard           S              6A                                                      CSW202
                                                                                              CSW202
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
      * Main processing
      *
     C                   EXSR      MAIN
      * Return
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'                                                        212772
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKTrSwft      @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
     C                   EVAL      WErrFlg = 'N'                                              CSE028
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   EVAL      WErrFlg = 'Y'                                              CSE028
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDTDRF
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
 
      * Screen Initialization
      *
     C                   EXSR      SCINIT
      *
      * PROTECT DETAIL FIELDS
      *
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'B'                                                        CSE028
     C                   MOVE      *OFF          *IN70
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
                                                                                              CSW202
      ** If CSE029 is installed set DDSNEW to 'Y' otherwise set to 'N'                        CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   IF        CSE029 = 'Y'                                               CSW202
     C                   EVAL      DDSNEW = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      DDSNEW = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
     C                   ENDIF                                                                CSW202
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   WRITE     SETRADES0
     C**********         WRITE     SETRADED1                                                AR656294
     C                   WRITE     SETRADEF1
     C                   WRITE     SETRADED1                                                AR656294
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SETRADED1                              99    *
     C                   ENDIF
     C                   EVAL      WDftFlg = *BLANK                                           201429
                                                                                              CSE028
      ** Set up PMODE for SE1806                                                              CSE028
                                                                                              CSE028
     C                   IF        *INKC = *OFF AND *INKE = *OFF AND                          CSE028
     C                             *INKL = *OFF AND *INKN = *OFF                              CSE028
      *                                                                                       CSE028
     C                   IF        DDACTN = 'I' AND WErrFlg = 'N'                             CSE028
     C                             or DDACTN = 'B' AND WErrFlg = 'N'                          205667
     C                             OR WErrFlg = 'N' AND (DDACTN = 'A' OR                      201429
     C                             DDACTN = 'C') AND T1NEW = 'N'                              201429
      *                                                                                       CSE028
     C                   IF        WCust = 'Y' OR WBook = 'Y'                                 CSE028
      *                                                                                       CSE028
     C                   IF        DDGMES = 'Y' AND DDSNEW = 'Y'                              201429
     C                   EVAL      WDftFlg = 'Y'                                              CSE028
      *                                                                                       CSE028
     C                   IF        BVREDE = 'N'                                               CSE028
     C                   EVAL      PMode = 'Y'                                                CSE028
     C                   ELSE                                                                 CSE028
     C                   EVAL      PMode = 'N'                                                CSE028
     C                   ENDIF                                                                CSE028
     C                   ENDIF                                                                201429
      *                                                                                       CSE028
      ** No SSI setup for the counterparty, then if Standard settlement                       201429
      ** is 'Y' and ISO15022 is 'Y', then force display of Extended                           201429
      ** Settlement screen.                                                                   201429
     C                   ELSE                                                                 201429
      *                                                                                       201429
     C                   IF        DDGMES = 'Y' AND DDSNEW = 'Y'                              201429
     C                   EVAL      PMode = 'N'                                                201429
     C                   EVAL      WDftFlg = 'N'                                              201429
     C                   ENDIF                                                                201429
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   ELSE                                                                 CSE028
      *                                                                                       CSE028
     C                   EVAL      PMode = 'N'                                                CSE028
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                         140951
      * If F14 taken, go to Extended Settlement Details SE1806                  140951
      * If MT5xx information was successfully defaulted, call SE1806                          CSE028
      * with PMODE set to 'Y' to update X2 file with the review screen.                       CSE028
      *                                                                         140951
     C     *INKN         IFEQ      *ON                                          140951
     C     CSE028        OREQ      'Y'                                                        CSE028
     C     WDftFlg       ANDEQ     'Y'                                                        CSE028
     C*****PMODE         ANDEQ     'Y'                                                 CSE028 201429
     C     PUYAT         ANDEQ     'Y'                                                        201429
     C     CSE028        OREQ      'Y'                                                        201429
     C     WDftFlg       ANDEQ     'N'                                                        201429
     C     PMode         ANDEQ     'N'                                                        201429
     C     PUYAT         ANDEQ     'Y'                                                        201429
      *                                                                                       178487
      * If trade reference not defined (on insert) get next available  trade                  178487
      * reference.                                                                            178487
      *                                                                                       178487
     C     DDTDRF        IFEQ      *BLANK                                                     178487
      *                                                                                       178487
     C                   CALLB     'ZATRNRTV'                                                 178487
     C                   PARM      *BLANKS       RetCodeOut                                   178487
     C                   PARM      'SE'          MODU              2                          178487
     C                   PARM      'T'           TRTY              1                          178487
     C                   PARM                    DDTDRF                                       178487
     C                   PARM      *ZERO         TDRF                                         178487
      *                                                                                       178487
      * DATABASE ERROR                                                                        178487
      *                                                                                       178487
     C     RetCodeOut    IFNE      *BLANK                                                     178487
     C                   MOVEL     'ZATRNRTV'    DBFILE                                       178487
     C                   MOVEL     '100'         DBASE                                        178487
     C                   MOVEL     DDTDRF        DBKEY                                        178487
     C                   EXSR      *PSSR                                                      178487
     C                   END                                                                  178487
                                                                                              178487
     C                   MOVEL     TDRF          DDTDRF                                       178487
                                                                                              178487
     C                   END                                                                  178487
                                                                                              178487
      *                                                                         140951
      * Set up PDATA array fields for passing to SE1806                         140951
     C                   EXSR      SetPDATA                                     140951
      *                                                                         140951
      *                                                                                       CSE045
      ** Call API Program if CSE045 is available and if this is accessed from                 CSE045
      ** SETRADRPR; otherwise, continue using SE1806.                                         CSE045
      *                                                                                       CSE045
     C                   IF        PCALL = 'RPR'                                              CSE045
     C                             AND CSE045 = 'Y'                                           CSE045
     C                   CLEAR                   NwSEFilFmt                                   CSE045
     C                   CALL      'SETSESSIN'                                                CSE045
     C                   PARM      '00'          PCMD                                         CSE045
     C                   PARM      'N'           PERR                                         CSE045
     C                   PARM                    PDATA                                        CSE045
     C                   PARM                    PMKCT                                        CSE045
     C                   PARM                    DftFlag                                      CSE045
     C                   PARM                    TRAWX2                                       CSE045
     C                   PARM                    SCREEN                                       CSE045
     C                   PARM                    PMode                                        CSE045
     C                   PARM                    DDSAFA                                       CSE045
     C                   PARM                    TrExts                                       CSE045
     C                   PARM                    OkTrExts                                     CSE045
     C                   PARM                    NwSEFilFmt                                   CSE045
     C                   ELSE                                                                 CSE045
      *
     C                   CALL      'SE1806'                                     140951
     C                   PARM      '00'          PCMD              2            140951
     C                   PARM      'N'           PERR              1            140951
     C                   PARM                    PDATA                          140951
     C                   PARM                    PMKCT             2                          205667
     C                   PARM                    DftFlag                                      CSE034
     C                   PARM                    TRAWX2                         140951
     C                   PARM                    SCREEN                         140951
     C                   PARM                    PMode                                        CSE028
     C                   PARM                    DDSAFA                                       201429
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
                                                                                              CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   ENDIF                                                                CSE045
      *                                                                         140951
     C                   SELECT                                                 140951
     C     PCMD          WHENEQ    '03'                                         140951
     C                   MOVE      '1'           *INKC                          140951
     C     PCMD          WHENEQ    '05'                                         140951
     C                   MOVE      '1'           *INKE                          140951
     C     PCMD          WHENEQ    '12'                                         140951
     C                   MOVE      '1'           *INKL                          140951
     C     PCMD          WHENEQ    '14'                                         140951
     C                   MOVE      '1'           *INKN                          140951
     C                   MOVE      'Y'           PUYAT                                        201429
     C     PCMD          WHENEQ    '00'                                                       201429
     C     PERR          ANDEQ     'N'                                                        201429
     C                   MOVE      ' '           PUYAT                                        201429
     C                   MOVE      '0'           *INKN                                        201429
     C                   ENDSL                                                  140951
      *                                                                         140951
     C                   ENDIF                                                  140951
      *
      * Clear message subfile
      *
     C**** martin        CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN                          140951
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * SCINIT - INITIAL SCREEN PROCESSING
      *****************************************************************
     C     SCINIT        BEGSR
      *
      * Retrieve Securities Trading info for Deliver From Depot (DELF)
      * --------------------------------------------------------------
      *
     C*****DELF*         IFNE      *ZEROS                                                     CSD027
     C     DELF          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      DELF          @SCKY             6
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        DELF_CLAS         1
     C                   ENDIF
      *
      * Retrieve Securities Trading info for 'Deliver To' Depot (DELT)
      * --------------------------------------------------------------
      *
     C*****DELT*         IFNE      *ZEROS                                                     CSD027
     C     DELT          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      DELT          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        DELT_CLAS         1
     C                   ENDIF
      *
      * Retrieve Securities Trading info for Counterparty (TCNR)
      * --------------------------------------------------------
     C*****TCNR*         IFNE      *ZEROS                                              208195 CSD027
     C     TCNR          IFNE      *BLANKS                                                    CSD027
      *
     C                   MOVE      TCNR          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        TCNR_CLAS         1
     C     *LIKE         DEFINE    PC101         TCNR_DRF1                      140951
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFDRF1        TCNR_DRF1                      140951
     C     *LIKE         DEFINE    PC102         TCNR_DRF2                      140951
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVEL     BFDRF2        TCNR_DRF2                      140951
     C                   ENDIF                                                                208195
      *                                                                                       178487
      * Define Trade number field for use by SE1806.                                          178487
      *                                                                                       178487
     C     *LIKE         DEFINE    DDTDRF        TDRF                                         178487
      *                                                                                       178487
      *
      * SET SCREEN PROTECT/NON-DISPLAY INDICATORS
      * =========================================
      *
      ** NON-Display Fungibility Code & Fungible Trade Indicator.
      *
     C                   MOVE      *OFF          *IN61
      *
      ** NON-Display
      ** Ins.Type, Ins. Sub-Type, Euroclear/Cedel Code, Safekeeping
      ** A/c, Requested Priorty, Guaranteed Delivery & Sender's Role.
      *
     C                   MOVE      *OFF          *IN62
      *
      ** NON-Display Conf message req, cust/counterparty ind, further ID
      *
     C                   MOVE      *OFF          *IN63
      *
      ** Determine fields to display on screen A.
      *
     C     Screen        IFEQ      'A'
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVE      *ON           *IN61
     C     DDCLTY        WHENEQ    '5'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN64                                        CSE034
     C     CSE028        IFNE      'Y'                                                        CSE034
     C                   MOVE      *ON           *IN62
     C                   ENDIF                                                                CSE034
     C*                                                                                       CSE034
     C                   ENDSL
     C                   ENDIF
      *
      ** Determine fields to display on screen B.
      *
     C     Screen        IFEQ      'B'
      *
      ** Determine fields to display on screen B.
      *
     C     DDCLTY        IFEQ      '1'
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
     C     DDCLTY        IFNE      '1'
     C     DDCLTY        ANDNE     '3'
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDEQ     'E'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVE      *ON           *IN61
     C                   ENDIF
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDNE     'E'
     C     DELF_CLAS     ANDNE     'C'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDNE     'E'
     C     DELT_CLAS     ANDNE     'C'
     C                   MOVE      *ON           *IN61
     C     CSE028        IFNE      'Y'                                                        CSE034
     C                   MOVE      *ON           *IN62
     C                   ENDIF                                                                CSE034
     C                   ENDIF
     C                   ENDIF
      *
     C*****CSE028        IFNE      'Y'                                                 CSE034 CAP084
     C                   MOVE      *ON           *IN63
     C*****              ENDIF                                                         CSE034 CAP084
     C     DDCLTY        IFEQ      '5'                                                        CSE034
     C                   MOVE      *ON           *IN64                                        CSE034
     C                   ENDIF                                                                CSE034
      *
     C                   ENDIF
                                                                                              CSE028
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information                       CSE028
                                                                                              CSE028
     C     CSE028        IFEQ      'Y'                                                        CSE028
     C     DDACTN        ANDEQ     'I'                                                        199797
     C     DftFlag       ANDEQ     'Y'                                                        CSE034
     C     CSE028        OREQ      'Y'                                                        205667
     C     DDACTN        ANDEQ     'B'                                                        205667
                                                                                              CSE028
     C     DDSESN        CHAIN     SECTYDF                            99                      199797
     C                   EVAL      PInvTyp = SITP                                             199797
                                                                                              199797
     C     DDACTN        IFEQ      'B'                                                        205667
     C     DDSETC        ANDEQ     *blanks                                                    205667
     C                   EVAL      ddsetc = spyc                                              205667
     C                   END                                                                  205667
                                                                                              205667
     C                   CALLB     'SESSIR0'                                                  CSE028
     C                   PARM      'D'           POType            1                          CSE028
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    TCNR                                         CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
     C                   PARM                    PInvTyp           3                          CSE028
     C                   PARM                    PPorRef           4                          CSE028
     C                   PARM                    PCBStd                                       CSE028
     C                   PARM                    PCBStdAd                                     CSE028
     C                   PARM      *BLANKS       PRetCode                                     CSE028
                                                                                              CSE028
     C                   SELECT                                                               CSE028
     C                   WHEN      PRetCode <> '*NRF ' AND PRetCode <> '*NCRF'                CSE028
     C     2             OCCUR     PCBStd                                                     CSE028
     C                   EVAL      WBook = 'N'                                                CSE028
     C                   EVAL      WCust = 'Y'                                                CSE028
     C                   WHEN      PRetCode <> '*NRF ' AND PRetCode <> '*NBRF'                CSE028
     C     1             OCCUR     PCBStd                                                     CSE028
     C                   EVAL      WBook = 'Y'                                                CSE028
     C                   EVAL      WCust = 'N'                                                CSE028
     C                   OTHER                                                                CSE028
     C                   EVAL      WBook = 'N'                                                CSE028
     C                   EVAL      WCust = 'N'                                                CSE028
     C                   ENDSL                                                                CSE028
                                                                                              CSE028
     C                   IF        WBook = 'Y'                                                CSE028
     C                   SELECT                                                               CSE028
                                                                                              CSE028
     C     DDTDTP        WHENEQ    'TP'                                                       CSE028
     C                   DO                                                                   CSE028
     C     1             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeP                                      CSE028
     C                   ENDDO                                                                CSE028
                                                                                              CSE028
     C     DDTDTP        WHENEQ    'TS'                                                       CSE028
     C                   DO                                                                   CSE028
     C     2             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeS                                      CSE028
     C                   ENDDO                                                                CSE028
                                                                                              CSE028
     C                   ENDSL                                                                CSE028
                                                                                              CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CSE028
     C                   IF        WCust = 'Y'                                                CSE028
     C                   SELECT                                                               CSE028
                                                                                              CSE028
     C     DDTDTP        WHENEQ    'TP'                                                       CSE028
     C                   DO                                                                   CSE028
     C     5             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeP                                      CSE028
     C                   ENDDO                                                                CSE028
                                                                                              CSE028
     C     DDTDTP        WHENEQ    'TS'                                                       CSE028
     C                   DO                                                                   CSE028
     C     6             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeS                                      CSE028
     C                   ENDDO                                                                CSE028
                                                                                              CSE028
     C                   ENDSL                                                                CSE028
                                                                                              CSE028
     C                   ENDIF                                                                CSE028
     C                   ENDIF                                                                CSE028
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************         140951
      * SetPDATA - Set up data structure for call to SE1806                     140951
      *****************************************************************         140951
     C     SetPDATA      BEGSR                                                  140951
      *                                                                         140951
     C                   MOVEL     DDACTN        PACTN                          140951
     C     DDACTN        IFEQ      'C'                                          140951
     C                   MOVEL     'A'           PACTN                          140951
     C                   END                                                    140951
     C                   MOVEL     DDTDRF        PTDRF                          140951
     C**********         MOVEL     TNMC          PTNMC                          140951 140951 CSE028
     C                   MOVEL     DDSETC        PTNMC                                        CSE028
     C                   MOVEL     DDSESN        PSESN                          140951
     C**********         MOVEL     DDSRPN        PSRPN                                 140951 CSE016
     C                   MOVEL     DDBLKR        PBLKR                          140951
     C                   MOVEL     TCNR          PTCNR                          140951
     C                   MOVEL     DDBRCD        PTDBR                          140951
     C                   MOVEL     DDTDTP        PTDTP                          140951
     C                   MOVEL     NOML          PNOML                          140951
     C                   MOVEL     DDTDMI        PTDMI                          140951
     C                   MOVEL     DDAIIP        PAIIP                          140951
     C                   MOVEL     DDINCS        PINCS                          140951
     C                   MOVEL     BVDR1         PDC01                          140951
     C                   MOVEL     BVDR2         PDC02                          140951
     C                   MOVEL     DDCLTY        PCLTY                          140951
     C                   MOVEL     DDPCOD        PPCOD                          140951
     C**********         MOVEL     DELT          PDELT                                 140951 213037
     C**********         MOVEL     DELF          PDELF                                 140951 213037
     C                   EVAL      PDELT = DELT                                               213037
     C                   EVAL      PDELF = DELF                                               213037
     C                   MOVEL     DDTDSI        PTDSI                          140951
     C                   MOVEL     DDSMTH        PSMTH                          140951
     C                   MOVEL     TCNR_DRF1     PC101                          140951
     C                   MOVEL     TCNR_DRF2     PC102                          140951
     C                   MOVEL     DDGMES        PGMES                          140951
     C                   MOVEL     DDGMEC        PGMEC                          140951
     C                   MOVEL     DDCCID        PCCID                          140951
     C                   MOVEL     DDPRYC        PPRYC                          140951
     C                   Z-ADD     TDVD          PTDVD                          140951
      *                                                                                       CSE028
     C     CSE028        IFEQ      'Y'                                                        CSE028
     C                   MOVEL     DDSNEW        PSNEW                                        CSE028
     C                   MOVEL     DDBPBK        PPBKC                                        CSE028
     C                   MOVEL     DDMRKT        PMKCT                                        205667
     C                   ENDIF                                                                CSE028
      *                                                                         140951
     C                   ENDSR                                                  140951
      *****************************************************************         140951
      /EJECT                                                                    140951
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS :
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Screen A/B
     C                   PARM                    Screen            1
      *
      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco                         140951
     C                   PARM                    TrSett
     C                   PARM                    TrSwft
     C                   PARM                    TrExts                                       CSE045
      *
      * Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC              3            140951
     C                   PARM                    NOML             11 0          140951
     C                   PARM                    TDVD              5 0          140951
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator in file                                                           201429
     C                   PARM                    T1NEW             1                          201429
      *                                                                                       CSE034
      ** Default SSI flag                                                                     CSE034
     C                   PARM                    DftFlag           1                          CSE034
      * fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     CSE045
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Destination of Settlement Text fields
     C                   PARM                    DDROUS            6
     C                   PARM                    DDROTS           12
      * Destination of Confirmation Text fields
     C                   PARM                    DDROUC            6
     C                   PARM                    DDROTC           12
      * Security report name
     C**********         PARM                    DDSRPN                                       CSE016
     C                   PARM                    DDSRNME          41                          CSE016
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201            1                          CSW201
     C                   PARM                    PCALL                                        CSE045
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM                    PBYSL             1                          CAP067
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1            140951
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
                                                                                              CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       CSE045
     C                   PARM                    NwSEFilFmt                                   CSE045
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADEDSP'  DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        DDUser
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if (CSW003) MT5XX - Phase 2 Message Generation is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CSW003
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *                                                                                       CSE028
      ** Check if CSE028 is switched on.                                                      CSE028
      *                                                                                       CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *BLANKS       @RTCD                                        CSE028
     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
     C                   PARM      'CSE028'      @SARD                                        CSE028
     C                   PARM                    DSFDY                                        CSE028
      *                                                                                       CSE028
      ** Database Error                                                                       CSE028
      *                                                                                       CSE028
     C     @RTCD         IFNE      *BLANKS                                                    CSE028
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE028
     C                   MOVEL     '904'         DBASE                                        CSE028
     C                   MOVEL     @OPTN         DBKEY                                        CSE028
     C                   EXSR      *PSSR                                                      CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C     @RTCD         IFEQ      *BLANK                                                     CSE028
     C                   MOVE      'Y'           CSE028            1                          CSE028
     C                   MOVE      *ON           *IN72                                        CSE028
     C                   ELSE                                                                 CSE028
     C                   MOVE      'N'           CSE028                                       CSE028
     C                   MOVE      *OFF          *IN72                                        CSE028
     C                   ENDIF                                                                CSE028
      *                                                                         140951
      ** ACCESS SECURITIES TRADING DETAILS                                      140951
      *                                                                         140951
     C                   CALL      'AOSTRDR0'                                   140951
     C                   PARM      *BLANKS       @RTCD             7            140951
     C                   PARM      '*FIRST  '    @OPTN             7            140951
     C     SDSTRD        PARM      SDSTRD        DSSDY                          140951
      *                                                                         140951
      * DATABASE ERROR                                                          140951
      *                                                                         140951
     C     @RTCD         IFNE      *BLANK                                       140951
     C                   MOVEL     'SDSTRDPD'    DBFILE                         140951
     C                   MOVEL     '903'         DBASE                          140951
     C                   MOVEL     @OPTN         DBKEY                          140951
     C                   EXSR      *PSSR                                        140951
     C                   END                                                    140951
                                                                                              CSW201
      ** If CSW201 - Swift 2001 Standards Update is installed, protect                        CSW201
      ** Standing Instructions Override field                                                 CSW201
      ** If CSE028 - Standing Settlements Instruction is installed,                           CSE028
      ** protect Standing Instructions Override field                                         CSE028
                                                                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                             OR CSE028 = 'Y'                                            CSE028
     C                   EVAL      *IN71 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CAP067
      ** If Buy-sell back processing, write appropriate screen header                         CAP067
     C                   IF        PBYSL = 'Y'                                                CAP067
     C                   EVAL      *IN86 = *ON                                                CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      *IN86 = *OFF                                               CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CSW202
      ** Check if CSW202 is switched on                                                       CSW202
                                                                                              CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRtCd                                        CSW202
                                                                                              CSW202
     C                   IF        PRtCd = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C**********         EVAL      *IN72 = *OFF                                        CSW202 221557
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
      ** Check if CSE029 is switched on                                                       CSW202
                                                                                              CSW202
     C                   EVAL      CSE029 = 'N'                                               CSW202
                                                                                              CSW202
     C                   CALLB     'AOSARDR0'                                                 CSW202
     C                   PARM      *BLANKS       PRtCd                                        CSW202
     C                   PARM      '*VERIFY'     POptn                                        CSW202
     C                   PARM      'CSE029'      PSard                                        CSW202
     C                   PARM                    DSFDY                                        CSW202
                                                                                              CSW202
     C                   IF        PRtCd <> *BLANKS and PRtCd <> '*NRF   '                    CSW202
     C     *LOCK         IN        LDA                                                        CSW202
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW202
     C                   EVAL      DBASE  = 905                                               CSW202
     C                   EVAL      DBKEY  = 'CSE029'                                          CSW202
     C                   OUT       LDA                                                        CSW202
     C                   EXSR      *PSSR                                                      CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        PRtCd = *BLANKS                                            CSW202
     C                   EVAL      CSE029 = 'Y'                                               CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSE045
      ** Check if CSE045 is switched on                                                       CSE045
                                                                                              CSE045
     C                   EVAL      CSE045 = 'N'                                               CSE045
                                                                                              CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       PRtCd                                        CSE045
     C                   PARM      '*VERIFY'     POptn                                        CSE045
     C                   PARM      'CSE045'      PSard                                        CSE045
     C                   PARM                    DSFDY                                        CSE045
                                                                                              CSE045
     C                   IF        PRtCd <> *BLANKS and PRtCd <> '*NRF   '                    CSE045
     C     *LOCK         IN        LDA                                                        CSE045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE045
     C                   EVAL      DBASE  = 906                                               CSE045
     C                   EVAL      DBKEY  = 'CSE045'                                          CSE045
     C                   OUT       LDA                                                        CSE045
     C                   EXSR      *PSSR                                                      CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   IF        PRtCd = *BLANKS                                            CSE045
     C                   EVAL      CSE045 = 'Y'                                               CSE045
     C                   ENDIF                                                                CSE045
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
