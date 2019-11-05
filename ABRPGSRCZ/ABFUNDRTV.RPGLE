     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal funding deals rtrve+act/key VAL')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDRTV - Internal Funding Deals Retrieve and Action/Key   *
      *              Validation                                       *
      *                                                               *
      *  Function:  This module retrieves an internal funding deal    *
      *             the midas database.  As it does, it validates the *
      *             action code and deal numbers.  This module also   *
      *             initialize the file-update fields.                *
      *                                                               *
      *  Component of: ABFUNDSIN - Internal Funding Deals Maintenance *
      *                ABFUNDRPR - Internal Funding Deals Repair      *
      *                ABFUNDCTL - Internal Funding Deals Interface   *
      *                            Controller                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *      
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 09May13               *
      *                 AR996631           Date 28Jun12               *
      *                 CRE073             Date 06Dec10               *
      *                 259924A            Date 29Jun09               *
      *                 259924             Date 29Jun09               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24158           Date 01Jun09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 239394             Date 08Mar07               *
      *                 237063             Date 20Nov05               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8259            Date 26Aug05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL019             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195003             Date 21Aug01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *      
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  AR996631 - System should not validate deal number range      *
      *             in PEA system                                     *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  259924A- Amended so that system will validate front office   *
      *           ID that came from Meridian.                         *
      *  259924 - Amended so that program will check front office ID  *
      *           in all deals.                                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG24158 - Clear WkDlAso field when DDDADN is blanks to      *
      *             prevent the record from being tagged as updated   *
      *             by another workstation.                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  239394 - Deposit and loan deal numbers should not be the same*
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8259- Serious Midas Error occurred (Recompile)            *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *           ,MMDELDPP .                                         *
      *  195003 - Second leg of deal is not deleted.                  *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Indicator for READ  operation                   *
      *    02         Indicator for CHAIN operation                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit   - Initialization                                    *
      *  SRVFrnt  - Validation for front office transaction interface *
      *  SRVal    - Validation of action code and deal number         *
      *  SRValAcE - Validation of action code 'E'                     *
      *  SRValAcI - Validation of action code 'I'                     *
      *  SRValAcA - Validation of action code 'A'                     *
      *  SRValAcD - Validation of action code 'D'                     *
      *  SRValADn - Validate Associated Deal Number                   *
      *  SRRtvDl  - Retrieve deal from file                           *
      *  SRAcsSec - Access security checking                          *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Internal Funding Deals by Deal number
     FABFUNDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Internal Funding Deals by Front Office ID
     FABFUNDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:MMDELFOI)
 
      ** All Deals File including Historic
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FXDEALP0:FXDLALL)
     F                                     RENAME(MMDELDP0:MMDELALL)
     F                                     RENAME(MMDENSP0:MMDESALL)
     F                                     RENAME(MMDENBP0:MMDEBALL)
 
      ** Deal Amendments
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
 
      ** Deal Number Ranges
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FFRNTOFCL1 IF   E           K DISK    INFSR(*PSSR)                                       259924
     F                                     RENAME(MMDELDP0:MMDELDX0)                          259924
     F                                     RENAME(MMDENBP0:MMDENBX0)                          259924
     F                                     RENAME(MMDENSP0:MMDENSX0)                          259924
     F                                     RENAME(ABDEALP0:ABDEALX0)                          259924
     F                                     RENAME(FXDEALP0:FXDEALX0)                          259924
     F                                     RENAME(DEALSDGF:DEALSGX0)                          259924
 
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
 
      ** External DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                            AR996631
      ** Externally described DS for SAR details                                            AR996631
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR996631
 
      ** Current Deal in File Format of main deal
     D CrDlFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  QQDoriD1     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD1     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD1     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD1     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD1     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD1     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD1     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D CrDlFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D  QQDoriD2     E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMoriD2     E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDopiD2     E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMopiD2     E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRonsD2     E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPonsD2     E                     EXTFLD(QQPONS)                                     CGL029
     D  QQInsaD2     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Deal File Format of MMDELDPP
     D DlFilFmt      E DS                  EXTNAME(MMDELDPP)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  RecNotFnd             02     02
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D KDlAmd          S              6  0
     D KAmdSeqN        S              3  0
 
     D PModeOfOp       S              6A
     D PRespMode       S              1A
     D DDACTN          S              1A
     D DDDLNO          S              6A
     D DDDADN          S              6A
     D DDBRC1          S              3A
     D DDBRC2          S              3A
     D FOTRID          S             20A
     D FOASID          S             20A
     D OKACTN          S              1A
     D OKDLNO          S              1A
     D OKBRC1          S              1A
     D OKBRC2          S              1A
     D PBRCD1          S              3A
     D PBRCD2          S              3A
     D PDsnB           S              3A
     D PErr            S              1  0
     D PErr2           S              1  0
     D PBJSBRC         S              3A
     D PBRC            S              3A
     D PBKOBUV         S              1A
     D PLnkFlag        S              1A
     D PSARD           S              6A                                                    AR996631
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
     D WkDlNum         S              6  0
     D WkDlAso         S              6  0                                                    239394
     D WkDlNumA        S              6  0
     D WkDlno          S              6A
     D WkRDlNum        S              6  0
     D WChkDlTyp       S              1A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D PSysVal1        C                   CONST('PEAIndicator')                            AR996631
     D PRetCode        S              7A                                                    AR996631
     D P@OP01          S             20A                                                    AR996631
     D P@VL01          S            200A                                                    AR996631
     D P@OP02          S             20A                                                    AR996631
     D P@VL02          S            200A                                                    AR996631
     D P@OP03          S             20A                                                    AR996631
     D P@VL03          S            200A                                                    AR996631
     D P@OP04          S             20A                                                    AR996631
     D P@VL04          S            200A                                                    AR996631
     D P@OP05          S             20A                                                    AR996631
     D P@VL05          S            200A                                                    AR996631
     D P@OP06          S             20A                                                    AR996631
     D P@VL06          S            200A                                                    AR996631
     D P@OP07          S             20A                                                    AR996631
     D P@VL07          S            200A                                                    AR996631
     D P@OP08          S             20A                                                    AR996631
     D P@VL08          S            200A                                                    AR996631
     D P@OP09          S             20A                                                    AR996631
     D P@VL09          S            200A                                                    AR996631
     D P@OP10          S             20A                                                    AR996631
     D P@VL10          S            200A                                                    AR996631
     D WPEAInd         S              1A                                                    AR996631
     D CSC054          S              1A                                                    AR996631
                                                                                            MD000091
      *                                                                                     MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (extra) validation for Front Office Transaction Interface
 
     C*********          IF        PModeOfOp = '*FRONT'                                      259924A
     C                   IF        PModeOfOp = '*FRONT' OR                                   259924A
     C                             PModeOfOp = '*SIN' AND DDACTN  = 'I' AND                  259924A
     C                             FOTRID <> ' '                                             259924A
     C                   EXSR      SRVFrnt
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR OKDLNO = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate action code & deal number
 
     C                   EXSR      SRVal
 
      **-------------------------------------------------------------*
      ** Validate if Associated deal no exist in file for non-insert *
      **-------------------------------------------------------------*
 
     C                   IF        OKACTN = 'Y' AND OKDLNO = 'Y' AND
     C                             DDACTN <> 'I'
     C                   EXSR      SRValADn
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR OKDLNO = 'N'
     C                   RETURN
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'I' *
      **--------------------------------*
 
      ** (only if the deal no. is not to be generated.)
 
     C                   IF        DDACTN = 'I' AND DDDLNO <> *BLANK
     C                   EXSR      SRValAcI
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'A' *
      **--------------------------------*
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      SRValAcA
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'D' *
      **--------------------------------*
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      SRValAcD
     C                   ENDIF
 
      ** Carry out no further validation if errors occurred.
 
     C                   IF        OKACTN = 'N' OR OKDLNO = 'N'
     C                   RETURN
     C                   ENDIF
 
      **-----------------------------------------------*
      ** Access Security Checking                      *
      **-----------------------------------------------*
 
     C                   IF        PRespMode = 'S' AND PLnkFlag <> 'Y'
     C                   EXSR      SRAcsSec
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      * SRVFrnt - Validation for Front Office Transaction Interface
      *****************************************************************
     C     SRVFrnt       BEGSR
 
      ** Error if action code is not 'I', 'A', 'D', or 'E'
 
     C                   IF        DDACTN <> 'I' AND DDACTN <> 'A' AND
     C                             DDACTN <> 'D' AND DDACTN <> 'E'
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'APM0111'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'APM0101'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access deal with Front Office Transaction ID
 
     C*****FOTRID        CHAIN     ABFUNDL1                           02                      259924
     C     FOTRID        CHAIN     FRNTOFCL1                          02                      259924
 
      ** If insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be present already
 
     C                   IF        RecNotFnd = False
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'APM0102'
     C**********         EVAL      MsgDtaArr(Ix) = FOTRID                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID must be present
 
     C                   IF        RecNotFnd = True
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'APM0103'
     C**********         EVAL      MsgDtaArr(Ix) = FOTRID                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** If not insert, update Midas deal number
 
     C                   MOVE      HKDN38        DDDLNO
     C                   MOVE      HKDADN        DDDADN                                       195003
 
     C                   ENDIF
 
      ** If Front Office Associated Transaction ID is not blank
 
     C                   IF        FOASID <> *BLANK
 
      ** Error if deal not found
 
     C     FOASID        CHAIN     ABFUNDL1                           02
     C                   IF        RecNotFnd = True
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'APM0104'
     C**********         EVAL      MsgDtaArr(Ix) = FOASID                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Update Midas associated deal number
 
     C                   MOVE      HKDN38        DDDADN
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVal - Validation of action code and deal number
      *****************************************************************
     C     SRVal         BEGSR
 
      ** Check that the action code is valid
 
     C                   IF        DDACTN = *BLANK
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
 
     C                   IF        DDACTN <> *BLANK AND DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND DDACTN <> 'D' AND
     C                             DDACTN <> 'E'
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'ABM0016'
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** If the deal number is not blank, check that it is numeric.
 
     C                   IF        DDDLNO <> *BLANKS
 
     C                   MOVE      *Blanks       PZField
     C                   MOVE      DDDLNO        PZField
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'N'
 
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0162'
     C                   GOTO      EVAL
     C                   ELSE
 
      ** Set up the deal number as a numeric field.
 
     C                   MOVE      PZField       DDDLNO
     C                   MOVE      PZField       WkDlNum
 
     C                   ENDIF
 
     C                   ENDIF
 
                                                                                              239394
      ** If the deal number is not blank, check that it is numeric.                           239394
                                                                                              239394
     C                   IF        DDDADN <> *BLANKS                                          239394
                                                                                              239394
     C                   MOVE      *Blanks       PZField                                      239394
     C                   MOVE      DDDADN        PZField                                      239394
     C                   Z-ADD     0             PZADEC                                       239394
     C                   Z-ADD     6             PZADIG                                       239394
     C                   EXSR      SRZAlign                                                   239394
                                                                                              239394
     C                   IF        PZAlignOk = 'N'                                            239394
                                                                                              239394
     C                   EVAL      OKDLNO = 'N'                                               239394
     C                   EVAL      Ix = Ix + 1                                                239394
     C                   EVAL      FldNameArr(Ix) = '#1DADN'                                  239394
     C                   EVAL      MsgIdArr(Ix) = 'MMM0162'                                   239394
     C                   GOTO      EVAL                                                       239394
     C                   ELSE                                                                 239394
                                                                                              239394
      ** Set up the deal number as a numeric field.                                           239394
                                                                                              239394
     C                   MOVE      PZField       DDDADN                                       239394
     C                   MOVE      PZField       WkDlAso                                      239394
                                                                                              239394
     C                   ENDIF                                                                239394
                                                                                              239394
     C                   ELSE                                                               BUG24158
     C                   CLEAR                   WkDlAso                                    BUG24158
                                                                                            BUG24158
     C                   ENDIF                                                                239394
                                                                                              239394
      ** Check if deal number for loan and deposit are the same.                              239394
                                                                                              239394
     C                   IF        WkDlAso <> 0 and WkDlNum <> 0                              239394
     C                             and WkDlAso = WkDlNum                                      239394
     C                   EVAL      OKDLNO = 'N'                                               239394
     C                   EVAL      Ix = Ix + 1                                                239394
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'                                  239394
     C                   EVAL      MsgIdArr(Ix) = 'MMM9204'                                   239394
     C                   ENDIF                                                                239394
                                                                                              239394
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValAcI - Validation of action code 'I'
      *****************************************************************
     C     SRValAcI      BEGSR
 
      ** Check that the deal does not exist on any Deals File
      ** Midas or DRS. If it does it's an error.
 
     C     WkDlNum       CHAIN     DEALSALL                           02
     C                   IF        RecNotFnd = False
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0163'
     C                   GOTO      EVALAI
     C                   ENDIF
 
     C                   IF        WPEAInd <> 'Y'                                           AR996631
      ** Check that the deal number is in the allowed range.
      ** (do not check if deal number generated through APIs)
 
     C                   IF        WkDlNum < NORDLN OR WkDlNum = 999999
     C                   IF        PModeOfOp =  '*SIN  ' OR
     C                             PModeOfOp =  '*RPR  '
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0164'
     C                   GOTO      EVALAI
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              AR996631
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValAcA - Validation of action code 'A'
      *****************************************************************
     C     SRValAcA      BEGSR
 
      ** Process for amend only.
 
     C                   IF        HKDDLT <> *BLANKS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0172'
     C                   GOTO      EVALAA
     C                   ENDIF
 
      ** If the record exists, its status must be C or A.
 
     C                   IF        HKDSTS <> 'C' AND HKDSTS <> 'A'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0166'
     C                   GOTO      EVALAA
     C                   ENDIF
 
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValAcD - Validation of action code 'D'
      *****************************************************************
     C     SRValAcD      BEGSR
 
     C                   IF        D1DDLT <> *BLANKS AND
     C                             D2DDLT <> *BLANKS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0172'
     C                   GOTO      EVALAD
     C                   ENDIF
 
      ** The deal status must be C or A.
 
     C                   IF        HKDSTS <> 'C' AND HKDSTS <> 'A'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0169'
     C                   GOTO      EVALAD
     C                   ENDIF
 
      ** Access the deal amendments file; if a live amendment exists
      ** for the deal, this is an error.
      ** Set the deam file pointer to be before any deam for the deal.
 
     C                   MOVE      DDDLNO        KDlAmd
     C                   EVAL      @YEAR  = *ZEROS
     C                   EVAL      @MNTH  = *ZEROS
     C                   EVAL      @DAY   = *ZEROS
     C                   EVAL      KAmdSeqN = *ZEROS
     C     KDlAmdKey     SETLL     MMLVDMLL
 
 
      ** Read through the deal amendments until one of the following
      ** conditions obtains...
      ** - the end of file has been reached.
      ** - the deal no. of the record found is not the same as that
      **   used in the access.
      ** - a valid deal amendment has been found; an error.
 
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C                   READ      MMLVDMLL                               01
     C                   MOVE      HNDA38        WkDlno
     C                   IF        DDDLNO = WkDlno
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0170'
     C                   GOTO      EVALAD
     C                   ELSE
     C                   EVAL      EndOfFile =True
     C                   ENDIF
     C                   ENDDO
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValADn - Validation of Associated deal no
      *****************************************************************
     C     SRValADn      BEGSR
 
      ** Retrieve deal
 
     C                   EXSR      SRRtvDl
 
      ** If the deal has been deleted, then it may not be amended.
 
     C                   IF        OKDLNO = 'N'
     C                   GOTO      EVLADN
     C                   ENDIF
 
      ** Move the main deal info to DlFilFmt1
 
     C                   EVAL      CrDlFilFmt1 = DlFilFmt
 
      ** Use the Associated deal no to chain to ABFUNDL0
 
     C                   MOVE      HKDADN        WkDlNumA
 
      ** If there is no valid record on ABFUNDL0, it is an error.
 
     C     WkDlNumA      CHAIN     ABFUNDL0                           02
 
      ** Check for a valid record.
 
     C                   IF        RecNotFnd = True OR HKDLTF <> *BLANKS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'ABM0125'
     C                   GOTO      EVLADN
     C                   ELSE
 
      ** If the deal status is not C,A, R or M, it is an error.
 
     C                   IF        HKDSTS <> 'C' AND HKDSTS <> 'A' AND
     C                             HKDSTS <> 'R' AND HKDSTS <> 'M'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0168'
     C                   GOTO      EVLADN
     C                   ENDIF
     C                   ENDIF
 
      ** Move the associated deal info to CrDlFilFmt2
 
     C                   EVAL      CrDlFilFmt2 = DlFilFmt
     C                   EVAL      DlFilFmt = CrDlFilFmt1
 
     C     EVLADN        ENDSR
      /EJECT
      *****************************************************************
      * SRRtvDl - Retrieve a deal from file
      *****************************************************************
     C     SRRtvdl       BEGSR
 
      ** If the deal number is blank, it is an error.
 
     C                   IF        DDDLNO = *BLANKS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0111'
     C                   GOTO      ERTVDL
     C                   ENDIF
 
      ** If there is no valid, undeleted record on ABFUNDL0, it is an
      ** error.
 
     C                   EVAL      WChkDlTyp = *BLANK
 
      ** If deal type not 'IL' get the associated deal number and make it
      ** the primary deal
 
     C                   DOU       WChkDlTyp = 'Y'
 
     C     WkDlNum       CHAIN     ABFUNDL0                           02
 
      ** Check for a valid record.
 
     C                   IF        RecNotFnd = True OR HKDLTF <> *BLANKS
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1DLNO'
     C                   EVAL      MsgIdArr(Ix) = 'ABM0125'
     C                   GOTO      ERTVDL
     C                   ENDIF
 
     C                   IF        HKMTYP = 'ID'
     C                   MOVE      HKDADN        WkDlNum
     C                   EVAL      DDDLNO = HKDADN
     C                   EVAL      WChkDlTyp = 'N'
     C                   ELSE
     C                   EVAL      WChkDlTyp = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C     ERTVDL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAcsSec - Access security checking
      *****************************************************************
     C     SRAcsSec      BEGSR
 
      ** If not multi-branching, check authority to only action code
 
     C                   IF        PBJSBRC <> *BLANK
 
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ActionCode
     C                   PARM      *ZERO         PErr
 
     C                   IF        PErr <> *ZERO
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'FXM0292'
     C                   GOTO      EACSSE
     C                   ENDIF
     C                   ENDIF
 
      ** If multi-branching, check authority to booking branch
 
     C                   IF        PBJSBRC = *BLANKS
 
     C                   IF        DDACTN = 'I'
 
     C                   IF        DDBRC1 = *BLANKS
     C                   EVAL      PBRCD1 = PBRC
     C                   EVAL      DDBRC1 = PBRC
     C                   ELSE
     C                   EVAL      PBRCD1 = DDBRC1
     C                   ENDIF
 
     C                   IF        DDBRC2 = *BLANKS
     C                   EVAL      PBRCD2 = PBRC
     C                   EVAL      DDBRC2 = PBRC
     C                   ELSE
     C                   EVAL      PBRCD2 = DDBRC2
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PBRCD1= D1BRCA
     C                   EVAL      PBRCD2= D2BRCA
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      PBRCD1        PDsnB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1BRC1'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0115'
     C                   GOTO      EACSSE
     C                   ELSE
     C                   EVAL      PBRCD1 = A8BRCD
     C                   EVAL      DDBRC1 = A8BRCD
     C                   ENDIF
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      PBRCD2        PDsnB
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      OKBRC2 = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1BRC2'
     C                   EVAL      MsgIdArr(Ix) = 'MMM0115'
     C                   GOTO      EACSSE
     C                   ELSE
     C                   EVAL      PBRCD2 = A8BRCD
     C                   EVAL      DDBRC2 = A8BRCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ActionCode
     C                   PARM                    PBRCD1
     C                   PARM      *ZERO         PErr
 
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ActionCode
     C                   PARM                    PBRCD2
     C                   PARM      *ZERO         PErr2
 
     C                   IF        PErr = 1 OR PErr2 = 1
     C                   EVAL      OKACTN = 'N'
 
      ** (If Insert then highlight branch field else deal number)
 
     C                   IF        DDACTN = 'I'
     C                   IF        PErr = 1
     C                   EVAL      OKBRC1 = 'N'
     C                   ENDIF
     C                   IF        PErr2 = 1
     C                   EVAL      OKBRC2 = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'FXM0290'
     C                   GOTO      EACSSE
     C                   ENDIF
 
     C                   IF        PErr = 2 OR PErr2 = 2
     C                   EVAL      OKACTN = 'N'
 
      ** (If Insert then highlight branch field else deal number)
 
     C                   IF        DDACTN = 'I'
     C                   IF        PErr = 2
     C                   EVAL      OKBRC1 = 'N'
     C                   ENDIF
     C                   IF        PErr2 = 2
     C                   EVAL      OKBRC2 = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      OKDLNO = 'N'
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'FXM0291'
     C                   GOTO      EACSSE
     C                   ENDIF
 
      ** Check authority to originating branch
 
     C                   IF        PBKOBUV = 'Y' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'I'
 
     C                   CALL      'ZVOBU'
     C                   PARM                    D1ORBR
     C                   PARM      *ZERO         PErr
 
     C                   CALL      'ZVOBU'
     C                   PARM                    D2ORBR
     C                   PARM      *ZERO         PErr2
 
     C                   IF        PErr = 1 OR PErr2 = 1
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'FXM0287'
     C                   GOTO      EACSSE
     C                   ENDIF
 
     C                   IF        PErr = 2 OR PErr2 = 2
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      OKDLNO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = '#1ACTN'
     C                   EVAL      MsgIdArr(Ix) = 'FXM0288'
     C                   GOTO      EACSSE
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     EACSSE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear outputs
 
     C                   CLEAR                   CrDlFilFmt1
     C                   Z-ADD     *ZEROS        D1DLUP
     C                   Z-ADD     *ZEROS        D1YLUP
     C                   Z-ADD     *ZEROS        D1TLUP
     C                   Z-ADD     *ZEROS        D1LCD
     C                   Z-ADD     *ZEROS        D1DN38
     C                   Z-ADD     *ZEROS        D1CYDP
     C                   Z-ADD     *ZEROS        D1VDYY
     C                   Z-ADD     *ZEROS        D1VDMM
     C                   Z-ADD     *ZEROS        D1VDDD
     C                   Z-ADD     *ZEROS        D1DTYY
     C                   Z-ADD     *ZEROS        D1DTMM
     C                   Z-ADD     *ZEROS        D1DTDD
     C**********         Z-ADD     *ZEROS        D1CNUM                                       CSD027
     C                   EVAL      D1CNUM = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D1AMNP
     C                   Z-ADD     *ZEROS        D1INTR
     C                   Z-ADD     *ZEROS        D1DDYY
     C                   Z-ADD     *ZEROS        D1DDMM
     C                   Z-ADD     *ZEROS        D1DDDD
     C                   Z-ADD     *ZEROS        D1BRKG
     C                   Z-ADD     *ZEROS        D1BCDP
     C                   Z-ADD     *ZEROS        D1PCTN
     C                   Z-ADD     *ZEROS        D1TIME
     C                   Z-ADD     *ZEROS        D1LDAT
     C                   Z-ADD     *ZEROS        D1SLYY
     C                   Z-ADD     *ZEROS        D1SLMM
     C                   Z-ADD     *ZEROS        D1SLDD
     C                   Z-ADD     *ZEROS        D1SPRD
     C                   Z-ADD     *ZEROS        D1IIRT
     C                   Z-ADD     *ZEROS        D1NIYY
     C                   Z-ADD     *ZEROS        D1NIMM
     C                   Z-ADD     *ZEROS        D1NIDD
     C                   Z-ADD     *ZEROS        D1IPDM
     C                   Z-ADD     *ZEROS        D1ACSQ
     C                   Z-ADD     *ZEROS        D1MTTI
     C**********         Z-ADD     *ZEROS        D1MCDH                                       CSD027
     C                   EVAL      D1MCDH = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D1IAYY
     C                   Z-ADD     *ZEROS        D1IAMM
     C                   Z-ADD     *ZEROS        D1IADD
     C                   Z-ADD     *ZEROS        D1MDYY
     C                   Z-ADD     *ZEROS        D1MDMM
     C                   Z-ADD     *ZEROS        D1MDDD
     C                   Z-ADD     *ZEROS        D1NTCE
     C                   Z-ADD     *ZEROS        D1FCLY
     C                   Z-ADD     *ZEROS        D1IMAT
     C                   Z-ADD     *ZEROS        D1BRAT
     C                   Z-ADD     *ZEROS        D1ORCM
     C                   Z-ADD     *ZEROS        D1MOPM
     C                   Z-ADD     *ZEROS        D1LNKN
     C                   Z-ADD     *ZEROS        D1RSTM
     C**********         Z-ADD     *ZEROS        D1ROBN                                       CSD027
     C**********         Z-ADD     *ZEROS        D1ROCN                                       CSD027
     C                   EVAL      D1ROBN = *BLANKS                                           CSD027
     C                   EVAL      D1ROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D1PSTM
     C**********         Z-ADD     *ZEROS        D1POBN                                       CSD027
     C**********         Z-ADD     *ZEROS        D1POCN                                       CSD027
     C                   EVAL      D1POBN = *BLANKS                                           CSD027
     C                   EVAL      D1POCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D1RLDN
     C                   Z-ADD     *ZEROS        D1FSRP
     C                   Z-ADD     *ZEROS        D1DVSD
     C                   Z-ADD     *ZEROS        D1DDND
     C                   Z-ADD     *ZEROS        D1NIPD
     C                   Z-ADD     *ZEROS        D1SLID
     C                   Z-ADD     *ZEROS        D1MATD
     C                   Z-ADD     *ZEROS        D1RBAT
     C                   Z-ADD     *ZEROS        D1ORDA
     C                   Z-ADD     *ZEROS        D1FCGA
     C                   Z-ADD     *ZEROS        D1FCGT
     C                   Z-ADD     *ZEROS        D1FCMA
     C                   Z-ADD     *ZEROS        D1FCMT
     C                   Z-ADD     *ZEROS        D1OMDT
     C                   Z-ADD     *ZEROS        D1PENA
     C                   Z-ADD     *ZEROS        D1COLA
     C                   CLEAR                   CrDlFilFmt2
     C                   Z-ADD     *ZEROS        D2DLUP
     C                   Z-ADD     *ZEROS        D2YLUP
     C                   Z-ADD     *ZEROS        D2TLUP
     C                   Z-ADD     *ZEROS        D2LCD
     C                   Z-ADD     *ZEROS        D2DN38
     C                   Z-ADD     *ZEROS        D2CYDP
     C                   Z-ADD     *ZEROS        D2VDYY
     C                   Z-ADD     *ZEROS        D2VDMM
     C                   Z-ADD     *ZEROS        D2VDDD
     C                   Z-ADD     *ZEROS        D2DTYY
     C                   Z-ADD     *ZEROS        D2DTMM
     C                   Z-ADD     *ZEROS        D2DTDD
     C**********         Z-ADD     *ZEROS        D2CNUM                                       CSD027
     C                   EVAL      D2CNUM = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D2AMNP
     C                   Z-ADD     *ZEROS        D2INTR
     C                   Z-ADD     *ZEROS        D2DDYY
     C                   Z-ADD     *ZEROS        D2DDMM
     C                   Z-ADD     *ZEROS        D2DDDD
     C                   Z-ADD     *ZEROS        D2BRKG
     C                   Z-ADD     *ZEROS        D2BCDP
     C                   Z-ADD     *ZEROS        D2PCTN
     C                   Z-ADD     *ZEROS        D2TIME
     C                   Z-ADD     *ZEROS        D2LDAT
     C                   Z-ADD     *ZEROS        D2SLYY
     C                   Z-ADD     *ZEROS        D2SLMM
     C                   Z-ADD     *ZEROS        D2SLDD
     C                   Z-ADD     *ZEROS        D2SPRD
     C                   Z-ADD     *ZEROS        D2IIRT
     C                   Z-ADD     *ZEROS        D2NIYY
     C                   Z-ADD     *ZEROS        D2NIMM
     C                   Z-ADD     *ZEROS        D2NIDD
     C                   Z-ADD     *ZEROS        D2IPDM
     C                   Z-ADD     *ZEROS        D2ACSQ
     C                   Z-ADD     *ZEROS        D2MTTI
     C**********         Z-ADD     *ZEROS        D2MCDH                                       CSD027
     C                   EVAL      D2MCDH = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D2IAYY
     C                   Z-ADD     *ZEROS        D2IAMM
     C                   Z-ADD     *ZEROS        D2IADD
     C                   Z-ADD     *ZEROS        D2MDYY
     C                   Z-ADD     *ZEROS        D2MDMM
     C                   Z-ADD     *ZEROS        D2MDDD
     C                   Z-ADD     *ZEROS        D2NTCE
     C                   Z-ADD     *ZEROS        D2FCLY
     C                   Z-ADD     *ZEROS        D2IMAT
     C                   Z-ADD     *ZEROS        D2BRAT
     C                   Z-ADD     *ZEROS        D2ORCM
     C                   Z-ADD     *ZEROS        D2MOPM
     C                   Z-ADD     *ZEROS        D2LNKN
     C                   Z-ADD     *ZEROS        D2RSTM
     C**********         Z-ADD     *ZEROS        D2ROBN                                       CSD027
     C**********         Z-ADD     *ZEROS        D2ROCN                                       CSD027
     C                   EVAL      D2ROBN = *BLANKS                                           CSD027
     C                   EVAL      D2ROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D2PSTM
     C**********         Z-ADD     *ZEROS        D2POBN                                       CSD027
     C**********         Z-ADD     *ZEROS        D2POCN                                       CSD027
     C                   EVAL      D2POBN = *BLANKS                                           CSD027
     C                   EVAL      D2POCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZEROS        D2RLDN
     C                   Z-ADD     *ZEROS        D2FSRP
     C                   Z-ADD     *ZEROS        D2DVSD
     C                   Z-ADD     *ZEROS        D2DDND
     C                   Z-ADD     *ZEROS        D2NIPD
     C                   Z-ADD     *ZEROS        D2SLID
     C                   Z-ADD     *ZEROS        D2MATD
     C                   Z-ADD     *ZEROS        D2RBAT
     C                   Z-ADD     *ZEROS        D2ORDA
     C                   Z-ADD     *ZEROS        D2FCGA
     C                   Z-ADD     *ZEROS        D2FCGT
     C                   Z-ADD     *ZEROS        D2FCMA
     C                   Z-ADD     *ZEROS        D2FCMT
     C                   Z-ADD     *ZEROS        D2OMDT
     C                   Z-ADD     *ZEROS        D2PENA
     C                   Z-ADD     *ZEROS        D2COLA
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKDLNO = 'Y'
     C                   EVAL      OKBRC1 = 'Y'
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM                    PModeOfOp
 
      ** Response mode
 
     C                   PARM                    PRespMode
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
 
     C                   PARM                    FOTRID
     C                   PARM                    FOASID
 
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
 
     C                   PARM                    DDDLNO
     C                   PARM                    DDDADN
     C                   PARM                    DDBRC1
     C                   PARM                    DDBRC2
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    PBJSBRC
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    PBKOBUV
 
      ** ZMUSER
      ** ========
 
     C                   PARM                    PBRC
 
      ** Output Parameters
      ** =================
      ** Current deal in file format of deal
 
     C                   PARM                    CrDlFilFmt1
 
      ** Current deal in file format of associated deal
 
     C                   PARM                    CrDlFilFmt2
 
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    OKACTN
     C                   PARM                    OKDLNO
     C                   PARM                    OKBRC1
     C                   PARM                    OKBRC2
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Key Lists
 
     C     KDlAmdKey     KLIST
     C                   KFLD                    KDlAmd
     C                   KFLD                    @YEAR
     C                   KFLD                    @MNTH
     C                   KFLD                    @DAY
     C                   KFLD                    KAmdSeqN
 
      ** Access Deal Number Ranges
 
     C     1             CHAIN     FDDLNMLL                           02
 
      ** Database error
 
     C                   IF        RecNotFnd = True OR NODLTF = '*'
     C                   EVAL      DBKEY  =  '1     '                           *************
     C                   EVAL      DBFILE =  'FDDLNMLL'                         * DBERR 001 *
     C                   EVAL      DBASE  =  001                                *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC054 is on                                                              AR996631
                                                                                            AR996631
     C                   CALLB     'AOSARDR0'                                               AR996631
     C                   PARM      *BLANKS       @RTCD                                      AR996631
     C                   PARM      '*VERIFY'     @OPTN                                      AR996631
     C                   PARM      'CSC054'      PSARD                                      AR996631
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR996631
                                                                                            AR996631
      ** An NRF (No Record Found) return code is valid.                                     AR996631
      ** Issue database error only for error return codes.                                  AR996631
                                                                                            AR996631
     C                   IF        @RTCD <> *BLANKS                                         AR996631
     C                             AND @RTCD <> '*NRF   '                                   AR996631
     C                   EVAL      DBFile = 'SCSARDPD'                                      AR996631
     C                   EVAL      DBKey = 'CSC054'                                         AR996631
     C                   EVAL      DBASE = 3                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
                                                                                            AR996631
     C                   EVAL      CSC054 = 'N'                                             AR996631
     C                   EVAL      WPEAInd = 'N'                                            AR996631
     C                   IF        @RTCD = *BLANKS                                          AR996631
     C                   EVAL      CSC054 = 'Y'                                             AR996631
      *                                                                                     AR996631
     C                   CALL      'AOSVALR0'                                               AR996631
     C                   PARM      *BLANKS       PRetCode                                   AR996631
     C                   PARM      PSysVal1      P@OP01                                     AR996631
     C                   PARM      *BLANKS       P@VL01                                     AR996631
     C                   PARM      *BLANKS       P@OP02                                     AR996631
     C                   PARM      *BLANKS       P@VL02                                     AR996631
     C                   PARM      *BLANKS       P@OP03                                     AR996631
     C                   PARM      *BLANKS       P@VL03                                     AR996631
     C                   PARM      *BLANKS       P@OP04                                     AR996631
     C                   PARM      *BLANKS       P@VL04                                     AR996631
     C                   PARM      *BLANKS       P@OP05                                     AR996631
     C                   PARM      *BLANKS       P@VL05                                     AR996631
     C                   PARM      *BLANKS       P@OP06                                     AR996631
     C                   PARM      *BLANKS       P@VL06                                     AR996631
     C                   PARM      *BLANKS       P@OP07                                     AR996631
     C                   PARM      *BLANKS       P@VL07                                     AR996631
     C                   PARM      *BLANKS       P@OP08                                     AR996631
     C                   PARM      *BLANKS       P@VL08                                     AR996631
     C                   PARM      *BLANKS       P@OP09                                     AR996631
     C                   PARM      *BLANKS       P@VL09                                     AR996631
     C                   PARM      *BLANKS       P@OP10                                     AR996631
     C                   PARM      *BLANKS       P@VL10                                     AR996631
      *                                                                                     AR996631
     C                   IF        PRetCode  <> *BLANKS                                     AR996631
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR996631
     C                   EVAL      DBKEy = '*KEY   '                                        AR996631
     C                   EVAL      DBase = 4                                                AR996631
     C                   EXSR      *PSSR                                                    AR996631
     C                   ENDIF                                                              AR996631
      *                                                                                     AR996631
     C                   MOVEL     P@VL01        WPEAInd                                    AR996631
      *                                                                                     AR996631
     C                   ENDIF                                                              AR996631
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
