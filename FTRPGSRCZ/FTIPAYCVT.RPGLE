     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming paymnts convert file to scrn fmt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYCVT - Incoming Payment Details Conversion from         *
      *              File to Screen Format                            *
      *                                                               *
      *  Function: This module converts the fields of an Incoming     *
      *            Payment from their format as on file to a screen   *
      *            format.                                            *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039986           Date 10Aug16               *
      *                 MD024011           Date 10Aug16               *
      *                 AR1090283          Date 10Aug16               *
      *                 CFT157             Date 29Aug14               *
      *                 AR1079259          Date 21Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18401           Date 29Apr08               *
      *                 BUG16620           Date 12Mar08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG2219            Date 24Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039986 - Additional codes to upgrade AR1090283.            *
      *  MD024011 - Pb when job name is QZDASSINIT                    *
      *           - Applied for MD-39986.                             *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  AR1079259 - Projected fee amount is wrong                    *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18401 - During amend of newly inserted transactions,      *
      *             expanding the field details caused errors         *
      *  BUG16620 - Net Settle Value Field is empty in the Charges    *
      *             Details 2 tab                                     *
      *           - After authorisation, currency in 'Charges In'     *
      *             column 2 changes                                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG2219- Action code is being cleared                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Rename DDSWTN and DDSEQNO in the parameter list     *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas Users file
     FMUSER     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas I.M. Control Retrieval index
     FMEINCRL1  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
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
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
     D PRECI         E                     EXTFLD(RECI)
     D/COPY WNCPYSRC,FTH00439
      *                                                                                       CFT157
     D PCHTP         E                     EXTFLD(CHTP)                                       CFT157
      *                                                                                       CFT157
      *                                                                         CFT014
      ** Incoming Payments (additional details) retrieved from file             CFT014
      ** - file format.                                                         CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details retrieved from                CFT014
      ** file - screen format                                                   CFT014
     D CrIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     D CrIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     D CrIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     D CrIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 details retrieved from                CFT014
      ** file - screen format                                                   CFT014
     D CrIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file             CFT014
      ** - screen format                                                        CFT014
     D CrIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details retrieved from file              CFT014
      ** - screen format                                                        CFT014
     D CrIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     D CrIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     D CrIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives retrieved from file                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     D CrIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL049
     D                                     PREFIX(SR)                                         CDL049
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL049
                                                                                              CDL049
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D/COPY WNCPYSRC,FTIPAYND01
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Address setup
      *
     D P8FT            DS           128
      *
      ** Currency
     D  W8CCY                  1      3
      *
      ** Settlement Type
     D  W8STMT                 4      5
      *
      ** Mandatory Text - convert BIC identifiers
     D  W8MTXT                 6      6
      *
      ** Message Tag
     D  W8MTAG                 7     11
      *
      ** Construct of data in field
     D  W8TYPE                12     12
      *
      ** Number of Lines available
     D  W8NLIN                13     14  0
      *
      ** Network and Message Type
     D  W8NWRK                15     20
     D  W8MTPY                21     23
      *
      ** Calling Program
     D  W8CPGM                24     33
      *
      ** Action *PRINT/*ENQ/*MSG GEN
     D  W8ACT                 34     41
      *
      ** Critical Reporting - Database error if 'Y'.
      ** If no BIC directory and BIC entered, no error.
     D  W8CRIT                42     42
      *
      ** Force Midas Address - where possible
     D  W8MADD                43     43
      *
      ** If Retail, get first address from account
     D  W8RTAD                44     44
      *
      ** Alternative Address
     D  W8ALTN                45     45
      *
      ** Address Type
     D  W8ADTP                46     46
      *
      ** DS for Redefining Address Fields
     D                 DS
     D  WADDRSS                1    175
     D  WADCHK1                1     35
     D  WADCHK2               36     70
     D  WADCHK3               71    105
     D  WADCHK4              106    140
     D  WADCHK5              141    175
      *
      ** DS for Additional Info details
     D PAddInfm        DS           196
     D  DDUSRP1                1     10
     D  DDUSER1               11     35
     D  DDUSRP2               36     45
     D  DDUSER2               46     70
     D  DDAUP1                71     80
     D  DDAUT1                81    105
     D  DDAUP2               106    115
     D  DDAUT2               116    140
     D  DDNMIR               141    168
     D  DDNMOR               169    196
      *                                                                         CFT009
      ** DS for Default Charge Amounts                                          CFT009
     D PCHARGES        DS           196                                         CFT009
     D  DDTRCM                 1     14                                         CFT009
     D  DDTXCH                15     28                                         CFT009
     D  DDCQCH                29     42                                         CFT009
     D  DDADCH                43     56                                         CFT009
     D  DDTLCH                57     70                                         CFT009
     D  DDMSCH                71     84                                         CFT009
     D  DDCHCM                85     98                                         CFT009
     D  DDVATT                99    112                                         CFT009
     D  DDVATD               113    126                                         CFT009
     D  M1CH                 127    140                                         CFT009
     D  M2CH                 141    154                                         CFT009
     D  M3CH                 155    168                                         CFT009
     D  M4CH                 169    182                                         CFT009
     D  M5CH                 183    196                                         CFT009
                                                                                CFT009
     D* Parameters for AOCCYCV0                                                 CFT009
     D D#DTA           DS           256                                         CFT009
     D  D#FCCY                 1      3                                         CFT009
     D  D#FAMT                 4     11P 0                                      CFT009
     D  D#TCCY                12     14                                         CFT009
     D  D#TAMT                15     22P 0                                      CFT009
     D  D#IMDIN               23     23                                         CFT009
     D  D#IRATE               24     36P 8                                      CFT009
     D  D#OMDIN               23     23                                         CFT009
     D  D#ORATE               24     36P 8                                      CFT009
      *                                                                         CFT009
      ** Externally described DS for Funds Transfer ICD details                 CFT009
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    CFT009
      *                                                                         CFT009
      ** DS for Access Objects - short data structure                           CFT009
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT009
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARDP       E DS                  EXTNAME(SCSARDPD)                                  CER030
     D  PLCD         E                     EXTFLD(LCD)                                        CER030
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                CFT009
     D* Parameters for AOCCYCV0                                                 CFT009
     D C#ACTN          S              8                                         CFT009
     D C#RTCD          S              7                                         CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     D PICCY           S              3                                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     D POCCY           S              3                                         CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     D PINBDP          S              1  0                                      CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     D PONBDP          S              1  0                                      CFT009
                                                                                              CGL029
      ** Working Variables                                                                    CGL029
     D WACDRO          S             18A                                                      CGL029
      *                                                                                       CSW209
      ** SWIFT 2009 work fields                                                               CSW209
     D CSW209          S              1A                                                      CSW209
     D PRTCD           S              7A                                                      CSW209
      *                                                                                       CER030
      ** Fields defined for CER030                                                            CER030
      *                                                                                       CER030
     D PSard           S              6A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Convert fields from file to screen format.
      *
     C                   EXSR      SRConvFlds
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *                                                                                      BUG2219
      ** Save Action Code                                                                    BUG2219
      *                                                                                      BUG2219
     C                   MOVE      PDDACTN       WDDACTN           1                         BUG2219
      *
      ** Initialise output parameters.
      *
     C                   CLEAR                   CrIP1SCnFmt
     C                   CLEAR                   CrIP1ASCnFmt                   CFT014
     C                   CLEAR                   CrIP2SCnFmt
     C                   CLEAR                   CrIP3SCnFmt
     C                   CLEAR                   CrIP4SCnFmt
     C                   CLEAR                   CrIP4ASCnFmt                   CFT014
     C                   CLEAR                   CrIP5SCnFmt                    CFT014
     C                   CLEAR                   CrIP6SCnFmt                    CFT014
     C                   CLEAR                   CrIP7SCnFmt                                  CSW209
     C                   CLEAR                   CrIP8SCnFmt                                  CSW209
     C                   CLEAR                   CrIP6ASCnFmt                                 CER030
     C                   CLEAR                   PAddInfm
      *
     C                   MOVE      *BLANKS       DDSWTN
     C                   MOVE      *BLANKS       DDSEQNO
     C                   MOVE      *BLANKS       PStatus
     C                   MOVE      *BLANKS       PPYTP
      *                                                                                       CSW209
      ** Check if SWIFT 2009 is installed                                                     CSW209
      *                                                                                       CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
      *                                                                                       CSW209
     C                   IF        PRTCD = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvFlds - Routine to move the contents of the fields      *
      *               from file to screen fields                      *
      *                                                               *
      *****************************************************************
      *
     C     SRConvFlds    BEGSR
      *
      ** LEVEL 1
      *  =======
      *
      ** Action Code.
      *
     C**********         MOVEL     PDDACTN       DDACTN                                      BUG2219
     C                   MOVEL     WDDACTN       DDACTN                                      BUG2219
      *
      ** Payment Reference.
      *
     C                   MOVEL     PREF          DDPREF
      *
      ** SWIFT Reference.
      *
     C                   MOVEL     MIR           DDSWTN
      *
      ** Sequence No.
      *
     C     ISEQ          IFEQ      '00'
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   ELSE
     C                   MOVEL     ISEQ          DDSEQNO
     C                   ENDIF
      *
      ** Booking Branch and Originating Branch.
      *
     C     BJSBRC        IFEQ      *BLANKS
      *
      ** Set up Booking Branch only if multibranching.
      *
     C                   MOVE      BRCA          DDBRCA
      *
      ** Set up Originating Branch if multibranching and
      ** Originating Branch Used indicator is 'Y'.
      *
     C     BKOBRU        IFEQ      'Y'
     C                   MOVE      ORBR          DDORBR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Payment Type.
      *
     C                   MOVE      PYTP          PPYTP
      *
      ** Payment Subtype.
      *
     C                   MOVE      PYST          DDPYST
      *
      ** SWIFT Priority Code.
      *
     C     SWPC          IFEQ      1
     C                   MOVE      'U'           DDSWPC
     C                   ENDIF
      *
     C     SWPC          IFEQ      2
     C                   MOVE      'N'           DDSWPC
     C                   ENDIF
      *
      ** Sender.
      *
     C                   MOVEL     SND1          DDSND1
      *
      ** If not multibranching and Sender Type is G (full a/c id),
      ** move blanks to where Branch Code of Sender would be
      ** (pos. 16-18).
      *
     C     BJSBRC        IFNE      *BLANKS
     C     SNTP          ANDEQ     'G'
     C                   EVAL      %SUBST(DDSND1:16:3) = *Blanks
     C                   ENDIF
      *
     C                   MOVEL     SND2          DDSND2
     C                   MOVEL     SND3          DDSND3
     C                   MOVEL     SND4          DDSND4
      *
      ** Receiver's Correspondence.
      *
     C*****RCRT**        IFEQ      'R'                                          CFT014
     C***********        MOVEL     RCCO          DDRCCO                         CFT014
     C***********        ENDIF                                                  CFT014
      ***********                                                               CFT014
     C*****RCRT**        IFEQ      'N'                                          CFT014
     C***********        MOVEL     RCCO          WA2               2            CFT014
     C***********        MOVEL     WA2           DDRCCO                         CFT014
     C***********        ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   EVAL      DDRCO1 = INRCO1                              CFT014
      *                                                                         CFT014
      ** If not multibranching and Receiver Cor. Type is G (full a/c id),       CFT014
      ** move blanks to where Branch Code of Receiver Correspondent would be    CFT014
      ** (pos. 16-18).                                                          CFT014
     C     BJSBRC        IFNE      *BLANKS                                      CFT014
     C     INRCRT        ANDEQ     'G'                                          CFT014
     C                   EVAL      %SUBST(DDRCO1:16:3) = *Blanks                CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   EVAL      DDRCO2 = INRCO2                              CFT014
     C                   EVAL      DDRCO3 = INRCO3                              CFT014
     C                   EVAL      DDRCO4 = INRCO4                              CFT014
     C                   EVAL      DDRCO5 = INRCO5                              CFT014
      *                                                                         CFT014
      ** Third Reimbursement.                                                   CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EVAL      DDTRIB = INTRIB                              CFT014
      *                                                                         CFT014
      ** If not multibranching and Third Reimbursement is G (full a/c id),      CFT014
      ** move blanks to where Branch Code of Third Reimbursement would be       CFT014
      ** (pos. 16-18).                                                          CFT014
     C     BJSBRC        IFNE      *BLANKS                                      CFT014
     C     INTRIT        ANDEQ     'G'                                          CFT014
     C                   EVAL      %SUBST(DDTRIB:16:3) = *Blanks                CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Account with Bank.
      *
     C                   SELECT
      *
      ** Partial a/c.
      *
     C     ACBT          WHENEQ    'P'
     C                   MOVEL     ACBK          DDACBK
      *
      ** Only set A/c with Bank Branch if multibranching and partial a/c.
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     ACBB          DDACBB
     C                   ENDIF
      *
      ** Retail.
      *
     C     ACBT          WHENEQ    'R'
     C                   MOVEL     ACBK          WA10             10
     C                   MOVEL     WA10          DDACBK
      *
      ** Nostro.
      *
     C     ACBT          WHENEQ    'N'
     C***********        MOVEL     ACBK          WA2                            CFT014
     C                   MOVEL     ACBK          WA2               2            CFT014
     C                   MOVEL     WA2           DDACBK
      *
     C                   ENDSL
      *
      ** Beneficiary.
      *
     C                   MOVEL     BNC1          DDBNC1
      *
      ** If not multibranching and Beneficiary Type is P (partial
      ** a/c id), move blanks to where Branch Code of Beneficiary
      ** would be (positions 13-15).
      *
     C     BJSBRC        IFNE      *BLANKS
     C     BNCT          ANDEQ     'P'
     C                   EVAL      %SUBST(DDBNC1:13:3) = *BLANKS
     C                   ENDIF
      *
     C                   MOVEL     BNC2          DDBNC2
     C                   MOVEL     BNC3          DDBNC3
     C                   MOVEL     BNC4          DDBNC4
     C                   MOVEL     BNC5          DDBNC5
      *
      ** If Enquiry then format Addresses for screen display.
      *
     C     DDACTN        IFEQ      'E'
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *
      ** Setup Sender address.
      *
     C                   CLEAR                   P8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     SMCY          W8CCY
     C                   MOVEL     PSProcPgm     W8CPGM
     C                   MOVEL     '*ENQ  '      W8ACT
     C                   Z-ADD     4             W8NLIN
      *
     C                   MOVEL     SNTP          W8TYPE
     C                   MOVEL     *BLANKS       P8LINS
     C                   MOVEL     *BLANKS       WADDRSS
     C                   MOVEL     SND1          WADCHK1
     C                   MOVEL     SND2          WADCHK2
     C                   MOVEL     SND3          WADCHK3
     C                   MOVEL     SND4          WADCHK4
     C                   MOVEL     WADDRSS       P8LINS
      *
     C                   EXSR      SRExPgm
      *
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDSND1
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDSND2
     C     35            SUBST     P8SCR:71      DDSND3
     C     35            SUBST     P8SCR:106     DDSND4
      *                                                                         CFT014
      ** Setup Receiver's Correspondent address.                                CFT014
      *                                                                         CFT014
     C                   CLEAR                   P8FT                           CFT014
     C                   MOVEL     *BLANKS       W8STMT                         CFT014
     C                   MOVEL     SMCY          W8CCY                          CFT014
     C                   MOVEL     PSProcPgm     W8CPGM                         CFT014
     C                   MOVEL     '*ENQ  '      W8ACT                          CFT014
     C                   Z-ADD     4             W8NLIN                         CFT014
      *                                                                         CFT014
     C                   MOVEL     INRCRT        W8TYPE                         CFT014
     C                   MOVEL     *BLANKS       P8LINS                         CFT014
     C                   MOVEL     *BLANKS       WADDRSS                        CFT014
     C                   MOVEL     INRCO1        WADCHK1                        CFT014
     C                   MOVEL     INRCO2        WADCHK2                        CFT014
     C                   MOVEL     INRCO3        WADCHK3                        CFT014
     C                   MOVEL     INRCO4        WADCHK4                        CFT014
     C                   MOVEL     INRCO5        WADCHK5                        CFT014
     C                   MOVEL     WADDRSS       P8LINS                         CFT014
      *                                                                         CFT014
     C                   EXSR      SRExPgm                                      CFT014
      *                                                                         CFT014
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDRCO1                         CFT014
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDRCO2                         CFT014
     C     35            SUBST     P8SCR:71      DDRCO3                         CFT014
     C     35            SUBST     P8SCR:106     DDRCO4                         CFT014
     C     35            SUBST     P8SCR:141     DDRCO5                         CFT014
      *
      ** Set up Beneficiary customer.
      *
     C                   CLEAR                   P8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     PCCY          W8CCY
     C                   MOVEL     PSProcPgm     W8CPGM
     C                   MOVEL     '*ENQ  '      W8ACT
     C                   Z-ADD     5             W8NLIN
      *
     C                   MOVEL     BNCT          W8TYPE
     C                   MOVEL     *BLANKS       P8LINS
     C                   MOVEL     *BLANKS       WADDRSS
     C                   MOVEL     BNC1          WADCHK1
     C                   MOVEL     BNC2          WADCHK2
     C                   MOVEL     BNC3          WADCHK3
     C                   MOVEL     BNC4          WADCHK4
     C                   MOVEL     BNC5          WADCHK5
     C                   MOVEL     WADDRSS       P8LINS
      *
     C                   EXSR      SRExPgm
      *
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDBNC1
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDBNC2
     C     35            SUBST     P8SCR:71      DDBNC3
     C     35            SUBST     P8SCR:106     DDBNC4
     C     35            SUBST     P8SCR:141     DDBNC5
      *
     C                   ENDIF
      *
      ** Book code.
      *
     C                   MOVE      BOKC          DDBOKC
      *
      ** Profit Centre.
      *
     C     BKPRCU        IFEQ      'Y'
     C                   MOVE      PRFC          DDPRFC
     C                   ENDIF
      *
      ** Fontis dealer's reference
      *
     C                   IF        CGL009 = 'Y'
     C                   MOVEL     FDLR          DDFDLR
     C                   ENDIF
      ***********                                                               CFT014
      ***If*EMU*FT*Settlement*Currency*Conversion*is*switched*on,*set*up        CFT014
      ***Notified*Delivery*Currency*and*Amount.************************         CFT014
      ***********                                                               CFT014
     C*****CEU006        IFEQ      'Y'                                          CFT014
     C*****NDCY**        ANDNE     *BLANKS                                      CFT014
      *                                                                         CFT014
      ** If EMU FT Settlement Currency Conversion is switched on or if          CFT014
      ** STP Phase 2 MT103 Processing is switched on, set up Instructed         CFT014
      ** Currency and Amount.                                                   CFT014
      *                                                                         CFT014
     C                   IF        (CEU006 = 'Y' or CFT014 = 'Y') and           CFT014
     C                             NDCY <> *BLANKS                              CFT014
     C                   MOVE      NDCY          DDNDCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDNDCY        PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     DDNDCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   Z-ADD     NDAM          PFMTIN
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDNDAM
     C                   ENDIF
      *                                                                         CFT014
      ** Orginal Exchange Rate.                                                 CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y' and INOEXR <> *ZERO             CFT014
     C                   Z-ADD     8             PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INOEXR * 100000000                  CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDOEXR                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Settlement Currency.
      *
     C                   MOVE      SMCY          DDSMCY
      *
      ** Settlement Amount.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSMCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     DDSMCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   Z-ADD     SMAM          PFMTIN
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDSMAM
      *
      ** Settlement Value Date.
      *
     C     SLDT          IFNE      *ZERO
     C                   Z-ADD     SLDT          PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo           5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM      *ZERO         PZDate            6 0
     C                   PARM      *BLANKS       PZaDate           7
     C                   MOVEL     PZDate        DDSLDT
     C                   ENDIF
      *
      ** Payment Currency.
      *
     C                   MOVE      PCCY          DDPCCY
      *
      ** Payment Amount.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDPCCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     DDPCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   Z-ADD     PYAM          PFMTIN
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDPYAM
      *
      ** Payment Value Date.
      *
     C     PVDT          IFNE      *ZERO
     C                   Z-ADD     PVDT          PZDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM      BJDFIN        PFmt
     C                   PARM      *ZERO         PZDate
     C                   PARM      *BLANKS       PZaDate
     C                   MOVEL     PZDate        DDPYDT
     C                   ENDIF
      *
      ** Rate.
      *
     C                   Z-ADD     8             PFMDEC
     C                   MOVE      RATE          PFMTIN
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDRATE
      *
      ** Override Flag.
      *
     C                   MOVE      OVRD          DDOVRD
      *
      ** Add/Deduct Charges Indicator.
      *
     C                   MOVE      ADDC          DDADDC
     C/COPY WNCPYSRC,FTIPAYNC01
      *                                                                         CFT009
      ** FX spread set and payment date offset code                             CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      SPDSET = FXSPSC                              CFT009
     C                   EVAL      SOFCD = INPDOF                               CFT009
     C                   EVAL      TRCDE = TFCCCO                               CFT009
     C                   EVAL      TXCDE = TLCODE                               CFT009
     C                   EVAL      CQCDE = CHCHCD                               CFT009
     C                   EVAL      ADCDE = ADCHCD                               CFT009
     C                   EVAL      TPCDE = TLCHCD                               CFT009
     C                   EVAL      MSCDE = MISCH                                CFT009
     C                   EVAL      FXCDE = FXCHEC                               CFT009
     C                   EVAL      M1CDE = MSCH1                                CFT009
     C                   EVAL      M2CDE = MSCH2                                CFT009
     C                   EVAL      M3CDE = MSCH3                                CFT009
     C                   EVAL      M4CDE = MSCH4                                CFT009
     C                   EVAL      M5CDE = MSCH5                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** LEVEL 2/1
      *  =========
      *
      ** Ordering Bank.
      *
     C                   MOVEL     ORB1          DDOBK1
     C                   MOVEL     ORB2          DDOBK2
     C                   MOVEL     ORB3          DDOBK3
     C                   MOVEL     ORB4          DDOBK4
     C                   MOVEL     ORB5          DDOBK5
      *
      ** Sender's Correspondent.
      *
     C                   MOVEL     SNC1          DDSNC1
     C                   MOVEL     SNC2          DDSNC2
     C                   MOVEL     SNC3          DDSNC3
     C                   MOVEL     SNC4          DDSNC4
     C                   MOVEL     SNC5          DDSNC5
      *
      ** Ordering Customer.
      *
     C                   MOVEL     ORC1          DDORC1
     C                   MOVEL     ORC2          DDORC2
     C                   MOVEL     ORC3          DDORC3
     C                   MOVEL     ORC4          DDORC4
     C***********        MOVEL     *BLANKS       DDORC5                         CFT014
     C                   EVAL      DDORC5 = ORC5                                              CFT032
      *
      ** Bank to Bank Information.
      *
     C                   MOVEL     BBI1          DDBBI1
     C                   MOVEL     BBI2          DDBBI2
     C                   MOVEL     BBI3          DDBBI3
     C                   MOVEL     BBI4          DDBBI4
     C                   MOVEL     BBI5          DDBBI5
     C                   MOVEL     BBI6          DDBBI6
      *
      ** If Enquiry, set up Addresses for screen display.
      *
     C     DDACTN        IFEQ      'E'
     C     JobType       AndEq     'INTER'                                                  BUG18401
     C     BtnPressed    OREQ      'ENQUIRE'                                               AR1090283
     C     PSJobName     ANDEQ     'QZDASOINIT'                                            AR1090283
     C     BtnPressed    OREQ      'ENQUIRE'                                                MD024011
     C     PSJobName     ANDEQ     'QZDASSINIT'                                             MD024011
      *
      ** Set up Ordering Bank.
      *
     C                   CLEAR                   P8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     PSProcPgm     W8CPGM
     C                   MOVEL     '*ENQ  '      W8ACT
     C                   Z-ADD     5             W8NLIN
      *
     C                   MOVEL     ORBT          W8TYPE
     C                   MOVEL     *BLANKS       P8LINS
     C                   MOVEL     *BLANKS       WADDRSS
     C                   MOVEL     ORB1          WADCHK1
     C                   MOVEL     ORB2          WADCHK2
     C                   MOVEL     ORB3          WADCHK3
     C                   MOVEL     ORB4          WADCHK4
     C                   MOVEL     ORB5          WADCHK5
     C                   MOVEL     WADDRSS       P8LINS
      *
     C                   EXSR      SRExPgm
      *
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDOBK1
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDOBK2
     C     35            SUBST     P8SCR:71      DDOBK3
     C     35            SUBST     P8SCR:106     DDOBK4
     C     35            SUBST     P8SCR:141     DDOBK5
      *
      ** Set up Sender's Correspondent.
      *
     C                   CLEAR                   P8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     PSProcPgm     W8CPGM
     C                   MOVEL     '*ENQ  '      W8ACT
     C                   Z-ADD     5             W8NLIN
      *
     C                   MOVEL     SNCT          W8TYPE
     C                   MOVEL     *BLANKS       P8LINS
     C                   MOVEL     *BLANKS       WADDRSS
     C                   MOVEL     SNC1          WADCHK1
     C                   MOVEL     SNC2          WADCHK2
     C                   MOVEL     SNC3          WADCHK3
     C                   MOVEL     SNC4          WADCHK4
     C                   MOVEL     SNC5          WADCHK5
     C                   MOVEL     WADDRSS       P8LINS
      *
     C                   EXSR      SRExPgm
      *
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDSNC1
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDSNC2
     C     35            SUBST     P8SCR:71      DDSNC3
     C     35            SUBST     P8SCR:106     DDSNC4
     C     35            SUBST     P8SCR:141     DDSNC5
      *
      ** Set up Ordering Customer.
      *
     C                   CLEAR                   P8FT
     C                   MOVEL     *BLANKS       W8STMT
     C                   MOVEL     PSProcPgm     W8CPGM
     C                   MOVEL     '*ENQ  '      W8ACT
     C                   Z-ADD     5             W8NLIN
      *
     C                   MOVEL     ORCT          W8TYPE
     C                   MOVEL     *BLANKS       P8LINS
     C                   MOVEL     *BLANKS       WADDRSS
     C                   MOVEL     ORC1          WADCHK1
     C                   MOVEL     ORC2          WADCHK2
     C                   MOVEL     ORC3          WADCHK3
     C                   MOVEL     ORC4          WADCHK4
     C                   MOVEL     *BLANKS       WADCHK5
     C                   EVAL      WADCHK5 = ORC5                                             CFT032
     C                   MOVEL     WADDRSS       P8LINS
      *
     C                   EXSR      SRExPgm
      *
     C     DDACTN        IFEQ      'E'                                                      MD039986
     C     JobType       ANDEQ     'INTER'                                                  MD039986
     C     35            SUBST     P8SCR:1       DDORC1
     C                   ENDIF                                                              MD039986
     C     35            SUBST     P8SCR:36      DDORC2
     C     35            SUBST     P8SCR:71      DDORC3
     C     35            SUBST     P8SCR:106     DDORC4
     C*****35****        SUBST     P8SCR:141     DDORC5                         CFT014
     C     35            SUBST     P8SCR:141     DDORC5                                       CFT032
      *
     C                   ENDIF
      *
      ** Transfer Commission Tariff.
      *
     C                   MOVEL     TRCT          DDTRCT
      *
      ** Charges to the Debit of A/c.
      *
     C     CDRT          IFNE      *BLANKS
     C**********         MOVEL     CDRO          WACDRO           12                          CGL029
     C                   MOVEL     CDRO          WACDRO                                       CGL029
     C                   SELECT
     C     CDRT          WHENEQ    'N'
     C     2             SUBST(P)  WACDRO:1      DDCDRO
     C     CDRT          WHENEQ    'R'
     C     10            SUBST(P)  WACDRO:1      DDCDRO
     C     CDRT          WHENEQ    'P'
     C                   MOVEL     CDRO          DDCDRO
     C                   ENDSL
     C                   ENDIF
      *
      ** Set up 'Charges to Debit of' Branch only if multibranching.
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     CDBR          DDCDBR
     C                   ENDIF
      *                                                                                       CFT120
      ** Set up Charges to Debit of Currency                                                  CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     INCDRC        DDCDRC                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT157
      ** Set up Stop User                                                                     CFT157
      *                                                                                       CFT157
     C                   IF        CFT157 = 'Y'                                               CFT157
     C                   MOVEL     SUSR          DDSUSR                                       CFT157
     C                   ENDIF                                                                CFT157
      *
      ** LEVEL 2/2
      *  =========
      *
      ** Intermediary Bank.
      *
     C                   MOVEL     INB1          DDINB1
     C                   MOVEL     INB2          DDINB2
     C                   MOVEL     INB3          DDINB3
     C                   MOVEL     INB4          DDINB4
     C                   MOVEL     INB5          DDINB5
      *
      ** Details of Payment.
      *
     C                   MOVEL     DTP1          DDDTP1
     C                   MOVEL     DTP2          DDDTP2
     C                   MOVEL     DTP3          DDDTP3
     C                   MOVEL     DTP4          DDDTP4
      *
      ** Central Bank Reference.
      *
     C     DNBC          IFNE      0
     C                   MOVEL     DNBC          DDDNBC
     C                   ENDIF
      *
      ** Related Pay Reference.
      *
     C                   MOVEL     RLPR          DDRLPR
      *                                                                         CFT014
      ** Format following fields of CFT014 is switched on.                      CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
      *                                                                         CFT014
      ** Bank Operation Code                                                    CFT014
     C                   EVAL      DDBOCD = INBOCD                              CFT014
      *                                                                         CFT014
      ** Transaction Type Code                                                  CFT014
     C                   EVAL      DDTTCD = INTTCD                              CFT014
      *                                                                         CFT014
      ** Instruction Code                                                       CFT014
     C                   EVAL      DDICD1 = INICD1                              CFT014
     C                   EVAL      DDICD2 = INICD2                              CFT014
     C                   EVAL      DDICD3 = INICD3                              CFT014
     C                   EVAL      DDICD4 = INICD4                              CFT014
     C                   EVAL      DDICD5 = INICD5                              CFT014
      *                                                                         CFT014
      ** Regulatory Reporting                                                   CFT014
     C                   EVAL      DDRRP1 = INRRP1                              CFT014
     C                   EVAL      DDRRP2 = INRRP2                              CFT014
     C                   EVAL      DDRRP3 = INRRP3                              CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Details of Charges.
      *
     C                   MOVEL     DTCH          DDDTCH
      *
      ** Outward Payment to be Generated.
      *
     C                   MOVEL     OPIN          DDOPIN
                                                                                CFT009
      * Output charges                                                          CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C**********         IF        CDRO <> *ZEROS                                    CFT009 BUG16620
     C                   IF        CDRO <> *BLANKS                                          BUG16620
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y' AND INCDRC = *BLANKS OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   EVAL      POCCY = BJCYCD                               CFT009
     C                   ELSE                                                                 CFT120
     C                   EVAL      POCCY = INCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ELSE                                                   CFT009
     C                   IF        ADDC = 'A'                                   CFT009
     C                   EVAL      POCCY = SMCY                                 CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      POCCY = PCCY                                 CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Get Output Currency decimal places.                                    CFT009
      *                                                                         CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *BLANK        PRTCD                          CFT009
     C                   PARM      '*KEY   '     POPTN                          CFT009
     C                   PARM      POCCY         PCURR                          CFT009
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C                   MOVEL     POCCY         DBKEY                          CFT009
     C                   MOVEL     'SDCURRPD'    DBFILE                         CFT009
     C                   Z-ADD     7             DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   EVAL      PONBDP = A6NBDP                              CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Determine Input Charge Currency to format Charge Amounts.
      *
     C                   SELECT
      *
     C     BTCHCY        WHENEQ    'B'
     C*****CDRO*         ORNE      *ZERO                                                    BUG16620
     C     CDRO          ORNE      *BLANKS                                                  BUG16620
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     BTCHCY        ANDNE     'F'                                                     AR1079259
     C                   MOVEL     BJCYCD        WICCY             3
      *
     C     BTCHCY        WHENEQ    'L'
     C                   MOVEL     BJLCCY        WICCY
      *                                                                         CFT009
     C     BTCHCY        WHENEQ    'F'                                          CFT009
     C                   MOVEL     FCHCCY        WICCY                          CFT009
      *
     C     BTCHCY        WHENEQ    'C'
     C     ADDC          ANDEQ     'A'
     C                   MOVEL     SMCY          WICCY
      *
     C                   OTHER
     C                   MOVEL     PCCY          WICCY
      *
     C                   ENDSL
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      PICCY = WICCY                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Get Input Currency decimal places.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WICCY         PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     WICCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      PINBDP = A6NBDP                              CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Set up Charge Amounts.
      *
      ** Transfer Commission.
      *
     C     DUMA1         IFNE      *ZERO
     C                   Z-ADD     DUMA1         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTRCD
     C                   ENDIF
      *
      ** Telex Charge.
      *
     C     DUMA2         IFNE      *ZERO
     C                   Z-ADD     DUMA2         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTXCD
     C                   ENDIF
      *
      ** Cheque Charge.
      *
     C     DUMA3         IFNE      *ZERO
     C                   Z-ADD     DUMA3         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCQCD
     C                   ENDIF
      *
      ** Advice Charge.
      *
     C     DUMA4         IFNE      *ZERO
     C                   Z-ADD     DUMA4         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDADCD
     C                   ENDIF
      *
      ** Telephone Charge.
      *
     C     DUMA5         IFNE      *ZERO
     C                   Z-ADD     DUMA5         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTLCD
     C                   ENDIF
      *
      ** Miscellaneous Charge.
      *
     C     DUMA6         IFNE      *ZERO
     C                   Z-ADD     DUMA6         PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDMSCD
     C                   ENDIF
      *
      ** Set up FX/Change Commission only if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C     INDUM7        IFNE      *ZERO
     C                   Z-ADD     INDUM7        PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCHCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up VAT Flags if BLI VAT Processing feature is on.
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
      *
     C                   MOVEL     INVAT1        DDVAT1
     C                   MOVEL     INVAT2        DDVAT2
     C                   MOVEL     INVAT3        DDVAT3
     C                   MOVEL     INVAT4        DDVAT4
     C                   MOVEL     INVAT5        DDVAT5
     C                   MOVEL     INVAT6        DDVAT6
      *
      ** Set up FX/Change Commission VAT Flag only if BLI VAT
      ** Processing and BLI Funds Transfer Enhancement features
      ** are on.
      *
     C     S01494        IFEQ      'Y'
     C                   MOVEL     INVAT7        DDVAT7
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   IF        CFT010 = 'Y'                                 CFT009
     C                   EVAL      VAT9 = VTMIC1                                CFT009
     C                   EVAL      VAT10 = VTMIC2                               CFT009
     C                   EVAL      VAT11 = VTMIC3                               CFT009
     C                   EVAL      VAT12 = VTMIC4                               CFT009
     C                   EVAL      VAT13 = VTMIC5                               CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** If CFT009 is on                                                        CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     *LIKE         Define    RATE          Rate_to_use                    CFT009
     C                   If        CHTRCY = 'Y'                                 CFT009
     C                   Eval      Rate_to_use = RATE                           CFT009
     C                   Else                                                   CFT009
     C                   Eval      Rate_to_use = INCHRT                         CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 1                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC01 <> 0                                  CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EVAL      D#TCCY = POCCY                               CFT009
     C                   EVAL      D#FCCY = PICCY                               CFT009
                                                                                CFT009
     C                   If        DDACTN = 'E'                                 CFT009
     C                   Z-ADD     MSC01         PFMTIN                         CFT009
     C                   Else                                                   CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      MSC01         PCharge_Amt      13 0          CFT009
     C                   PARM      PCCY          PPay_Ccy          3            CFT009
     C                   PARM      SMCY          PSettle_Ccy       3            CFT009
     C                   PARM      INCHGC        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   PFMTIN                         CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M1CH                           CFT009
                                                                                CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 2                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC02 <> 0                                  CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EVAL      D#TCCY = POCCY                               CFT009
     C                   EVAL      D#FCCY = PICCY                               CFT009
                                                                                CFT009
     C                   If        DDACTN = 'E'                                 CFT009
     C                   Z-ADD     MSC02         PFMTIN                         CFT009
     C                   Else                                                   CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      MSC02         PCharge_Amt      13 0          CFT009
     C                   PARM      PCCY          PPay_Ccy          3            CFT009
     C                   PARM      SMCY          PSettle_Ccy       3            CFT009
     C                   PARM      INCHGC        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   PFMTIN                         CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M2CH                           CFT009
                                                                                CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 3                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC03 <> 0                                  CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EVAL      D#TCCY = POCCY                               CFT009
     C                   EVAL      D#FCCY = PICCY                               CFT009
                                                                                CFT009
     C                   If        DDACTN = 'E'                                 CFT009
     C                   Z-ADD     MSC03         PFMTIN                         CFT009
     C                   Else                                                   CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      MSC03         PCharge_Amt      13 0          CFT009
     C                   PARM      PCCY          PPay_Ccy          3            CFT009
     C                   PARM      SMCY          PSettle_Ccy       3            CFT009
     C                   PARM      INCHGC        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   PFMTIN                         CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M3CH                           CFT009
                                                                                CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 4                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC04 <> 0                                  CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EVAL      D#TCCY = POCCY                               CFT009
     C                   EVAL      D#FCCY = PICCY                               CFT009
                                                                                CFT009
     C                   If        DDACTN = 'E'                                 CFT009
     C                   Z-ADD     MSC04         PFMTIN                         CFT009
     C                   Else                                                   CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      MSC04         PCharge_Amt      13 0          CFT009
     C                   PARM      PCCY          PPay_Ccy          3            CFT009
     C                   PARM      SMCY          PSettle_Ccy       3            CFT009
     C                   PARM      INCHGC        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   PFMTIN                         CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M4CH                           CFT009
                                                                                CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 5                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC05 <> 0                                  CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EVAL      D#TCCY = POCCY                               CFT009
     C                   EVAL      D#FCCY = PICCY                               CFT009
                                                                                CFT009
     C                   If        DDACTN = 'E'                                 CFT009
     C                   Z-ADD     MSC05         PFMTIN                         CFT009
     C                   Else                                                   CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      MSC05         PCharge_Amt      13 0          CFT009
     C                   PARM      PCCY          PPay_Ccy          3            CFT009
     C                   PARM      SMCY          PSettle_Ccy       3            CFT009
     C                   PARM      INCHGC        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   PFMTIN                         CFT009
     C                   Endif                                                  CFT009
                                                                                CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M5CH                           CFT009
                                                                                CFT009
     C                   Endif                                                  CFT009
      *                                                                         CFT009
      ** Format Total VAT Amount (Input Currency).                              CFT009
      *                                                                         CFT009
     C                   IF        INDUM8 <> *ZERO                              CFT009
     C                   Z-ADD     INDUM8        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDVATD                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDVATD                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Format Total VAT Amount (Charges Currency).                            CFT009
      *                                                                         CFT009
     C                   IF        INVATT <> *ZERO                              CFT009
     C                   Z-ADD     INVATT        PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFmtAmt                                     CFT009
     C                   MOVE      PFMTOUT       DDVATT                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDVATT                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 1                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC01 <> 0                                  CFT009
     C                   Z-ADD     CMSC01        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M1CD                           CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       M1CD                           CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 2                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC02 <> 0                                  CFT009
     C                   Z-ADD     CMSC02        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M2CD                           CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       M2CD                           CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 3                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC03 <> 0                                  CFT009
     C                   Z-ADD     CMSC03        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M3CD                           CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       M3CD                           CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 4                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC04 <> 0                                  CFT009
     C                   Z-ADD     CMSC04        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M4CD                           CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       M4CD                           CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous 5                                                        CFT009
                                                                                CFT009
     C                   IF        CMSC05 <> 0                                  CFT009
     C                   Z-ADD     CMSC05        PFMTIN                         CFT009
     C                   Z-ADD     PINBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       M5CD                           CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       M5CD                           CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Transfer commission                                                    CFT009
                                                                                CFT009
     C                   IF        TRCM <> 0                                    CFT009
     C                   Z-ADD     TRCM          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDTRCM                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANK        DDTRCM                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Telex                                                                  CFT009
                                                                                CFT009
     C                   IF        TXCH <> 0                                    CFT009
     C                   Z-ADD     TXCH          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDTXCH                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDTXCH                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Cheque                                                                 CFT009
                                                                                CFT009
     C                   IF        CQCH <> 0                                    CFT009
     C                   Z-ADD     CQCH          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDCQCH                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDCQCH                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Advice                                                                 CFT009
                                                                                CFT009
     C                   IF        ADCH <> 0                                    CFT009
     C                   Z-ADD     ADCH          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDADCH                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDADCH                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Telephone                                                              CFT009
                                                                                CFT009
     C                   IF        TLCH <> 0                                    CFT009
     C                   Z-ADD     TLCH          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDTLCH                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDTLCH                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Miscellaneous                                                          CFT009
                                                                                CFT009
     C                   IF        MSCH <> 0                                    CFT009
     C                   Z-ADD     MSCH          PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDMSCH                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDMSCH                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** FX/Change                                                              CFT009
                                                                                CFT009
     C                   IF        INCHCM <> 0                                  CFT009
     C                   Z-ADD     INCHCM        PFMTIN                         CFT009
     C                   Z-ADD     PONBDP        PFMDEC                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      PFMTOUT       DDCHCM                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *BLANKS       DDCHCM                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT014
      ** Format following fields of CFT014 is switched on.                      CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
      *                                                                         CFT014
      ** Receiver's Charges Remitted                                            CFT014
     C                   IF        INRCRM <> *ZERO                              CFT014
     C                   EVAL      PCURR = SMCY                                 CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INRCRM                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDRCRM                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Sender's Charges Deducted                                              CFT014
     C                   IF        INSCY1 <> *BLANKS                            CFT014
     C                   EVAL      PCURR = INSCY1                               CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INSCH1                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDSCH1                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        INSCY2 <> *BLANKS                            CFT014
     C                   EVAL      PCURR = INSCY2                               CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INSCH2                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDSCH2                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        INSCY3 <> *BLANKS                            CFT014
     C                   EVAL      PCURR = INSCY3                               CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INSCH3                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDSCH3                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        INSCY4 <> *BLANKS                            CFT014
     C                   EVAL      PCURR = INSCY4                               CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INSCH4                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDSCH4                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        INSCY5 <> *BLANKS                            CFT014
     C                   EVAL      PCURR = INSCY5                               CFT014
     C                   EXSR      SRAoCurr                                     CFT014
     C                   Z-ADD     A6NBDP        PFMDEC                         CFT014
     C                   EVAL      PFMTIN = INSCH5                              CFT014
     C                   EXSR      SRFmtAmt                                     CFT014
     C                   MOVE      PFMTOUT       DDSCH5                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVEL     INSCY1        DDSCC1                         CFT014
     C                   MOVEL     INSCY2        DDSCC2                         CFT014
     C                   MOVEL     INSCY3        DDSCC3                         CFT014
     C                   MOVEL     INSCY4        DDSCC4                         CFT014
     C                   MOVEL     INSCY5        DDSCC5                         CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Set up FX Margin fields if Analytical Accounting feature is on.
      *
     C     BGN0ST        IFEQ      'Y'
      *
      ** FX Margin Points.
      *
     C     FXMP          IFNE      0
     C     FXMP          MULT      100           PFMTIN
     C                   Z-ADD     2             PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDFXMP
     C                   ELSE                                                                 CAP084
     C     MSIG          IFNE      *BLANKS                                                    CAP084
     C                   MOVE      '0.00'        DDFXMP                                       CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF
      *
      ** Margin P/S Indicator.
      *
     C     MBSI          IFEQ      'S'
     C                   MOVE      'P'           DDMBSI
     C                   ENDIF
      *
     C     MBSI          IFEQ      'B'
     C                   MOVE      'S'           DDMBSI
     C                   ENDIF
      *
      ** Margin Sign.
      *
     C                   MOVEL     MSIG          DDMSIG
      *
     C                   ENDIF
      *                                                                                       CSW209
      ** Populate Cover Message fields                                                        CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     INNWRK        DDNWRK                                       CSW209
     C                   MOVEL     INMTPY        DDMTPY                                       CSW209
     C                   MOVEL     INVALF        DDVALF                                       CSW209
      ** Ordering Customer (Cover)                                                            CSW209
     C                   MOVEL     INCOC1        DDCOC1                                       CSW209
     C                   MOVEL     INCOC2        DDCOC2                                       CSW209
     C                   MOVEL     INCOC3        DDCOC3                                       CSW209
     C                   MOVEL     INCOC4        DDCOC4                                       CSW209
     C                   MOVEL     INCOC5        DDCOC5                                       CSW209
      ** Ordering Institution (Cover)                                                         CSW209
     C                   MOVEL     INCOB1        DDCOB1                                       CSW209
     C                   MOVEL     INCOB2        DDCOB2                                       CSW209
     C                   MOVEL     INCOB3        DDCOB3                                       CSW209
     C                   MOVEL     INCOB4        DDCOB4                                       CSW209
     C                   MOVEL     INCOB5        DDCOB5                                       CSW209
      ** Intermediary Institution (Cover)                                                     CSW209
     C                   MOVEL     INCIB1        DDCIB1                                       CSW209
     C                   MOVEL     INCIB2        DDCIB2                                       CSW209
     C                   MOVEL     INCIB3        DDCIB3                                       CSW209
     C                   MOVEL     INCIB4        DDCIB4                                       CSW209
     C                   MOVEL     INCIB5        DDCIB5                                       CSW209
      ** Account with Institution (Cover)                                                     CSW209
     C                   MOVEL     INCAB1        DDCAB1                                       CSW209
     C                   MOVEL     INCAB2        DDCAB2                                       CSW209
     C                   MOVEL     INCAB3        DDCAB3                                       CSW209
     C                   MOVEL     INCAB4        DDCAB4                                       CSW209
     C                   MOVEL     INCAB5        DDCAB5                                       CSW209
      ** Beneficiary Customer (Cover)                                                         CSW209
     C                   MOVEL     INCBC1        DDCBC1                                       CSW209
     C                   MOVEL     INCBC2        DDCBC2                                       CSW209
     C                   MOVEL     INCBC3        DDCBC3                                       CSW209
     C                   MOVEL     INCBC4        DDCBC4                                       CSW209
     C                   MOVEL     INCBC5        DDCBC5                                       CSW209
      ** Remittance Information (Cover)                                                       CSW209
     C                   MOVEL     INCDP1        DDCDP1                                       CSW209
     C                   MOVEL     INCDP2        DDCDP2                                       CSW209
     C                   MOVEL     INCDP3        DDCDP3                                       CSW209
     C                   MOVEL     INCDP4        DDCDP4                                       CSW209
      ** Sender to Receiver (Cover)                                                           CSW209
     C                   MOVEL     INCBB1        DDCBB1                                       CSW209
     C                   MOVEL     INCBB2        DDCBB2                                       CSW209
     C                   MOVEL     INCBB3        DDCBB3                                       CSW209
     C                   MOVEL     INCBB4        DDCBB4                                       CSW209
     C                   MOVEL     INCBB5        DDCBB5                                       CSW209
     C                   MOVEL     INCBB6        DDCBB6                                       CSW209
      ** Instructed Currency (Cover)                                                          CSW209
     C                   MOVEL     INCICY        DDCICY                                       CSW209
      ** Instructed Amount (Cover)                                                            CSW209
     C                   IF        INCICY <> *BLANKS                                          CSW209
      ** Get Input Currency decimal places.                                                   CSW209
     C                   CALLB     'AOCURRR0'                                                 CSW209
     C                   PARM      *BLANK        PRTCD                                        CSW209
     C                   PARM      '*KEY   '     POPTN                                        CSW209
     C                   PARM      INCICY        PCURR                                        CSW209
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW209
      *                                                                                       CSW209
     C                   IF        PRTCD <> *BLANKS                                           CSW209
     C                   MOVEL     INCICY        DBKEY                                        CSW209
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CSW209
     C                   Z-ADD     4             DBASE                                        CSW209
     C                   EXSR      *PSSR                                                      CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   Z-ADD     INCIAM        PFMTIN                                       CSW209
     C                   Z-ADD     A6NBDP        PFMDEC                                       CSW209
     C                   EXSR      SRFmtAmt                                                   CSW209
     C                   MOVE      PFMTOUT       DDCIAM                                       CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *
      ** Set up Status Flag for display.
      *
     C                   SELECT
      *
      ** Authorised.
      *
     C     PRECI         WHENEQ    'D'
     C     AUIN          ANDEQ     'Y'
     C                   MOVEL     'FTM2309'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        PStatus
      *
      ** Matured.
      *
     C     PRECI         WHENEQ    'M'
     C                   MOVEL     'FTM2308'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        PStatus
      *
      ** Deleted.
      *
     C     PRECI         WHENEQ    'C'
     C/COPY WNCPYSRC,FTH00440
      *                                                                                       CFT157
     C     PCHTP         ANDNE     'S'                                                        CFT157
      *                                                                                       CFT157
     C                   MOVEL     'FTM2311'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        PStatus
     C/COPY WNCPYSRC,FTH00441
      *                                                                                       CFT157
     C     PRECI         WHENEQ    'C'                                                        CFT157
     C     PCHTP         ANDEQ     'S'                                                        CFT157
     C                                                                                        CFT157
     C                   MOVEL     '5047371'     PMSGID                                       CFT157
     C                   MOVEL     *BLANKS       PMSDTA                                       CFT157
     C                   EXSR      SRRtvMsg                                                   CFT157
     C                   MOVEL     PMSTX1        PStatus                                      CFT157
      *                                                                                       CFT157
      *
      ** Live.
      *
     C     PRECI         WHENEQ    'D'
     C                   MOVEL     'FTM2310'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        PStatus
      *
     C                   ENDSL
      *
      ** Convert Additional Information details if action is
      ** is Enquire.
      *
     C     DDACTN        IFEQ      'E'
      *
      ** Retrieve the user profile names of the Input Users 1 & 2 and
      ** Authorising Users 1 & 2 from MUSERDD.
      *
     C                   MOVEL     INUSR1        DDUSRP1
     C     INUSR1        IFNE      *BLANKS
     C     INUSR1        CHAIN     MUSER                              01
     C     *IN01         IFEQ      *ON
     C     *IN01         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        DDUSER1
     C                   ELSE
     C                   MOVEL     USER1         DDUSER1
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     INUSR2        DDUSRP2
     C     INUSR2        IFNE      *BLANKS
     C     INUSR2        CHAIN     MUSER                              01
     C     *IN01         IFEQ      *ON
     C     *IN01         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        DDUSER2
     C                   ELSE
     C                   MOVEL     USER1         DDUSER2
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     AUP1          DDAUP1
     C     AUP1          IFNE      *BLANKS
     C     AUP1          CHAIN     MUSER                              01
     C     *IN01         IFEQ      *ON
     C     *IN01         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        DDAUT1
     C                   ELSE
     C                   MOVEL     USER1         DDAUT1
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     AUP2          DDAUP2
     C     AUP2          IFNE      *BLANKS
     C     AUP2          CHAIN     MUSER                              01
     C     *IN01         IFEQ      *ON
     C     *IN01         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        DDAUT2
     C                   ELSE
     C                   MOVEL     USER1         DDAUT2
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve MIR and MOR of the transaction from MEINCRPD.
      *
     C     INMSGR        IFNE      *ZEROS
     C     INMSGR        CHAIN     MEINCRL1                           01
     C     *IN01         IFEQ      *ON
     C                   MOVEL     WM2519        DDNMIR
     C                   MOVEL     WM2519        DDNMOR
     C                   ELSE
     C                   MOVEL     CRMIR         DDNMIR
     C                   MOVEL     CRMOR         DDNMOR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Format Reference Rate                                                   CDL049
     C     CDL049        IFEQ      'Y'                                          CDL049
     C                   MOVE      INRRAT        PFMTIN                         CDL049
     C                   Z-ADD     8             PFMDEC                         CDL049
     C                   EXSR      SRFmtAmt                                     CDL049
     C                   MOVE      PFMTOUT       DDRRAT                         CDL049
     C                   ENDIF                                                  CDL049
      *                                                                         CDL049
      ** If CER030 and CER031 is ON                                                           CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   EVAL      DDRTTY = IRTTY                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        CER031 = 'Y'                                               CER030
      *                                                                                       CER030
     C                   EVAL      DDEXT1 = IEXT1                                             CER030
     C                   EVAL      DDEXT2 = IEXT2                                             CER030
     C                   EVAL      DDEXT3 = IEXT3                                             CER030
     C                   EVAL      DDEXT4 = IEXT4                                             CER030
     C                   EVAL      DDEXT5 = IEXT5                                             CER030
     C                   EVAL      DDEXT6 = IEXT6                                             CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format Amount For Display                         *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        PRETC            10
     C                   PARM                    PFMTIN           13 0
     C                   PARM                    PFMDEC            1 0
     C                   PARM      '.'           PCCYSEP           1
     C                   PARM      *BLANK        PFMTOUT          14
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExpPgm - Call expansion program FT0315                     *
      *                                                               *
      *****************************************************************
      *
     C     SRExPgm       BEGSR
      *
      ** Call expansion program.
      *
     C                   CALL      'FT0315'                             9090
     C                   PARM      *BLANKS       P8RTN             7
     C                   PARM                    P8FT
     C                   PARM                    P8LINS          256
     C                   PARM                    P8RPT           256
     C                   PARM                    P8MSG           256
     C                   PARM                    P8SCR           256
      *
      ** Check if database error occurred.
      *
     C     *IN90         IFEQ      '1'
     C     P8RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0315  '    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvMsg - Retrieve message using MEC1150                    *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvMsg      BEGSR
      *
     C                   CALL      'MEC1150'
     C                   PARM                    PMSGID            7
     C                   PARM      'FTUSRMSG'    PMsgFile         10
     C                   PARM                    PMSDTA          132
     C                   PARM      *BLANKS       PMSTX1          132
     C                   PARM      *BLANKS       PMSTX2          512
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRAoCurr - Access currency details                           *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRAoCurr      BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   EVAL      A6NBDP = 0                                   CFT014
     C                   IF        PCURR <> *BLANKS                             CFT014
      *                                                                         CFT014
     C                   CALLB     'AOCURRR0'                                   CFT014
     C                   PARM      *BLANK        PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM                    PCURR                          CFT014
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C                   EVAL      DBKEY = PCURR                                CFT014
     C                   EVAL      DBFILE = 'SDCURRPD'                          CFT014
     C                   Z-ADD     6             DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
     C                   PARM                    CrIP2FilFmt                    CFT014
      *
      ** Action Code
     C**********         PARM                    PDDACTN           1                         BUG2219
     C                   PARM      DDACTN        PDDACTN           1                         BUG2219
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU            1
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** SDFTFR - Charges Currency
     C*******************PARM                    BTCHCY            1            CFT009
     C                   PARM                    OBTCHCY           1            CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed Charge Currency                                         CFT009
     C                   PARM                    OFCHCCY           3            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009            1
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
     C/COPY WNCPYSRC,FTIPAYNC03
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
     C/COPY WNCPYSRC,FTIPAYNC02
      *
      ** OUTPUT
      ** ======
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
     C                   PARM                    CrIP1aScnFmt                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP3ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP4ScnFmt
     C                   PARM                    CrIP4aScnFmt                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file             CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    CrIP5ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details retrieved from file              CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    CrIP6ScnFmt                    CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CrIP7ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CrIP8ScnFmt                                  CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives retrieved from file                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    CrIP6AScnFmt                                 CER030
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C**********         PARM                    DDSWTN           28                          CAP084
     C                   PARM      DDSWTN        PDDSWTN          28                          CAP084
      *
      ** Sequence No.
     C**********         PARM                    DDSEQNO           2                          CAP084
     C                   PARM      DDSEQNO       PDDSEQNO          2                          CAP084
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *                                                                         CFT009
      ** DS for Default Charge Amounts                                          CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
     C                   PARM                    BtnPressed       10                       AR1090283
      *
      ** Get text messages for FTM2510 and FTM2519.
      *
     C                   MOVEL     'FTM2510'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        WM2510           28
      *
     C                   MOVEL     'FTM2519'     PMSGID
     C                   MOVEL     *BLANKS       PMSDTA
     C                   EXSR      SRRtvMsg
     C                   MOVEL     PMSTX1        WM2519           28
      *                                                                         CFT009
      ** Access Funds Transfer ICD details.                                     CFT009
      *                                                                         CFT009
     C                   CALL      'AOFTFRR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD                          CFT009
     C                   PARM      '*FIRST '     POPTN                          CFT009
     C     SDFTFR        PARM      SDFTFR        DSFDY                          CFT009
      *                                                                         CFT009
      ** Database error.                                                        CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C                   MOVEL     POPTN         DBKEY                          CFT009
     C                   MOVEL     'SDFTFRPD'    DBFILE                         CFT009
     C                   Z-ADD     008           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                          CDL049
      ** Access SAR details for Additional Reference Rate (CDL049)               CDL049
      *                                                                          CDL049
     C                   CALLB     'AOSARDR0'                                    CDL049
     C                   PARM      *BLANKS       @RTCD                           CDL049
     C                   PARM      '*VERIFY'     @OPTN                           CDL049
     C                   PARM      'CDL049'      @SARD                           CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                           CDL049
      *                                                                          CDL049
      * DATABASE ERROR                                                           CDL049
      *                                                                          CDL049
     C     @RTCD         IFNE      *BLANKS                                       CDL049
     C     @RTCD         ANDNE     '*NRF   '                                     CDL049
     C                   MOVEL     'CDL049'      DBKEY                           CDL049
     C                   MOVEL     'SCSARDPD'    DBFILE                          CDL049
     C                   MOVEL     '905'         DBASE                           CDL049
     C                   EXSR      *PSSR                                         CDL049
     C                   END                                                     CDL049
     C*                                                                          CDL049
     C     @RTCD         IFEQ      *BLANK                                        CDL049
     C                   MOVEL     'Y'           CDL049            1             CDL049
     C                   ELSE                                                    CDL049
     C                   MOVEL     'N'           CDL049                          CDL049
     C                   END                                                     CDL049
     C/COPY WNCPYSRC,FTH00442
      *                                                                                       CFT157
                                                                                              CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   PARM      *BLANKS       @RTCD                                        CFT157
     C                   PARM      '*VERIFY'     @OPTN                                        CFT157
     C                   PARM      'CFT157'      @SARD             6                          CFT157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT157
      *                                                                                       CFT157
      * DATABASE ERROR                                                                        CFT157
      *                                                                                       CFT157
     C     @RTCD         IFNE      *BLANKS                                                    CFT157
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT157
     C                   MOVEL     'CFT157'      DBKEY                                        CFT157
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT157
     C                   MOVEL     '943'         DBASE                                        CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   END                                                                  CFT157
     C     @RTCD         IFEQ      *BLANK                                                     CFT157
     C                   MOVEL     'Y'           CFT157            1                          CFT157
     C                   ELSE                                                                 CFT157
     C                   MOVEL     'N'           CFT157                                       CFT157
     C                   END                                                                  CFT157
      *                                                                                       CFT157
      *                                                                                     BUG18401
     C                   CALLB     'ZACRTVJOBA'                         90                  BUG18401
     C                   PARM                    PSJobName                                  BUG18401
     C                   PARM                    PSUser                                     BUG18401
     C                   PARM                    PSJobNo                                    BUG18401
     C                   PARM                    JobType           5                        BUG18401
      *                                                                                     BUG18401
     C     *IN90         IFEQ      '1'                                                      BUG18401
     C                   MOVEL     '*ERROR'      RetCodeIn                                  BUG18401
     C                   MOVEL     'FTIPAYCVT'   Dbpgm                                      BUG18401
     C                   MOVEL     'ZACRTVJOBA'  Dbfile                                     BUG18401
     C                   MOVEL     '009'         Dbase                                      BUG18401
     C                   MOVEL     '*CALL'       Dbkey                                      BUG18401
     C                   EXSR      *PSSR                                                    BUG18401
     C                   ENDIF                                                              BUG18401
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARDP       PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   EVAL      *IN50 = *ON                                                CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 012                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER031 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 010                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 011                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CFT120
      ** Check the switchable feature CGL013 with the corresponding                           CFT120
      ** parameters.                                                                          CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRtCd                                        CFT120
     C                   PARM      '*VERIFY'     POptn                                        CFT120
     C                   PARM      'CFT120'      PSard                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd <> '*NRF'                                            CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 012                                                CFT120
     C                   EVAL      DBKEY = '*VERIFY'                                          CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
