     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*XBIA*  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*XBIB*  OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate and update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GL001505 - Account Maintenance validate and update           *
      *                                                               *
      *  Note: This is a copy of GLAMADVU, without Commit/Rollback.   *
      *        Any change applied to GLAMADVU, should be applied to   *
      *        this program too.                                      *
      *                                                               *
      *  Function: This Program Validates Midas Account Details for   *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD027217           Date 29May14               *
      *  Prev Amend No. AR971184           Date 29May14               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE030             Date 10Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238625             Date 06Apr06               *
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD023  *CREATE    Date 05Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027217 - Not possible to authorize customer closure        *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *           - Applied for MD027217                              *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CRE030 - Default RE Accounts by Currency                     *
      *  238625 - DDICNST is incorrect, initialise field properly     *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD023 - Automatic Customer Account Closure                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
     FTABTBRE   IF   E             DISK    INFSR(*pssr)
     F                                     PREFIX(R_)
 
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)  USROPN
     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCPTFRF)
     F                                     PREFIX(AC_)
      ** Default Retail Account
     FREDEF     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
     F                                     IGNORE(REDEFAF)
     F                                     IGNORE(REDEFZF)
 
      ** Retail Interest and Charge File
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)
 
      ** Accounts by Branch
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Numbers
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMTBF)
     F                                     INFSR(*PSSR)
 
      ** BRT Customer Details
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
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
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D AccnInMast    E DS                  EXTNAME(GLAMADPD)
     D AccnInDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccnInCred    E DS                  EXTNAME(GLAMCIPD)
     D AccnInComm    E DS                  EXTNAME(GLAMCOPD)
     D AccnInOthe    E DS                  EXTNAME(GLAMODPD)
     D AccnInPena    E DS                  EXTNAME(GLAMPPPD)                                MD027217
     D AccnInPena1   E DS                  EXTNAME(GLAMPP1PD) PREFIX(P1:2)                  MD027217
     D AccnInPena2   E DS                  EXTNAME(GLAMPP2PD) PREFIX(P2:2)                  MD027217
 
 
      * Valid Account layout
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
     D                                     PREFIX(V_)
      * Valid Extn. Account layout -> ACCNTBXC
     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(V_)
     D V_QQACC1      E                     EXTFLD(QQACOD)
      * Valid Extn. Account layout -> REIACD
     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(V_)
     D V_QQACC2      E                     EXTFLD(QQACOD)
     D ValidExR2     E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(W_)
     D ValidExsh               1    144
     D ValidExex             212    284
      * Valid Extn. Account layout -> RECOMD
     D ValidExCO     E DS                  EXTNAME(GLVAMCOPD)
     D                                     PREFIX(V_)
     D V_QQACC3      E                     EXTFLD(QQACOD)
     D ValidExCO1              1    286
     D ValidExCOEx           354    363
      * Valid Extn. Account layout -> REAPWDPD
     D ValidExPW     E DS                  EXTNAME(GLVAMPWPD)
     D                                     PREFIX(V_)
     D V_QQACC4      E                     EXTFLD(QQACOD)
     D ValidExPW1              1     33
     D ValidExPWEx           101    110
      * Valid Extn. Account layout -> REPRPNPD                                              MD027217
     D ValidPena     E DS                  EXTNAME(GLVAMPPPD)                               MD027217
     D                                     PREFIX(V_)                                       MD027217
 
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(A_)
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(B_)
     D ExRIFilsh               1    144
     D ExRIFilex             146    218
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(C_)
     D ExCOFilFmt1             1    286
     D ExCOFilFmtEx          287    296
     D ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(D_)
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                MD027217
     D                                     PREFIX(F1)                                       MD027217
     D ExPWFilFmt1             1     33
     D ExPWFilFmtEx           34     43
 
      * (Current) Account in Screen Format - Master Details
     D CurAcMast     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Debit Details
     D CurAcDebi     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Credit Details
     D CurAcCred     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Commision Details
     D CurAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Other Details
     D CurAcOthe     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@)
      * Current account in screen format - Period and Penalty                               MD027217
     D CurAcPena     E DS                  EXTNAME(GLAMPPPD)                                MD027217
     D                                     PREFIX(@)                                        MD027217
      * Current Account in File Format
     D CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(E_)
      * Current Account in File Format (Extension File)
     D CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(CA_)
      * Current Account in File Format (Extension File)
     D CARIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(CB_)
      * Current Account in File Format (Extension File)
     D CACOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(CC_)
      * Current Account in File Format (Extension File)
     D CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(CD_)
     D CAPPFILFMT    E DS                  EXTNAME(GLVAMPPPD)                               MD027217
     D                                     PREFIX(PP_)                                      MD027217
      * New Account in File Format
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)
      * New Account in File Format (Extension File)
     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(A_)
     D QQACOD1       E                     EXTFLD(QQACOD)
      * New Account in File Format (Extension File)
     D NARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(B_)
      * New Account in File Format (Extension File)
     D NACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)
     D                                     PREFIX(C_)
      * New Account in File Format (Extension File)
     D NAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)
     D                                     PREFIX(D_)
      * New Account in Screen Format - First Details
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(N)
      * New Account in Screen Format - Debit Details
     D NewAcDebt     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(N)
      * New Account in Screen Format - Credit Details
     D NewAcCrdt     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(N)
      * New Account in Screen Format - Commission Details
     D NewAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(N)
      * New Account in Screen Format - Other Details
     D NewAcOthr     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(N)
      * New Account in Screen Format - Period and Penalty                                   MD027217
     D NewAcPena     E DS                  EXTNAME(GLAMPPPD)                                MD027217
     D                                     PREFIX(N)                                        MD027217
 
      * Error indicators
     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
     D OKAcPena      E DS                  EXTNAME(GLEAMPPPD) PREFIX(X:1)                   MD027217
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
      ** Externally described DS for Nostro Code details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDNOSTACCD    E                     EXTFLD(QQACCD)
 
     D ExtData       E DS                  EXTNAME(GLAMEXPD)
      * GL Accounts Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for access programs, very long data structure
 
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqAccntMaint')
 
      ** Override SDAULGL0
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)
 
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External DS for Portfolio Customer Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
      ** External DS for Customer Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** EXTERNAL DS FOR MIDAS BASE RATE CODE DETAILS
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)
     D  WCMTJOBS               4    103A
      ** Commitment Control dataarea
 
      **--------------------------------------------------------------------------------------------
     D RUNDAT          DS            13
      * Rundate data area
     D  AGMBIN                13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Accnt5001       S            500A
     D Accnt5002       S            500A
     D Accnt5003       S            500A
     D Accnt5004       S            500A
     D Accnt5005       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Field to tell whether Commissions are to be displayed
     D CommDisp        S              1A
 
      ** Fields for enhancement CSC022
     D CSC022          S              1A   INZ('N')
     D WCmtSk          S              1A
 
      ** Array to hold commitment jobs name
     D WCMT            S             10A   DIM(10)
 
     D DDEABC          S              1A
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepMast         S              1A   inz('N')
     D RepDebi         S              1A   inz('N')
     D RepCred         S              1A   inz('N')
     D RepComm         S              1A   inz('N')
     D RepOthe         S              1A   inz('N')
 
     D WProcDate       S                   LIKE(BJRDNB)
     D CSC011          S              1A   INZ('N')
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          S            256
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   MOVEL     Accnt5001     AccnInMast
     C                   MOVEL     Accnt5002     AccnInDebi
     C                   MOVEL     Accnt5003     AccnInCred
     C                   MOVEL     Accnt5004     AccnInComm
     C                   MOVEL     Accnt5005     AccnInOthe
     C                   MOVEL     Extdata500    Extdata
 
     C                   EVAL      WAPFOTranID = APFOTRANID + APFOASOCID                    AR971184
     C                   EVAL      FOTRID =  APFOTRANID + APFOASOCID                        AR971184
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
     C                   MOVE      *OFF          *IN30
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
      *
      *  Processing for Inserts
 
     C                   EXSR      GLVACSQ
 
      *  Validate Action Code
 
     C                   EXSR      ValidatAcn
 
      *  If error in validation of action code, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateAc
 
     C                   WHEN         DDACTN = 'A'
 
      *  Processing for Amends or Changes
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateAc
 
     C                   ENDSL
      *
      ** Validate miscellaneous screen fields.
      *
     C                   EXSR      GLVALID
      *
     C     INVALID       TAG
 
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Ix            ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
     C                   EVAL                    Buffer = AccnInMast
     C                                           + AccnInDebi + AccnInCred
     C                                           + AccnInComm + AccnInOthe
     C                                           + @TimeStamp
     C                                           + DDFAMT + AMATYP + AMSTYP
     C                                           + DODRCD + DOCRCD + INCST
     C                                           + BRT + ALT + LTYP + LINK
     C                                           + IBA1 + DOPOLC + DOPOLE
     C                                           + DSPTFR + DDDRMG1 + DDCRMG1
     C                                           + DDCEXA1 + DDCEXB1 + DDCEXC1
     C                                           + DDCEXD1 + DDCEXE1 + DDCEXF1
     C                                           + DDCEXG1
     C                                           + DDEABC
 
     C     *IN28         IFEQ      *ON
     C                   CLOSE     PMPORTLL
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidatAcn - Routine to validate action code versus the       *
      *    Account IDs supplied                                       *
      *                                                               *
      *****************************************************************
     C     ValidatAcn    BEGSR
 
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      * Validate action code versus account IDs supplied
      * This function will set the Midas account reference
      * The account in file format from the GL database is retrieved as well
 
     C                   RESET                   ReturnCode
     C                   CALLB     'GLAMADRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C**********         PARM      DDACCN        WAPFOTranID      40                        AR971184
     C                   PARM                    WAPFOTranID      40                        AR971184
      *
      * (Midas) Account Key
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      *
      * Commissions
     C                   PARM                    CommDisp
      * IBAN
     C                   PARM                    CFT004
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                     MD027217
      *
      ** New Accounts Currency
      *
     C                   PARM                    WDCCY             3
      *
      * OUTPUTS
      *
      * (Current) Account in file format
      * (Current) Account extension in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    ExPPFilFmt                                 MD027217
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Account Key
     C                   PARM                    DDCUSNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    DDACODOK
     C                   PARM                    DDACSQOK
     C                   PARM                    DDBRCAOK
     C                   PARM                    DDACNOOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Base Rate Auth Req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
     C     GLVACSQ       BEGSR
 
     C                   CALLB     'GLVACSQ'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Account Screen Fields
     C                   PARM                    DDACOD           10
     C                   PARM                    DDACSQ            2
     C                   PARM                    DDCUSN            6
     C                   PARM                    A8BICN            6
     C                   PARM                    AGMBIN            1
      * OUTPUTS :
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM                    AMATYP            1
     C                   PARM                    AMSTYP            1
     C                   PARM                    WWTOIN            1
     C                   PARM                    WWRETL            1
      * Account Code - OK
      * Account Sequence - OK
     C                   PARM      *ZERO         DDACODOK          1
     C                   PARM      *ZERO         DDACSQOK          1
      *
      ** Access Account Code details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDACOD        @ACOD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C     DDACOD        ANDNE     *BLANKS
     C                   MOVEL     'N'           DDACODOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACOD'      FldNameArr(Ix)
     C                   MOVEL     'RE71037'     MsgIdArr(Ix)
     C                   END
      *
      ** If each field filled, generate error on 1st input screen if account already exists.
      *
     C     DDCUSN        IFNE      *BLANKS
     C     DDCCY         ANDNE     *BLANKS
     C     DDACOD        ANDNE     *BLANKS
     C     DDACSQ        ANDNE     *BLANKS
     C     DDBRCA        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'I'
      **
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVEL     DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      DDBRCA        WWBRCA            3
      *
     C     WWACKA        CHAIN     ACCNTLXX                           80
      *
      ** If record was found then this account cannot be entered as new.
      ** Highlight Branch field (as only one field can be highlighted).
      *
     C     *IN80         IFEQ      '0'
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71025'     MsgIdArr(Ix)
      *
     C                   END
     C                   END
      *
      ** Ensure all fields are defauted if appropriate.
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      SRDEFT
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLVALID       BEGSR
 
      *
      * Initialise screen conditioning fields for initial insert.
      *
     C                   MOVE      *BLANKS       DOPOLC            6
     C                   MOVE      *BLANKS       DOPOLE            6
     C                   MOVEL     'N'           ALT               1
     C                   MOVEL     ' '           LTYP              1
     C                   MOVEL     *BLANKS       LINK             18
 
     C                   MOVEL     'N'           INCST             1
      *
     C                   CLEAR                   SDCURR
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Display if is an In currency past the transition start date.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     WProcDate
     C     CSC011        ANDEQ     'Y'                                                        238625
     C     A6INCY        OREQ      'Y'                                                        238625
     C     A6TPSD        ANDLE     BJRDNB                                                     238625
     C     CSC011        ANDNE     'Y'                                                        238625
     C                   MOVEL     'Y'           INCST
     C                   ENDIF
      *
      * Validate BRT category extension record exists.
      *
     C                   MOVEL     'N'           BRT               1
     C**********         MOVE      DDCUSN        @CNUM6            6 0                        CSD027
     C                   MOVE      DDCUSN        @CNUM6            6                          CSD027
      *
     C     S01383        IFEQ      'Y'
     C     @CNUM6        CHAIN     SDCBRTL1                           81
     C     *IN81         IFEQ      *OFF
     C     XRECI         ANDEQ     'D'
     C                   MOVEL     'Y'           BRT
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Branch details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Not Found
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71040'     MsgIdArr(Ix)
     C                   MOVE      'Y'           IBA1              1
     C                   ELSE
     C     A8GENM        IFEQ      '1'
     C     A8GENM        OREQ      ' '
     C                   MOVE      'N'           IBA1
     C                   ELSE
     C                   MOVE      'Y'           IBA1
     C                   ENDIF
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
      *
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR            1
     C     @RTCD         IFEQ      'PMA0008'
     C     @RTCD         OREQ      'PMA0009'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDNE     'B'
     C     AMATYP        ANDNE     'R'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDEQ     'B'
     C     AMATYP        ANDNE     'R'
     C     AMATYP        ANDNE     'N'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDNE     'B'
     C     A5ACTY        ANDNE     'R'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDEQ     'B'
     C     A5ACTY        ANDNE     'R'
     C     A5ACTY        ANDNE     'N'
      *
      ** Suppress Portfolio Reference.
     C                   MOVE      'N'           DSPTFR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGN4ST        IFEQ      'Y'
     C                   MOVEL     DDCUSN        @KEY10
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY10           10
     C                   PARM      *BLANKS       @KEY7             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR
     C                   ELSE
     C     BGPFMG        IFNE      'Y'
      ** Suppress Portfolio Reference.
     C                   MOVE      'N'           DSPTFR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     A5ACTY        IFEQ      'R'
     C     DSPTFR        ANDEQ     'Y'
     C     *IN28         ANDEQ     *ON
     C     DDPTFR        IFEQ      *BLANKS
     C**********         MOVEL     DDCUSN        KPCNUM            6 0                        CSD027
     C                   MOVEL     DDCUSN        KPCNUM            6                          CSD027
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      'N'           WWVAL             1
     C     KPCNUM        SETLL     PMPORTLL
     C     KPCNUM        READE     PMPORTLL                               88
      *
     C     *IN88         DOWEQ     *OFF
     C     WWVAL         ANDEQ     'N'
     C     PNDPCL        IFEQ      0
     C                   MOVE      PNPTFR        WWPTFR            4
     C     PTFRK         CHAIN     ACCPTFR                            81
      *
     C     *IN81         IFEQ      '0'
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ELSE
     C                   MOVE      PNPTFR        DDPTFR
     C                   MOVE      'Y'           WWVAL
     C                   ENDIF
      *
     C                   ELSE
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      DFT@O
     C                   END
      *
      ** Set up Enable Account Balance Check Flag
     C                   EXSR      SREnableABC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnableABC - Subroutine to setup Enable Account Balance     *
      *                Check flag                                     *
      *                                                               *
      *****************************************************************
     C     SREnableABC   BEGSR
 
      ** Initialise account flag to 'N'
     C                   EVAL      DDEABC = 'N'
 
      ** Set to 'Y' only if retail and non=nostro account
 
     C                   IF        AMATYP = 'R'
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDCUSN        PKCUST            6
     C                   PARM      DDCCY         PKCYCD            3
     C                   PARM      DDACOD        PKACCD           10
     C                   PARM      DDACSQ        PKACSN            2
     C                   PARM                    PKNONB            2
     C                   PARM      DDBRCA        PKBRCD            3
     C                   PARM                    PKUCSN           10
     C                   PARM                    PKPNOI            1
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DDEABC = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN
      **********************************************************************
     C     DFT@O         BEGSR
      *
     C                   MOVEL     CABXFilFmt    NABXFilFmt
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     BBCGRP        IFEQ      *BLANKS
     C     @RTCD         ORNE      *BLANKS
     C                   MOVEL     '1'           BBCGRP
     C                   ENDIF
      *
      *
     C                   CALLB     'GLAMAD4DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM                    RetCodeIn
 
      * Customer Retail Group
     C                   PARM                    BBCGRP
      *
      ** CCRM Revenue Analysis
     C                   PARM                    CDE002
 
      * Account details (DS) in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    NABXFilFmt
 
      * OUTPUTS :
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1
     C                   PARM                    DDCRMG1
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Account into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVEL     AccnFilFmt    ValidAccn
     C                   MOVEL     ExBXFilFmt    ValidExBX
     C                   CLEAR                   ValidExR2
     C                   MOVEL     ExRIFilsh     ValidExsh
     C                   MOVEL     ExRIFilex     ValidExex
     C                   MOVEL     ValidExR2     ValidExRI
     C                   MOVEL     ExCOFilFmt1   ValidExCO1
     C                   MOVEL     ExCOFilFmtEx  ValidExCOEx
     C                   MOVEL     ExPWFilFmt1   ValidExPW1
     C                   MOVEL     ExPWFilFmtEx  ValidExPWEx
 
      * For Amends, convert the Account to screen format
 
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Account - file formats
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExCO
     C                   PARM                    ValidExPW
     C                   PARM                    ValidPena                                  MD027217
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis
     C                   PARM                    CDE002            1
      * Retail charges details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      *
      * Output parameters
      *
      * Account - screen formats
     C                   PARM                    CurAcMast
     C                   PARM                    CurAcDebi
     C                   PARM                    CurAcCred
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthe
     C                   PARM                    CurAcPena                                  MD027217
      *
      * Screen 1 Output
     C                   PARM      *BLANK        DDDACC            6
     C                   PARM      *BLANK        DDLINK           24
     C                   PARM      *BLANK        DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM      *BLANK        DODRCD            6
     C                   PARM      *BLANK        DDPOLC            6
     C                   PARM      *BLANK        DDPOLE            6
      *
      * Screen 3 Output
     C                   PARM      *BLANK        DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM      *BLANK        DDCEXA1          11
     C                   PARM      *BLANK        DDCEXB1          11
     C                   PARM      *BLANK        DDCEXC1          11
     C                   PARM      *BLANK        DDCEXD1           8
     C                   PARM      *BLANK        DDCEXE1           8
     C                   PARM      *BLANK        DDCEXF1           8
     C                   PARM      *BLANK        DDCEXG1           8
     C                   PARM      *BLANK        DDDRMG1          12
     C                   PARM      *BLANK        DDCRMG1          12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate the main Account details     *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
      * Validate Account master details
 
     C                   EXSR      ValdAcMast
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C     V_AMATYP      IFEQ      'R'
      * Validate Account debit details
 
     C                   EXSR      ValdAcDebi
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account credit details
 
     C                   EXSR      ValdAcCred
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account commission details
 
     C                   EXSR      ValdAcComm
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account other details
 
     C                   EXSR      ValdAcOthe
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
     C                   ENDIF
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcMast - Validate Account Master details                  *
      *                                                               *
      *****************************************************************
     C     ValdAcMast    BEGSR
 
     C                   CALLB     'GLAMAD1VL'
 
      * INPUTS
 
      * Response mode
     C                   PARM      'S'           APRESPMODE
 
      * Screen Format
     C                   PARM                    WFMT              2
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Master details
     C                   PARM                    AccnInMast
      * Front Office ID
     C                   PARM                    WAPFOTranID
 
      ** Account Master Details OK inds
     C                   PARM                    OKAcMast
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Full GL Account Number
     C                   PARM      *BLANKS       WGLKEY           24
      * IBAN Sequence
     C                   Parm                    DDIBSQ            3
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidEXBX
      * Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
      *
      * Ensure first individual alternate address field is read if error encountered.
     C                   Z-ADD     1             I                 3 0
     C                   MOVEL     'DDRef     '  TEST             10
     C     TEST          LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'DDRF01    '  FldNameArr(I)
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcDebi - Validate Account Debit details                   *
      *                                                               *
      *****************************************************************
     C     ValdAcDebi    BEGSR
 
     C                   CALLB     'GLAMAD2VL'
 
      * INPUTS
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Debit details
     C                   PARM                    AccnInDebi
 
      ** Account Commision details
     C                   PARM                    AccnInComm
 
      * Front Office ID
     C                   PARM                    WAPFOTranID
 
      ** Account Debit Details OK inds
     C                   PARM                    OKAcDebi
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
     C                   PARM                    WFldNamArr                                   CER055
     C                   PARM                    WMsgIDArr                                    CER055
     C                   PARM                    WMsgDtaArr                                   CER055
      * Array index (3P0) from/to caller                                                      CER055
     C                   PARM                    WIdx                                         CER055
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
      * Revenue Analysis
     C                   PARM                    CDE002            1
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcCred - Validate Account Credit details                  *
      *                                                               *
      *****************************************************************
     C     ValdAcCred    BEGSR
 
     C                   CALLB     'GLAMAD3VL'
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Credit details
     C                   PARM                    AccnInCred
 
      ** Account Commision details
     C                   PARM                    AccnInComm
 
      ** ICD
     C                   PARM                    R_TCAL
      * Front Office ID
     C                   PARM                    WAPFOTranID
 
      ** Account Credit details OK inds
     C                   PARM                    OKAcCred
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
     C                   PARM                    WFldNamArr                                 AR847249
     C                   PARM                    WMsgIDArr                                  AR847249
     C                   PARM                    WMsgDtaArr                                 AR847249
      ** Array index (3P0) from/to caller                                                   AR847249
     C                   PARM                    WIdx                                       AR847249
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExBX
      * Revenue Analysis
     C                   PARM                    CDE002
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcComm - Validate Account Commission details              *
      *                                                               *
      *****************************************************************
     C     ValdAcComm    BEGSR
 
     C                   CALLB     'GLAMAD4VL'
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Commision details
     C                   PARM                    AccnInComm
 
      ** ICD
     C                   PARM                    RETABLE
      ** CCRM Revenue Analysis
     C                   PARM                    CDE002            1
 
      ** Account Commissions OK inds
     C                   PARM                    OKAcComm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidExCO
      * Valid Account layout (extension file) (DS) from/to caller
     C                   PARM                    ValidExBX
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcOthe - Validate Account Other details                   *
      *                                                               *
      *****************************************************************
     C     ValdAcOthe    BEGSR
 
     C                   CALLB     'GLAMAD5VL'
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Other Details
     C                   PARM                    AccnInOthe
 
      ** Account Other details OK inds
     C                   PARM                    OKAcOthe
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER047
     C                   PARM                    WFldNamArr                                   CER047
     C                   PARM                    WMsgIDArr                                    CER047
     C                   PARM                    WMsgDtaArr                                   CER047
      * Array index (3P0) from/to caller                                                      CER047
     C                   PARM                    WIdx                                         CER047
                                                                                              CER047
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExPW
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
 
     C                   CALLB     'GLAMADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    AccninMast
     C                   PARM                    AccninDebi
     C                   PARM                    AccninCred
     C                   PARM                    AccninComm
     C                   PARM                    AccninOthe
     C                   PARM                    AccnInPena                                 MD027217
      *
      * (Current) Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurAcMast
     C                   PARM                    CurAcDebi
     C                   PARM                    CurAcCred
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthe
     C                   PARM                    CurAcPena                                  MD027217
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcMast
     C                   PARM                    OKAcDebi
     C                   PARM                    OKAcCred
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthe
     C                   PARM                    OKAcPena                                   MD027217
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Ix
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR
 
     C     Ix            IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Ix
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurAcMast
     C                   CLEAR                   CurAcDebi
     C                   CLEAR                   CurAcCred
     C                   CLEAR                   CurAcComm
     C                   CLEAR                   CurAcOthe
 
     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVE      *ALL'Y'       OKAcDebi
     C                   MOVE      *ALL'Y'       OKAcCred
     C                   MOVE      *ALL'Y'       OKAcComm
     C                   MOVE      *ALL'Y'       OKAcOthe
 
     C                   CLEAR                   ValidAccn
     C                   CLEAR                   ValidExBX
     C                   CLEAR                   ValidExCO
     C                   CLEAR                   ValidExRI
     C                   CLEAR                   ValidExPW
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR
 
      * Set Valid file field for a delete.
     C                   IF        DDACTN = 'D'
     C                   EVAL      ValidAccn = AccnFilFmt
     C                   MOVEL     ExCOFilFmt    ValidExCO
     C                   MOVEL     ExPWFilFmt    ValidExPW
     C                   ENDIF
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_AMCHTP = DDACTN
     C                   EVAL      V_AMIBAN = DDIBAN
     C                   EVAL      V_AMIBSEQN = DDIBSQ
 
     C                   IF        APFOTranID <> *BLANKS                                    AR971184
     C                   EVAL      V_AMFRNT =  APFOTranID                                   AR971184
     C                   EVAL      V_AMAFRT =  APFOAsocID                                   AR971184
     C                   EVAL      V_AMREPA =  APRprLocn                                    AR971184
     C                   ENDIF                                                              AR971184
      * Restore Timestamp from the original record
     C                   IF        DDACTN <> 'I'
 
      ** If timestamp is blank, then generate it
     C                   IF        @TimeStamp = *BLANKS
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    @TimeStamp
     C                   ENDIF
 
     C                   MOVEL     @TimeStamp    AMTMST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      ** ACCOUNT DATABASE UPDATE
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM      'S'           RespMode          1
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExCO
     C                   PARM                    ValidExPW
     C                   PARM                    ValidPena                                  MD027217
     C                   PARM                    CEU013
     C                   PARM                    CRT001
     C                   PARM                    CRT002
     C                   PARM                    CRE001
     C                   PARM                    CRT101
     C                   PARM                    CFT004
     C                   PARM                    CDE002            1
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @@RTCD        IFNE      *BLANK
     C     @@RTCD        ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   IF        (CSC022 = 'N')
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')
     C                   ENDIF
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 = 'N')
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')
     C                   ENDIF
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRDEFT - Process default values in INSERT MODE
      ********************************************************************
     C     SRDEFT        BEGSR
      *
      ** Initialise screen fields to default values:
      ** Test rightmost 130 characters of screen, if blank then default.
     C                   MOVE      AccnInMast    BLANKCHK        130
     C     BLANKCHK      IFEQ      *BLANKS
      *
      ** If account code is retail and on REDEFD then default from that.
     C     AMATYP        IFEQ      'R'
      *
     C                   MOVE      DDACOD        WWACOK
     C                   MOVE      'D'           WWRECI
      *                                                                                       CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            50                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              50                      CRE030
     C     ACODK         CHAIN     REDEFDF                            50                      CRE030
     C                   ENDIF                                                                CRE030
      *
     C     *IN50         IFEQ      '0'
     C     X_RECI        ANDEQ     'D'
      *
      * Save key of account being entered.
      *
     C                   MOVE      DDACTN        WDACTN            1
     C                   MOVE      DDCUSN        WDCUSN            6
     C                   MOVE      DDCCY         WDCCY             3
     C                   MOVE      DDACOD        WDACOD           10
     C                   MOVE      DDACSQ        WDACSQ            2
     C                   MOVE      DDBRCA        WDBRCA            3
     C                   MOVE      DDACNO        WDACNO           10
      *
      * Lookup account for default account found.
      * Result returned to Current file formats.
      *
     C                   MOVE      'R'           DDACTN
      *
     C                   EXSR      SRRTVACC
      *
      * Convert the default Account to screen format
      * Result returned to New screen formats.
      * Then moved to the Current screen formats.
      *
     C                   MOVE      WDACTN        DDACTN
     C                   EXSR      SRCVTACC
      * Set action code in CurAcMast.
     C                   MOVE      WDACTN        @DDACTN
      *
      ** Replace the original account reference and reset basic fields.
      *
     C                   MOVE      WDCUSN        DDCUSN
     C                   MOVE      WDCCY         DDCCY
     C                   MOVE      WDACOD        DDACOD
     C                   MOVE      WDACSQ        DDACSQ
     C                   MOVE      WDBRCA        DDBRCA
     C                   MOVE      WDACNO        DDACNO
     C                   MOVE      *BLANKS       DDDACO
     C                   MOVE      *BLANKS       DDIBAN
      *
      ** Copy the New account details to the current account details.
      *
     C                   MOVE      WDCUSN        E_CNUM
     C                   MOVE      WDCCY         E_CCY
     C                   MOVE      WDACOD        E_ACOD
     C                   MOVE      WDACSQ        E_ACSQ
     C                   MOVE      WDBRCA        E_BRCA
     C                   MOVE      WDACNO        E_ACNO
     C                   MOVE      *BLANKS       E_IBAN
     C                   MOVE      *BLANKS       E_IBSEQN
      *
     C                   MOVE      DDACOD        WWACOK
     C                   MOVE      'D'           WWRECI
      *
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            99                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              99                      CRE030
     C     ACODK         CHAIN     REDEFDF                            99                      CRE030
     C                   ENDIF                                                                CRE030
      *
     C     *IN99         IFEQ      '0'
     C     X_RECI        ANDEQ     'D'
      *
     C*****X_CNUM        IFEQ      *ZEROS                                                     CSD027
     C     X_CNUM        IFEQ      *BLANKS                                                    CSD027
      *
     C     X_RETN        CHAIN     ACNUM                              99
     C     *IN99         IFEQ      '0'
     C                   MOVE      CNUM          WWCUSK
     C                   MOVE      CCY           WWCCYK
     C                   MOVE      ACOD          WWACOK
     C                   MOVE      ACSQ          WWACSK
     C                   MOVE      BRCA          WWBRCK
     C     WWACKB        CHAIN     ACCNTLXX                           99
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      X_CNUM        WWCUSK
     C                   MOVE      X_RCCY        WWCCYK
     C                   MOVE      X_ACOD        WWACOK
     C                   MOVE      X_SEQR        WWACSK
     C                   MOVE      X_BRCA        WWBRCK
     C     WWACKB        CHAIN     ACCNTLXX                           99
     C                   ENDIF
      *
     C     *IN99         IFEQ      '0'
      *                                                                                       CRE030
      ** Default Minimum Balance if CRE030 is enabled                                         CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   IF        MINB=*ZERO                                                 CRE030
     C                   EVAL      DDMINB=*BLANKS                                             CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      *BLANKS       ZFIELD                                       CRE030
     C                   MOVE(P)   MINB          ZFIELD                                       CRE030
     C                   Z-ADD     *ZERO         ZADEC                                        CRE030
     C                   CALLB     'ZEDIT'                                                    CRE030
     C                   PARM                    ZFIELD                                       CRE030
     C                   PARM                    ZADEC                                        CRE030
     C                   MOVEL     ZFIELD        DDMINB                                       CRE030
     C                   ENDIF                                                                CRE030
     C                   ENDIF                                                                CRE030
      *
     C     X_RCCY        IFEQ      DDCCY
     C     DRIB          IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       DDDRIB
     C                   ELSE
     C                   MOVE      DRIB          DDDRIB
     C                   ENDIF
      *
      ** If not the same Ccy - Check Base Type is valid for other Ccy
     C                   ELSE
     C     DRIB          IFNE      *ZEROS
     C                   MOVE      DRIB          WWRIB             2
      *
      ** Get Base Rate Codes
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCCY
     C                   PARM                    WWRIB
     C     SDBSRT        PARM      SDBSRT        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      DRIB          DDDRIB
     C                   ELSE
     C                   MOVE      *BLANKS       DDDRIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DRIS          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDDRIS
     C                   ELSE
     C     DRIS          IFLT      *ZEROS
     C                   MOVE      '-'           DDDSIG
     C                   Z-SUB     DRIS          DRIS
     C                   ELSE
     C                   MOVE      ' '           DDDSIG
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   DRIS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVEL     ZFIELD        DDDRIS
     C                   ENDIF
      *
     C     X_RCCY        IFEQ      DDCCY
     C     CRIB          IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       DDCRIB
     C                   ELSE
     C                   MOVE      CRIB          DDCRIB
     C                   ENDIF
      *
      ** If not the same Ccy - Check Base Type is valid for other Ccy
     C                   ELSE
     C     CRIB          IFNE      *ZEROS
     C                   MOVE      CRIB          WWRIB
      *
      ** Get Base Rate Codes
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCCY
     C                   PARM                    WWRIB
     C     SDBSRT        PARM      SDBSRT        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      CRIB          DDCRIB
     C                   ELSE
     C                   MOVE      *BLANKS       DDCRIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     CRIS          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDCRIS
     C                   ELSE
     C     CRIS          IFLT      *ZEROS
     C                   MOVE      '-'           DDCSIG
     C                   Z-SUB     CRIS          CRIS
     C                   ELSE
     C                   MOVE      ' '           DDCSIG
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE(P)   CRIS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVEL     ZFIELD        DDCRIS
     C                   ENDIF
     C                   ENDIF
      *
     C     DRIC          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDDRIC
     C                   ELSE
     C                   MOVE      DRIC          DDDRIC
     C                   ENDIF
      *
     C     NDID          IFNE      *ZEROS
     C                   CallB     'ZDATE2'
     C                   Parm      NDID          ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   Move      ZDATE         DDNDID
     C                   ELSE
     C                   MOVEL     *BLANKS       DDNDID
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       DDDRCD
     C                   MOVE      *BLANKS       DDCRCD
      *
     C                   MOVEL     DRIF          DDDRIF
     C                   MOVEL     CRIF          DDCRIF
      *
     C     DDDRIF        IFEQ      'M'
     C     DDDRIF        OREQ      'T'
     C     DDDRIF        OREQ      'Q'
     C     DDDRIF        OREQ      'X'
     C     DDDRIF        OREQ      'Y'
     C                   MOVE      DRDY          DDDNCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDDNCD
     C                   ENDIF
      *
     C     DDCRIF        IFEQ      'M'
     C     DDCRIF        OREQ      'T'
     C     DDCRIF        OREQ      'Q'
     C     DDCRIF        OREQ      'X'
     C     DDCRIF        OREQ      'Y'
     C                   MOVE      CRDY          DDCNCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDCNCD
     C                   ENDIF
      *
     C     CRIC          IFEQ      *ZEROS
     C                   MOVE      *BLANKS       DDCRIC
     C                   ELSE
     C                   MOVE      CRIC          DDCRIC
     C                   ENDIF
      *
     C     NCID          IFNE      *ZEROS
     C                   CallB     'ZDATE2'
     C                   Parm      NCID          ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   Move      ZDATE         DDNCID
     C                   ELSE
     C                   MOVEL     *BLANKS       DDNCID
     C                   ENDIF
      *
     C     WWACK2        CHAIN     REIACXX                            99
      *
     C     *IN99         IFEQ      '0'
      *
     C     X_RCCY        IFEQ      DDCCY
      *
     C                   MOVEL     *BLANKS       DDDICT
     C     DICT          IFNE      *ZEROS
     C                   MOVE      DICT          DDDICT
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       DDCICT
     C     CICT          IFNE      *ZEROS
     C                   MOVE      CICT          DDCICT
     C                   ENDIF
      *
     C     DCST          IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       DDDCST
     C                   ELSE
     C                   MOVE      DCST          DDDCST
     C                   ENDIF
      *
     C     CCST          IFEQ      *ZEROS
     C                   MOVEL     *BLANKS       DDCCST
     C                   ELSE
     C                   MOVE      CCST          DDCCST
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** This moves the CurAcFilFmt retail defaults to CurAcMast.
     C                   Z-ADD     WprocDate     E_DACO
     C                   EXSR      SRCVTACC
      * Set action code in CurAcMast.
     C                   MOVE      WDACTN        @DDACTN
      ** Move the defaults to the screen fields.
     C                   MOVEL     CurAcMast     AccnInMast
     C                   MOVEL     CurAcDebi     AccnInDebi
     C                   MOVEL     CurAcCred     AccnInCred
     C                   MOVEL     CurAcComm     AccnInComm
     C                   MOVEL     CurAcOthe     AccnInOthe
      *
      ** Access customer details do default the correct client name
     C                   CALLB     'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   Eval      DDANAM = BBCRNM
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Proceed to the GL defaults if no RE default account was used.
      ** Test rightmost 130 characters of screen, if blank then default.
     C                   MOVE      AccnInMast    BLANKCHK
     C     BLANKCHK      IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           DDPTAD
     C                   MOVE      'N'           DDRAD
     C                   MOVE      'N'           DDRAC
     C                   MOVE      'N'           DDBAD
     C                   MOVE      'N'           DDBAC
      *
      ** Dft the Statement Freq to the value held on the GL ICD (SdGelr)
     C                   MOVE      BKDSFC        DDSTFQ
      *
      ** Access customer details
     C                   CALLB     'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ** Dft Account Name to Client Name
     C                   MOVE      BBCRNM        DDANAM
     C                   MOVE      BBCRNM        WWANAM           20
      *
      ** If Midas/Trade Innovation Interface is switched on then
      ** TI Account defaults to 'N' and other TI fields to blanks
     C     BGN3ST        IFEQ      'Y'
     C                   MOVE      'N'           DDTIAC
     C                   ENDIF
      *
     C     CRE007        IFEQ      'N'
     C                   MOVE      BBTAIN        DDITAX
     C                   ELSE
     C                   MOVE      'N'           DDITAX
     C                   ENDIF
      *
     C                   MOVE      R_TSTMC       DDSTCI
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTVACC - Retrieve Account
      *****************************************************************
     C     SRRTVACC      BEGSR
                                                                                            AR971184
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      *
      * Retrieve Account
      *
     C                   CALLB     'GLAMADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C**********         PARM                    FOTRID           20                        AR971184
     C                   PARM                    FOTRID           40                        AR971184
      * (Midas) Account Reference
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      * Commissions
     C                   PARM                    CommDisp
      * IBAN
     C                   PARM                    CFT004
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                     MD027217
      *
      ** New Accounts Currency
      *
     C                   PARM                    WDCCY
      * OUTPUTS :
      * (Current) Account in file format
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C                   PARM                    CARIFilFmt
     C                   PARM                    CACOFilFmt
     C                   PARM                    CAPWFilFmt
     C                   PARM                    CAPPFilFmt                                 MD027217
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Account Reference
     C                   PARM                    DDCUSNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    DDACODOK
     C                   PARM                    DDACSQOK
     C                   PARM                    DDBRCAOK
     C                   PARM                    DDACNOOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix
      * Base Rate Auth req
     C                   PARM                    AUTHRQ
      * Authorisation Mode
     C                   PARM                    AUTHMD
      *
     C     EndRTVACC     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCVTACC - Put a Account on the detial screens
      *****************************************************************
     C     SRCVTACC      BEGSR
      *
      * Call program to fill screen fields with data from master files
      *
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS :
      * Return Code
      * Account in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C                   PARM                    CARIFilFmt
     C                   PARM                    CACOFilFmt
     C                   PARM                    CAPWFilFmt
     C                   PARM                    CAPPFilFmt                                 MD027217
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis
     C                   PARM                    CDE002            1
      *
      * Retail Details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * OUTPUTS
      * Account - screen formats
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthr
     C                   PARM                    NewAcPena                                  MD027217
      *
      * Screen 1 Output
     C                   PARM                    DDDACC            6
     C                   PARM                    DDLINK           24
     C                   PARM                    DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM                    DODRCD            6
     C                   PARM                    DOPOLC            6
     C                   PARM                    DOPOLE            6
      *
      * Screen 3 Output
     C                   PARM                    DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1          12
     C                   PARM                    DDCRMG1          12
      *
      * Update 'Current' Account with Account in Screen Format
      *
     C                   MOVEL     NewAcPrim     CurAcMast
     C                   MOVEL     NewAcDebt     CurAcDebi
     C                   MOVEL     NewAcCrdt     CurAcCred
     C                   MOVEL     NewAcComm     CurAcComm
     C                   MOVEL     NewAcOthr     CurAcOthe
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Accnt5001
     C                   PARM                    Accnt5002
     C                   PARM                    Accnt5003
     C                   PARM                    Accnt5004
     C                   PARM                    Accnt5005
     C                   PARM                    ExtData500
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'REUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,GLAMADM01
 
      * Override SDAULGL0
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    CMDLEN
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access SAR details file to determine if CRE001 Overdraft
      ** interest calculations is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001            1
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   END
      *
      ** Access SAR file to determine if S01383 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     'S01383'      DBKEY                          *************
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     'N'           S01383            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSD012 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD012'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF
 
      ** If CSD012 is ON, Check if Account Authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'GLAMADSIN'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Account Authorisation is On set to Authorise
     C     SVAL11        IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ            1
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Portfolio Management
      ** or Private Banking Module
     C                   MOVE      *OFF          *IN28
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C                   OPEN      PMPORTLL
     C                   MOVE      *ON           *IN28
     C                   ENDIF
 
      *
      ** Access SAR details file to determine if CRT001 Retail
      ** Teller System is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001            1
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   END
 
      *
      ** Access SAR details file to determine if CRT101 Password on
      ** Retail Teller account facilities is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101            1
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   END
      *
      ** Access SAR details file to determine if CFT004 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   END
      *
      ** Access SAR details file to determine if CDE002 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   END
      *
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Postings Narrative) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU013'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Access SAR details file to determine if CRT002
      ** (Retail Branch Access) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002            1
     C                   ELSE
     C                   MOVEL     'N'           CRT002
     C                   END
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *Blanks
 
     C                   EVAL      CSC011 = 'Y'
 
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF
 
     C                   ELSE
      ** Database error
 
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSC022 switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *Blanks
 
     C                   EVAL      CSC022 = 'Y'
     C                   EVAL      WCMTSK = 'N'
 
     C                   IN        SCCMTJOB
 
     C                   IF        COMITNUM > 0
 
     C                   MOVEA     WCMTJOBS      WCMT
 
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0
     C                   EVAL      WCMTSK = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   IF        @RTCD <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC022'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Access SAR details file to determine if CRE007 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'CRE007'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CRE007            1
     C                   ELSE
     C                   MOVE      'N'           CRE007
     C                   END
      *                                                                                       CRE030
      ** Check if feature CRE030 is active                                                    CRE030
      *                                                                                       CRE030
     C                   CALL      'AOSARDR0'                                                 CRE030
     C                   PARM      '       '     @RTCD             7                          CRE030
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE030
     C                   PARM      'CRE030'      @SARD             6                          CRE030
     C*                                                                                       CRE030
     C                   IF        @RTCD = *BLANKS                                            CRE030
     C                   MOVE      'Y'           CRE030            1                          CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      'N'           CRE030                                       CRE030
     C                   ENDIF                                                                CRE030
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Retail ICD for Commissions
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                80
     C     *IN80         IFEQ      *ON
     C     R_RECI        ORNE      'D'
     C                   MOVEL     'TABTBRE '    DBFILE                         ************
     C                   MOVEL     '101'         DBASE                          * DBERR 101*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C                   IF        R_CDTO='Y' or R_CHOV='Y' or R_FXAC='Y'
     C                             or R_CNDS='Y' or R_CDRI='Y'
     C                             or R_CMBL='Y' or R_CINA='Y'
     C                   EVAL      CommDisp='Y'
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      **  GET RUNDAT to access multi-branching indicator on.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Define key list to access ACCPTFR
     C     PTFRK         KLIST
     C                   KFLD                    WWPTFR            4
     C**********         KFLD                    WWCNUM            6 0                        CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWCCY             3
     C                   KFLD                    WWACOD           10 0
     C                   KFLD                    WWACSQ            2 0
     C*
     C** Key list to access full account details from ACCNTLXX
     C*
     C     WWACKA        KLIST
     C                   KFLD                    WWBRCA
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWACSQ
      *
     C     ACODK         KLIST
     C                   KFLD                    WWACOK           10 0
     C                   KFLD                    WWRECI            1
      *                                                                                       CRE030
     C     ACODK2        KLIST                                                                CRE030
     C                   KFLD                    WWACOK                                       CRE030
     C                   KFLD                    WWRECI                                       CRE030
     C                   KFLD                    WWACCY            3                          CRE030
      *
     C     WWACKB        KLIST
     C                   KFLD                    WWBRCK            3
     C**********         KFLD                    WWCUSK            6 0                        CSD027
     C                   KFLD                    WWCUSK            6                          CSD027
     C                   KFLD                    WWCCYK            3
     C                   KFLD                    WWACOK           10 0
     C                   KFLD                    WWACSK            2 0
      *
     C     WWACK2        KLIST
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
     C                   KFLD                    WWBRCK
 
     C                   ENDSR
      *****************************************************************
