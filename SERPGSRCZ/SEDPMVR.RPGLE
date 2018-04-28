     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Depot walkin/walkout retrieve')               *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEDPMVR - SE Depot WalkIn/WalkOut retrieve a record          *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244007             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10026           Date 30Jan06               *
      *                 CAP087             Date 07Sep05               *
      *                 BUG9089            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 237063             Date 20Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG2392            Date 15Jun04               *
      *                 CGP003             Date 01Jun04               *
      *                 BUG1569            Date 17Mar04               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 07Nov03               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  244007 - Recompile due to changes in SEDMAXPD.               *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10026 - (DPWI Input) Narrative field in transction        *
      *             confirmation is incorrect.                        *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           Recompile due to changes in file SEDMWIPD           *
      *           and SEEDMWIPD. Also due to code changes in          *
      *           SEDPMVRTV.                                          *
      *  BUG9089- Mapping error with Java for DPMV                    *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG2392- Correct defaulting errors                           *
      *  CGP003 - Add calculation of consideration for authorisation  *
      *           limit checking.                                     *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FINVTP     IF   E           K DISK
     FSECTY     IF   E           K DISK    PREFIX(SEC)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                       CAP087
     F                                     INFDS(INFDS)                                       CAP087
     F                                     IGNORE(MMDENSP0)                                   CAP087
     F                                     IGNORE(MMDENBP0)                                   CAP087
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
 
      ** Current transaction in screen format
     D CurTrDPMV     E DS                  EXTNAME(SEDMWIPD)
 
      ** Transaction in file format
     D DPMVFilFmt    E DS                  EXTNAME(DPTMVD)
      *                                                                                       CER001
      ** DPMV Extension File Format                                                           CER001
     D DPMVLUXFilFmt E DS                  EXTNAME(SEDPX1PD)                                  CER001
 
      ** Transaction DPTMVDX1 in file format
     D SEDMX1        E DS                  EXTNAME(DPTMVDX1)
 
      ** Transaction in file format
     D SEDMX2        E DS                  EXTNAME(DPTMVDX2)
 
      ** Other data in file format                                                           BUG9089
     D DPMVOth       E DS                  EXTNAME(SEDMAXPD)                                 BUG9089
                                                                                             BUG9089
      ** Extra data in file format
     D ExtData       E DS                  EXTNAME(SEDMEXPD)
      *                                                                                       CER001
      ** Extra data in file format (Regional)                                                 CER001
     D RegData       E DS                  EXTNAME(SEDMRXPD)                                  CER001
 
      ** The following /COPY includes the customer details data structure                    BUG2392
     D/COPY SECPYSRC,SE_CUSTDT                                                               BUG2392
      ** The following /COPY includes the currency details data structures                   BUG2392
     D/COPY SECPYSRC,SE_CCYDT                                                                BUG2392
                                                                                              CAP087
     D SECTYX        E DS                  EXTNAME(SECTYD)                                    CAP087
     D                                     PREFIX(SEC)                                        CAP087
      ** External DS for bank details                                                         CAP087
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CAP087
                                                                                             BUG2392
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG2392
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                    BUG2392
                                                                                             BUG2392
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 BUG2392
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                    BUG2392
                                                                                             BUG2392
     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                 BUG2392
      ** External DS for Security Customer details                                           BUG2392
                                                                                             BUG2392
      ** DS for Access Objects - long data structure                                         BUG2392
     D DSSDY         E DS                  EXTNAME(DSSDY)                                    BUG2392
                                                                                             BUG2392
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Error indicators
     D OKTrDPMV      E DS                  EXTNAME(SEEDMWIPD)
                                                                                              CAP087
     D INFDS           DS                                                                     CAP087
      **  Data structure for file status of MM deals file.                                    CAP087
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0 INZ(*ZERO)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(*ZERO)
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
      ** Country of treaty (Not use for Depot Movement)                                      BUG2392
     D PDRBW           S              2A                                                     BUG2392
      *                                                                                      BUG2392
      ** Withholding tax (Not use for Depot Movement)                                        BUG2392
     D DDWTAX          S             15A                                                     BUG2392
                                                                                             BUG2392
      ** Entry parameters
     D Buffer          S           6000A
     D DDPMVTyp        S              2A
     D DDDPRN_In       S              6A
     D DDDPSS_In       S             10A                                                      CAP087
     D FwdBck          S              1A
     D AuthComp        S              1A
     D APIRetc         S              1A
 
      ** Response Mode, passed as a constant parameter to the RTV module
      ** This is always 'S' for Synchronous
     D APRespMode      S              1A   INZ(' ')
 
      ** Switchable features
     D CSW201          S              1A
     D CSW003          S              1A
     D CSE028          S              1A
     D S01401          S              1A
     D CGL031          S              1A                                                      CGL031
     D ULX602          S              1A                                                      CER001
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
 
      ** Work variables
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PErrMs          S              7A   INZ(*BLANKS)
     D PPPSSSel        S             10A   INZ(*BLANKS)
     D PPPRNSel        S              6A   INZ(*BLANKS)
     D PPDPBSel        S              3A   INZ(*BLANKS)
     D PPORBSel        S              3A   INZ(*BLANKS)
     D CallProg        S             10A   INZ('       ')
     D Ex              S              3P 0 INZ(*ZERO)
     D ModeofOp        S              6A
     D FOTrId          S             20A
     D*DDSPXR***       S             14A                                                     BUG9089
     D*DDSPMD***       S              1A                                                     BUG9089
     D*DDSecSts*       S              7A                                                     BUG9089
     D*DDTranSts       S              7A                                                     BUG9089
     D*DDTCTR***       S             21A                                              CGP003 BUG9089
     D PortCusInd      S              1A
     D PBFieldInd      S              1A
     D PEUTX           S             13P 0                                                    237063
     D*SECNMCY******** S              3A                                                     BUG2392
      ** Work fields for Interest Calculation                                                 CAP087
     D DateFmtInd      S                   LIKE(BJDFIN)                                       CAP087
     D DateFormat      S                   LIKE(BJDFIN)                                       CAP087
     D DADJN           S              1A                                                      CAP087
      ** Day adjustment                                                                       CAP087
     D  ZDADJ          S              3P 0                                                    CAP087
      ** Accrued indicator                                                                    CAP087
     D  ZACIN          S              1A                                                      CAP087
      ** Actual Difference indicator                                                          CAP087
     D  ZADIN          S              1A                                                      CAP087
      ** Coupon rate (trade)                                                                  CAP087
     D  ZADEC          S              1P 0                                                    CAP087
      ** Output of ZSEDIT                                                                     CAP087
     D   ZFLD15        S             15  0                                                    CAP087
      ** Output of ZPCINT                                                                     CAP087
     D   ZITRA         S             13  0                                                    CAP087
     D   ZTINA         S             13  0                                                    CAP087
      ** Coupon rate (trade)                                                                  CAP087
     D TDCR            S             11P 7                                                    CAP087
      ** Overide Indicator                                                                    CAP087
     D  ZCPOVR         S              1A                                                      CAP087
      ** Nominal                                                                              CAP087
     D NOML            S             11P 0 INZ(0)                                             CAP087
      ** Error arrays                                                                         CAP087
     D XArrayMax       C                   CONST(40)                                          CAP087
     D FldNamXAr       S             10A   DIM(XArrayMax)                                     CAP087
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)                        CAP087
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CAP087
                                                                                              CAP087
      ***** Data used by SEDPMVR ******                                                       CAP087
      ** Array of Fields in error.                                                            CAP087
     D @FldNameArr     S             10A   DIM(ArrayMax)                                      CAP087
                                                                                              CAP087
      ** Array of error message IDs                                                           CAP087
     D @MsgIDArr       S                   DIM(ArrayMax)                                      CAP087
     D                                     LIKE(#MsgID)                                       CAP087
                                                                                              CAP087
      ** Array of error message data.                                                         CAP087
     D @MsgDtaArr      S                   DIM(ArrayMax)                                      CAP087
     D                                     LIKE(#MsgData)                                     CAP087
                                                                                              CAP087
      ** Array of message files to check                                                      CAP087
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                    CAP087
                                                                                              CAP087
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   CLEAR                   DPMVFilFmt
 
      ** If the action code is blank, set to enquire
 
     C                   IF        DDACTN = *BLANK
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      FwdBck = 'F'
     C                   MOVEL     'Y'           PRdFwd
     C                   MOVEL     'N'           PRdBck
 
     C                   WHEN      FwdBck = 'B'
     C                   MOVEL     'N'           PRdFwd
     C                   MOVEL     'Y'           PRdBck
 
     C                   OTHER
     C                   MOVEL     'N'           PRdFwd
     C                   MOVEL     'N'           PRdBck
     C                   ENDSL
 
      ** Read depot movement record
 
     C                   IF        PRdFwd = 'Y' OR
     C                             PRdBck = 'Y'
     C                   EXSR      ReadDPMV
     C                   ELSE
     C                   MOVEL     DDDPRN_In     PPPRNSel
     C                   MOVE      *BLANKS       PPPSSSel
     C                   MOVE      *BLANKS       PPDPBSel
     C                   MOVE      *BLANKS       PPORBSel
     C                   ENDIF
 
      ** Display error message if problems found when reading the
      ** incoming payment
 
     C                   IF        PErrMs <> *BLANKS
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      SRSndM
     C                   ENDIF
 
      ** Otherwise, if no error message returned,then retrieve
      ** and convert record from file to screen format
 
     C                   IF        PErrMs = *BLANKS AND
     C                             PPPRNSel <> *BLANKS AND
     C                             DDPMVTyp <> *BLANKS
 
     C                   EXSR      RetrieveDPMV
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EXSR      SEDPMV2RV                                                  CER001
     C                   ENDIF                                                                CER001
 
     C                   IF        Idx = 0
     C                   EXSR      ConvertDPMV
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   EXSR      SEDPMV2CT                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF
 
     C                   ENDIF
 
      ** Workout destination address for settlement to be display on screen
      ** only
 
     C     DPMV          IFEQ      'WI'
     C                   MOVE      DPID          WSNDR
     C                   MOVE      DPID          WDEST
     C                   ELSE
     C                   MOVE      DPOD          WSNDR
     C                   MOVE      DPOD          WDEST
     C                   END
     C                   MOVE      '08'          WSETP
     C                   EXSR      SR1100
 
     C                   MOVE      WWROU         DSROUC
     C                   MOVE      WWROT         DSROTC
 
      ** Build buffer with required output
 
     C                   EXSR      CalcTrCVAL                                                BUG2392
     C                   EXSR      CalcPurchInt                                               CAP087
     C                   MOVE      DMTMST        @TimeStamp       26                         BUG1569
     C                   EVAL      DDNMCY = SECNMCY                                          BUG9089
     C                   EVAL      Buffer = CurTrDPMV + DDPMVTyp
     C*************                         + ExtData                                        BUG1569
     C**********                            + @TimeStamp + ExtData                    BUG1569 CER001
     C**********                            + DDTranSts + DDSecSts                           BUG9089
     C**********                            + DDSPXR + DDSPMD                                BUG9089
     C**********                            + DDTCTR + SECNMCY                       CGP003  BUG9089
     C**********                            + PROT                                   BUG2392 BUG9089
     C**********                            + @TimeStamp                             CER001  BUG9089
     C                                      + @TimeStamp + DPMVOth                           BUG9089
     C**********                            + DDVDIN + DDMDIN                        CAP087 BUG10026
     C                                      + RegData + ExtData                               CER001
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
 
     C     SRSndM        BEGSR
 
      ** If single-branching, user does not have the authority to
      ** Browse.
 
     C     PErrMs        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   ENDIF
 
      ** Invalid Transaction Reference.
 
     C     PErrMs        IFEQ      'MMA0425'
     C                   MOVE      'N'           DDDPRNOK
     C                   ENDIF
 
      ** Add error message to array passed to screen.
 
     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     PErrMs        MsgIdArr(Ex)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ReadDPMV - Read previous or next record in Depot Movement    *
      *             file                                              *
      *                                                               *
      *****************************************************************
 
     C     ReadDPMV      BEGSR
 
     C                   CALLB     'SEDPMVRED'
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Received Parameters
      ** -------------------
      *
      ** Action Code
      ** Depot Movement Type
      ** Reference Number (Pointer)
      ** Security (Pointer)
     C                   PARM                    DDACTN
     C                   PARM                    DDPMVTyp
     C                   PARM                    CallProg         10                          222373
     C                   PARM                    PPPRNSel
     C                   PARM                    PPPSSSel
 
      ** Read Forward Ind
      ** Read Backward Ind
     C                   PARM                    PRdFwd
     C                   PARM                    PRdBck
 
      ** Returned Parameters
      ** -------------------
      *
      ** Error Message
     C                   PARM      *BLANK        PErrMs
 
      ** Reference Number Read
      ** Security Read
     C                   PARM      *BLANK        PPPRNSel                                 @DLRED
     C                   PARM      *BLANK        PPPSSSel                                 @FTRED
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RetrieveDPMV - Retrieve depot movement transaction in        *
      *                 file format                                   *
      *                                                               *
      *****************************************************************
 
     C     RetrieveDPMV  BEGSR
 
     C                   MOVE      'S'           APRespMode
     C                   CALLB     'SEDPMVRTV'
 
     ** Screen Fields
      * Action Code (1A)
      * Depot Movement Reference Number (6A)
      * Booking Branch  (3A)
      * Originating Branch  (3A)
 
     C                   PARM                    DDACTN
     C                   PARM                    PPPRNSel
     C                   PARM                    PPDPBSel
     C                   PARM                    PPORBSel
 
     ** Operation Details
      * Mode of Operation (6A)
      * Response Mode (1A)
      * Front Office ID No. (20A)
      * Depot Movement Type. (2A)
 
     C                   PARM      *BLANKS       ModeofOp
     C                   PARM                    APRespMode
     C                   PARM      *BLANKS       FOTrId
     C                   PARM                    DDPMVTyp
     C                   PARM                    CallProg
     C                   PARM                    DDDPSS_In                                    CAP087
 
      ** Returned Parameters
      ** -------------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Error Index (3P 0)
 
     C                   PARM                    Idx
 
      ** Depot movement transaction file Output
 
     C                   PARM                    DPMVFilFmt
 
     ** Ok Indicators
      * Action Code Ok Indicator (1A)
      * Transaction ID number Ok Indicator (1A)
      * Booking Branch Ok indicator (1A)
      * Originating Branch Ok indicator (1A)
 
     C                   PARM                    DDACTNOK
     C                   PARM                    DDDPRNOK
     C                   PARM                    DDDPBAOK
     C                   PARM                    DDORBROK
      *
      ** Clear all the data structures for extended settlement
      *
     C                   CLEAR                   SEDMX1
     C                   CLEAR                   SEDMX2
      *
      ** Retrieve the eventual current database records
      *
     C                   IF        S01401 = 'Y'
 
     C                   CALLB     'SEDMESRTV'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Movement references
     C                   PARM                    DPSS
     C                   PARM                    DPRN
      ** Features
     C                   PARM                    CSE028
     C                   PARM                    CSW003
      *
      ** OUTPUT PARAMETERS
      ** Extension and Extended Settlement details
     C                   PARM                    SEDMX1
     C                   PARM                    SEDMX2
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertDPMV - Convert Depot movement details from file to    *
      *                screen format                                  *
      *                                                               *
      *****************************************************************
 
     C     ConvertDPMV   BEGSR
 
     C                   CALLB     'SEDPMVCVT'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
 
      ** (Current) Depot movement in file format
     C                   PARM                    DPMVFilFmt
 
      ** Output Parameters
      ** =================
 
      ** (Current) Depot movement in screen format
     C                   PARM                    CurTrDPMV
 
      ** Fx Rate
      ** Mul/Div Indicator
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
      ** Security Status
      ** Transaction status
     C**********         PARM                    DDSecSts                                    BUG9089
     C**********         PARM                    DDTranSts                                   BUG9089
     C                   PARM                    DDSSTS                                      BUG9089
     C                   PARM                    DDTSTS                                      BUG9089
     C                   PARM                    PortCusInd
     C                   PARM                    PBFieldInd
     C                   PARM                    CGL031                                       CGL031
      *
      ** Convert X1 and X2 record into screen field if S01401 is present
      *
     C                   IF        S01401 = 'Y'
 
     C                   CALLB     'SEDMESCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Extension and Extended Settlements Details
     C                   PARM                    SEDMX1
     C                   PARM                    SEDMX2
      ** Features status
     C                   PARM                    CSE028
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
      *
      ** INPUT/OUTPUT PARAMETERS
      ** New fields in screen format (whole API message)
      ** Only the sub-field NewScnFld will be updated
     C                   PARM                    CurTrDPMV
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR1100 - Determine Network and Addresses.                    *
      *                                                               *
      *****************************************************************
     C     SR1100        BEGSR
      *
     C                   CALL      'ZM1100'                             99
     C                   PARM                    WSNDR             6
     C                   PARM                    WSCSD            12
     C                   PARM                    WDEST             6
     C                   PARM                    WSETP             2
     C                   PARM      *BLANKS       WNWSN            20
     C                   PARM      *BLANKS       WNWDS            22
     C                   PARM      *BLANKS       WNWRK             6
     C                   PARM      *BLANKS       WERRC             1
     C                   PARM      *BLANKS       WSRNM            20
     C                   PARM      *BLANKS       WSRTN            10
     C                   PARM      *BLANKS       WDRNM            20
     C                   PARM      *BLANKS       WDRTN            10
      *
     C     WSNDR         IFNE      *BLANKS
     C     WDEST         ANDNE     *BLANKS
      *
     C     *IN99         IFEQ      '1'
     C     WERRC         OREQ      'S'
     C     WERRC         OREQ      'D'
     C     WNWRK         OREQ      'UNROUT'
      *
     C                   MOVEL     *BLANKS       WWROU             6
     C                   MOVEL     '  UNRO'      WWROT            12
     C                   MOVE      'UTABLE'      WWROT
     C                   ELSE
      *
     C                   MOVEL     WNWRK         WWROU
     C                   MOVEA     WNWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     WNWDS         WWROT
     C                   ELSE
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WWROT
     C                   END
     C                   END
 
     C                   ELSE
 
     C                   MOVEL     *BLANKS       WWROU
     C                   MOVEL     *BLANKS       WWROT
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************                      BUG2392
      /EJECT                                                                                 BUG2392
      *****************************************************************                      BUG2392
      *                                                               *                      BUG2392
      * CalcTrCVAL - Calculate Countervalue                           *                      BUG2392
      *                                                               *                      BUG2392
      *****************************************************************                      BUG2392
     C     CalcTrCVAL    BEGSR                                                               BUG2392
                                                                                             BUG2392
      ** INITIALISE UN-USED FIELDS                                                           BUG2392
     C                   EVAL      V_RALL = 0                                                BUG2392
     C                   EVAL      V_ITRA = 0                                                BUG2392
     C                   EVAL      V_TBCA = 0                                                BUG2392
     C                   EVAL      V_TCCA = 0                                                BUG2392
     C                   EVAL      V_TCA1 = 0                                                BUG2392
     C                   EVAL      V_TCA2 = 0                                                BUG2392
     C                   EVAL      V_TCA3 = 0                                                BUG2392
     C                   EVAL      V_TCA4 = 0                                                BUG2392
     C                   EVAL      V_TCA5 = 0                                                BUG2392
     C                   EVAL      V_TCA6 = 0                                                BUG2392
     C                   EVAL      V_TCA7 = 0                                                BUG2392
     C                   EVAL      V_TAXA = 0                                                BUG2392
     C                   EVAL      V_TDER = 1                                                BUG2392
     C                   EVAL      V_TMDI = 'M'                                              BUG2392
     C                   EVAL      V_TDTP = 'TP'                                             BUG2392
     C                   IF        DPMV = 'WI'                                               BUG2392
     C                             OR DPMV = 'RR'                                             CAP087
     C                             OR DPMV = 'BB'                                             CAP087
     C                             OR DPMV = 'PL'                                             CAP087
     C                             OR DPMV = 'DT'                                             CAP087
     C                   EVAL      V_TDVD = DPMD                                             BUG2392
     C                   ELSE                                                                BUG2392
     C                   EVAL      V_TDVD = DPDO                                             BUG2392
     C                   ENDIF                                                               BUG2392
      * Access Securities Details                                                            BUG2392
                                                                                             BUG2392
     C     DPSS          CHAIN     SECTYDF                            99                     BUG2392
      *                                                                                      BUG2392
      * DATABASE ERROR                                                                       BUG2392
      *                                                                                      BUG2392
     C     *IN99         IFEQ      '1'                                                       BUG2392
     C                   MOVE      *BLANK        DBKEY                                       BUG2392
     C                   MOVE      DPSS          DBKEY                                       BUG2392
     C                   MOVEL     'SECTYD'      DBFILE                                      BUG2392
     C                   MOVEL     '001'         DBASE                                       BUG2392
     C                   EXSR      *PSSR                                                     BUG2392
     C                   END                                                                 BUG2392
                                                                                             BUG2392
      * Access Investment Type details                                                       BUG2392
                                                                                             BUG2392
     C     KLINVT        CHAIN     INVTPDF                            99                     BUG2392
      *                                                                                      BUG2392
      * DATABASE ERROR                                                                       BUG2392
      *                                                                                      BUG2392
     C     *IN99         IFEQ      '1'                                                       BUG2392
     C                   MOVEL     SECNMCY       DBKEY                                       BUG2392
     C                   MOVE      SECSITP       DBKEY                                       BUG2392
     C                   MOVEL     'INVTPD'      DBFILE                                      BUG2392
     C                   MOVEL     '002'         DBASE                                       BUG2392
     C                   EXSR      *PSSR                                                     BUG2392
     C                   END                                                                 BUG2392
                                                                                             BUG2392
      * Get nominal currency details                                                         BUG2392
                                                                                             BUG2392
     C                   MOVE      SECNMCY       @AJCD                                       BUG2392
     C                   EXSR      ACSCURR                                                   BUG2392
                                                                                             BUG2392
     C                   MOVEL     A6SPRT        NomCcySPRT                                  BUG2392
     C                   Z-ADD     A6NBDP        NomCcyDec                                   BUG2392
     C                   MOVEL     A6MDIN        NomCcyMDIN                                  BUG2392
     C                   MOVEL     A6NQDP        NomCcyNQDP                                  BUG2392
     C                   MOVEL     A6SWCY        NomCcySWCY                                  BUG2392
     C                   MOVEL     A6CDFN        NomCcyCDFN                                  BUG2392
     C                   MOVEL     A6ECDN        NomCcyECDN                                  BUG2392
                                                                                             BUG2392
     C                   EXSR      ACSCUST                                                   BUG2392
                                                                                             BUG2392
      ** CALCULATE COUNTERVALUE                                                              BUG2392
                                                                                             BUG2392
     C                   CALLB     'SETCVALCAL'                                              BUG2392
                                                                                             BUG2392
      * INPUTS                                                                               BUG2392
                                                                                             BUG2392
      ** Trade details                                                                       BUG2392
     C                   PARM                    V_TDTP            2                         BUG2392
     C                   PARM                    DPNA                                        BUG2392
     C                   PARM                    MKTP                                        BUG2392
     C                   PARM                    V_RALL            9 5                       BUG2392
     C                   PARM                    V_ITRA           13 0                       BUG2392
     C                   PARM                    V_TBCA           13 0                       BUG2392
     C                   PARM                    V_TCCA           13 0                       BUG2392
     C                   PARM                    V_TCA1           13 0                       BUG2392
     C                   PARM                    V_TCA2           13 0                       BUG2392
     C                   PARM                    V_TCA3           13 0                       BUG2392
     C                   PARM                    V_TCA4           13 0                       BUG2392
     C                   PARM                    V_TCA5           13 0                       BUG2392
     C                   PARM                    V_TCA6           13 0                       BUG2392
     C                   PARM                    V_TCA7           13 0                       BUG2392
     C                   PARM                    V_TAXA           13 0                       BUG2392
     C                   PARM                    V_TDER           13 8                       BUG2392
     C                   PARM                    V_TMDI            1                         BUG2392
     C                   PARM                    SECNMCY                                     BUG2392
     C                   PARM                    V_TDVD            5 0                       BUG2392
                                                                                             BUG2392
      ** Security details                                                                    BUG2392
     C                   PARM                    PROT              1                         BUG2392
     C                   PARM                    SECSPBS                                     BUG2392
     C                   PARM                    SECCFCT                                     BUG2392
     C                   PARM                    SECNMCY                                     BUG2392
     C                   PARM                    SECNMDP                                     BUG2392
     C                   PARM                    SECSESN                                     BUG2392
                                                                                             BUG2392
      ** Nominal Currency Details                                                            BUG2392
      ** Settlement Currency Details                                                         BUG2392
     C                   PARM                    NomCcyDts                                   BUG2392
     C                   PARM                    NomCcyDts                                   BUG2392
                                                                                             BUG2392
      ** Customer classification                                                             BUG2392
     C                   PARM                    CustClass         1                         BUG2392
                                                                                             BUG2392
      ** Country of treaty from PF/SECTYD                                                    BUG2392
     C                   PARM                    SECCRTT                                     BUG2392
                                                                                             BUG2392
      ** Default basket for backup withholding                                               BUG2392
     C                   PARM                    PDRBW                                       BUG2392
                                                                                             BUG2392
      ** Value date                                                                          BUG2392
     C                   PARM                    V_TDVD                                      BUG2392
                                                                                              237063
      ** EU Tax                                                                               237063
     C                   PARM                    PEUTX                                        237063
                                                                                             BUG2392
      * OUTPUTS                                                                              BUG2392
                                                                                             BUG2392
      * Trade consideration in nominal currency                                              BUG2392
      * Trade countervalue in nominal currency                                               BUG2392
      * Withholding tax                                                                      BUG2392
      * Trade countervalue in settlement currency in screen format                           BUG2392
      * Withholding tax in screen format                                                     BUG2392
     C                   PARM                    V_TCSR           15 0                       BUG2392
     C                   PARM                    V_TCTR           15 0                       BUG2392
     C                   PARM                    WHTX             13 0                       BUG2392
     C                   PARM                    DDTCTR           21                         BUG2392
     C                   PARM                    DDWTAX                                      BUG2392
                                                                                             BUG2392
     C                   ENDSR                                                               BUG2392
      *****************************************************************                      BUG2392
      /EJECT                                                                                 BUG2392
      *****************************************************************                      BUG2392
      * ACSCURR - ACCESS CURRENCY DETAILS                             *                      BUG2392
      *****************************************************************                      BUG2392
     C     ACSCURR       BEGSR                                                               BUG2392
                                                                                             BUG2392
     C                   CALL      'AOCURRR0'                                                BUG2392
     C                   PARM      *BLANKS       @RTCD             7                         BUG2392
     C                   PARM      '*KEY   '     @OPTN             7                         BUG2392
     C                   PARM                    @AJCD             3                         BUG2392
     C     SDCURR        PARM      SDCURR        DSSDY                                       BUG2392
      *                                                                                      BUG2392
      * DATABASE ERROR                                                                       BUG2392
      *                                                                                      BUG2392
     C     @RTCD         IFNE      *BLANK                                                    BUG2392
     C                   MOVEL     @AJCD         DBKEY                                       BUG2392
     C                   MOVEL     'SDCURRPD'    DBFILE                                      BUG2392
     C                   MOVEL     '003'         DBASE                                       BUG2392
     C                   EXSR      *PSSR                                                     BUG2392
     C                   END                                                                 BUG2392
                                                                                             BUG2392
     C                   ENDSR                                                               BUG2392
      *****************************************************************                      BUG2392
      /EJECT                                                                                 BUG2392
      *****************************************************************                      BUG2392
      * ACSCUST - ACCESS CUSTOMER DETAILS                             *                      BUG2392
      *****************************************************************                      BUG2392
     C     ACSCUST       BEGSR                                                               BUG2392
                                                                                             BUG2392
     C                   MOVEL     *BLANK        @KEY1                                       BUG2392
     C                   MOVEL     DPBN          @KEY1                                       BUG2392
                                                                                             BUG2392
     C                   CALL      'AOCUSTR0'                                                BUG2392
     C                   PARM      *BLANK        @RTCD             7                         BUG2392
     C                   PARM      '*KEY   '     @OPTN             7                         BUG2392
     C                   PARM                    @KEY1            10                         BUG2392
     C                   PARM                    @KYST             7                         BUG2392
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG2392
      *                                                                                      BUG2392
      * DATABASE ERROR                                                                       BUG2392
      *                                                                                      BUG2392
     C     @RTCD         IFNE      *BLANK                                                    BUG2392
     C                   MOVEL     DPBN          DBKEY                                       BUG2392
     C                   MOVEL     'SDCUSTPD'    DBFILE                                      BUG2392
     C                   MOVEL     '004'         DBASE                                       BUG2392
     C                   EXSR      *PSSR                                                     BUG2392
     C                   END                                                                 BUG2392
                                                                                             BUG2392
     C                   CALL      'AOSECSR0'                                                BUG2392
     C                   PARM                    @RTCD             7                         BUG2392
     C                   PARM      '*KEY   '     @OPTN             7                         BUG2392
     C                   PARM      BBCUST        @SCKY             6                         BUG2392
     C     SDSECS        PARM      SDSECS        DSSDY                                       BUG2392
      *                                                                                      BUG2392
      * DATABASE ERROR                                                                       BUG2392
      *                                                                                      BUG2392
     C     @RTCD         IFNE      *BLANK                                                    BUG2392
     C                   MOVEL     DPBN          DBKEY                                       BUG2392
     C                   MOVEL     'SDSECSPD'    DBFILE                                      BUG2392
     C                   MOVEL     '005'         DBASE                                       BUG2392
     C                   EXSR      *PSSR                                                     BUG2392
     C                   END                                                                 BUG2392
                                                                                             BUG2392
     C                   MOVE      BFCLAS        CustClass                                   BUG2392
                                                                                             BUG2392
     C                   ENDSR                                                               BUG2392
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * SEDPMV2RV - Retrieve DPMV Extension File                      *                       CER001
      *****************************************************************                       CER001
     C     SEDPMV2RV     BEGSR                                                                CER001
     C                   CALLB     'SEDPMV2RV'                                                CER001
     C                   PARM      *BLANKS       RetCodeOut                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANKS       FOTRID                                       CER001
     C                   PARM                    DPSS                                         CER001
     C                   PARM                    DPRN                                         CER001
     C                   PARM                    DPMVLUXFilFmt                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * SEDPMV2CT - Convert DPMV Extension File to Screen Format      *                       CER001
      *****************************************************************                       CER001
     C     SEDPMV2CT     BEGSR                                                                CER001
     C                   CALLB     'SEDPMV2CT'                                                CER001
     C                   PARM                    RetCodeOut                                   CER001
     C                   PARM                    DPSS                                         CER001
     C                   PARM                    DPRN                                         CER001
     C                   PARM                    DPMVLUXFilFmt                                CER001
     C                   PARM                    RegData                                      CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                      BUG2392
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * CalcPurchInt - Calculate Purchase Interest for Repos          *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
     C     CalcPurchInt  BEGSR                                                                CAP087
      *                                                                                       CAP087
      ** Only process if movement type is Repo.                                               CAP087
     C                   IF        DDPMVTyp = 'RR' OR DDPMVTyp = 'RP'                         CAP087
     C                             OR DDPMVTyp = 'PL' OR DDPMVTyp = 'PD'                      CAP087
     C                             OR DDPMVTyp = 'BL' OR DDPMVTyp = 'BB'                      CAP087
      *                                                                                       CAP087
      ** Processing type must not be 2, 4 nor 7.                                              CAP087
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'                CAP087
      *                                                                                       CAP087
     C                   EVAL      DDAcinOK = 'Y'                                             CAP087
      *                                                                                       CAP087
     C                   CALLB     'SEVTACCRIN'                                               CAP087
     C                   PARM      *BLANKS       ReturnCode                                   CAP087
     C                   PARM      'Y'           Default           1                          CAP087
     C                   PARM      'N'           Validate          1                          CAP087
     C                   PARM      *BLANK        DDACIN            1                          CAP087
     C                   PARM      V_TDVD        TDVD              5 0                        CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDAcinOK          1                          CAP087
     C                   PARM                    ACIN              1                          CAP087
      *                                                                                       CAP087
     C                   CALLB     'ZPCINT'                                                   CAP087
                                                                                              CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM      *BLANK        DADJN                                        CAP087
     C                   PARM                    NomCcyDec                                    CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      DPNA          NOML                                         CAP087
     C                   PARM      DDACIN        ZACIN                                        CAP087
     C                   PARM      *ZERO         ZDADJ                                        CAP087
     C                   PARM      *BLANK        ZADIN                                        CAP087
     C                   PARM      SECCPNR       TDCR                                         CAP087
     C                   PARM      *BLANK        ZCPOVR                                       CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM      V_TDVD        ECD               5 0                        CAP087
     C                   PARM                    ZITRA                                        CAP087
     C                   PARM                    ZTINA                                        CAP087
                                                                                              CAP087
     C                   MOVE      ZITRA         ZFLD15                                       CAP087
      *                                                                                       CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      *BLANKS       DDVDIN                                       CAP087
     C                   MOVE      ZOUT21        DDVDIN                                       CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
      * Format a zero value                                                                   CAP087
     C                   Z-ADD     0             ZFLD15                                       CAP087
                                                                                              CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDVDIN                                       CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      * Set Up Maturity Date Interest, if Associated Deal's MATD is not zero.                 CAP087
      *                                                                                       CAP087
     C     DPAD          CHAIN     MMDELDP0                           90                      CAP087
     C                   IF        *IN90 = '0' AND HKMATD <> 0                                CAP087
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'                CAP087
                                                                                              CAP087
     C                   CALLB     'ZPCINT'                                                   CAP087
     C                   PARM                    SECTYX                                       CAP087
     C                   PARM      *BLANK        DADJN                                        CAP087
     C                   PARM                    NomCcyDec                                    CAP087
     C                   PARM                    PROT                                         CAP087
     C                   PARM      DPNA          NOML                                         CAP087
     C                   PARM      DDACIN        ZACIN                                        CAP087
     C                   PARM      *ZERO         ZDADJ                                        CAP087
     C                   PARM      *BLANK        ZADIN                                        CAP087
     C                   PARM      SECCPNR       TDCR                                         CAP087
     C                   PARM      *BLANK        ZCPOVR                                       CAP087
     C                   PARM      DateFmtInd    DateFormat                                   CAP087
     C                   PARM      HKMATD        ECD               5 0                        CAP087
     C                   PARM                    ZITRA                                        CAP087
     C                   PARM                    ZTINA                                        CAP087
      *                                                                                       CAP087
     C                   MOVE      ZITRA         ZFLD15                                       CAP087
     C                   MOVE      *BLANKS       DDMDIN                                       CAP087
      *                                                                                       CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDMDIN                                       CAP087
      *                                                                                       CAP087
     C                   ELSE                                                                 CAP087
      * Format a zero value                                                                   CAP087
     C                   Z-ADD     0             ZFLD15                                       CAP087
     C                   MOVE      *BLANKS       DDMDIN                                       CAP087
                                                                                              CAP087
     C                   CALLB     'ZSEDIT'                                                   CAP087
     C                   PARM                    ZFLD15                                       CAP087
     C                   PARM      NomCcyDec     ZADEC                                        CAP087
     C                   PARM      *BLANK        ZECODE            1                          CAP087
     C                   PARM                    ZOUT21           21                          CAP087
      *                                                                                       CAP087
     C                   MOVE      ZOUT21        DDMDIN                                       CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                 BUG2392
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Paramaters
      ** ================
 
     C                   PARM                    AuthComp
      ** Read forward/backward indicator
     C                   PARM                    FwdBck
      ** Reference Fields
     C                   PARM                    DDPMVTyp
     C                   PARM                    DDDPRN_In
     C                   PARM                    DDDPSS_In                                    CAP087
 
      ** Output Paramaters
      ** ================
     C                   PARM                    Buffer
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray                                    222373
      ** API Return Code
     C                   PARM                    APIRetc
      *                                                                                       222373
      * Set up the name of the primary and secondary message files from                       222373
      * which the message handler will get the messages                                       222373
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'                                  222373
     C                   EVAL      MsgFArray(2) = 'DRSMM'                                     222373
                                                                                              CAP087
      ** Access bank details via access program                                               CAP087
      ** (database error handling done in access program)                                     CAP087
                                                                                              CAP087
     C                   CALLB     'AOBANKR0'                                                 CAP087
     C                   PARM      '*DBERR '     PRtCd                                        CAP087
     C                   PARM      '*FIRST '     POptn                                        CAP087
     C     SDBANK        PARM      SDBANK        DSFDY                                        CAP087
      *                                                                                       CAP087
      ** Retrieve Date Format                                                                 CAP087
     C                   EVAL      DateFmtInd = BJDFIN                                        CAP087
      *
      ** Access SAR file to determine if S01401
      ** (MT5xx message generation) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement phase 2 is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
      *
      ** Access SAR details file to determine if CSE028
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE028'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE028
     C                   ELSE
     C                   MOVEL     'N'           CSE028
     C                   END
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
 
      ** Check if CSW201 - Swift 2001 Standards Update is installed
 
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       @RTCD
 
     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on                                      CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX602 is installed                          CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANK                                             CER001
     C                   EVAL      ULX602 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX602 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX602'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C*                                                                                      BUG2392
     C* Define key list for file INVTP                                                       BUG2392
     C*                                                                                      BUG2392
     C     KLINVT        KLIST                                                               BUG2392
     C                   KFLD                    SECNMCY                                     BUG2392
     C                   KFLD                    SECSITP                                     BUG2392
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
 
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
