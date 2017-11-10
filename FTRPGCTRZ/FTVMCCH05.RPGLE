     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate miscellaneous charge 5')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVMCCH05 - Validate Miscellaneous Charge 5                  *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 30Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244227             Date 12Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 13Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  244227 - Don't call FT000981 if charge code not found on file*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************

     FFTPCHGL0  IF   E           K DISK
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

      ** The maximum size of the appended error arrays
     D XARRAYMAX       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FLDNAMXAR       S             10A   DIM(XARRAYMAX)

      ** Array of error message IDs
     D MSGIDXAR        S                   DIM(XARRAYMAX) LIKE(#MSGID)

      ** Array of error message data.
     D MSGDTAXAR       S                   DIM(XARRAYMAX) LIKE(#MSGDATA)

      ** Array of Warning in error.
     D WFLDNMXAR       S             10A   DIM(XARRAYMAX)

      ** Array of Warning message IDs
     D WMSGIDXAR       S                   DIM(XARRAYMAX) LIKE(#MSGID)

      ** Array of Warning message data.
     D WMSGDTAXAR      S                   DIM(XARRAYMAX) LIKE(#MSGDATA)

      * Incoming Transaction
     D TRANINPRIM    E DS                  EXTNAME(FTOPY1PD)
     D TRANINFOUR    E DS                  EXTNAME(FTOPY6PD)

      * Flags to indicate whether transaction fields are valid
     D OKFLAGSDS     E DS                  EXTNAME(FTEOPY4PD)

      * Validation Work Fields
     D VAL@FIELDS    E DS                  EXTNAME(FTV@OPAYPD)

      ** Valid Payments layout
     D VALIDPMNT     E DS                  EXTNAME(FTVOPAYPD)
     D  QQCDRO1      E                     EXTFLD(QQCDRO)                                     CGL029

      ** Valid Outgoing Payments Extension File
     D VALIDPMTX     E DS                  EXTNAME(FTVOPY2PD)

      ** Valid Outgoing Payments Extension File (default)
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)
     D                                     PREFIX(D#)

      * Valid Payments layout (default)
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)
     D                                     PREFIX(D#)

      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120

      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      *  Transaction details file parameter for FT000652
     D TRNDET          DS          3000

      *  Transaction details extension file parameter for FT000652
     D TRNEXT          DS          3000

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D IDX             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0

     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0

     D C#CURR          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7

      * Parameter for FT000940
     D P#PYCD          S                   LIKE(PYCHCD)

      ** Parameters for FT000652
     D MRTCD           S             10
     D TRNTYP          S              2
     D CHGCDE          S              5
     D INKC            S              1

      ** Parameters for FT000981
     D WRTCD           S             10A
     D PAYAMT          S             13P 0
     D PAYCCY          S              3A
     D SMCCY           S              3A
     D CHGCCY          S              3A
     D CHGEXC          S             13P 8
     D STP             S              1A
     D TOTCHG          S             13P 0
     D CHGAMT          S             13P 0
     D PTIERC          S             13A   DIM(11)
     D PTIERA          S             13A   DIM(11)
     D SETTAMT         S             13P 0
     D*CHARGEDR*       S             12A                                                      CGL029
     D CHARGEDR        S             18A                                                      CGL029
     D ADDDEDUCT       S              1A

      * Parameters for AOCCYCV0
     D D#DTA           DS           256
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
     D  D#IMDIN               23     23
     D  D#IRATE               24     36P 8
     D  D#OMDIN               23     23
     D  D#ORATE               24     36P 8
     D C#ACTN          S              8
      *                                                                                       CFT120
      ** Charges to the DR of Currency                                                        CFT120
      *                                                                                       CFT120
     D P_ChgDRCcy      S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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

      ** Initialization
      *
     C                   EVAL      RETCODEIN = *BLANKS
     C                   EVAL      FLDNAMXAR = *BLANKS
     C                   EVAL      MSGIDXAR  = *BLANKS
     C                   EVAL      MSGDTAXAR = *BLANKS
     C                   EVAL      WFLDNMXAR = *BLANKS
     C                   EVAL      WMSGIDXAR  = *BLANKS
     C                   EVAL      WMSGDTAXAR = *BLANKS
     C                   EVAL      WIX = 0
     C                   EVAL      IDX = 0

      * Validate
     C                   EXSR      VMISC05

      * If charge amount is not the same as default, warning

     C                   IF        SACTION = 'I' OR SACTION = 'A'

     C                   IF        @MI5CD <> D#O2AMC5
     C                             AND OKM5CD <> 'N'
     C                   MOVE      'W'           OKM5CD
     C                   ADD       1             WIX
     C                   MOVEL     'M5CD'        WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3175'     WMSGIDXAR(WIX)
     C                   ENDIF
     C                   ENDIF

      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKM5CD = 'N' OR OKM5CDE = 'N'
     C                   EVAL      RETCODEIN = 'Error'
     C                   ENDIF

      * RETURN

     C                   RETURN
      *****************************************************************
      /EJECT
      ************************************************************
      * VMISC05 - VALIDATION OF MISCELLANEOUS CHARGE 5
      ************************************************************
      *
     C     VMISC05       BEGSR

      * Validate miscellaneous charge code 5

     C                   IF        M5CDE <> *BLANKS
     C                   EXSR      VM5CODE
     C                   ENDIF

      * If charge code is not the same as default, warning

     C                   IF        SACTION = 'I' OR SACTION = 'A'
     C                   IF        M5CDE <> D#O2M5CD
     C                             AND OKM5CDE <> 'N'
     C                   MOVE      'W'           OKM5CDE
     C                   ADD       1             WIX
     C                   MOVEL     'M5CDE'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3188'     WMSGIDXAR(WIX)
     C                   ENDIF
     C                   ENDIF

      *  Access currency record
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      @CCCY         C#CURR
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   IF        C#RTCD <> *BLANKS
     C                   MOVEL     'AOCURRR0'    DBFILE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EVAL       DBASE = 1
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      @INCY = A6INCY
     C                   EVAL      @NBDP = A6NBDP
     C                   EVAL      @TPSD = A6TPSD
     C                   ENDIF

      *  Miscellaneous Charge 5
      *  ----------------------
      *  Miscellaneous Charge 5 is optional.
      *  If entered must be valid for charge currency details

      ** Change to IF conditioning to re-default if M5CD = *blanks or
      ** charges to the DR of had changed.

     C                   If        M5CD = *BLANKS or PCDROCHG = 'Y'
      *
      * If charge code <> blank and charge amount = blank, recalculate
      * charge amount
     C                   IF        M5CDE <> *BLANKS AND OKM5CDE <> 'N'
      *
      ** Also call FT000981 if charges to the DR of field has changed and
      ** charge code is not blank.
     C                             or PCDROCHG = 'Y' and M5CDE <> *BLANKS
     C                             AND OKM5CDE <> 'N'                                         244227

     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      O2CCDE        C#CURR
     C     SDCURR        PARM      *BLANKS       DSSDY

      * If use transaction exchange rate, add it in
     C                   IF        CHTRCY = 'Y'
     C                   EVAL      CHGEXC = O2XRTE
     C                   ELSE
     C                   EVAL      CHGEXC = A6SPRT
     C                   ENDIF

     C     CFT120        IFEQ      'Y'                                                        CFT120
     C                   MOVEL     @CDRO         CHARGEDR                                     CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     SCDRO         CHARGEDR                                     CFT120
     C                   ENDIF                                                                CFT120
     C                   CALLB     'FT000981'
      * OUTPUTS:
      *
      ** Return Code (10A)
      ** Payment Amount (13,0)
      ** Payment Currency (3A)
      ** Charges Currency (3A)
      ** Exchange Rate from transaction (13,8)
      ** STP flag (1A)
      ** Payment Charge Code (5A)
      ** Settle Amount (13,0)                                                                 CFT120
      ** Charges to debit of account (18A)                                                    CFT120
      ** Add deduct indicator (1A)                                                            CFT120
      ** Charges to the DR of Currency (3A)                                                   CFT120
      *                                                                                       CFT120
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      OTPYAM        PAYAMT
     C                   PARM      OTPCCY        PAYCCY
     C                   PARM      OTSMCY        SMCCY
     C                   PARM      O2CCDE        CHGCCY
     C                   PARM                    CHGEXC
     C                   PARM      'M'           STP
     C                   PARM      M5CDE         CHGCDE
     C                   PARM      OTSMAM        SETTAMT
     C**********         PARM      SCDRO         CHARGEDR                                     CFT120
     C                   PARM                    CHARGEDR                                     CFT120
     C                   PARM      OTADDC        ADDDEDUCT
     C                   PARM      OTCDRC        P_ChgDRCcy                                   CFT120
      *
      * RETURNS:
      ** Total Charge (13,0)
      ** Chargeable Amount (13,0)
      ** Charge per Tier (11 x 13A)
      ** Amount being charged by Tier (11 x 13A)
     C                   PARM                    TOTCHG
     C                   PARM                    CHGAMT
     C                   PARM                    PTIERC
     C                   PARM                    PTIERA

     C                   EVAL      @MI5CD = TOTCHG

     C                   Z-ADD     TOTCHG        @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M5CD

     C                   ELSE

      * If M5CD blank or zero initialise output fields
     C                   MOVE      *BLANKS       M5CD
     C                   Z-ADD     *ZERO         @MI5CD
     C                   Z-ADD     *ZERO         @M5CH
     C                   ENDIF

     C                   ELSE

      * ? processing - Charge enquiry

     C     '?'           SCAN      M5CD

     C                   IF        %FOUND

     C                   IF        OKM5CDE = 'N' OR M5CDE = *BLANKS
     C                   MOVE      'N'           OKM5CD
     C                   ADD       1             IDX
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3206'     MSGIDXAR(IDX)
     C                   ELSE

     C                   EVAL      TRNDET = VALIDPMNT
     C                   EVAL      TRNEXT = VALIDPMTX

     C                   CALLB     'FT000652'
     C                   PARM      *BLANKS       MRTCD
     C                   PARM                    TRNDET
     C                   PARM                    TRNEXT
     C                   PARM      'OP'          TRNTYP
     C                   PARM      M5CDE         CHGCDE
     C                   PARM                    INKC
     C                   ENDIF
     C                   ENDIF

     C                   MOVE(P)   M5CD          ZFIELD
     C                   EVAL      ZADIG = 11 - @NBDP
     C                   EVAL      ZADEC = @NBDP

      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNOK = 'N'
      * Send error to screen
     C                   MOVE      'N'           OKM5CD
     C                   ADD       1             IDX
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3268'     MSGIDXAR(IDX)

     C                   ELSE
     C                   Move      ZFIELD        @MI5CD
      * Format amount for screen
     C                   MOVE      ZFIELD        @@AMTW
     C                   Z-ADD     @NBDP         @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M5CD
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
     C************************************************************
     C* END MISCELLANEOUS CHARGE 5 VALIDATION
     C************************************************************
      /EJECT
      ************************************************************
      * VM5CODE - VALIDATION OF MISCELLANEOUS CHARGE 5 CODE
      ************************************************************
      *
     C     VM5CODE       BEGSR

      * ? processing

     C     '?'           SCAN      M5CDE

     C                   IF        %FOUND

     C                   CALLB     'FT000940'
     C                   PARM      *BLANKS       P#PYCD

     C                   IF        P#PYCD <> *BLANKS
     C                   EVAL      M5CDE = P#PYCD
     C                   ENDIF

     C                   ENDIF

      * Check if charge code exists in payment charge definition file

     C     M5CDE         CHAIN     FTPCHGL0

     C                   IF        NOT %FOUND
     C                   MOVE      'N'           OKM5CDE
     C                   ADD       1             IDX
     C                   MOVEL     'M5CDE'       FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3267'     MSGIDXAR(IDX)
     C                   ENDIF

     C                   ENDSR
     C/EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST

      * INPUTS
      *  Return Code
     C                   PARM                    RETCODEIN

      *  Screen fields
     C                   PARM                    TRANINPRIM
     C                   PARM                    TRANINFOUR

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR

     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTAXAR
      *
      *  OK Flags
     C                   PARM                    OKFLAGSDS

      *  Validation Work Fields
     C                   PARM                    VAL@FIELDS

     C                   PARM                    VALIDPMNT
     C                   PARM                    VALIDPMTX
      *  Saved default charges
     C                   PARM                    DEFVALID
     C                   PARM                    DEFVALIDX
      *
      ** Charges to the debit of - field changed (Y or blank)
     C                   PARM                    PCDROCHG          1

      * Access Funds Transfer details via access program

     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      C#RTCD
     C                   PARM      '*FIRST'      C#OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY

      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
      *                                                                                       CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 2                                                  CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
