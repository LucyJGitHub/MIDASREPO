     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input')                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMSIN - LE Fee Input                                     *
      *                                                               *
      *  Function:  This is the screens input function for Fee        *
      *             Input.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD031692           Date 12Mar20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 30Mar07               *
      *                 245099             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9496            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG2571            Date 13May04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA044             Date 25Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031692 - Incorrect accrual when fee rate is changed on     *
      *             payment date. Add warning message parameters in   *
      *             LEFEEMAMD.                                        *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244636 - If no settlement details for a fees are entered     *
      *           then default settlement details from related loan   *
      *  245099 - Pass CLE006 to LEFEEMAMD                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9496- Include CAS011 changes in GZLEFEED to align valids  *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG2571 - Include CSC022 and COM006 changes.                 *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *        (COM006) Wrong Return Code variable used in LEFEEMUPD. *
      *        (CSC022) Commitment Control Changes for MidasPlus.     *
      *  TDA044 - If Payment On field not specified, set Date of      *
      *           Receipt to Payment Start date.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ***  FILES  ***
      *
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
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
      *  Array for job name                                                                  BUG2571
     D ARRJBNAM        S             10A   DIM(10)                                           BUG2571
      *
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
      ***  Current Fee in File Format
 
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
     D                                     PREFIX(@)
      ***  Current Fee in Screen Format
 
     D ValidFeem     E DS                  EXTNAME(LEVFEEMPD)
     D QQOURS1       E                     EXTFLD(QQOURS)                                     CGL029
      ***  New Fee in file format
     D***VFRec**              294    362                                                      CGL029
     D***VFPay**              363    921                                                      CGL029
     D  VFRec                308    362                                                       CGL029
     D  VFPay                377    921                                                       CGL029
     D  VFRecEx             1076   1093                                                       CGL029
     D  VFPayEx             1094   1111                                                       CGL029
 
     D NwFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
      ***  New Fee in Screen Format
      *
 
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
      ***  Customer Loans record CL in file Format
 
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
      ***  Facility record FM in file Format
 
     D OKFee         E DS                  EXTNAME(LEEFEEMPD)
      ***  Error indicators Screen
 
     D F_REC         E DS                  EXTNAME(SDESFRPD)
      * File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
 
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
      * File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
 
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
      * File Fra/irs instructions
 
     D S_REC         E DS                  EXTNAME(SDESSRPD)
      * Screen Receive instructions
 
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      * Screen Payment instructions
 
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
      * Screen Fra/irs instructions
 
     D @CCI@           DS
      ***  Current control indicators for details screen
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3                                                  F7
     D  @EINKH                 4      4                                                  F8
     D  @EINKJ                 5      5                                                  F10
     D  @EINKK                 6      6                                                  F11
     D  @EINKN                 7      7                                                  F14
     D  @EINKP                 8      8                                                  F16
      *
     D @PCI@           DS             8
      ***  Previous control indicators for details screen
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
      *                                                                                      BUG2571
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2571
      ** Midas SC Jobs handling commitment control data area                                 BUG2571
     D  COMITNOM               1      3S 0                                                   BUG2571
     D  COMITJOB               4    103                                                      BUG2571
      *                                                                                      BUG2571
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** External DS for Lending ICD Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
     D ExtData       E DS                  EXTNAME(LEFEEXPD)
      ***  LE (FEEM) Extra Data - File (D/B) format
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF3MFPD)
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF4MFPD)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D                 DS
     D  @SIFEER                1     19
     D  @SICSSN                1      6
     D  @SIFACT                7      9
     D  @SIFCNO               10     11
     D  @SILNRF               12     17
     D  @SIFSEQ               18     19
      *
     D                 DS
     D PrvWarnAr               1     70
      *
     D                 DS
     D ChkWarnAr               1     70
      *
      ** +--------------------------------------+                                            BUG2571
      ** ¦ Use of Indicator                     ¦                                            BUG2571
      ** ¦ ================                     ¦                                            BUG2571
      ** |                                      |                                            BUG2571
      ** | 17      Used by LOOKUP               |                                            BUG2571
      ** +--------------------------------------+                                            BUG2571
                                                                                             BUG2571
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
     D CSC022          S              1A   INZ('N')                                          BUG2571
      ** Counter variable                                                                    BUG2571
     D WCMT01          S              1A                                                     BUG2571
      ** Commitment Flag                                                                     BUG2571
      *                                                                                       244636
      ** Parameter for LEFEEMRTV                                                              244636
     D PRcvParm        S             92                                                       244636
      *                                                                                       244636
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
     D WTRCcy          S              3A                                                     CSF011A
     D WTPCcy          S              3A                                                     CSF011A
                                                                                             CSF011A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFEEMS001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      /COPY WNCPYSRC,LEFEEMS002
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ***  Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      ***  Do while screen: Screen detail
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   END
      *
      ***  Do while screen: Settlement details
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   END
      *
      ***  Screen: Confirmation of input
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      ***  Do file updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      ***  Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - Process screen detail                                *
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      ***  Update 'previous' Fee & screen control indicator
      *
     C                   MOVEL     DDACTN        @PACTN            1
     C                   MOVEL     DDCSSN        @PCSSN           10
     C                   MOVEL     DDFACT        @PFACT            3
     C                   MOVEL     DDFCNO        @PFCNO            2
     C                   MOVEL     DDLNRF        @PLNRF            6
     C                   MOVEL     DDFSEQ        @PFSEQ            2
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen
      *
     C                   CALLB     'LEFEEMDSP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fee (in screen format)
     C                   PARM                    NwFeScnFmt
      *
      ***  Fields in error
      *
     C                   PARM                    OKFee
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFEER          19
      *
      ***  Feature
      *
     C                   PARM                    CLE006
      *
      ***  Feature
      *
     C                   PARM                    BKPRCA
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      *** Save array of warning messages already viewed:
     C                   MOVEA     WMsgIdArr     PrvWarnAr
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OKFee
      *
     C                   EXSR      RESET
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - Process screen: Settlement details evoked for        *
      *          inserts, amends, enquiries & authorizations          *
      *****************************************************************
     C     SCRN@S        BEGSR
 
     C                   MOVE      *BLANKS       WWLNRF            6
 
     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      WWLNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      WWLNRF = DDLNRF
     C                   END
      *
      ** Determine if pay settlement should be protected
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'Y'           ##PREC
     C                   ENDIF
 
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C     WPTFI         IFEQ      'P'
     C     WPTFI         OREQ      'S'                                                        CLE106
     C     WPTFI         OREQ      'R'                                                        CLE106
     C                   MOVE      'N'           ##PPAY
     C                   MOVE      'Y'           ##PREC
     C                   ENDIF
      *
     C     WPTFI         IFEQ      *BLANK
     C                   MOVE      'Y'           ##PPAY
     C                   MOVE      'N'           ##PREC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFNE      'I'
     C     WrkDftSettl   OREQ      'Y'
      *
      ***  Set up payment instructions
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     VFPay         F_Pay                                        CGL029
     C                   MOVEL     VFPay         FLPay                                        CGL029
     C                   MOVEL     VFPayEx       FLPONS                                       CGL029
     C                   MOVEL     VFPSTM        FLPSTM                                       CGL029
     C                   MOVEL     VFCVMR        FLCVMR
     C                   MOVEL     VFSCCY        FLPSCY
     C                   MOVEL     VFICCY        FLIC72
      *
      ***  Set up receive instructions
      ***  (on insertions, these fields will be zero/blank)
      *
     C**********         MOVEL     VFRec         F_Rec                                        CGL029
     C                   MOVEL     VFRec         FLRec                                        CGL029
     C                   MOVEL     VFRecEx       FLRONS                                       CGL029
     C                   MOVEL     VFRSTM        FLRSTM                                       CGL029
     C                   MOVEL     VFSCCY        FLRSCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     VFFEREXR      FLREXR                                       CLE031
     C                   Z-ADD     VFFEPEXR      FLPEXR                                       CLE031
     C                   MOVE      VFFEREXI      FLREXI                                       CLE031
     C                   MOVE      VFFEPEXI      FLPEXI                                       CLE031
     C                   MOVE      VFSCCY        FLRSCY                                       CLE031
     C                   MOVE      VFFEPSCY      FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDIF
      *
      ***  Determine parameters for settlement details input
      *
     C                   EXSR      DETP@S
      *
      ***  Settlement instructions input
      *
     C                   MOVE      *BLANKS       ##LNRF
     C     DDFACT        IFNE      *Zero
     C     DDFACT        ANDNE     *Blank
     C                   EVAL      ##LNRF = DDFACT + DDFCNO
     C                   ELSE
     C                   EVAL      ##LNRF = DDLNRF
     C                   END
 
     C                   EVAL      WTRCcy = DDECUR                                           CSF011A
     C                   EVAL      WTPCcy = DDECUR                                           CSF011A
     C                                                                                       CSF011A
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Inputs                                                               File Fmt
      *
     C                   PARM                    F_Pay                          File paym settl inst
     C                   PARM                    F_Rec                          File Recei Sett Inst
     C                   PARM      *BLANK        F_Fri                          FRA/IRS Settl. Instr
      *
      ***  Outputs                                                              Screen Fmt
      *
     C                   PARM      *BLANK        S_Pay                          Paym settl. inst Scr
     C                   PARM      *BLANK        S_Rec                          Recei settl inst Scr
     C                   PARM      *BLANK        S_Fri                          FRA/IRS Sett inst
     C                   PARM      WTRCcy        #TRCCY                                      CSF011A
     C                   PARM      WTPCcy        #TPCCY                                      CSF011A
      *
      *
     C                   CALLB     'ZASETINSIN'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        ##RTCD           10
      *
      ***  Action code
      *
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Loan number
      *
     C                   PARM                    ##LNRF            6
      *
      ***  Protect Payment
      *
     C                   PARM                    ##PPAY            1
      *
      ***  Protect Receive
      *
     C                   PARM                    ##PREC            1
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDECUR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDECUR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCSSN        ##CSSN           10
      *
      ***  Transaction Type
      *
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Booking branch
      *
     C                   PARM      FEBRCA        ##BRCA            3
      *
      ***  Receipt Date
      *
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
      *
     C                   PARM                    ##DATP            5 0
      *
      ***  Payment instructions
      *
     C                   PARM                    S_PAY
      *
      ***  Receive instructions
      *
     C**********         PARM                    S_REC                                        244636
     C                   PARM      PRcvParm      S_REC                                        244636
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    S_FRI
      *
      ***  Outputs
      *
      ***  Payment instructions
      *
     C                   PARM                    F_Pay
      *
      ***  Receive instructions
      *
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    F_FRI
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
      *
     C                   PARM      '0'           @INKK             1                        MD036070
     C                   PARM      '0'           @INKL             1
      *
      ***  Extra validation
      *
     C                   CALLB     'LEFEEMEVL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode
      * Fee detail file
     C                   PARM                    CrFeFilFmt
      * Fee detail screen
     C                   PARM                    NwFeScnFmt
      * Fee Valid file
     C                   PARM                    ValidFeem
      * CEU004
     C                   PARM                    CEU004
      * Payment instructions
     C                   PARM                    F_Pay
      *
      *  Receive instructions
     C                   PARM                    F_REC
      *
      *  FRA/IRS instructions
     C                   PARM                    F_FRI
 
      * OUTPUTS
 
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on settlement details
      *
     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S
      *
      ***  Exit from settlement details
      *
     C                   CAS                     EXIT@S
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETP@S - Determine parameters for settlement details screen   *
      *****************************************************************
     C     DETP@S        BEGSR
 
      * Validate settlement account against Fee payment date:
     C     VFPYON        IFEQ      'S'
     C     VFPYON        OREQ      ' '                                                        TDA044
     C                   MOVE      VFPSTD        ##DATR
     C                   MOVE      VFPSTD        ##DATP
     C                   ENDIF
      *
     C     VFPYON        IFEQ      'N'
     C                   MOVE      VFNPYD        ##DATR
     C                   MOVE      VFNPYD        ##DATP
     C                   ENDIF
      *
     C     VFPYON        IFEQ      'E'
     C                   MOVE      VFPEND        ##DATR
     C                   MOVE      VFPEND        ##DATP
     C                   ENDIF
      *
      ***  If amend, enquire, authorize or delete
      ***  move settlement file fields to screen fields
      ***  Else clear settlement screen fields
 
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'D'
      *
      ***  SET UP PAYMENT INSTRUCTIONS
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     VFPAY         F_Pay                                        CGL029
     C                   MOVEL     VFPAY         FLPay                                        CGL029
     C                   MOVEL     VFPAYEx       FLPONS                                       CGL029
     C                   MOVEL     VFPSTM        FLPSTM                                       CGL029
     C                   MOVE      VFOSBR        FLPOBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     VFSCCY        FLPSCY
     C                   MOVEL     VFICCY        FLIC72
     C                   Endif
      *
      *** SET UP RECEIVE INSTRUCTIONS
      *** (ON INSERTIONS, THESE FIELDS WILL BE ZERO/BLANK)
      *
     C**********         MOVEL     VFRec         F_Rec                                        CGL029
     C                   MOVEL     VFRec         FLRec                                        CGL029
     C                   MOVEL     VFRecEx       FLRONS                                       CGL029
     C                   MOVEL     VFRSTM        FLRSTM                                       CGL029
     C                   MOVE      VFOSBR        FLROBR
     C                   if        CEU004 = 'Y'
     C                   MOVEL     VFSCCY        FLRSCY
     C                   endif
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     VFFEREXR      FLREXR                                       CLE031
     C                   Z-ADD     VFFEPEXR      FLPEXR                                       CLE031
     C                   MOVE      VFFEREXI      FLREXI                                       CLE031
     C                   MOVE      VFFEPEXI      FLPEXI                                       CLE031
     C                   MOVE      VFSCCY        FLRSCY                                       CLE031
     C                   MOVE      VFFEPSCY      FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ELSE                                                                    x1
      *
      * IF SETTLEMENT INSTRUCTIONS ARE NOT DEFINED, DEFAULT THEM
      *
     C     WrkDftSettl   IFEQ      'Y'
     C     FLPSTM        IFEQ      *ZERO                                                         b2
     C     ##PPAY        ANDNE     'Y'
     C     FLRSTM        OREQ      *ZERO
     C     ##PREC        ANDNE     'Y'
      *
     C                   CALLB     'ZASETINDFT'
      *
      ***  Inputs
      *
      ***  Calling program
      *
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
      *
     C                   PARM      DDECUR        ##PCCY            3
      *
      ***  Receive currency
      *
     C                   PARM      DDECUR        ##RCCY            3
      *
      ***  Customer shortname
      *
     C                   PARM      DDCSSN        ##CSSN           10
      *
      ***  Ts Type
      *
     C                   PARM      *BLANKS       ##TTYP            2
      *
      ***  Federal Funds Ind.
      *
     C                   PARM      *BLANK        ##FFND            1
      *
      ***  Version of ISDA Rules govern
      *
     C                   PARM                    BQISDA            4
      *
      ***  Type of ISDA agreement
      *
     C                   PARM                    BQAGTY            6
      *
      ***  Date of ISDA Agreement
      *
     C                   PARM                    BQAGDT            6
      *
      ***  Version of ISDA Agreement
      *
     C                   PARM                    BQAGVV            2
      *
      ***  Version of ISDA Agreement century
      *
     C                   PARM                    Blank2            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ***  OUTPUTS
      *
      ***  Payment instructions
      *
     C                   PARM                    F_Pay
      *
      ***  Receive instructions
      *
     C                   PARM                    F_REC
      *
      ***  FRA/IRS instructions
      *
     C                   PARM                    F_FRI
      *
      * Clear payment instructions if protected
      *
     C     ##PPAY        IFEQ      'Y'
     C                   CLEAR                   F_Pay
     C                   Z-ADD     *ZERO         FLPSTM
     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
     C                   ENDIF
      *
      * Clear receipt instructions if protected
      *
     C     ##PREC        IFEQ      'Y'
     C                   CLEAR                   F_REC
     C                   Z-ADD     *ZERO         FLRSTM
     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
     C                   EVAL      FLROBN = *BLANKS                                           CSD027
     C                   EVAL      FLROCN = *BLANKS                                           CSD027
     C                   ENDIF
     C                   ENDIF
      *
     C                   END                                                                      e2
      *
     C                   END                                                                   e1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      *
     C/COPY WNCPYSRC,LEFEEMSC04
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C/COPY WNCPYSRC,LEFEEMSC05
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - Exit from settlement details screen                  *
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     ##RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
     C                   MOVEL     'Y'           Valid_Set         1
      *
      * UPDATE VALID Fee : PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLPAY         VFPAY
     C                   MOVEL     FLPONS        VFPAYEx                                      CGL029
     C                   MOVEL     FLPSTM        VFPSTM                                       CGL029
     C                   MOVEL     FLPOBR        VFOMDB
     C                   MOVEL     FLCVMR        VFCVMR
      *
      * UPDATE VALID FEE : RECEIPT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     FLREC         VFREC
     C                   MOVEL     FLRONS        VFRECEx                                      CGL029
     C                   MOVEL     FLRSTM        VFRSTM                                       CGL029
     C                   MOVEL     FLROBR        VFOSDB
      *
      * UPDATE VALID FEE : SETTLEMENT CURRENCY & 'IN' CCY IN FIELD 72
      *
     C                   MOVEL     FLPSCY        VFSCCY
     C                   MOVEL     FLIC72        VFICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        VFFEREXR                                     CLE031
     C                   Z-ADD     FLPEXR        VFFEPEXR                                     CLE031
     C                   MOVE      FLREXI        VFFEREXI                                     CLE031
     C                   MOVE      FLPEXI        VFFEPEXI                                     CLE031
     C                   MOVE      FLRSCY        VFSCCY                                       CLE031
     C                   MOVE      FLPSCY        VFFEPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESET  - Reset errors                                         *
      *****************************************************************
     C     RESET         BEGSR
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to detail screen                      *
      *****************************************************************
     C     VAL@M         BEGSR
      *
      ***  If action code and Fee ref are blank
      ***  Re-output screen
      *
     C     DDACTN        IFEQ      *BLANKS
     C     DDCSSN        ANDEQ     *BLANKS
     C     DDFACT        ANDEQ     *BLANKS
     C     DDFCNO        ANDEQ     *BLANKS
     C     DDLNRF        ANDEQ     *BLANKS
     C     DDFSEQ        ANDEQ     *BLANKS
     C                   GOTO      EVAL@M
     C                   END
      *
      ***  Retrieve Fee details
      *
     C                   EXSR      RTVFee
      *
      ***  If action code or Fee ref are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C     DDLNRFOK      OREQ      'N'
     C     DDFSEQOK      OREQ      'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      ***  Set field and function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  If action code is delete, enquire or authorize
      ***  or action code is amend and Fee ref has changed
      ***  Put the Fee on the main screen
      *
     C     DDACTN        IFEQ      'D'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDCSSN        ANDNE     @PCSSN
     C     DDACTN        OREQ      'A'
     C     DDFACT        ANDNE     @PFACT
     C     DDACTN        OREQ      'A'
     C     DDFCNO        ANDNE     @PFCNO
     C     DDACTN        OREQ      'A'
     C     DDACTN        ANDNE     @PACTN
     C     DDACTN        OREQ      'A'
     C     DDLNRF        ANDNE     @PLNRF
     C     DDACTN        OREQ      'A'
     C     DDFSEQ        ANDNE     @PFSEQ
     C                   EXSR      PUTD@M
     C                   END
      *
      ***  If Fee ref or screen control indicators have changed
      ***  Re-output screen
      *
     C     DDCSSN        IFNE      @PCSSN
     C     DDACTN        ANDNE     'I'
     C     DDFACT        ORNE      @PFACT
     C     DDACTN        ANDNE     'I'
     C     DDFCNO        ORNE      @PFCNO
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ORNE      @PACTN
     C     DDACTN        ANDNE     'I'
     C     DDLNRF        ORNE      @PLNRF
     C     DDACTN        ANDNE     'I'
     C     DDFSEQ        ORNE      @PFSEQ
     C     DDACTN        ANDNE     'I'
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If Delete
      *
     C     DDACTN        IFEQ      'D'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If enquire
      *
     C     DDACTN        IFEQ      'E'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
      *
      ***  If browse outstanding, read next browse subfile record
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   END
      *
     C                   END
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
      * Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
     C                   GOTO      EVAL@M
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKFee
     C                   CLEAR                   ValidFeem
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Validate whether non-amendable fields have been changed
      *
     C                   MOVEL     CrFeFilFmt    ValidFeem
      *
     C                   CALLB     'LEFEEMAMD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Fee in Screen Format
     C                   PARM                    NwFeScnFmt
      *
      * Current Fee in Screen Format
     C                   PARM                    CrFeScnFmt
      *
      * Fee - file formats
     C                   PARM                    ValidFeem
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *                                                                                       245099
     C                   PARM                    CLE006                                       245099
      *                                                                                     MD031692
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD031692
      *                                                                                     MD031692
     C                   PARM                    WFldNamArr                                 MD031692
     C                   PARM                    WMsgIDArr                                  MD031692
     C                   PARM                    WMsgDtaArr                                 MD031692
      *                                                                                     MD031692
      ** Array index (3P0) from/to caller                                                   MD031692
      *                                                                                     MD031692
     C                   PARM                    WIdx                                       MD031692
     C                   END
      *
      * Validate Fee details
      *
      *
     C                   CALLB     'LEFEEMVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Transaction Details
     C                   PARM                    NwFeScnFmt
      ** Settlement instructions
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_Fri
      ** Current Fee file
     C                   PARM                    CrFeFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      ** Loan CL file format
     C                   PARM                    ClilFilFmt
      * Facility FM in file format
     C                   PARM                    FacmFilFmt
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      * CLE006
     C                   PARM                    CLE006            1
      * CEU004
     C                   PARM                    CEU004            1
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F3PCOB            3
     C                   PARM                    F3TNRF           15
     C                   PARM                    F3IUSR           10
     C                   PARM                    F3XUSR           10
     C                   PARM                    F3AUSR           10
     C                   PARM                    F3TRDS            8
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
 
      * OUTPUTS
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFee
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
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidFeem
      *
     C                   MOVEL     *BLANKS       ChkWarnAr
     C                   MOVEA     WMsgIdArr     ChkWarnAr
      *
      ***  If errors returned
      ***  or warnings that have not yet been seen:
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C     ChkWarnAr     ANDNE     PrvWarnAr
     C                   GOTO      EVAL@M
     C                   END
      *
      * Internal Fees do not require settlement instructions.
     C     WPTFI         IFEQ      'I'
     C                   MOVEL     'C'           @SCRN
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
 
      * If Settlement screen has not yet been validated:
     C     Valid_Set     IFNE      'Y'
     C                   MOVE      'Y'           WrkDftSettl       1            def Settl instr. 'I'
     C                   ELSE
     C                   MOVE      'N'           WrkDftSettl       1
     C                   ENDIF
     C                   END
     C                   END
      *
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through Fee file
      *****************************************************************
     C     ROLL          BEGSR
      *
      ***  Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      ***  Read next or previous record on Fee file
      ***  according to command key taken (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'LEFEEMRED'
      ***  INPUT PARAMETERS
      *
      ***  RETURN CODE
     C                   PARM                    RetCodeIn
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ***  Action code
     C                   PARM                    DDACTN            1
      *
      ***  Fee ref pointer
     C                   PARM                    DDCSSN           10
      *
      ***  Fee ref pointer
     C                   PARM                    DDFACT            3
      *
      ***  Fee ref pointer
     C                   PARM                    DDFCNO            2
      *
      ***  Fee ref pointer
     C                   PARM                    DDLNRF            6
      *
      ***  Fee ref pointer
     C                   PARM                    DDFSEQ            2
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Fee ref pointer
     C                   PARM                    @CNUMR            6
      *
      ***  Fee ref pointer
     C                   PARM                    @FACTR            3
      *
      ***  Fee ref pointer
     C                   PARM                    @FCNOR            2
      *
      ***  Fee ref pointer
     C                   PARM                    @LNRFR            6
      *
      ***  Fee ref pointer
     C                   PARM                    @FSEQR            2
      *
      ***  Front Office Fee Read
     C                   PARM                    @FTRED           20
      *
      ***  If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   END
      *
      ***  If Fee read
      *
     C     @CNUMR        IFNE      *BLANK
      *
      ***  Retrieve Fee details
      *
     C                   MOVEL     @CNUMR        DDCSSN
     C                   MOVEL     @FACTR        DDFACT
     C                   MOVEL     @FCNOR        DDFCNO
     C                   MOVEL     @LNRFR        DDLNRF
     C                   MOVEL     @FSEQR        DDFSEQ
     C                   EXSR      RTVFee
      *
      ***  Set field and function key status on main details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Fee on the main details screen
      *
     C                   EXSR      PUTD@M
      *
      ***  Go to detail screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   MOVEL     'Y'           WrkDftSettl
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build browse subfile                                 *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Save the screen fields
      *
     C                   MOVEL     DDACTN        StoreAC           1
     C                   MOVEL(P)  DDCSSN        WSDDCSSN         10
     C                   MOVEL(P)  DDFACT        WSDDFACT          3
     C                   MOVEL(P)  DDFCNO        WSDDFCNO          2
     C                   MOVEL(P)  DDLNRF        WSDDLNRF          6
     C                   MOVEL(P)  DDFSEQ        WSDDFSEQ          2
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEFEEMBRW'
      *
      ***  INPUT parameters.
      *
      ***  Return code.
     C                   PARM                    RetCodeIn
      *
      ***  Action code.
     C                   PARM                    DDACTN
      *
      ***  Fee pointer.
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDLNRF
     C                   PARM                    DDFSEQ
      *
      ***  Build sub-file.
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read sub-file record.
     C                   PARM      *Blanks       @RDSFL            1
      *
      ***  OUTPUT parameters.
      *
      ***  Error message.
     C                   PARM                    @ERRMS            7
      *
      ***  Option selected.
     C                   PARM                    @OPSEL            1
      *
      ***  Fee selected.
     C                   PARM                    @CUSEL            6
     C                   PARM                    @FASEL            3
     C                   PARM                    @FCSEL            2
     C                   PARM                    @LNSEL            6
     C                   PARM                    @FSSEL            2
      *
      ***  Command keys.
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Restore the screen fields
      *
     C                   MOVEL     StoreAC       DDACTN
     C                   MOVEL(P)  WSDDCSSN      DDCSSN
     C                   MOVEL(P)  WSDDFACT      DDFACT
     C                   MOVEL(P)  WSDDFCNO      DDFCNO
     C                   MOVEL(P)  WSDDLNRF      DDLNRF
     C                   MOVEL(P)  WSDDFSEQ      DDFSEQ
      *
      ***  If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If CK/12 not taken in browse
      ***  Read next browse subfile record
      *
     C     @INKL         IFEQ      '0'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVE      '0'           @INKL
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record                      *
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LEFEEMBRW'
      *
      ***  INPUT parameters.
      *
      ***  Return code.
     C                   PARM                    RetCodeIn
      *
      ***  Action code.
     C                   PARM                    DDACTN
      *
      ***  Fee pointer.
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDLNRF
     C                   PARM                    DDFSEQ
      *
      ***  Build sub-file.
     C                   PARM      *Blanks       @BDSFL
      *
      ***  Read sub-file record.
     C                   PARM      'Y'           @RDSFL
      *
      ***  OUTPUT parameters.
      *
      ***  Error message.
     C                   PARM                    @ERRMS
      *
      ***  Option selected.
     C                   PARM                    @OPSEL
      *
      ***  Fee selected.
     C                   PARM                    @CUSEL
     C                   PARM                    @FASEL
     C                   PARM                    @FCSEL
     C                   PARM                    @LNSEL
     C                   PARM                    @FSSEL
      *
      ***  Command keys.
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *
      *
      ***  If Fee read from subfile
      *
     C     @CUSEL        IFNE      *BLANKS
     C     @OPSEL        ANDNE     *BLANKS
      *
      ***  Retrieve Fee details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @CUSEL        DDCSSN
     C                   MOVEL     @FASEL        DDFACT
     C                   MOVEL     @FCSEL        DDFCNO
     C                   MOVEL     @LNSEL        DDLNRF
     C                   MOVEL     @FSSEL        DDFSEQ
     C                   EXSR      RTVFee
      *
      ***  Set field and function key status on first details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      ***  Put the Fee on the appropriate detail screen
      *
     C                   EXSR      PUTD@M
      *
      ***  Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   END
      *
      ***  Go to appropriate detail screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   MOVE      *OFF          @INKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFee  - Retrieve Fee                                        *
      *****************************************************************
     C     RTVFee        BEGSR
      *
      ***  Retrieve Fee
      *
     C                   CALLB     'LEFEEMRTV'
 
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Loan number
     C                   PARM                    DDLNRF            6
      * (Midas) Fee Sequence
     C                   PARM                    DDFSEQ            2
      *
      * CSC011 processing date
     C                   PARM                    WRNDAY
 
      * OUTPUTS
      * (Current) Fee in file format
     C                   PARM                    CrFeFilFmt
      * Loan CL in file format
     C                   PARM                    ClilFilFmt
      * Fclty FM in file format
     C                   PARM                    FacmFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
      * OK - Loan number
     C                   PARM                    DDLNRFOK          1
      * OK - Fee sequence
     C                   PARM                    DDFSEQOK          1
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      * Expiry date
     C                   PARM                    WDTEX             5 0
      * Facility amount
     C                   PARM                    WFAMT            13 0
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *Zero         Ix
     C                   PARM                    PRcvParm                                     244636
      *
     C                   Z-ADD     FETNLU        H#TNLU            5 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a Fee on the detail screen                       *
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      ***  Call program to fill screen fields with data from Fee file
      *
     C                   CALLB     'LEFEEMCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Fee in file formats
     C                   PARM                    CrFeFilFmt
      *
      * Loan in file formats
     C                   PARM                    ClilFilFmt
      *
      * Fclty in file formats
     C                   PARM                    FacmFilFmt
      *
      * CLE006
     C                   PARM                    CLE006            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      *
      * Output parameters
      *
      * Fee in screen format
     C                   PARM                    NwFeScnFmt
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI
      *
      ***  Update 'Current' Fee   with Fee   in Screen Format
      *
     C                   MOVEL     NwFeScnFmt    CrFeScnFmt
 
      * Do not activate F14 (Settlement Instructions) if Internal Fee:
     C     WPTFI         IFEQ      'I'
     C                   MOVEL     'N'           @EINKN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - Set field status on details screen                   *
      *          according to action code                             *
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      ***  Enable/disable key & detail fields on details screen
      ***  (key fields = action code & Fee ref; detail fields = rest)
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - Set function key status on details screens           *
      *                according to action code                       *
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      ***  Enable/disable function keys on details screen
      *
      ***  KG = Command key 07 = Previous
      *
     C                   MOVEL     'Y'           @EINKG
      ***  KH = Command key 08 = Next
      *
     C                   MOVEL     'Y'           @EINKH
      *
      ***  KJ = Command Key 10 = Delete
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  KK = Command Key 11 = Authorise
      *
     C     DDACTN        IFEQ      'X'
     C     BPAURV        ANDNE     'Y'
     C                   MOVEL     'Y'           @EINKK
     C                   ELSE
     C                   MOVEL     'N'           @EINKK
     C                   END
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I, A, X display settlement details automatically)
      * (No further screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      ***  KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - Initialize field status on details screen            *
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      ***  Enable key & details fields
      *
     C                   MOVEL     'Y'           @EKYFD
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'I'
     C     DDACTN        OREQ      *BLANKS
     C                   MOVEL     'Y'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - Initialize function key status on detail  screen     *
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      ***  Enable/disable function keys on details screens
      *
      * KG = Command key 07 = Read previous
      * KH = Command key 08 = Read next
      * KJ = Command key 10 = Delete
      * KK = Command key 11 = Authorise
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'N'           @EINKK
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'A'
     C                   MOVEL     'Y'           @EINKP
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - Cancel on detail  screen                             *
      *****************************************************************
     C     CANC@M        BEGSR
      *
      ***  Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      ***  If input fields are enabled
      ***  Blank the first details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NwFeScnFmt
     C                   END
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a message to detail  screen                     *
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      ***  If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'LEF0009'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ***  Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LER0350'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEFEEMDSP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fee (in screen format)
     C                   PARM                    NwFeScnFmt
      *
      ***  Fields in error
      *
     C                   PARM                    OKFee
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM      'N'           @EINKP
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFEER
      *
      ***  Feature
      *
     C                   PARM                    CLE006
      *
      ***  Feature
      *
     C                   PARM                    BKPRCA
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKK             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      'N'           WriteOnly         1
      *
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OKFee
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen                        *
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to detail screen
      *
     C                   MOVEL     'M'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@M
      *
      ***  Set function key status on detail screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen                        *
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
     C     WIdx          ANDEQ     *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  else, return to main detail screen
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@M
      *
      ***  Set function key status on detail screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates                                              *
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ***  Update valid Fee : Fee Ref
      *
     C                   MOVEL     DDCSSN        VFCNUM
     C                   MOVEL     DDFACT        VFFACL
     C                   MOVE      DDFCNO        VFFACL
     C                   MOVEL     DDLNRF        VFLOAN
      *
      ** Restore Seq.number if Insert mode
     C     DDACTN        IFEQ      'I'
     C     DDFSEQ        ANDEQ     *BLANKS
     C                   MOVEL     WWFSEQ        DDFSEQ
     C                   END
 
     C                   MOVEL     DDFSEQ        VFFSEQ
      *
      ***  Update valid Fee  : Last action code
      *
     C                   MOVEL     DDACTN        VFLCHT
      *
      ** Send the confirmation message only in Insert mode
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     DDCSSN        @SICSSN
     C                   MOVEL     DDFACT        @SIFACT
     C                   MOVEL     DDFCNO        @SIFCNO
     C                   MOVEL     DDLNRF        @SILNRF
     C                   MOVEL     DDFSEQ        @SIFSEQ
     C                   END
      *
      ***  Fee updates
      *
     C     @RTCD         IFEQ      *BLANK
      *
     C                   CALLB     'LEFEEMUPD'
     C                   PARM      *Blanks       @RTCD             7                         BUG2571
     C**********         PARM                    @@RTCD            7                         BUG2571
     C                   PARM                    P#MODE            1
     C                   PARM                    ValidFeem
     C                   PARM                    CrFeFilFmt                                  BUG3760
     C                   PARM                    CLE002            1
     C                   PARM                    CSC011            1
     C                   PARM                    BPFEAU            1
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU            5 0
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OKFee
      * Fee sequence
     C                   PARM                    WWFSEQ            2 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Wx                3 0
 
     C                   END
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*RECUPD'
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C                   ROLBK
     C                   ELSE                                                                BUG2571
     C     WCMT01        IFNE      'Y'                                                       BUG2571
     C                   ROLBK                                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                       BUG2571
     C     WCMT01        OREQ      'N'                                                       BUG2571
     C     CSC022        ANDEQ     'Y'                                                       BUG2571
     C                   COMMIT
     C                   ENDIF                                                               BUG2571
     C                   END
      *
      ***  If update not done due to record being updated by another
      ***  workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LER0351'     MsgIdArr(1)
     C                   END
 
      * Set up the sequence number for the confirmation message
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     WWFSEQ        @SIFSEQ
     C                   MOVEL     *BLANKS       WWFSEQ
     C                   END
 
      * Blank all details screen
      *
     C                   MOVEL     *BLANKS       NwFeScnFmt
      *
      ***  Initialize field and function key status on detail screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to detail screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program                                            *
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Receive entry parameters
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFEEMSIN'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      **  ACCESS CUSTOMER LENDING DATA
     C                   CALL      'AOCLNDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSFDY
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C* Is the support system on?
     C     S1SUPP        IFEQ      LIBR
     C                   Z-ADD     S1DATE        WRNDAY            6 0
     C                   ELSE
     C                   MOVE      BJRDNB        WRNDAY
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Determine if CEU004 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU004            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU004
     C                   ENDIF
      *
      ***  Start with the Main detail screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      ***  Initialize field and function key status on detail screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
     C                   MOVE      *BLANKS       @RTCD
 
      *
      ***  Hook to enable non-core initial processing to be included
      *
      * Determine if CSC022 is switched on                                                   BUG2571
                                                                                             BUG2571
     C                   CALLB     'AOSARDR0'                                                BUG2571
     C                   PARM      *BLANKS       @RTCD                                       BUG2571
     C                   PARM      '*VERIFY'     @OPTN                                       BUG2571
     C                   PARM      'CSC022'      @SARD                                       BUG2571
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG2571
     C                   IF        @RTCD = *BLANK                                            BUG2571
     C                   EVAL      CSC022 ='Y'                                               BUG2571
     C                   EVAL      WCMT01 ='N'                                               BUG2571
      * SCCMTJOB data area                                                                   BUG2571
     C                   IN        SCCMTJOB                                                  BUG2571
      * Move data area to commitment array                                                   BUG2571
     C                   IF        COMITNOM > 0                                              BUG2571
     C                   MOVEA     COMITJOB      ARRJBNAM                                    BUG2571
      *                                                                                      BUG2571
      * Check if PSJOBNAME exist.                                                            BUG2571
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                 BUG2571
     C                   IF        *IN17 = *ON                                               BUG2571
     C                   EVAL      WCMT01= 'Y'                                               BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
      *                                                                                      BUG2571
     C                   ELSE                                                                BUG2571
      * @rtcd not found                                                                      BUG2571
     C                   IF        @RTCD <> '*NRF'                                           BUG2571
     C     *LOCK         IN        LDA                                                       BUG2571
     C                   EVAL      DBPGM = 'LEFEEMSIN'                                       BUG2571
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2571
     C                   EVAL      DBFILE ='SCSARDPD'                                        BUG2571
     C                   EVAL      DBASE  = 004                                              BUG2571
     C                   OUT       LDA                                                       BUG2571
     C                   EXSR      *PSSR                                                     BUG2571
     C                   ENDIF                                                               BUG2571
     C                   ENDIF                                                               BUG2571
                                                                                             BUG2571
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     @RTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
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
(c) Finastra International Limited 2002
