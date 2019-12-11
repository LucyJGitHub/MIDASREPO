     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contract validation')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCVAL - Internal Contract Validation                     *
      *                                                               *
      *  Function: This program validates internal contract deals     *
      *            for input to the Midas database.                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *  Last Amend No. BUG8550            Date 15Jun06               *
      *                 217693             Date 26May06               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 05Aug03               *
      *                 CAP076             Date 03Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  217693 - Int. Contracts maint. - no warning msg.             *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in ABVDEPODTS ABVLOANDTS    *
      *           (new parameter to ZINTDY)                           *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,ABINTCV024

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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

      * Incoming Transaction
     D TranIn        E DS                  EXTNAME(ABINTCPD)

     D ExtData       E DS                  EXTNAME(ABICEXPD)
      * FX Extra Data - File (D/B) format

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(ABEINTCPD)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      *                                                                                       CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *                                                                                       CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011

     D ValidDeal     E DS                  EXTNAME(ABVINTCPD)
     D W@VDT1                171    178  0
     D W@VDT2                179    186  0
      * Valid Deals layout

     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PSARD           S              6A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
                                                                                              CSC011
     D CDL038          S              1A                                                     BUG9717
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,ABINTCV025

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      **  GET ZMUSER to access default branch.                                               BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
                                                                                             BUG8550
      /COPY WNCPYSRC,ABINTCV001

      * Call Validation Modules in Sequence

                                                                                CDL038
      ** Default Sub Type and Class                                             CDL038
      *                                                                         CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                    CDL038
     C                   ENDIF                                                               BUG9717
      *
      *  Validate Deal Type and Sub Type
      *
      /COPY WNCPYSRC,ABINTCV002

     C                   EXSR      VDEALTPS

      /COPY WNCPYSRC,ABINTCV003

      *
      *  Validate Booking and Originating Branch
      *
      /COPY WNCPYSRC,ABINTCV004

     C                   EXSR      VBRANCHS

      /COPY WNCPYSRC,ABINTCV005

      *
      * Validate Deal Date, 1st Leg Date, 2nd Leg Date
      *
      /COPY WNCPYSRC,ABINTCV006

     C                   EXSR      VDATES

      /COPY WNCPYSRC,ABINTCV007

      *
      *  Validate Books and Profit Centres
      *
      /COPY WNCPYSRC,ABINTCV008

     C                   EXSR      VBKPRFC

      /COPY WNCPYSRC,ABINTCV009

      *
      *  Validate Link Reference
      *
      /COPY WNCPYSRC,ABINTCV010

     C                   EXSR      VLNKN

      /COPY WNCPYSRC,ABINTCV011

      *
      *  Validate Leg 1 Buy and Sell Ccys & Amounts
      *
      /COPY WNCPYSRC,ABINTCV012

     C                   EXSR      VL1BSAMT

      /COPY WNCPYSRC,ABINTCV013

      *
      *  Validate Loan Details
      *
      /COPY WNCPYSRC,ABINTCV014

     C                   EXSR      VLOANDTS

      /COPY WNCPYSRC,ABINTCV015

      *
      *  Validate Deposit Details
      *
      /COPY WNCPYSRC,ABINTCV016

     C                   EXSR      VDEPODTS

      /COPY WNCPYSRC,ABINTCV017

      *
      *  Validate Leg 2 Base Currency Equivalent
      *
      /COPY WNCPYSRC,ABINTCV018

     C                   EXSR      VL2BSCYE

      /COPY WNCPYSRC,ABINTCV019

      *
      *  Validate Forward Points
      *
      /COPY WNCPYSRC,ABINTCV020

     C                   EXSR      VFWDPTS

      /COPY WNCPYSRC,ABINTCV021

      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

      /COPY WNCPYSRC,ABINTCV022

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,ABINTCV023

      * RETURN
      *
     C                   RETURN

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,ABINTCV026

      *****************************************************************
     C/EJECT
      *****************************************************************
      * VDEALTPS - Validate Deal Type and Sub Type
      *****************************************************************
     C     VDEALTPS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Deal Type and Sub Type
      *
     C                   CALLB     'ABVDEALTPS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Type & Deal Sub-Type
      ** and Class                                                                            CDL038
     C                   PARM                    DDDLTP            2
     C                   PARM                    DDDSTP            2
     C                   PARM                    DDCLAS            4                          CDL038
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deal Type - OK
      ** Deal Sub-Type - OK
      ** Class         - OK                                                                   CDL038
     C                   PARM                    DDDLTPOK          1
     C                   PARM                    DDDSTPOK          1
     C                   PARM                    DDClasOK          1                          CDL038
      *
      ** Deal Type & Deal Sub-Type
      ** and Class                                                                            CDL038
     C                   PARM                    JUMDTY            2
     C                   PARM                    JUSTYP            2
     C                   PARM                    JUCLAS            4                          CDL038

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VBRANCHS - Validate Booking and Originating Branch
      *****************************************************************
     C     VBRANCHS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Booking and Originating Branch
      *
     C                   CALLB     'ABVBRANCHS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Action
      ** Booking branch
      ** Originating branch
     C                   PARM                    DDACTN            1
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDORBR            3
      *
      ** ICD
     C                   PARM                    BJSBRC            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
      *
      ** Response mode (from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode          1
      *
      ** Default branch code from ZMUSER
     C                   PARM                    BRC               3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Action code - OK
      ** Booking branch - OK
      ** Originating branch - OK
     C                   PARM                    DDACTNOK          1
     C                   PARM                    DDBRCDOK          1
     C                   PARM                    DDORBROK          1
      *
      ** Deal Booking Branch(es), Originating Branch, Customer
     C                   PARM                    JUDBRC            3
     C                   PARM                    JUMBCA            3
     C                   PARM                    JUORBR            3
     C                   PARM                    JUDCNO
      *
      ** Booking branch round down indicator
      ** Booking branch location
      ** Booking branch customer
      ** Booking branch account officer
     C                   PARM                    BkgBrRDFC         1
     C                   PARM                    BkgBrLCCD         3
     C                   PARM                    BkgBrCUST         6
     C                   PARM                    BkgBrACOC         2

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VDATES - Validate Deal Date, 1st Leg Date, 2nd Leg Date
      *****************************************************************
     C     VDATES        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      * Validate Deal Date, 1st Leg Date, 2nd Leg Date
      *
     C                   CALLB     'ABVDATES'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Date
      ** 1st Leg Value Date
      ** 2nd Leg Value Date
     C                   PARM                    DDDLDT            6
     C                   PARM                    DDL1DT            6
     C                   PARM                    DDL2DT            6
     C                   PARM                    DDL1CB                                       217693
     C                   PARM                    DDL1CS                                       217693
     C                   PARM                    DDL2CB                                       217693
     C                   PARM                    DDL2CS                                       217693
      *
      ** Booking branch OK
     C                   PARM                    DDBRCDOK          1
      *
      * Booking branch location
     C                   PARM                    BkgBrLCCD         3
      *
      * ICD
      *
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJHOCY            3
      *
      * OUTPUTS
                                                                                              217693
      * Warning felds/message IDs/message data (arrays) from/to caller                        217693
     C                   PARM                    WFldNmXAr                                    217693
     C                   PARM                    WMsgIdXAr                                    217693
     C                   PARM                    WMsgDtXAr                                    217693
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deal Date - OK
      ** 1st Leg Value date - OK
      ** 2nd Leg Value date - OK
     C                   PARM                    DDDLDTOK          1
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL2DTOK          1
      *
      ** Deal Date, 1st Leg (Near) Value Date, 2nd Leg (Far) Value Date
      *
     C                   PARM                    JUDDAT            5 0
     C                   PARM                    JUDDYY
     C                   PARM                    JUDDMM
     C                   PARM                    JUDDDD

     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUNDYY
     C                   PARM                    JUNDMM
     C                   PARM                    JUNDDD

     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUFDYY
     C                   PARM                    JUFDMM
     C                   PARM                    JUFDDD

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VBKPRFC - Validate Books and Profit Centres
      *****************************************************************
     C     VBKPRFC       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Books and Profit Centres
      *
     C                   CALLB     'ABVBKPRFC'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
      ** Deal Type
      ** Deal Subtype
      ** Deal Type
      ** Branch
      ** FX Book Code
      ** MM Book Code
      ** FX Profit Centre
      ** MM Profit Centre
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDSTP            2            deal sub type
     C                   PARM                    DDBRCD            3            booking branch
     C                   PARM                    DDFXBC            2            book
     C                   PARM                    DDMMBC            2            book
     C                   PARM                    DDPRFC            4            profit centre
     C                   PARM                    DDMMPC            4            profit centre
      *
      ** Deal Type OK
      ** Deal Subtype OK
      ** Booking branch OK
     C                   PARM                    DDDLTPOK          1
     C                   PARM                    DDDSTPOK          1
     C                   PARM                    DDBRCDOK          1
      *
      ** Booking branch customer
      ** Booking branch account officer.
     C                   PARM                    BkgBrCUST         6
     C                   PARM                    BkgBrACOC         2
      *
      * ICD
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    BGN0ST            1
      * Dept from ZMUSER
     C                   PARM                    DEPT              3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** FX Book - OK
      ** MM Book - OK
      ** FX Profit Centre - OK
      ** MM Profit Centre - OK
     C                   PARM                    DDFXBCOK          1
     C                   PARM                    DDMMBCOK          1
     C                   PARM                    DDPRFCOK          1
     C                   PARM                    DDMMPCOK          1
      *
      ** Deal FX Book
      ** Deal MM Book
      ** Deal FX Profit Centre
      ** Deal MM Profit Centre
      *
     C                   PARM                    JUFXBC            2
     C                   PARM                    JUMMBC            2
     C                   PARM                    JUPRFC            4
     C                   PARM                    JUMMPC            4

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VLNKN - Validate Link Reference
      *****************************************************************
     C     VLNKN         BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Link Reference
      *
     C                   CALLB     'FXVLNKN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDLNKR            6
      *
      * ICD
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Linked reference no - OK
     C                   PARM                    DDLNKROK          1
      *
      ** Deal Linked Reference No.
     C                   PARM                    JULNKN

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VL1BSAMT - Validate Leg 1 Buy and Sell Ccys & Amounts
      *****************************************************************
     C     VL1BSAMT      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Leg 1 Buy and Sell Ccys & Amounts
      *
     C                   CALLB     'ABVL1BSAMT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
      ** 1st leg exchange rate
      ** 1st leg buy currency
      ** 1st leg buy amount
      ** 1st leg sell currency
      ** 1st leg sell amount
      ** 1st leg base equivalent
     C                   PARM                    DDL1RT           13
     C                   PARM                    DDL1CB            3
     C                   PARM                    DDL1BA           16
     C                   PARM                    DDL1CS            3
     C                   PARM                    DDL1SA           16
     C                   PARM                    DDL1BE           16
      *
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BseCcyDP          1 0
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Currency 1 details
     C                   PARM                    W@SRT1           13 8            Spot rate
     C                   PARM                    W@MDI1            1              Mult/Div.ind.
     C                   PARM                    W@HSR1           13 8          Hi Spot rate 1
     C                   PARM                    W@LSR1           13 8          Lo Spot rate 1
     C                   PARM                    W@XMD1            1            Xrate M/D 1
     C                   PARM                    W@NQD1            1 0          N/Quoted dec.1
     C                   PARM                    W@SXP1            1 0          ScaleExponent1
     C                   PARM                    W@ICM1            1            Int.Calc.Mth.1
     C                   PARM                    W@FSD1            8 0          FX Spot date 1
     C                   PARM                    W@LCRD            1            Ln Ccy R-dn ind
      *
      ** Currency 2 details
     C                   PARM                    W@SRT2           13 8            Spot rate
     C                   PARM                    W@MDI2            1              Mult/Div.ind.
     C                   PARM                    W@HSR2           13 8          Hi Spot rate 2
     C                   PARM                    W@LSR2           13 8          Lo Spot rate 2
     C                   PARM                    W@XMD2            1            Xrate M/D 2
     C                   PARM                    W@NQD2            1 0          N/Quoted dec.2
     C                   PARM                    W@SXP2            1 0          ScaleExponent2
     C                   PARM                    W@ICM2            1            Int.Calc.Mth.2
     C                   PARM                    W@FSD2            8 0          FX Spot date 2
     C                   PARM                    W@DCRD            1            Dp Ccy R-dn ind
      *
      * Deal Normally-Quoted Decimal Places:
     C                   PARM                    W@NQDP            1 0            Quoted=5
      *
      ** 2nd leg buy currency
      ** 2nd leg sell currency
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2CS            3
      *
      ** 1st leg exchange rate - OK
      ** 1st leg buy currency - OK
      ** 1st leg buy amount - OK
      ** 1st leg sell currency - OK
      ** 1st leg sell amount - OK
      ** 1st leg base equivalent - OK
     C                   PARM                    ddL1RTok          1
     C                   PARM                    ddL1CBok          1
     C                   PARM                    ddL1BAok          1
     C                   PARM                    ddL1CSok          1
     C                   PARM                    ddL1SAok          1
     C                   PARM                    ddL1BEok          1
      *
      ** Near Date Exchange Rate
      ** First Currency
      ** First Currency Decimal Places
      ** First Ccy Near Date Amount
      ** Near Date Buy Amount
      ** Second Currency
      ** Second Currency Decimal Places
      ** Second Ccy Near Date Amount
      ** Near Date Sell Amount
      ** Deal Mult/Div First Amount Ind
      ** Near Date Base Ccy for Accounting Amount
      *
     C                   PARM                    JUNDXR           13 8
     C                   PARM                    JUDFCY            3              Currency
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUNDA1           15 0            Amount
     C                   PARM                    JUNDBA           15 0            Buy amount
     C                   PARM                    JUDSCY            3              Currency
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUNDA2           15 0            Amount
     C                   PARM                    JUNDSA           15 0            Sell amount
     C                   PARM                    JUDMD1            1              Mult/Div ind.
     C                   PARM                    JUNBCA           15 0            Amount

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VLOANDTS - Validate Loan Details
      *****************************************************************
     C     VLOANDTS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Loan Details
      *
     C                   CALLB     'ABVLOANDTS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields:
      ** Loan Round Down Indicator
      ** Loan Interest Calculation Method
      ** Loan Interest Rate
     C                   PARM                    DDLRDF            1
     C                   PARM                    DDLOCM            1
     C                   PARM                    DDLOIR           13
      *
      ** Deal File fields:
      ** Deal Near Date
      ** Deal Far Date
      ** Deal First Ccy Near Date Amount
     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUNDA1           15 0
      *
      ** 1st Leg Value Date - OK
      ** 1st Leg Buy Currency - OK
      ** 1st Leg Buy Amount - OK
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CBOK          1
     C                   PARM                    DDL1BAOK          1
      *
      ** Booking branch round down indicator
      ** Buy currency round down indicator
      ** Buy currency int. calc. method
      ** Buy number of decimal places
     C                   PARM                    BkgBrRDFC         1
     C                   PARM      W@LCRD        BuyCyRDFC         1
     C                   PARM      W@ICM1        BuyCyDICB         1
     C                   PARM      JUCDPF        BuyCyNBDP         1 0
      *
      * ICD
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Loan Round Down Indicator - OK
      ** Loan Interest Calculation Method - OK
      ** Loan Interest Rate - OK
     C                   PARM                    DDLRDFOK          1
     C                   PARM                    DDLOCMOK          1
     C                   PARM                    DDLOIROK          1
      *
      ** 2nd Leg Sell Amount
      ** Loan Interest Amount
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
      *
      * Loan round-down int indicator
      * Deal First Ccy Interest Calc.Method
      * Deal First Ccy Interest Rate
      * Deal First Ccy Interest Amount
      * Deal Far Date Sell Amount
      * Deal First Ccy Far Date Amount
      *
     C                   PARM                    JULRDF            1
     C                   PARM                    JUICM1
     C                   PARM                    JUIRT1           11 7
     C                   PARM                    JUINA1           15 0
     C                   PARM                    JUFDSA           15 0
     C                   PARM                    JUFDA1           15 0

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VDEPODTS - Validate Deposit Details
      *****************************************************************
     C     VDEPODTS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Deposit Details
      *
     C                   CALLB     'ABVDEPODTS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields:
      ** Deposit Round Down Indicator
      ** Deposit Interest Calculation Method
      ** Deposit Interest Rate
     C                   PARM                    DDDRDF            1
     C                   PARM                    DDDPCM            1
     C                   PARM                    DDDPIR           13
      *
      ** Deal File fields:
      ** Deal Near Date
      ** Deal Far Date
      ** Deal Second Ccy Near Date Amount
     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUNDA2           15 0
      *
      ** 1st Leg Value Date - OK
      ** 1st Leg Sell Currency - OK
      ** 1st Leg Sell Amount - OK
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CSOK          1
     C                   PARM                    DDL1SAOK          1
      *
      ** Booking branch round down indicator
      ** Sell currency round down indicator
      ** Sell currency int. calc. method
      ** Sell number of decimal places
     C                   PARM                    BkgBrRDFC         1
     C                   PARM      W@DCRD        SelCyRDFC         1
     C                   PARM      W@ICM2        SelCyDICB         1
     C                   PARM      JUCDPS        SelCyNBDP         1 0
      *
      * ICD
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deposit Round Down Indicator - OK
      ** Deposit Interest Calculation Method - OK
      ** Deposit Interest Rate - OK
     C                   PARM                    DDDRDFOK          1
     C                   PARM                    DDDPCMOK          1
     C                   PARM                    DDDPIROK          1
      *
      ** 2nd Leg Buy Amount
      ** Deposit Interest Amount
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDDPIA           17
      *
      * Deposit round-down int indicator
      * Deal Second Ccy Interest Calc.Method
      * Deal Second Ccy Interest Rate
      * Deal Second Ccy Interest Amount
      * Deal Far Date Buy Amount
      * Deal Second Ccy Far Date Amount
      *
     C                   PARM                    JUDRDF            1
     C                   PARM                    JUICM2
     C                   PARM                    JUIRT2           11 7
     C                   PARM                    JUINA2           15 0
     C                   PARM                    JUFDBA           15 0
     C                   PARM                    JUFDA2           15 0

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VL2BSCYE - Validate Leg 2 Base Currency Equivalent
      *****************************************************************
     C     VL2BSCYE      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Leg 2 Base Currency Equivalent
      *
     C                   CALLB     'ABVL2BSCYE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
      ** 2nd leg base equivalent
      ** 2nd leg buy currency
      ** 2nd leg sell currency
     C                   PARM                    DDL2BE           16
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2CS            3
      *
      ** Deal File fields
      ** First Currency Decimal Places
      ** First Ccy Far Date Amount
      ** Second Currency Decimal Places
      ** Second Ccy Far Date Amount
      *
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUFDA1           15 0            Amount
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUFDA2           15 0            Amount
      *
      ** 1st Leg Exchange Rate - OK
      ** 1st Leg Value Date - OK
      ** 1st Leg Buy Currency - OK
      ** 1st Leg Buy Amount - OK
      ** 1st Leg Sell Currency - OK
      ** 1st Leg Sell Amount - OK
      ** 2nd Leg Value Date - OK
      ** Loan Round down Ind. - OK
      ** Loan Interest Calculation Method - OK
      ** Loan Interest Rate - OK
      ** Deposit Round down Ind. - OK
      ** Deposit Interest Calculation Method - OK
      ** Deposit Interest Rate - OK
     C                   PARM                    DDL1RTOK          1
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CBOK          1
     C                   PARM                    DDL1BAOK          1
     C                   PARM                    DDL1CSOK          1
     C                   PARM                    DDL1SAOK          1
     C                   PARM                    DDL2DTOK          1
     C                   PARM                    DDLRDFOK          1             AND R-D IND OK
     C                   PARM                    DDLOCMOK          1
     C                   PARM                    DDLOIROK          1             1ST LEG SELL
     C                   PARM                    DDDRDFOK          1             AND R-D IND OK
     C                   PARM                    DDDPCMOK          1
     C                   PARM                    DDDPIROK          1             1ST LEG SELL
      *
      ** Currency 1 & 2 spot rates & M/D indicators
     C                   PARM                    W@SRT1           13 8            Spot rate
     C                   PARM                    W@MDI1            1              Mult/Div.ind.
     C                   PARM                    W@SRT2           13 8            Spot rate
     C                   PARM                    W@MDI2            1              Mult/Div.ind.
      *
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BseCcyDP          1 0
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** 2nd leg base equivalent - OK
     C                   PARM                    DDL2BEOK          1
      *
      ** Far Date Base Ccy for Accounting Amount
     C                   PARM                    JUFBCA           15 0            Amount

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VFWDPTS - Validate Forward Points
      *****************************************************************
     C     VFWDPTS       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Forward Points
      *
     C                   CALLB     'ABVFWDPTS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDFPTS            9
      *
      ** Deal File fields
      ** Near Date Exchange Rate
      ** First Currency Decimal Places
      ** First Ccy Far Date Amount
      ** Second Currency Decimal Places
      ** Second Ccy Far Date Amount
      ** Deal Mult/Div First Amount Ind
      *
     C                   PARM                    JUNDXR           13 8
     C                   PARM                    JUCDPF                           Dec.places
     C                   PARM                    JUFDA1           15 0            Amount
     C                   PARM                    JUCDPS                           Dec.places
     C                   PARM                    JUFDA2           15 0            Amount
     C                   PARM                    JUDMD1            1              Dec.places
      *
      * Deal Normally-Quoted Decimal Places:
     C                   PARM                    W@NQDP            1 0            Quoted=5
      *
      ** 1st Leg Exchange Rate - OK
      ** 1st Leg Value Date - OK
      ** 1st Leg Buy Currency - OK
      ** 1st Leg Buy Amount - OK
      ** 1st Leg Sell Currency - OK
      ** 1st Leg Sell Amount - OK
      ** 2nd Leg Value Date - OK
      ** Loan Round down Ind. - OK
      ** Loan Interest Calculation Method - OK
      ** Loan Interest Rate - OK
      ** Deposit Round down Ind. - OK
      ** Deposit Interest Calculation Method - OK
      ** Deposit Interest Rate - OK
     C                   PARM                    DDL1RTOK          1
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CBOK          1
     C                   PARM                    DDL1BAOK          1
     C                   PARM                    DDL1CSOK          1
     C                   PARM                    DDL1SAOK          1
     C                   PARM                    DDL2DTOK          1
     C                   PARM                    DDLRDFOK          1             AND R-D IND OK
     C                   PARM                    DDLOCMOK          1
     C                   PARM                    DDLOIROK          1             1ST LEG SELL
     C                   PARM                    DDDRDFOK          1             AND R-D IND OK
     C                   PARM                    DDDPCMOK          1
     C                   PARM                    DDDPIROK          1             1ST LEG SELL
      *
      ** ICD
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      * 2nd Leg Exchange Rate
     C                   PARM                    DDL2RT           13
      *
      ** Forward Points - OK
     C                   PARM                    DDFPTSOK          1
      *
      ** Deal Far Date exchange Rate
      ** Deal Forward Points
      *
     C                   PARM                    JUFDXR           13 8           New rate
     C                   PARM                    JUFWPP            7 2           Fwd. points

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    DDACTN                                       CDL038
     C                   PARM                    DDDLTP                                       CDL038
     C                   PARM                    @Customer        10                          CDL038
     C                   PARM                    DDL1DT                                       CDL038
     C                   PARM                    DDL2DT                                       CDL038
     C                   PARM                    DDFXBC                                       CDL038
     C                   PARM                    DDPRFC                                       CDL038
     C                   PARM                    DDL1CB                                       CDL038
     C                   PARM                    DDL1CS                                       CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDDSTP                                       CDL038
     C                   PARM                    DDCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
      * Make sell amounts negative
      *
     C                   Z-SUB     JUNDA2        JUNDA2
     C                   Z-SUB     JUFDA1        JUFDA1
     C                   Z-SUB     JUNDSA        JUNDSA
     C                   Z-SUB     JUFDSA        JUFDSA

      * Zeroize Treasury Management amounts:
      * Near Dealt BCE
      * Far Dealt  BCE
      * Near Spot  BCE
      * Far Spot   BCE

     C                   Z-ADD     0             JUNBCD                         O:Near DBCE
     C                   Z-ADD     0             JUFBCD                         O:Far DBCE
     C                   Z-ADD     0             JUNSBC                         O:Near SBCE
     C                   Z-ADD     0             JUFSBC                         O:Far SBCE
      *
      ** Calculate Treasury Management amounts:
      ** if Treasury Management is present
      *
     C     BGTRMG        IFEQ      'Y'
     C                   EXSR      CALTMAMT
     C                   END
      *                                                                         CAP084
      ** Setup deal numbers                                                     CAP084
      *                                                                         CAP084
     C     JUFD38        IFEQ      0                                            CAP084
     C                   MOVE      DDL1DN        JUFD38                         CAP084
     C                   ENDIF                                                  CAP084
     C     JUSD38        IFEQ      0                                            CAP084
     C                   MOVE      DDL2DN        JUSD38                         CAP084
     C                   ENDIF                                                  CAP084
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALTMAMT- Calculate Treasury Management Amounts
      *****************************************************************
     C     CALTMAMT      BEGSR
      *
      * Calculate Near Dealt BCE and Near Spot BCE
      *
     C                   Z-ADD     JUNDA1        @@DAM1                         I:1st.Amount
     C                   MOVE      JUDFCY        @@CCY1                         I: "  Currency
     C                   Z-ADD     JUNDA2        @@DAM2                         I:2nd.Amount
     C                   MOVE      JUDSCY        @@CCY2                         I: "  Currency
     C                   Z-ADD     W@VDT1        @@VLDT                         I:Value date

     C                   EXSR      CALBED                                       <Get Near DBCE>
      *
      ** Update file fields
      *
     C                   Z-ADD     @@DBCE        JUNBCD                         O:Near DBCE
     C                   Z-ADD     @@DSBC        JUNSBC                         O:Near SBCE
      *
      * Calculate Far Dealt BCE and Far Spot BCE
      * Use -ve amounts as ZACALBED assumes @@DAM1 is +ve. @@DAM2 is -ve.
      * JUFDA1 will be -ve (sell), and JUFDA2 will be +ve (buy).
      *
     C                   Z-SUB     JUFDA1        @@DAM1                         I:1st.Amount
     C                   MOVE      JUDFCY        @@CCY1                         I: "  Currency
     C                   Z-SUB     JUFDA2        @@DAM2                         I:2nd.Amount
     C                   MOVE      JUDSCY        @@CCY2                         I: "  Currency
     C                   Z-ADD     W@VDT2        @@VLDT                         I:Value date

     C                   EXSR      CALBED                                       <Get Far DBCE>
      *
      ** Update file fields
      *
     C                   Z-ADD     @@DBCE        JUFBCD                         O:Far DBCE
     C                   Z-ADD     @@DSBC        JUFSBC                         O:Far SBCE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALBED - Calculate Base Currency Equivalent - Dealing
      *****************************************************************
     C     CALBED        BEGSR
      *
     C                   CALLB     'ZACALBED'
      *
      * INPUTS
      *
      * Buy  & Sell currencies
     C                   PARM                    @@CCY1            3            buy ccy
     C                   PARM                    @@CCY2            3            sell ccy
      *
      * Date effective, exchange rate, forward points
      *
     C                   PARM                    @@VLDT            8 0          value date
     C                   PARM      *ZERO         @@DXR            13 8          exch rate
     C                   PARM      *ZERO         @@DFP             7 2          forward pts
      *
      * Buy amount and Sell amount
      *
     C                   PARM                    @@DAM1           15 0          amount
     C                   PARM                    @@DAM2           15 0          amount
      *
      * buy: spot rate, ccy dec places, round down, norm quot decs
      *      scaling exponent, mult/div ind, mult/div ind-exch,
      *      low spot rate, high spot rate, FX spot date
      *
     C                   PARM      W@SRT1        @SPOT1           13 8          spot rate
     C                   PARM      JUCDPF        @CDP1             1 0          no of dec places
     C                   PARM      W@LCRD        @RDCY1            1            round down
     C                   PARM      W@NQD1        @@NDP1            1 0          norm quot decs
     C                   PARM      W@SXP1        @@SXP1                         scaling exponent
     C                   PARM      W@MDI1        @@MDF1            1            mult/div ind
     C                   PARM      W@XMD1        @@MDX1            1            mult/div ind,exch
     C                   PARM      W@LSR1        @@LSP1           13 8          low spot rate
     C                   PARM      W@HSR1        @@HSP1           13 8          high spot rate
     C                   PARM      W@FSD1        @@SPD1            8 0          FX spot date
      *
      * sell: spot rate, ccy dec places, round down, norm quot decs
      *       scaling exponent, mult/div ind, mult/div ind-exch,
      *       low spot rate, high spot rate, FX spot date
      *
     C                   PARM      W@SRT2        @SPOT2           13 8          spot rate
     C                   PARM      JUCDPS        @CDP2             1 0          no of dec places
     C                   PARM      W@DCRD        @RDCY2            1            round down
     C                   PARM      W@NQD2        @@NDP2            1 0          norm quot decs
     C                   PARM      W@SXP2        @@SXP2                         scaling exponent
     C                   PARM      W@MDI2        @@MDF2            1            mult/div ind
     C                   PARM      W@XMD2        @@MDX2            1            mult/div ind,exch
     C                   PARM      W@LSR2        @@LSP2           13 8          low spot rate
     C                   PARM      W@HSR2        @@HSP2           13 8          high spot rate
     C                   PARM      W@FSD2        @@SPD2            8 0          FX spot date
      *
      * ICD
     C                   PARM                    BNCYDL            3            mult/div ind
      *
      * OUTPUTS
      *
      * Base ccy dealing and dealt spot base
      *
     C                   PARM      *ZERO         @@DBCE           15 0          base ccy dealing
     C                   PARM      *ZERO         @@DSBC           15 0          dealt spot base
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      * INPUTS

      * Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Extra Data
     C                   PARM                    ExtData

      * OUTPUTS

      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      * Status                                                                  CAP084
     C                   PARM                    DDSTS            24            CAP084

      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'ABINTCVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Currencies file via access program
      ** for Base Currency for Accounting details
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6NBDP        BseCcyDP          1 0
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
     C                   PARM      'CDL038'      PSARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
     C                             PRTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 902                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,ABINTCV027

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
