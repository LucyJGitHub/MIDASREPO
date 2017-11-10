     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments charges defaults')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTOPAY1DT - FT Outgoing Payments Charges Defaults            *
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
      *  Prev Amend No. AR898162           Date 25Nov14               *
      *                 CFT157             Date 29Aug14               *
      *                 AR895223           Date 19Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 AR572042           Date 21Sep12               *
      *                 AR941425           Date 27Mar12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26557           Date 30Oct09               *
      *                 258229             Date 05Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257897             Date 26Nov08               *
      *                 256564             Date 17Sep08               *
      *                 257122             Date 09Oct08               *
      *                 256255             Date 02Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 242480A            Date 12Dec06
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12705           Date 17Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 01Aug03               *
      *                 CFT018             Date 30Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009 *CREATE     Date 13Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  AR898162 - Charge codes passed via API are lost              *
      *             (Child: AR898163)                                 *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  AR895223 - Exchange rates should allow 5 digits. Fix is to   *
      *             increase the number of digits to five. Applied    *
      *             fix 257663. (Child: AR895224)                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  AR572042 - Charges Amount are incorrectly defaulted.  Allow  *
      *             manual input of charge amounts in API             *
      *  AR941425 - Defaulted transfer commission charge amount       *
      *             warning error                                     *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG26557 - Transfer Commission Charge Amount field value not *
      *           displayed on confirmation screen.  Apply GEMS fix   *
      *           258341.                                             *
      *  258229 - FT fees and charges - Wrong amendment of payment    *
      *           (refreshing commission)                             *
      *  257897 - Prevent DB Error on mathematical ops.               *
      *           Apply client fix 250881                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  257122 - FT OP Miscellaneous Charge error                    *
      *  256255 - Charges in Paid Currency is incorrect.              *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  242480A- Change message FTM0012 to FTM0028 for warning       *
      *           message during validation of screen rate vesrus     *
      *           default rate.                                       *
      *  BUG12705 - Error in ordering customer       (Recompile)      *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  CAP084 - MidasPlus Changes                                   *
      *  CFT018 - Spread Set should be blank when pay and settle      *
      *           currency are the same.                              *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTPCHGL0  IF   E           K DISK
      *****************************************************************

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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

      * Factors table
     D FCTR            S              4  0 DIM(4) CTDATA PERRCD(1)

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

      ** Payment Extension Details layout
     D TRANINPRMB    E DS                  EXTNAME(FTOPY1APD)

      ** Flags to indicate whether transaction fields are valid
     D OKFLAGSDS     E DS                  EXTNAME(FTEOPY1PD)

      * Validation Work Fields
     D VAL@FIELDS    E DS                  EXTNAME(FTV@OPAYPD)

      * Valid Payments layout
     D VALIDPMNT     E DS                  EXTNAME(FTVOPAYPD)
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029

      ** Valid Outgoing Payments Extension File
     D VALIDPMTX     E DS                  EXTNAME(FTVOPY2PD)

      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)
     D NEWPMTSCN4    E DS                  EXTNAME(FTOPY6PD)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      *  Transaction details file parameter for FT000980
     D TRNDET          DS          3000

      *  Transaction details extension file parameter for FT000980
     D TRNEXT          DS          3000

      *  Data structure to retrieve VAT rate
     DVATDS            DS
     D WVATR                  10     12P 4

     D* Parameters for AOCCYCV0
     D D#DTA           DS           256
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
     D  D#IMDIN               23     23
     D  D#IRATE               24     36P 8
     D  D#OMDIN               23     23
     D  D#ORATE               24     36P 8
                                                                                             242480A
      ** Message Data for FTM0028                                                            242480A
     D FTM0028DS       DS            34                                                      242480A
     D   FTM28RT1              1     16A                                                     242480A
     D   FTM28SP1             17     17A                                                     242480A
     D   FTM28RT2             18     33A                                                     242480A
     D   FTM28SP2             34     34A                                                     242480A
                                                                                             242480A

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

      * Parameters for FT000980

     D RTN980          S             10
     D TRNTYP          S              2
     D PRCMTD          S              1
     D MESTYP          S              3
     D SETNUM          S              3

      * Parameters for ZALIGN/ZEDIT

     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZALIGNOK        S              1
     D ZADIG           S              2  0

      * Parameters for AOCURRR0

     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#K101          S              3

      * Work fields

     D CRATE           S             14
     D CDATE           S              6

     D* Parameters for AOCCYCV0
     D C#ACTN          S              8

      * Charges Currency Decimal Places
     D ChgCcyDP        S                   Like(A6NBDP)

      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
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

     C                   EVAL      RETCODEIN = *BLANKS
     C                   EVAL      FLDNAMXAR = *BLANKS
     C                   EVAL      MSGIDXAR  = *BLANKS
     C                   EVAL      MSGDTAXAR = *BLANKS
     C                   EVAL      WFLDNMXAR = *BLANKS
     C                   EVAL      WMSGIDXAR  = *BLANKS
     C                   EVAL      WMSGDTAXAR = *BLANKS
     C                   EVAL      IDX = 0
     C                   EVAL      WIX = 0
      *
     C                   CLEAR                   TRNDET
     C                   CLEAR                   TRNEXT

      * Charge currency

     C                   SELECT
     C                   WHEN      BTCHCY = 'C'

     C                   IF        OTADDC = 'A'
     C                   EVAL      O2CCDE = OTSMCY
     C                   ELSE
     C                   EVAL      O2CCDE = OTPCCY
     C                   ENDIF

     C                   WHEN      BTCHCY = 'L'
     C                   EVAL      O2CCDE = BJLCCY

     C                   WHEN      BTCHCY = 'F'
     C                   EVAL      O2CCDE = FCHCCY

     C                   WHEN      BTCHCY = 'B'
     C                   EVAL      O2CCDE = BJCYCD

     C                   OTHER
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     O2CCDE        DBKEY
     C                   EXSR      *PSSR
     C                   ENDSL

     C                   EVAL      @CCCY = O2CCDE

      * If using exchange rate from transaction, move in the correct
      * rate.

     C                   IF        CHTRCY = 'Y'
     C                   EVAL      O2XRTE = OTRATE
     C                   ENDIF
      *
      ** If settle amount is blank , move '*CALCSET' into return code,
      ** otherwise move '*CALCPAY' into return code for call of
      ** FT000980
      *
     C                   IF        SSMAM = *BLANKS
     C                   EVAL      RTN980 = '*CALCSET'
     C                   ELSE
     C                   IF        SPYAM = *BLANKS
     C                   EVAL      RTN980 = '*CALCPAY'
     C                   ELSE
     C                   EVAL      RTN980 = '*NONE   '
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      TRNDET = VALIDPMNT
     C                   EVAL      TRNEXT = VALIDPMTX

      * Default charges

     C                   CALLB     'FT000980'
     C                   PARM                    RTN980
     C                   PARM                    TRNDET
     C                   PARM                    TRNEXT
     C                   PARM      'OP'          TRNTYP
     C                   PARM      'M'           PRCMTD
     C                   PARM      *BLANKS       MESTYP
     C                   PARM      *BLANKS       SETNUM

     C                   EVAL      VALIDPMNT = TRNDET
     C                   EVAL      VALIDPMTX = TRNEXT
                                                                                            AR898162
      ** If charge codes present already, set the charge codes and                          AR898162
      ** amounts                                                                            AR898162
                                                                                            AR898162
     C                   IF        TRCDE <> ' ' or FXCDE <> ' ' or                          AR898162
     C                             TXCDE <> ' ' or CQCDE <> ' ' or                          AR898162
     C                             CACDE <> ' ' or STCDE <> ' ' or                          AR898162
     C                             SPCDE <> ' ' or MSCDE <> ' ' or                          AR898162
     C                             M1CDE <> ' ' or M2CDE <> ' ' or                          AR898162
     C                             M3CDE <> ' ' or M4CDE <> ' ' or                          AR898162
     C                             M5CDE <> ' '                                             AR898162
     C                   EXSR      SET_CHARGECODS                                           AR898162
     C                   EXSR      SET_CHARGEAMTS                                           AR898162
     C                   ENDIF                                                              AR898162

      * Move charge codes to screen fields

     C                   IF        TRCDE = *BLANKS AND STRCD = *BLANKS                      AR572042
     C                   EVAL      TRCDE = O2TFCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTTRCM = *ZERO                                           AR572042
     C                   EVAL      O2TFCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        FXCDE = *BLANKS AND SCHCD = *BLANKS                      AR572042
     C                   EVAL      FXCDE = O2FXCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTOPCHCM = *ZERO                                         AR572042
     C                   EVAL      O2FXCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        TXCDE = *BLANKS AND STXCD = *BLANKS                      AR572042
     C                   EVAL      TXCDE = O2TXCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTTXCH = *ZERO                                           AR572042
     C                   EVAL      O2TXCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        CQCDE = *BLANKS AND SCQCD = *BLANKS                      AR572042
     C                   EVAL      CQCDE = O2CQCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTCQCH = *ZERO                                           AR572042
     C                   EVAL      O2CQCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        CACDE = *BLANKS AND SCSTD = *BLANKS                      AR572042
     C                   EVAL      CACDE = O2CACD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTCSTA = *ZERO                                           AR572042
     C                   EVAL      O2CACD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        STCDE = *BLANKS AND STCD = *BLANKS                       AR572042
     C                   EVAL      STCDE = O2SSCD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMCS = *ZERO                                           AR572042
     C                   EVAL      O2SSCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        SPCDE = *BLANKS AND SSPCD = *BLANKS                      AR572042
     C                   EVAL      SPCDE = O2SPCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTSPCH = *ZERO                                           AR572042
     C                   EVAL      O2SPCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        MSCDE = *BLANKS AND SMSCD = *BLANKS                      AR572042
     C                   EVAL      MSCDE = O2MSCD
     C                   ELSE                                                               AR572042
     C                   EVAL      OTMSCH = *ZERO                                           AR572042
     C                   EVAL      O2MSCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        M1CDE = *BLANKS AND M1CD = *BLANKS                       AR572042
     C                   EVAL      M1CDE = O2M1CD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMC1 = *ZERO                                           AR572042
     C                   EVAL      O2M1CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        M2CDE = *BLANKS AND M2CD = *BLANKS                       AR572042
     C                   EVAL      M2CDE = O2M2CD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMC2 = *ZERO                                           AR572042
     C                   EVAL      O2M2CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        M3CDE = *BLANKS AND M3CD = *BLANKS                       AR572042
     C                   EVAL      M3CDE = O2M3CD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMC3 = *ZERO                                           AR572042
     C                   EVAL      O2M3CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        M4CDE = *BLANKS AND M4CD = *BLANKS                       AR572042
     C                   EVAL      M4CDE = O2M4CD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMC4 = *ZERO                                           AR572042
     C                   EVAL      O2M4CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *                                                                                     AR572042
     C                   IF        M5CDE = *BLANKS AND M5CD = *BLANKS                       AR572042
     C                   EVAL      M5CDE = O2M5CD
     C                   ELSE                                                               AR572042
     C                   EVAL      O2AMC5 = *ZERO                                           AR572042
     C                   EVAL      O2M5CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              AR572042
      *
      ** If screen spread set <> defaulted spread set, issue warning
      ** message
      *
     C                   IF        SPDSET <> *BLANKS
     C                   IF        SPDSET <> O2FXSP
     C                   EVAL      O2FXSP = SPDSET
     C                   MOVE      'W'           OKSPST
     C                   ADD       1             WIX
     C                   MOVEL     'SPDSET'      WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3154'     WMSGIDXAR(WIX)
     C                   ENDIF
     C                   ELSE
     C                   IF        SSMCY <> SPCCY                                             CFT018
     C                   EVAL      SPDSET = O2FXSP
     C                   ENDIF                                                                CFT018
     C                   ENDIF
      *
      ** If screen payment date offset code <> defaulted payment date offset
      ** code, issue warning message
      *
     C                   IF        SOFCD <> *BLANKS
     C                   IF        SOFCD <> O2PDOF
     C                   EVAL      O2PDOF = SOFCD
     C                   MOVE      'W'           OKOFCD
     C                   ADD       1             WIX
     C                   MOVEL     'SOFCD'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3222'     WMSGIDXAR(WIX)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SOFCD = O2PDOF
     C                   ENDIF
      *
      ** If screen rate <> calculated rate, issue warning message
      ** else if screen rate is blank, move calculated rate in and
      ** calculated pay amount
      *
     C                   IF        SRATE <> *BLANKS
     C                   EVAL      FTM0028DS = *BLANKS                                       242480A
                                                                                             242480A

      * Convert decimal rate to character rate for comparison against
      * screen rate

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      OTRATE        ZFIELD
     C                   EVAL      ZADEC = 8

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        CRATE
     C                   MOVEL     CRATE         FTM28RT1                                    242480A
     C                   MOVEL     SRATE         FTM28RT2                                    242480A
                                                                                             242480A
      * Convert screen rate to decimal rate for comparision to default rate.                 242480A
                                                                                             242480A
     C                   EVAL      ZFIELD = *BLANKS                                          242480A
     C                   MOVE      SRATE         ZFIELD                                      242480A
     C                   EVAL      ZADEC = 8                                                 242480A
     C**********         EVAL      ZADIG = 4                                        242480A AR895223
     C                   EVAL      ZADIG = 5                                                AR895223
                                                                                             242480A
     C                   CALLB     'ZALIGN'                                                  242480A
     C                   PARM                    ZALIGNOK                                    242480A
     C                   PARM                    ZFIELD                                      242480A
     C                   PARM                    ZADEC                                       242480A
     C                   PARM                    ZADIG                                       242480A
                                                                                             242480A
     C     *LIKE         DEFINE    OTRATE        TPRATE                                      242480A
     C                   MOVE      ZFIELD        TPRATE                                      242480A

     C**********         IF        CRATE <> SRATE                                            242480A
     C                   IF        OTRATE <> TPRATE                                          242480A

      **Convert*screen*rate to decimal rate for update                                       242480A
      *********                                                                              242480A
     C*********          EVAL      ZFIELD = *BLANKS                                          242480A
     C*********          MOVE      SRATE         ZFIELD                                      242480A
     C*********          EVAL      ZADEC = 8                                                 242480A
     C*********          EVAL      ZADIG = 4                                                 242480A
      *********                                                                              242480A
     C*********          CALLB     'ZALIGN'                                                  242480A
     C*********          PARM                    ZALIGNOK                                    242480A
     C*********          PARM                    ZFIELD                                      242480A
     C*********          PARM                    ZADEC                                       242480A
     C*********          PARM                    ZADIG                                       242480A
      *********                                                                              242480A
     C*********          MOVE      ZFIELD        OTRATE                                      242480A
     C                   Z-ADD     TPRATE        OTRATE                                      242480A

      * Warning

     C                   MOVE      'W'           OKRATE
     C                   ADD       1             WIX
     C                   MOVEL     'SRATE'       WFLDNMXAR(WIX)
     C**********         MOVEL     'FTM0012'     WMSGIDXAR(WIX)                              242480A
     C                   MOVEL     'FTM0028'     WMSGIDXAR(WIX)                              242480A
     C     *LIKE         DEFINE    WIX           WX                                          242480A
     C                   Z-ADD     WIX           WX                                          242480A
     C                   MOVEL     FTM0028DS     WMSGDTAXAR(WX)                              242480A
     C                   ENDIF

     C                   ELSE

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      OTRATE        ZFIELD
     C                   EVAL      ZADEC = 8

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        SRATE

     C                   IF        @MDIN = 1
     C                   EVAL      OTRATED = OTRATE
     C                   ELSE
     C                   EVAL      OTRATED = 1 / OTRATE
     C                   ENDIF
      * Pay amount
     C                   MOVE      SPCCY         C#K101

     C                   EXSR      CURRED

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      OTPYAM        ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        SPYAM

     C                   EVAL      OTPYAMD = OTPYAM
     C                   DO        A6NBDP
     C                   EVAL      OTPYAMD = OTPYAMD / 10
     C                   ENDDO

      * Settle amount
     C                   MOVE      SSMCY         C#K101

     C                   EXSR      CURRED

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      OTSMAM        ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        SSMAM

     C                   Eval      OTSMAMD = OTSMAM

     C                   DO        A6NBDP
     C                   EVAL      OTSMAMD = OTSMAMD / 10
     C                   ENDDO

     C                   ENDIF
      *
      ** If screen settle date <> defaulted date, issue warning
      ** message else if screen settle date is blank, move defaulted
      ** date into screen field
      *
     C                   IF        SPYDT <> *BLANKS
     C                   MOVE      OTSLDTD1      CDATE

     C                   IF        SPYDT <> CDATE

     C                   MOVE      SPYDT         OTSLDTD1
      * Warning
     C                   MOVE      'W'           OKPYDT
     C                   ADD       1             WIX
     C                   MOVEL     'SPYDT'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3156'     WMSGIDXAR(WIX)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      OTSLDTD1      SPYDT

      ** Convert settle date into various formats

     C                   CALLB     'FTVSEDT'
      * INPUTS
      *  Return Code
     C                   PARM                    RETCODEOUT

      *  Screen fields
     C                   PARM                    TRANINPRIM

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR

     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTAXAR

      *  OK Flags
     C                   PARM                    OKFLAGSDS

      *  Validation Work Fields
     C                   PARM                    VAL@FIELDS

     C                   EVAL      OTSLDT = @SLDT
     C                   EVAL      OTSLDTD1 = @SLDTD1
     C                   EVAL      OTSLDTD2 = @SLDTD2
     C                   EVAL      OTSLDTD3 = @SLDTD3
     C                   ENDIF
      *
      ** If screen pay date <> defaulted date, issue warning
      ** message else if screen pay date is blank, move defaulted
      ** date into screen field
      *
     C                   IF        SPYVD <> *BLANKS
     C                   MOVE      OTPVDTD1      CDATE
     C                   IF        SPYVD <> CDATE

     C                   MOVE      SPYVD         OTPVDTD1
      * Warning
     C                   MOVE      'W'           OKPYVD
     C                   ADD       1             WIX
     C                   MOVEL     'SPYVD'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3155'     WMSGIDXAR(WIX)
     C                   ENDIF

     C                   ELSE
     C                   MOVE      OTPVDTD1      SPYVD

      ** Convert pay date into various formats

     C                   CALLB     'FTVPYDT'
      * INPUTS
      *  Return Code
     C                   PARM                    RETCODEOUT

      *  Screen fields
     C                   PARM                    TRANINPRIM

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR

     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTAXAR

      *  OK Flags
     C                   PARM                    OKFLAGSDS

      *  Validation Work Fields
     C                   PARM                    VAL@FIELDS

     C                   Eval      OTPRBD = @PRBD
     C                   Eval      OTPVDT = @PVDT
     C                   Eval      OTPVDTD1 = @PVDTD1
     C                   Eval      OTPVDTD2 = @PVDTD2
     C                   Eval      OTPVDTD3 = @PVDTD3

     C                   ENDIF

      ** Default VAT flags, total VAT, VAT rate, file DAF format for
      ** charges, entry charges

     C                   EXSR      CHGENT
     C                   EXSR      CHGVAT
      * RETURN

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * CURRED - READ CURRENCY FILE                                   *
      *****************************************************************

     C     CURRED        BEGSR

     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM                    C#K101
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR
      /EJECT
      *****************************************************************
      * CHGVAT - Default VAT flags, VAT rate, VAT totals              *
      *****************************************************************

     C     CHGVAT        BEGSR

      ** Default VAT flags

     C                   IF        @CFT010 = 'Y'

      ** Telex VAT flag

     C                   IF        O2TXCD <> *BLANKS
     C     O2TXCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT2 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT2 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT2 = 'Y'
     C                   ENDIF

      ** Cheque VAT flag

     C                   IF        O2CQCD <> *BLANKS
     C     O2CQCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT3 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT3 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT3 = 'Y'
     C                   ENDIF

      ** Costs Abroad VAT flag

     C                   IF        O2CACD <> *BLANKS
     C     O2CACD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT4 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT4 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT4 = 'Y'
     C                   ENDIF

      ** SWIFT standard VAT flag

     C                   IF        O2SSCD <> *BLANKS
     C     O2SSCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT14 = 'Y'
     C                   ELSE
     C                   EVAL      VAT14 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT14 = 'Y'
     C                   ENDIF

      ** SWIFT priority VAT flag

     C                   IF        O2SPCD <> *BLANKS
     C     O2SPCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT5 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT5 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT5 = 'Y'
     C                   ENDIF

      ** Miscellaneous VAT flag

     C                   IF        O2MSCD <> *BLANKS
     C     O2MSCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT6 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT6 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT6 = 'Y'
     C                   ENDIF

      ** Miscellaneous 1 VAT flag

     C                   IF        O2M1CD <> *BLANKS
     C     O2M1CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT9 = 'Y'
     C                   ELSE
     C                   EVAL      VAT9 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT9 = 'Y'
     C                   ENDIF

      ** Miscellaneous 2 VAT flag

     C                   IF        O2M2CD <> *BLANKS
     C     O2M2CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT10 = 'Y'
     C                   ELSE
     C                   EVAL      VAT10 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT10 = 'Y'
     C                   ENDIF

      ** Miscellaneous 3 VAT flag

     C                   IF        O2M3CD <> *BLANKS
     C     O2M3CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT11 = 'Y'
     C                   ELSE
     C                   EVAL      VAT11 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT11 = 'Y'
     C                   ENDIF

      ** Miscellaneous 4 VAT flag

     C                   IF        O2M4CD <> *BLANKS
     C     O2M4CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT12 = 'Y'
     C                   ELSE
     C                   EVAL      VAT12 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT12 = 'Y'
     C                   ENDIF

      ** Miscellaneous 5 VAT flag

     C                   IF        O2M5CD <> *BLANKS
     C     O2M5CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT13 = 'Y'
     C                   ELSE
     C                   EVAL      VAT13 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT13 = 'Y'
     C                   ENDIF

      ** Transfer Commission VAT flag

     C                   IF        O2TFCD <> *BLANKS
     C     O2TFCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT1 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT1 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT1 = 'Y'
     C                   ENDIF

      ** FX/change VAT flag

     C                   IF        O2FXCD <> *BLANKS
     C     O2FXCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      SVAT7 = 'Y'
     C                   ELSE
     C                   EVAL      SVAT7 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT7 = 'Y'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      SVAT2 = 'N'
     C                   EVAL      SVAT3 = 'N'
     C                   EVAL      SVAT4 = 'N'
     C                   EVAL      VAT14 = 'N'
     C                   EVAL      SVAT5 = 'N'
     C                   EVAL      SVAT6 = 'N'
     C                   EVAL      VAT9  = 'N'
     C                   EVAL      VAT10 = 'N'
     C                   EVAL      VAT11 = 'N'
     C                   EVAL      VAT12 = 'N'
     C                   EVAL      VAT13 = 'N'
     C                   EVAL      SVAT1 = 'N'
     C                   EVAL      SVAT7 = 'N'
     C                   ENDIF

      ** VAT totals

     C                   EVAL      @VATD = 0
     C                   EVAL      @VATT = 0

      * If apply V.A.T. flag is 'Y', calculate V.A.T. charge

      * Transfer commission

     C                   IF        SVAT1 = 'Y'
     C                   EVAL      @VATD = @VATD + @TRCD
     C                   EVAL      @VATT = @VATT + @TRCM
     C                   ENDIF

      * Telex

     C                   IF        SVAT2 = 'Y'
     C                   EVAL      @VATD = @VATD + @TXCD
     C                   EVAL      @VATT = @VATT + @TXCH
     C                   ENDIF

      * Cheque

     C                   IF        SVAT3 = 'Y'
     C                   EVAL      @VATD = @VATD + @CQCD
     C                   EVAL      @VATT = @VATT + @CQCH
     C                   ENDIF

      * Costs

     C                   IF        SVAT4 = 'Y'
     C                   EVAL      @VATD = @VATD + @CSTD
     C                   EVAL      @VATT = @VATT + @CSTA
     C                   ENDIF

      * SWIFT priority

     C                   IF        SVAT5 = 'Y'
     C                   EVAL      @VATD = @VATD + @SPCD
     C                   EVAL      @VATT = @VATT + @SPCH
     C                   ENDIF

      * Miscellaneous

     C                   IF        SVAT6 = 'Y'
     C                   EVAL      @VATD = @VATD + @MSCD
     C                   EVAL      @VATT = @VATT + @MSCH
     C                   ENDIF

      * Fx/Change commission

     C                   IF        SVAT7 = 'Y' and @S01494 = 'Y'
     C                   EVAL      @VATD = @VATD + @CHCD
     C                   EVAL      @VATT = @VATT + @CHCM
     C                   ENDIF

      * Miscellaneous 1

     C                   IF        VAT9  = 'Y'
     C                   EVAL      @VATD = @VATD + @MI1CD
     C                   EVAL      @VATT = @VATT + @M1CH
     C                   ENDIF

      * Miscellaneous 2

     C                   IF        VAT10 = 'Y'
     C                   EVAL      @VATD = @VATD + @MI2CD
     C                   EVAL      @VATT = @VATT + @M2CH
     C                   ENDIF

      * Miscellaneous 3

     C                   IF        VAT11 = 'Y'
     C                   EVAL      @VATD = @VATD + @MI3CD
     C                   EVAL      @VATT = @VATT + @M3CH
     C                   ENDIF

      * Miscellaneous 4

     C                   IF        VAT12 = 'Y'
     C                   EVAL      @VATD = @VATD + @MI4CD
     C                   EVAL      @VATT = @VATT + @M4CH
     C                   ENDIF

      * Miscellaneous 5

     C                   IF        VAT13 = 'Y'
     C                   EVAL      @VATD = @VATD + @MI5CD
     C                   EVAL      @VATT = @VATT + @M5CH
     C                   ENDIF

      * SWIFT standard

     C                   IF        VAT14 = 'Y'
     C                   EVAL      @VATD = @VATD + @SSCD
     C                   EVAL      @VATT = @VATT + @SSCH
     C                   ENDIF

      * V.A.T. amount = total x V.A.T. rate.

     C                   If        @VATD <> 0 and @VATR <> 0                                  257897
     C                   Eval(H)   @VATD = @VATD * @VATR
     C                   EndIf                                                                257897
     C                   If        @VATT <> 0 and @VATR <> 0                                  257897
     C                   Eval(H)   @VATT = @VATT * @VATR
     C                   EndIf                                                                257897

      * Now convert to levied currency
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = @VATD
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE


      ** Set up rate to use, depending on flag from SDFTFRPD.
     C     *LIKE         Define    OTRATE        Rate_to_use

     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = OTRATE
     C                   Else
     C                   Eval      Rate_to_use = O2XRTE
     C                   EndIf

     C                   ENDSR
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * SET_CHARGECODS - SET CHARGE CODES                             *                     AR898162
      *****************************************************************                     AR898162
     C     SET_CHARGECODSBEGSR                                                              AR898162
     C                   EVAL      O2TFCD = TRCDE                                           AR898162
     C                   EVAL      O2FXCD = FXCDE                                           AR898162
     C                   EVAL      O2TXCD = TXCDE                                           AR898162
     C                   EVAL      O2CQCD = CQCDE                                           AR898162
     C                   EVAL      O2CACD = CACDE                                           AR898162
     C                   EVAL      O2SSCD = STCDE                                           AR898162
     C                   EVAL      O2SPCD = SPCDE                                           AR898162
     C                   EVAL      O2MSCD = MSCDE                                           AR898162
     C                   EVAL      O2M1CD = M1CDE                                           AR898162
     C                   EVAL      O2M2CD = M2CDE                                           AR898162
     C                   EVAL      O2M3CD = M3CDE                                           AR898162
     C                   EVAL      O2M4CD = M4CDE                                           AR898162
     C                   EVAL      O2M5CD = M5CDE                                           AR898162
     C                   ENDSR                                                              AR898162
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * SET_CHARGEAMTS - SET CHARGE AMOUNTS                           *                     AR898162
      *****************************************************************                     AR898162
     C     SET_CHARGEAMTSBEGSR                                                              AR898162
                                                                                            AR898162
      ** Get Charges Currency Decimal Places                                                AR898162
                                                                                            AR898162
     C                   Eval      C#K101  = O2CCDE                                         AR898162
     C                   Exsr      CURRED                                                   AR898162
     C                   Eval      ChgCcyDP = A6NBDP                                        AR898162
                                                                                            AR898162
      ** Transfer commission                                                                AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      STRCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTTRCM                                     AR898162
      ** FX/Change                                                                          AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      SCHCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTOPCHCM                                   AR898162
      ** Telex                                                                              AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      STXCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTTXCH                                     AR898162
      ** Cheque                                                                             AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      SCQCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTCQCH                                     AR898162
      ** Costs abroad                                                                       AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      SCSTD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTCSTA                                     AR898162
      ** SWIFT standard                                                                     AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      STCD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMCS                                     AR898162
      ** SWIFT priority                                                                     AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      SSPCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTSPCH                                     AR898162
      ** Miscellaneous                                                                      AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      SMSCD         ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        OTMSCH                                     AR898162
      ** Miscellaneous 1                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M1CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMC1                                     AR898162
      ** Miscellaneous 2                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M2CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMC2                                     AR898162
      ** Miscellaneous 3                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M3CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMC3                                     AR898162
      ** Miscellaneous 4                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M4CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMC4                                     AR898162
      ** Miscellaneous 5                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M5CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        O2AMC5                                     AR898162
                                                                                            AR898162
     C                   ENDSR                                                              AR898162
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * ZALIGN - EDIT A SCREEN FIELD TO AN AMOUN                      *                     AR898162
      *****************************************************************                     AR898162
     C     ZALIGN        BEGSR                                                              AR898162
     C                   EVAL      ZADEC = ChgCcyDP                                         AR898162
     C                   EVAL      ZADIG = 11 - ChgCcyDP                                    AR898162
     C                   CALLB     'ZALIGN'                                                 AR898162
     C                   PARM                    ZALIGNOK                                   AR898162
     C                   PARM                    ZFIELD                                     AR898162
     C                   PARM                    ZADEC                                      AR898162
     C                   PARM                    ZADIG                                      AR898162
     C                   ENDSR                                                              AR898162
      /EJECT
      *****************************************************************
      * CHGENT - Default entry charges, DAF format                    *
      *****************************************************************

     C     CHGENT        BEGSR

      * Get Charges Currency Decimal Places
     C                   Eval      C#K101  = O2CCDE
     C                   Exsr      CURRED
     C                   Eval      ChgCcyDP = A6NBDP

      ** Set up rate to use, depending on flag from SDFTFRPD.
     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = OTRATE
     C                   Else
     C                   Eval      Rate_to_use = O2XRTE
     C                   EndIf

      * Entry charges

     C**********         IF        OTCDRO <> *ZEROS                                           256255
     C                   IF        OTCDRO <> *BLANKS                                          256255
      *                                                                                       CFT120
     C                   IF        OTCDRC = *BLANKS AND CFT120 = 'Y'                          CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   EVAL      @RCCY = BJCYCD
     C                   ELSE                                                                 CFT120
     C                   EVAL      @RCCY = OTCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ELSE
     C                   IF        OTADDC = 'A'
     C                   EVAL      @RCCY = OTSMCY
     C                   ELSE
     C                   EVAL      @RCCY = OTPCCY
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      @CCCY         C#K101
     C                   EXSR      CURRED


      ** Transfer commission (Returned in Charges Ccy.  Should be in Levied Ccy).

     C                   If        OTDUMA1 <> 0                                               258229
     C                   Eval      OTTRCM = OTDUMA1                                           258229
     C                   EndIf                                                                258229
                                                                                              258229
     C                   IF        OTTRCM <> 0
     C                             AND STRCD = ' '                                            258341
     C                   Z-ADD     OTTRCM        OTDUMA1
     C                   Eval      OtTrcmd = OTTRCM

     C                   Eval      @@AmtW = OTTRCM
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        STRCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTTRCM
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTTRCM        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @TRCM
     C                   Z-ADD     OTTRCMD       @TRCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @TRCD
     C                   Z-ADD     *ZEROS        @TRCM
     C**********         Z-ADD     *ZEROS        OTDUMA1                                    AR941425
     C                   Z-ADD     OTTRCM        OTDUMA1                                    AR941425
     C**********         MOVE      *BLANKS       STRCD                                        258341
     C                   Z-ADD     *ZEROS        OTTRCM                                       258341
     C                   ENDIF

      ** FX/Change

     C                   IF        OTOPCHCM <> 0
     C                             AND SCHCD = ' '                                            258341
     C                   Z-ADD     OTOPCHCM      OTOPDUM7
     C                   Eval      OTOPDUM7 = OTOPCHCM

     C                   Eval      @@AmtW = OTOPCHCM
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        SCHCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTOPCHCM
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTOPCHCM      PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @CHCM
     C                   Z-ADD     OTOPDUM7      @CHCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @CHCD
     C                   Z-ADD     *ZEROS        @CHCM
     C                   Z-ADD     *ZEROS        OTOPDUM7
     C**********         MOVE      *BLANKS       SCHCD                                        258341
     C                   Z-ADD     *ZEROS        OTOPCHCM                                     258341
     C                   ENDIF

      ** Telex

     C                   IF        OTTXCH <> 0
     C                             AND STXCD = ' '                                            258341
     C                   Z-ADD     OTTXCH        OTDUMA2
     C                   Eval      OTTXCHD = OTTXCH

     C                   Eval      @@AmtW = OTTXCH
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        STXCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTTXCH
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTTXCH        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @TXCH
     C                   Z-ADD     OTTXCHD       @TXCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @TXCD
     C                   Z-ADD     *ZEROS        @TXCH
     C                   Z-ADD     *ZEROS        OTDUMA2
     C**********         MOVE      *BLANKS       STXCD                                        258341
     C                   Z-ADD     *ZEROS        OTTXCH                                       258341
     C                   ENDIF

      ** Cheque

     C                   IF        OTCQCH <> 0
     C                             AND SCQCD = ' '                                            258341
     C                   Z-ADD     OTCQCH        OTDUMA3
     C                   Eval      OTCQCHD = OTCQCH

     C                   Eval      @@AmtW = OTCQCH
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        SCQCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTCQCH
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTCQCH        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @CQCH
     C                   Z-ADD     OTCQCHD       @CQCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @CQCD
     C                   Z-ADD     *ZEROS        @CQCH
     C                   Z-ADD     *ZEROS        OTDUMA3
     C**********         MOVE      *BLANKS       SCQCD                                        258341
     C                   Z-ADD     *ZEROS        OTCQCH                                       258341
     C                   ENDIF

      ** Costs abroad

     C                   IF        OTCSTA <> 0
     C                             AND SCSTD = ' '                                            258341
     C                   Z-ADD     OTCSTA        OTDUMA4
     C                   Eval      OTCSTAD = OTCSTA

     C                   Eval      @@AmtW = OTCSTAD
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        SCSTD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTCSTA
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTCSTA        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @CSTA
     C                   Z-ADD     OTCSTAD       @CSTD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @CSTD
     C                   Z-ADD     *ZEROS        @CSTA
     C                   Z-ADD     *ZEROS        OTDUMA4
     C**********         MOVE      *BLANKS       SCSTD                                        258341
     C                   Z-ADD     *ZEROS        OTCSTA                                       258341
     C                   ENDIF

      ** SWIFT standard

     C                   IF        O2AMCS <> 0
     C                             AND STCD = ' '                                             258341

     C                   Eval      @@AmtW = O2AMCS
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        STCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMCS
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMCS        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @SSCH
     C                   Z-ADD     O2AMCS        @SSCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @SSCD
     C                   Z-ADD     *ZEROS        @SSCH
     C**********         MOVE      *BLANKS       STCD                                         258341
     C                   Z-ADD     *ZEROS        O2AMCS                                       258341
     C                   ENDIF

      ** SWIFT priority

     C                   IF        OTSPCH <> 0
     C                             AND SSPCD = ' '                                            258341
     C                   Z-ADD     OTSPCH        OTDUMA5
     C                   Eval      OTSPCHD = OTSPCH

     C                   Eval      @@AmtW = OTSPCHD
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        SSPCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTSPCH
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTSPCH        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @SPCH
     C                   Z-ADD     OTSPCHD       @SPCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @SPCD
     C                   Z-ADD     *ZEROS        @SPCH
     C                   Z-ADD     *ZEROS        OTDUMA5
     C**********         MOVE      *BLANKS       SSPCD                                        258341
     C                   Z-ADD     *ZEROS        OTSPCH                                       258341
     C                   ENDIF

      ** Miscellaneous

     C                   IF        OTMSCH <> 0
     C                             AND SMSCD = ' '                                            258341
     C**********         Z-ADD     OTMSCH        OTDUMA6                                      257122
     C                   Eval      OTMSCHD = OTMSCH
     C                   Eval      OTMSCH = OTDUMA6                                           257122

     C                   Eval      @@AmtW = OTMSCH
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        SMSCD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = OTMSCH
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      OTMSCH        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MSCH
     C                   Z-ADD     OTMSCHD       @MSCD

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MSCD
     C                   Z-ADD     *ZEROS        @MSCH
     C                   Z-ADD     *ZEROS        OTDUMA6
     C**********         MOVE      *BLANKS       SMSCD                                        258341
     C                   Z-ADD     *ZEROS        OTMSCH                                       258341
     C                   ENDIF

      ** Miscellaneous 1

     C                   IF        O2AMC1 <> 0
     C                             AND M1CD = ' '                                             258341

     C                   Z-ADD     O2AMC1        @MI1CD

     C                   Eval      @@AmtW = O2AMC1
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        M1CD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMC1
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMC1        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @M1CH
     C                   Z-ADD     PLev_Charge   O2AMM1

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI1CD
     C                   Z-ADD     *ZEROS        @M1CH
     C**********         MOVE      *BLANKS       M1CD                                         258341
     C                   Z-ADD     *ZEROS        O2AMC1                                       258341
     C                   ENDIF

      ** Miscellaneous 2

     C                   IF        O2AMC2 <> 0
     C                             AND M2CD = ' '                                             258341

     C                   Z-ADD     O2AMC2        @MI2CD

     C                   Eval      @@AmtW = O2AMC2
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        M2CD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMC2
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMC2        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @M2CH
     C                   Z-ADD     @M2CH         O2AMM2

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI2CD
     C                   Z-ADD     *ZEROS        @M2CH
     C**********         MOVE      *BLANKS       M2CD                                         258341
     C                   Z-ADD     *ZEROS        O2AMC2                                       258341
     C                   ENDIF

      ** Miscellaneous 3

     C                   IF        O2AMC3 <> 0
     C                             AND M3CD = ' '                                             258341

     C                   Z-ADD     O2AMC3        @MI3CD

     C                   Eval      @@AmtW = O2AMC3
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        M3CD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMC3
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMC3        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @M3CH
     C                   Z-ADD     @M3CH         O2AMM3

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI3CD
     C                   Z-ADD     *ZEROS        @M3CH
     C**********         MOVE      *BLANKS       M3CD                                         258341
     C                   Z-ADD     *ZEROS        O2AMC3                                       258341
     C                   ENDIF

      ** Miscellaneous 4

     C                   IF        O2AMC4 <> 0
     C                             AND M4CD = ' '                                             258341

     C                   Z-ADD     O2AMC4        @MI4CD

     C                   Eval      @@AmtW = O2AMC4
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        M4CD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMC4
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMC4        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @M4CH
     C                   Z-ADD     @M4CH         O2AMM4

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI4CD
     C                   Z-ADD     *ZEROS        @M4CH
     C**********         MOVE      *BLANKS       M4CD                                         258341
     C                   Z-ADD     *ZEROS        O2AMC4                                       258341
     C                   ENDIF

      ** Miscellaneous 5

     C                   IF        O2AMC5 <> 0
     C                             AND M5CD = ' '                                             258341

     C                   Z-ADD     O2AMC5        @MI5CD

     C                   Eval      @@AmtW = O2AMC5
     C                   Eval      @@Qecn = ChgCcyDP
     C                   Exsr      FmtAmt
     C                   MOVE      @@AMTD        M5CD

     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = O2AMC5
     C                   EVAL      D#TCCY = @RCCY
     C                   EVAL      D#FCCY = O2CCDE

      ** use FTCALCLEV
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      O2AMC5        PCharge_Amt      13 0
     C                   PARM      SPCCY         PPay_Ccy          3
     C                   PARM      SSMCY         PSettle_Ccy       3
     C                   PARM      @CCCY         PCharge_Ccy       3
     C                   PARM      @RCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @M5CH
     C                   Z-ADD     @M5CH         O2AMM5

     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI5CD
     C                   Z-ADD     *ZEROS        @M5CH
     C**********         MOVE      *BLANKS       M5CD                                         258341
     C                   Z-ADD     *ZEROS        O2AMC5                                       258341
     C                   ENDIF

      * File DAF format (not like real DAF)

     C     @CCCY         IFNE      BJCYCD
     C                   Z-ADD     A6NBDP        @FCDP
     C                   ELSE
     C                   Z-ADD     @BCDP         @FCDP
     C                   ENDIF

      * Transfer commission

     C     @FCDP         ADD       1             W                 1 0
     C     OTTRCM        DIV       FCTR(W)       OTTRCMD

      * Telex Charge

     C     @FCDP         ADD       1             W
     C     OTTXCH        DIV       FCTR(W)       OTTXCHD

      * Cheque Charge

     C     @FCDP         ADD       1             W
     C     OTCQCH        DIV       FCTR(W)       OTCQCHD

      * Costs abroad

     C     @FCDP         ADD       1             W
     C     OTCSTA        DIV       FCTR(W)       OTCSTAD

      * SWIFT priority charge

     C     @FCDP         ADD       1             W
     C     OTSPCH        DIV       FCTR(W)       OTSPCHD

      * Miscellaneous charge

     C     @FCDP         ADD       1             W
     C     OTMSCH        DIV       FCTR(W)       OTMSCHD

     C                   ENDSR
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR

     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14

     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RETCODEIN

      *  Screen fields
     C                   PARM                    TRANINPRIM
     C                   PARM                    TRANINPRMB
     C                   PARM                    NEWPMTSCN4

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR

     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTAXAR

      *  OK Flags
     C                   PARM                    OKFLAGSDS
      * Valid payment layout (DS) from/to caller
     C                   PARM                    VALIDPMNT
     C                   PARM                    VALIDPMTX

      *  Validation Work Fields
     C                   PARM                    VAL@FIELDS

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Read SDFTFRPD

     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Read V.A.T. details if CFT010 switched ON

     C                   IF        @CFT010 = 'Y'
     C                   CALL      'AOVATR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM                    VATDS

     C                   EVAL      @VATR = WVATR
     C                   ENDIF
      *
      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01494'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @S01494           1
     C                   Else
     C                   Movel     'N'           @S01494
     C                   End

      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 is on.                                CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   Parm      *BLANKS       @RTCD                                        CFT120
     C                   Parm      '*VERIFY'     @OPTN                                        CFT120
     C                   Parm      'CFT120'      @SARD                                        CFT120
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT120
                                                                                              CFT120
     C                   If        @RTCD <> *Blanks and                                       CFT120
     C                             @RTCD <> '*NRF   '                                         CFT120
     C     *LOCK         In        LDA                                                        CFT120
     C                   Movel     'SCSARDPD'    DBFILE                                       CFT120
     C                   Movel     '003'         DBASE                                        CFT120
     C                   Movel     'CFT120'      DBKEY                                        CFT120
     C                   Out       LDA                                                        CFT120
     C                   Exsr      *PSSR                                                      CFT120
     C                   End                                                                  CFT120
                                                                                              CFT120
     C                   If        @RTCD = *Blanks                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   Else                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   End                                                                  CFT120
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
** FCTR
0001
0010
0100
1000
