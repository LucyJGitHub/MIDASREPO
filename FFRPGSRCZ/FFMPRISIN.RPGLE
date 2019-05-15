     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Screen Input')                  *
      *****************************************************************
      *                                                               *
      *  FFMPRISIN - Midas FF Market Prices Screen Input              *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for the FF Market Prices.                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245143             Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  245143 - Apply file overrides.                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
      ** Current Transaction Detail in File Format
     D CrMnFilFmt    E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(C_)
 
      ** Current Transaction  Detail in Screen Format
     D CurTrnDets    E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@)
 
      ** Current Transaction Detail in Screen Format at second screen
     D CurTrn@2nd    E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@K)
 
      ** New Transaction Detail in File Format
     D NwMnFilFmt    E DS                  EXTNAME(FFVMPRIPD)
 
      ** Previous Transaction Detail in Scrn Format
     D PrvTrnDets    E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@P)
 
      ** Error indicators
     D OKTrnDets     E DS                  EXTNAME(FFEMPRIPD)
 
      ** FF Extention data Market Price - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFMPEXPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D    SARLCD     E                     EXTFLD(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access progrmas, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for market prices key
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
     D @SCRED          DS
     D  @SCISTT                1      5
     D  @SCMRKT                1      2
     D  @SCISTC                3      5
     D  @SCMTHN                6      8
     D  @SCYRNO                9     10
     D  @SCPCAL               11     11
     D  @SCSTRP               12     27
 
     D @TRSEL          DS
     D  @TRISTT                1      5
     D  @TRMRKT                1      2
     D  @TRISTC                3      5
     D  @TRMTHN                6      8
     D  @TRYRNO                9     10
     D  @TRPCAL               11     11
     D  @TRSTRP               12     27
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Action Code
     D DDACTN          S              1A
 
     D PPRSTRP         S             15  8
     D PTransStat      S             10A   INZ('          ')
 
      ** Build subfile
     D @BDSFL          S              1A
 
      ** Customer selected
     D @CUSEL          S              6A
 
      ** Whether position/select fields have been changed during key browse
     D KPosSelChg      S              1A
 
      ** condition availability of F10 (delete)
     D @EINKJ          S              1A
 
      ** error message reference
     D @ERRMS          S              7A
 
      ** F3 Exit
     D @INKC           S              1A
 
      ** F7 Roll backwards
     D @INKG           S              1A
 
      ** F8 Roll forwards
     D @INKH           S              1A
 
      ** F9 Insert
     D @INKI           S              1A
 
      ** F10 Delete
     D @INKJ           S              1A
 
      ** F12 Cancel
     D @INKL           S              1A
 
      ** Option selected
     D @OPSEL          S              1A
 
      ** Read backwards in roll
     D @RDBCK          S              1A
 
      ** Read forwards in roll
     D @RDFWD          S              1A
 
      ** Read subfile
     D @RDSFL          S              1A
 
 
      ** Screen / function
     D WSCRN2          S              1A
     D WSCRN3          S              1A
 
      ** Mode of operation
     D MODEOFOP        S              6A
 
      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A
 
      ** Index of errors
     D Idx             S              3P 0
 
     D WIdx            S              3  0
 
     D @EKYFD          S              1
 
      ** Flags
     D POTCFlag        S              1A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFMPRIS001
 
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
 
      /COPY WNCPYSRC,FFMPRIS002
 
      ** Do while screen: Key Details Screen
 
     C                   DOW       WSCRN2 = 'A'
     C                   EXSR      Scrn@A
     C                   ENDDO
 
      ** Do while screen: Key Details Screen
 
     C                   DOW       WSCRN2 = 'K'
     C                   EXSR      Scrn@K
     C                   ENDDO
 
      /COPY WNCPYSRC,FFMPRIS003
      ** Build browse subfile record
 
     C                   IF        WSCRN2 = 'B'
     C                   EXSR      BLDBRW
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   IF        WSCRN2 = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFMPRIS006
 
      ** Do while screen: Transaction Detail Screen
 
     C                   Z-ADD     *ZERO         WIdx
     C                   DOW       WSCRN2 = 'P'
     C                   EXSR      Scrn@P
     C                   EXSR      SFDS@P
     C                   ENDDO
 
      /COPY WNCPYSRC,FFMPRIS007
 
     C                   IF        WSCRN2 = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
      /COPY WNCPYSRC,FFMPRIS008
 
      ** Terminate program
 
     C                   IF        WSCRN2 = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFMPRIS009
 
      /EJECT
      *****************************************************************
      * SCRN@A - PROCESS FIRST SCREEN
      *****************************************************************
     C     SCRN@A        BEGSR
 
      ** Write/Read Display Screen - Key Details
 
     C                   CALLB     'FFMPRIDSP'
 
      ** Input Parameters :
      ** Return code
 
     C                   PARM      *BLANK        RetCodeIn
 
      ** Transaction Details in screen format
 
     C                   PARM                    CurTrnDets
 
      ** Transaction Status
 
     C                   PARM                    PTransStat
 
      ** Transaction Details OK indicators
 
     C                   PARM                    OKTrnDets
 
      ** Transaction Details OK indicators
 
     C                   PARM                    PRTRNN
 
      ** OTC Flag
 
     C                   PARM                    POTCFlag
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
     C                   PARM                    @EDTFD
 
      ** Enabled Function Keys
      ** F10 - Delete
 
     C                   PARM                    @EINKJ
 
     C                   PARM                    WSCRN2
 
      ** Output Parameters :
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
 
      ** Reset Errors
 
     C                   EXSR      ResetErrs
 
      ** F3 - End Program
 
     C                   SELECT
     C                   WHEN      @INKC = '1'
     C                   EXSR      ENDP
 
      ** F12 - Cancel on Key Screen
 
     C                   WHEN      @INKL = '1'
     C                   EXSR      ENDP
 
     C                   OTHER
 
      ** Validate input to Key screen
 
     C                   EXSR      RTVTRN
 
     C                   IF        OKMRKT <> 'N'
 
     C                   EVAL      WSCRN2 = 'K'
 
     C                   EVAL      CurTrn@2nd = CurTrnDets
 
     C                   ENDIF
 
     C                   EVAL      PTransStat = *BLANKS
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@K - PROCESS SCREEN: KEY DETAILS
      *****************************************************************
     C     SCRN@K        BEGSR
 
      ** Write/Read Display Screen - Key Details
 
     C                   CALLB     'FFMPRIDSP'
 
      ** Input Parameters
      ** Return code
 
     C                   PARM      *BLANK        RetCodeIn
 
 
      ** Transaction Details in screen format
 
     C                   PARM                    CurTrnDets
 
      ** Transaction Status
 
     C                   PARM                    PTransStat
 
      ** Transaction Details OK indicators
 
     C                   PARM                    OKTrnDets
 
     C                   PARM                    PRTRNN
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
     C                   PARM                    @EDTFD
 
      ** Enabled Function Keys
      ** F10 - Delete
 
     C                   PARM                    @EINKJ
 
     C                   PARM                    WSCRN2
 
      ** Output Parameters
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
 
     C                   EVAL      DDACTN = @DDACTN
 
      ** Reset Errors
 
     C                   Exsr      ResetErrs
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F12 - Cancel on Key Screen
 
     C     @INKL         CASEQ     '1'           CANC@K
 
      ** Validate input to Key screen
 
     C                   CAS                     VAL@K
 
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@K  - VALIDATE INPUT TO KEY SCREEN
      *****************************************************************
     C     VAL@K         BEGSR
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
      ** Call RTV to validate action code
 
     C                   EXSR      RTVTRN
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** If action is invalid
 
     C                   IF        OKACTN = 'N' OR OKISTC = 'N' OR
     C                             OKMTHN = 'N' OR OKYEAR = 'N' OR
     C                             OKPCAL = 'N' OR OKSTRP = 'N'
     C                   GOTO      EndVAL@K
     C                   ENDIF
 
      ** If Insert or Amend / Change
 
     C                   IF        @DDACTN = *BLANK AND @DDISTC = *BLANKS
     C                             AND @DDMTHN = *BLANKS AND @DDYRNO = *BLANKS
     C                             AND @DDPCAL = *BLANK AND @DDSTRP = *BLANKS
 
     C                   EVAL      WSCRN2 = 'B'
     C                   GOTO      EndVAL@K
 
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      DDACTN = 'A' OR DDACTN = 'D'
     C                             OR DDACTN = 'E'
 
      ** If action code is not insert
      ** Convert the Transaction details to screen format
      ** Update the transaction in file format
      ** Go to Details screen
 
     C                   EVAL      @DDISTN = ITISTN
 
      ** Check if transaction has been deleted
     C                   IF        DDACTN = 'E' AND C_RECI = '*'
     C                   EVAL      PTransStat = 'DELETED'
     C                   ELSE
     C                   EVAL      PTransStat = *BLANKS
     C                   ENDIF
 
     C                   EXSR      CVTTRN
     C                   EVAL      NwMnFilFmt = CrMnFilFmt
     C                   EVAL      WSCRN3 = 'K'
     C                   EVAL      WSCRN2 = 'P'
     C                   EXSR      SFDS@P
 
     C                   WHEN      DDACTN = 'I'
 
      ** Clear DS parameter arrays and go to detail screen
 
     C                   EVAL      @DDISTN = ITISTN
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      WSCRN3 = 'K'
     C                   EVAL      WSCRN2 = 'P'
     C                   EXSR      SFDS@P
 
     C                   ENDSL
 
     C     EndVAL@K      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON DETAIL SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
 
      ** Enable/disable fields on detail screen
 
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
 
      ** Enable key fields on detail screen
 
     C                   EVAL      @EKYFD = 'Y'
     C                   EVAL      @EDTFD = 'Y'
     C                   ELSE
     C                   EVAL      @EKYFD = 'N'
     C                   EVAL      @EDTFD = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * 7CRN@P - PROCESS DETAIL SCREEN
      *****************************************************************
     C     SCRN@P        BEGSR
 
      ** Set function key status on screen
 
     C                   EXSR      SFKEYS
 
      ** Write/Read Display Screen - Primary Details
 
     C                   CALLB     'FFMPRIDSP'
 
      ** Input Parameters :
      ** Return code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Transaction Details in screen format
 
     C                   PARM                    CurTrnDets
 
      ** Transaction Status
 
     C                   PARM                    PTransStat
 
      ** Transaction Details OK indicators
 
     C                   PARM                    OKTrnDets
 
     C                   PARM                    PRTRNN
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled Key & Detail Fields
 
     C                   PARM                    @EDTFD            1
 
      ** Enabled Function Keys
      ** F10 - Delete
 
     C                   PARM                    @EINKJ
 
     C                   PARM                    WSCRN2
 
      ** Output Parameters :
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Idx = *Zero
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           ENDP
 
      ** F7 - Roll Backwards
 
     C     @INKG         CASEQ     '1'           ROLL
 
      ** F8 - Roll Forwards
 
     C     @INKH         CASEQ     '1'           ROLL
 
      ** F12 - Cancel on Details Screen
 
     C     @INKL         CASEQ     '1'           CANC@P
 
      ** Validate Input to Details Screen
 
     C                   CAS                     VAL@P
 
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
 
      ** If customer number is NOT OK
      ** Re-output screen with error message on it
 
     C                   IF        OKISTC = 'N' OR OKMTHN = 'N' OR
     C                             OKYEAR = 'N' OR OKPCAL = 'N' OR
     C                             OKSTRP = 'N'
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Delete
 
     C                   IF        DDACTN = 'D'
 
      ** If F10 taken, got to updates
 
     C                   IF        @INKJ = '1'
     C                   MOVEL     'U'           WSCRN2
     C                   ENDIF
 
      ** Reset Errors
 
     C                   Exsr      ResetErrs
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Enquire
 
     C                   IF        DDACTN = 'E'
 
     C                   EVAL      WSCRN2 = WSCRN3
     C                   IF        WSCRN3 = 'K'
     C                   EVAL      %SUBST(PRISTT:3:3) = *BLANKS
     C                   EVAL      PRMTHN = *BLANKS
     C                   EVAL      PRYRNO = *BLANKS
     C                   EVAL      PRPCAL = *BLANK
     C                   EVAL      PRSTRP = *BLANKS
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   CurTrnDets
     C                   CLEAR                   PrvTrnDets
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      CurTrnDets = CurTrn@2nd
     C                   ENDIF
 
      ** Reset Errors
 
     C                   Exsr      ResetErrs
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Insert or Amend / Change
 
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
 
      ** Validate Transaction Detail
      ** Store image of input screen and current number of warnings
 
     C                   EVAL      PrvTrnDets = CurTrnDets
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
 
      ** Override routine
 
     C*                  EXSR      SROvrFle
     C                   EXSR      SROvrFle                                                   245143
 
      ** Reset Errors
 
     C                   Exsr      ResetErrs
 
     C                   CALLB     'FFMPRIVAL'
 
      ** Inputs
      ** Response mode
 
     C                   PARM      *BLANK        RespMode
 
      ** Transaction Details
 
     C                   PARM                    CurTrnDets
 
      ** Extension File Data
 
     C                   PARM                    ExtData
 
      ** Key info
 
     C                   PARM                    PPRSTRP
 
      ** Outputs
      ** Transaction Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
 
     C                   PARM                    NwMnFilFmt
 
      ** Instrument Types
 
     C                   PARM                    InstTypes
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
 
      ** If any screen defaulting or reformatting has occurred in validation
      ** or if the number of warnings has changed, re-display the screen
 
     C                   IF        CurTrnDets <> PrvTrnDets OR
     C                             WIdx       <> PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   ENDIF
 
     C                   EVAL      WSCRN2 = 'U'
 
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     ROLL          BEGSR
 
      ** Read next or previous record on customer file
      ** according to command key taken (F7/@INKG or F8/@INKH)
 
     C                   IF        @INKG = '1'
     C                   EVAL      @RDFWD = *BLANK
     C                   EVAL      @RDBCK = 'Y'
     C                   ELSE
     C                   EVAL      @RDFWD = 'Y'
     C                   EVAL      @RDBCK = *BLANK
     C                   ENDIF
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
     C                   CALLB     'FFMPRIRED'
 
      ** Input Parameters :
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Transaction number pointer
 
     C                   PARM                    PRTRNN
 
      ** Read Forwards
 
     C                   PARM                    @RDFWD
 
      ** Read Backwards
 
     C                   PARM                    @RDBCK
 
      ** Strike price numeric format
 
     C                   PARM                    PPRSTRP
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Output Parameters :
      ** Error message
 
     C                   PARM      *BLANK        @ERRMS
 
      ** Transaction read
 
     C                   PARM      *BLANKS       @SCRED
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** If error message returned from read, send it to detail screen
 
     C                   IF        @ERRMS <> *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If transaction read
 
     C                   IF        @SCRED <> *BLANK
 
      ** Retrieve transaction details
 
     C                   MOVEL     @SCRED        PRTRNN
 
     C                   EVAL      @DDISTC = @SCISTC
     C                   EVAL      @DDMTHN = @SCMTHN
     C                   EVAL      @DDYRNO = @SCYRNO
     C                   EVAL      @DDSTRP = @SCSTRP
     C                   EVAL      @DDPCAL = @SCPCAL
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
 
     C                   EXSR      RTVTRN
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** Convert Transaction Detail
 
     C                   CLEAR                   PTransStat
     C                   EXSR      CVTTRN
     C                   EVAL      NwMnFilFmt = CrMnFilFmt
 
     C                   IF        DDACTN = 'E' and C_RECI = '*'
     C                   EVAL      PTransStat = 'DELETED'
     C                   ELSE
     C                   EVAL      PTransStat = *BLANKS
     C                   ENDIF
 
     C                   EVAL      @DDISTN = ITISTN
 
     C                   ENDIF
 
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
      ** Build Browse subfile
 
     C                   CALLB     'FFMPRIBRW'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Transaction Detail Reference Pointer
 
     C                   PARM                    PRTRNN
 
      ** Build Sub-File
 
     C                   PARM      'Y'           @BDSFL
 
      ** Read Subfile Record
 
     C                   PARM      *BLANKS       @RDSFL
 
      ** Strike price numeric format
 
     C                   PARM                    PPRSTRP
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM      *BLANKS       @ERRMS
 
      ** Option Selected
 
     C                   PARM      *BLANKS       @OPSEL
 
      ** Transaction Reference selected
 
     C                   PARM      *BLANKS       @TrSEL
 
      ** Command Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** If F3 taken in browse, End Program
 
     C                   IF        @INKC = '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** If F12 taken in browse
 
     C                   IF        @INKL = '1'
     C                   EXSR      CANC@B
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        @ERRMS <> *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
     C                   EVAL      WSCRN2 = 'R'
 
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
 
     C                   CLEAR                   InstTypes
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
      ** Read Next Subfile Record
 
     C                   CALLB     'FFMPRIBRW'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Transaction Detail Reference Pointer
 
     C                   PARM                    PRTRNN
 
      ** Build Sub-File
 
     C                   PARM      *BLANKS       @BDSFL
 
      ** Read Subfile Record
 
     C                   PARM      'Y'           @RDSFL
 
      ** Strike price numeric format
 
     C                   PARM                    PPRSTRP
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM      *BLANKS       @ERRMS
 
      ** Option Selected
 
     C                   PARM      *BLANKS       @OPSEL
 
      ** Transaction Reference selected
 
     C                   PARM      *BLANKS       @TrSEL
 
      ** Command Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** If Transaction read from subfile
 
     C                   IF        @TrSEL <> *BLANK
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
      ** Retrieve Transaction Detail
 
     C                   EVAL      @DDACTN = @OPSEL
     C                   EVAL      DDACTN  = @OPSEL
     C                   EVAL      PRTRNN  = @TrSEL
     C                   EVAL      @DDISTC = @TRISTC
     C                   EVAL      @DDMTHN = @TRMTHN
     C                   EVAL      @DDYRNO = @TRYRNO
     C                   EVAL      @DDSTRP = @TRSTRP
     C                   EVAL      @DDPCAL = @TRPCAL
 
     C                   EXSR      RTVTRN
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
      ** Stay on browse screen if there is an error on Transaction number
 
     C                   IF        OKISTC = 'N' OR OKYEAR = 'N' OR
     C                             OKMTHN = 'N' OR OKPCAL = 'N' OR
     C                             OKSTRP = 'N' OR OKACTN = 'N'
     C                   EVAL      WSCRN2 = 'B'
     C                   GOTO      EndRDNBRW
     C                   ENDIF
 
     C                   EVAL      @DDISTN = ITISTN
 
     C                   IF        DDACTN <> 'I'
 
      ** Convert Transaction Detail
 
     C                   EXSR      CVTTRN
     C                   EVAL      NwMnFilFmt = CrMnFilFmt
 
     C                   ENDIF
      ** Check if transaction has been deleted
     C                   IF        DDACTN = 'E' AND C_RECI = '*'
     C                   EVAL      PTransStat = 'DELETED'
     C                   ELSE
     C                   EVAL      PTransStat = *BLANKS
     C                   ENDIF
 
      ** Put Transaction Detail detail screen
 
     C                   EVAL      WSCRN3 = 'B'
     C                   EVAL      WSCRN2 = 'P'
     C                   EXSR      SFDS@P
 
     C                   ELSE
 
     C                   EVAL      WSCRN2 = 'B'
 
     C                   ENDIF
 
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - Retrieve Transaction Detail
      *****************************************************************
     C     RTVTRN        BEGSR
 
      ** Retrieve Transaction Detail
 
     C                   CALLB     'FFMPRIRTV'
 
      ** INPUTS
      ** Return code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM      '      '      ModeofOp
 
      ** Response mode
 
     C                   PARM      'S'           RespMode
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
 
     C                   PARM                    C_FRNT
 
      ** (Midas) Transaction number
 
     C                   PARM                    PRTRNN
 
     C                   PARM                    WSCRN2
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Outputs
 
      ** Transaction  Details in File Format
     C                   PARM                    CrMnFilFmt
 
      ** Transaction Details OK indicators
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      0             Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
     C                   PARM                    @DDMKTN
     C                   PARM                    @DDBUSD
 
      ** Valid Instrument types
 
     C                   PARM                    InstTypes
 
      ** Valid strike price
 
     C                   PARM                    PPRSTRP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - Put a Transaction Detail on Screen
      *****************************************************************
     C     CVTTRN        BEGSR
 
      ** Call program to fill screen fields with data from FFMPRIFLPD
 
     C                   CALLB     'FFMPRICVT'
 
      ** Output Parameters
      ** Return Code
 
     C                   PARM      *BLANKS       RetCodeIn
 
      ** Market Prices  Details File Format
 
     C                   PARM                    CrMnFilFmt
 
      ** Output Parameters
      ** Market Prices  Details Screen Format
 
     C                   PARM                    CurTrnDets
 
      ** Instrument types File format
 
     C                   PARM                    InstTypes
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
 
      ** Enable/disable function keys
      ** KJ = Command Key F10 = CONFIRM DELETE
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO DETAIL SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
 
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@K - SEND A MESSAGE TO KEY SCREEN
      *****************************************************************
     C     SNDM@K        BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   EVAL      E = 1
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
 
     C     EndSNDM@K     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@B - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@B        BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WSCRN2 = 'K'
     C                   EVAL      PRISTT = *BLANKS
     C                   EVAL      %SUBST(PRISTT:1:2) = @KDDMRKT
     C                   EVAL      PRMTHN = *BLANKS
     C                   EVAL      PRYRNO = *BLANKS
     C                   EVAL      PRPCAL = *BLANK
     C                   EVAL      PRSTRP = *BLANKS
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   CurTrnDets
     C                   CLEAR                   PrvTrnDets
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
 
     C                   EVAL      CurTrnDets = CurTrn@2nd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@K - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@K        BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WSCRN2  = 'A'
     C                   EVAL      PRTRNN = *BLANK
     C                   EVAL      PTransStat = *BLANKS
 
      ** If input fields are enabled
      ** Blank the screens
 
     C                   EVAL      CurTrnDets = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
 
      ** Return to previous screen
 
     C                   EVAL      %SUBST(PRISTT:3:3) = *BLANKS
     C                   EVAL      PRMTHN = *BLANKS
     C                   EVAL      PRYRNO = *BLANKS
     C                   EVAL      PRPCAL = *BLANK
     C                   EVAL      PRSTRP = *BLANKS
     C                   EVAL      WSCRN2  = 'K'
 
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   CurTrnDets
     C                   CLEAR                   PrvTrnDets
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
 
     C                   EVAL      CurTrnDets = CurTrn@2nd
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
      ** Update valid transaction: transaction reference
 
     C                   EVAL      DVISTT  = PRISTT
     C                   MOVE      PRYRNO        DVYRNO
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   EVAL      DVMTHN = 01
     C                   WHEN      PRMTHN = 'FEB'
     C                   EVAL      DVMTHN=  02
     C                   WHEN      PRMTHN = 'MAR'
     C                   EVAL      DVMTHN=  03
     C                   WHEN      PRMTHN = 'APR'
     C                   EVAL      DVMTHN=  04
     C                   WHEN      PRMTHN = 'MAY'
     C                   EVAL      DVMTHN=  05
     C                   WHEN      PRMTHN = 'JUN'
     C                   EVAL      DVMTHN=  06
     C                   WHEN      PRMTHN = 'JUL'
     C                   EVAL      DVMTHN=  07
     C                   WHEN      PRMTHN = 'AUG'
     C                   EVAL      DVMTHN=  08
     C                   WHEN      PRMTHN = 'SEP'
     C                   EVAL      DVMTHN=  09
     C                   WHEN      PRMTHN = 'OCT'
     C                   EVAL      DVMTHN=  10
     C                   WHEN      PRMTHN = 'NOV'
     C                   EVAL      DVMTHN=  11
     C                   WHEN      PRMTHN = 'DEC'
     C                   EVAL      DVMTHN = 12
     C                   ENDSL
     C                   EVAL      DVPCAL = PRPCAL
     C                   EVAL      DVSTRP = PPRSTRP
 
     C                   EVAL      DVCHTP = DDACTN
 
     C                   SELECT
     C                   WHEN      DDACTN = 'A'
 
      ** Carry forward number of trades value to valid file field
 
     C                   EVAL      DVTNLU = C_TNLU
 
     C                   WHEN      DDACTN = 'I'
 
      ** Initialise number of trades field for Insert
 
     C                   EVAL      DVTNLU = 0
 
     C                   WHEN      DDACTN = 'D'
 
     C                   EVAL      @EINKJ = 'N'
 
     C                   ENDSL
 
     C                   EVAL      @RTCD = *BLANK
 
      ** Override routine
 
     C                   EXSR      SROvrFle
 
      ** Market Prices Details Updates
 
     C                   CALLB     'FFMPRIUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwMnFilFmt
     C                   PARM                    POTCFlag
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C                   IF        @RTCD <> *BLANK
     C                   ROLBK
     C                   IF        @RTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   COMMIT
      ** Reset Errors                                                                       BUG10387
                                                                                            BUG10387
     C                   EXSR      ResetErrs                                                BUG10387
                                                                                            BUG10387
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C
     C                   IF        @RTCD = '*RECUPD'
 
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      @ERRMS = 'USR5002'
     C                   EXSR      SNDM@K
     C                   ENDIF
 
      ** Return to previous screen
 
     C                   EVAL      WSCRN2 = WSCRN3
     C                   IF        WSCRN3 = 'K'
     C                   EVAL      CurTrnDets = CurTrn@2nd
     C                   EVAL      WSCRN2  = 'K'
     C                   EVAL      %SUBST(PRISTT:3:3) = *BLANKS
     C                   EVAL      PRMTHN = *BLANKS
     C                   EVAL      PRYRNO = *BLANKS
     C                   EVAL      PRPCAL = *BLANK
     C                   EVAL      PRSTRP = *BLANKS
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   PrvTrnDets
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   ENDIF
 
      ** Delete Override
 
     C                   EXSR      SRDltOvr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SROvrFle - Override File
      *****************************************************************
     C     SROvrFle      BEGSR
 
     C                   IF        OKMRKT <> 'N'
 
     C                   EVAL      POTCFlag = 'N'
     C                   IF        @KDDMRKT = *BLANKS
     C                   EVAL      @KDDMRKT = 'OT'
     C                   EVAL      POTCFlag = 'Y'
     C                   ENDIF
 
      ** Apply the multimember file overrides for the transaction, and
      ** get the current trading date.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    @KDDMRKT
 
     C                   IF        @KDDMRKT = 'OT'
     C                   EVAL      @KDDMRKT = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDltOvr - Override File
      *****************************************************************
     C     SRDltOvr      BEGSR
 
      ** Remove the multimembered file overrides for this transaction
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
 
     C                   EVAL      WSCRN2 = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error indicators
      *****************************************************************
     C     ResetErrs     BEGSR
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Idx = *Zero
     C                   EVAL      WIdx = *Zero
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      PRTRNN = *BLANK
 
      ** Blank the screens
 
     C                   EVAL      CurTrnDets = *BLANK
 
      ** If you wish to go straight to the input screen and not the subfile,
      ** replace the 'B' with a 'K' to specify the key detail screen.
      ** Browse Screen
 
     C                   MOVEL     'A'           WSCRN2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialise program name
 
     C                   MOVEL     'FFMPRISIN'   DBPGM
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   IF        PRTRNN <> *BLANK AND
     C                             DDACTN <> ' '
     C                   MOVEL     ' '           WSCRN2
     C                   MOVEL     'FFFF'        @CALLP            4
 
      ** Clear DS parameter arrays and go to detail screen
 
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   CurTrnDets
     C                   CLEAR                   PTransStat
     C                   MOVE      *ALL'Y'       OKTrnDets
 
     C                   ELSE
 
      ** Go To Initial Screen
 
     C                   EXSR      INITIAL
     C                   MOVEL     'FFFF'        @CALLP            4
     C                   ENDIF
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFMPRIS010
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
