     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees input')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFESIN - Dealing Fees Screen Input                        *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for dealing fees.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036070           Date 19Oct15               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036070 - No way to go back to main deal details screen     *
      *             after reaching settlement screen.  Introduce new  *
      *             function key F11.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
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

     D CrDlFilFmt    E DS                  EXTNAME(DLFEED)
      * Current Transaction Detail in File Format

      * New Transaction Detail in File Format
     D VFRec                 152    220
     D VFPay                 221    779

     D CrDlScnFmt    E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(@)
      * Current Transaction  Detail in Screen Format

     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
     D ValidDlfe     E DS                  EXTNAME(DLVDLFEPD)
      **New*Transaction Detail in File Format
     D***VFRec                 154    222
     D***VFPay                 223    711

      * Previous Transaction Detail in Scrn Format
     D NwDlScnFmt    E DS                  EXTNAME(DLDLFEPD)
      * Previous Transaction Detail in Scrn Format
     D PrvTrnDets    E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(W_)

      * Error indicators
     D OkDlfe        E DS                  EXTNAME(DLEDLFEPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     **  Payment Instructions (File Format)
     D P_PAYF        E DS                  EXTNAME(SDESFPPD)
     **  Receive Instructions (File Format)
     D P_RECF        E DS                  EXTNAME(SDESFRPD)
     **  FRA/IRS Instructions (File Format)
     D P_FRIF        E DS                  EXTNAME(SDESFFPD)
     **  Payment Instructions (Screen Format)
     D P_PAYS        E DS                  EXTNAME(SDESSPPD)
     **  Receive Instructions (Screen Format)
     D P_RECS        E DS                  EXTNAME(SDESSRPD)
     **  FRA/IRS Instructions (Screen Format)
     D P_FRIS        E DS                  EXTNAME(SDESSFPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access progrmas, long data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Transaction number Work Field
     D WKDLNO          S                   LIKE(DDDLNO)

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** Build subfile
     D @BDSFL          S              1A

      ** Customer selected
     D @CUSEL          S              6A

      ** Whether position/select fields have been changed during key browse
     D KPosSelChg      S              1A


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

      ** F10 Authorise
     D @INKK           S              1A

      ** F12 Cancel
     D @INKL           S              1A

      ** F14 Extended SEttlements
     D @INKN           S              1A

      ** F15 Browse
     D @INKP           S              1A

      ** Option selected
     D @OPSEL          S              1A

      ** Read backwards in roll
     D @RDBCK          S              1A

      ** Read forwards in roll
     D @RDFWD          S              1A

      ** Read next browse
     D @RDNB           S              1A

      ** Read subfile
     D @RDSFL          S              1A

      **
     D @SCRED          S              6A
     D @FTRED          S             20A
     D @SQRED          S              2A

      ** Screen / function
     D @SCRN           S              1A


      ** Read next browse in key screen query browse subfile
     D K@RDNB          S              1A

      ** Query check in key screen customer number field
     D KEYQUERY        S              1A

      ** Mode of operation
     D MODEOFOP        S              6A

      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A

      ** Index of errors
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D @CCI@M          DS
     D @EKYFD                  1      1
     D @EDTFD                  2      2
     D @EINKG                  3      3
     D @EINKH                  4      4
     D @EINKJ                  5      5
     D @EINKK                  6      6
     D @EINKN                  7      7
     D @EINKP                  8      8

     D @PCI@M          DS             8

      ** Timestamp for the transaction
     D TimeStamp       S               Z
     D@TrSEL           S                   LIKE(DDDLNO)
     ** Workfields
     D PrvN_Warn       S              3  0
     D P_CALP          S              4
     D P_PCCY          S                   LIKE(DDFCCY)
     D P_RCCY          S                   LIKE(DDFCCY)
     D P_CSNM          S                   LIKE(BBCSSN)
     D P_TTYP          S              2A
     D P_FFND          S              1A
     D P_ISDA          S              4A
     D P_AGTY          S              6A
     D P_AGDT          S              6A
     D P_AGVV          S              2A
     D P_BLANK         S              2A
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
     D PWPgm           S             10A
     D PWKey           S              2A
     D PWAction        S              1A
     D Data            DS          1024
     D PWRtn           S              7A
     D PWSpare         S            256A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D P_RTCD          S             10A
     D P_ACTN          S              1A
     D P_DLNO          S              6A
     D P_PPAY          S              1A
     D P_PREC          S              1A
     D P_BRCA          S              3A
     D P_DATP          S              5  0
     D P_DATR          S              5  0
     D AmendOk         S              1A
     D DDSTAT          S             16A
     D @PDLNO          S                   LIKE(DDDLNO)
     D @PACTN          S                   LIKE(DDACTN)
     D @PFSEQ          S                   LIKE(DDFSEQ)
     D DealType        S                   LIKE(C_DTYP)
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

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

      ** Issue rollback to clear any possible updates in window functions

     C                   IF        @INKL = '1'
     C                   ROLBK
     C                   ENDIF

      ** Read next browse subfile record
     C                   IF        @SCRN = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF

      ** Do while screen: Transaction Detail Screen
     C                   DOW       @SCRN = 'M'
     C                   EXSR      SCRN@M
     C                   ENDDO

      ** SCREEN: WINDOW
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   ENDIF

      ** DO WHILE SCREEN: SETTLEMENT DETAILS
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO

      ** SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF

      ** UPDATE FILES
     C                   IF        @SCRN = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF

      ** Terminate program
     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS DETAIL SCREEN
      *****************************************************************
     C     SCRN@M        BEGSR

     C                   EVAL      @PDLNO = DDDLNO
     C                   EVAL      @PACTN = DDACTN
     C                   EVAL      @PFSEQ = DDFSEQ
     C                   EVAL      @PCI@M = @CCI@M

      ** Write/Read Display Screen - Primary Details
     C                   CALLB     'DLDLFEDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input Parameters :

      * Return code
     C                   PARM      *BLANKS       RetCodeIn

      ** Transaction Details in screen format
     C                   PARM                    NwDlScnFmt

      ** Transaction Details OK indicators
     C                   PARM                    OkDlfe

      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      * Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      *
      * Enabled Key & Detail Fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * Enabled Function Keys
      * F7 - Read Previous
      * F8 - Read Next
      * F10 - Delete
      * F11 - Authorise
      * F14 - Settlement Details
      * F15 - Browse
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      * Status
     C                   PARM                    DDSTAT

      * Output Parameters :

      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP

      * Reset Errors
     C                   Exsr      ResetErrs
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Details Screen
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * F15 - Build Browse
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * Validate Input to Details Screen
     C                   CAS                     VAL@M

     C                   ENDCS


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@M         BEGSR
     C                   EXSR      RTVDEL
      *
      * If Deal number, Fee sequence or Action code is NOT OK
      * Re-output screen with error message on it
      *
     C                   IF        OKDLNO = 'N' OR OKACTN = 'N'
     C                             OR OKFSEQ = 'N'
     C                   GOTO      EndVAL@M
     C                   ENDIF
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
     C                   IF        DDACTN = 'D' OR DDACTN = 'E'
     C                             OR DDACTN = 'X' OR DDACTN = 'A'
     C                             AND DDDLNO <> @PDLNO OR DDACTN = 'A'
     C                             AND DDFSEQ <> @PFSEQ
     C                   EXSR      CVTDEL
     C                   ENDIF
     C                   IF        DDDLNO <> @PDLNO AND DDACTN <> 'I' OR
     C                             DDFSEQ <> @PFSEQ AND DDACTN <> 'I' OR
     C                             DDACTN <> @PACTN OR @CCI@M <> @PCI@M
     C                   GOTO      EndVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * If Delete
     C                   IF        DDACTN = 'D'
     C                   MOVEL     CrDlFilFmt    ValidDlfe
      *
      * If F10 taken, got to updates
     C                   IF        @INKJ = '1'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF

     C                   GOTO      EndVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * If Enquire
     C                   IF        DDACTN = 'E'
     C                   MOVEL     CrDlFilFmt    ValidDlfe
      *
      * IF CK/14 TAKEN, CONTINUE TO SETTLEMENTS SCREEN
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @INKN         IFEQ      '1'
     C                   MOVEL     'S'           @SCRN
     C                   ELSE

     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ENDIF
     C                   ENDIF


     C                   GOTO      EndVAL@M
     C                   ENDIF
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Fee in File Format
      *
     C                   MOVEL     CrDlFilFmt    ValidDlfe
      *
      * Continue to settlements screen
      *
     C                   MOVEL     'S'           @SCRN
     C                   GOTO      EndVAL@M
     C                   END


      *
      *----------------------------------------------------------------
      * If Insert or Amend / Change
      *
     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'

      * Validate Transaction Detail

      * Store image of input screen and current number of warnings
     C                   EVAL      PrvTrnDets = NwDlScnFmt
     C                   Z-ADD     WIdx          PrvN_Warn
      *
      * IF AMEND
      *
     C     DDACTN        IFEQ      'A'
      *
      * Validate whether non-amendable fields have been changed
      *
     C                   MOVEL     CrDlFilFmt    ValidDlfe
      *
     C                   CALLB     'DLDLFEAMD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Fee in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Fee in Screen Format
     C                   PARM                    CrDlScnFmt
      *
      * Fee - file formats
     C                   PARM                    ValidDlfe
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OkDlfe
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
     C                   PARM                    AmendOk
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErr          1
     C                   END

     C                   CALLB     'DLDLFEVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Inputs

      * Response mode
     C                   PARM      *BLANK        RespMode

      ** Transaction Details
     C                   PARM                    NwDlScnFmt

      * Outputs

      ** Transaction Details OK inds
     C                   PARM                    OkDlfe

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

      * Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidDlfe
      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD

      *
      * If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@M
     C                   ENDIF
      *
      * If any screen defaulting or reformatting has occurred in validation
      * or if the number of warnings has changed, re-display the screen
     C                   IF        NwDlScnFmt <> PrvTrnDets OR
     C                             WIdx       <> PrvN_Warn
     C                   GOTO      EndVAL@M
     C                   ENDIF
      *
      * Clear any warning messages
     C                   MOVE      *ALL'Y'       OkDlfe
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF

     C     EndVAL@M      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WINDOW - Process Window screen                               *
      *                                                               *
      *****************************************************************
     C     WINDOW        BEGSR
      *
      ** Display window screen.
      *
     C                   CALLB     'DLDLFEDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input Parameters :

      * Return code
     C                   PARM      *BLANKS       RetCodeIn

      ** Transaction Details in screen format
     C                   PARM                    NwDlScnFmt

      ** Transaction Details OK indicators
     C                   PARM                    OkDlfe

      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      * Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      *
      * Enabled Key & Detail Fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * Enabled Function Keys
      * F7 - Read Previous
      * F8 - Read Next
      * F10 - Delete
      * F11 - Authorise
      * F14 - Settlement Details
      * F15 - Browse
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKK
     C                   PARM                    @EINKN
     C                   PARM                    @EINKP
      * Status
     C                   PARM                    DDSTAT

      * Output Parameters :

      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
      *
      ** Call window manager.
      *
     C                   CALL      'WN0010'
     C                   PARM      'DLDLFESIN'   PWPgm
     C                   PARM                    PWKey
     C                   PARM      DDACTN        PWAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn
     C                   PARM                    PWSpare

     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PWRtn = 'Y2U9999'
     C                   EXSR      EndP
      *
      ** F12 - cancel.  Display initial screen.
     C                   WHEN      PWRtn = 'USR0790'
     C                   EVAL      WScrn = 'P'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - proceed to confirmation screen.
     C                   IF        DDACTN  = 'I' OR DDACTN = 'A'
     C                   EVAL      WScrn = 'C'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF

     C                   ENDSL

     C     EWINDOW       ENDSR
      *
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH CUSTOMER FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if action insert or not valid
     C                   IF        DDACTN <> 'A' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'X'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
      *
      * Read next or previous record on customer file
      * according to command key taken (F7/@INKG or F8/@INKH)
     C                   IF        @INKG = '1'
     C                   EVAL      @RDFWD = *BLANK
     C                   EVAL      @RDBCK = 'Y'
     C                   ELSE
     C                   EVAL      @RDFWD = 'Y'
     C                   EVAL      @RDBCK = *BLANK
     C                   ENDIF
      *
     C                   CALLB     'DLDLFERED'
      *
      * Input Parameters :

      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Mode
     C                   PARM                    ModeofOp
      * Action Code
     C                   PARM                    DDACTN
      * Deal number pointer
     C                   PARM                    DDDLNO
      * Front Office Transaction ID
     C                   PARM                    DFFRNT
      * Fee Sequence
     C                   PARM                    DDFSEQ
      * Read Forwards
     C                   PARM                    @RDFWD
      * Read Backwards
     C                   PARM                    @RDBCK

      * Output Parameters :

      * Error message
     C                   PARM      *BLANK        @ERRMS
      * Transaction read
     C                   PARM      *BLANK        @SCRED
      * Front Office Deal Read
     C                   PARM                    @FTRED           20
      *
      * SEQUENCE NUMBER READ
     C                   PARM                    @SQRED            2
      *
      * If error message returned from read, send it to detail screen
     C                   IF        @ERRMS <> *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   ENDIF

      * If transaction read
     C                   IF        @SCRED <> *BLANK

      * Retrieve transaction details
     C                   MOVEL     @SCRED        DDDLNO
     C                   MOVEL     @SQRED        DDFSEQ

     C                   EXSR      RTVDEL
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Convert Transaction Detail
     C                   EXSR      CVTDEL
     C                   EVAL      CrDlScnFmt = NwDlScnFmt
      *
      * Put the Transaction Detail on screen
     C                   EVAL      @SCRN = 'M'
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Reset Read next browse subfile record
     C                   EVAL      @RDNB = *BLANK
      *
      * Build Browse subfile
     C                   CALLB     'DLDLFEBRW'

      * Input Parameters :

      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Deal Number
     C                   PARM                    DDDLNO
      * Fee Sequence
     C                   PARM                    DDFSEQ
      * Build Sub-File
     C                   PARM      'Y'           @BDSFL
      * Read Subfile Record
     C                   PARM      *BLANKS       @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Output Parameters :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Transaction Reference selected
     C                   PARM      *BLANKS       @TrSEL
      * Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      *
      * If F3 taken in browse, End Program
     C                   IF        @INKC = '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * If Insert (F9) selected from browse, go to key screen
     C                   IF        @OPSEL = 'I'
     C                   EVAL      @SCRN = 'M'
     C                   EVAL      DDACTN = 'I'
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * If error message returned from browse, send it to detail screen
     C                   IF        @ERRMS <> *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      * Read next browse subfile record
      *
     C                   EVAL      @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
     C                   CALLB     'DLDLFEBRW'

      * Input Parameters :

      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      * Action Code
     C                   PARM                    DDACTN
      * Transaction Detail Reference Pointer
     C                   PARM                    DDDLNO
      * Fee Sequence
     C                   PARM                    DDFSEQ
      * Build Sub-File
     C                   PARM      *BLANKS       @BDSFL
      * Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Output Parameters :
      * Error Message
     C                   PARM      *BLANKS       @ERRMS
      * Option Selected
     C                   PARM      *BLANKS       @OPSEL
      * Transaction Reference selected
     C                   PARM      *BLANKS       @TrSEL
      * Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      *
      *
      * If Transaction read from subfile
     C                   IF        @TrSEL <> *BLANK
      *
      * Retrieve Transaction Detail
     C                   EVAL      DDACTN = @OPSEL
     C                   EVAL      DDDLNO = @TrSEL

     C                   EXSR      RTVDEL

      * Stay on browse screen if there is an error on Transaction number
     C*                  IF        OKDLNO = 'N' OR
     C*                            OKACTN = 'N'
     C*                  EVAL      @SCRN = 'B'
     C*                  GOTO      EndRDNBRW
     C*                  ENDIF
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Convert Transaction Detail
     C                   EXSR      CVTDEL
     C                   EVAL      CrDlScnFmt = NwDlScnFmt
      *
      * Put Transaction Detail detail screen
     C                   EVAL      @SCRN = 'M'
      *
      * Else, rebuild subfile browse
     C                   ELSE
     C                   EXSR      INITIAL
     C                   ENDIF
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - Retrieve Transaction Detail
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * Retrieve Transaction Detail
      *
     C                   CALLB     'DLDLFERTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      ModeofOp
      *
      * Response mode
     C                   PARM      'S'           RespMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    DFFRNT
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * Fee Sequence
     C                   PARM                    DDFSEQ
      *
      * Outputs
      *
      * Transaction  Details in File Format
     C                   PARM                    CrDlFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO
      * OK - Fee Sequence
     C                   PARM      *BLANK        OKFSEQ

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
      *


     C     EndRTVDEL     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDEL - Put a Transaction Detail on Screen
      *****************************************************************
     C     CVTDEL        BEGSR
      *
      * Call program to fill screen fields with data from DLFEED
      *
     C                   CALLB     'DLDLFECVT'
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * Dealing Fees Transaction Details File Format
     C                   PARM                    CrDlFilFmt
      *

      * Output Parameters

      * Dealing Fees Transaction Details Screen Format
     C                   PARM                    NwDlScnFmt
      * Status
     C                   PARM                    DDSTAT
     C                   MOVEL     NwDlScnFmt    CrDlScnFmt

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR

      * Enable/disable function keys

      * KJ = Command Key F10 = CONFIRM DELETE

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
      *
      ** Add error message to array passed to detail screen
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@K - SEND A MESSAGE TO KEY SCREEN
      *****************************************************************
     C     SNDM@K        BEGSR
      *
      ** Add error message to array passed to detail screen
     C                   EVAL      E = 1
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@K     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@K - CANCEL ON KEY SCREEN
      *****************************************************************
     C     CANC@K        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
     C                   EVAL      @RDNB  = *BLANK
     C                   EVAL      @SCRN  = 'B'
     C                   EVAL      DDDLNO = *BLANK
      *
      * If input fields are enabled
      * Blank the screens
     C                   EVAL      NwDlScnFmt = *BLANK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR

      * Update valid transaction: transaction reference


     C                   EVAL      @RTCD = *BLANK
     C                   EVAL      DLLCDT = DDACTN

      * Dealing Fees Details Updates
     C                   CALLB     'DLDLFEUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ValidDlfe
      *
      * If there were any errors in the update functions, rollback any
      * updates and end this program. Otherwise, commit the updates
     C                   IF        @RTCD <> *BLANK
     C                   ROLBK
     C                   IF        @RTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
     C
     C                   IF        @RTCD = '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   ELSE
      *
     C                   IF        @RTCD = *BLANKS
      *
     C                   SELECT
     C                   WHEN      DDACTN = 'I'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C**********         MOVEL     'MMM9040'     MsgIdArr(1)                                  CAS011
     C                   MOVEL     'MMM9042'     MsgIdArr(1)                                  CAS011
     C                   WHEN      DDACTN = 'D'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM9041'     MsgIdArr(1)
     C                   ENDSL
      *
     C                   ENDIF
     C
     C                   ENDIF
     C                   CLEAR                   NwDlScnFmt
     C                   EVAL      DDSTAT = *BLANK
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * If records are still to be read from the subfile, read them
     C                   IF        @RDNB = 'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * Else, Return to Insert Key Screen or Browse Subfile
     C                   IF        DDACTN = 'I'
     C                   EVAL      @ERRMS = 'USR5002'
     C                   EXSR      SNDM@K
     C                   EVAL      @SCRN = 'M'
     C                   ELSE
     C                   EVAL      @SCRN = WSCRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   EVAL      @SCRN = 'T'
      *
     C                   ENDSR
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: SETTLEMENT DETAILS
      *          EVOKED FOR INSERTS, AMENDS, ENQUIRIES & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ** Determine if pay settlement should be protected
      *
     C                   EVAL      P_PPAY = 'N'
     C                   EVAL      P_PREC = 'N'

     C                   IF        DDACTN ='E' OR DDACTN = 'D' OR DDACTN = 'X'
     C                   EVAL      P_PPAY = 'Y'
     C                   EVAL      P_PREC = 'Y'
     C                   ENDIF

     C     C_DTYP        IFNE      *BLANK
     C                   EVAL      DealType = C_DTYP
     C                   ELSE
     C                   EVAL      DealType = D_DTYP
     C                   ENDIF

     C                   IF        DealType = 'IT' OR DealType = 'TD' OR
     C                             DealType = 'CI' OR DealType = 'CD'
     C                   EVAL      P_PREC = 'Y'
     C                   ELSE
     C                   EVAL      P_PPAY = 'Y'
     C                   ENDIF

     C     OKCUST        IFEQ      'Y'
     C                   MOVEL(P)  DDCUST        PKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PKEY1            10
     C                   PARM                    PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF
      *
      * DETERMINE PARAMETERS FOR SETTLEMENT DETAILS INPUT
      *
     C                   EXSR      DETP@S
      *
      * SETTLEMENT INSTRUCTIONS INPUT
      *
     C                   CALLB     'ZASETINSIN'

      ** INPUTS

      ** Return Code
     C                   PARM      *BLANK        P_RTCD

      ** Action code
     C                   PARM      DDACTN        P_ACTN

      ** Deal number
     C                   PARM      DDDLNO        P_DLNO

      ** Protect Payment
     C                   PARM                    P_PPAY

      ** Protect Receive
     C                   PARM                    P_PREC

      ** Calling program
     C                   PARM      'DLFE'        P_CALP

      ** Payment currency
     C                   PARM      DDFCCY        P_PCCY

      ** Receive currency
     C                   PARM      DDFCCY        P_RCCY

      ** Customer shortname
     C                   PARM      BBCSSN        P_CSNM

      ** Transaction Type
     C                   PARM      DFDTYP        P_TTYP

      ** Federal Funds Ind.
     C                   PARM      *BLANK        P_FFND

      ** Booking branch
     C                   PARM      DFBRCA        P_BRCA

      ** Receipt Date
     C                   PARM                    P_DATR

      ** Payment Date
     C                   PARM                    P_DATP

      ** Payment instructions
     C                   PARM                    P_PAYS

      ** Receive instructions
     C                   PARM                    P_RECS

      ** FRA/IRS instructions
     C                   PARM                    P_FRIS

      * OUTPUTS

      ** Payment instructions
     C                   PARM                    P_PAYF

      ** Receive instructions
     C                   PARM                    P_RECF

      ** FRA/IRS instructions
     C                   PARM                    P_FRIF

      ** FUNCTION KEYS
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKK                                      MD036070
     C                   PARM      '0'           @INKL

      ** CK/3 - END PROGRAM

     C     @INKC         CASEQ     '1'           ENDP

      ** CK/12 - CANCEL ON SETTLEMENT DETAILS

     C     @INKK         CASEQ     '1'           CANC@S                                     MD036070
     C     @INKL         CASEQ     '1'           CANC@S

      ** EXIT FROM SETTLEMENT DETAILS

     C                   CAS                     EXIT@S
     C                   ENDCS

     C                   ENDSR
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       OkDlfe
      *
      * Validate Dealing Fees Details
      *
     C                   CALLB     'DLDLFEVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Inputs

      * Response mode
     C                   PARM      *BLANK        RespMode

      ** Transaction Details
     C                   PARM                    NwDlScnFmt

      * Outputs

      ** Transaction Details OK inds
     C                   PARM                    OkDlfe

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

      * Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidDlfe
      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   ENDIF
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'DLDLFEDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input Parameters :

      * Return code
     C                   PARM      *BLANKS       RetCodeIn

      ** Transaction Details in screen format
     C                   PARM                    NwDlScnFmt

      ** Transaction Details OK indicators
     C                   PARM                    OkDlfe

      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      * Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      *
      * Enabled Key & Detail Fields
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      * Enabled Function Keys
      * F7 - Read Previous
      * F8 - Read Next
      * F10 - Delete
      * F11 - Authorise
      * F14 - Settlement Details
      * F15 - Browse
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKK
     C                   PARM      'N'           @EINKN
     C                   PARM      'N'           @EINKP
      * Status
     C                   PARM                    DDSTAT

      * Output Parameters :

      * Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKK
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
     C                   PARM      '0'           @INKP
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OkDlfe
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
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
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   ENDIF
      *
      ***  KK = Command Key 11 = Authorise
      *
     C     DDACTN        IFEQ      'X'
     C                   IF        OKACTN = 'N'                                               CAS009
     C                   MOVEL     'N'           @EINKK                                       CAS009
     C                   ELSE                                                                 CAS009
     C                   MOVEL     'Y'           @EINKK
     C                   ENDIF                                                                CAS009
     C                   ELSE
     C                   MOVEL     'N'           @EINKK
     C                   ENDIF
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I, A, X display settlement details automatically)
      * (No further screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   ENDIF
      *
      ***  KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      * IFDS@M - Initialize field status on details screen            *
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      ***  Enable key & details fields
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
      *
     C                   ENDSR
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
     C                   EVAL      NwDlScnFmt = *BLANK
     C                   EVAL      DDSTAT = *BLANK
     C                   ENDIF
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * DETP@S - DETERMINE PARAMETERS FOR SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     DETP@S        BEGSR
     C
     C     DLPYON        IFEQ      'S'
     C     DLPYON        OREQ      ' '
     C                   EVAL      P_DATR = DLPSTD
     C                   EVAL      P_DATP = DLPSTD
     C                   ENDIF
     C     DLPYON        IFEQ      'E'
     C                   EVAL      P_DATR = DLPEND
     C                   EVAL      P_DATP = DLPEND
     C                   ENDIF
     C     DLPYON        IFEQ      'N'
     C                   EVAL      P_DATR = DLNPYD
     C                   EVAL      P_DATP = DLNPYD
     C                   ENDIF
     C                   IF        DDACTN = 'A' OR DDACTN = 'E' OR DDACTN = 'X'
     C                             OR DDACTN = 'D'
     C                   MOVEL     VFREC         P_RECF
     C                   MOVEL     VFPAY         P_PAYF
     C                   EVAL      FLPOBR = DLOMDB
     C                   EVAL      FLROBR = DLOSDB
     C                   ELSE
     C                   CALLB     'ZASETINDFT'
      *
      * INPUTS
      *
      * Calling program
     C                   PARM      'DLFE'        P_CALP
      *
      * Payment currency
     C                   PARM      DDFCCY        P_PCCY            3
      *
      * Receive currency
     C                   PARM      DDFCCY        P_RCCY            3
      *
      * Customer shortname
     C                   PARM      BBCSSN        P_CSNM
      *
      * Transaction Type
     C                   PARM      *BLANK        P_TTYP
      *
      * Federal Funds Ind.
     C                   PARM      *BLANK        P_FFND
      *
      ** Version of ISDA Rules govern
     C                   PARM                    P_ISDA
      *
      ** Type of ISDA agreement
     C                   PARM                    P_AGTY
      *
      ** Date of ISDA Agreement
     C                   PARM                    P_AGDT
      *
      ** Version of ISDA Agreement
     C                   PARM                    P_AGVV
      ** Version of ISDA Agreement century
     C                   PARM                    P_BLANK
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
      *
      ** OUTPUTS
      *
      * Payment instructions
     C                   PARM                    P_PAYF
      *
      * Receive instructions
     C                   PARM                    P_RECF
      *
      * FRA/IRS instructions
     C                   PARM                    P_FRIF
      *
      *
      * Clear payment instructions if protected
      *
     C     P_PPAY        IFEQ      'Y'
     C                   CLEAR                   P_PAYF
     C                   Z-ADD     *ZERO         FLPSTM
     C**********         Z-ADD     *ZERO         FLPOBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLPOCN                                       CSD027
     C                   EVAL      FLPOBN = *BLANKS                                           CSD027
     C                   EVAL      FLPOCN = *BLANKS                                           CSD027
     C                   ENDIF
      *
      * Clear receipt instructions if protected
      *
     C     P_PREC        IFEQ      'Y'
     C                   CLEAR                   P_RECF
     C                   Z-ADD     *ZERO         FLRSTM
     C**********         Z-ADD     *ZERO         FLROBN                                       CSD027
     C**********         Z-ADD     *ZERO         FLROCN                                       CSD027
     C                   EVAL      FLROBN = *BLANKS                                           CSD027
     C                   EVAL      FLROCN = *BLANKS                                           CSD027
     C                   ENDIF
     C                   ENDIF
      *
      * CONVERT SETTLEMENT DETAILS FROM FILE TO SCREEN FORMAT
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    P_PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    P_RECF
      *
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANKS       P_FRIF
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANKS       P_PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANKS       P_RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANKS       P_FRIS
     C                   PARM      DDFCCY        InRCCY                                      CSF011A
     C                   PARM      DDFCCY        InPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * CANC@S - Cancel on settlement details screen                  *
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      * EXIT@S - Exit from settlement details screen                  *
      *****************************************************************
     C     EXIT@S        BEGSR
      *
      * IF SETTLEMENT DETAILS INVALID
      *
     C     P_RTCD        IFEQ      '*ERRORS'
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ELSE
      *
      * ELSE, CONTINUE WITH CONFIRMATION SCREEN
      *
     C                   MOVEL     'C'           @SCRN
      *
      * UPDATE VALID Fee : PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   END
     C                   IF        DealType = 'IT' OR DealType = 'TD' OR
     C                             DealType = 'CI' OR DealType = 'CD'
     C                   EVAL      DLSTTL = FLPSTM
     C                   EVAL      DLOURS = FLPONS
     C                   EVAL      DLOSBR = FLPOBR
     C                   EVAL      DLTHER = FLPIBN
     C                   EVAL      DLOMDB = FLPOBR
     C                   EVAL      DLPSTM = FLPSTM
     C                   EVAL      DLPONS = FLPONS
     C                   EVAL      DLPIBN = FLPIBN
     C                   EVAL      DLPIBA = FLPIBA
     C                   EVAL      DLPOBN = FLPOBN
     C                   EVAL      DLPOCN = FLPOCN
     C                   EVAL      DLBTB1 = FLBTB1
     C                   EVAL      DLBTB2 = FLBTB2
     C                   EVAL      DLBTB3 = FLBTB3
     C                   EVAL      DLBTB4 = FLBTB4
     C                   EVAL      DLBTB5 = FLBTB5
     C                   EVAL      DLBTB6 = FLBTB6
     C                   ELSE
     C                   EVAL      DLSTTL = FLRSTM
     C                   EVAL      DLOURS = FLRONS
     C                   EVAL      DLOSBR = FLROBR
     C                   EVAL      DLTHER = FLRIBN
     C                   EVAL      DLOSDB = FLROBR
     C                   EVAL      DLRSTM = FLRSTM
     C                   EVAL      DLRONS = FLRONS
     C                   EVAL      DLRIBN = FLRIBN
     C                   EVAL      DLRIBA = FLRIBA
     C                   EVAL      DLROBN = FLROBN
     C                   EVAL      DLROCN = FLROCN
     C                   ENDIF
     C                   EVAL      DLRCRN = FLRCRN
     C                   EVAL      DLRCRA = FLRCRA
     C                   EVAL      DLRVNO = FLRVNO
     C                   EVAL      DLAWBN = FLAWBN
     C                   EVAL      DLAWBA = FLAWBA
     C                   EVAL      DLBENN = FLBENN
     C                   EVAL      DLBENA = FLBENA
     C                   EVAL      DLDTP1 = FLDTP1
     C                   EVAL      DLDTP2 = FLDTP2
     C                   EVAL      DLDTP3 = FLDTP3
     C                   EVAL      DLDTP4 = FLDTP4
     C                   EVAL      DLDCHG = FLDCHG
     C                   EVAL      DLAMTO = DLFAMT
     C                   EVAL      DLSCCY = FLRSCY
     C                   EVAL      DLICCY = FLIC72
      *
     C                   ENDSR
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
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error indicators
      *****************************************************************
     C     ResetErrs     BEGSR
      *
      * Reset Errors
     C                   MOVE      *ALL'Y'       OkDlfe
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      Idx = *Zero
     C                   EVAL      WIdx = *Zero
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
     C                   MOVEL     ' '           WSCRN             1
     C                   MOVEL     ' '           @SCRN             1
     C                   MOVEL     'DLFE'        @CALLP            4
      *
      * Clear DS parameter arrays and go to detail screen
     C                   CLEAR                   ValidDlfe
     C                   CLEAR                   CrDlFilFmt
     C                   CLEAR                   NwDlScnFmt
     C                   MOVE      *ALL'Y'       OkDlfe
      *
      * Reset Read Next Browse Subfile Record (if active)
     C                   EVAL      @RDNB  = *BLANK
     C                   EVAL      DDDLNO = *BLANK
      *
      * If you wish to go straight to the input screen and not the subfile,
      * replace the 'B' with a 'K' to specify the key detail screen.
      * Browse Screen
     C                   MOVEL     'M'           @SCRN
     C                   MOVEL     'M'           WSCRN             1
      *
      ***  Initialize field and function key status on detail screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR

      *
      ** Initialise program name
     C                   MOVEL     'DLDLFESIN'   DBPGM
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
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
      *
      *
      * Go To Initial Screen
      *
     C                   EXSR      INITIAL

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
(c) Finastra International Limited 2004
