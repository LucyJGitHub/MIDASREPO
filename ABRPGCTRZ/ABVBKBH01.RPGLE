     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Booking Branch 1')              *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVBKBH01 - Validate FUND Booking Branch Code 1              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. MD000091           Date 09May13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05         SCAN: String '?' found indicator                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValBRC1 - Validate Booking Branch 1                         *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
     D  QQDORI1      E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMORI1      E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDOPI1      E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMOPI1      E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQINSA1      E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  QQDORI2      E                     EXTFLD(QQDORI)                                     CGL029
     D  QQMORI2      E                     EXTFLD(QQMORI)                                     CGL029
     D  QQDOPI2      E                     EXTFLD(QQDOPI)                                     CGL029
     D  QQMOPI2      E                     EXTFLD(QQMOPI)                                     CGL029
     D  QQRONS2      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS2      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQINSA2      E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Externally described DS for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Location Code Details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Objects - very long data structure                                     CSD025
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  StrFoundIn            05     05
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Mode of processing
     D PMode           S              6A
 
      ** Response Mode, received as a parameter from the common header
     D PResponse       S              1A
 
      ** Redisplay screen flag
     D PReDsp          S              1A
 
      ** Work Variables
     D WBookBrch1      S              3A
     D WDBrchCode      S              3A
     D WCustNo2        S              6A
     D WCustSN2        S             10A
     D WLocnCode1      S              3A
     D WLCcyCode1      S              3A
     D WAcntOfr2       S              2A
 
      ** Work Parameters
     D BJSBRC          S              3A
     D BJSLCD          S              3A
     D BJLCCY          S              3A
     D BJCUST          S              6A
     D DBRN            S              3A
     D AGMBIN          S              1A
 
      ** Parameters for call to access object modules
     D PRtCd           S              7A
     D POptn           S              7A
     D PBrKey          S              3A
     D PLoKey          S              3A
     D PCuKey          S             10A
     D PStKey          S              7A
 
      ** Parameters for call to ZVACTBU
      *(DDACTN)
     D PErr            S              1  0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *                                                                                     MD000091
      **                                                                                    MD000091
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
     C                   EVAL      WBookBrch1 = *Blank
     C                   EVAL      WDBrchCode = *Blank
     C                   EVAL      WCustNo2 = *Blank
     C                   EVAL      WCustSN2 = *Blank
     C                   EVAL      WLocnCode1 = *Blank
     C                   EVAL      WLCcyCode1 = *Blank
     C                   EVAL      WAcntOfr2 = *Blank
 
     C                   EXSR      SRValBRC1
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKBRC1 <> 'Y'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   EVAL      N1BRCA = WBookBrch1
     C                   EVAL      N1DBRC = WDBrchCode
     C                   MOVE      WCustNo2      N2CNUM
     C                   EVAL      N2CSNM = WCustSN2
 
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
      *  SRValBRC1 - Validate Booking Branch Code 1                   *
      *                                                               *
      *****************************************************************
 
     C     SRValBRC1     BEGSR
 
      ** Setup the booking branch code field with default values
 
     C                   IF        AGMBIN = 'N'
 
     C                   EVAL      DDBRC1 = BJSBRC
     C                   EVAL      WBookBrch1 = BJSBRC
     C                   EVAL      WDBrchCode = BJSBRC
     C                   EVAL      WLocnCode1 = BJSLCD
     C                   EVAL      WLCcyCode1 = BJLCCY
     C                   EVAL      WCustNo2 = BJCUST
 
     C                   ELSE
 
     C                   IF        DDBRC1 = *Blanks
     C                   EVAL      DDBRC1 = DBRN
     C                   ENDIF
 
     C     '?'           SCAN      DDBRC1                                 05
 
     C                   IF        StrFoundIn = True
 
     C                   EVAL      PReDsp = 'Y'
 
     C                   IF        PMode = '*FRONT'
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0013'
     C                   GOTO      EndValBRC1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate if Booking Branch is existing
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDBRC1        PBrKey
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   SELECT
 
      ** Booking branch is valid
 
     C                   WHEN      PRtcd = *Blanks
 
     C                   EVAL      DDBRC1 = A8BRCD
     C                   EVAL      WBookBrch1 = A8BRCD
     C                   EVAL      WDBrchCode = A8BRCD
     C                   EVAL      WLocnCode1 = A8LCCD
     C                   EVAL      WCustNo2 = A8BICN
 
      ** if no select
 
     C                   WHEN      PRtcd = '*NOSEL '
 
      ** Use default branch
 
     C                   EVAL      DDBRC1 = DBRN
 
      ** Validate if Booking Branch is existing
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDBRC1        PBrKey
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRtcd <> *Blanks
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0013'
     C                   GOTO      EndValBRC1
 
     C                   ELSE
 
     C                   EVAL      WBookBrch1 = A8BRCD
     C                   EVAL      WDBrchCode = A8BRCD
     C                   EVAL      WLocnCode1 = A8LCCD
     C                   EVAL      WCustNo2 = A8BICN
 
     C                   ENDIF
 
      ** Error found in first access object
 
     C                   OTHER
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0013'
     C                   GOTO      EndValBRC1
 
     C                   ENDSL
 
      ** Check user authority to action/branch
 
     C                   IF        PResponse = 'S'
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    DDACTN
     C                   PARM                    WBookBrch1
     C                   PARM                    PErr
 
     C                   IF        PErr <> 0
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
 
      ** No valid action codes for user/branch combination
 
     C                   IF        PErr = 1
 
     C                   EVAL      MsgIdXAr(IDx) = 'FXM0290'
 
     C                   ELSE
 
      ** The action code is invalid for user/branch combination
 
     C                   EVAL      MsgIdXAr(IDx) = 'FXM0291'
 
     C                   ENDIF
 
     C                   GOTO      EndValBRC1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Get dealing currency of branch location
 
     C                   IF        WLocnCode1 = *Blanks
 
      ** If no location code get global default
 
     C                   EVAL      PLoKey = '***'
 
     C                   ELSE
 
     C                   EVAL      PLoKey = WLocnCode1
 
     C                   ENDIF
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PLoKey
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
     C                   IF        PRtcd <> *Blanks
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
     C                   EVAL      MsgIdXAr(IDx) = 'FDM0459'
     C                   GOTO      EndValBRC1
 
     C                   ENDIF
 
     C                   EVAL      WLCcyCode1 = DVLDCY
 
     C                   ENDIF
 
      ** Get customer details for later use
 
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustNo2      PCuKey
     C                   PARM      *Blanks       PStKey
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
 
     C                   IF        PRtcd <> *Blanks OR
     C                             PStKey = 'ERROR'
 
     C                   EVAL      OKBRC1 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'
     C                   EVAL      MsgIdXAr(IDx) = 'FXM0205'
 
     C                   ELSE
 
     C                   EVAL      WAcntOfr2 = BBACOC
     C                   EVAL      WCustSN2 = BBCSSN
 
     C                   ENDIF
 
      * Check for De-Activation if CSD025 is active                                           CSD025
                                                                                              CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
                                                                                              CSD025
     C                   EVAL      OKBRC1 = 'N'                                               CSD025
     C                   EVAL      IDx = IDx + 1                                              CSD025
     C                   EVAL      FldNamXAr(IDx)= '#1BRC1'                                   CSD025
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(BBCUST)                   MD000091
                                                                                              CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
     C     EndValBRC1    ENDSR
 
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
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
 
      ** Response Mode
     C                   PARM                    PResponse
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Standing Data
      ** =============
      ** SDBANK: Single Branch Code
     C                   PARM                    BJSBRC
      ** SDBANK: System Location Code
     C                   PARM                    BJSLCD
      ** SDBANK: Local Currency Code
     C                   PARM                    BJLCCY
      ** SDBANK: Customer Number
     C                   PARM                    BJCUST
 
      ** RUNDAT: Multibranching Indicator
     C                   PARM                    AGMBIN
 
      ** ZMUSER: Default Branch
     C                   PARM                    DBRN
 
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
 
      ** Redisplay screen flag
     C                   PARM                    PReDsp
 
      ** Account Officer
     C                   PARM                    WAcntOfr2
 
      ** Branch Internal Customer
     C                   PARM                    WCustNo2
 
      ** Local Currency Code 1
     C                   PARM                    WLCcyCode1
 
      ** Location Code 1
     C                   PARM                    WLocnCode1
 
      *                                                                                       CSD025
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd                                        CSD025
     C                   PARM      '*VERIFY'     POptn                                        CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
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
