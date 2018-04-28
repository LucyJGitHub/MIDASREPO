     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV screen enquiry')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading  Module                           *
      *                                                               *
      *  SEDPMVSIN - SE Depot Movement Screen Enquiry                 *
      *                                                               *
      *  Function:  This is the main screen enquiry function          *
      *             for Depot Movement Transaction.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 24Aug05               *
      *                 CGL031             Date 05Jul04               *
      *                 222373             Date 22Oct03
      *                 222727             Date 05Nov03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 174742             Date 17Jan01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007  *Create    Date 26Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           New parameter added to call to SEDPMVRTV.           *
      *           Also due to changes in file SEDMWIPD and            *
      *           SEEDMWIP)                                           *
      *  CGL031 - Taxation of Savings Income                          *
      *  222373 - Parameter Mismatch                                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Auto-settle of trades.                              *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  174742 - Walk in transactions showing on Walk out screen with*
      *         - Walk out transactions showing on Walk in screen     *
      *  CGL007 - Account Postings Enquiry                            *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRP002 - Retrieve the Details of the Deal                    *
      *  SRP003 - Convert details to Screen Format                    *
      *  SRP004 - Calls Walk-In Displacy Screen                       *
      *  SRP005 - Calls Walk-Out Display Screen                       *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the FX standard declares
      *
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      **------------------------------------------------------------------------
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** Depot Movement Details Data Structures
      ** --------------------------------------
      *
     D NwScrnRec     E DS                  EXTNAME(SEDMWIPD)
      ** Screen Fields
      *
     D OKIndFile     E DS                  EXTNAME(SEEDMWIPD)
      ** Fields Ok Indicator
      *
     D OldDPMVRec    E DS                  EXTNAME(DPTMVD)
      ** Current Transaction In file Format
     D                                     PREFIX(Old)
      *
      ** ICD/SD Data Structures
      ** ----------------------
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules Details Accessed Via Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs, Short DS
      *
     D @CCI@M          DS
      ** Current Control Indicators for Main Detail screen
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7
      *
     D WDPRN           S              6S 0
                                                                                              CGL031
      ** CGL031 Access object                                                                 CGL031
                                                                                              CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
     D PSard           S              6A                                                      CGL031
     D CGL031          S              1A                                                      CGL031
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P001 - Main Processing                                       *
      *                                                               *
      *  Calls:     SRP002 - Retrieve Details of the Deal             *
      *             SRP003 - Convert Details to Screen Format         *
      *             SRP004 - Calls Walk-In Display Screen             *
      *             SRP005 - Calls Walk-Out Display Screen            *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      SRP002
      *
     C     DDACTNok      IFEQ      'N'
     C     DDDPRNok      OREQ      'N'
     C     DDDPBAok      OREQ      'N'
     C     DDORBRok      OREQ      'N'
     C                   MOVE      'E'           PRETC
     C                   ELSE
     C                   EXSR      SRP003
     C                   ENDIF
      *
     C                   DOW       PRETC = *blanks
     C     PMOVT         IFEQ      'WI'
     C                   EXSR      SRP004
     C                   ELSE
     C                   EXSR      SRP005
     C                   ENDIF
      *
     C                   Select
     C                   When      @INKC = '1'
     C                   Eval      PRETC = 'Q'
      *
     C                   When      @INKL = '1'
     C                   Eval      PRETC = 'P'
      *
     C                   ENDSL
      *
     C                   Enddo
      *
     C                   MOVE      '1'           *INLR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP002 - Retrieve the Details of the Deal                    *
      *                                                               *
      *  Called by: P001 - Main Processing                            *
      *                                                               *
      *  Calls:     SEDPMVRTV - DPMV Retrieve Function                *
      *                                                               *
      *****************************************************************
     C     SRP002        BEGSR
      *
     C                   CALLB     'SEDPMVRTV'
     C                   PARM      PACT          DDACTN
     C                   PARM      PREF          DDDPRN
     C                   PARM      PBKBR         DDDPBA
     C                   PARM      PORBR         DDORBR
     C                   PARM      *BLANKS       ModeOfOP          6
     C                   PARM      'S'           RespMode
     C                   PARM      *BLANKS       FOTRID           20
     C                   PARM                    DPMVType          2                          174742
     C                   PARM                    CallProg         10                          222373
     C                   PARM                    DDDPSS                                       CAP087
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    OldDPMVRec
     C                   PARM                    DDACTNOk
     C                   PARM                    DDDPRNOk
     C                   PARM                    DDDPBAOk
     C                   PARM                    DDORBROk
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP003 - Convert Details to Screen Format                    *
      *                                                               *
      *  Called by: P001 - Main Processing                            *
      *                                                               *
      *  Calls:     SEDPMVCVT - DPMV Conversion: File to Screen       *
      *                                                               *
      *****************************************************************
      *
     C     SRP003        BEGSR
      *
     C                   CALLB     'SEDPMVCVT'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    OldDPMVRec
     C                   PARM                    NwScrnRec
     C                   PARM      *BLANK        DDSPXR           14
     C                   PARM      *BLANK        DDSPMD            1
     C                   PARM                    DDSecSts          7
     C                   PARM                    DDTranSts         7
     C                   PARM                    PBCusInd          1                          222373
     C                   PARM                    PBFieldInd        1                          222373
     C                   PARM                    CGL031                                       CGL031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP004 - Calls Walk In Display Screen                        *
      *                                                               *
      *  Called by: P001 - Main Processing                            *
      *                                                               *
      *  Calls:     SEDMWIDSP - DPMV Walk-in Transaction Display      *
      *                                                               *
      *****************************************************************
      *
     C     SRP004        BEGSR
      *
     C                   CALLB     'SEDMWIDSP'
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety         10                          CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno          6                          CSE039
      *
      ** Received parameters
      ** -------------------
      *
      ** Transaction Details
      ** Transaction Status
      ** Security Status
      ** Transaction screen format
      ** Exchange Rate
      ** M/D Indicator
      ** Portfolio Customer Indicator
      ** Fields in error
      *
     C                   PARM                    DDTranSts         7
     C                   PARM                    DDSecSts          7
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd                                     222373
     C                   PARM                    PBFieldInd                                   222373
     C                   PARM                    OKIndFile
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Disable Key & details fields
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      ** Disable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KN = Command Key 14 = Settlement Details
      ** KP = Command Key 15 = Browse
      *
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      ** Succesful Insert Deal
      *
     C                   PARM                    @SIDN             6
      *
      ** Output Parameters
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP005 - Calls Walk Out Display Screen                       *
      *                                                               *
      *  Called by: P001 - Main Processing.                           *
      *                                                               *
      *  Calls:     SEDMWODSP - DPMV Walk-Out Transaction Display     *
      *                                                               *
      *****************************************************************
      *
     C     SRP005        BEGSR
      *
     C                   CALLB     'SEDMWODSP'
      *
      ** Retrun Code
      *
     C                   PARM                    RetCodeIn
      ** Security                                                                             CSE039
     C                   PARM                    DPMVSety         10                          CSE039
      ** Transaction Number                                                                   CSE039
     C                   PARM                    DPMVTrno          6                          CSE039
      *
      ** Received parameters
      ** -------------------
      *
      ** Transaction Details
      ** Transaction Status
      ** Security Status
      ** Transaction Screen Format
      ** Exchange Rate
      ** M/D Indicator
      ** Portfolio customer Indicator
      ** Fields in Error
      *
     C                   PARM                    DDTranSts
     C                   PARM                    DDSecSts
     C                   PARM                    NwScrnRec
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    PortCusInd        1
     C                   PARM                    PBCusInd                                     222373
     C                   PARM                    PBFieldInd                                   222373
     C                   PARM                    OKIndFile
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Disable Key & Detail Fields
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      ** Disable Function Keys
      ** KG = Comamnd Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KN = Command Key 14 = Settlement Details
      ** KP = Command Key 15 = Browse
      *
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKN            1
     C                   PARM      'N'           @EINKP            1
      *
      ** Succesful Insert Deal
      *
     C                   PARM                    @SIDN             6
      *
      ** Output Parameters
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    CGL031                                       CGL031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *InzSR        BEGSR
      *
     C     *Entry        PLIST
     C                   PARM                    PACT              1
     C                   PARM                    PREF              6
     C                   PARM                    PBKBR             3
     C                   PARM                    PORBR             3
     C                   PARM                    PMOVT             2
     C                   PARM                    PRETC             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVSIN'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
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
     C                   MOVEL     '903'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   MOVEL     ' '           PortCusInd        1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
