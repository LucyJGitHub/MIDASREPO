     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade display - other details screen')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Trading Module                          *
      *                                                               *
      *  SETRADODSP - SECURITIES TRADES DISPLAY - Other Detail Screen *
      *                                                               *
      *  Function:  This module displays the Other details screen of  *
      *             the Securites input function, i.e.                *
      *             - Exchange Rates                                  *
      *             - Settlements                                     *
      *             - Charges & Commissions                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE039             Date 04Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 07Jul00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      *                 CPB001             Date 10Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income                          *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CSE039 - Auto-settlement of trades                           *
      *         - Recompiled due to change in SETRSEPD                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE016 - Extended Security Descriptions                      *
      *  178695 - Protect Amend of Portfolio Reference                *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over changes to /COPY       *
      *           MSGHNDDCL.                                          *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSETRADODF CF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
                                                                                178695
      ** SE Trades Authorisation                                                178695
     FTRAUT     IF   E           K DISK    Infsr(*pssr)                         178695

      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       70  Protect trade detail fields                         *
      *                                                               *
      *       61  Protect pay from branch                             *
      *       62  Protect pay to branch                               *
      *       63  Protect portfolio reference                         *
      *       64  Protect FX margin                                   *
      *       65  Protect Settlement Instructions                     *
      *       66  Protect Delivery Instructions                       *
      *       67  Protect Charges & Commissions details               *
      *       68  Protect 'In' Currency in Field 72                   *
      *       69  Protect Exchange rate and M/D ind                   *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centre not used                              *
      *       83  Bulk input option not used                          *
      *       84  Autocharge option not used                          *
      *       85  Portfolio management not used                       *
      *       86  EMU SE Settlement Ccy Conv. not installed.          *
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

     D @EIX            DS
     D  @EI                    1     60
     D                                     DIM(60)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS

      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)

      ** EXTERNAL DS FOR Portfolio Management DETAILS
     D SDPORT        E DS                  EXTNAME(SDPORTPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D @T1_CLTY      E                     EXTFLD(DDCLTY)
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
     D TrExch        E DS                  EXTNAME(SETREXPD)
     D TrSett        E DS                  EXTNAME(SETRSTPD)
     D TrChCm        E DS                  EXTNAME(SETRCCPD)

     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL031
     D CGL031          S              1                                                       CGL031

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
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C     @INKC         IFEQ      '1'
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
     C                   EVAL      @EIX = (OKTrExch+ OKTrSett+ OKTrChCm)
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
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



      ** If single branch or if purchase protect "Pay to" Branch
      ** If single branch or if sale protect "Pay from" Branch
      *
     C                   MOVE      '0'           *IN61
     C                   MOVE      '0'           *IN62
     C     BJSBRC        IFEQ      *BLANK
     C     DDTDTP        IFEQ      'TS'
     C                   MOVE      '1'           *IN61
     C                   ELSE
     C                   MOVE      '1'           *IN62
     C                   END
     C                   ELSE
     C                   MOVE      '1'           *IN61
     C                   MOVE      '1'           *IN62
     C                   END
      *
      *  If date made complete is prior to run date
      *  or if not portfolio customer
      *  or bank portfolios
      *  Protect portfolio reference
      *
     C*****              MOVE      '0'           *IN63                          178695
     C*****DDACTN        IFEQ      'A'                                          178695
     C*****DDACTN        OREQ      'C'                                          178695
     C*****BJRDNB        IFGT      CurTDMC                                      178695
     C*****CurTINC       ANDEQ     'C'                                          178695
     C*****              MOVE      '1'           *IN63                          178695
     C*****              END                                                    178695
     C*****              END                                                    178695
      *                                                                         178695
      *  Authorisation level equal to 00                                        178695
      *  Protect Portfolio Reference if Action code 'A' or 'C' and Trad Comp.   178695
     C     BVAUTH        Ifeq      '00'                                         178695
     C     DDACTN        Ifeq      'A'                                          178695
     C     CurTINC       Andeq     'C'                                          178695
     C     DDACTN        Oreq      'C'                                          178695
     C     CurTINC       Andeq     'C'                                          178695
     C                   Move      True          *IN63                          178695
     C                   Endif                                                  178695
     C                   Endif                                                  178695
      *                                                                         178695
      *  Authorisation level not equal to 00                                    178695
      *  Check if Trade has been authorised to protect Portfolio Reference      178695
     C     BVAUTH        Ifne      '00'                                         178695
     C     DDACTN        Andeq     'A'                                          178695
     C     BVAUTH        orne      '00'                                         178695
     C     DDACTN        Andeq     'C'                                          178695
     C     DDTDRF        Setll     TRAUT                                        178695
     C     DDTDRF        Reade     TRAUT                                  89    178695
     C                   Move      'N'           W_Found           1            178695
                                                                                178695
     C     *in89         Doweq     False                                        178695
     C     W_found       Andeq     'N'                                          178695
     C     TATYP         Ifeq      'AU'                                         178695
     C                   Move      True          *in63                          178695
     C                   Move      'Y'           W_Found                        178695
     C                   Endif                                                  178695
     C     DDTDRF        Reade     TRAUT                                  89    178695
     C                   Enddo                                                  178695
     C                   Endif                                                  178695
                                                                                178695
     C     CustPM        IFNE      'Y'
     C     CustPB        ANDNE     'Y'                                          CPB001
     C     FCPORS        OREQ      'B'
     C     CustPB        ANDNE     'Y'                                          CPB001
     C                   MOVE      '1'           *IN63
     C                   END
      *
      * If settlement currency = nominal currency
      * Protect FX Margin Points
      *
     C                   MOVE      '0'           *IN64
     C     DDSETC        IFEQ      NMCY
     C                   MOVE      '1'           *IN64
     C                   END
      *
      * Protect Settlement Instructions and Delivery Instructions
      *
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C     CustClass     IFEQ      'I'
     C                   MOVE      '1'           *IN65
     C                   MOVE      '1'           *IN66
     C                   END
      *
      * If date made complete is prior to run date
      * Protect Delivery Instructions
      *
     C     DDACTN        IFEQ      'A'
     C     BJRDNB        ANDGT     CurTDMC
     C     CurTINC       ANDEQ     'C'
     C                   MOVE      '1'           *IN66
     C                   END
      *
      * Protect Charges & Commissions details
      *
     C                   MOVE      '0'           *IN67
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'C'
     C                   MOVE      '1'           *IN67
     C                   END
      *
      * CEU005 installed.
      * Protect 'In' Currency in Field 72
      *
     C                   MOVE      '0'           *IN68
     C     CEU005        IFEQ      'Y'
     C     DDTDTP        IFEQ      'TS'
     C     DDSETC        ORNE      BKEURO
     C                   MOVE      '1'           *IN68
     C                   END
     C                   END
      *
      * CEU005 installed.
      * Protect Exchange rate and M/D ind
      *
     C                   MOVE      '0'           *IN69
     C     CEU005        IFEQ      'Y'
     C     DDSETC        IFEQ      BKEURO
     C     NMCY          OREQ      BKEURO
     C                   MOVE      '1'           *IN69
     C                   END
     C                   END
      *
      * Protect all fields
      *
     C                   MOVE      *OFF          *IN70
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'C'
     C     DDACTN        WHENEQ    'A'
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     SETRADOS0
     C                   WRITE     SETRADOD1
     C                   WRITE     SETRADOF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SETRADOD1                              99    *
     C                   ENDIF
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
      *
      * Set clearance type on first screen
      *
     C                   MOVE      DDCLTY        @T1_CLTY
      *
     C                   ENDSR

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------

      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      * RETURN CODE
     C                   PARM                    RetCodeIn
      * TRADE (IN SCREEN FORMAT)
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    TrExch
     C                   PARM                    TrSett
     C                   PARM                    TrChCm
      *
      * Current trade incomplete ind and date made complete
     C                   PARM                    CurTINC           1
     C                   PARM                    CurTDMC           5 0
      *
      * Customer classification, Customer PM (Y/N) and nominal currency
      * And Private Banking Customer (Y/N)                                      CPB001
     C                   PARM                    CustClass         1
     C                   PARM                    CustPM            1
     C                   PARM                    NMCY              3
     C                   PARM                    CustPB            1            CPB001
      *                                                                         CSE023
      ** Withholding tax                                                        CSE023
      *                                                                         CSE023
     C                   PARM                    DDWTAX           15            CSE023
      * FIELDS IN ERROR
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChCm
      * Security report name
      * Countervalue
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *                                                                                       CGL031
      ** CGL031 Switchable Feature                                                            CGL031
      *                                                                                       CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM                    PBYSL             1                          CAP067
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKL             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADODSP'  DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
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
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 907*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Check if (CEU005) EMU SE Settlement Currency Conversion is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD             6
     C                   PARM                    DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF'
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVE      'N'           CEU005
     C                   END
      *                                                                         CSE023
      ** Check if (CSE023) Treaty withholding tax is on.                        CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
     C                   PARM                    DSFDY                          CSE023
      *                                                                         CSE023
      ** DATABASE ERROR                                                         CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '907'         DBASE                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVEL     'Y'           CSE023            1            CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023                         CSE023
     C                   ENDIF                                                  CSE023
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLAY INDICATORS
      * =========================================
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Originating Branches not used
      *
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   END
      *
      * Profit Centres not used (protect profit centre)
      *
     C     BGN0ST        IFEQ      'Y'
     C     BKPRCU        ORNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      ** Bulk input option not used (non display bulk ref)
      *
     C     BVBIOP        IFNE      'Y'
     C                   MOVE      '1'           *IN83
     C                   END
      *
      ** Autocharge option not used (protect charges 6,7)
      *
     C     BVACOP        IFNE      'Y'
     C                   MOVE      '1'           *IN84
     C                   END
      *
      ** Portfolio Management not installed
      ** Private Banking not installed                                          CPB001
      **   protect and non display portfolio
      *
     C     BGPFMG        IFNE      'Y'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '1'           *IN85
     C                   ELSE                                                   CPB001
     C                   MOVE      '0'           *IN85                          CPB001
     C                   END
      *
      ** EMU SE Settlement Currency Conversion not installed.
      *
     C     CEU005        IFNE      'Y'
     C                   MOVE      '1'           *IN86
     C                   END
      *                                                                         CSE023
      ** Treaty withholding tax is not installed.                               CSE023
      *                                                                         CSE023
     C     CSE023        IFNE      'Y'                                          CSE023
     C                   MOVE      '1'           *IN87                          CSE023
     C                   ENDIF                                                  CSE023

      *                                                                                       CAP067
      ** If Buy-sell back processing, write appropriate screen header                         CAP067
     C                   IF        PBYSL = 'Y'                                                CAP067
     C                   EVAL      *IN86 = *ON                                                CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      *IN86 = *OFF                                               CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CGL031
      ** CGL031 feature is installed.                                                         CGL031
      *                                                                                       CGL031
     C                   MOVE      *OFF          *IN77                                        CGL031
     C     CGL031        IFEQ      'Y'                                                        CGL031
     C                   MOVE      *ON           *IN77                                        CGL031
     C                   ENDIF                                                                CGL031

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
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
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
