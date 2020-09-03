     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Controller')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCCTL - LE Repayments Schedule - Controller              *
      *                                                               *
      *  Function: This Program Validates Repayments schedule for     *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the repayment sch. details fields     *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this repayment sch. and bypass the rest  *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE154             Date 02Aug12               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      *                 247540             Date 03May07               *
      *                 246772             Date 30Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG4960            Date 22Dec04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA070             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      *                 CAP084             Date 31Jul03               *
      *                 CAP079  *CREATE    Date 14Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  247540 - Do not hard code RespMode.                          *
      *  246772 - Wrong EXTdata format - LERPEXPD                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Changes for MidasPlus                               *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
      *
     FLEVRPSCPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      *
     FLEIRPSCPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FLEVRPSCL0 IF   E           K DISK
     F                                     RENAME(LEVRPSCD0:LEVRPSCL00)
      *
     FLEVRPSCL1 IF   E           K DISK
     F                                     RENAME(LEVRPSCD0:LEVRPSCL01)
      *
     FAPIDSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ***  Hook to enable non-core files to be included
      /COPY WNCPYSRC,LERPSCC001
      *
      *****************************************************************
      *  +--------------------------------------+
      *    Automatically included D-specs        
      *    ==============================        
      *  +--------------------------------------+
      *
      *  Standard D-specs
      *  ================
      *
      *  The following /COPY line includes the LDA layout,
      *  the copyright array definition,
      *  and the following named constants:
      *     True       logical = *on (for indcator processing)
      *     False      logical = *off (for indcator processing)
      *     DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      *                                     handler)
      *  and the following variables:
      *     RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      *  Program Status Data Structure
      *  =============================
      *  The following /COPY line includes all the defined fields in the
      *  PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *  The following /COPY line includes definitions for the above fields
      *  as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      *  corresponding fields in the PSDS /COPY member, so that member
      *  must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for error and
      *  warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      * --------------------------------------------------------------------------------------------
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for arrays
      *  specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      * --------------------------------------------------------------------------------------------
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for fields
      *  used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      * --------------------------------------------------------------------------------------------
      *
      *  +--------------------------------------+
      *    End of automatically included D-specs 
      *    ===================================== 
      *  +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  +--------------------------------------+
      *    Manually included D-specs             
      *    =========================             
      *  +--------------------------------------+
      *
      *  +--------------------------------------+
      *    Named constants                       
      *    ===============                       
      *  +--------------------------------------+
      *
      ***  String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      *
      *  +--------------------------------------+
      *    Arrays and Data Structures            
      *    ==========================            
      *  +--------------------------------------+
      *
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      ***  Incoming Header
      *
     D TransIncom    E DS                  EXTNAME(LERPSCPD)
      ***  Incoming Transaction
      *
     D ValidRpSc     E DS                  EXTNAME(LEVRPSCPD)
      ***  Valid repayments sch. layout
     D                                     PREFIX(V_)
     D***ValidREC             321    389                                                      CGL029
     D***ValidPAY             390    948                                                      CGL029
     D  ValidREC             335    389                                                       CGL029
     D  ValidPAY             404    948                                                       CGL029
     D  ValidRECEx          1195   1212                                                       CGL029
     D  ValidPAYEx          1213   1230                                                       CGL029
      *
     D RpScFilFmt    E DS                  EXTNAME(LOAMSDK)
      ***  (Current) Repayment Schedule in file Format
     D                                     PREFIX(RP_)
     D***RpScFilREC           321    389                                                      CGL029
     D***RpScFilPAY           390    948                                                      CGL029
     D  RpScFilREC           335    389                                                       CGL029
     D  RpScFilPAY           404    948                                                       CGL029
     D  RpScFilRECEx        1195   1212                                                       CGL029
     D  RpScFilPAYEx        1213   1230                                                       CGL029
      *
     D CurRpScCF     E DS                  EXTNAME(LERPSCPD)
      ***  (Current) Screen Format
     D                                     PREFIX(@)
      *
     D OKRpSc        E DS                  EXTNAME(LEERPSCPD)
      ***  Error indicators
      *
     D L_REC         E DS                  EXTNAME(SDESFRPD)
      ***  File Receive instructions
     D***FLREC**                1     69                                                      CGL029
     D  FLREC                 21     75                                                       CGL029
      *
     D L_PAY         E DS                  EXTNAME(SDESFPPD)
      ***  File Payment instructions
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY                 21    565                                                       CGL029
      *
     D L_FRI         E DS                  EXTNAME(SDESFFPD)
      ***  File Fra/irs instructions
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
      * LE Extra Data - Classe 1 Data - File (D/B) format                                     CAP086
     D                                     PREFIX(IF_)                                        CAP086
      *
     D S_REC         E DS                  EXTNAME(SDESSRPD)
      ***  Screen Receive instructions
      *
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
      * Screen Payment instructions
      *
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
      ***  Screen Fra/irs instructions
      *
     D C_REC         E DS                  EXTNAME(SDESSRPD) PREFIX(C_)
      ***  Current Screen Receive instructions
      *
     D C_PAY         E DS                  EXTNAME(SDESSPPD) PREFIX(C_)
      ***  Current Screen Payment instructions
      *
     D C_FRA         E DS                  EXTNAME(SDESSFPD) PREFIX(C_)
      ***  FRA/IRS Settlement Instructions - Current
      *
     D OKPayInsDS      DS
      ***  Flags to indicate whether Pay Settlement instruction fields
      ***  are valid
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
     D  DDPmacOK                      1A   INZ('Y')                                           CLE031
     D  DDPexrOK                      1A   INZ('Y')                                           CLE031
     D  DDPexiOK                      1A   INZ('Y')                                           CLE031
      *
     D OKRecInsDS      DS
      ***  Flags to indicate whether Receive Settlement instruction fields
      ***  are valid
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
     D  DDRmacOK                      1A   INZ('Y')                                           CLE031
     D  DDRexrOK                      1A   INZ('Y')                                           CLE031
     D  DDRexiOK                      1A   INZ('Y')                                           CLE031
      *
     D OKFRAInsDS      DS
      ***  Flags to indicate whether FRA/IRS instruction fields are valid
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for Bank Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for Midas modules details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ***  External DS for API ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  External DS for SAR details
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
      *
     D***ExtData     E DS                  EXTNAME(LECLEXPD)
     D ExtData       E DS                  EXTNAME(LERPEXPD)                                  246772
      ***  Repayment Sch. Extra Data - File (D/B) format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs - short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs - long data structure
      *
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***WSPI1**               35     64                                                      CGL029
     D***WSPI2**               65     94                                                      CGL029
     D***WSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  WSPI1                 41     70                                                       CGL029
     D  WSPI2                 71    100                                                       CGL029
     D  WSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D PTranID         DS            20
      ***  Midas transaction ID for the Message Handling module "CallMsgHdl"
     D  PLNRFId                1      6
     D  PVDATId                7     12
     D  PLASNId               13     15
      *
      *
      *  +--------------------------------------+
      *    Declared variables                    
      *    ==================                    
      *  +--------------------------------------+
      *
      ***  Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
      *
      ***  Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
      ***  Index for arrays of warning message ids etc
     D WIdx            S              3P 0
      *
      ***  Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
      *
      ***  Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
      *
      ***  Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
      *
      ***  Indicies for arrays used to set up corresponding sequence numbers
      ***  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
      *
      ***  Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
      *
      ***  Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
      *
      ***  Timestamp for the transaction
     D TimeStamp       S             26Z
      *
     D Object          S             10A   INZ('LERPSCUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
      *
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
      ***  Whether or not to clear the program message queue (this is not
      ***  actually used, but is required by the message handler's parameter
      ***  list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      *
      ***  Flags to indicate whether substitution is required in
      ***  each of the various parts the transaction
     D RepScrn         S              1A   inz('N')
 
      ** Parameters for ZASETINDFT
     D BQISDA          S              4
     D BQAGTY          S              6
     D BQAGDT          S              6
     D BQAGVV          S              2
     D Blank2          S              2
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                               TDA070 BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
     D CAP086          S              1A                                                      CAP086
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      *
      *  +--------------------------------------+
      *    End of D-specs                        
      *    ==============                        
      *  +--------------------------------------+
      *
      *  +----------------------------------------+
      *    Hook for non-core D-specs (all types)   
      *    also any I-specs (if necessary)         
      *    =====================================   
      *  +----------------------------------------+
      /COPY WNCPYSRC,LERPSCC002
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  +--- Start of Main processing -----------------------------------+
      *                                                                    
      *    Initial processing is performed automatically: the *INZSR is    
      *    executed at program activation.                                 
      *                                                                    
      *  +----------------------------------------------------------------+
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC003
      *
      ***  Incoming transaction is broken into 500A fields, so that a common CL
      ***  can be used between this module and the one that read the MQ queue.
      ***  This module needs to break these 500A fields by loading them into
      ***  the appropriate (externally described) data structure.
      *
     C                   MOVEL     Trans5001     TransIncom
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Extdata500    Extdata
      *
      ***  Generate a timestamp for this transaction
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
      ***  Reset variables gradually updated
      *
     C                   EXSR      ResetCycle
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC004
      *
      ***  Check if valid repayment sch. details exists
      *
     C                   EXSR      ChkValRpSc
      *
      ***  If repayment Sch. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Check if valid repayment sch. exists for Midas
      *
     C                   EXSR      ChkValMiRS
      *
      ***  If valid repayment sch. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Reset variables again in case the details have been corrupted
      ***  by previous chain to valid repayment sch. details file.
      *
     C                   EXSR      ResetCycle
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC005
      *
      ***  Validate Action Code
      *
     C                   EXSR      ValidateAc
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC006
      *
      ***  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      Invalid
     C                   END
      *
      ***  Processing depends upon Action Code
      *
     C                   SELECT
      *
     C                   WHEN         DDACTN = 'I'
      *
      ***  Processing for Inserts
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC007
     C                   EXSR      ValidateTr
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC008
      *                                                                                      BUG8529
      ** Default settlement details from related loan                                        BUG8529
     C                   IF        S_Rec = *blank AND                                        BUG8529
     C                             S_Pay = *blank AND                                        BUG8529
     C                             PRcvParm <> *blank AND                                    BUG8529
     C                             PPayParm <> *blank                                        BUG8529
     C                   MOVEL     PRcvParm      S_Rec                                       BUG8529
     C                   MOVEL     PPayParm      S_Pay                                       BUG8529
     C                   EndIf                                                               BUG8529
 
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateSt
      *
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'R'
      *
      ***  Processing for Amends or Changes
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC009
      *
      ***  Check for the existence of the replacement character; if this is
      ***  used, only the changed data has been sent, and all occurrences of
      ***  the replacement character must be replaced with the corresponding
      ***  character from the original transaction.
      *
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
      *
     C     GHSUBS        scan      TransIncom                             99
     C                   if        *in99
     C                   eval      RepScrn = 'Y'
     C                   endif
      *
      ***  If any of the flags set above is true, do the data
      ***  substution subroutine.
      *
     C                   if        (RepScrn = 'Y')
     C                   EXSR      DtaSubs
     C                   endif
      *
     C                   endif
      *
     C                   EXSR      SetupAmd
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC010
     C                   EXSR      ValidateTr
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC011
     C                   EXSR      ValidateSt
     C                   EXSR      ValdateAmd
      *
     C                   ENDSL
      *
     C     Invalid       TAG
      *
      ***  Check for exception error from any program lower in the stack
      ***  If error detected, send message to system operator and
      ***  return to calling program without updating database or
      ***  prompting the database update program
      *
     C                   IN        APDUMP
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC012
      *
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
      *
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
     C                   ELSE
      *
      ***  Processing for Error checking/write to database
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC013
     C                   EXSR      CheckWrite
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC014
      *
      ***  If valid, send data queue entry to prompt DB update program
      *
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *
      ***  Check if update program active using Allocate Object API
      ***  No prompting necessary if program is running
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
      *
     C     Return        IFEQ      *BLANK
      *
      * --------------------------------------------------------------------------------------------
      *  The following /COPY line includes a check for whether there
      *  are messages on the server/updater data queue, and sends a 'GO'.
      *  message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      * --------------------------------------------------------------------------------------------
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPSCC015
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValRpSc - Routine to check if valid repayment schedule     *
      *              details exist                                    *
      *****************************************************************
     C     ChkValRpSc    BEGSR
      *
      ***  Check for repayment schedule on Valid file
      *
     C     APFOTranID    CHAIN     LEVRPSCL0                          99
      *
      ***  If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ***  Delay, then repeat check
      *
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
      *
     C     APFOTranID    CHAIN     LEVRPSCL0                          99
     C                   END                                                                  247549
      *
      ***  Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkValMiRS - Routine to check if valid Repayment exists for   *
      *              Repayment schedule reference                     *
      *****************************************************************
     C     ChkValMiRS    BEGSR
      *
      ***  Key list for file LEVRPSCL1
      *
     C     KRPSC1        KLIST
     C**********         KFLD                    KLNRF             6 0                        CLE148
     C                   KFLD                    KLNRF             6                          CLE148
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    KLASN             3 0
      *
     C     DDLNRF        IFNE      *BLANKS
     C     DDVDAT        ANDNE     *BLANKS
     C     DDSEQN        ANDNE     *BLANKS
      *
      ***  Check for repayment sch. on Valid file
      *
     C                   MOVE      DDLNRF        KLNRF
      *
     C                   MOVE      DDVDAT        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   MOVE      ZDAYNO        KVDAT
      *
     C                   MOVE      DDSEQN        KLASN
     C     KRPSC1        CHAIN     LEVRPSCL1                          99
      *
      ***  If record found...
      *
     C     *IN99         IFEQ      '0'
      *
      ***  ..delay, then repeat check
      *
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
      *
     C     KRPSC1        CHAIN     LEVRPSCL1                          99
     C                   END                                                                  247549
      *
      ***  Error if still present
      *
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx) = 'LEL0664'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValidateAc - Routine to validate action code versus the       *
      *              repayment schedule supplied                      *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      ***  Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ***  if insert
      ***  if not insert and Midas transaction ID is not present
      ***  Otherwise
      ***  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TransIncom    SubForTRNN        2 0
     C                   ENDIF
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   IF        TransIncom = *BLANK
     C                             OR SubForTRNN <> 0
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     *BLANKS       ModeofOp
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate action code versus transaction IDs supplied
      ***  The repayment sch. in file format from the LE database is retrieved
      ***  as well.
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'LERPSCRTV'
      *
      ***  INPUTS
      *
      ***  Return code
     C                   PARM      *BLANK        ReturnCode
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ***  Response mode
     C**********         PARM                    APRESPMODE        1                          CAP084
     C**********         PARM      'S'           APRESPMODE        1                    CAP084247540
     C                   PARM                    APRESPMODE        1                          247540
      *
      ***  Action Code
     C                   PARM                    DDACTN
      *
      ***  Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      ***  (Midas) Loan Number
     C                   PARM                    DDLNRF
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT
      *
      ***  Outputs
      *
      ***  (Current) Repayment sch. in file format
     C                   PARM                    RpScFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      ***  OK - Loan number
     C                   PARM                    DDLnrfOK          1
      *
      ***  OK - Sequence no.
     C                   PARM      *BLANK        DDSeqnOK
      *
      ***  OK - Value Date
     C                   PARM      *BLANK        DDVdatOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
      *
      ***  Save the settlement details for update if not insert
      *
     C     DDACTN        IFNE      'I'
     C                   MOVE      RP_SETP       OSETP
     C                   MOVEL     RP_OSAC       OOSAC
     C                   MOVEL     RP_TSEN       OTSEN
     C                   MOVEL     RP_FACO       OFACO
     C                   MOVEL     RP_SPI1       OSPI1
     C                   MOVEL     RP_SPI2       OSPI2
     C                   MOVEL     RP_SPI3       OSPI3
      *
      ***  Save the last update for test
      *
     C                   Z-ADD     RP_LCD        WLCD
     C                   MOVE      RP_CHTP       WCHTP
     C                   Z-ADD     RP_TNLU       WTNLU
     C                   MOVE      WLSTC         SAVLC
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Routine to apply default settlement instructions *
      *                                                               *
      *****************************************************************
     C     DftSettmts    BEGSR
 
      * If ANY of the Settlements fields have been entered, bypass this
      * routine.
      * Otherwise, use modules which will use Standard Settlement
      * Instructions to apply defaults.
     C                   IF        S_Rec = *blank AND S_Pay = *blank
 
     C                   CALLB     'ZASETINDFT'
      ** Output
      ** Calling function type
     C                   PARM      'LEND'        ##CALP
      ** Payment currency
     C                   PARM      DDCURR        ##PCCY
      ** Receive currency
     C                   PARM      DDCURR        ##RCCY
      ** Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM
      **  Loan Type
     C                   PARM      PTypFilCLOAN  ##TTYP
      ** Federal Funds Ind.
     C                   PARM      *BLANK        ##FFND
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV
      ** Version century of ISDA Agreement
     C                   PARM                    Blank2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
 
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    L_Pay
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    L_Rec
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    L_FRI
 
      ** The defaulted instructions are in file format, but the
      ** Settlements validation requires that they are in the input format.
      ** Therefore run them through a conversion module.
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    L_Pay
     C                   PARM                    L_Rec
     C                   PARM                    L_FRI
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
      *
      ***  Set up date of receipt, and date of payment
      *
     C                   Z-ADD     *ZERO         ##DATR
      *
     C                   MOVE      DDVDAT        DATEA
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   Z-ADD     ZDAYNO        ##DATP
     C                   Z-ADD     ZDAYNO        ##DATR
      *
     C                   RESET                   ReturnCode
      *                                                                                      BUG4960
      ** Set loan type and branch correctly during insert                                    BUG4960
     C                   IF        DDACTN = 'I'                                              BUG4960
     C                   EVAL      ##TTYP = PTypFilCLOAN                                     BUG4960
     C                   ELSE                                                                BUG4960
     C                   EVAL      ##TTYP = RP_LTYP                                          BUG4960
     C                   ENDIF                                                               BUG4960
                                                                                             BUG4960
     C                   IF        DDACTN = 'I'                                              BUG4960
     C                   EVAL      ##BRCA = BrcaFilCLOAN                                     BUG4960
     C                   ELSE                                                                BUG4960
     C                   EVAL      ##BRCA = RP_BRCA                                          BUG4960
     C                   ENDIF                                                               BUG4960
      *
     C                   CALLB     'ZASETINVAL'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Following parameters are output to called module
      ***  Calling function type
     C                   PARM      'LEND'        ##CALP            4
      *
      ***  Payment currency
     C                   PARM      DDCURR        ##PCCY            3
      *
      ***  Receive currency
     C                   PARM      DDCURR        ##RCCY            3
      *
      ***  Customer (shortname or number)
     C                   PARM      DDCUST        ##CSNM           10
      *
      ***  Loan type
     C**********         PARM      RP_LTYP       ##TTYP            2                         BUG4960
     C                   PARM                    ##TTYP            2                         BUG4960
      *
      ***  Federal Funds Ind.
     C                   PARM      *BLANKS       ##FFND            1
      *
      ***  Booking Branch
     C**********         PARM      RP_BRCA       ##BRCA            3                         BUG4960
     C                   PARM                    ##BRCA            3                         BUG4960
      *
      ***  Receipt Date
     C                   PARM                    ##DATR            5 0
      *
      ***  Payment Date
     C                   PARM                    ##DATP            5 0
      *
      ***  Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
      *
      ***  Action Code
     C                   PARM      DDACTN        ##ACTN            1
      * Protect Payment Field                                                                 222373
     C                   PARM                    ##PPAY            1                          222373
      * Protect Receipt Field                                                                 222373
     C                   PARM                    ##PREC            1                          222373
      *
      ***  Following parameters are returned by called module
      ***  Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      *
      ***  Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      *
      ***  FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      *
      ***  Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning Messages                                                                     222373
     C                   PARM                    WFldNamArr                                   222373
     C                   PARM                    WMsgIdArr                                    222373
     C                   PARM                    WMsgDtaArr                                   222373
     C                   PARM                    WIdx                                         222373
      *
      ***  File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    L_Pay
     C                   PARM                    L_Rec
     C                   PARM                    L_FRI
      *
      ***  Extra Input
      ***  Action Code used
     C                   PARM      DDACTN        ##ACTN            1
      *
      ***  Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3
      *
      ***  update valid Repayment schedule settlement instructions
      *
     C                   MOVEL     FLREC         ValidREC
     C                   MOVEL     FLRONS        ValidRECEx                                   CGL029
     C                   MOVEL     FLRSTM        V_RPRSTM                                     CGL029
     C                   MOVEL     FLRSCY        V_RPSCCY
      *
     C                   MOVEL     FLPAY         ValidPAY
     C                   MOVEL     FLPONS        ValidPAYEx                                   CGL029
     C                   MOVEL     FLPSTM        V_RPPSTM                                     CGL029
     C                   MOVEL     FLCVMR        V_RPCVMR
     C                   MOVEL     FLPSCY        V_RPSCCY
     C                   MOVEL     FLIC72        V_RPICCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        V_RPREXR                                     CLE031
     C                   Z-ADD     FLPEXR        V_RPPEXR                                     CLE031
     C                   MOVE      FLREXI        V_RPREXI                                     CLE031
     C                   MOVE      FLPEXI        V_RPPEXI                                     CLE031
     C                   MOVE      FLRSCY        V_RPSCCY                                     CLE031
     C                   MOVE      FLPSCY        V_RPPSCY                                     CLE031
     C                   ENDIF                                                                CLE031
      *
     C     RP_PTYP       IFEQ      66
     C     CLE005        OREQ      'Y'
     C     RP_PTYP       ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     RP_PTYP       ANDEQ     72
     C                   MOVE      FLPOBR        V_RPOSBR
     C                   ELSE
     C                   MOVE      FLROBR        V_RPOSBR
     C                   END
      *
      ***  Perform the additional validations
      *
     C                   CALLB     'LERPSC2VL'
      *
      ***  Response mode (1A), from source system common header
     C**********         PARM                    RespMode                                     CAP084
     C**********         PARM      'S'           RespMode                               CAP084247540
     C                   PARM                    RespMode                                     247540
      *
      ***  Valid Repayment schedule
     C                   PARM                    ValidRpSc
      *
      ***  Payment instructions
     C                   PARM                    L_Pay
      *
      ***  Receive instructions
     C                   PARM                    L_Rec
      *
      ***  Field OK flags (DS)
     C                   PARM                    OKRpSc
      *
      ***  Warning fields/message IDs/message data (arrays)
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index
     C                   PARM                    WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments and changes.                         *
      *****************************************************************
     C     SetupAmd      BEGSR
      *
      ***  For Amends, put the complete (pre-existing) repayment sch. into the Valid
      ***  file record - fields in this will be updated during processing
      *
     C                   MOVE      RpScFilFmt    ValidRpSc
      *
      ***  For Amends, convert the repayment sch. to screen format
      *
     C                   CALLB     'LERPSCCVT'
      *
      ***  Inputs
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      ***  Repayment sch. - file formats
     C                   PARM                    ValidRpSc
      *
      ***  Output parameters
      *
      ***  Repayment sch. Details - screen format
     C                   PARM                    CurRpScCF
      *
      ***  The sett instructions are in file format (retrieved on ValidateAc, but the
      ***   Settlements validation requires that they are in the input format.
      ***  Therefore run them through a conversion module.
      *
     C                   CALLB     'ZASETINCVT'
      *
      ***  Defaulted Settlement Instructions in file format
     C                   PARM                    L_PAY
     C                   PARM                    L_REC
     C                   PARM      *BLANK        L_FRI
      *
      ***  Current Settlement Instruction in input format
     C                   PARM                    C_Pay
     C                   PARM                    C_Rec
     C                   PARM                    C_FRA
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
      *
      ***  If no Payment or Receive instructions have been supplied
      ***  Default them to those currently on the deal.
      *
     C                   IF            (S_Pay = *blank)
     C                   EVAL      S_Pay = C_Pay
     C                   ENDIF
      *
     C                   IF            (S_Rec = *blank)
     C                   EVAL      S_Rec = C_Rec
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      * ValidateTr - Routine to validate the main transaction details  *
      ******************************************************************
     C     ValidateTr    BEGSR
      *
      ***  Validate repayment sch. details screen
      *
     C                   EXSR      ValdTrPrim
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValdTrPrim - Validate repayment sch. details                  *
      *****************************************************************
     C     ValdTrPrim    BEGSR
      *
     C                   CALLB     'LERPSC1VL'
      *
      * INPUTS
      *
      ***  Response mode
     C**********         PARM                    RespMode          1                          CAP084
     C**********         PARM      'S'           RespMode          1                    CAP084247540
     C                   PARM                    RespMode          1                          247540
      *
      ***  Screen Details
     C                   PARM                    TransIncom
      *
     C                   PARM                    InfData                                      CAP086
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  OUTPUTS
      *
      ***  Repayment Sch. Details OK inds
     C                   PARM                    OKRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ***  Valid Repayment Sch. layout (DS) from/to caller
     C                   PARM                    ValidRpSc
      *
      ***  Processing type in CLOANCL file
     C                   PARM                    PTypFilCLOAN      2
      *                                                                                      BUG4960
      ***  Branch in CLOANCL file                                                            BUG4960
     C                   PARM                    BrcaFilCLOAN      3                         BUG4960
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      * This subroutine calls a procedure which checks whether it
      * was valid to Amend or Change any of the fields which have been
      * altered.  Some are never amendable and some are amendable depending
      * on the Action Code - "A" for Amend.
      *
      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.
      *
      * These fields are then compared with the fields on the input
      * transaction.
      *
      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.
      *
      * Repayment Sch. - Amend module for main screen
      * =============================================
      *
     C                   CALLB     'LERPSCAMD'
      *
      ***  INPUTS
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  Incoming Repayment Sch. in Screen Format :
     C                   PARM                    TransIncom
      *
      ***  (Current) Repayment Sch. in Screen Format :
     C                   PARM                    CurRpScCF
      *
      ***  OUTPUTS
      *
      ***  Error Indicators
     C                   PARM                    OKRpSc
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *
      ***  If any errors overwrite previous error information
      *
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *****************************************************************
     C     CheckWrite    BEGSR
      *
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Repayment sch. status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
††††† *
††††† *  +--- Note for a later release -------------------------------+
††††† *  ¶                                                            ¶
††††† *  ¶ At a later date this routine will have to cater for        ¶
††††† *  ¶ warning messages.  The following logic will have to be     ¶
††††† *  ¶ inserted before "If no errors were found", in the          ¶
††††† *  ¶ above comments (and the code):                             ¶
††††† *  ¶                                                            ¶
††††† *  ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† *  ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† *  ¶                                                            ¶
††††† *  ¶ -†††If errors exist                                        ¶
††††† *  ¶†††††-†††††Add the warning array index to the error array   ¶
††††† *  ¶†††††††††††index                                            ¶
††††† *  ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† *  ¶†††††††††††end of the error arrays                          ¶
††††† *  ¶ -†††Else                                                   ¶
††††† *  ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† *  ¶†††††††††††array index                                      ¶
††††† *  ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† *  ¶†††††††††††error arrays                                     ¶
††††† *  ¶ -†††Endif                                                  ¶
††††† *  ¶                                                            ¶
††††† *  ¶ Endif                                                      ¶
††††† *  ¶                                                            ¶
††††† *  ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† *  ¶ can probably be implemented unconditionally (ie the same   ¶
††††† *  ¶ logic will apply whether errors exist as well as warnings  ¶
††††† *  ¶ or not).  It is shown in the above form for clarity.       ¶
††††† *  ¶                                                            ¶
††††† *  +------------------------------------------------------------+
      *
     C                   IF        Idx = 0
      *
     C                   EXSR      SetupValid
     C                   WRITE     LEVRPSCD0
      *
     C                   EXSR      CallMsgHdl
      *
     C                   ENDIF
      *
     C     Idx           IFGT      0
     C                   EXSR      SetupInVal
      *
      ***  Only write to Invalid files if repair in back office
      *
     C                   IF        APRprLocn = 'B'
     C                   WRITE     LEIRPSCD0
     C                   WRITE     APIDSETD0
      *
     C                   ENDIF
      *
     C                   EXSR      CallMsgHdl
      *
     C                   ENDIF
      *
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetCycle- Reset error information that is gradually         *
      * updated during each run of this program                       *
      *****************************************************************
     C     ResetCycle    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
      *
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
      *
     C                   RESET                   FldNoArr
      *
     C                   CLEAR                   CurRpScCF
      *
     C                   MOVE      *ALL'Y'       OKRpSc
      *
     C                   CLEAR                   ValidRpSc
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupInVal - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *****************************************************************
     C     SetupInVal    BEGSR
      *
      ***  Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'LERPSC'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                              CAP086
      * Setup the Automatic Autorisation Flag                                                 CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      DDAUTH     = IF_AUTH                                       CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
     C                   EVAL      TranStatus = 'F'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC016
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *****************************************************************
     C     SetupValid    BEGSR
      *
      ***  For Reversed put the complete (pre-existing) Repayment schedule
      ***  into the Valid file record
      *
     C                   IF           DDACTN = 'R' OR DDACTN = 'X'
     C                   MOVE      RpScFilFmt    ValidRpSc
     C                   ENDIF
      *
      ***  Set Valid file field(s) that are needed for all Action Codes
      *
     C                   EVAL      V_RPCHTP = DDACTN
      *
      ***  Include Header fields that need to be o/p to the Valid file
      *
     C                   EVAL      V_RPFRNT = APFOTranID
     C                   EVAL      V_RPPCRF = APFOTranID
     C                   EVAL      V_RPREPA = APRprLocn
     C                   EVAL      V_RPTMES = TimeStamp
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_RPAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
      *
     C                   EVAL      TranStatus = 'S'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC017
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CallMsgHdl - Call the Message Handling module                 *
      *****************************************************************
     C     CallMsgHdl    BEGSR
      *
      ***  Set up an array of sequence numbers that correspond to the fields
      ***  with errors
      *
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
      *
     C                   IF        FldNameArr(Ix) <> *blanks
      *
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             Ix
      *
     C                   ENDDO
      *
     C                   RESET                   ReturnCode
      *
     C                   MOVEL     DDLNRF        PLNRFID
     C                   MOVEL     DDVDAT        PVDATID
     C                   MOVEL     DDSEQN        PLASNID
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      ***  Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      *
      ***  Repair location (1A, from caller)
     C                   PARM                    APRprLocn
      *
      ***  Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      *
      ***  List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      *
      ***  List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      *
      ***  List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      *
      ***  List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ***  Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      *
      ***  Midas module ID (2A)
     C                   Parm                    ModuleID
      *
      ***  Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID
      *
      ***  Message file (10A, from caller)
     C                   PARM                    #MsgFile
      *
      ***  Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ***  Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      *
      ***  Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C**********         PARM                    APRespMode                                   CAP084
     C**********         PARM      'S'           APRespMode                             CAP084247540
     C                   PARM                    APRespMode                                   247540
      *
      ***  The following three parameters are needed when messages are to
      ***  be displayed on a screen
      ***  Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      *
      ***  Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      *
      ***  Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      *
      ***  The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      *
      ***  The transaction's timestamp
     C                   PARM                    TimeStamp
      *
      ***  Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      *
      ***  Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DtaSubs - Data Substitution                                   *
      *****************************************************************
     C     DtaSubs       BEGSR
      *
      ***  Convert file fields to screen format
      *
     C                   RESET                   ReturnCode
      *
     C                   EXSR      SetupAmd
      *
      ***  Substitute the data for the various parts of the transaction,
      ***  dependent on the flags that were set earlier.
      *
     C                   IF        RepScrn = 'Y'
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      *
      ***  Return Code
     C                   PARM                    ReturnCode
      *
      ***  Substitution character
     C                   PARM                    GHSUBS
      *
      ***  Incoming Data
     C                   PARM      TransIncom    IncData        2000
      *
      ***  Current Data
     C                   PARM      CurRpScCF     CurData        2000
      *
     C                   MOVEL     IncDATA       TransIncom
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Common header information (DS) from source system
     C                   PARM                    HeadIn
      *
      ***  Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    InfData500                                   CAP086
      *
      ***  Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_FRI
     C                   PARM                    ExtData500
      *
      ***  Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LERPSCCTL'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD             7                          CLE031
     C                   PARM      '*VERIFY'     POPTN             7                          CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      ***  Set up the name of the primary and secondary message files from
      ***  which the message handler will get the messages
      *
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
      *
      ***  Set up the Module ID, used to make the Transaction number unique
      *
     C                   EVAL      ModuleID = 'LE'
      *
      ***  Access Bank details via access program
      ***  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Access MIDAS Modules details via access program
      ***  (database error handling done in access program)
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ***  Determine if the features are installed
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
                                                                                              CAP086
      ** Check if enhancement Automatic Authorisation(CAP086) is on                           CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBKey  = 'CAP086'                                          CAP086
     C                   EVAL      DBase  = 1                                                 CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
      *
      ***  Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APRPSCDTQ'
      *
      ***  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LERPSCC018
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
