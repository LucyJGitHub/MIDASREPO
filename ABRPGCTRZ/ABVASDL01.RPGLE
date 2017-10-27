     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Associated Deal Number')        *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVASDL01 - Validate FUND Associated Deal Number             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP.*
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         SETLL: Record Present Indicator                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValDADN - Validate Associated Deal Number                   *
      * SRZAlign  - Validate numeric fields                           *
      * *INZSR    - Initialise                                        *
      * *PSSR     - Error processing                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** IN - Deal Number Ranges
     FFDDLNMLL  IF   E             DISK    INFSR(*PsSR)
 
      ** IN - Deals File by Deal Number
     FCAMIDNLL  IF   E           K DISK    INFSR(*PsSR)
 
      ** IN - Customer Deals Index
     FDEALSH    IF   E           K DISK    INFSR(*PsSR)
     F                                     RENAME(DEALSDBF:RDAB)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  N1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  N2DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N2MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N2DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N2MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N2RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N2PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N2INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecPresIn             03     03
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Work Variables
     D WAscDlNo        S              6  0
 
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Initialise work variables
 
     C                   EVAL      IDx = 0
     C                   EVAL      WAscDlNo = 0
 
     C                   EXSR      SRValDADN
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKDADN <> 'Y'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   MOVE      WAscDlNo      N2DN38
     C                   MOVE      WAscDlNo      N1DADN
 
     C                   ENDIF
 
      *                  ======
     C                   RETURN
      *                  ======
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDADN - Validate Associated Deal Number                  *
      *                                                               *
      *****************************************************************
 
     C     SRValDADN     BEGSR
 
      ** Deal Number must be numeric or blank
 
     C                   MOVE      *Blanks       ZField
     C                   MOVE      DDDADN        ZField
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        DDDADN <> *Blanks AND
     C                             ZAlignOk = 'N'
 
     C                   EVAL      OKDADN = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1DADN'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0162'
     C                   GOTO      EndValDADN
 
     C                   ENDIF
 
      ** Read Deal number ranges file
 
     C                   READ      FDDLNMLL                             1213
 
      ** Setup Deal No. as a numeric field
 
     C                   MOVE      DDDADN        WAscDlNo
 
     C                   IF        DDACTN = 'I'
 
     C                   SELECT
 
     C                   WHEN      WAscDlno = 0
 
     C                   EVAL      DDDADN = *Blanks
 
      ** Check if Deal number is within range
 
     C                   WHEN      WAscDlNo = 999999 OR
     C                             WAscDlNo < NORDLN
 
     C                   EVAL      OKDADN = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1DADN'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0164'
 
      ** Check if Deal Number already exists
 
     C                   OTHER
 
     C     WAscDlNo      SETLL     CAMIDNLL                               03
 
     C                   IF        RecPresIn = False
 
     C     WAscDlNo      SETLL     DEALSH                                 03
 
     C                   ENDIF
 
     C                   IF        RecPresIn = True
 
     C                   EVAL      OKDADN = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1DADN'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0163'
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C     EndValDADN    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
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
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
