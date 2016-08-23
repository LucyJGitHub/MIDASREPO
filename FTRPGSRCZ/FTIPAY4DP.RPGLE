     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments level 2 scrn 3 display')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY4DP - Incoming Payments Level 2 Screen 3 Display       *
      *                                                               *
      *  Function:  This module displays the Incoming Payments        *
      *             Level 2 screen 3 details and is a component of    *
      *             FTIPAYRPR, FTIPAYSIN, and service program for     *
      *             level 2 modules.                                  *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD035776           Date 10Sep15               *
      *  Prev Amend No. MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *Create    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Level 2 Screen 3 display file
     FFTIPAY4DF CF   E             WORKSTN INFDS(ScrInfo)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *                                                                         CFT009
      ** Payment Charge defintion file                                          CFT009
     FFTPCHGL0  IF   E           K DISK    INFSR(*PSSR)                         CFT009
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01         End of File indicator                        *
      *                                                               *
      *     10-60        Field Error - highlight screen fields        *
      *                                                               *
      *       80         CFT014 is on                                 *
      *       81         BLI Funds Transfer Enhancement is on         *
      *       82         BLI VAT Processing is on                     *
      *                                                               *
      *       70         Protect details fields                       *
      *       71         Enable CF05 - Refresh                        *
      *       72         Enable CF07 - Read Previous Record           *
      *       73         Enable CF08 - Read Next Record               *
      *       74         Enable CF15 - Select Record                  *
      *       75         Enable CF18 - Next Payment                   *
      *                  (from linked enquiry)                        *
      *                                                               *
      *       96         Subfile control                              *
      *       97         Subfile end                                  *
      *                                                               *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
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
     F/COPY WNCPYSRC,FTIPA4XF01
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
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming
      ** transaction - screen format
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)                   CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)
      *
      ** Display file information data structure
     D ScrInfo       E DS                  EXTNAME(Y2I#DSP)
      *                                                                                       CER030
      ** First DS for Access Programs, short data structure                                   CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *
      ** Arrays for screen error indicators
     D WZ0             S              1    DIM(60) CTDATA PERRCD(60)
     D WEI             S              1    DIM(60)
 
      * Miscellaneous Charge descriptions                                       CFT009
     D DESC            S             30    DIM(5) CTDATA PERRCD(1)              CFT009
      *
      ** Data structure for default Charge Amounts
     D*PCharges********DS           108                                         CFT009
     D**DDTRCM**************** 1     12                                         CFT009
     D**DDTXCH****************13     24                                         CFT009
     D**DDCQCH****************25     36                                         CFT009
     D**DDADCH****************37     48                                         CFT009
     D**DDTLCH****************49     60                                         CFT009
     D**DDMSCH****************61     72                                         CFT009
     D**DDCHCM****************73     84                                         CFT009
     D**DDVATT****************85     96                                         CFT009
     D**DDVATD****************97    108                                         CFT009
     D PCharges        DS           196                                         CFT009
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
      *
      ** Data structure for default Charge Currencies
     D PChgCcy         DS            48
     D  DDCCY1                 1      3
     D  DDCCY2                 4      6
     D  DDCCY3                 7      9
     D  DDCCY4                10     12
     D  DDCCY5                13     15
     D  DDCCY6                16     18
     D  DDCCY7                19     21
     D  DDCCY8                22     24
     D  DDRCY1                25     27
     D  DDRCY2                28     30
     D  DDRCY3                31     33
     D  DDRCY4                34     36
     D  DDRCY5                37     39
     D  DDRCY6                40     42
     D  DDRCY7                43     45
     D  DDRCY8                46     48
      *
      ** Commands text
     D WCTXTF03        C                   CONST('F3=Exit')
     D WCTXTF04        C                   CONST('F4=Prompt')
     D WCTXTF05        C                   CONST('F5=Refresh')
     D WCTXTF07        C                   CONST('F7=Previous')
     D WCTXTF08        C                   CONST('F8=Next')
     D WCTXTF12        C                   CONST('F12=Cancel')
     D WCTXTF15        C                   CONST('F15=Select')
     D WCTXTF16        C                   CONST('F16=Search')
     D WCTXTF18        C                   CONST('F18=Next Payment')
     D WCTXTF19        C                   CONST('F19=Margin Info')
     D WCTXT1F19       C                   CONST('F19=Margin Info/+                           CER030
     D                                     Extended Narratives')                              CER030
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Cursor position
     D  PRowCol        S              4B 0
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     D PICCY           S              3                                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     D POCCY           S              3                                         CFT009
      *                                                                                       CER030
      ** Fields added for CER030                                                              CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
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
      ** Main processing.
      *
     C                   EXSR      SRMainP
      *
      ** Return.
      *
     C*****PINKC         IFEQ      *ON                                                      MD027047
     C                   EVAL      *INLR = *ON
     C**********         ENDIF                                                              MD027047
      *
     C**********         RETURN                                                             MD027047
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     FTEIPY4       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx                2 0
     C                   Z-ADD     10            Ex                2 0
      *
     C     Cx            DOUGT     60
      *
     C     WEI(Cx)       IFEQ      'N'
     C     WEI(Cx)       OREQ      'W'
     C                   MOVEL     *ON           *IN(Ex)
     C                   ENDIF
      *
     C                   ADD       1             Cx
     C                   ADD       1             Ex
     C                   ENDDO
      *                                                                                       CFT120
      ** Set error code for w/f screen for Charges to Debit Ccy                               CFT120
      ** Currency (DDCDRC)                                                                    CFT120
      *                                                                                       CFT120
     C                   If        OKCdrc = 'N' AND CFT120 = 'Y'                              CFT120
     C                   Eval      *IN65  = *On                                               CFT120
     C                   EndIf                                                                CFT120
      *                                                                                       CFT120
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Enable detail fields.
      *
     C     PEDTFLD       IFEQ      'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ELSE
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
      ** Enable CF05 (Refresh).
      *
     C     PEINKE        IFEQ      'Y'
     C                   EVAL      *IN71 = *ON
     C                   ELSE
     C                   EVAL      *IN71 = *OFF
     C                   ENDIF
      *
      ** Enable CF07 (Read Previous Record).
      *
     C     PEINKG        IFEQ      'Y'
     C                   EVAL      *IN72 = *ON
     C                   ELSE
     C                   EVAL      *IN72 = *OFF
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
      *
     C     PEINKH        IFEQ      'Y'
     C                   EVAL      *IN73 = *ON
     C                   ELSE
     C                   EVAL      *IN73 = *OFF
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
      *
     C     PEINKP        IFEQ      'Y'
     C                   EVAL      *IN74 = *ON
     C                   ELSE
     C                   EVAL      *IN74 = *OFF
     C                   ENDIF
      *
      ** Enable CF18 (Next Payment).
      *
     C     PEINKS        IFEQ      'Y'
     C                   EVAL      *IN75 = *ON
     C                   ELSE
     C                   EVAL      *IN75 = *OFF
     C                   ENDIF
      *
      ** Enable CF19 - Margin Information
      *
     C     PEINKT        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   EVAL      *IN77 = *ON
     C                   ELSE
     C                   EVAL      *IN77 = *OFF
     C                   ENDIF
      *                                                                                       CER030
      ** Enable CF19 - Margin Information/Extended Narratives                                 CER030
      *                                                                                       CER030
     C     PEINKT        IFEQ      'Y'                                                        CER030
     C     CER030        IFEQ      'Y'                                                        CER030
     C     CER031        OREQ      'Y'                                                        CER030
     C     CGL013        OREQ      'Y'                                                        CER030
     C                   EVAL      *IN77 = *ON                                                CER030
     C                   EVAL      *IN78 = *ON                                                CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      *IN78 = *OFF                                               CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *
      ** Set up Commands text on footer
      *
     C                   MOVE      *BLANKS       SCMDTXT23
      ** Exit
     C                   CAT       WCTXTF03:0    SCMDTXT23
      ** Refresh
     C                   IF        *IN71 = *ON
     C                   CAT       WCTXTF05:2    SCMDTXT23
     C                   ENDIF
      ** Previous
     C                   IF        *IN72 = *ON
     C                   CAT       WCTXTF07:2    SCMDTXT23
     C                   ENDIF
      ** Next
     C                   IF        *IN73 = *ON
     C                   CAT       WCTXTF08:2    SCMDTXT23
     C                   ENDIF
      ** Cancel
     C                   CAT       WCTXTF12:2    SCMDTXT23
      ** Select
     C                   IF        *IN74 = *ON
     C                   CAT       WCTXTF15:2    SCMDTXT23
     C                   ENDIF
      ** Next Payment
     C                   IF        *IN75 = *ON
     C                   CAT       WCTXTF18:2    SCMDTXT23
     C                   ENDIF
      ** Margin Info
     C                   MOVE      *BLANKS       SCMDTXT24
      *                                                                                       CER030
      ** Margin Info/Extended Narratives                                                      CER030
      *                                                                                       CER030
     C                   IF        *IN78 = *ON                                                CER030
     C                   CAT       WCTXT1F19:0   SCMDTXT24                                    CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        *IN77 = *ON
     C                   CAT       WCTXTF19:0    SCMDTXT24
     C                   ENDIF
     C                   ENDIF                                                                CER030
      *
      ** Set up Payment Status.
      *
     C                   MOVEL     PStatus       DDSTAT
      *
      ** Set up currency for receiver's charges remitted.
      *
     C                   MOVEL     DDSMCY        DDRCCY
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
      *                                                                         CFT009
      ** Set up default Charge Currencies.                                      CFT009
      *                                                                         CFT009
     C                   EVAL      DDCCY1 = PICCY                               CFT009
     C                   EVAL      DDCCY2 = PICCY                               CFT009
     C                   EVAL      DDCCY3 = PICCY                               CFT009
     C                   EVAL      DDCCY4 = PICCY                               CFT009
     C                   EVAL      DDCCY5 = PICCY                               CFT009
     C                   EVAL      DDCCY6 = PICCY                               CFT009
     C                   EVAL      CCY9 = PICCY                                 CFT009
     C                   EVAL      CCY10 = PICCY                                CFT009
     C                   EVAL      CCY11 = PICCY                                CFT009
     C                   EVAL      CCY12 = PICCY                                CFT009
     C                   EVAL      CCY13 = PICCY                                CFT009
      *                                                                         CFT009
     C                   EVAL      DDRCY1 = POCCY                               CFT009
     C                   EVAL      DDRCY2 = POCCY                               CFT009
     C                   EVAL      DDRCY3 = POCCY                               CFT009
     C                   EVAL      DDRCY4 = POCCY                               CFT009
     C                   EVAL      DDRCY5 = POCCY                               CFT009
     C                   EVAL      DDRCY6 = POCCY                               CFT009
     C                   EVAL      RCY9 = POCCY                                 CFT009
     C                   EVAL      RCY10 = POCCY                                CFT009
     C                   EVAL      RCY11 = POCCY                                CFT009
     C                   EVAL      RCY12 = POCCY                                CFT009
     C                   EVAL      RCY13 = POCCY                                CFT009
      *                                                                         CFT009
      ** Default FX/Commission Charge Currencies if BLI Funds                   CFT009
      ** Funds Enhancement feature is on.                                       CFT009
      *                                                                         CFT009
     C     S01494        IFEQ      'Y'                                          CFT009
     C                   EVAL      DDCCY7 = PICCY                               CFT009
     C                   EVAL      DDRCY7 = POCCY                               CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Default VAT Charge Currencies if CFT010 is on.                         CFT009
      *                                                                         CFT009
     C     CFT010        IFEQ      'Y'                                          CFT009
     C                   EVAL      DDCCY8 = PICCY                               CFT009
     C                   EVAL      DDRCY8 = POCCY                               CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Miscellaneous Charge descriptions                                      CFT009
                                                                                CFT009
     C     M1CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M1DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M1DESC = DESC(1)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M2CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M2DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M2DESC = DESC(2)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M3CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M3DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M3DESC = DESC(3)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M4CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M4DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M4DESC = DESC(4)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M5CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M5DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M5DESC = DESC(5)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    DDTIME
      *
      ** Save Charges to the debit of field - we need to know if it                           CFT009
      ** changes and we need to re-call ft000981 in validation modules                        CFT009
      ** if it has.                                                                           CFT009
     C     *LIKE         DEFINE    DDCDRO        PrvDDCDRO                                    CFT009
     C                   EVAL      PrvDDCDRO = DDCDRO                                         CFT009
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     *LIKE         DEFINE    DDCDRC        PrvDDCDRC                                    CFT120
     C                   EVAL      PrvDDCDRC = DDCDRC                                         CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   WRITE     FTIPAYC0
     C                   WRITE     FTIPAYD1
     C                   WRITE     FTIPAYF1
      *
      ** If not Write Only, read details screen.
      *
     C     PWriteOnly    IFNE      'Y'
     C                   READ      FTIPAYD1                               01
     C                   ENDIF
      *                                                                                       CFT009
      ** Check if new value entered for Charges to the debit of                               CFT009
     C                   IF        PrvDDCDRO <> DDCDRO                                        CFT009
     C                             OR  PrvDDCDRC <> DDCDRC AND CFT120 = 'Y'                   CFT120
     C                   EVAL      PCDROCHG = 'Y'                                             CFT009
     C                   ELSE                                                                 CFT009
     C                   EVAL      PCDROCHG = *blanks                                         CFT009
     C                   ENDIF                                                                CFT009
      *
      ** If feature BIC database plus is installed, pass cursor position.
     C                   IF        CFT007 = 'Y'
     C                   Z-ADD     @#RWCL        PRowCol
     C                   ENDIF
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     WZ0           *IN(10)
      *
      ** Set return keys.
      *
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKE         PINKE
     C                   MOVE      *INKG         PINKG
     C                   MOVE      *INKH         PINKH
     C                   MOVE      *INKL         PINKL
     C                   MOVE      *INKP         PINKP
     C                   MOVE      *INKS         PINKS
     C                   MOVE      *INKT         PINKT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
      *
      *****************************************************************
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
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Payment Reference
     C                   PARM                    DDPREF           15
      *
      ** Settle Currency
     C                   PARM                    DDSMCY            3
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NwIPFilFmt                     CFT009
      *
      ** DS for default Charge Amounts
     C                   PARM                    PCharges
      *
      ** DS for default Charge Currencies
     C                   PARM                    PChgCcy
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
      *
      ** Enable Detail Fields
     C                   PARM                    PEDTFLD           1
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KT = Command Key 19 = Margin Info
     C                   PARM                    PEINKE            1
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKS            1
     C                   PARM                    PEINKT            1
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM                    PWriteOnly        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Default branch code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** Switchable features
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *
      ** BIC database plus
     C                   PARM                    CFT007            1
      *
      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014            1
     C/COPY WNCPYSRC,FTIPA4XC01
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KT = Command Key 19 = Margin Info
     C                   PARM                    PINKC             1
     C                   PARM                    PINKE             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKS             1
     C                   PARM                    PINKT             1
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *
      ** MT103 Messages Generation for FT
     C     CFT014        IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   ELSE
     C                   MOVE      *OFF          *IN80
     C                   ENDIF
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
      *                                                                         CFT009
     C     CFT009        IFEQ      'Y'                                          CFT009
     C                   MOVE      *ON           *IN88                          CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *OFF          *IN88                          CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     CFT010        IFEQ      'Y'                                          CFT009
     C                   MOVE      *ON           *IN89                          CFT009
     C                   ELSE                                                   CFT009
     C                   MOVE      *OFF          *IN89                          CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Multi-branching environment
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN81
     C                   ELSE
     C                   MOVE      *OFF          *IN81
     C                   ENDIF
      *
      ** BLI VAT Processing feature is on.
     C     S01499        IFEQ      'Y'
     C                   MOVE      *ON           *IN82
     C                   ELSE
     C                   MOVE      *OFF          *IN82
     C                   ENDIF
      *
      ** BLI Funds Transfer Enhancement feature is on.
     C     S01494        IFEQ      'Y'
     C                   MOVE      *ON           *IN83
     C                   ELSE
     C                   MOVE      *OFF          *IN83
     C                   ENDIF
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
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
     C                   EVAL      DBASE = 001                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 002                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
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
     C                   EVAL      DBASE = 003                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CFT120
      ** Check the switchable feature CFT120                                                  CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRtCd                                        CFT120
     C                   PARM      '*VERIFY'     POptn                                        CFT120
     C                   PARM      'CFT120'      PSard                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   EVAL      *IN66 = *OFF                                               CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   EVAL      *IN66 = *ON                                                CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd <> '*NRF'                                            CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 004                                                CFT120
     C                   EVAL      DBKEY = '*VERIFY'                                          CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
     C                   EVAL      ModuleID     = 'FT'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C/COPY WNCPYSRC,FTH00480
      *
      ** Message subfile control and program queue initialisation
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           DDPGMQ
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
(c) Misys International Banking Systems Ltd. 2001
** WZ0
000000000000000000000000000000000000000000000000000000000000
**  DESC
Miscellaneous Charge 1                                                    CFT009
Miscellaneous Charge 2                                                    CFT009
Miscellaneous Charge 3                                                    CFT009
Miscellaneous Charge 4                                                    CFT009
Miscellaneous Charge 5                                                    CFT009
