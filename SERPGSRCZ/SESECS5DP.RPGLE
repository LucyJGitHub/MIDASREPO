     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities maintenance screen 5 display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS5DP - Securities Maintenance Screen 5 Display          *
      *                                                               *
      *  Function:  This module displays the Securities Maintenance   *
      *             Screen 5 Details.                                 *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESECS5DF CF   E             WORKSTN
      ** Securities Maintenance Screen 5 Display File
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Midas ZA Sequence Numbers for Input Fields
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Invalid Credit Risk Spread                      *
      *    02         Invalid Liquidity Premium                       *
      *                                                               *
      *    61         Hedge Accounting Phase B Indicator              *
      *                                                               *
      *    71         Interest-Bearing Security Indicator             *
      *    72         Complete Security Indicator                     *
      *    73         Edit Indicator                                  *
      *                                                               *
      *    81         F05 Enable - Refresh                            *
      *    82         F06 Enable - Read Previous                      *
      *    83         F07 Enable - Read Next                          *
      *    84         F08 Enable - Initial Screen                     *
      *    85         F12 Enable - Cancel                             *
      *    86         F15 Enable - Select                             *
      *                                                               *
      *    91         Subfile Control                                 *
      *    92         Subfile End                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the Copyright Array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for Error
      ** and Warning Message Arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the Message Handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line declares the arrays for processing
      ** that takes place in the *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Securities Screen 1 Details From Incoming Transaction
      ** - Screen Format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(S:2)
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)
     D                                     PREFIX(S:2)
 
      ** Securities Details Retrieved From File - File Format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
 
      ** PARM Investment Type Details Data Structure
     D PInvTypDet    E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
 
      ** AO Investment Type Details Data Structure
     D SDINVT        E DS                  EXTNAME(INVTPD) PREFIX(SE)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Display-Only Details Data Structure
     D PDspDet         DS
     D  SCSNM1                       10A
     D  SCSNM2                       10A
     D  SCSNM3                       10A
     D  SMKTN                        20A
     D  SSTBS                         1A
 
      ** Securities Details Screen 2 Error Indicators
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)
 
      ** Error Indicators Array
     D WEI             S              1A   DIM(%LEN(SEESEC5))
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S             10A
     D PEdtInd         S              1A
     D PWrOInd         S              1A
     D PEInKE          S              1A
     D PEInKF          S              1A
     D PEInKG          S              1A
     D PEInKH          S              1A
     D PEInKL          S              1A
     D PEInKP          S              1A
     D BJMRDT          S              7A
     D PInKC           S              1A
     D PInKE           S              1A
     D PInKF           S              1A
     D PInKG           S              1A
     D PInKH           S              1A
     D PInKL           S              1A
     D PInKP           S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PInvTyp         S              3A
     D PCcy            S              3A
 
      ** Switchable Features
     D CAS006          S              1A
 
      ** Working Variables
     D WLimit          S              3P 0
     D WIdx            S              3P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRInit
 
     C                   EXSR      SRMain
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main processing.                            *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Derive the Trade Basis if it is currently unknown.
 
     C                   IF        SSTBS = *BLANK
 
      ** Access Investment Type Details.
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      SSITP         PInvTyp
     C                   PARM      SNMCY         PCcy
     C     SDINVT        PARM      SDINVT        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      SSTBS = SETRBS
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'INVTPD'
     C                   EVAL      DBKey = SSITP + SNMCY
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Move all relevant 'OK' flags into the Error Indicators Array.
 
     C                   MOVEA     SEESEC5       WEI
 
      ** Set the Error Indicators depending upon the 'OK' flags.
 
     C                   EVAL      WLimit = %LEN(SEESEC5)
 
     C                   FOR       WIdx = 1 TO WLimit
 
     C                   IF        WEI(WIdx) = 'N' OR
     C                             WEI(WIdx) = 'W'
     C                   EVAL      *IN(WIdx) = *ON
     C                   ENDIF
 
     C                   ENDFOR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for Error and
      ** Warning Messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Disable the detail fields if necessary.
 
     C                   IF        PEdtInd = 'Y'
     C                   EVAL      *IN73 = *OFF
     C                   ELSE
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
 
      ** Enable F05 (Refresh).
 
     C                   IF        PEInKE = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   ENDIF
 
      ** Enable F06 (Initial Screen).
 
     C                   IF        PEInKF = 'Y'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
 
      ** Enable F07 (Read Previous Record).
 
     C                   IF        PEInKG = 'Y'
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
 
      ** Enable F08 (Read Next Record).
 
     C                   IF        PEInKH = 'Y'
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
 
      ** Enable F12 (Cancel).
 
     C                   IF        PEInKL = 'Y'
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
 
      ** Enable F15 (Select).
 
     C                   IF        PEInKP = 'Y'
     C                   EVAL      *IN86 = *ON
     C                   ENDIF
 
      ** Determine if the Security is Interest-Bearing.
 
     C                   IF        (SSTBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (SSTBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
 
      ** Return to the calling program if CAS006 is not enabled or the
      ** Security is not Interest-Bearing.
 
     C                   IF        CAS006 <> 'Y' OR
     C                             *IN71 = *OFF
     C                   RETURN
     C                   ENDIF
 
      ** If Incomplete Indicator = 'C', protect the fields that are
      ** not amendable when the Security is complete.
 
     C                   IF        SACTN <> 'I' AND
     C                             INCS = 'C'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
 
      ** Display the Coupon Rate Credit Risk Spread and the Coupon Rate
      ** Liquidity Premium screen fields if CAS006 is enabled and the
      ** Security is Interest-Bearing.
 
     C                   IF        CAS006 = 'Y' AND
     C                             *IN71 = *ON
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
 
      ** Write the Message Subfile, Details, and Footer Screens.
 
     C                   TIME                    STIME
     C                   WRITE     SESECSD1
     C                   WRITE     SESECSC1
     C                   WRITE     SESECSF1
 
      ** If Write Only Indicator <> 'Y', read the details screen.
 
     C                   IF        PWrOInd <> 'Y'
     C                   READ      SESECSD1
     C                   ENDIF
 
      ** Clear the Message Subfile.
 
     C                   CALL      'ZA0250'
 
      ** Reset all Error Indicators.
 
     C                   FOR       WIdx = 1 TO WLimit
     C                   EVAL      *IN(WIdx) = *OFF
     C                   ENDFOR
 
      ** Set the Return Keys.
 
     C                   EVAL      PInKC = *INKC
     C                   EVAL      PInKE = *INKE
     C                   EVAL      PInKF = *INKF
     C                   EVAL      PInKG = *INKG
     C                   EVAL      PInKH = *INKH
     C                   EVAL      PInKL = *INKL
     C                   EVAL      PInKP = *INKP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Handles initial processing.                         *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Reset all relevant indicators.
 
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN72 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *OFF
     C                   EVAL      *IN83 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      *IN86 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Begin Parameter List
      ** ====================
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    PRetCde
 
      ** Securities Screen 1 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE1ScnFmt
 
      ** Securities Screen 5 Details From Incoming Transaction
      ** - Screen Format
     C                   PARM                    NwSE5ScnFmt
 
      ** Securities Details Retrieved From File - File Format
     C                   PARM                    CrSEFilFmt
 
      ** Investment Type Details
     C                   PARM                    PInvTypDet
 
      ** Display-Only Details
     C                   PARM                    PDspDet
 
      ** Edit Indicator
     C                   PARM                    PEdtInd
 
      ** Function Key Indicators:
 
      ** KE (F05) = Refresh
      ** KF (F06) = Initial Screen
      ** KG (F07) = Read Previous
      ** KH (F08) = Read Next
      ** KL (F12) = Cancel
      ** KP (F15) = Browse
     C                   PARM                    PEInKE
     C                   PARM                    PEInKF
     C                   PARM                    PEInKG
     C                   PARM                    PEInKH
     C                   PARM                    PEInKL
     C                   PARM                    PEInKP
 
      ** Securities Screen 5 Error Indicators
     C                   PARM                    SEESEC5
 
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Write Only Indicator
     C                   PARM                    PWrOInd
 
      ** Standing Data:
 
      ** System Run Date
     C                   PARM                    BJMRDT
 
      ** Switchable Features:
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
 
      ** Output Parameters
      ** =================
 
      ** KC (F03) = Exit
      ** KE (F05) = Refresh
      ** KF (F06) = Initial Screen
      ** KG (F07) = Read Previous
      ** KH (F08) = Read Next
      ** KL (F12) = Cancel
      ** KP (F15) = Browse
     C                   PARM                    PInKC
     C                   PARM                    PInKE
     C                   PARM                    PInKF
     C                   PARM                    PInKG
     C                   PARM                    PInKH
     C                   PARM                    PInKL
     C                   PARM                    PInKP
 
      ** End Parameter List
      ** ==================
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
      ** Set the Message Handler parameters.
 
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the primary and secondary Message Files for searching
      ** Message IDs.
 
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Set the Message Subfile Control Indicators and Program
      ** Message Queue.
 
     C                   EVAL      *IN91 = *ON
     C                   EVAL      *IN92 = *ON
     C                   EVAL      SPGMQ = '*'
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Error-Handling Routines              ¦
      ** ¦ =======================              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the *PSSR subroutine.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2003
