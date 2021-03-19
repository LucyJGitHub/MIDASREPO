     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments charges defaults')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTIPAY1DT - FT Incoming Payments Charges Defaults            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR1088819          Date 03Jun20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR898162           Date 25Nov14               *
      *                 CFT157             Date 29Aug14               *
      *                 AR895223           Date 19Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 AR572042           Date 21Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257897             Date 26Nov08               *
      *                 256564             Date 17Sep08               *
      *                 BUG16701           Date 13Mar08               *
      *                 BUG16753           Date 07Mar08               *
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244952             Date 18Jan07               *
      *                 242480A            Date 12Dec06
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 240813             Date 06Jul06
      *                 CSD027             Date 09Dec05               *
      *                 BUG4029            Date 17Aug04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 19Aug03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009 *CREATE     Date 13Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1088819 - Issue on job names during SSL enabling of JDBC   *
      *              calls                                            *
      *            - Applied for MD050405                             *
      *  CSD102 - Password Length Extension                           *
      *  MD046248 - Finastra Rebranding                               *
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
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257897 - Prevent DB Error on mathematical ops.               *
      *           Apply client fix 250881                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16701 - IPAY & OPAY default charge for customer group not *
      *           reflected                                           *
      *  BUG16753 - Selected Charge Code in IPAY not reflected.       *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  244952 - Don't overwrite details of charges if not blank     *
      *  242480A- Change message FTM0012 to FTM0028 for warning       *
      *           message during validation of screen rate vesrus     *
      *           default rate.                                       *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240813 - Ensure that calculated IPRATE value will not be     *
      *           blanked out to prevent divide by zero error from    *
      *           occuring.                                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4029- Decimal data error when no charges                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CAP084 - When calling FTVCALCLEV, set Charge currency to     *
      *           be equal to PICCY instead of I2CCDE.                *
      *           Perform defaulting if no value entered from         *
      *           interface.                                          *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTPCHGL0  IF   E           K DISK
     FINPAY     IF   E           K DISK
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
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *

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

      * Factors table
     D FCTR            S              4  0 DIM(4) CTDATA PERRCD(1)
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NWIP1SCNFMT   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Lvl 1 Scrn 1/2 details from Incoming trans.
     D NWIP1ASCNFMT  E DS                  EXTNAME(FTIPY1APD)
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming trans.
      ** - screen format
     D NWIP5SCNFMT   E DS                  EXTNAME(FTIPY5PD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NWIPFILFMT    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments (additional details) for file update
     D NWIP2FILFMT   E DS                  EXTNAME(FTVIPY2PD)
      *
      ** Incoming Payments for file update - file format
     D P#IPFILFMT    E DS                  EXTNAME(FTVIPAYPD) PREFIX(P#)
      *
      ** Incoming Payments (additional details) for file update
     D P#IP2FILFMT   E DS                  EXTNAME(FTVIPY2PD) PREFIX(P#)
      *
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              219241
      ** External DS for Midas Message Management ICD                                         219241
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
      *
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D NOSLOC                 29     31
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CFT120
      ** External DS for SAR details                                                          CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120

      *  Transaction details file parameter for FT000980
     D TRNDET          DS          3000
     D  D#DATE              2822   2824P 0                                                    CSD102

      *  Transaction details extension file parameter for FT000980
     D TRNEXT          DS          3000

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
      *
      * Date formatting
     D WODATE          DS             6
     D  ODD                    1      2
     D  OMM                    3      4
     D  OYY                    5      6
      *
     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
      *
      ** DS for Default Charge Amounts
     D PCHARGES        DS           196
     D  DDTRCM                 1     14
     D  DDTXCH                15     28
     D  DDCQCH                29     42
     D  DDADCH                43     56
     D  DDTLCH                57     70
     D  DDMSCH                71     84
     D  DDCHCM                85     98
     D  DDVATT                99    112
     D  DDVATD               113    126
     D  M1CH                 127    140
     D  M2CH                 141    154
     D  M3CH                 155    168
     D  M4CH                 169    182
     D  M5CH                 183    196
      *
      ** Fields needed in setting default pay value date
     D PPYFLDS         DS
     D  CNUMPY                 1      6
     D  CCYPY                  7      9
     D***ACODPY*               10     12                                                      CGL029
     D***ACSQPY*               13     15                                                      CGL029
     D***BRCAPY*               16     18                                                      CGL029
     D  ACODPY                10     19                                                       CGL029
     D  ACSQPY                20     21                                                       CGL029
     D  BRCAPY                22     24                                                       CGL029

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
     D @FCDP           S              1  0
     D W               S              1  0
     D @MI1CH          S             13  0
     D @MI2CH          S             13  0
     D @MI3CH          S             13  0
     D @MI4CH          S             13  0
     D @MI5CH          S             13  0
     D BVLD            S              5P 0

     D* Parameters for AOCCYCV0
     D C#ACTN          S              8
      *
      * Parameters for ZDATE1
     D ZDATIN          S              6A
     D ZDAYNO          S              5P 0
     D ZERR            S              1A
      *
      ** Input Charge Currency
     D PICCY           S              3
      *
      ** Output Charge Currency
     D POCCY           S              3
      *
      ** Input Charge Currency No. of Decimal Places
     D PINBDP          S              1  0
      *
      ** Output Charge Currency No. of Decimal Places
     D PONBDP          S              1  0
                                                                                              CGL029
      ** AONOSTR0 Account Code Parameter                                                      CGL029
     D PACCD           S             10A                                                      CGL029
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                              CGL029
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
     C                   EVAL      WMSGDTXAR = *BLANKS
     C                   EVAL      IDX = 0
     C                   EVAL      WIX = 0
      *
     C                   CLEAR                   TRNDET
     C                   CLEAR                   TRNEXT
     C                   EVAL      D#DATE = 0                                                 CSD102

     C                   EVAL      P#IPFILFMT = NWIPFILFMT
     C                   EVAL      P#IP2FILFMT = NWIP2FILFMT

      * Charge currency

     C                   SELECT
     C                   WHEN      BTCHCY = 'C'

     C                   IF        IPADDC = 'A'
     C                   EVAL      P#I2CCDE = IPSMCY
     C                   ELSE
     C                   EVAL      P#I2CCDE = IPPCCY
     C                   ENDIF

     C                   WHEN      BTCHCY = 'L'
     C                   EVAL      P#I2CCDE = BJLCCY

     C                   WHEN      BTCHCY = 'F'
     C                   EVAL      P#I2CCDE = FCHCCY

     C                   WHEN      BTCHCY = 'B'
     C                   EVAL      P#I2CCDE = BJCYCD

     C                   OTHER
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     P#I2CCDE      DBKEY
     C                   EXSR      *PSSR
     C                   ENDSL
      *
      ** Input Charge Currency.
      *
     C                   EVAL      PICCY = P#I2CCDE
      *
      ** Get Input Currency decimal places.
      *
     C                   MOVE      PICCY         C#K101
     C                   EXSR      CURRED
     C                   EVAL      PINBDP = A6NBDP
      *
      ** Output Charge Currency.
      *
     C***********        IF        IPCDRO <> *ZEROS                                           CSD027
     C                   IF        IPCDRO <> *BLANKS                                          CSD027
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y' AND IPCDRC = *BLANKS OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   EVAL      POCCY = BJCYCD
     C                   ELSE                                                                 CFT120
     C                   EVAL      POCCY = IPCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ELSE
     C                   IF        IPADDC = 'A'
     C                   EVAL      POCCY = IPSMCY
     C                   ELSE
     C                   EVAL      POCCY = IPPCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Get Output Currency decimal places.
      *
     C                   MOVE      POCCY         C#K101
     C                   EXSR      CURRED
     C                   EVAL      PONBDP = A6NBDP

      * If using exchange rate from transaction, move in the correct
      * rate.

     C                   IF        CHTRCY = 'Y'
     C                   IF        PICCY = IPSMCY AND POCCY = IPPCCY
     C                             OR POCCY = IPSMCY AND PICCY = IPPCCY
     C                   EVAL      P#I2XRTE = IPRATE
     C                   ENDIF
     C                   ENDIF
      *
      * Default pay date
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      CNUMPY        PCUST             6
     C                   PARM      CCYPY         PCYCD             3
     C**********         PARM      ACODPY        PACCD             4                          CGL029
     C                   PARM      ACODPY        PACCD                                        CGL029
     C                   PARM      ACSQPY        PACSN             2
     C                   PARM      *BLANKS       PNONB             2
     C                   PARM      BRCAPY        PBRCD             3
     C                   PARM      *BLANKS       PCSSN            10
     C                   PARM      *BLANKS       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      CCYPY         ZCCY
     C                   MOVE      NOSLOC        ZLOC
     C                   ELSE
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
     C                   IF        ZCCY = BJCYCD
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     1             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZEROS        ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
     C                   Z-ADD     ZDYNBR        P#IPPVDT
      *
     C                   ELSE
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     2             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM      *ZEROS        ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
      *
     C                   Z-ADD     ZDYNBR        P#IPPVDT
     C                   ENDIF
      *
      ** Setup DAF Pay value date 1 and defualt date to screen field.
      *
     C                   Z-ADD     P#IPPVDT      ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   EVAL      P#IPPVDTD1 = ZDATE
      *
      * Default settle date
      *
     C                   Z-ADD     BJRDNB        P#IPSLDT
      *
      ** Setup DAF settle value date 1 and default date to screen field.
      *
     C                   Z-ADD     P#IPSLDT      ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT
     C                   PARM                    ZDATE
     C                   PARM      *BLANKS       ZADATE
      *
     C                   EVAL      P#IPSLDTD1 = ZDATE
      *
      ** If settle amount is blank , move '*CALCSET' into return code,
      ** otherwise move '*CALCPAY' into return code for call of
      ** FT000980
      *
     C                   IF        DDSMAM = *BLANKS
     C                   EVAL      RTN980 = '*CALCSET'
     C                   ELSE
     C                   IF        DDPYAM = *BLANKS
     C                   EVAL      RTN980 = '*CALCPAY'
     C                   ELSE
     C                   EVAL      RTN980 = '*NONE   '
     C                   ENDIF
     C                   ENDIF
      *
      ** Check to see if a key change has occurred. If the key hasn't
      ** changed, don't bother to default the charges.
      *
     C                   MOVE      'N'           Key_Change        1
      *
     C***********        IF        CDRO = 0                                                   CSD027
     C                   IF        CDRO = *BLANKS                                             CSD027
      *
      ** Convert screen numbers to numeric, so that they may be compared
      ** with saved amounts.
      *
     C     *LIKE         DEFINE    IPSMAM        Work_Sett_Amt
     C     *LIKE         DEFINE    SRATE         Work_Rate
      *
      ** Get Settlement Currency decimal places.
      *
     C                   MOVE      DDSMCY        C#K101
      *
     C                   EXSR      CURRED
      *
     C                   EVAL      ZFIELD = DDSMAM
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 14 - ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   IF        ZALIGNOK = 'Y'
     C                   MOVE      ZFIELD        Work_Sett_Amt
     C                   ENDIF
      *
      ** Set up screen rate
      *
     C                   EVAL      ZADEC = 8
     C**********         EVAL      ZADIG = 4                                                AR895223
     C                   EVAL      ZADIG = 5                                                AR895223
     C                   EVAL      ZFIELD = DDRATE
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   IF        ZALIGNOK = 'Y'
     C                   MOVE      ZFIELD        Work_Rate
     C                   ENDIF
      *
     C                   IF        SADDC <> DDADDC and DDSMCY <> DDPCCY
     C                             or SADDC <> DDADDC and SPCCY <> DDPCCY
     C                             or SPCCY <> DDPCCY and SADDC = 'D'
     C                             or SSMCY <> DDSMCY and SADDC = 'A'
     C                             or Work_Sett_Amt <> SSMAM
     C                             or Work_Rate <> SRATE
     C                             or SADDC <> DDADDC
     C                             or Already_Run <> 'Y'
      *
     C                   EVAL      Key_Change = 'Y'
     C                   MOVE      'Y'           Already_Run       1
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Only default charges if a key change has occurred.
      ** Blank out charge codes and amounts since they are defaulted in
      ** FT000980
      *
     C                   EVAL      P#I2TFCD = *BLANKS
     C                   EVAL      P#I2FXCD = *BLANKS
     C                   EVAL      P#I2TXCD = *BLANKS
     C                   EVAL      P#I2CQCD = *BLANKS
     C                   EVAL      P#I2ADCD = *BLANKS
     C                   EVAL      P#I2TPCD = *BLANKS
     C                   EVAL      P#I2MSCD = *BLANKS
     C                   EVAL      P#I2M1CD = *BLANKS
     C                   EVAL      P#I2M2CD = *BLANKS
     C                   EVAL      P#I2M3CD = *BLANKS
     C                   EVAL      P#I2M4CD = *BLANKS
     C                   EVAL      P#I2M5CD = *BLANKS
     C                   EVAL      P#IPTRCM = 0
     C                   EVAL      P#IPTRCMD = 0
     C                   EVAL      P#IPTXCH = 0
     C                   EVAL      P#IPTXCHD = 0
     C                   EVAL      P#IPCQCH = 0
     C                   EVAL      P#IPCQCHD = 0
     C                   EVAL      P#IPADCH = 0
     C                   EVAL      P#IPADCHD = 0
     C                   EVAL      P#IPTLCH = 0
     C                   EVAL      P#IPTLCHD = 0
     C                   EVAL      P#IPMSCH = 0
     C                   EVAL      P#IPMSCHD = 0
     C                   EVAL      P#IPINCHCM = 0
     C                   EVAL      P#IPDUMA1 = 0
     C                   EVAL      P#IPDUMA2 = 0
     C                   EVAL      P#IPDUMA3 = 0
     C                   EVAL      P#IPDUMA4 = 0
     C                   EVAL      P#IPDUMA5 = 0
     C                   EVAL      P#IPDUMA6 = 0
     C                   EVAL      P#IPINDUM7 = 0
     C                   EVAL      P#I2AMM1 = 0
     C                   EVAL      P#I2AMM2 = 0
     C                   EVAL      P#I2AMM3 = 0
     C                   EVAL      P#I2AMM4 = 0
     C                   EVAL      P#I2AMM5 = 0
     C                   EVAL      P#I2MSC01 = 0
     C                   EVAL      P#I2MSC02 = 0
     C                   EVAL      P#I2MSC03 = 0
     C                   EVAL      P#I2MSC04 = 0
     C                   EVAL      P#I2MSC05 = 0

      *                                                                                       240813
      ** If IPRATE is not equal to zero, save this to a work variable                         240813
      ** so it can be retrieved later.                                                        240813
      *                                                                                       240813
     C                   IF        IPRATE <> 0                                                240813
     C                   MOVE      *BLANKS       WRATE                                        240813
     C                   EVAL      WRATE = IPRATE                                             240813
     C                   ENDIF                                                                240813
                                                                                              240813
     C                   EVAL      TRNDET = P#IPFILFMT
     C                   EVAL      TRNEXT = P#IP2FILFMT

      * Default charges

     C                   CALLB     'FT000980'
     C                   PARM                    RTN980
     C                   PARM                    TRNDET
     C                   PARM                    TRNEXT
     C                   PARM      'IN'          TRNTYP
     C                   PARM      'M'           PRCMTD
     C                   PARM      *BLANKS       MESTYP
     C                   PARM      *BLANKS       SETNUM

      * Insert mode
     C/COPY WNCPYSRC,FTH00551

     C                   IF        DDACTN = 'I'
     C                   EVAL      NWIPFILFMT = TRNDET
     C                   EVAL      NWIP2FILFMT = TRNEXT
                                                                                            AR898162
      ** If charge codes present already, set the charge codes and                          AR898162
      ** amounts                                                                            AR898162
                                                                                            AR898162
     c                   IF        TRCDE <> ' ' or FXCDE <> ' ' or                          AR898162
     c                             TXCDE <> ' ' or CQCDE <> ' ' or                          AR898162
     c                             ADCDE <> ' ' or TPCDE <> ' ' or                          AR898162
     c                             MSCDE <> ' ' or M1CDE <> ' ' or                          AR898162
     c                             M2CDE <> ' ' or M3CDE <> ' ' or                          AR898162
     c                             M4CDE <> ' ' or M5CDE <> ' '                             AR898162
     C                   EXSR      SET_CHARGECODS                                           AR898162
     C                   EXSR      SET_CHARGEAMTS                                           AR898162
     C                   ENDIF                                                              AR898162
     C/COPY WNCPYSRC,FTH00552

      * If screen pay/settle amounts are not blank, move these back into
      * data structure since FT000980 overwrites them

     C                   IF        DDPYAM <> *BLANKS
     C                   EVAL      IPPYAM = P#IPPYAM
     C                   ENDIF

     C                   IF        DDSMAM <> *BLANKS
     C                   EVAL      IPSMAM = P#IPSMAM
     C                   ENDIF

      * Move charge codes to screen fields

     C**********         EVAL      TRCDE = I2TFCD                                           BUG16753
     C**********         EVAL      FXCDE = I2FXCD                                           BUG16753
     C**********         EVAL      TXCDE = I2TXCD                                           BUG16753
     C**********         EVAL      CQCDE = I2CQCD                                           BUG16753
     C**********         EVAL      ADCDE = I2ADCD                                           BUG16753
     C**********         EVAL      TPCDE = I2TPCD                                           BUG16753
     C**********         EVAL      MSCDE = I2MSCD                                           BUG16753
     C**********         EVAL      M1CDE = I2M1CD                                           BUG16753
     C**********         EVAL      M2CDE = I2M2CD                                           BUG16753
     C**********         EVAL      M3CDE = I2M3CD                                           BUG16753
     C**********         EVAL      M4CDE = I2M4CD                                           BUG16753
     C**********         EVAL      M5CDE = I2M5CD                                           BUG16753
                                                                                            BUG16701
      ** If the user did not enter any values, use the default                              BUG16701
                                                                                            BUG16701
     C                   IF        TRCDE = *BLANKS                                          BUG16701
     C                             AND DDTRCD = *BLANKS                                     AR572042
     C                   EVAL      TRCDE = I2TFCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPTRCM = *ZERO                                           AR572042
     C                   EVAL      I2TFCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        FXCDE = *BLANKS                                          BUG16701
     C                             AND DDCHCD = *BLANKS                                     AR572042
     C                   EVAL      FXCDE = I2FXCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPINCHCM = *ZERO                                         AR572042
     C                   EVAL      I2FXCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        TXCDE = *BLANKS                                          BUG16701
     C                             AND DDTXCD = *BLANKS                                     AR572042
     C                   EVAL      TXCDE = I2TXCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPTXCH = *ZERO                                           AR572042
     C                   EVAL      I2TXCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        CQCDE = *BLANKS                                          BUG16701
     C                             AND DDCQCD = *BLANKS                                     AR572042
     C                   EVAL      CQCDE = I2CQCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPCQCH = *ZERO                                           AR572042
     C                   EVAL      I2CQCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        ADCDE = *BLANKS                                          BUG16701
     C                             AND DDADCD = *BLANKS                                     AR572042
     C                   EVAL      ADCDE = I2ADCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPADCH = *ZERO                                           AR572042
     C                   EVAL      I2ADCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        TPCDE = *BLANKS                                          BUG16701
     C                             AND DDTLCD = *BLANKS                                     AR572042
     C                   EVAL      TPCDE = I2TPCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPTLCH = *ZERO                                           AR572042
     C                   EVAL      I2TPCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        MSCDE = *BLANKS                                          BUG16701
     C                             AND DDMSCD = *BLANKS                                     AR572042
     C                   EVAL      MSCDE = I2MSCD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      IPMSCH = *ZERO                                           AR572042
     C                   EVAL      I2MSCD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        M1CDE = *BLANKS                                          BUG16701
     C                             AND M1CD = *BLANKS                                       AR572042
     C                   EVAL      M1CDE = I2M1CD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      I2MSC01 = *ZERO                                          AR572042
     C                   EVAL      I2M1CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        M2CDE = *BLANKS                                          BUG16701
     C                             AND M2CD = *BLANKS                                       AR572042
     C                   EVAL      M2CDE = I2M2CD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      I2MSC02 = *ZERO                                          AR572042
     C                   EVAL      I2M2CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        M3CDE = *BLANKS                                          BUG16701
     C                             AND M3CD = *BLANKS                                       AR572042
     C                   EVAL      M3CDE = I2M3CD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      I2MSC03 = *ZERO                                          AR572042
     C                   EVAL      I2M3CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        M4CDE = *BLANKS                                          BUG16701
     C                             AND M4CD = *BLANKS                                       AR572042
     C                   EVAL      M4CDE = I2M4CD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      I2MSC03 = *ZERO                                          AR572042
     C                   EVAL      I2M3CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *                                                                                     AR572042
     C                   IF        M5CDE = *BLANKS                                          BUG16701
     C                             AND M5CD = *BLANKS                                       AR572042
     C                   EVAL      M5CDE = I2M5CD                                           BUG16701
     C                   ELSE                                                               AR572042
     C                   EVAL      I2MSC05 = *ZERO                                          AR572042
     C                   EVAL      I2M5CD = *BLANKS                                         AR572042
     C                   ENDIF                                                              BUG16701
      *
      ** Save the 'key' defaulted fields, to allow the check for a key
      ** change.
      *
      ** Define save fields
      *
     C     *LIKE         DEFINE    IPCDRO        SCDRO
     C     *LIKE         DEFINE    IPADDC        SADDC
     C     *LIKE         DEFINE    IPSMCY        SSMCY
     C     *LIKE         DEFINE    IPPCCY        SPCCY
     C     *LIKE         DEFINE    IPSMAM        SSMAM
     C     *LIKE         DEFINE    IPRATE        SRATE
     C     *LIKE         DEFINE    IPRATE        WRATE                                        240813
      *
      ** Save data within fields
      *
     C                   EVAL      SCDRO = IPCDRO
     C                   EVAL      SADDC = IPADDC
     C                   EVAL      SSMCY = IPSMCY
     C                   EVAL      SPCCY = IPPCCY
     C                   EVAL      SSMAM = IPSMAM
     C                   EVAL      SRATE = IPRATE
      *
      ** If screen spread set <> defaulted spread set, issue warning
      ** message
      *
     C                   IF        SPDSET <> *BLANKS

     C                   IF        SPDSET <> I2FXSP
     C                   EVAL      I2FXSP = SPDSET
     C                   MOVE      'W'           OKSPST
     C                   ADD       1             WIX
     C                   MOVEL     'SPDSET'      WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3154'     WMSGIDXAR(WIX)
     C                   ENDIF

     C                   ELSE

     C                   IF        IPSMCY <> IPPCCY

     C                   IF        Key_Change = 'Y'
     C                   EVAL      SPDSET = I2FXSP
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SPDSET = *BLANKS
     C                   EVAL      I2FXSP = *BLANKS
     C                   ENDIF

     C                   ENDIF
      *
      ** If screen payment date offset code <> defaulted payment date offset
      ** code, issue warning message
      *
     C                   IF        SOFCD <> *BLANKS
     C                   IF        SOFCD <> I2PDOF
     C                   EVAL      I2PDOF = SOFCD
     C                   MOVE      'W'           OKOFCD
     C                   ADD       1             WIX
     C                   MOVEL     'SOFCD'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3222'     WMSGIDXAR(WIX)
     C                   ENDIF
     C                   ELSE

     C                   IF        Key_Change = 'Y'
     C                   EVAL      SOFCD = I2PDOF
     C                   ENDIF
     C                   ENDIF
      *
      ** If screen rate <> calculated rate, issue warning message
      ** else if screen rate is blank, move calculated rate in and
      ** calculated pay amount
      *
     C                   IF        DDRATE <> *BLANKS
     C                   EVAL      FTM0028DS = *BLANKS                                       242480A
                                                                                             242480A
      * Convert decimal rate to character rate for comparison against
      * screen rate

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      IPRATE        ZFIELD
     C                   EVAL      ZADEC = 8

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        CRATE
     C                   MOVEL     CRATE         FTM28RT1                                    242480A
     C                   MOVEL     DDRATE        FTM28RT2                                    242480A
                                                                                             242480A
      * Convert screen rate to decimal rate for comparision to default rate.                 242480A
                                                                                             242480A
     C                   EVAL      ZFIELD = *BLANKS                                          242480A
     C                   MOVE      DDRATE        ZFIELD                                      242480A
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
     C     *LIKE         DEFINE    IPRATE        TPRATE                                      242480A
     C                   MOVE      ZFIELD        TPRATE                                      242480A

     C**********         IF        CRATE <> DDRATE                                           242480A
     C                   IF        IPRATE <> TPRATE                                          242480A

      **Convert*screen*rate to decimal rate for update                                       242480A
      *********                                                                              242480A
     C*********          EVAL      ZFIELD = *BLANKS                                          242480A
     C*********          MOVE      DDRATE        ZFIELD                                      242480A
     C*********          EVAL      ZADEC = 8                                                 242480A
     C*********          EVAL      ZADIG = 4                                                 242480A
      *********                                                                              242480A
     C*********          CALLB     'ZALIGN'                                                  242480A
     C*********          PARM                    ZALIGNOK                                    242480A
     C*********          PARM                    ZFIELD                                      242480A
     C*********          PARM                    ZADEC                                       242480A
     C*********          PARM                    ZADIG                                       242480A
      *********                                                                              242480A
     C*********          MOVE      ZFIELD        IPRATE                                      242480A
     C                   Z-ADD     TPRATE        IPRATE                                      242480A

      * Warning

     C                   MOVE      'W'           OKRATE
     C                   ADD       1             WIX
     C                   MOVEL     'DDRATE'      WFLDNMXAR(WIX)
     C**********         MOVEL     'FTM0012'     WMSGIDXAR(WIX)                              242480A
     C                   MOVEL     'FTM0028'     WMSGIDXAR(WIX)                              242480A
     C                   MOVEL     FTM0028DS     WMSGDTXAR(WIX)                              242480A
     C                   ENDIF

     C                   ELSE

     C                   EVAL      ZFIELD = *BLANKS
      *                                                                                       240813
      ** If IPRATE is zero and WRATE is not = 0 it means that the rate                        240813
      ** value needs to be reintroduced to IPRATE to prevent divide by                        240813
      ** zero error.                                                                          240813
     C                   IF        IPRATE = 0 AND WRATE <> 0                                  240813
     C                   MOVE      WRATE         IPRATE                                       240813
     C                   ENDIF                                                                240813
     C                   MOVE      IPRATE        ZFIELD
                                                                                              240813
     C                   EVAL      ZADEC = 8

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDRATE

     C                   IF        IPMDIN = 1
     C                   EVAL      IPRATED = IPRATE
     C                   ELSE
     C                   EVAL      IPRATED = 1 / IPRATE
     C                   ENDIF
      * Pay amount
     C                   MOVE      DDPCCY        C#K101

     C                   EXSR      CURRED

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      IPPYAM        ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDPYAM

     C                   EVAL      IPPYAMD = IPPYAM
     C                   DO        A6NBDP
     C                   EVAL      IPPYAMD = IPPYAMD / 10
     C                   ENDDO

      * Settle amount
     C                   MOVE      DDSMCY        C#K101

     C                   EXSR      CURRED

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      IPSMAM        ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDSMAM

     C                   Eval      IPSMAMD = IPSMAM

     C                   DO        A6NBDP
     C                   EVAL      IPSMAMD = IPSMAMD / 10
     C                   ENDDO

     C                   ENDIF
      *
      ** If screen settle date <> defaulted date, issue warning
      ** message else if screen settle date is blank, move defaulted
      ** date into screen field
      *
     C                   IF        DDSLDT <> *BLANKS
     C                   MOVE      IPSLDTD1      CDATE

     C                   IF        DDSLDT <> CDATE
      * Warning
     C                   MOVE      'W'           OKSLDT
     C                   ADD       1             WIX
     C                   MOVEL     'DDSLDT'      WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3156'     WMSGIDXAR(WIX)
     C                   ENDIF

     C                   MOVE      DDSLDT        IPSLDTD1

     C                   ELSE

     C                   MOVE      IPSLDTD1      DDSLDT

     C                   ENDIF

      ** Convert settle date into various formats

     C                   EVAL      WZDATE = IPSLDTD1
      *
      ** Setup DAF settle value date 2
     C                   IF        ZYN < 72
     C                   Z-ADD     20            IPSLDTD2
     C                   ELSE
     C                   Z-ADD     19            IPSLDTD2
     C                   ENDIF
      *
      ** Setup DAF settle value date 3
     C                   IF        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   ENDIF
      *
     C                   MOVE      WODATE        IPSLDTD3
      *
     C                   MOVE      IPSLDTD1      ZDATIN
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   Z-ADD     ZDAYNO        IPSLDT
      *
      ** If screen pay date <> defaulted date, issue warning
      ** message else if screen pay date is blank, move defaulted
      ** date into screen field
      *
     C                   IF        DDPYDT <> *BLANKS
     C                   MOVE      IPPVDTD1      CDATE
     C                   IF        DDPYDT <> CDATE
      * Warning
     C                   MOVE      'W'           OKPYDT
     C                   ADD       1             WIX
     C                   MOVEL     'DDPYDT'      WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3155'     WMSGIDXAR(WIX)
     C                   ENDIF

     C                   MOVE      DDPYDT        IPPVDTD1

     C                   ELSE
     C                   MOVE      IPPVDTD1      DDPYDT

     C                   ENDIF

      ** Convert pay date into various formats

     C                   EVAL      WZDATE = IPPVDTD1
      *
      ** Setup DAF settle value date 2
     C                   IF        ZYN < 72
     C                   Z-ADD     20            IPPVDTD2
     C                   ELSE
     C                   Z-ADD     19            IPPVDTD2
     C                   ENDIF
      *
      ** Setup DAF settle value date 3
     C                   IF        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   ENDIF
      *
     C                   MOVE      WODATE        IPPVDTD3
      *
     C                   MOVE      IPPVDTD1      ZDATIN
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   Z-ADD     ZDAYNO        IPPVDT

      * Amend mode

     C                   ELSE
     C                   EVAL      P#IPFILFMT = TRNDET
     C                   EVAL      P#IP2FILFMT = TRNEXT
      *
      ** If payment dates are blanked out, redefualt them
      *
     C                   IF        DDSLDT = *BLANKS
     C                   MOVE      P#IPSLDTD1    DDSLDT
     C                   EVAL      IPSLDTD1 = P#IPSLDTD1
      *
      ** Convert settle date into various formats
      *
     C                   EVAL      WZDATE = IPSLDTD1
      *
      ** Setup DAF settle value date 2
      *
     C                   IF        ZYN < 72
     C                   Z-ADD     20            IPSLDTD2
     C                   ELSE
     C                   Z-ADD     19            IPSLDTD2
     C                   ENDIF
      *
      ** Setup DAF settle value date 3
     C                   IF        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   ENDIF
      *
     C                   MOVE      WODATE        IPSLDTD3
      *
     C                   MOVE      IPSLDTD1      ZDATIN
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   Z-ADD     ZDAYNO        IPSLDT
     C                   ENDIF
      *
     C                   IF        DDPYDT = *BLANKS
     C                   MOVE      P#IPPVDTD1    DDPYDT
     C                   EVAL      IPPVDTD1 = P#IPPVDTD1
      *
      ** Convert pay date into various formats
      *
     C                   EVAL      WZDATE = IPPVDTD1
      *
      ** Setup DAF settle value date 2
     C                   IF        ZYN < 72
     C                   Z-ADD     20            IPPVDTD2
     C                   ELSE
     C                   Z-ADD     19            IPPVDTD2
     C                   ENDIF
      *
      ** Setup DAF settle value date 3
     C                   IF        BJDFIN <> 'M'
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZMM
     C                   EVAL      OYY = ZDD
     C                   ELSE
     C                   EVAL      ODD = ZYY
     C                   EVAL      OMM = ZDD
     C                   EVAL      OYY = ZMM
     C                   ENDIF
      *
     C                   MOVE      WODATE        IPPVDTD3
      *
     C                   MOVE      IPPVDTD1      ZDATIN
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM      0             ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      ' '           ZERR
      *
     C                   Z-ADD     ZDAYNO        IPPVDT
     C                   ENDIF
      *
      ** If add/deduct indicator is amended and spread set is blanked
      ** out, redefault the spread set
      *
     C     P#IPPREF      CHAIN     INPAY

     C                   IF        P#IPADDC <> ADDC
      *                            AND SPDSET = *BLANKS
     C                   IF        P#IPSMCY <> P#IPPCCY
     C                   EVAL      SPDSET = P#I2FXSP
     C                   EVAL      I2FXSP = P#I2FXSP
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If rate is blanked out, redefault rate
      *
     C                   IF        DDRATE = *BLANKS
      *
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      P#IPRATE      ZFIELD
     C                   EVAL      ZADEC = 8

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDRATE
     C                   EVAL      IPRATE = P#IPRATE
      *
      ** Pay amount
      *
     C                   MOVE      DDPCCY        C#K101

     C                   EXSR      CURRED
      *
     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      P#IPPYAM      ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDPYAM
     C                   EVAL      IPPYAM = P#IPPYAM

     C                   EVAL      IPPYAMD = IPPYAM
     C                   DO        A6NBDP
     C                   EVAL      IPPYAMD = IPPYAMD / 10
     C                   ENDDO
      *
      ** Settle amount
      *
     C                   MOVE      DDSMCY        C#K101

     C                   EXSR      CURRED

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      P#IPSMAM      ZFIELD
     C                   EVAL      ZADEC = A6NBDP

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC

     C                   MOVE      ZFIELD        DDSMAM
     C                   EVAL      IPSMAM = P#IPSMAM

     C                   EVAL      IPSMAMD = IPSMAM

     C                   DO        A6NBDP
     C                   EVAL      IPSMAMD = IPSMAMD / 10
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if Pay Value Date is in the future and if the
      ** account is closing today
      *
     C                   IF        IPPVDT > BJRDNB AND
     C                             PACST3 = 'C'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDBNC1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0030'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   IF        IPPVDT > BJRDNB AND
     C                             PACST4 = 'C'
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDX
     C                   MOVEL     'DDACBK'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0031'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   EVAL      BVLD = BJRDNB - BJBVPD
      *
     C                   IF        DDACBK = *BLANKS
      *
      ** Use Beneficiary customer fields
      *
     C                   IF        PATYP3 = 'R'
     C                   IF        IPPVDT < BVLD
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDBNC1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0032'     MSGIDXAR(IDX)
     C                   ELSE
     C                   IF        IPPVDT < PDACO3
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDBNC1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0033'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Use Account with Bank Fields
      *
     C                   IF        PATYP4 = 'R'
     C                   IF        IPPVDT < BVLD
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDX
     C                   MOVEL     'DDACBK'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0034'     MSGIDXAR(IDX)
     C                   ELSE
     C                   IF        IPPVDT < PDACO4
     C                   MOVE      'N'           OKACBK
     C                   ADD       1             IDX
     C                   MOVEL     'DDACBK'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0035'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if settle date is in the future and if the account
      ** is closing today
      *
     C                   IF        IPSLDT > BJRDNB AND
     C                             PACST1 = 'C'
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             IDX
     C                   MOVEL     'DDSND1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0074'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   IF        IPSLDT > BJRDNB AND
     C                             PACST2 = 'C'
     C                   MOVE      'N'           OKRCO1
     C                   ADD       1             IDX
     C                   MOVEL     'DDRCO1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0074'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   IF        IPSLDT > BJRDNB AND
     C                             PACST5 = 'C' AND CFT014 = 'Y'
     C                   MOVE      'N'           OKTRIB
     C                   ADD       1             IDX
     C                   MOVEL     'DDTRIB'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0074'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** For Retail accounts only check that the settle
      ** value date is not before the backvalue limit date nor before
      ** the date the account was opened for the account that must be
      ** in settle currency.
      ** Third Reimbursement Institution precedes Sender and
      ** Receiver's Correspondent if CFT014 is installed.
      *
      *
     C                   IF        DDTRIB <> *BLANKS
     C                             AND (CFT014 = 'Y')
      *
      ** Third Reimbursement Institution
     C                   IF        PATYP5 = 'R'
      *
     C                   IF        IPSLDT < BVLD
     C                   MOVE      'N'           OKTRIB
     C                   ADD       1             IDX
     C                   MOVEL     'DDTRIB'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0075'     MSGIDXAR(IDX)
     C                   ELSE
     C                   IF        IPSLDT < PDACO5
     C                   MOVE      'N'           OKTRIB
     C                   ADD       1             IDX
     C                   MOVEL     'DDTRIB'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0076'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDRCO1 = *BLANKS
      *
      ** Use Sender fields
     C                   IF        PATYP1 = 'R'
      *
     C                   IF        IPSLDT < BVLD
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             IDX
     C                   MOVEL     'DDSND1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0075'     MSGIDXAR(IDX)
     C                   ELSE
     C                   IF        IPSLDT < PDACO1
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             IDX
     C                   MOVEL     'DDSND1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0076'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Use Receiver's correspondent fields
     C                   IF        PATYP2 = 'R'
      *
     C                   IF        IPSLDT < BVLD
     C                   MOVE      'N'           OKRCO1
     C                   ADD       1             IDX
     C                   MOVEL     'DDRCO1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0075'     MSGIDXAR(IDX)
     C                   ELSE
     C                   IF        IPSLDT < PDACO2
     C                   MOVE      'N'           OKRCO1
     C                   ADD       1             IDX
     C                   MOVEL     'DDRCO1'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTA0076'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF

      * Only for insert and no errors

     C                   IF        DDACTN = 'I' AND IDX = 0
                                                                                              219241
      ** Default details of charges from ME ICD                                               219241
                                                                                              219241
     C*******************IF        CFT014 = 'Y'                                        219241 244952
     C                   IF        CFT014 = 'Y' AND DDDTCH = *blanks                          244952
     C                   EVAL      DDDTCH = ENDCHG                                            219241
     C                   ENDIF                                                                219241

      ** Default VAT flags, total VAT, VAT rate, file DAF format for
      ** charges, entry charges, format charges for screen

     C                   EXSR      CHGENT
     C                   EXSR      CHGVAT

     C                   ENDIF

      * Only for amend,no errors and if the add deduct indicator has changed

     C                   IF        DDACTN = 'A' AND IDX = 0 AND
     C                             P#IPADDC <> ADDC
      *
      ** If add/deduct indicator is amended, levied charge currency and
      ** corresponding charge amount must be adjusted accordingly
      *
     C                   EXSR      READJ
     C                   ENDIF
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
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * SET_CHARGECODS - SET CHARGE CODES                             *                     AR898162
      *****************************************************************                     AR898162
     C     SET_CHARGECODSBEGSR                                                              AR898162
     C                   EVAL      I2TFCD = TRCDE                                           AR898162
     C                   EVAL      I2FXCD = FXCDE                                           AR898162
     C                   EVAL      I2TXCD = TXCDE                                           AR898162
     C                   EVAL      I2CQCD = CQCDE                                           AR898162
     C                   EVAL      I2ADCD = ADCDE                                           AR898162
     C                   EVAL      I2TPCD = TPCDE                                           AR898162
     C                   EVAL      I2MSCD = MSCDE                                           AR898162
     C                   EVAL      I2M1CD = M1CDE                                           AR898162
     C                   EVAL      I2M2CD = M2CDE                                           AR898162
     C                   EVAL      I2M3CD = M3CDE                                           AR898162
     C                   EVAL      I2M4CD = M4CDE                                           AR898162
     C                   EVAL      I2M5CD = M5CDE                                           AR898162
     C                   ENDSR                                                              AR898162
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * SET_CHARGEAMTS - SET CHARGE AMOUNTS                           *                     AR898162
      *****************************************************************                     AR898162
     C     SET_CHARGEAMTSBEGSR                                                              AR898162
                                                                                            AR898162
      ** Get Charges Currency Decimal Places                                                AR898162
                                                                                            AR898162
     C                   Eval      C#K101  = I2CCDE                                         AR898162
     C                   Exsr      CURRED                                                   AR898162
     C                   Eval      PINBDP = A6NBDP                                          AR898162
                                                                                            AR898162
      ** Transfer commission                                                                AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDTRCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPTRCM                                     AR898162
      ** FX/Change                                                                          AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDCHCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPINCHCM                                   AR898162
      ** Telex                                                                              AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDTXCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPTXCH                                     AR898162
      ** Cheque                                                                             AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDCQCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPCQCH                                     AR898162
      ** Advice                                                                             AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDADCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPADCH                                     AR898162
      ** Telephone                                                                          AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDTLCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPTLCH                                     AR898162
      ** Miscellaneous                                                                      AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      DDMSCD        ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        IPMSCH                                     AR898162
      ** Miscellaneous 1                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M1CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        I2MSC01                                    AR898162
      ** Miscellaneous 2                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M2CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        I2MSC02                                    AR898162
      ** Miscellaneous 3                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M3CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        I2MSC03                                    AR898162
      ** Miscellaneous 4                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M4CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        I2MSC04                                    AR898162
      ** Miscellaneous 5                                                                    AR898162
     C                   EVAL      ZFIELD = *BLANKS                                         AR898162
     C                   MOVE      M5CD          ZFIELD                                     AR898162
     C                   EXSR      ZALIGN                                                   AR898162
     C                   MOVE      ZFIELD        I2MSC05                                    AR898162
                                                                                            AR898162
     C                   ENDSR                                                              AR898162
      /EJECT                                                                                AR898162
      *****************************************************************                     AR898162
      * ZALIGN - EDIT A SCREEN FIELD TO AN AMOUN                      *                     AR898162
      *****************************************************************                     AR898162
     C     ZALIGN        BEGSR                                                              AR898162
     C                   EVAL      ZADEC = PINBDP                                           AR898162
     C                   EVAL      ZADIG = 11 - PINBDP                                      AR898162
     C                   CALLB     'ZALIGN'                                                 AR898162
     C                   PARM                    ZALIGNOK                                   AR898162
     C                   PARM                    ZFIELD                                     AR898162
     C                   PARM                    ZADEC                                      AR898162
     C                   PARM                    ZADIG                                      AR898162
     C                   ENDSR                                                              AR898162
     C/COPY WNCPYSRC,FTH00553
      /EJECT
      *****************************************************************
      * CHGVAT - Default VAT flags, VAT rate, VAT totals              *
      *****************************************************************

     C     CHGVAT        BEGSR

      ** Default VAT flags

     C                   IF        CFT010 = 'Y'

      ** Telex VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT2 = *BLANKS                                           CAP084
     C                   IF        I2TXCD <> *BLANKS
     C     I2TXCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT2 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT2 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT2 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Cheque VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT3 = *BLANKS                                           CAP084
     C                   IF        I2CQCD <> *BLANKS
     C     I2CQCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT3 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT3 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT3 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Advice VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT4 = *BLANKS                                           CAP084
     C                   IF        I2ADCD <> *BLANKS
     C     I2ADCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT4 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT4 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT4 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Telephone VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT5 = *BLANKS                                           CAP084
     C                   IF        I2TPCD <> *BLANKS
     C     I2TPCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT5 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT5 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT5 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT6 = *BLANKS                                           CAP084
     C                   IF        I2MSCD <> *BLANKS
     C     I2MSCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT6 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT6 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT6 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 1 VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             VAT9 = *BLANKS                                             CAP084
     C                   IF        I2M1CD <> *BLANKS
     C     I2M1CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT9 = 'Y'
     C                   ELSE
     C                   EVAL      VAT9 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT9 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 2 VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             VAT10 = *BLANKS                                            CAP084
     C                   IF        I2M2CD <> *BLANKS
     C     I2M2CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT10 = 'Y'
     C                   ELSE
     C                   EVAL      VAT10 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT10 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 3 VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             VAT11 = *BLANKS                                            CAP084
     C                   IF        I2M3CD <> *BLANKS
     C     I2M3CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT11 = 'Y'
     C                   ELSE
     C                   EVAL      VAT11 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT11 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 4 VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             VAT12 = *BLANKS                                            CAP084
     C                   IF        I2M4CD <> *BLANKS
     C     I2M4CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT12 = 'Y'
     C                   ELSE
     C                   EVAL      VAT12 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT12 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 5 VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             VAT13 = *BLANKS                                            CAP084
     C                   IF        I2M5CD <> *BLANKS
     C     I2M5CD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      VAT13 = 'Y'
     C                   ELSE
     C                   EVAL      VAT13 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      VAT13 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Transfer Commission VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT1 = *BLANKS                                           CAP084
     C                   IF        I2TFCD <> *BLANKS
     C     I2TFCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT1 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT1 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT1 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** FX/change VAT flag

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDVAT7 = *BLANKS                                           CAP084
     C                   IF        I2FXCD <> *BLANKS
     C     I2FXCD        CHAIN     FTPCHGL0

     C                   IF        VATLIN = 'Y'
     C                   EVAL      DDVAT7 = 'Y'
     C                   ELSE
     C                   EVAL      DDVAT7 = 'N'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      DDVAT7 = *Blank
     C                   ENDIF
     C                   ENDIF                                                                CAP084

     C                   ELSE
     C                   EVAL      DDVAT2 = 'N'
     C                   EVAL      DDVAT3 = 'N'
     C                   EVAL      DDVAT4 = 'N'
     C                   EVAL      DDVAT5 = 'N'
     C                   EVAL      DDVAT6 = 'N'
     C                   EVAL      VAT9 = 'N'
     C                   EVAL      VAT10 = 'N'
     C                   EVAL      VAT11 = 'N'
     C                   EVAL      VAT12 = 'N'
     C                   EVAL      VAT13 = 'N'
     C                   EVAL      DDVAT1 = 'N'
     C                   EVAL      DDVAT7 = 'N'
     C                   ENDIF

      ** VAT totals

     C                   EVAL      IPINDUM8 = 0
     C                   EVAL      IPINVATT = 0

      * If apply V.A.T. flag is 'Y', calculate V.A.T. charge

      * Transfer commission

     C                   IF        DDVAT1 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA1
     C                   EVAL      IPINVATT = IPINVATT + IPTRCM
     C                   ENDIF

      * Telex

     C                   IF        DDVAT2 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA2
     C                   EVAL      IPINVATT = IPINVATT + IPTXCH
     C                   ENDIF

      * Cheque

     C                   IF        DDVAT3 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA3
     C                   EVAL      IPINVATT = IPINVATT + IPCQCH
     C                   ENDIF

      * Advice

     C                   IF        DDVAT4 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA4
     C                   EVAL      IPINVATT = IPINVATT + IPADCH
     C                   ENDIF

      * Telephone

     C                   IF        DDVAT5 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA5
     C                   EVAL      IPINVATT = IPINVATT + IPTLCH
     C                   ENDIF

      * Miscellaneous

     C                   IF        DDVAT6 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPDUMA6
     C                   EVAL      IPINVATT = IPINVATT + IPMSCH
     C                   ENDIF

      * Fx/Change commission

     C                   IF        DDVAT7 = 'Y' AND S01494 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + IPINDUM7
     C                   EVAL      IPINVATT = IPINVATT + IPINCHCM
     C                   ENDIF

      * Miscellaneous 1

     C                   IF        VAT9 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + I2MSC01
     C                   EVAL      IPINVATT = IPINVATT + @MI1CH
     C                   ENDIF

      * Miscellaneous 2

     C                   IF        VAT10 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + I2MSC02
     C                   EVAL      IPINVATT = IPINVATT + @MI2CH
     C                   ENDIF

      * Miscellaneous 3

     C                   IF        VAT11 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + I2MSC03
     C                   EVAL      IPINVATT = IPINVATT + @MI3CH
     C                   ENDIF

      * Miscellaneous 4

     C                   IF        VAT12 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + I2MSC04
     C                   EVAL      IPINVATT = IPINVATT + @MI4CH
     C                   ENDIF

      * Miscellaneous 5

     C                   IF        VAT13 = 'Y'
     C                   EVAL      IPINDUM8 = IPINDUM8 + I2MSC05
     C                   EVAL      IPINVATT = IPINVATT + @MI5CH
     C                   ENDIF

      *
      * Do VAT calculation on total not single amounts.
      *
     C                   IF        IPINDUM8 <> 0                                             BUG4029
     C**********         EVAL(H)   IPINDUM8 = IPINDUM8 * PVATR                                257897
     C                   ENDIF                                                               BUG4029
     C                   IF        IPINVATT <> 0                                             BUG4029
     C**********         EVAL(H)   IPINVATT = IPINVATT * PVATR                                257897
     C                   ENDIF                                                               BUG4029

      *
      ** Total VAT Amount (Input Currency)
      *
     C                   IF        IPINDUM8 <> 0
     C                   EVAL(H)   IPINDUM8 = IPINDUM8 * PVATR                                257897
     C                   Z-ADD     IPINDUM8      @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDVATD
     C                   ELSE
     C                   MOVE      *BLANKS       DDVATD
     C                   ENDIF
      *
      ** Total VAT Amount (Levied Charges Currency).
      *
     C                   IF        IPINVATT <> 0
     C                   EVAL(H)   IPINVATT = IPINVATT * PVATR                                257897
     C                   Z-ADD     IPINVATT      @@AMTW
     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDVATT
     C                   ELSE
     C                   MOVE      *BLANKS       DDVATT
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      * CHGENT - Default entry charges, DAF format                    *
      *****************************************************************

     C     CHGENT        BEGSR

      * Entry charges (saved in charges currency)

      ** Miscellaneous 1

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             M1CD = *BLANKS                                             CAP084
     C                   IF        I2MSC01 <> 0
     C                   Z-ADD     I2MSC01       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M1CD
     C**********         ELSE                                                               AR572042
     C**********         MOVE      *BLANKS       M1CD                                       AR572042
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 2

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             M2CD = *BLANKS                                             CAP084
     C                   IF        I2MSC02 <> 0
     C                   Z-ADD     I2MSC02       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M2CD
     C**********         ELSE                                                               AR572042
     C**********         MOVE      *BLANKS       M2CD                                       AR572042
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 3

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             M3CD = *BLANKS                                             CAP084
     C                   IF        I2MSC03 <> 0
     C                   Z-ADD     I2MSC03       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CD
     C**********         ELSE                                                               AR572042
     C**********         MOVE      *BLANKS       M3CD                                       AR572042
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 4

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             M4CD = *BLANKS                                             CAP084
     C                   IF        I2MSC04 <> 0
     C                   Z-ADD     I2MSC04       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M4CD
     C**********         ELSE                                                               AR572042
     C**********         MOVE      *BLANKS       M4CD                                       AR572042
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Miscellaneous 5

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             M5CD = *BLANKS                                             CAP084
     C                   IF        I2MSC05 <> 0
     C                   Z-ADD     I2MSC05       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M5CD
     C**********         ELSE                                                               AR572042
     C**********         MOVE      *BLANKS       M5CD                                       AR572042
     C                   ENDIF
     C                   ENDIF                                                                CAP084

      ** Transfer commission

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDTRCD = *BLANKS                                           CAP084
     C                   IF        IPTRCM <> 0
     C                   Z-ADD     IPTRCM        IPDUMA1
     C                   Z-ADD     IPDUMA1       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTRCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA1
     C**********         MOVE      *BLANKS       DDTRCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA1                                      CAP084
     C                   ENDIF                                                                CAP084

      ** Telex

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDTXCD = *BLANKS                                           CAP084
     C                   IF        IPTXCH <> 0
     C                   Z-ADD     IPTXCH        IPDUMA2
     C                   Z-ADD     IPDUMA2       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTXCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA2
     C**********         MOVE      *BLANKS       DDTXCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA2                                      CAP084
     C                   ENDIF                                                                CAP084

      ** Cheque

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDCQCD = *BLANKS                                           CAP084
     C                   IF        IPCQCH <> 0
     C                   Z-ADD     IPCQCH        IPDUMA3
     C                   Z-ADD     IPDUMA3       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCQCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA3
     C**********         MOVE      *BLANKS       DDCQCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA3                                      CAP084
     C                   ENDIF                                                                CAP084

      ** Advice

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDADCD = *BLANKS                                           CAP084
     C                   IF        IPADCH <> 0
     C                   Z-ADD     IPADCH        IPDUMA4
     C                   Z-ADD     IPDUMA4       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDADCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA4
     C**********         MOVE      *BLANKS       DDADCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA4                                      CAP084
     C                   ENDIF                                                                CAP084

      ** Telephone

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDTLCD = *BLANKS                                           CAP084
     C                   IF        IPTLCH <> 0
     C                   Z-ADD     IPTLCH        IPDUMA5
     C                   Z-ADD     IPDUMA5       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTLCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA5
     C**********         MOVE      *BLANKS       DDTLCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA5                                      CAP084
     C                   ENDIF                                                                CAP084

      ** Miscellaneous

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDMSCD = *BLANKS                                           CAP084
     C                   IF        IPMSCH <> 0
     C                   Z-ADD     IPMSCH        IPDUMA6
     C                   Z-ADD     IPDUMA6       @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMSCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPDUMA6
     C**********         MOVE      *BLANKS       DDMSCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPDUMA6                                      CAP084
     C                   ENDIF                                                                CAP084

      ** FX/Change

     C******             IF        PSJobName <> 'QZDASOINIT' OR                        CAP084 247277
     C                   IF        PSJobName <> 'QZDASOINIT' AND                              247277
     C                             PSJobName <> 'QZDASSINIT' AND                           AR1088819
     C                             PSJobName <> 'QSQSRVR'    OR                               247277
     C                             DDCHCD = *BLANKS                                           CAP084
     C                   IF        IPINCHCM <> 0
     C                   Z-ADD     IPINCHCM      IPINDUM7
     C                   Z-ADD     IPINDUM7      @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCHCD
     C                   ELSE
     C                   Z-ADD     *ZEROS        IPINDUM7
     C**********         MOVE      *BLANKS       DDCHCD                                     AR572042
     C                   ENDIF
     C                   ELSE                                                                 CAP084
     C                   Z-ADD     *ZEROS        IPINDUM7                                     CAP084
     C                   ENDIF                                                                CAP084

      *
      ** Convert new charges (miscellaneous charges 1-5) into levied
      ** charge currency for VAT calculations and for screen

      ** Set up rate to use, depending on flag from SDFTFRPD.
     C     *LIKE         Define    IPRATE        Rate_to_use

     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = IPRATE
     C                   Else
     C                   Eval      Rate_to_use = I2XRTE
     C                   EndIf
      *
      ** Miscellaneous 1

     C                   IF        I2MSC01 <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = I2MSC01
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      I2MSC01       PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy       3                          CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MI1CH
     C                   Z-ADD     PLev_Charge   @@AMTW
     C                   Z-ADD     PLev_Charge   P#I2MSC01

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M1CH
     C                   ELSE
     C                   Z-ADD     *ZEROS        @MI1CH
     C                   MOVE      *BLANKS       M1CH
     C                   ENDIF

      ** Miscellaneous 2

     C                   IF        I2MSC02 <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = I2MSC02
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      I2MSC02       PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MI2CH
     C                   Z-ADD     PLev_Charge   @@AMTW
     C                   Z-ADD     PLev_Charge   P#I2MSC02

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M2CH
     C                   ELSE
     C                   MOVE      *BLANKS       M2CH
     C                   Z-ADD     *ZEROS        @MI2CH
     C                   ENDIF

      ** Miscellaneous 3

     C                   IF        I2MSC03 <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = I2MSC03
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      I2MSC03       PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MI3CH
     C                   Z-ADD     PLev_Charge   @@AMTW
     C                   Z-ADD     PLev_Charge   P#I2MSC03

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CH
     C                   ELSE
     C                   MOVE      *BLANKS       M3CH
     C                   Z-ADD     *ZEROS        @MI3CH
     C                   ENDIF

      ** Miscellaneous 4

     C                   IF        I2MSC04 <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = I2MSC04
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      I2MSC04       PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MI4CH
     C                   Z-ADD     PLev_Charge   @@AMTW
     C                   Z-ADD     PLev_Charge   P#I2MSC04

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M4CH
     C                   ELSE
     C                   MOVE      *BLANKS       M4CH
     C                   Z-ADD     *ZEROS        @MI4CH
     C                   ENDIF

      ** Miscellaneous 5

     C                   IF        I2MSC05 <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = I2MSC05
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      I2MSC05       PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @MI5CH
     C                   Z-ADD     PLev_Charge   @@AMTW
     C                   Z-ADD     PLev_Charge   P#I2MSC05

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M5CH
     C                   ELSE
     C                   MOVE      *BLANKS       M5CH
     C                   Z-ADD     *ZEROS        @MI5CH
     C                   ENDIF
      *
      *  Existing charges are saved in levied currency, need to convert
      *  as they are currently in charges currency from FT000980

      *
      ** Transfer commission

     C                   IF        IPTRCM <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPTRCM
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPTRCM        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C/COPY WNCPYSRC,FTH00554
     C                   Z-ADD     PLev_Charge   IPTRCM
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTRCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDTRCM
     C                   ENDIF

      ** Telex

     C                   IF        IPTXCH <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPTXCH
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPTXCH        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPTXCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTXCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTXCH
     C                   ENDIF

      ** Cheque

     C                   IF        IPCQCH <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPCQCH
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPCQCH        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPCQCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCQCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDCQCH
     C                   ENDIF

      ** Advice

     C                   IF        IPADCH <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPADCH
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPADCH        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPADCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDADCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDADCH
     C                   ENDIF

      ** Telephone

     C                   IF        IPTLCH <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPTLCH
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPTLCH        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPTLCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTLCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTLCH
     C                   ENDIF

      ** Miscellaneous

     C                   IF        IPMSCH <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPMSCH
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPMSCH        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPMSCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMSCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDMSCH
     C                   ENDIF

      ** FX/Change

     C                   IF        IPINCHCM <> 0
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = IPINCHCM
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = I2CCDE

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      IPINCHCM      PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPINCHCM
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCHCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDCHCM
     C                   ENDIF

      * File DAF format (not like real DAF)

     C     PICCY         IFNE      BJCYCD
     C                   Z-ADD     PINBDP        @FCDP
     C                   ELSE
     C                   Z-ADD     PBCDP         @FCDP
     C                   ENDIF

      * Transfer commission

     C     @FCDP         ADD       1             W
     C     IPTRCM        DIV       FCTR(W)       IPTRCMD

      * Telex Charge

     C     @FCDP         ADD       1             W
     C     IPTXCH        DIV       FCTR(W)       IPTXCHD

      * Cheque Charge

     C     @FCDP         ADD       1             W
     C     IPCQCH        DIV       FCTR(W)       IPCQCHD

      * Advice charge

     C     @FCDP         ADD       1             W
     C     IPADCH        DIV       FCTR(W)       IPADCHD

      * Telephone charge

     C     @FCDP         ADD       1             W
     C     IPTLCH        DIV       FCTR(W)       IPTLCHD

      * Miscellaneous charge

     C     @FCDP         ADD       1             W
     C     IPMSCH        DIV       FCTR(W)       IPMSCHD

     C                   ENDSR
      /EJECT
      *****************************************************************
      * READJ - Readjust levied charge currency and charge amounts    *
      *****************************************************************

     C     READJ         BEGSR

      ** Set up rate to use, depending on flag from SDFTFRPD.

     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = I2XRTE
     C                   Else
     C                   Eval      Rate_to_use = IPRATE
     C                   EndIf
      *
      ** Miscellaneous 1
      *
     C                   IF        M1CD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M1CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA

     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M1CH
     C                   ELSE
     C                   MOVE      *BLANKS       M1CH
     C                   ENDIF

      ** Miscellaneous 2

     C                   IF        M2CD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M2CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA

     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M2CH
     C                   ELSE
     C                   MOVE      *BLANKS       M2CH
     C                   ENDIF

      ** Miscellaneous 3

     C                   IF        M3CD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M3CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CH
     C                   ELSE
     C                   MOVE      *BLANKS       M3CH
     C                   ENDIF

      ** Miscellaneous 4

     C                   IF        M4CD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M4CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M4CH
     C                   ELSE
     C                   MOVE      *BLANKS       M4CH
     C                   ENDIF

      ** Miscellaneous 5

     C                   IF        M5CD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M5CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M5CH
     C                   ELSE
     C                   MOVE      *BLANKS       M5CH
     C                   ENDIF

      ** Transfer commission

     C                   IF        DDTRCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDTRCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPTRCM
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTRCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDTRCM
     C                   ENDIF

      ** Telex

     C                   IF        DDTXCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDTXCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPTXCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTXCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTXCH
     C                   ENDIF

      ** Cheque

     C                   IF        DDCQCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDCQCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPCQCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCQCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDCQCH
     C                   ENDIF

      ** Advice

     C                   IF        DDADCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDADCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPADCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDADCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDADCH
     C                   ENDIF

      ** Telephone

     C                   IF        DDTLCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDTLCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPTLCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDTLCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTLCH
     C                   ENDIF

      ** Miscellaneous

     C                   IF        DDMSCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDMSCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPMSCH
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDMSCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDMSCH
     C                   ENDIF

      ** FX/Change

     C                   IF        DDCHCD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDCHCD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPINCHCM
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDCHCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDCHCM
     C                   ENDIF
      *
      ** Total VAT Amount
      *
     C                   IF        DDVATD <> *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   DDVATD        ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   CLEAR                   D#DTA
     C                   MOVE      ZFIELD        D#FAMT
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY

     C                   MOVE      ZFIELD        PCharge_Amt

     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM                    PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C**********         PARM      I2CCDE        PCharge_Ccy       3                          CAP084
     C                   PARM      PICCY         PCharge_Ccy                                  CAP084
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16

     C                   Z-ADD     PLev_Charge   IPINVATT
     C                   Z-ADD     PLev_Charge   @@AMTW

     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDVATT
     C                   ELSE
     C                   MOVE      *BLANKS       DDVATT
     C                   ENDIF

      * File DAF format (not like real DAF)

     C     PICCY         IFNE      BJCYCD
     C                   Z-ADD     PINBDP        @FCDP
     C                   ELSE
     C                   Z-ADD     PBCDP         @FCDP
     C                   ENDIF

      * Transfer commission

     C     @FCDP         ADD       1             W
     C     IPTRCM        DIV       FCTR(W)       IPTRCMD

      * Telex Charge

     C     @FCDP         ADD       1             W
     C     IPTXCH        DIV       FCTR(W)       IPTXCHD

      * Cheque Charge

     C     @FCDP         ADD       1             W
     C     IPCQCH        DIV       FCTR(W)       IPCQCHD

      * Advice charge

     C     @FCDP         ADD       1             W
     C     IPADCH        DIV       FCTR(W)       IPADCHD

      * Telephone charge

     C     @FCDP         ADD       1             W
     C     IPTLCH        DIV       FCTR(W)       IPTLCHD

      * Miscellaneous charge

     C     @FCDP         ADD       1             W
     C     IPMSCH        DIV       FCTR(W)       IPMSCHD

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
     C                   PARM                    NWIP1SCNFMT
     C                   PARM                    NWIP1ASCNFMT
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP             1 0
      *
      ** Sender's Account Type
     C                   PARM                    PATYP1            1
      *
      ** Sender's Account Status
     C                   PARM                    PACST1            1
      *
      ** Sender's Date Account Opened
     C                   PARM                    PDACO1            5 0
      *
      ** RCorr's Account Type
     C                   PARM                    PATYP2            1
      *
      ** RCorr's Account Status
     C                   PARM                    PACST2            1
      *
      ** RCorr's Date Account Opened
     C                   PARM                    PDACO2            5 0
      *
      ** Beneficiary Customer's Account Type
     C                   PARM                    PATYP3            1
      *
      ** Beneficiary Customer's Account Status
     C                   PARM                    PACST3            1
      *
      ** Beneficiary Customer's Date Account Opened
     C                   PARM                    PDACO3            5 0
      *
      ** A/c with Bank's Account Type
     C                   PARM                    PATYP4            1
      *
      ** A/c with Bank's Account Status
     C                   PARM                    PACST4            1
      *
      ** A/c with Bank's Date Account Opened
     C                   PARM                    PDACO4            5 0
      *
      ** Third Reimbursement Inst. Account Type
     C                   PARM                    PATYP5            1
      *
      ** Third Reimbursement Inst. Account Status
     C                   PARM                    PACST5            1
      *
      ** Third Reimbursement Inst. Date Account Opened
     C                   PARM                    PDACO5            5 0
      *
      ** Account needed to set payment value date
     C                   PARM                    PPYFLDS
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY            1
      *
      ** SDFTFR - Fixed Charge Currency
     C                   PARM                    FCHCCY            3
      *
      ** SDFTFR - Charges calculated in transaction ccy
     C                   PARM                    CHTRCY            1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - System Location Code
     C                   PARM                    BJSLCD            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Fees & Charges (VAT)
     C                   PARM                    CFT010            1
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014            1
     C/COPY WNCPYSRC,FTH00555
      *
      ** OUTPUT
      ** ======
      *
     C                   PARM                    NWIP5SCNFMT

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR

     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTXAR

      *  OK Flags
     C                   PARM                    FTEIPY1
      * Valid payment layout (DS) from/to caller
     C                   PARM                    NWIPFILFMT
     C                   PARM                    NWIP2FILFMT
      *
      ** DS for Default Charge Amounts
     C                   PARM                    PCHARGES
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *
      ** Output Charge Currency
     C                   PARM                    POCCY
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP
                                                                                              219241
      ** Get Message Management Details if CFT014 is installed                                219241
                                                                                              219241
     C                   IF        CFT014 = 'Y'                                               219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 8                                                  219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
      *                                                                                       CFT120
      ** Check if CFT120 is on                                                                CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD             7                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
                                                                                              CFT120
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBKEY  = 'CFT120'                                          CFT120
     C                   EVAL      DBASE  = 9                                                 CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
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
(c) Finastra International Limited 2001
** FCTR
0001
0010
0100
1000
