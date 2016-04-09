     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-sell interface control')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLCTL - SE Buy-Sell Interface Control                    *
      *                                                               *
      *  Function: This entry module is a batch API function that     *
      *            processes incoming Security Buy-sell back messages *
      *            and determines whether they are valid or invalid.  *
      *                                                               *
      *            The decision as to whether to write to the Valid   *
      *            or Invalid file and the call to the Message Handler*
      *            (ZAMSGHNDLE) will take place in this module.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249071             Date 31Jul07               *
      *                 249072             Date 12Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 233708             Date 02Jun05               *
      *                 233881             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210284             Date 08Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 08Apr02               *
      *                 CSC011             Date 14Mar02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249071 - CSE097 problems in BYSL(Recompile)                  *
      *  249072 - Missing parameter for calling SETRADSVAL            *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233708 - Addition of Fiscal Price for CGL031 (Recompile)     *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  CGL031 - Taxation of Savings Income.                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  216338 - Add missing parameter                               *
      *  210284 - Current factor not applied to countervalue for 'MP' *
      *           Securities. Add checking to SEDEV for new current   *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue. Amended to be consistent with SE0050. *
      *           Applied fix 201168.                                 *
      *  CSE031 - Coupon Fixing for Floating Rate Notes. (Recompile)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Valid Buy-Sell Trades
     FSEVBYSLPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
 
      ** Valid Trades - Extension file
     FSEVTRX1PD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
 
      ** Invalid Buy-Sell Trades
     FSEIBYSLPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(IN_)
     F                                     COMMIT
 
      ** Work File for Buy-Sell Trades
     FSEWBYSLL0 UF A E           K DISK    INFSR(*pssr)
     F                                     PREFIX(W1_)
     F                                     COMMIT
 
      ** Valid Securities Buy-Sell by front office ID
     FSEVBYSLL0 IF   E           K DISK    RENAME(SEVBYSLD0:SEVBYSLCHK)
     F                                     INFSR(*pssr)
 
      ** Valid Buy-sell by Trade reference and timestamp
     FSEVBYSLL1 IF   E           K DISK    RENAME(SEVBYSLD0:SEVBYSLCK1)
     F                                     INFSR(*pssr)
 
      ** Current and Historic Trades file
     FTRADHS    IF   E           K DISK    INFSR(*PSSR)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEBYSLC001
 
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure to hold incoming header variables
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Data structure to hold incoming transaction variables
     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
     D TranInExch    E DS                  EXTNAME(SETREXPD)
     D TranInSett    E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
     D TranInThir    E DS                  EXTNAME(SETRTHPD)                                  CAS006
 
      ** Data structure to hold work file variables
     D WInValdTr     E DS                  EXTNAME(SEWBYSLPD)
     D                                     PREFIX(W1_)
     D***W1DETL*                 62    812                                                    CGL029
     D***W2DETL*                840    888                                             CAS006 CGL029
     DW1DETL                  62    824                                                       CGL029
     DW2DETL                 852    900                                                       CGL029
 
      ** Data structures to hold invalid file variables
     D TInValTrd     E DS                  EXTNAME(SEIBYSLPD)
     D                                     PREFIX(IN_)
     D***I1DETL*                 62    812                                                    CGL029
     D***I2DETL*                840    888                                             CAS006 CGL029
     DI1DETL                  62    824                                                       CGL029
     DI2DETL                 852    900                                                       CGL029
     D TInValTrd1    E DS                  EXTNAME(SEIBYSLPD)
     D                                     PREFIX(TI1)
     D TInValTrd2    E DS                  EXTNAME(SEIBYSLPD)
     D                                     PREFIX(TI2)
 
      ** Data structure to hold current valid trade variables
     D ValidTrad     E DS                  EXTNAME(SEVBYSLPD)
     D                                     PREFIX(V_)
     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(V_)
     D ValidTX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VA_)
     D ValidTX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VB_)
 
      ** Data structures to hold valid trade variables
     D TValdTrad1    E DS                  EXTNAME(SEVBYSLPD)
     D                                     PREFIX(TV1)
     D TValdTrad2    E DS                  EXTNAME(SEVBYSLPD)
     D                                     PREFIX(TV2)
 
      ** Data structures to hold trade extension variables
     D TValdTrX1     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(TX1)
     D TValdTrX2     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(TX2)
     D TValdTrX3     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(TX3)
 
      ** Data structures to hold trade files variables
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
 
      ** Data structures to hold error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
 
      ** Data structures to hold security details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)
     D SEC_FRNT      E                     EXTFLD(FRNT)
     D SEC_REPA      E                     EXTFLD(REPA)
     D SEC_TMST      E                     EXTFLD(TMST)
 
      ** Data structures to hold investment type details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
      * The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      * The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities Trading Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** External DS for Switchable features details
      *
     D InfData       E DS                  EXTNAME(SETRIFPD)
      ** SE Extra Data - Classe 1 Data - File (D/B) format
      *
     D ExtData       E DS                  EXTNAME(SETDEXPD)
      ** SE Trades Extra Data - File (D/B) format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure
      *
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D TradSwX2A     E DS                  EXTNAME(TRADSDX2)                                  216338
     D                                     PREFIX(A_)                                         216338
                                                                                              216338
     D TradSwX2B     E DS                  EXTNAME(TRADSDX2)                                  216338
     D                                     PREFIX(B_)                                         216338
                                                                                              216338
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A
     D Trans5008       S            500A                                                      CAS006
 
      ** Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SEBYSLUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      *
      ** Country of treaty
     D PDRBW           S              2A
      *
      ** Withholding tax
     D DDWTAX          S             15A
 
      ** Swift 2001 flag
     D CSW201          S              1A
 
     D CSC011          S              1A                                                      CSC011
     D CallFromVU      S              1A   INZ(' ')                                           CAP087
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WTRTP           S             20A                                                      CSC011
                                                                                              CSC011
     D PUYAT           S              1                                                       216338
     D CAS006          S              1                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
                                                                                              CAS006
      ** CGL031 access object                                                                 CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEBYSLC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEBYSLC003
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
 
      *
      ** Incoming string Trans5001 is composed of transaction type(SEBYS1/SEBYS2) and
      ** primary screen of the trade
      *
     C                   MOVEL     Trans5001     DDTRTP           20
     C     77            SUBST     Trans5001:21  TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     Trans5003     TranInExch
     C                   MOVEL     Trans5004     TranInSett
     C                   MOVEL     Trans5005     TranInChCm
     C                   MOVEL     Trans5006     TranInSwfA
     C                   MOVEL     Trans5007     TranInSwfB
     C                   MOVEL     Trans5008     TranInThir                                   CAS006
     C                   MOVEL     Infdata500    Infdata
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     ' '           PFBYSL
      *
     C                   EVAL      W1DETL = TranInPrim+TranInSeco+TranInExch
     C                                     +TranInSett+TranInChCm+TranInSwfA
     C                                     +TranInSwfB
     C                   EVAL      W2DETL = TranInThir                                        CAS006
      *
      ** Write to work file
      *
     C                   EXSR      SRWrWrkFil
      *
      ** Process both legs
      *
     C     PFBYSL        DOWEQ     'Y'
     C     PFBYSL        OREQ      'N'
      *
      ** Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      ** Reset variables gradually updated
      *
     C                   EXSR      SRResetCyc
      *
      /COPY WNCPYSRC,SEBYSLC004
      *
      ** Check if valid trade exists for Front Office ID
      *
     C                   EXSR      SRChkVTrad
      *
      ** If valid trade does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if valid trade exists for Midas Trade Ref
      *
     C                   EXSR      SRChkVMiTR
      *
      ** If valid trade does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid trades file.
      *
     C                   EXSR      SRResetCyc
      *
      /COPY WNCPYSRC,SEBYSLC005
      *
      ** Validate Action Code
      *
     C                   EXSR      SRValidAct
      *
      /COPY WNCPYSRC,SEBYSLC006
      *
      ** If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLC007
      *
      ** Validate the trade
      *
     C                   EXSR      SRValidTrd
      *
      /COPY WNCPYSRC,SEBYSLC008
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,SEBYSLC009
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,SEBYSLC010
 
     C                   EXSR      SRChkWrite
      /COPY WNCPYSRC,SEBYSLC011
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If second leg is processed, terminate the loop
      *
     C     PFBYSL        IFEQ      'N'
     C                   MOVE      ' '           PFBYSL
     C                   ENDIF
      *
      ** If first leg is processed, move 'N' to PFBYSL to process the second leg
      *
     C     PFBYSL        IFEQ      'Y'
     C                   MOVE      'N'           PFBYSL
      *
      ** Retrieve the second leg using the FO associated ID of the first leg
      *
     C     APFOAsocID    CHAIN     SEWBYSLL0                          99
      *
     C     *IN99         IFEQ      *OFF
      *
      ** Move the record variables from the work file to the current variables
      ** and do normal processing
      *
     C                   EXSR      SRWrkToCur
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEBYSLC012
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrWrkFil - Routine to write to work file                    *
      *                                                               *
      *****************************************************************
     C     SRWrWrkFil    BEGSR
 
     C                   MOVEL     DDTRTP        W1_DDTRTP
      *
      ** Setup header for work file then write
      *
     C                   EXSR      SRSetUpWHd
     C                   WRITE     SEWBYSLD0
      *
     C     DDTRTP        IFEQ      'SEBYS2'
      *
      ** If the incoming message has a transaction type of SEBYS2(trade is second leg),
      ** get the first leg from the work file using the associated front office id. So
      ** that the processing will start with the first leg of the trade
      *
     C     APFOAsocID    CHAIN     SEWBYSLL0                          99
      *
      ** If record is found, move the variables from work file to the current
      *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'Y'           PFBYSL
     C                   EXSR      SRWrkToCur
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkVTrad - Routine to check if valid trade exists           *
      *              for Front Office ID                              *
      *                                                               *
      *****************************************************************
     C     SRChkVTrad    BEGSR
      *
      ** Check for trade on Valid file
      *
     C     APFOTranID    CHAIN     SEVBYSLL0                          99
      *
      ** If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
      *
     C     APFOTranID    CHAIN     SEVBYSLL0                          99
      *
      ** Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrkToCur - Routine to move varibles from work file to the   *
      *              current variables                                *
      *                                                               *
      *****************************************************************
     C     SRWrkToCur    BEGSR
      *
     C     77            SUBST     W1DETL:1      TranInPrim
     C     126           SUBST     W1DETL:78     TranInSeco
     C     39            SUBST     W1DETL:204    TranInExch
     C*****131**         SUBST     W1DETL:243    TranInSett                                   CGL029
     C*****204**         SUBST     W1DETL:374    TranInChCm                                   CGL029
     C*****87***         SUBST     W1DETL:578    TranInSwfA                                   CGL029
     C*****87***         SUBST     W1DETL:665    TranInSwfB                                   CGL029
     C     143           SUBST     W1DETL:243    TranInSett                                   CGL029
     C     204           SUBST     W1DETL:386    TranInChCm                                   CGL029
     C     87            SUBST     W1DETL:590    TranInSwfA                                   CGL029
     C     87            SUBST     W1DETL:677    TranInSwfB                                   CGL029
     C     49            SUBST     W2DETL:1      TranInThir                                   CAS006
     C                   EVAL      DDTRTP = W1_DDTRTP
     C                   EVAL      APFOTranID = W1_DDFOtranID
     C                   EVAL      APFOAsocID = W1_DDFOAsocID
     C                   EVAL      APRprLocn = W1_DDRprLocn
      *
      ** Setup the Automatic Autorisation Flag
      *
     C                   IF        CAP051 = 'Y'
     C                   EVAL      AUTHA = W1_DDAUTHA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkVMiTR - Routine to check if valid trade exists for       *
      *              Midas Trade Reference                            *
      *                                                               *
      *****************************************************************
     C     SRChkVMiTR    BEGSR
      *
      ** If (numeric) Midas Trade Reference supplied
      *
     C                   TESTN                   DDTDRF               9898
 
     C     DDTDRF        IFNE      *BLANKS
     C     *IN98         ANDEQ     '1'
      *
      ** Check for trade on Valid file
      *
     C                   MOVEL     DDTDRF        TDRF
     C     TDRF          CHAIN     SEVBYSLL1                          99
      *
      ** If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ** ..delay, then repeat check
      *
     C                   CALLB     'ZACDELAY'
 
     C     TDRF          CHAIN     SEVBYSLL1                          99
      *
      ** Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidAct - Routine to validate action code versus the       *
      *              transaction IDs supplied                         *
      *                                                               *
      *****************************************************************
     C     SRValidAct    BEGSR
      *
      ** All buy-sell transactions in this program should be insert
      *
     C                   MOVE      'I'           DDACTN
     C                   MOVEL     '*FRONT'      ModeofOp
      *
      ** Validate action code versus transaction IDs supplied
      ** This function will set the Midas trade reference
      ** The trade in file format from the SE database is retrieved as well.
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'SETRADRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
      *
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF            6
      *
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003            1
      *
      * Buy-sell back
     C                   PARM                    PFBYSL            1
      *
      * Trade Reference
     C                   PARM                    PFTDRF            6
      *
      * OUTPUTS
      *
      * (Current) trade in file format
      * (Current) trade extension in file format
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Trade Reference
     C                   PARM                    DDTdrfOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Move book from file to work field for later checking.
      *
     C                   MOVE      V_TDBK        OLDBK1            2
     C                   MOVE      *BLANK        WARNIND           1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidTrd - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
     C     SRValidTrd    BEGSR
      *
      ** Validate Trade Primary details
      *
     C                   EXSR      SRValidPrim
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      ** Validate Trade Secondary details
      *
     C                   EXSR      SRValidSec
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
                                                                                              CAS006
      ** Validate more Trade details (third screen)                                           CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRValidThr                                                 CAS006
                                                                                              CAS006
      ** If error in validation, fail this input                                              CAS006
                                                                                              CAS006
     C     Idx           IFNE      0                                                          CAS006
     C                   GOTO      EValidTr                                                   CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
 
      * Default Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
      /COPY WNCPYSRC,SEBYSLC013
 
     C                   EXSR      SRDfltOth
 
      /COPY WNCPYSRC,SEBYSLC014
      * SRCalcChCm - Calculate Trade Charges/Commissions
 
     C                   EXSR      SRCalcChCm
 
      * Validate Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
 
     C                   EXSR      SRValidOth
                                                                                              233881
      * SRCalcEuTx - Calculate EU Tax                                                         233881
                                                                                              233881
     C                   IF        CGL031 = 'Y'                                               233881
     C                   EXSR      SRCalcEuTx                                                 233881
     C                   ENDIF                                                                233881
 
      * SRCalcCVal - Calculate Trade Countervalue
 
     C                   EXSR      SRCalcCVal
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      ** If MT5XX Message Generation are installed,
      *
     C     S01401        IFEQ      'Y'
      *
      ** Default Trade Extension (SWIFT) 'A' details
      *
     C     TranInSwfA    IFEQ      *BLANK
     C                   EXSR      SRDfltSwfA
     C                   ENDIF
                                                                                              216338
      ** Default fields for the TRADSDX2 file                                                 216338
                                                                                              216338
     C                   EXSR      SRDfltTrX2A                                                216338
      *
      ** Validate Trade Extension (SWIFT) 'A' details
      *
     C                   EXSR      SRValidSwfA
      *
      **  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
      ** If screen B is required
      *
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     V_DELT        ANDNE     V_DELF
     C     CustClass     OREQ      'D'
     C     V_DELT        ANDNE     V_DELF
      *
      ** Default Trade Extension (SWIFT) 'B' details
      *
     C     TranInSwfB    IFEQ      *BLANK
     C                   EXSR      SRDfltSwfB
     C                   ENDIF
                                                                                              216338
      ** Default fields for the TRADSDX2 file                                                 216338
                                                                                              216338
     C                   EXSR      SRDfltTrX2B                                                216338
      *
      ** Validate Trade Extension (SWIFT) 'B' details
      *
     C                   EXSR      SRValidSwfB
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidPrim - Validate Trade Primary details                   *
      *                                                               *
      *****************************************************************
     C     SRValidPrim   BEGSR
 
     C                   CALLB     'SETRADPVAL'
 
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Trade Primary Details
     C                   PARM                    TranInPrim
      *
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      * Trade settlement currency
     C                   PARM                    DDSETC            3
      *
      * Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      *
      * Output details of original book.
     C                   PARM                    OLDBK1
     C                   PARM                    WARNIND
      *
      * First Buy-sell back indicator
     C                   PARM                    PFBYSL            1
      *
      * First Buy-sell book code
     C                   PARM                    PFBPBK            2
      *
      * First Buy-sell counterparty
     C                   PARM                    PFTCNR            6 0
      *
      * First Buy-sell trade type
     C                   PARM                    PFTDTP            2
      *
      * First Buy-sell Value Date
     C                   PARM                    PFTDVD            5 0
      *
      * First Buy-sell Security Shortname
     C                   PARM                    PFSESN           10
     C                   PARM                    CallFromVU                                   CAP087
      *
      * OUTPUTS
      *
      * Security Details
      * Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      * Coupon Rate
      * Current Factor
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
      *
      * Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      * Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Portfolio Details
     C                   PARM                    PortDts
      *
      * Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      * Trade Primary Details OK inds
     C                   PARM                    OKTrPrim
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      *
      * PB Order Number
     C                   PARM                    DDORDE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidSec - Validate Trade Secondary details                 *
      *                                                               *
      *****************************************************************
     C     SRValidSec    BEGSR
      *
     C                   CALLB     'SETRADSVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Trade Primary Details
      * Trade Secondary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
      *
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      * Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM      'Y'           Validate
      *
      * Security Details
      * Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      * Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      * Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
      *                                                                                       CGL031
      * CGL031                                                                                CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              249072
      ** Current File Trade Date                                                              249072
     C                   PARM                    TDVD                                         249072
      *                                                                                       249072
      * OUTPUTS
      *
      * Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      * Trade Secondary Details OK inds
     C                   PARM                    OKTrSeco
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRValidThr - Validate Trade third screen details             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRValidThr    BEGSR                                                                CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTVAL'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Response mode                                                                        CAS006
                                                                                              CAS006
     C                   PARM                    RespMode                                     CAS006
                                                                                              CAS006
      ** Trade Primary Details                                                                CAS006
      ** Trade Secondary Details                                                              CAS006
      ** Trade Third screen details                                                           CAS006
                                                                                              CAS006
     C                   PARM                    TranInPrim                                   CAS006
     C                   PARM                    TranInSeco                                   CAS006
     C                   PARM                    TranInThir                                   CAS006
                                                                                              CAS006
      ** Custom Extra Data file data                                                          CAS006
                                                                                              CAS006
     C                   PARM                    ExtData                                      CAS006
                                                                                              CAS006
      ** Default & Validate (Y or N)                                                          CAS006
                                                                                              CAS006
     C                   PARM      'Y'           Default                                      CAS006
     C                   PARM      'Y'           Validate                                     CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Coupon Rate using NTR                                                                CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Customer (Counterparty) Details                                                      CAS006
      ** Portfolio Details                                                                    CAS006
      ** Nominal Currency Details                                                             CAS006
      ** Settlement Currency Details                                                          CAS006
                                                                                              CAS006
     C                   PARM                    CustDts                                      CAS006
     C                   PARM                    PortDts                                      CAS006
     C                   PARM                    NomCcyDts                                    CAS006
     C                   PARM                    SetCcyDts                                    CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
                                                                                              CAS006
      ** Trade Third screen details OK inds                                                   CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIDArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    Idx                                          CAS006
                                                                                              CAS006
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIDArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    WIdx                                         CAS006
                                                                                              CAS006
      ** Valid Trade layout (DS) from/to caller                                               CAS006
                                                                                              CAS006
     C                   PARM                    ValidTrad                                    CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      * SRDfltOth - Default Trade Other details                       *
      *                                                               *
      *****************************************************************
     C     SRDfltOth     BEGSR
      *
      ** Exchnage rate defaulting
      *
     C                   CALLB     'SETEXCHDFT'
      * INPUTS
      *
      * Nominal Currency
      * Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDSETC            3
      *
      * Nominal Currency Details
      * Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      * ICD
      * Euro Currency
      * EMU SE Settlement Ccy Conv.
     C                   PARM                    BKEURO            3
     C                   PARM                    CEU005            1
      *
      * OUTPUTS
      *
      * Trade Exchange Rate screen fields
      *
     C                   PARM                    TranInExch
      *
      * Trade Exchange Rate file fields
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    V_TBCR           13 8
      *
      ** Settlement instruction defaulting
      *
     C                   CALLB     'SETSETIDFT'
      *
      * INPUTS
      *
      * Booking branch
      * Incomplete Ind
      * Trade Type
      * Settlement Currency
      * Market Ind.
      * Book Code.
      ** Market Centre                                                                        216338
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBPBK
     C                   PARM                    DDMRKT                                       216338
      *
      * Investment type (SECTYD)
     C                   PARM                    SITP              3
      *
      * Nominal Currency Details
      * Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      *
      * Customer (Counterparty) Details
      * ( Note: Customer Participant/Non-participant Indicator 1 and
      *  Customer Participant/Non-participant Indicator 2 are also outputs)
     C                   PARM                    CustDts
      *
      * ICD
      * Depot 1 (Eurclear)
      * Depot 2 (Cedel)
     C                   PARM                    BVDR1             6
     C                   PARM                    BVDR2             6
      *
      * MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
      *
      * OUTPUTS
      *
      * Trade Settlement Instructions
     C                   PARM                    TranInSett
      *
      ** Charge/Commission defaulting
      *
     C                   CALLB     'SETCHCMDFT'
      *
      * INPUTS
      *
      * Bulk reference
      * Incomplete Ind.
      * Market Centre
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDINCS            1
     C                   PARM                    DDMRKT            2
      *
      * Trade Counterparty
     C                   PARM                    TCNR
      *
      * Security details
     C                   PARM                    SECTY
      *
      * Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      * Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Portfolio Details
     C                   PARM                    PortDts
      *
      * ICD
      * PM installed
      * Bank Portfolios installed
      * Ref applied to 9997 portfolio
      * Autocharge Option
      * Adjust Commission Same Day T
      * Priority of Cust Grp Dft
      * Priority of Invst typ Dft
      * Priority of Market Dft
      * Priority of Cust Chrg Dft
      * Midas/TOF I/F installed
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVACOP            1
     C                   PARM                    BVACSD            1
     C                   PARM                    BVPCSD            1
     C                   PARM                    BVPIDF            1
     C                   PARM                    BVPMDF            1
     C                   PARM                    BVPOCD            1
     C                   PARM                    S01496            1
     C                   PARM                    BGN4ST            1
      *
      * OUTPUTS
      *
      * Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      * Trade Charges & Commissions screen fields
     C                   PARM                    TranInChcm
      *
      * Trade Charges & Commissions file fields
     C                   PARM                    V_TBCC            2
     C                   PARM                    V_TCCC            2
     C                   PARM                    V_TCC1            2
     C                   PARM                    V_TCC2            2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidOth - Validate Trade Other details                     *
      *                                                               *
      *****************************************************************
     C     SRValidOth    BEGSR
      *
     C                   CALLB     'SETRADOVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Trade Primary Details
      * Trade Secondary Details
      * Trade Exchange Rates
      * Trade Settlement Instructions
      * Trade Charge & Commissions
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
     C                   PARM                    TranInChcm
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      * Security Details
      * Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      * Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Portfolio Details
     C                   PARM                    PortDts
      *
      * Nominal Currency Details
      * Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
      * FX Margin Amount
      * Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      * Trade Exchange Rates OK inds
      * Trade Settlement Instructions OK
      * Trade Charge & Commissions OK inds
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltSwfA - Default Trade Extension (SWIFT) 'A' details      *
      *                                                               *
      *****************************************************************
     C     SRDfltSwfA    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      * INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      * Trade Details (screen)
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT                                       222373
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    InvType           3                          222373
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      * OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidSwfA - Validate Trade Extension (SWIFT) 'A' details    *
      *                                                               *
      *****************************************************************
     C     SRValidSwfA   BEGSR
      *
     C                   CALLB     'SETRADEVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      * Trade Primary Details
      * Trade Secondary Details
      * Trade Exchange Rates
      * Trade Settlement Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      * Trade Extension File details
     C                   PARM                    TranInSwfA
      *
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      * Previous inds
     C                   PARM                    ADDGMES
     C                   PARM                    ADDGMEC
     C                   PARM                    ADDCCID
     C                   PARM                    A_T1CONG
      *
      * Processing type
     C                   PARM                    PROT
      *
      * Override errors
     C                   PARM                    OVRErrors
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      *
      * Swift 2001 flag
     C                   PARM                    CSW201
      *                                                                                       216338
      ** Destination of settlement                                                            216338
     C                   PARM                    A_DDROTS                                     216338
      *                                                                                       216338
      ** Process SE1806 flag                                                                  216338
     C                   PARM                    PUYAT                                        216338
                                                                                              216338
     C                   PARM                    TradSwX2A                                    216338
      *
      * OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltSwfB - Default Trade Extension (SWIFT) 'B' details      *
      *                                                               *
      *****************************************************************
     C     SRDfltSwfB    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      * INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      * Trade Details (screen)
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT            2                          222373
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    InvType           3                          222373
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      * OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidSwfB - Validate Trade Extension (SWIFT) 'B' details    *
      *                                                               *
      *****************************************************************
     C     SRValidSwfB   BEGSR
      *
     C                   CALLB     'SETRADEVAL'
      *
      * INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      * Trade Primary Details
      * Trade Secondary Details
      * Trade Exchange Rates
      * Trade Settlement Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      * Trade Extension File details
     C                   PARM                    TranInSwfB
      *
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      * Previous inds
     C                   PARM                    BDDGMES
     C                   PARM                    BDDGMEC
     C                   PARM                    BDDCCID
     C                   PARM                    B_T1CONG
      *
      * Processing type
     C                   PARM                    PROT
      *
      * Override errors
     C                   PARM                    OVRErrors         1
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      *
      * Swift 2001 flag
     C                   PARM                    CSW201
      *                                                                                       216338
      ** Destination of settlement                                                            216338
     C                   PARM                    B_DDROTS                                     216338
      *                                                                                       216338
      ** Process SE1806 flag                                                                  216338
     C                   PARM                    PUYAT             1                          216338
                                                                                              216338
     C                   PARM                    TradSwX2B                                    216338
      *
      * OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1B
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  216338
      *****************************************************************                       216338
      *                                                               *                       216338
      *  SRDfltTrX2A - Set up the default for TRADSDX2 for screen A   *                       216338
      *                                                               *                       216338
      *****************************************************************                       216338
     C     SRDfltTrX2A   BEGSR                                                                216338
                                                                                              216338
     C                   CALLB     'SETSWX2DFT'                                               216338
                                                                                              216338
      ** Screen (A or B)                                                                      216338
                                                                                              216338
     C                   PARM      'A'           Screen                                       216338
                                                                                              216338
      ** Trade Details (screen)                                                               216338
                                                                                              216338
     C                   PARM                    DDTDRF                                       216338
     C                   PARM                    DDTDTP                                       216338
     C                   PARM                    DDCNUM                                       216338
     C                   PARM                    DDSESN                                       216338
     C                   PARM                    DDBRCD                                       216338
     C                   PARM                    DDDELF                                       216338
     C                   PARM                    DDDELT                                       216338
     C                   PARM                    DDBPBK                                       216338
     C                   PARM                    DDSETC                                       216338
     C                   PARM                    DDMRKT                                       216338
                                                                                              216338
      ** OUTPUT PARAMETERS :                                                                  216338
      ** Screen A details                                                                     216338
                                                                                              216338
     C                   PARM                    TradSwX2A                                    216338
                                                                                              216338
      ** Screen B details                                                                     216338
                                                                                              216338
     C                   PARM                    TradSwX2B                                    216338
                                                                                              216338
     C                   ENDSR                                                                216338
      *****************************************************************                       216338
      /EJECT                                                                                  216338
      *****************************************************************                       216338
      *                                                               *                       216338
      *  SRDfltTrX2B - Set up the default for TRADSDX2 for screen B   *                       216338
      *                                                               *                       216338
      *****************************************************************                       216338
     C     SRDfltTrX2B   BEGSR                                                                216338
                                                                                              216338
     C                   CALLB     'SETSWX2DFT'                                               216338
                                                                                              216338
      ** Screen (A or B)                                                                      216338
                                                                                              216338
     C                   PARM      'B'           Screen                                       216338
                                                                                              216338
      ** Trade Details (screen)                                                               216338
                                                                                              216338
     C                   PARM                    DDTDRF                                       216338
     C                   PARM                    DDTDTP                                       216338
     C                   PARM                    DDCNUM                                       216338
     C                   PARM                    DDSESN                                       216338
     C                   PARM                    DDBRCD                                       216338
     C                   PARM                    DDDELF                                       216338
     C                   PARM                    DDDELT                                       216338
     C                   PARM                    DDBPBK                                       216338
     C                   PARM                    DDSETC                                       216338
     C                   PARM                    DDMRKT                                       216338
                                                                                              216338
      ** OUTPUT PARAMETERS :                                                                  216338
      ** Screen A details                                                                     216338
                                                                                              216338
     C                   PARM                    TradSwX2A                                    216338
                                                                                              216338
      ** Screen B details                                                                     216338
                                                                                              216338
     C                   PARM                    TradSwX2B                                    216338
                                                                                              216338
     C                   ENDSR                                                                216338
      *****************************************************************                       216338
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcChCm - Calculate Trade Charges/Commissions              *
      *                                                               *
      *****************************************************************
     C     SRCalcChCm    BEGSR
      *
     C                   CALLB     'SETCHCMCAL'
      *
      * INPUTS
      *
      * Trade reference
      * Security
      * Trade Type
     C                   PARM                    DDTDRF            6
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
      *
      * Trade Counterparty
      * Trade Nominal
      * Trade % price
      * Trade Date
      * Trade Purchased Interest
      * Trade Current Factor
     C                   PARM                    V_TCNR
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_TDDT            5 0
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TCFC           10 9
      *
      * Security & Investment Type details
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      * Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      * Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      * Previous Trade Charges & Commissions
     C                   PARM                    TranInChCm
      *
      * Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
      *
      * ICD
      * Autocharge Option
      * Securities Charges Currency
      * Adjust Commission Same Day T
     C                   PARM                    BVACOP            1
     C                   PARM                    BVCHRC            3
     C                   PARM                    BVACSD            1
     C                   PARM                    S01446            1
      *
      * INPUTS & OUTPUTS
      *
      * Trade Charges & commissions screen fields
     C                   PARM                    TranInChcm
      *
      * Trade details
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_BCMR           13 0
     C                   PARM                    V_CCMR           13 0
     C                   PARM                    V_TXRB           13 0
      *
     C                   ENDSR
      *****************************************************************                       233881
      /EJECT                                                                                  233881
      *****************************************************************                       233881
      *                                                               *                       233881
      * SRCalcEuTx - Calculate EU Tax                                 *                       233881
      *                                                               *                       233881
      *****************************************************************                       233881
     C     SRCalcEuTx    BEGSR                                                                233881
                                                                                              233881
     C                   CALLB     'SEVTRADTAX'                                               233881
                                                                                              233881
      * INPUTS                                                                                233881
                                                                                              233881
      * Response Mode                                                                         233881
     C                   PARM                    RespMode                                     233881
      * Valid Trade Details                                                                   233881
     C                   PARM                    ValidTrad                                    233881
      * Security Details                                                                      233881
     C                   PARM                    SECTY                                        233881
      * Process Flag                                                                          233881
     C                   PARM      'E'           ProcFlag          1                          233881
                                                                                              233881
      * OUTPUTS                                                                               233881
                                                                                              233881
      * EU Tax Screen Format                                                                  233881
      * EU Tax in Nominal Currency File Format                                                233881
      * EU Tax in Settlement Currency File Format                                             233881
     C                   PARM                    DDEUTX                                       233881
     C                   PARM                    EUTX                                         233881
     C                   PARM                    EUTS                                         233881
                                                                                              233881
     C                   ENDSR                                                                233881
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcCVal - Calculate Trade Countervalue                     *
      *                                                               *
      *****************************************************************
     C     SRCalcCVal    BEGSR
      *
      ** Calculate countervalue
      *
     C                   CALLB     'SETCVALCAL'
      *
      * INPUTS
      *
      * Trade details
     C                   PARM                    V_TDTP            2
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_RALL            9 5
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    V_SETC            3
     C                   PARM                    V_TDVD            5 0                        210284
      *
      * Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    SESN             10                          210284
      *
      * Nominal Currency Details
      * Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      *
      * Customer classification
     C                   PARM                    CustClass         1
      *
      * Country of treaty from PF/SECTYD
     C                   PARM                    CRTT
      *
      * Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      * Value date
     C                   PARM                    TDVD
                                                                                              233881
      ** EU Tax                                                                               233881
     C                   PARM                    EUTX                                         233881
      *
      * OUTPUTS
      *
      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format
     C                   PARM                    V_TCSR           15 0
     C                   PARM                    V_TCTR           15 0
     C                   PARM                    WHTX
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkWrite - Routine to control checking of error status and  *
      *              sending of messgaes/writing to the database      *
      *                                                               *
      *****************************************************************
     C     SRChkWrite    BEGSR
      *
     C     Idx           IFEQ      0
      *
      ** If no error and trade reference has been set up properly, set up
      ** additional fields that are needed on the Valid file record
      *
     C                   EXSR      SRSetUpVal
      *
     C     PFBYSL        IFEQ      'Y'
      *
      ** If 1st leg is being processed, store the details first in temporary
      ** data structure, so that when the 2nd leg has error, the file will not be
      ** updated and both legs will go to the invalid file
      *
     C                   MOVEL     ValidTrad     TValdTrad1
     C                   MOVEL     DDTDRF        TV1TDRF
      *
      ** Setup invalid fields for the first leg as well, in case the 2nd leg
      ** is invalid
      *
     C                   MOVEL     W1DETL        I1DETL
     C                   MOVEL     W2DETL        I2DETL                                       CAS006
     C                   EXSR      SRSetUpInv
     C                   MOVEL     TInValTrd     TInValTrd1
      *
      ** After storing, delete the transaction from the work file
      *
     C                   DELETE    SEWBYSLD0
     C                   ENDIF
      *
     C     PFBYSL        IFEQ      'N'
      *
      ** If 2nd leg is being processed, store the details in another temporary
      *
     C                   MOVEL     ValidTrad     TValdTrad2
      *
      ** Delete the 2nd leg from the work file as well
      *
     C                   DELETE    SEWBYSLD0
     C                   MOVEL     DDTDRF        TV2TDRF
      *
      ** Retrieve the stored 1st leg details to update the file
      *
     C                   MOVEL     TValdTrad1    ValidTrad
     C                   MOVEL     TV1TDRF       DDTDRF
     C                   MOVEL     *BLANKS       WKTDRF            6
      *
      ** Call subroutine that sets up the trade reference for 1st leg
      ** Input field DDTDRF, output field WATDRF
      *
     C                   EXSR      SRSetUpTdRf
      *
      ** Move the trade refence to the trade reference field of the 1st leg
      ** and also to the link reference field of the 2nd leg
      *
     C                   MOVEL     WATDRF        WKTDRF
     C                   MOVEL     WATDRF        TV1TDRF
     C                   MOVEL     WATDRF        TX1T1TDRF
     C                   MOVEL     WATDRF        V_TDRF
     C                   MOVEL     WATDRF        TV2LKRF
      *
     C     TX1T1WHEN     IFEQ      'B'
     C                   MOVEL     WATDRF        TX2T1TDRF
     C                   ENDIF
      *
     C                   MOVEL     TV2TDRF       DDTDRF
      *
      ** Call subroutine that sets up the trade reference for 2nd leg
      ** Input field DDTDRF, output field WATDRF
      *
     C                   EXSR      SRSetUpTdRf
      *
      ** Move the trade refence to the trade reference field of the 2nd leg
      ** and also to the link reference field of the 1st leg
      *
     C                   MOVEL     WATDRF        TV2TDRF
     C                   MOVEL     WATDRF        TX2T1TDRF
     C                   MOVEL     WATDRF        V_LKRF
      *
      ** Write the 1st leg to the valid file
      *
     C                   WRITE     SEVBYSLD0
      *
      ** Retrieve the stored 2nd leg details to update the file
      *
     C                   MOVEL     TValdTrad2    ValidTrad
      *
      ** Write the 2nd leg to the valid file
      *
     C                   WRITE     SEVBYSLD0
     C                   ENDIF
      *
      ** If S01401 is 'Y', update the extension file
      *
     C     S01401        IFEQ      'Y'
      *
      ** Store the 1st leg detail to data structure that will be used for update
      *
     C                   MOVE      ValidTX1A     ValidTrX1
     C                   EVAL      V_T1TDRF = V_TDRF
     C                   EVAL      V_T1FRNT = APFOTranID
     C                   EVAL      V_T1AFRT = APFOAsocID
     C                   EVAL      V_T1TMES = TimeStamp
      *
     C     PFBYSL        IFEQ      'Y'
      *
      ** If 1st leg is being processed, store details in temporary data structure
      *
     C                   MOVEL     ValidTrX1     TValdTrX1
     C                   ENDIF
      *
     C     PFBYSL        IFEQ      'N'
      *
      ** If 2nd leg is being processed, store details in another temporary data
      ** structure, retrieve the 1st leg details A then write to file
      *
     C                   MOVEL     ValidTrX1     TValdTrX3
     C                   MOVEL     TValdTrX1     ValidTrX1
     C                   WRITE     SEVTRX1PD0
      *
     C     WKSWFB        IFEQ      'Y'
      *
      ** If Swift B details is available in the 1st leg, retrieve the 1st leg
      ** details B, then write to file
      *
     C                   MOVEL     TValdTrX2     ValidTrX1
     C                   WRITE     SEVTRX1PD0
     C                   ENDIF
      *
      ** Retrieve 2nd leg detail A, then write to file
      *
     C                   MOVEL     TValdTrX3     ValidTrX1
     C                   WRITE     SEVTRX1PD0
     C                   ENDIF
      *
     C                   MOVE      ValidTX1B     ValidTrX1
     C                   EVAL      V_T1TDRF = V_TDRF
     C                   EVAL      V_T1FRNT = APFOTranID
     C                   EVAL      V_T1AFRT = APFOAsocID
     C                   EVAL      V_T1TMES = TimeStamp
      *
     C     V_T1WHEN      IFEQ      'B'
      *
     C     PFBYSL        IFEQ      'Y'
     C                   MOVE      'Y'           WKSWFB            1
     C                   MOVEL     ValidTrX1     TValdTrX2
     C                   ENDIF
      *
     C     PFBYSL        IFEQ      'N'
     C                   WRITE     SEVTRX1PD0
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           WKSWFB
     C                   ENDIF
      *
     C                   ENDIF
     C                   EXSR      CallMsgHdl
     C                   ENDIF
      *
      ** Error is encountered
      *
     C     Idx           IFGT      0
     C                   MOVEL     W1DETL        I1DETL
     C                   MOVEL     W2DETL        I2DETL                                       CAS006
      *
      ** Call subroutine that sets up additional information needed in the
      ** invalid file
      *
     C                   EXSR      SRSetUpInv
      *
      ** Only write to invalid files if repair in back office
      *
     C     APRprLocn     IFEQ      'B'
      *
     C     PFBYSL        IFEQ      'Y'
      *
      ** 1st leg is being processed, write to invalid file immediately then
      ** delete transaction from the work file
      *
     C                   WRITE     SEIBYSLD0
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed and Support System is                        CSC011
      ** active                                                                               CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   MOVEL     'SEBYS1'      WTRTP                                        CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = WTRTP + TranInPrim +                            CSC011
     C                                        TranInSeco + TranInExch +                       CSC011
     C                                        TranInSett + TranInChCm +                       CSC011
     C                                        TranInSwfA + TranInSwfB +                       CSC011
     C**********                              InfData + ExtData                        CSC011 CAS006
     C                                        TranInThir + InfData + ExtData                  CAS006
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SEBYSL'                                       CSC011
     C                   EVAL      PDealNum = DDTDRF                                          CSC011
                                                                                              CSC011
      ** Write log file                                                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       ReturnCode                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        ReturnCode <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY  = PDealNum                                          CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE  = 2                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   DELETE    SEWBYSLD0
      *
     C                   EXSR      CallMsgHdl
      *
      ** Chain work file to look for the related trade by using the associated
      ** Transaction Id
      *
     C     APFOAsocID    CHAIN     SEWBYSLL0                          99
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWrkToCur
     C                   MOVEL     W1DETL        I1DETL
     C                   MOVEL     W2DETL        I2DETL                                       CAS006
     C                   EXSR      SRSetUpInv
     C                   WRITE     SEIBYSLD0
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed and Support System is                        CSC011
      ** active                                                                               CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   MOVEL     'SEBYS2'      WTRTP                                        CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = WTRTP + TranInPrim +                            CSC011
     C                                        TranInSeco + TranInExch +                       CSC011
     C                                        TranInSett + TranInChCm +                       CSC011
     C                                        TranInSwfA + TranInSwfB +                       CSC011
     C**********                              InfData + ExtData                        CSC011 CAS006
     C                                        TranInThir + InfData + ExtData                  CAS006
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SEBYSL'                                       CSC011
     C                   EVAL      PDealNum = DDTDRF                                          CSC011
                                                                                              CSC011
      ** Write log file                                                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       ReturnCode                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        ReturnCode <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY  = PDealNum                                          CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE  = 3                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   DELETE    SEWBYSLD0
     C                   ENDIF
     C                   MOVE      ' '           PFBYSL
     C                   ENDIF
      *
     C     PFBYSL        IFEQ      'N'
     C                   MOVEL     TInValTrd     TInValTrd2
     C                   MOVEL     TInValTrd1    TInValTrd
     C                   WRITE     SEIBYSLD0
     C                   MOVEL     TInValTrd2    TInValTrd
     C                   WRITE     SEIBYSLD0
     C                   DELETE    SEWBYSLD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRResetCyc - Reset error information that is gradually        *
      *              updated during each run of this program          *
      *                                                               *
      *****************************************************************
     C     SRResetCyc    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
      *
     C                   RESET                   FldNoArr
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVE      *ALL'Y'       OKTrSwft
      *
     C                   CLEAR                   ValidTrad
     C                   CLEAR                   ValidTX1A
     C                   CLEAR                   ValidTX1B
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpInv - Set up additional fields that are needed on the  *
      *              Invalid file record.                             *
      *                                                               *
      *****************************************************************
     C     SRSetUpInv    BEGSR
      *
      ** Include Header fields that need to be o/p to the Invalid files
      *
     C                   EVAL      IN_DDTRTP = DDTRTP
     C                   EVAL      IN_DDFOtranID = APFOTranID
     C                   EVAL      IN_DDFOAsocID = APFOAsocID
     C                   EVAL      IN_DDRprLocn  = APRprLocn
     C                   EVAL      IN_DDTMESTMP = TimeStamp
      *
      ** Setup the Automatic Autorisation Flag
      *
     C                   IF        CAP051 = 'Y'
     C                   EVAL      IN_DDAUTHA    = AUTHA
     C                   ENDIF
      *
     C                   EVAL      TranStatus = 'F'
      *
      /COPY WNCPYSRC,SEBYSLC015
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpWHd - Set up additional fields that are needed on the  *
      *              Work File record.                                *
      *                                                               *
      *****************************************************************
     C     SRSetUpWHd    BEGSR
      *
      ** Include Header fields that need to be o/p to the Invalid files
      *
     C                   EVAL      W1_DDFOtranID = APFOTranID
     C                   EVAL      W1_DDFOAsocID = APFOAsocID
     C                   EVAL      W1_DDRprLocn  = APRprLocn
     C                   EVAL      W1_DDTMESTMP = TimeStamp
      *
      ** Setup the Automatic Autorisation Flag
      *
     C                   IF        CAP051 = 'Y'
     C                   EVAL      W1_DDAUTHA    = AUTHA
     C                   ENDIF
 
     C                   EVAL      TranStatus = 'F'
      *
      /COPY WNCPYSRC,SEBYSLC016
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpTdRf - Set up Trade Reference for Inserts              *
      *                                                               *
      *****************************************************************
     C     SRSetUpTdRf   BEGSR
      *
     C                   IF        DDTDRF = *blanks
     C                             OR DDTDRF = *zeros
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    DDTDRF
     C                   PARM      *ZERO         WRTDRF            6 0
      *
     C     ReturnCode    IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'ZATRNRTV'
     C                   ENDIF
      *
      ** Check if trade reference generated is already in the valids file
      *
     C     DDTDRF        SETLL     SEVBYSLCK1                             01
     C                   MOVEL     DDTDRF        PTDRF
      *
     C                   DOW       *IN01
     C                   ADD       1             PTDRF             6 0
     C                   MOVEL     PTDRF         DDTDRF
     C     DDTDRF        SETLL     SEVBYSLCK1                             01
     C                   ENDDO
      *
      ** If trade reference was entered, put it in the file field
      *
     C                   ELSE
     C                   MOVEL     DDTDRF        WRTDRF
     C                   MOVEL     DDTDRF        WATDRF            6
     C                   ENDIF
      *
     C     DDTDRF        IFNE      *BLANKS
     C                   MOVEL     DDTDRF        WRTDRF
     C                   MOVEL     DDTDRF        WATDRF
     C                   ENDIF
      *
      ** Check if first leg is the same as second leg, if yes, generate
      ** a new one for the second leg.
      *
     C     DDTDRF        IFEQ      WKTDRF
     C     WKTDRF        OREQ      *BLANKS
     C     DDTDRF        ANDEQ     TV2TDRF
      *
     C                   MOVEL     DDTDRF        PTDRF
     C                   DOU       NOT(*IN01)
     C                   ADD       1             PTDRF             6 0
     C                   MOVEL     PTDRF         DDTDRF
     C                   MOVEL     PTDRF         WRTDRF
     C                   MOVEL     WRTDRF        WATDRF
     C     DDTDRF        SETLL     TRADSDF                                01
      *
     C                   IF        NOT(*IN01)
     C     DDTDRF        SETLL     HSTTRDF                                01
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetUpVal - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      *****************************************************************
     C     SRSetUpVal    BEGSR
      *
      ** Set Valid file field(s) that are needed for all Action Codes
      *
     C                   EVAL      V_CHTP = DDACTN
      *
      ** Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      V_FRNT = APFOTranID
     C                   EVAL      V_AFRT = APFOAsocID
     C                   EVAL      V_REPA = APRprLocn
     C                   EVAL      V_TMST = TimeStamp
      *
      ** Automatic Authorisation flag
      *
     C                   IF        CAP051 = 'Y'
     C                   EVAL      V_AUTH = AUTHA
     C                   ENDIF
      *
     C                   EVAL      TranStatus = 'S'
      *
      /COPY WNCPYSRC,SEBYSLC017
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
      *
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
      *
     C     FldNameArr(Ix)IFNE      *BLANKS
      *
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             Ix
     C                   ENDDO
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      * Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      *
      * Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      *
      * Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      *
      * List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      *
      * List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      *
      * List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      *
      * List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      * Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      *
      * Midas module ID (2A)
     C                   Parm                    ModuleID
      *
      * Midas transaction ID (6A, from caller)
     C                   PARM      DDTDRF        WDDTDRF          20
      *
      * Message file (10A, from caller)
     C                   PARM                    #MsgFile
      *
      * Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      * Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      *
      * Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      *
      * The following three parameters are needed when messages are to
      * be displayed on a screen
      * Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      *
      * Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      *
      * Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      *
      * The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      *
      * The transaction's timestamp
     C                   PARM                    TimeStamp
      *
      * Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      *
      * Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      *
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C                   PARM                    Trans5008                                    CAS006
     C                   PARM                    InfData500
     C                   PARM                    ExtData500
      *
      ** Ultimate calling Program/Module/Procedure
      *
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
      *
     C                   EVAL      #MsgFile = 'DRSMM'
      *
      ** Set up the name of the primary and secomdary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'SE'
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access Securities Trading details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   ENDIF
      *
      ** Access SAR details file to determine if Customer Commissions
      ** (courtage) enhancement is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01446'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01446            1
     C                   ELSE
     C                   MOVEL     'N'           S01446
     C                   ENDIF
      *
      ** Access SAR details file to determine if Private Banking
      ** securities enhancements is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   ENDIF
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement phase 2 is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   ENDIF
      *
      ** Access SAR details file to determine if TOF/Midas
      ** Interface is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   ENDIF
      *
      ** Access SAR details file to determine if EMU SE
      ** Settlement Currency Conversion is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   ENDIF
      *
      ** Access SAR details file to determine if
      ** Automatic Authorisation (SE Part) is installed
      *
     C                   MOVEL     'N'           CAP051            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051
     C                   ENDIF
      *
      ** Check if CSW201 - Swift 2001 Standards Update is installed
      *
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       @RTCD
 
     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
      *
      ** Check if CSE028 feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE028'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE028            1
     C                   ELSE
     C                   MOVEL     'N'           CSE028
     C                   ENDIF
                                                                                              CSC011
      ** Determine if CSC011 enhancement is installed                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 1                                                 CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '901'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APBYSLDTQ'
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEBYSLC018
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
