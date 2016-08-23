     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Fees/buy-outs input')                         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRFEBOSIN - Fees/Buy-Outs/Processing Method/Next Principal   *
      *              Change Date Details Screen Input                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. 245692             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 CDL038             Date 10May05               *
      *                 BUG4872            Date 08Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 185064             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 10Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233467 - Pass Deal number to IRSFBOVAL for Principal Change  *
      *           Schedule verification of 'Next Principal Change     *
      *           Date'                                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG4872 - Upfront fees and buyout details disappear during   *
      *            authorisation                                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  185064 - Old up-front fee details should be saved in         *
      *           DLDGUPFE.                                           *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
     FDLDGUPFE  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDGREF:DLDGREFF)
     F                                     COMMIT
 
     FDLDGUPL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
 
      ** Transaction Details in screen format - other fields
     D NwFBScnFld    E DS                  EXTNAME(IRFEB1PD)
 
      ** Transaction Details in screen format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(B)
 
      ** Transaction Details in screen format - other fields
     D CrFBScnFld    E DS                  EXTNAME(IRFEB1PD)
     D                                     PREFIX(B)
 
      ** OK Flag indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** MIDAS 'Next Available Transaction No.' Data Area  MNATN
     D DNATN           DS             5
     D FNATN                   1      5  0
 
      ** Rundat data area
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Deal details                                                         245692
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D W#ACCD        E                     EXTFLD(QQACCD)                                     245692
                                                                                              245692
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** DS for brokerage details
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
 
      ** DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY QWINDSRC,IRSIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Work fields
     D @BRKC           S              4A
     D @CYCD           S              3A
 
      ** error message reference
     D @ERRMS          S              7A
      *
      ** Enable detail field
      ** condition availability of F10 (delete)
      ** F3 Exit
      ** F8 Next screen
      ** F9 Insert
      ** F12 Cancel
     D @EDTFLD         S              1A
     D @EINKJ          S              1A
     D @INKC           S              1A
     D @INKH           S              1A
     D @INKI           S              1A
     D @INKL           S              1A
 
      ** Screen / function
     D @SCRN           S              1A
 
      ** Return Code
     D PRETC           S              7
 
      ** Return Code (to calling pgm)
     D RTRN            S              7
 
      ** Index of errors
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D WIx             S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Define work fields
 
     D WUPVD           S                   LIKE(#1UPVD)
     D WUPFE           S                   LIKE(#1UPFE)
     D WUPPR           S                   LIKE(#1UPPR)                                       185064
     D CANCFM          S              1
 
     D WRedisplay      S              1
     D WPSCY           S              3
     D WPNLOC          S              3
     D WRSCY           S              3
     D WRNLOC          S              3
     D W0RTN           S              7
     D WUCDP           S              1P 0
     D WTCDP           S              1P 0
     D WUPDP           S              1P 0
     D WBODP           S              1P 0
 
     D UCTLD           S              6
     D TCTLD           S              6
      *
     D PRTCD           S              7
     D P@RTCD          S              7
     D P@OPTN          S              7
     D P@CUST          S              6
     D P@CCY           S              3
     D P@ACCD          S              4
     D P@ACSN          S              2
     D P@NOST          S              2P 0
     D P@BRCD          S              3
     D P@CSSN          S             10
     D P@PNOI          S              1
 
     D ZFLD15          S             15P 0
     D ZDECS           S              1P 0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRFEBOS001
 
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
      *
      /COPY WNCPYSRC,IRFEBOS002
      *
      ** Initialise fields
      *
     C                   EXSR      SRInit
      *
      ** Action is not Deletion
      *
     C                   IF        #1ACTN <> 'R'
      *
      ** Convert screen fields
     C                   EXSR      SRConScr
      *
      ** Process screen
     C                   DOW       @SCRN = 'S'
     C                   EXSR      SRProcScrn
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Action is not Enquiry
      *
     C                   IF        #1ACTN <> 'E'
      *
      ** Update transaction number
     C                   EXSR      ZTNLU1
      *
      ** Process Up front fee details
     C                   EXSR      SRUpFFee
      *
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRFEBOS003
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialize screen                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      @SCRN = 'S'
     C                   EVAL      WRedisplay = 'N'
     C                   EVAL      PRetC = *BLANK
 
     C                   IF        #1ACTN = 'E'
     C                   EVAL      *IN24 = *ON
     C                   ELSE
     C                   EVAL      *IN24 = *OFF
     C                   ENDIF
      *
      ** Determine our and their effective setllement currency
      ** workfields and corresponding nostro location.
      *
     C                   IF        CEU003 = *ON and #1PSCY <> *BLANKS
     C                   MOVEL     #1PSCY        WPSCY
     C                   ELSE
     C                   MOVEL     #1UCUC        WPSCY
     C                   ENDIF
 
     C                   IF        CEU003 = *ON and #1RSCY <> *BLANKS
     C                   MOVEL     #1RSCY        WRSCY
     C                   ELSE
     C                   MOVEL     #1TCUC        WRSCY
     C                   ENDIF
      *
      ** Access nostro location for our-effective-settlement-currency
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANK        P@CUST
     C                   PARM      WPSCY         P@CCY
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM      #1UNON        P@NOST
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WPNLOC = A7NOSN
     C                   ENDIF
      *
      ** Access nostro location for their-effective-settlement-currency
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANK        P@CUST
     C                   PARM      WRSCY         P@CCY
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM      #1TNON        P@NOST
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WRNLOC = A7NOSN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcScrn - Process screen                                  *
      *                                                               *
      *****************************************************************
     C     SRProcScrn    BEGSR
      *
      ** Save original details
      *
     C                   MOVE      NwFBScnFmt    CrFBScnFmt
     C                   MOVE      NwFBScnFld    CrFBScnFld
      *
      ** Write/Read Display Screen
      *
     C                   CALLB     'IRFEBODSP'
      *
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeIn
      *
      ** Transaction details in screen format
     C                   PARM                    NwFBScnFmt
     C                   PARM                    NwFBScnFld
      *
      ** IRS Details OK indicators
     C                   PARM                    OKFEBO
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enable detail field
     C                   PARM                    @EDTFLD
      *
      ** OUTPUTS
      ** =======
      *
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKL
      *
      ** Deal info passed from calling programs
     C                   PARM                    DATA
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset Errors
      *
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - Exit
     C                   WHEN      @INKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - Previous Screen
     C                   WHEN      @INKL = *ON
     C                   EXSR      SRPrev
      *
      ** F8 or Enter pressed
     C                   OTHER
      *
      ** Perform validation if action is Insert or Amend
     C                   IF        #1ACTN = 'I' OR
     C                             #1ACTN = 'A'
     C                   EXSR      SRValidate
     C                   ENDIF
      *
      ** Errors found
     C                   IF        Idx <> 0 or WRedisplay = 'Y'
     C                   GOTO      ESRProcScrn
     C                   ENDIF
      *
      ** Process principal change schedule
     C                   IF        #1DTYP = 'RS' OR #1DTYP = 'RX' OR
     C                             #1DTYP = 'RP' OR #1DTYP = 'RR' OR
     C                             #1DTYP = 'RF'
     C                   EXSR      SRPrChgSkd
     C                   ENDIF
      *
      ** F3 pressed
     C                   IF        PRETC = 'Y2U9999'
     C                   EXSR      SREndP
     C                   ENDIF
      *
      ** F12 pressed or there are errors, redisplay screen
     C                   IF        PRETC = 'USR0790' OR
     C                             OKONPCD = 'N' OR OKTNPCD = 'N'
     C                   GOTO      ESRProcScrn
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      @SCRN = 'T'
 
     C     ESRProcScrn   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate details                                *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
      ** If Cross Currency IRS
      *
     C                   IF        SDTYP = 'RX'
     C                   EXSR      SRValdC
     C                   ELSE
      *
      ** Single Currency IRS or Interest Rate Collar
      *
     C                   EXSR      SRValdS
     C                   ENDIF
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields
      ** check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IdX = 0
 
     C                   Z-ADD     1             WiX
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
     C                   ENDDO
      *
      ** Reset errors
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
      *
      ** Reset 'Next Principal Change Date' if errors found on validation                     233467
      *                                                                                       233467
     C                   ELSE                                                                 233467
     C     'RS00061'     LOOKUP    MsgIDArr                               50                  233467
     C     'RS00062'     LOOKUP    MsgIDArr                               51                  233467
     C   50              EVAL      SONPCD = BSONPCD                                           233467
     C   51              EVAL      STNPCD = BSTNPCD                                           233467
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdS - Validate Single Currency IRS                       *
      *                                                               *
      *****************************************************************
 
     C     SRValdS       BEGSR
 
     C                   CALLB     'IRSFBOAMD'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** IRS details on screen
      ** Original IRS details (screen format)
     C                   PARM                    NwFBScnFmt
     C                   PARM                    CrFBScnFmt
      *
      ** Deal information details
     C                   PARM                    Data
      *
      ** Reset of Fields in Error Required
     C                   PARM      'Y'           @@RSTE            1
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
      *
     C                   PARM                    WUCDP
     C                   PARM                    WTCDP
      *
      ** SDBANK - Rundate
     C                   PARM                    BJRDNB
      *
      ** Interest Rate Calendars on?
      ** Overnight Index Swaps on?
      *
     C                   PARM                    CIR007
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK          1
     C                   PARM                    BNDCSP                                       245692
 
     C                   CALLB     'IRSFBOVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM      *BLANK        RespMode
      *
      ** Screen Data
     C                   PARM                    NwFBScnFmt
      *                                                                                       233467
      ** Deal number                                                                          233467
     C                   PARM                    SDLNO                                        233467
      *
      ** Our up-front pay/receive dec.points
      ** Their up-front pay/receive dec.points
      ** Settlement currency
      ** Receivers currency
      ** Pay Nostro Location
      ** Receive Nostro Location
     C                   PARM                    WUCDP
     C                   PARM                    WTCDP
     C                   PARM                    WPSCY
     C                   PARM                    WRSCY
     C                   PARM                    WPNLOC
     C                   PARM                    WRNLOC
      *
      ** OUTPUTS
      ** =======
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Deal Info
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdC - Validate Cross currency IRS                        *
      *                                                               *
      *****************************************************************
 
     C     SRValdC       BEGSR
      *
     C                   CALLB     'IRCFBOAMD'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** IRS details on screen
      ** Original IRS details (screen format)
     C                   PARM                    NwFBScnFmt
     C                   PARM                    CrFBScnFmt
      *
      ** Deal information details
     C                   PARM                    Data
      *
      ** Reset of Fields in Error Required
     C                   PARM      'Y'           @@RSTE            1
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
      *
     C                   PARM                    WUCDP
     C                   PARM                    WTCDP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Rundate
     C                   PARM                    BJRDNB
      *
      ** Interest Rate Calendars on?
      ** Overnight Index Swaps on?
      *
     C                   PARM                    CIR007
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK          1
     C                   PARM                    BNDCSP                                       245692
 
     C                   CALLB     'IRCFBOVAL'
      *
      ** INPUTS
      ** ======
      *
      ** Response mode
      ** Screen Data
     C                   PARM      *BLANK        RespMode
     C                   PARM                    NwFBScnFmt
      ** Deal number                                                                          233467
     C                   PARM                    SDLNO                                        233467
      *
      ** Our up-front pay/receive dec.points
      ** Their up-front pay/receive dec.points
      ** Settlement currency
      ** Receivers currency
      ** Pay Nostro Location
      ** Receive Nostro Location
 
     C                   PARM                    WUCDP
     C                   PARM                    WTCDP
     C                   PARM                    WPSCY
     C                   PARM                    WRSCY
     C                   PARM                    WPNLOC
     C                   PARM                    WRNLOC
      *
      ** OUTPUTS
      ** =======
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Deal Info
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
      *
     C     EndVALD@C     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrChgSkd - Process Principal change schedules              *
      *                                                               *
      *****************************************************************
 
     C     SRPrChgSkd    BEGSR
 
     C                   IF        #1DTYP = 'RX'
 
     C                   CALLB     'IRCPCDSHD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       PRetC
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Transaction Details
     C                   PARM                    DATA
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    WUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    WTCDP
      *
      ** Settlement currency (Our)
     C                   PARM                    WPSCY
      *
      ** Settlement Currency (Their)
     C                   PARM                    WRSCY
      *
      ** STANDING DATA
      ** =============
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
     C                   ELSE
 
     C                   CALLB     'IRSPCDSHD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       PRetC
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Settlement currency
     C                   PARM                    WPSCY
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    WUCDP
      *
      ** STANDING DATA
      ** =============
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps/Collars/Floors &
      ** Individual Compounding Swaps
     C                   PARM                    CIR006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal information details
     C                   PARM                    DATA
 
     C                   ENDIF
 
     C     ESRPrChgSkd   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConScr - Convert data to screen format                     *
      *                                                               *
      *****************************************************************
      *
     C     SRConScr      BEGSR
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKFEBO
     C                   CLEAR                   NwFBScnFmt
     C                   EXSR      SRResetErr
      *
      ** Initialise screen fields
      *
     C                   EVAL      SWSID = PSJobName
     C                   MOVE      #1DLNO        SDLNO
     C                   EVAL      SACTN = #1ACTN
     C                   EVAL      SDTYP = #1DTYP
     C                   EVAL      SDLST = #1DLST
 
     C                   IF        #1ACTN <> 'A' and
     C                             #1ACTN <> 'R' and
     C                             #1ACTN <> 'E' and
     C                             #1ACTN <> 'X' and                                         BUG4872
     C                             CANCFM <> 'Y'
     C                   Z-ADD     *ZERO         #1ORED
     C                   Z-ADD     *ZERO         #1UNPC
     C                   Z-ADD     *ZERO         #1TNPC
     C                   Z-ADD     *ZERO         #1UPVD
     C                   Z-ADD     *ZERO         #1UPFE
     C                   Z-ADD     *ZERO         #1BOVD
     C                   Z-ADD     *ZERO         #1BOAM
     C                   ENDIF
      *
      ** Populate work fields
      *
     C                   EVAL      SUICF = #1UICF
     C                   EVAL      STICF = #1TICF
      *
      ** Convert dates to MMDDYY or DDMMYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ELSE
     C                   EVAL      *IN98 = *OFF
     C                   ENDIF
      *
     C                   Z-ADD     #1ORED        SOREDM
      *
     C                   EVAL      WQ0001 = #1DDAT
     C                   IF        WQ0001 <> *ZEROS
     C                   EXSR      SRDate2
     C                   MOVE      ZDATE         SDDAT
     C                   ELSE
     C                   EVAL      SDDAT = *BLANKS
     C                   ENDIF
      *
     C                   MOVE      #1VDAT        SVDATM
     C                   EVAL      WQ0001 = #1VDAT
     C                   IF        WQ0001 <> *ZEROS
     C                   EXSR      SRDate2
     C                   MOVE      ZDATE         SVDAT
     C                   ELSE
     C                   EVAL      SVDAT = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      WQ0001 = #1MDAT
     C                   IF        WQ0001 <> *ZEROS
     C                   EXSR      SRDate2
     C                   MOVE      ZDATE         SMDAT
     C                   ELSE
     C                   EVAL      SMDAT = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      SBRCA = #1BRCA
     C                   EVAL      SBRKC = #1BRKC
      *
      ** Format Brokerage according to no. of dec.pl. of broker ccy
      *
     C                   IF        #1BRKC <> 'TELX' and #1BRKC <> 'PHON'
     C                             and #1BRKC <> 'MAIL'
     C                   CALL      'AOBROKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1BRKC        @BRKC
     C     SDBROK        PARM      SDBROK        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBROKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     #1BRKC        DBKEY
     C                   OUT       LDA
     C                   EVAL      W0RTN = 'USR0567'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      A9BRCY        @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   MOVEL     A9BRCY        DBKEY
     C                   OUT       LDA
     C                   EVAL      W0RTN = 'USR0567'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     #1BAGE        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        SBAGE
     C                   ENDIF
 
     C                   IF        #1LNKD <> *ZERO
     C                   MOVEL     #1LNKD        SLNKDN
     C                   ELSE
     C                   EVAL      SLNKDN = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     #1CNUM        SCNUM
     C                   MOVE      #1CDAS        SCDAS
     C                   MOVE      #1UCUC        SUCUCY
 
     C                   IF        #1DTYP = 'RX'
     C                   MOVE      #1TCUC        STCUCY
     C                   ENDIF
      *
      ** Format the amounts using the currency decimal places.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C                   PARM      #1UCUC        @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   MOVEL     #1UCUC        DBKEY
     C                   OUT       LDA
     C                   EVAL      W0RTN = 'USR0567'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Our principal amount
      *
     C                   Z-ADD     #1UPAM        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        SUPAMT
     C                   Z-ADD     A6NBDP        WUCDP
     C                   Z-ADD     A6NBDP        WTCDP
 
     C                   IF        #1DTYP = 'RX'
      *
      ** Their principal amount
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1TCUC        @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   MOVEL     A9BRCY        DBKEY
     C                   OUT       LDA
     C                   EVAL      W0RTN = 'USR0567'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     #1TPAM        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        STPAMT
     C                   Z-ADD     A6NBDP        WTCDP
     C                   ENDIF
 
     C                   IF        CIR002 = 'Y' or CIR006 = 'Y' AND
     C                             (#1ACTN = 'E' or #1ACTN = 'A'
     C                             or #1ACTN = 'R')
 
     C                   IF        CIR006 = 'N' or #1UINP = 'A' or
     C                             #1UINP = 'I' or #1UINP = 'L'
      *
      ** Format Our unsettled interest
      *
     C                   Z-ADD     #1OUSI        ZFLD15
     C                   Z-ADD     WUCDP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        SOUSI
      *
      ** Format Our unsettled interest adjustment
      *
     C                   Z-ADD     #1OUSA        ZFLD15
     C                   Z-ADD     WUCDP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        SOUSA
     C                   ENDIF
 
     C                   IF        CIR006 = 'N' or #1TINP = 'A' or
     C                             #1TINP = 'I' or #1TINP = 'L'
      *
      ** Format Their unsettled interest
      *
     C                   Z-ADD     #1TUSI        ZFLD15
     C                   Z-ADD     WTCDP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        STUSI
      *
      ** Format Their unsettled interest adjustment
      *
     C                   Z-ADD     #1TUSA        ZFLD15
     C                   Z-ADD     WTCDP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        STUSA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1ACTN <> 'I' or
     C                             CANCFM = 'Y'
      *
      ** Up-Front Fee details
      *
     C                   IF        #1UPVD <> *ZEROS
 
     C                   EVAL      WQ0001 = #1UPVD
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         SUFVD
 
     C                   IF        #1UPPR = 'P'
     C                   Z-ADD     WUCDP         WUPDP
     C                   ELSE
     C                   Z-ADD     WTCDP         WUPDP
     C                   ENDIF
     C                   EVAL      SUFPR = #1UPPR
     C                   EVAL      WUPPR = #1UPPR                                             185064
 
     C                   Z-ADD     #1UPFE        ZFLD15
     C                   Z-ADD     WUPDP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        SUFEE
     C                   ENDIF
      *
      ** Save original up front file fields
     C                   EVAL      WUPFE = #1UPFE
     C                   EVAL      WUPVD = #1UPVD
      *
      ** Buy-Out details
      *
     C                   IF        #1BOVD <> *ZEROS
 
     C                   EVAL      WQ0001 = #1BOVD
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         SBOVD
 
     C                   IF        #1BAPR = 'P'
     C                   Z-ADD     WUCDP         WBODP
     C                   ELSE
     C                   Z-ADD     WTCDP         WBODP
     C                   ENDIF
     C                   EVAL      SBOPR = #1BAPR
 
     C                   Z-ADD     #1BOAM        ZFLD15
     C                   Z-ADD     WBODP         ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANK        ZOUT21
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        SBUYA
     C                   ENDIF
      *
      ** Our Next principal change date
      *
     C                   EVAL      WQ0001 = #1UNPC
     C                   IF        WQ0001 <> *ZEROS
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         SONPCD
     C                   ENDIF
      *
      ** Their Next principal change date
      *
     C                   IF        #1DTYP = 'RX'
     C                   EVAL      WQ0001 = #1TNPC
     C                   IF        WQ0001 <> *ZEROS
     C                   EXSR      SRDate2
     C                   MOVEL     ZDATE         STNPCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Our Interest processing method
      *
     C                   EVAL      SOIPM = #1UINP
      *
      ** Their Interest processing method
      *
     C                   EVAL      STIPM = #1TINP
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpFFee - Process up front fee details                      *
      *                                                               *
      *****************************************************************
 
     C     SRUpFFee      BEGSR
      *
      ** If any of the Up-front fee details have been
      ** amended, set Confirmation Required indicator to Y
      ** otherwise, set to N.
      *
     C                   IF        #1UPVD <> WUPVD or
     C                             #1UPFE <> WUPFE or
     C**********                   #1UPPR <> SUFPR                                            185064
     C                             #1UPPR <> WUPPR                                            185064
     C                   EVAL      #1CNRQ = 'Y'
     C                   EXSR      SRUpdUpF
     C                   ELSE
     C                   EVAL      #1CNRQ = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdUpF -  Write into PF/DLDGUPFE old values of up-front    *
      *              value date, fee and P/R indicator                *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdUpF      BEGSR
      *
     C     #1ACTN        IFEQ      'A'
     C                   MOVE      #1DLNO        DDLNO             6 0
     C     DDLNO         CHAIN     DLDGUPL1                           01
      *
     C                   IF        *IN01
     C                   MOVE      DDLNO         DLNO
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      WUPVD         UPVD                                         185064
     C                   MOVE      WUPFE         UPFE                                         185064
     C                   MOVE      WUPPR         UPPR                                         185064
     C                   WRITE     DLDGREFF
     C                   ELSE
     C**********         MOVE      #1UPFE        UPFE                                         185064
     C**********         MOVE      #1UPVD        UPVD                                         185064
     C**********         MOVE      #1UPPR        UPPR                                         185064
     C                   MOVE      WUPVD         UPVD                                         185064
     C                   MOVE      WUPFE         UPFE                                         185064
     C                   MOVE      WUPPR         UPPR                                         185064
     C                   UPDATE    DLDGREF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZTNLU1 - Transaction Number Data Area                        *
      *                                                               *
      *****************************************************************
     C     ZTNLU1        BEGSR
      *
      **  Lock Transaction No. DTAARA, access next Tran No, then update
      *
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         NATN              5 0
     C                   MOVE      FNATN         ZZWK05            5 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - End Program                                         *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      RTRN = 'Y2U9999'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrev - Previous Program                                    *
      *                                                               *
      *****************************************************************
     C     SRPrev        BEGSR
 
     C                   EVAL      RTRN = 'USR0790'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset Error Messages                            *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
 
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVE      *ALL'Y'       OKFEBO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDate2 - Convert date using ZDATE2                          *
      *                                                               *
      *****************************************************************
 
     C     SRDate2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    WQ0001            5 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    WQ0004            7
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialization processing                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RTRN
      *
      ** OUTPUTS
      ** =======
      *
      ** Deal info passed from calling programs
     C                   PARM                    DATA
      *
      ** Cancel from Confirm taken
     C                   PARM                    CANCFM
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Initialize program name
      *
     C                   MOVEL     'IRFEBOSIN'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              245692
      ** Access Dealing details                                                               245692
                                                                                              245692
     C                   CALL      'AODEALR1'                                                 245692
     C                   PARM      '*DBERR '     @RTCD                                        245692
     C                   PARM      '*FIRST '     @OPTN                                        245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
                                                                                              245692
     C     @RTCD         IFNE      *BLANKS                                                    245692
     C     *LOCK         IN        LDA                                                        245692
     C                   EVAL      DBFILE = 'SDDEALPD'                                        245692
     C                   EVAL      DBASE = 908                                                245692
     C                   EVAL      DBKEY = @OPTN                                              245692
     C                   OUT       LDA                                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDIF                                                                245692
                                                                                              245692
      *
      ** Access General Ledger Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculate Event Control Date as lesser of
      ** (Next Working Day - 1) & Accrual Profit Date.
      *
     C     BJDNWD        SUB       1             EVCD              5 0
      *
     C                   IF        BKAPDT < EVCD
     C                   Z-ADD     BKAPDT        EVCD
     C                   ENDIF
      *
      ** Access SAR details file to determine if CIR001 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     903           DBASE
     C                   MOVEL     'CIR001'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   ENDIF
      *
      ** Access SAR details file to determine if CIR002 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     904           DBASE
     C                   MOVEL     'CIR002'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   END
      *
      ** Access SAR details file to determine if CEU003 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     905           DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CEU003            1
     C                   ELSE
     C                   MOVEL     'N'           CEU003
     C                   END
      *
      ** Access SAR details file to determine if CIR006 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     906           DBASE
     C                   MOVEL     'CIR006'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR006            1
     C                   ELSE
     C                   MOVEL     'N'           CIR006
     C                   END
      *
      ** Access SAR details file to determine if CIR007 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     907           DBASE
     C                   MOVEL     'CIR007'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR007            1
     C                   ELSE
     C                   MOVEL     'N'           CIR007
     C                   END
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRFEBOS010
 
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
(c) Misys International Banking Systems Ltd. 2002
