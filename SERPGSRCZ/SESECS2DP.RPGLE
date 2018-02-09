     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities maintenance screen 2 display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS2DP - Securities Maintenance Screen 2 Display          *
      *                                                               *
      *  Function:  This module displays the Securities Maintenance   *
      *             screen 2 details.                                 *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 226777             Date 03May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205427             Date 02May02               *
      *                 CSE031             Date 12Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  226777 - Display current factor field for processing type 8. *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  205427 - Addition to CSE032 changes. Allow Yield Basis to be *
      *           initialised if now required on setting on feature.  *
      *           Recompile over changed SESECS2DF.                   *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities Maintenance Screen 2 display file
     FSESECS2DF CF   E             WORKSTN
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
     FINVTPC    IF   E           K DISK    INFSR(*PSSR)                                       CSE037
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  1-64      Field Error - highlight screen fields              *
      *  65        Last Coupon date is in error                       *                       CSE031
      *  66        Interest bearing security                          *
      *  67        Processing type 4 and 7                            *
      *  68        Trade basis is 'D' or 'Y' and PROT is 9            *
      *  69        Security is complete                               *
      *  70        Protect details fields                             *
      *  71        Enable CF05 - Refresh                              *
      *  72        Enable CF07 - Read Previous Record                 *
      *  73        Enable CF08 - Read Next Record                     *
      *  74        Enable CF06 - Return to initial screen             *
      *  75        Enable CF15 - Select Record                        *
      *  76        Enable CF12 - Cancel                               *
      *  78        Error on Field Fixing Days                         *                       CSE031
      *  79        Error on Field Auto Fix                            *                       CSE031
      *  80        Processing type 9                                  *
      *  81        Risk Management indicator is 'Y'                   *
      *  82        Processing type 3 and CSE005 is present            *
      *  83        Early repayment indicator is 'Y'                   *
      *  84        Processing type 3, 5 or 8                          *
      *  85        CSE007 and CEU017 is present                       *
      *  86        Maturity date indicator is 'F'                     *
      *  87        Protect maturity date                              *
      *  88        Action code is Insert                              *
      *  89        Processing type 2, 4 or 7                          *
      *  90        One of the coupon date is in error                 *
      *  91        Next Coupon date is in error                       *                       CSE031
      *  92        Australian yield basis                             *
      *  93        Partly-Paid security                               *
      *  94        Trade basis is 'D' and security is complete        *
      *  95        Countervalue rounding is switched on               *                       CSE037
      *  96        Subfile control                                    *
      *  97        Subfile end                                        *
      *  98        Round to Decimal Places is in error                *                       CSE037
      *  99        End of File indicator                              *
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
      ** Arrays for screen error indicators
     D WZ0             S              1    DIM(64) CTDATA PERRCD(64)
     D*WEI*************S              1    DIM(64)                                            CSE031
     D*WEI*************S              1    DIM(68)                                            CSE031
     D WEI             S              1    DIM(69)                                            CSE037
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(S:2)
      *
      ** Security screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(S:2)
      *
      ** Security retrieved from file - file file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Investment Types files
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** Security details screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** DS of fields for output only
     D POutFlds        DS
     D  SCSNM1                       10A
     D  SCSNM2                       10A
     D  SCSNM3                       10A
     D  SMKTN                        20A
     D  SSTBS                         1A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Entry parameters definition
     D PEDtFld         S              1A
     D PLCPN           S              6A
     D PNCD            S              6A
     D PEINKE          S              1A
     D PEINKF          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKI          S              1A                                                      CSE031
     D PEINKL          S              1A
     D PEINKP          S              1A
     D BJMRDT          S              7A
     D BGRKMG          S              1A
     D CSE005          S              1A
     D CSE007          S              1A
     D CEU017          S              1A
     D CSE031          S              1A                                                      CSE031
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKF           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKI           S              1A                                                      CSE031
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
      *                                                                                       226777
      ** Parameter list for ZA0921                                                            226777
     D PAmountIn       S             15P 0                                                    226777
     D PNDCP           S              1P 0                                                    226777
     D PDCSP           S              1A                                                      226777
     D PAmountOutP     S             16A                                                      226777
     D PAmountOutD     S             17A                                                      226777
      *                                                                                       CSE037
      * Countervalue rounding                                                                 CSE037
     D CSE037          S              1A                                                      CSE037
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
     C                   EXSR      SRMainP
      *
      ** Return.
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainP - Main processing                                    *
      *                                                               *
      *****************************************************************
     C     SRMainP       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MOVEA     SEESEC2       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-ADD     1             Cx
     C                   Z-ADD     1             Ex
      *
     C                   DOU       Cx > 64
      *
     C                   IF        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   EVAL      *IN(Ex) = *ON
     C                   ENDIF
      *
     C                   EVAL      Cx = Cx + 1
     C                   EVAL      Ex = Ex + 1
     C                   ENDDO
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Reset work indicators.
     C                   MOVEA     '0000'        *IN(66)
     C                   MOVEA     '1000000000'  *IN(70)
     C                   MOVEA     '0000000000'  *IN(80)
     C*********          MOVEA     '11000'       *IN(90)                                      CSE031
     C                   MOVEA     '10000'       *IN(90)                                      CSE031
      *                                                                                       CSE031
      ** SAR CSE031 is switched ON.                                                           CSE031
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
      *                                                                                       CSE031
     C                   EVAL      *IN65 = *OFF                                               CSE031
     C                   EVAL      *IN91 = *OFF                                               CSE031
      *                                                                                       CSE031
     C                   IF        WEI(65) = 'N'                                              CSE031
     C                   EVAL      *IN(65) = *ON                                Last Coupon   CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        WEI(66) = 'N'                                              CSE031
     C                   EVAL      *IN(91) = *ON                                Next Coupon   CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        WEI(67) = 'N'                                              CSE031
     C                   EVAL      *IN(78) = *ON                                Fixing Days   CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        WEI(68) = 'N'                                              CSE031
     C                   EVAL      *IN(79) = *ON                                Auto Fix      CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Disable detail fields.
     C                   IF        PEDtFld = 'Y'
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
      *
      ** Enable CF05 (Refresh).
     C                   IF        PEINKE = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
      ** Enable CF06 (Init Scrn).
     C                   IF        PEINKF = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
      ** Enable CF07 (Read Previous Record).
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
      ** Enable CF08 (Read Next Record).
     C                   IF        PEINKH = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *                                                                                       CSE031
      ** Enable CF09 (Additional Information) if CSE031 is switched ON.                       CSE031
     C                   IF        CSE031 = 'Y' AND PEINKI = 'Y'                              CSE031
     C                   EVAL      *IN77 = *ON                                                CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Enable CF12 (Cancel).
     C                   IF        PEINKL = 'Y'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
      *
      ** Enable CF15 (Browse screen).
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *
      ** Display fields for interest bearing security.
     C                   IF        (SSTBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (SSTBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
     C                   EVAL      *IN66 = *ON
     C                   ENDIF
 
     C                   IF        PPROT = '4' OR PPROT = '7'
     C                   EVAL      *IN67 = *ON
     C                   ENDIF
      *                                                                                       CSE031
      ** Display the 'Fixing Days and Auto Fix' field if the                                  CSE031
      ** processing type is equal to 3 or 8.                                                  CSE031
      ** Also make the Last and Next Coupon Date amendable.                                   CSE031
     C                   IF        CSE031= 'Y'                                                CSE031
      *                                                                                       CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
     C                   EVAL      *IN26 = *ON                                                CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      *IN26 = *OFF                                               CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *
      ** If Trade basis equal to 'D' or 'Y' and processing type is 9,
      ** set on indicator 68.
     C                   IF        SACTN = 'I'
     C                   IF        SSTBS = 'D' OR
     C                             (SSTBS = 'Y' AND PPROT = '9')
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
     C                   ELSE
     C                   IF        STBS = 'D' OR
     C                             (STBS = 'Y' AND PPROT = '9')
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
     C                   ENDIF
      *
      ** If incomplete indicator is 'C', set on 69 to protect fields
      ** that are not to be amended when security is complete.
     C                   IF        SACTN <> 'I' AND INCS = 'C'
     C                   EVAL      *IN69 = *ON
     C                   ENDIF
 
     C                   IF        PPROT = '9'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      ** Test to see if Early Redemption is allowed and if Risk
      ** Management indicator is on.
     C                   IF        BGRKMG = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   IF        SERPY = 'Y'
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PPROT = '3' OR PPROT = '5' OR
     C                             PPROT = '8'
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
      *
      ** SAR CSE007 and CEU017 is switched on.
     C                   IF        CSE007 = 'Y' OR CEU017 = 'Y'
     C/COPY WNCPYSRC,SESEC2XC01
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
      *
      ** If security complete and maturity date ind is 'F' then protect
      ** maturity date field and indicator.
     C                   IF        SACTN = 'A' AND SINCS = 'C' AND
     C                             MDTI = 'F'
     C                   EVAL      *IN86 = *ON
     C                   ENDIF
 
     C                   IF        CSE007 = 'N' AND CEU017 = 'N'
     C/COPY WNCPYSRC,SESEC2XC02
      *
      ** If security complete and maturity date not equal 999999
      ** then protect maturity date field.
     C                   IF        SACTN = 'A' AND INCS = 'C' AND
     C                             MATY <> 99999 AND PPROT <> '9'
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
 
     C                   ELSE
      *
      ** If security complete and trade type not = 'P'
      ** then protect maturity date field.
     C                   IF        SACTN = 'A' AND STBS <> 'P'
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        SACTN = 'I'
     C                   EVAL      *IN88 = *ON
     C                   ENDIF
 
     C                   IF        PPROT = '2' OR PPROT = '4' OR
     C                             PPROT = '7'
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
 
     C**********         IF        PPROT = '3' AND CSE005 = 'Y'                               CSE031
     C                   IF        PPROT = '3' AND CSE005 = 'Y' OR                            CSE031
     C                             PPROT = '8' AND CSE005 = 'Y' AND                           CSE031
     C                             CSE031 = 'Y'                                               CSE031
     C                   EVAL      *IN82 = *ON
 
     C                   IF        SACTN <> 'I'
      *
      ** If not insert and one of the coupon dates is error then do not
      ** display last coupon date.
     C                   IF        *IN28 = *OFF AND *IN30 = *OFF AND
     C                             *IN32 = *OFF AND *IN34 = *OFF AND
     C                             *IN36 = *OFF AND *IN38 = *OFF AND
     C                             *IN40 = *OFF AND *IN42 = *OFF AND
     C                             *IN44 = *OFF AND *IN46 = *OFF AND
     C                             *IN48 = *OFF AND *IN50 = *OFF
     C                   EVAL      *IN90 = *OFF
     C                   ELSE
     C                   EVAL      *IN90 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** Australian yield basis
     C                   IF        SSYBS = 'AU'
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
      *
      ** Partly Paid indicator
     C                   IF        SPPDI = 'Y'
     C                   EVAL      *IN93 = *ON
     C                   ENDIF
 
     C                   IF        *IN68 AND *IN69
     C                   EVAL      *IN94 = *ON
     C                   ENDIF
      *                                                                                       CSE031
     C                   IF        CSE031 <> 'Y' OR                                           CSE031
     C                             CSE031 = 'Y' AND PPROT <> '3' AND                          CSE031
     C                             PPROT <> '8'                                               CSE031
      *
      ** Next Coupon Date
     C                   EVAL      SNCD = PNCD
      *
      ** Last Coupon Date
     C                   EVAL      SLCPN = PLCPN
     C                   ENDIF                                                                CSE031
                                                                                              CSE037
      ** Countervalue rounding is switched on                                                 CSE037
     C                   IF        CSE037 = 'Y'                                               CSE037
      *                                                                                       CSE037
      ** check investment type 'prompt at security level' flag                                CSE037
     C                   IF        PSFLG = 'Y'                                                CSE037
     C                   EVAL      *IN95 = *ON                                                CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE037
     C                   IF        WEI(69) = 'N'                                              CSE037
     C                   EVAL      *IN(98) = *ON                                Rounding      CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       CSE037
     C                   ENDIF                                                                CSE037
      *                                                                                       226777
      ** If processing type is 8, display Current Factor field                                226777
      *                                                                                       226777
     C                   IF        PPROT = '8' AND                                            226777
     C                             SACTN <> 'I'                                               226777
                                                                                              226777
     C                   Z-ADD     *ZERO         PAmountIn                                    226777
     C                   MOVE      CFCT          PAmountIn                                    226777
                                                                                              226777
     C                   CALLB     'ZA0921'                                                   226777
     C                   PARM      *BLANK        RetCodeOut                                   226777
     C                   PARM                    PAmountIn                                    226777
     C                   PARM      9             PNDCP                                        226777
     C                   PARM      '.'           PDCSP                                        226777
     C                   PARM      *BLANK        PAmountOutP                                  226777
     C                   PARM      *BLANK        PAmountOutD                                  226777
     C                   MOVE      PAmountOutP   SCFCT                                        226777
                                                                                              226777
     C                   EVAL      *IN95 = *ON                                                226777
                                                                                              226777
     C                   ELSE                                                                 226777
     C                   EVAL      *IN95 = *OFF                                               226777
     C                   ENDIF                                                                226777
      *
      ** Write message subfile, details and footer screens.
     C                   TIME                    STIME
     C                   WRITE     SESECSD1
     C                   WRITE     SESECSC1
     C                   WRITE     SESECSF1
      *
      ** If not Write Only, read details screen.
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SESECSD1                               01
     C                   ENDIF
      *
      ** Clear message subfile.
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
     C                   MOVEA     WZ0           *IN(1)
      *
      ** Set return keys.
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKE = *INKE
     C                   EVAL      PINKF = *INKF
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
     C                   EVAL      PINKI = *INKI                                              CSE031
 
     C                   ENDSR
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Security 2nd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security retrieved from file - file file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Fields for display only
     C                   PARM                    POutFlds
      *
      ** Last Coupon Date
     C                   PARM                    PLCPN
      *
      ** Next Coupon Date
     C                   PARM                    PNCD
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDtFld
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
     C                   PARM                    PEINKI                                       CSE031
      *
      ** Security 2nd screen error indicators
     C                   PARM                    SEESEC2
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
     C                   PARM                    WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Risk Manangement
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on frn cpuon dates
     C                   PARM                    CSE005
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KF = Command Key 06 = Initial Screen
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKI                                        CSE031
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           SPGMQ
     C/COPY WNCPYSRC,SESEC2XC03
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
**  WZ0
0000000000000000000000000000000000000000000000000000000000000000
