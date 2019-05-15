     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account maintenance interface controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADCTL - GL  Account Maintenance Interface Controller     *
      *                                                               *
      *  Function: This Program Validates GL Accounts for input into  *
      *            the Midas database.                                *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Account fields                    *
      *                them up from standard settlement instructions  *
      *            - For A (=Amend)                                   *
      *              - If it is valid, call a separate function to    *
      *                check whether it is a valid amendment          *
      *            - For X (=Authorise) call a separate function to   *
      *              process this Account and bypass the rest of the  *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this Account and bypass the rest of the  *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. LLN022A            Date 03Jun15               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CRE090             Date 14Feb14               *
      *                 AR850512           Date 28Apr14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR314589           Date 04Oct12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR899028           Date 25Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR847269           Date 09Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 256895             Date 30Sep08               *
      *                 247888             Date 18May07               *
      *                 245046             Date 27Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244450             Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 231128             Date 16Oct06               *
      *                 242488             Date 27Sep06               *
      *                 239720             Date 11May06               *
      *                 238839             Date 29Mar06               *
      *                 238639             Date 27Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 LLN022             Date 24Jan05               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201922             Date 14Dec01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 02Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 180721             Date 03May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 12Nov99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP035  *CREATE    Date 21Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR850512 - Some API uploaded JV's causes Midas+ to crash     *
      *             when enquired. Change OVRSCOPE to CALLLVL command *
      *             from ACCNTL1 to ACCNTL0. Apply fix 257391.        *
      *             (Child: AR850513)                                 *
      *           - Applied for MD023834                              *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR314589 - Duplicate GLAMAD requests cause failures in       *
      *             DBU_AMAD.                                         *
      *           - Amend SR/CHKVALMIAC to check on individual fields *
      *             and remove checking for numeric customer no.      *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256895 - Correct fields being written to GLVAMBXPD.          *
      *  247888 - Missing record in CLE025 files.                     *
      *  245046 - DBU_AMAD is dumping due to incorrect key.           *
      *  244450 - Correct parameters used to check accounts against   *
      *           valid file.                                         *
      *  231128 - Same fix as 242488.                                 *
      *  242488 - Write record in GLVAMBXPD for all RE accounts.      *
      *           Apply fix 239720/238639.                            *
      *  239720 - Write record in GLVAMBXPD for all RE accounts       *
      *           Applied 238639.                                     *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  238639 - Write record in GLVAMBXPD for all RE accounts       *
      *           Applied 231128                                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - Lux Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CSD012 - Standing Data Authorisation.                        *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  201922 - BRT catergory is validated for non-retail accounts  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Accounts
     FGLVAMADPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Accounts - Extension file
     FGLVAMBXPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Accounts - Retail Interest and charges file
     FGLVAMRIPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Accounts - Retail Commisions file
     FGLVAMCOPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Accounts - Password file
     FGLVAMPWPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Accounts
     FGLIAMADPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      ** GL Account Extension File                                                            247888
     FGLACNTL3  UF A E           K DISK    PREFIX(AX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
 
     F***GLVAMADL0 IF   E           K DISK    RENAME(GLVAMADD0:GLVAMADCHK)                    CGL029
     FGLVAMADL2 IF   E           K DISK    RENAME(GLVAMADD0:GLVAMADCHK)                       CGL029
     F                                     INFSR(*pssr)                         CAP013
     FGLVAMADL1 IF   E           K DISK    RENAME(GLVAMADD0:GLVAMADCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
     FTABTBRE   IF   E             DISK    INFSR(*pssr)
     F                                     PREFIX(R_)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLAMADC016
      *                                                                                       CER001
      ** Valid Account BoE details                                                           LLN022A
      *                                                                                      LLN022A
     FGLVAMADX0 UF A E             DISK    INFSR(*pssr)                                      LLN022A
     F                                     RENAME(GLVAMADD0:VAMADD0)                         LLN022A
     F                                     COMMIT                                            LLN022A
      *                                                                                      LLN022A
      ** Invalid Account BoE details                                                         LLN022A
      *                                                                                      LLN022A
     FGLIAMADX0 UF A E             DISK    INFSR(*pssr)                                      LLN022A
     F                                     RENAME(GLIAMADD0:IAMADD0)                         LLN022A
     F                                     COMMIT                                            LLN022A
     FGLVAMLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FGLIAMLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
 
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
      **    False      logical = *off (for indcator processing)
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
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
 
 
      * Valid Account layout
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
     D                                     PREFIX(V_)
      * Valid Extn. Account layout -> ACCNTBXC
     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(V_)
     D V_GLBXACOD    E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Extn. Account layout -> REIACD
     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(V_)
     D V_GLRIACOD    E                     EXTFLD(QQACOD)                                     CGL029
     D ValidExRI1              1    144                                                       CGL029
     D ValidExRIEx           212    284                                                       CGL029
      * Valid Extn. Account layout -> RECOMD
     D ValidExCO     E DS                  EXTNAME(GLVAMCOPD)
     D                                     PREFIX(V_)
     D V_GLCOACOD    E                     EXTFLD(QQACOD)                                     CGL029
     D ValidExCO1              1    286                                                       CGL029
     D ValidExCOEx           354    363                                                       CGL029
      * Valid Extn. Account layout -> REAPWDPD
     D ValidExPW     E DS                  EXTNAME(GLVAMPWPD)
     D                                     PREFIX(V_)
     D V_GLPWACOD    E                     EXTFLD(QQACOD)                                     CGL029
     D ValidExPW1              1     33                                                       CGL029
     D ValidExPWEx           101    110                                                       CGL029
 
 
     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(A_)
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(B_)
     D ExRIFilFmt1             1    144                                                       CGL029
     D ExRIFilFmtEx          146    218                                                       CGL029
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(C_)
     D ExCOFilFmt1             1    286                                                       CGL029
     D ExCOFilFmtEx          287    296                                                       CGL029
     D ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(D_)
     D ExPWFilFmt1             1     33                                                       CGL029
     D ExPWFilFmtEx           34     43                                                       CGL029
 
 
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
 
 
      * Error indicators
     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(GLAMIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** GL Extra Data - Classe 1 Data - File (D/B) format                                    CAP086
                                                                                              CAP086
 
     D ExtData       E DS                  EXTNAME(GLAMEXPD)
      * GL Accounts Extra Data - File (D/B) format
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(GLAMRXPD)                                  CER001
      *                                                                                       CER001
      ** GL Accounts Extra Data                                                               CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
      *                                                                                       CER001
      ** DS for Dealing Details                                                               CER001
      *                                                                                       CER001
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CER001
                                                                                              CER001
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
      *                                                                                       CER001
      ** Data Structure for CER001                                                            CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
      *                                                                                       CER001
     D  #1CNUM                 1      6                                                       CER001
     D  #1CCY                  7      9                                                       CER001
     D  #1ACOD                10     19                                                       CER001
     D  #1ACSQ                20     21                                                       CER001
     D  #1BRCA                22     24                                                       CER001
     D  #1ATYP                25     25                                                       CER001
     D  #1STFQ                26     26                                                       CER001
     D  #1AMNT                27     41  0                                                    CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
      *                                                                                       CER001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Accnt5001       S            500A
     D Accnt5002       S            500A
     D Accnt5003       S            500A
     D Accnt5004       S            500A
     D Accnt5005       S            500A
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                       CER001
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
 
 
      ** Overall Account status, to be passed to the Message Handler
     D AccnStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('GLAMADUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Field to tell whether Commissions are to be displayed
     D CommDisp        S              1A
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
     D*##OX2****       S              1    DIM(50) CTDATA PERRCD(50)                        AR850512
     D ##OX2           S              1    DIM(70) CTDATA PERRCD(70)                        AR850512
     D ##OX3           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX4           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX5           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepMast         S              1A   inz('N')
     D RepDebi         S              1A   inz('N')
     D RepCred         S              1A   inz('N')
     D RepComm         S              1A   inz('N')
     D RepOthe         S              1A   inz('N')
 
      ** Fields defined for enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D CAP086          S              1A                                                      CAP086
     D TRANSDTL        S           5800A                                                      CSC011
     D***PAcctNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PAcctNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** Fields Defined for CSD012                                                            CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqAccntMaint')                         CSD012
                                                                                              CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSD012
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D APFOTran40      S             40A                                                      CGL029
      *                                                                                       CER001
      ** Fields for enhancement CER001                                                        CER001
      *                                                                                       CER001
     D ULX004          S              1A                                                      CER001
     D ULX606          S              1A                                                      CER001
      *                                                                                       CER001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,GLAMADC017
      *                                                                                      LLN022A
      ** Valid Account Bank of England details layout                                        LLN022A
      *                                                                                      LLN022A
     D ValidBoE      E DS                  EXTNAME(GLVAMADX0)                                LLN022A
      *                                                                                      LLN022A
      ** OK Indicators for fields                                                            LLN022A
      *                                                                                      LLN022A
     D OKCuBoE       E DS                  EXTNAME(GLEAMADX0)                                LLN022A
      *                                                                                      LLN022A
      ** DATA Structure for passing data required further                                    LLN022A
      ** down the Call Stack                                                                 LLN022A
      *                                                                                      LLN022A
     D DATA            DS          1024                                                      LLN022A
     D ULBRCA                  1      3                                                      LLN022A
     D ULCNUM                  4      9                                                      LLN022A
     D ULCCY                  10     12                                                      LLN022A
     D ULACOD                 13     22                                                      LLN022A
     D ULACSQ                 23     24                                                      LLN022A
     D ULATYP                 25     25                                                      LLN022A
      *                                                                                       CER001
      ** Valid Extended Account in File Format                                                CER001
      *                                                                                       CER001
     D ValidFilExt   E DS                  EXTNAME(GLVAMLX1PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExt    E DS                  EXTNAME(GLEAMLX1PD)                                CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,GLAMADC001
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Accnt5001     AccnInMast
     C                   MOVEL     Accnt5002     AccnInDebi
     C                   MOVEL     Accnt5003     AccnInCred
     C                   MOVEL     Accnt5004     AccnInComm
     C                   MOVEL     Accnt5005     AccnInOthe
     C                   MOVEL     Infdata500    Infdata                                      CAP086
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,GLAMADC002
 
      *  Check if valid Account exists for Front Office ID
 
     C                   EXSR      ChkValAccn
      *
      *  If valid Account does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid Account exists for Midas Account Number                 CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiAc                                   CAP013
      *                                                                         CAP013
      *  If valid Account does exist (even after delay), fail this input        CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Accounts file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,GLAMADC003
 
      *  Validate Action Code
 
     C                   EXSR      ValidatAcn
      *
      /COPY WNCPYSRC,GLAMADC004
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,GLAMADC005
     C                   EXSR      ValidateAc
      /COPY WNCPYSRC,GLAMADC006
 
      *                                                                                      LLN022A
      ** If LLN007 is ON and other data is valid then                                        LLN022A
      ** validate Bank Of England Extra Data                                                 LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
     C     Idx           AndEq     0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed                                                            LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     DDBRCA        ULBRCA                                      LLN022A
     C                   MOVEL     DDCUSN        ULCNUM                                      LLN022A
     C                   MOVEL     DDCCY         ULCCY                                       LLN022A
     C                   MOVEL     DDACOD        ULACOD                                      LLN022A
     C                   MOVEL     DDACSQ        ULACSQ                                      LLN022A
     C                   MOVEL     AMATYP        ULATYP                                      LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'BYAMADW0VL'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      *                                                                                      LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    RespMode          1                         LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack                                               LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ExtData                                     LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKCuBoE                                     LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
      *                                                                                      LLN022A
      ** Valid Bank of England layout (DS) from/to caller                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
     C                   EndIf                                                               LLN022A
      *                                                                                      LLN022A
     C                   WHEN         DDACTN = 'A'
 
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        GHSUBS <> *blank
 
     C     GHSUBS        scan      AccnInMast                             99
     C                   if        *in99
     C                   eval      RepMast = 'Y'
     C                   endif
 
     C     GHSUBS        scan      AccnInDebi                             99
     C                   if        *in99
     C                   eval      RepDebi = 'Y'
     C                   endif
 
     C     GHSUBS        scan      AccnInCred                             99
     C                   if        *in99
     C                   eval      RepCred = 'Y'
     C                   endif
 
     C     GHSUBS        scan      AccnInComm                             99
     C                   if        *in99
     C                   eval      RepComm = 'Y'
     C                   endif
 
     C     GHSUBS        scan      AccnInOthe                             99
     C                   if        *in99
     C                   eval      RepOthe = 'Y'
     C                   endif
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if         RepMast = 'Y' OR RepDebi = 'Y' OR
     C                              RepCred = 'Y' OR RepComm = 'Y' OR
     C                              RepOthe = 'Y'
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
      **                 (End of "if GHSUBS <> *blank")
 
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,GLAMADC007
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,GLAMADC008
     C                   EXSR      ValidateAc
      /COPY WNCPYSRC,GLAMADC009
      *                                                                                      LLN022A
      ** If LLN007 is ON and other data is valid then                                        LLN022A
      ** validate Bank Of England Extra Data                                                 LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
     C     Idx           AndEq     0                                                         LLN022A
      *                                                                                      LLN022A
      ** Set Up DATA to be passed                                                            LLN022A
      *                                                                                      LLN022A
     C                   MOVEL     DDBRCA        ULBRCA                                      LLN022A
     C                   MOVEL     DDCUSN        ULCNUM                                      LLN022A
     C                   MOVEL     DDCCY         ULCCY                                       LLN022A
     C                   MOVEL     DDACOD        ULACOD                                      LLN022A
     C                   MOVEL     DDACSQ        ULACSQ                                      LLN022A
     C                   MOVEL     AMATYP        ULATYP                                      LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'BYAMADW0VL'                                              LLN022A
      *                                                                                      LLN022A
      ** INPUTS                                                                              LLN022A
      *                                                                                      LLN022A
      ** Response mode                                                                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    RespMode          1                         LLN022A
      *                                                                                      LLN022A
      ** Data required further down call stack                                               LLN022A
      *                                                                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details                                                             LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ExtData                                     LLN022A
      *                                                                                      LLN022A
      ** OUTPUTS                                                                             LLN022A
      *                                                                                      LLN022A
      ** Bank of England Details OK inds                                                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    OKCuBoE                                     LLN022A
      *                                                                                      LLN022A
      ** Error fields/message IDs/message data (arrays) from/to caller                       LLN022A
      *                                                                                      LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    Idx                                         LLN022A
      *                                                                                      LLN022A
      ** Warning fields/message IDs/message data (arrays) from/to caller                     LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
      *                                                                                      LLN022A
      ** Array index (3P0) from/to caller                                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    WIdx                                        LLN022A
      *                                                                                      LLN022A
      ** Valid Bank of England layout (DS) from/to caller                                    LLN022A
      *                                                                                      LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
      *                                                                                      LLN022A
     C                   EndIf                                                               LLN022A
      *                                                                                      LLN022A
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,GLAMADC010
 
     C                   ENDSL
      *
     C     INVALID       TAG
     C/COPY WNCPYSRC,GLH00700
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,GLAMADC011
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,GLAMADC012
     C                   IF        ULX606 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        DDACTN = 'I'                                               CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   EVAL      #1CNUM = DDCUSN                                            CER001
     C                   EVAL      #1CCY = DDCCY                                              CER001
     C                   EVAL      #1ACOD = DDACOD                                            CER001
     C                   EVAL      #1ACSQ = DDACSQ                                            CER001
     C                   EVAL      #1BRCA = DDBRCA                                            CER001
     C                   EVAL      #1ATYP = V_AMATYP                                          CER001
      *                                                                                       CER001
     C                   CALLB     'GLAMAD6VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    BNDCSP                                       CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C                   IF        Idx = 0                                                    CER001
     C                   EVAL      #6LXWECNUM = V_AMCNUM                                      CER001
     C                   EVAL      #6LXWECCYC = V_AMCCY                                       CER001
     C                   EVAL      #6LXWEACOD = V_AMACOD                                      CER001
     C                   EVAL      #6LXWEACSQ = V_AMACSQ                                      CER001
     C                   EVAL      #6LXWEBRCA = V_AMBRCA                                      CER001
     C                   EVAL      #6LXWEATYP = V_AMATYP                                      CER001
     C                   EVAL      #6LXWEFOTR = APFOTranID + APFOAsocID                       CER001
     C                   EVAL      #6LXWTMES  = Timestamp                                     CER001
     C                   IF        DDACTN <> 'I'                                              CER001
     C                   EVAL      #6LXWE1UAC = 0                                             CER001
     C                   EVAL      #6LXWELUSU = 0                                             CER001
     C                   EVAL      #6LXWELURA = 0                                             CER001
     C                   EVAL      #6LXWECOAM = 0                                             CER001
     C                   ENDIF                                                                CER001
     C                   WRITE     GLVAMLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C                   IF        Idx > 0 AND                                                CER001
     C                             APRprlocn = 'B'                                            CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,GLH00703
     C                   EVAL      #6LXFOTR = APFOTranID + APFOAsocID                         CER001
     C                   EVAL      #6LXTMES = TimeStamp                                       CER001
     C                   EVAL      #6LXCOBR = L6LXCOBR                                        CER001
     C                   EVAL      #6LXCOAC = L6LXCOAC                                        CER001
     C                   EVAL      #6LXCOAM = L6LXCOAM                                        CER001
     C                   EVAL      #6LXLUSU = L6LXLUSU                                        CER001
     C                   EVAL      #6LX1UAC = L6LX1UAC                                        CER001
     C                   WRITE     GLIAMLXD6                                                  CER001
     C/COPY WNCPYSRC,GLH00702
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,GLAMADC013
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLAMADC018
 
      *****************************************************************
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRClear -  Initialises Packed-type Variables to Zero         *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRClear       BEGSR                                                                CGL029
                                                                                              CGL029
     C                   EVAL      V_RINRCA = *ZEROS                                          CGL029
     C                   EVAL      V_RIRCA  = *ZEROS                                          CGL029
     C                   EVAL      V_RIMCLB = *ZEROS                                          CGL029
     C                   EVAL      V_RINOALT = *ZEROS                                         CGL029
     C                   EVAL      V_RITCHO = *ZEROS                                          CGL029
                                                                                              CGL029
     C                   EVAL      V_COFXDC = *ZEROS                                          CGL029
     C                   EVAL      V_COACCEA = *ZEROS                                         CGL029
     C                   EVAL      V_COACCC = *ZEROS                                          CGL029
     C                   EVAL      V_COGVDPE = *ZEROS                                         CGL029
     C                   EVAL      V_COGVDPC = *ZEROS                                         CGL029
     C                   EVAL      V_COACCRA = *ZEROS                                         CGL029
     C                   EVAL      V_COCACCC = *ZEROS                                         CGL029
     C                   EVAL      V_COCDIE = *ZEROS                                          CGL029
     C                   EVAL      V_COCDICA = *ZEROS                                         CGL029
     C                   EVAL      V_COCDRR = *ZEROS                                          CGL029
     C                   EVAL      V_COCCDIC = *ZEROS                                         CGL029
     C                   EVAL      V_COIACE = *ZEROS                                          CGL029
     C                   EVAL      V_COIACCC = *ZEROS                                         CGL029
     C                   EVAL      V_COCIACC = *ZEROS                                         CGL029
     C                   EVAL      V_COCMBE = *ZEROS                                          CGL029
     C                   EVAL      V_COCMBC = *ZEROS                                          CGL029
     C                   EVAL      V_COACCB = *ZEROS                                          CGL029
     C                   EVAL      V_COCCMBC = *ZEROS                                         CGL029
     C                   EVAL      V_COCHDBE = *ZEROS                                         CGL029
     C                   EVAL      V_COCHDBC = *ZEROS                                         CGL029
     C                   EVAL      V_COHDRB = *ZEROS                                          CGL029
     C                   EVAL      V_COCHDBR = *ZEROS                                         CGL029
     C                   EVAL      V_COCCHDBC = *ZEROS                                        CGL029
     C                   EVAL      V_COCCINST = *ZEROS                                        CGL029
     C                   EVAL      V_COVATAM = *ZEROS                                         CGL029
     C                   EVAL      V_CONOIS = *ZEROS                                          CGL029
     C                   EVAL      V_CONOCC = *ZEROS                                          CGL029
     C                   EVAL      V_COPESP = *ZEROS                                          CGL029
     C                   EVAL      V_CONOIP = *ZEROS                                          CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************                       CGL029
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValAccn - Routine to check if valid Account exists         *
      * for Front Office ID                                           *
      *                                                               *
      *****************************************************************
     C     ChkValAccn    BEGSR
 
      * Check for Account on Valid file
     C*****APFOTranID    CHAIN     GLVAMADL0                          99                      CGL029
     C                   EVAL      APFOTran40 = APFOTranID + APFOAsocID                       245046
     C     APFOTran40    CHAIN     GLVAMADL2                          99                      CGL029
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C*****APFOTranId    CHAIN     GLVAMADL0                          99                      CGL029
     C     APFOTran40    CHAIN     GLVAMADL2                          99                      CGL029
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiAc - Routine to check if valid Account exists for     *         CAP013
      *    Midas Account Number                                       *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiAc    BEGSR                                                  CAP013
                                                                                CAP013
      ** Key list for file GLVAMADL1                                            CAP013
     C     KMIACN        KLIST                                                  CAP013
     C                   KFLD                    KBRCA             3            CAP013
     C**********         KFLD                    KCNUM             6 0          CAP013        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KCCY              3            CAP013
     C**********         KFLD                    KACOD             4 0                 CAP013 CGL029
     C                   KFLD                    KACOD            10 0                        CGL029
     C                   KFLD                    KACSQ             2 0          CAP013
      *                                                                         CAP013
      **If*(numeric)*Midas*Customer*number*supplied********************              CAP013 AR314589
                                                                                CAP013
     C**********         TESTN                   DDCUSN               9898           CAP013 AR314589
                                                                                CAP013
      * If (numeric) Midas Account code supplied                                CAP013
                                                                                CAP013
     C                   TESTN                   DDACOD               9797      CAP013
                                                                                CAP013
      * If (numeric) Midas Account Sequence supplied                            CAP013
                                                                                CAP013
     C                   TESTN                   DDACSQ               9696      CAP013
                                                                                CAP013
     C*****DDACCN        IFNE      *BLANKS                                           CAP013 AR314589
     C******IN98         ANDEQ     '1'                                               CAP013 AR314589
      *                                                                                     AR314589
     C     DDCUSN        IFNE      *BLANKS                                                  AR314589
     C     DDBRCA        ANDNE     *BLANKS                                                  AR314589
     C     DDCCY         ANDNE     *BLANKS                                                  AR314589
     C     DDACOD        ANDNE     *BLANKS                                                  AR314589
     C     DDACSQ        ANDNE     *BLANKS                                                  AR314589
     C     *IN97         ANDEQ     '1'                                          CAP013
     C     *IN96         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for Account on Valid file                                         CAP013
     C                   MOVEL     DDBRCA        KBRCA                          CAP013
     C                   MOVEL     DDCUSN        KCNUM                          CAP013
     C                   MOVEL     DDCCY         KCCY                           CAP013
     C                   MOVEL     DDACOD        KACOD                          CAP013
     C**********         MOVEL     DDACOD        KACSQ                                 CAP013 244450
     C                   MOVEL     DDACSQ        KACSQ                                        244450
     C     KMIACN        CHAIN     GLVAMADL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     KMIACN        CHAIN     GLVAMADL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDACCN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidatAcn - Routine to validate action code versus the       *
      *    Account IDs supplied                                       *
      *                                                               *
      *****************************************************************
     C     ValidatAcn    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDACCN        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus account IDs supplied
      * This function will set the Midas account reference
      * The account in file format from the GL database is retrieved as well
 
     C                   RESET                   ReturnCode
     C                   EVAL      APFOTran40 = APFOTranID + APFOAsocID                       CGL029
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
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C**********         PARM                    APFOTranID                                   CGL029
     C                   PARM                    APFOTran40                                   CGL029
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
      * IBAN                                                                    CFT004
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    DDIBAN                                       238839
      *                                                                                       222373
      ** New Accounts Currency                                                                222373
      *                                                                                       222373
     C                   PARM                    WDCCY             3                          222373
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
     C                   PARM                    Idx
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
 
     C                   ENDSR
      *****************************************************************
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
     C**********         MOVEL     ExRIFilFmt    ValidExRI                                    CGL029
     C                   MOVEL     ExRIFilFmt1   ValidExRI1                                   CGL029
     C                   MOVEL     ExRIFilFmtEx  ValidExRIEx                                  CGL029
     C**********         MOVEL     ExCOFilFmt    ValidExCO                                    CGL029
     C                   MOVEL     ExCOFilFmt1   ValidExCO1                                   CGL029
     C                   MOVEL     ExCOFilFmtEx  ValidExCOEx                                  CGL029
     C**********         MOVEL     ExPWFilFmt    ValidExPW                                    CGL029
     C                   MOVEL     ExPWFilFmt1   ValidExPW1                                   CGL029
     C                   MOVEL     ExPWFilFmtEx  ValidExPWEx                                  CGL029
 
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
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002            1            CDE002
      *                                                                         CDE002
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
      *
      * Screen 1 Output
     C                   PARM      *BLANK        DDDACC            6
     C**********         PARM      *BLANK        DDLINK           18                          CGL029
     C                   PARM      *BLANK        DDLINK           24                          CGL029
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
     C                   PARM      *BLANK        DDDRMG1          12            CDE002
     C                   PARM      *BLANK        DDCRMG1          12            CDE002
 
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
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C     V_AMATYP      IFEQ      'R'                                                        201922
      * Validate Account debit details
 
     C                   EXSR      ValdAcDebi
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account credit details
 
     C                   EXSR      ValdAcCred
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account commission details
 
     C                   EXSR      ValdAcComm
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Account other details
 
     C                   EXSR      ValdAcOthe
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
     C                   ENDIF                                                                201922
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcMast - Validate Account Master details                  *
      *                                                               *
      *****************************************************************
     C     ValdAcMast    BEGSR
 
     C                   EVAL      APFOTran40 = APFOTranID + APFOAsocID                       CGL029
                                                                                              CGL029
     C                   CALLB     'GLAMAD1VL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    APRESPMODE
 
      * Screen Format
     C                   PARM      '  '          WFMT              2
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Master details
     C                   PARM                    AccnInMast
                                                                                180721
      ** Front Office Id                                                        180721
     C**********         PARM                    APFOTranID                            180721 CGL029
     C                   PARM                    APFOTran40                                   CGL029
      ** Account Master Details OK inds
     C                   PARM                    OKAcMast
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Full GL Account Number
     C**********         PARM      *BLANKS       WGLKEY           18                          CGL029
     C                   PARM      *BLANKS       WGLKEY           24                          CGL029
      * IBAN Sequence                                                           CFT004
     C                   Parm                    DDIBSQ            3            CFT004
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidEXBX
                                                                                              CSD012
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
                                                                                              CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcDebi - Validate Account Debit details                   *
      *                                                               *
      *****************************************************************
     C     ValdAcDebi    BEGSR
 
     C                   EVAL      APFOTran40 = APFOTranID + APFOAsocID                       CGL029
                                                                                              CGL029
     C                   CALLB     'GLAMAD2VL'
 
      * INPUTS
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Debit details
     C                   PARM                    AccnInDebi
                                                                                              208221
      ** Account Commission details                                                           208221
     C                   PARM                    AccnInComm                                   208221
                                                                                180721
      ** Front Office Id                                                        180721
     C**********         PARM                    APFOTranID                            180721 CGL029
     C                   PARM                    APFOTran40                                   CGL029
 
      ** Account Debit Details OK inds
     C                   PARM                    OKAcDebi
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
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
      * Revenue Analysis                                                                      208221
     C                   PARM                    CDE002                                       208221
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
 
     C                   EVAL      APFOTran40 = APFOTranID + APFOAsocID                       CGL029
                                                                                              CGL029
     C                   CALLB     'GLAMAD3VL'
 
      ** Account Master details
     C                   PARM                    AccnInMast
 
      ** Account Credit details
     C                   PARM                    AccnInCred
                                                                                              208221
      ** Account Commission details                                                           208221
     C                   PARM                    AccnInComm                                   208221
 
      ** ICD
     C                   PARM                    R_TCAL
                                                                                180721
      ** Front Office Id                                                        180721
     C**********         PARM                    APFOTranID                            180721 CGL029
     C                   PARM                    APFOTran40                                   CGL029
 
      ** Account Credit details OK inds
     C                   PARM                    OKAcCred
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
     C                   PARM                    WFldNamArr                                 AR847249
     C                   PARM                    WMsgIDArr                                  AR847249
     C                   PARM                    WMsgDtaArr                                 AR847249
      ** Array index (3P0) from/to caller                                                   AR847249
     C                   PARM                    WIdx                                       AR847249
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExBX                                    208221
      * Revenue Analysis                                                                      208221
     C                   PARM                    CDE002                                       208221
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
 
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                CDE002
      ** Account Commissions OK inds
     C                   PARM                    OKAcComm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              208221
      * Warning fields/message IDs/message data (arrays) from/to caller                       208221
     C                   PARM                    WFldNamArr                                   208221
     C                   PARM                    WMsgIDArr                                    208221
     C                   PARM                    WMsgDtaArr                                   208221
      * Array index (3P0) from/to caller                                                      208221
     C                   PARM                    WIdx                                         208221
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidExCO
 
      * Valid Account layout (Extension file) (DS) from/to caller               CDE002
     C                   PARM                    ValidExBX                      CDE002
      * Valid Account layout (DS) from/to caller                                208221
     C                   PARM                    ValidAccn                      208221
      *                                                                         CDE002
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
     C                   PARM                    Idx
 
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
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend, "C" for Change.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
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
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcMast
     C                   PARM                    OKAcDebi
     C                   PARM                    OKAcCred
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthe
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
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *  - If there are no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Account status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report Account status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
     C     Idx           IFEQ      0
 
     C                   EXSR      SETUPVALID
     C                   WRITE     GLVAMADD0
     C                   IF        DDACTN <> 'D'
     C********           IF        CRE001='Y' and V_AMATYP='R'                                238639
     C********                     or (CDE002 = 'Y' and V_AMATYP = 'R')                CDE002 238639
     C                   IF        V_AMATYP='R'                                               238639
     C/COPY WNCPYSRC,GLAMADCC04
      *                                                                                       245046
     C**********         EVAL      V_BXCNUM = KCNUM                                    245046 256895
     C                   EVAL      V_BXCNUM = DDCUSN                                          256895
     C                   EVAL      V_BXCCY  = DDCCY                                           245046
     C**********         EVAL      V_BXACOD = KACOD                                    245046 256895
     C                   EVAL      V_BXACOD = V_AMACOD                                        256895
     C**********         EVAL      V_BXACSQ = KACSQ                                    245046 256895
     C                   EVAL      V_BXACSQ = V_AMACSQ                                        256895
     C                   EVAL      V_BXBRCA = DDBRCA                                          245046
      *                                                                                       245046
     C                   EVAL      V_BXFRNT = APFOTranID
     C                   EVAL      V_BXAFRT = APFOAsocID
     C                   EVAL      V_BXTMES = TimeStamp
     C                   WRITE     GLVAMBXD0
     C                   END
     C                   IF        V_AMATYP='R'
     C                   EVAL      V_RIFRNT = APFOTranID
     C                   EVAL      V_RIAFRT = APFOAsocID
     C                   EVAL      V_RITMES = TimeStamp
     C                   WRITE     GLVAMRID0
     C                   END
     C                   IF        CommDisp='Y' and V_AMATYP='R'
     C                   EVAL      V_COFRNT = APFOTranID
     C                   EVAL      V_COAFRT = APFOAsocID
     C                   EVAL      V_COTMES = TimeStamp
     C                   WRITE     GLVAMCOD0
     C                   END
     C                   IF        CRT101='Y' and CRT001='Y'
     C                              and V_AMATYP='R' and V_AMSTYP='S'
     C                   EVAL      V_PWFRNT = APFOTranID
     C                   EVAL      V_PWAFRT = APFOAsocID
     C                   EVAL      V_PWTMES = TimeStamp
     C                   WRITE     GLVAMPWD0
     C                   END
     C/COPY WNCPYSRC,GLAMADCC01
      *                                                                                      LLN022A
      ** If LLN007 is ON then write to valid Extra Data file.                                LLN022A
      ** Valid file fields are set up from return from extra                                 LLN022A
      ** validation module.                                                                  LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
      *                                                                                      LLN022A
     C                   EVAL      LVBRCD = V_AMBRCA                                         LLN022A
     C                   EVAL      LVCNUM = V_AMCNUM                                         LLN022A
     C                   EVAL      LVCCY  = V_AMCCY                                          LLN022A
     C                   EVAL      LVACOD = V_AMACOD                                         LLN022A
     C                   EVAL      LVACSQ = V_AMACSQ                                         LLN022A
     C                   EVAL      LVTMST = TimeStamp                                        LLN022A
     C                   Eval      LVAFRT = APFOTRANID                                       LLN022A
     C                   Eval      LVREPA = APRprLocn                                        LLN022A
      *                                                                                      LLN022A
     C                   WRITE     VAMADD0                                                   LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF
                                                                                              247888
      ** Insert GLACNTQD record for CLE025 processing                                         247888
                                                                                              247888
     C     R1KEY         KLIST                                                                247888
     C                   KFLD                    AC_CNUM           6                          247888
     C                   KFLD                    AC_CCY            3                          247888
     C                   KFLD                    AC_ACOD          10 0                        247888
     C                   KFLD                    AC_ACSQ           2 0                        247888
     C                   KFLD                    AC_BRCA           3                          247888
                                                                                              247888
     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
     C                   MOVEL     DDCUSN        AC_CNUM                                      247888
     C                   MOVEL     DDCCY         AC_CCY                                       247888
     C                   MOVEL     DDACOD        AC_ACOD                                      247888
     C                   MOVEL     DDACSQ        AC_ACSQ                                      247888
     C                   MOVEL     DDBRCA        AC_BRCA                                      247888
     C     R1KEY         CHAIN     GLACNTL3                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      AX_F1CNUM = AC_CNUM                                        247888
     C                   EVAL      AX_F1CCY  = AC_CCY                                         247888
     C                   EVAL      AX_F1ACOD = AC_ACOD                                        247888
     C                   EVAL      AX_F1ACSQ = AC_ACSQ                                        247888
     C                   EVAL      AX_F1BRCA = AC_BRCA                                        247888
     C                   WRITE     GLACNTD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C/COPY WNCPYSRC,GLH00704
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
      *
     C     APRprLocn     IFEQ      'B'
     C                   WRITE     GLIAMADD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = AccnInMast +                                    CSC011
     C                                        AccnInDebi +                                    CSC011
     C                                        AccnInCred +                                    CSC011
     C                                        AccnInComm +                                    CSC011
     C                                        AccnInOthe +                                    CSC011
     C                                        RegData    +                                    CER001
     C                                        ExtData                                         CSC011
     C                   EVAL      APTGTTYPE = 'GLAMAD'                                       CSC011
     C                   EVAL      PAcctNum = DDACCN                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PAcctNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PAcctNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 2                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,GLAMADCC02
      *                                                                                      LLN022A
      ** If LLN007 is ON then write to Invalid Extra                                         LLN022A
      ** Data file.                                                                          LLN022A
      *                                                                                      LLN022A
     C     LLN007        IfEq      'Y'                                                       LLN022A
      *                                                                                      LLN022A
     C                   EVAL      LITMST = TimeStamp                                        LLN022A
     C                   Eval      LIAFRT = APFOTRANID                                       LLN022A
     C                   Eval      LIREPA = APRprLocn                                        LLN022A
     C                   EVAL      LIBRCD = V_AMBRCA                                         LLN022A
     C                   MOVE      V_AMCNUM      LICNUM                                      LLN022A
     C                   EVAL      LICCY  = V_AMCCY                                          LLN022A
     C                   MOVE      V_AMACOD      LIACOD                                      LLN022A
     C                   MOVE      V_AMACSQ      LIACSQ                                      LLN022A
     C                   EVAL      LINETI = NETI                                             LLN022A
     C                   EVAL      LIDPTP = DPTP                                             LLN022A
     C                   EVAL      LISNOD = SNOD                                             LLN022A
     C                   EVAL      LILNTP = LNTP                                             LLN022A
     C                   EVAL      LIMDAT = MDAT                                             LLN022A
     C                   EVAL      LILLIM = LLIM                                             LLN022A
      *                                                                                      LLN022A
     C                   WRITE     IAMADD0                                                   LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF
     C                   EXSR      CallMsgHdl
     C/COPY WNCPYSRC,GLH00705
     C                   ENDIF
 
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
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
     C                   RESET                   Idx
 
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
     C                   EXSR      SRClear                                                    CGL029
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                              CAP086
      ** Setup the Automatic Autorisation Flag                                                CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      AccnStatus = 'F'
 
      /COPY WNCPYSRC,GLAMADC014
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
     C                   ENDIF
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_AMCHTP = DDACTN
     C                   EVAL      V_AMIBAN = DDIBAN                              CFT004
     C                   EVAL      V_AMIBSEQN = DDIBSQ                            CFT004
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_AMFRNT = APFOTranID
     C                   EVAL      V_AMAFRT = APFOAsocID                                      CGL029
     C                   EVAL      V_AMREPA = APRprLocn
     C                   EVAL      V_AMTMST = TimeStamp
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AMAUTH = IF_AUTH                                           CAP086
     C                   ENDIF                                                                CAP086
 
     C                   EVAL      AccnStatus = 'S'
 
      /COPY WNCPYSRC,GLAMADC015
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C**********         CALLB     'ZAMSGHNDLE'                                               CGL029
     C                   CALLB     'ZAMSGHNDL2'                                               CGL029
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Account repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Associate Front office transaction dentifier (20A, from caller)                      CGL029
     C                   PARM                    APFOAsocID                                   CGL029
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDCUSN
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    AccnStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       begsr
 
      ** Fill file fields to convert to screen format
     C                   MOVEL     AccnFilFmt    ValidAccn
     C                   MOVEL     ExBXFilFmt    ValidExBX
     C**********         MOVEL     ExRIFilFmt    ValidExRI                                    CGL029
     C                   MOVEL     ExRIFilFmt1   ValidExRI1                                   CGL029
     C                   MOVEL     ExRIFilFmtEx  ValidExRIEx                                  CGL029
     C**********         MOVEL     ExCOFilFmt    ValidExCO                                    CGL029
     C                   MOVEL     ExCOFilFmt1   ValidExCO1                                   CGL029
     C                   MOVEL     ExCOFilFmtEx  ValidExCOEx                                  CGL029
     C**********         MOVEL     ExPWFilFmt    ValidExPW                                    CGL029
     C                   MOVEL     ExPWFilFmt1   ValidExPW1                                   CGL029
     C                   MOVEL     ExPWFilFmtEx  ValidExPWEx                                  CGL029
 
      ** Convert file fields to screen format
     C                   reset                   RetCodeIn
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
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002            1            CDE002
      *                                                                         CDE002
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
      *
      * Screen 1 Output
     C                   PARM      *BLANK        DDDACC            6
     C**********         PARM      *BLANK        DDLINK           18                          CGL029
     C                   PARM      *BLANK        DDLINK                                       CGL029
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
     C                   PARM      *BLANK        DDDRMG1                        CDE002
     C                   PARM      *BLANK        DDCRMG1                        CDE002
 
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the field values that were set earlier.
 
     C                   if        RepMast = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      AccnInMast    IncData        2000
      * Current Data
     C                   PARM      CurAcMast     CurData        2000
 
     C                   MOVEL     IncDATA       AccnInMast
 
     C                   endif
 
     C                   if        RepDebi = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      AccnInDebi    IncData
      * Current Data
     C                   PARM      CurAcDebi     CurData
 
     C                   MOVEL     IncDATA       AccnInDebi
 
     C                   endif
 
     C                   if        RepCred = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      AccnInCred    IncData
      * Current Data
     C                   PARM      CurAcCred     CurData
 
     C                   MOVEL     IncDATA       AccnInCred
 
     C                   endif
 
     C                   if        RepComm = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      AccnInComm    IncData
      * Current Data
     C                   PARM      CurAcComm     CurData
 
     C                   MOVEL     IncDATA       AccnInComm
 
     C                   endif
 
     C                   if        RepOthe = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      AccnInOthe    IncData
      * Current Data
     C                   PARM      CurAcOthe     CurData
 
     C                   MOVEL     IncDATA       AccnInOthe
 
     C                   endif
 
     C                   endsr
 
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,GLAMADCC05
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Accnt5001
     C                   PARM                    Accnt5002
     C                   PARM                    Accnt5003
     C                   PARM                    Accnt5004
     C                   PARM                    Accnt5005
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    InfData500                                   CAP086
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'REUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C/COPY WNCPYSRC,GLAMADCC03
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'GL'
 
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
      *                                                                         CFT004
      ** Access SAR details file to determine if CFT004 is on.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
      *                                                                         CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004            1            CFT004
     C                   ELSE                                                   CFT004
     C                   MOVEL     'N'           CFT004                         CFT004
     C                   END                                                    CFT004
      *
      ** Access SAR details file to determine if CDE002 is on.                  CDE002
      *                                                                         CDE002
     C                   CALLB     'AOSARDR0'                                   CDE002
     C                   PARM      *BLANKS       @RTCD                          CDE002
     C                   PARM      '*VERIFY'     @OPTN                          CDE002
     C                   PARM      'CDE002'      @SARD                          CDE002
     C     SCSARD        PARM      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C     @RTCD         IFEQ      *BLANK                                       CDE002
     C                   MOVEL     'Y'           CDE002            1            CDE002
     C                   ELSE                                                   CDE002
     C                   MOVEL     'N'           CDE002                         CDE002
     C                   END                                                    CDE002
      *                                                                         CDE002
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBase = 1                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if CSD012 is installed                                                         CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Account Authorisation is ON                                CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     3             DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'GLAMADCTL'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Account Authorisation is On set to Authorise                                      CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 4                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      ** Access Retail ICD for Commissions
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
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
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APAMADDTQ'
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLAMADCTL'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 5                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
 
     C* Overrride ACCBR
     C                   Z-ADD     50            MESLEN           15 5
     C                   Z-ADD     70            MESLEN1          15 5                      AR850512
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C* Overrride ACCNTL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX2
     C***********        PARM                    MESLEN                                     AR850512
     C                   PARM                    MESLEN1                                    AR850512
     C* Overrride REIAC
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
     C* Overrride RECOM
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
     C* Overrride REAPWDL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLAMADC019
      *                                                                                      LLN022A
      ** Access SAR details file to determine if Bank of England is                          LLN022A
      ** switched on                                                                         LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
     C     @RTCD         IFEQ      *BLANK                                                    LLN022A
     C                   MOVEL     'Y'           LLN007            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVEL     'N'           LLN007                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   EVAL      ULX004 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX004 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX606 - API Luxembourg - Function GLAMAD                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX606 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS AND                                        CER001
     C                             ULX004 = 'Y'                                               CER001
     C                   EVAL      ULX606 = 'Y'                                               CER001
     C                   OPEN      GLVAMLX1PD                                                 CER001
     C                   OPEN      GLIAMLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access Dealing details via access program                                            CER001
      ** (database error handling done in access program)                                     CER001
      *                                                                                       CER001
     C                   CALLB     'AODEALR0'                                                 CER001
     C                   PARM      '*DBERR '     @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        CER001
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
 
     C                   ENDSR
      *****************************************************************
      *                                                                                     AR850512
      ** Add OVRSCOPE(*CALLLVL) for ##OX2                                                   AR850512
      *                                                                                     AR850512
**  CPY@
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)
** ##OX2
OVRDBF FILE(ACCNTL1) TOFILE(ACCNTL0) SHARE(*NO) OVRSCOPE(*CALLLVL)                          AR850512
** ##OX3
OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)
** ##OX4
OVRDBF FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)
** ##OX5
OVRDBF FILE(REAPWDL1) TOFILE(REAPWDL0) SHARE(*NO)
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
