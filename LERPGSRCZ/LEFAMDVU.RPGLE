     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility amendment Validate & Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFAMDVU - Facility Amendment Validate                       *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD024398           Date 11May14               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG11161           Date 06Mar06               *
      *                 BUG10384           Date 06Feb06               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 30Jun05               *
      *                 BUG4482            Date 29Sep04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1371            Date 22Mar04               *
      *                 CAP084  *CREATE    Date 16Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024398 - API Performance Optimisation                      *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00251                                 *
      *             WNCPYSRC,LEH00252                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11161 - Add hidden fields from FAMD.xml (Recompile)       *
      *  BUG10384 - Display Facility UTN and Facility Event UTN       *
      *             correctly.                                        *
      *  CLE106 - Syndications Manager. Updated Pro Rata field.       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *         - Include fix of parameter mismatch between VU and RTV*
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1371 - Sequence number not set up if there is a warning   *
      *  CAP084 - API wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **-----------------------------------------------------------------------
 
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
      *  Array for job name                                                                   CSC022
     D ARRJBNAM        S             10A   DIM(10)                                            CSC022
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInFAMD    E DS                  EXTNAME(LEFAMDPD)
      *                                                                                       CLE106
      ** Incoming Transaction                                                                 CLE106
      *                                                                                       CLE106
     D TranInFAM2    E DS                  EXTNAME(LEFAM2PD)                                  CLE106
 
      * Valid Customer Securities Details layout
     D ValidFAMD     E DS                  EXTNAME(LEVFAMDPD)
     D                                     PREFIX(V_)
                                                                                              CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** Interface Data Format Definition File format                                         CAP086
 
      * (Current) Transaction record in file Format
     D FAMDFilFmt    E DS                  EXTNAME(LEFCAMPD)
 
      * (Current) Transaction in Screen Format - Main Details
     D CurTrFAMD     E DS                  EXTNAME(LEFAMDPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKTrFAMD      E DS                  EXTNAME(LEEFAMDPD)
 
      *                                                                                       CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D  COMITNOM               1      3S 0                                                    CSC022
     D  COMITJOB               4    103                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * EXTERNAL DS FOR SAR DETAILS                                                           CSC022
      *                                                                                       CSC022
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D  @RUNA          DS            50                                                       CAP086
      * Facility run dates                                                                    CAP086
                                                                                              CAP086
     D  @OAMA          DS           130                                                       CAP086
      * Facility drawn amounts                                                                CAP086
                                                                                              CAP086
      ** +--------------------------------------+                                             CSC022
      ** ¦ Use of Indicator                     ¦                                             CSC022
      ** ¦ ================                     ¦                                             CSC022
      ** |                                      |                                             CSC022
      ** | 17      Used by LOOKUP               |                                             CSC022
      ** +--------------------------------------+                                             CSC022
                                                                                              CSC022
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
     D Trans5001       S            500A
      *                                                                                       CLE106
      ** Fields (500A) to receive the incoming transaction 2                                  CLE106
      *                                                                                       CLE106
     D Trans5002       S            500A                                                      CLE106
                                                                                              CAP086
     D InfData500      S            500A                                                      CAP086
      ** Field (500A) to receive the incoming Interface Data                                  CAP086
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
                                                                                              CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
      ** Counter variable                                                                     CSC022
     D WCMT01          S              1A                                                      CSC022
      ** Commitment Flag                                                                      CSC022
     D CAP086          S              1A   INZ('N')                                           CAP086
      *                                                                                       CLE106
      ** Parameters used by CLE106                                                            CLE106
      *                                                                                       CLE106
     D ZAMSID          S              7A                                                      CLE106
     D ZAMSGF          S             10A                                                      CLE106
     D ZAMSDA          S            132A                                                      CLE106
     D ZAMSTX          S            132A                                                      CLE106
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,LEFAMDVU02
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,LEFAMDVU03
 
      * Incoming transaction
     C                   MOVEL     Trans5001     TranInFAMD
     C                   MOVEL     Trans5002     TranInFAM2                                   CLE106
 
     C                   MOVEL     InfData500    InfData                                      CAP086
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,LEFAMDVU05
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,LEFAMDVU06
 
      *  If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         S#ACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,LEFAMDVU07
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFAMDVU08
 
     C                   WHEN         S#ACTN = 'A'
     C                             OR S#ACTN = 'D'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,LEFAMDVU09
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,LEFAMDVU10
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,LEFAMDVU11
                                                                                             BUG4482
     C                   WHEN      S#ACTN = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
 
     C                   ENDSL
      *
     C     INVALID       TAG
      *  Write to database
 
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF
 
     C                   SETON                                        LR
 
     C                   EVAL                    Buffer = TranInFAMD
     C                                                    + TranInFAM2                        CLE106
     C                                                    + InfData                           CAP086
 
     C                   RETURN
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
 
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the mm database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'LEFAMDRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      'S'           RESPMODE          1
      *
      * Action Code, Facility Customer & Type
 
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
      *
      * Facility Amendment Number, Type, Value Date & Seq no.
 
     C                   PARM                    S#FCNO
     C                   PARM                    S#FATP
     C                   PARM                    S#VLDT
     C                   PARM                    S#SQNO
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    FAMDFilFmt
      *
      * Action, customer, facility type, facility number, facility
      * amendment type, value date and sequence number OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FATPok          1
     C                   PARM                    S#VLDTok          1
     C                   PARM                    S#SQNOok          1
 
      * Customer number
     C**********         PARM                    S#CNUM            6                          CAP086
     C                   PARM                    S#CNUM           10                          CAP086
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
      * Facility tranche/credit agreement ind
      * Facility revolving credit indicator
      * Facility record ID
      * Facility date of expiry
      * Facility closure date
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00251
 
      * Facility run dates
      * Facility drawn amounts
     C**********         PARM                    @RUNA             5 0                        CAP086
     C**********         PARM                    @OAMA            13 0                        CAP086
     C                   PARM                    @RUNA                                        CAP086
     C                   PARM                    @OAMA                                        CAP086
                                                                                            BUG10384
      ** Facility UTN                                                                       BUG10384
     C                   PARM                    S#FUTN                                     BUG10384
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
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
 
      * For Amends, put the complete (pre-existing) Transaction into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      FAMDFilFmt    ValidFAMD
 
      * For Amends, convert the Facility Amendment transaction to screen format
 
     C                   CALLB     'LEFAMDCVT'
      * Inputs
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility Amendment Transaction - file formats
     C                   PARM                    ValidFAMD
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
      * Facility Amendment Transaction Details - screen formats
     C                   PARM                    CurTrFAMD
 
      * Customer details
     C**********         PARM                    S#CNUM            6                          CAP086
     C                   PARM                    S#CNUM           10                          CAP086
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Facility amendment type narrative
      * Record status
      * Value date in alpha format
     C                   PARM                    S#FATN           24
     C                   PARM                    S#STAT           10
     C                   PARM                    S#VLDA            7
      *                                                                                       CLE106
      ** Move the record status parameter to the status field in buffer                       CLE106
      *                                                                                       CLE106
     C                   EVAL      S_STAT = S#STAT                                            CLE106
                                                                                              CLE106
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Facility Amendment Transaction details
 
     C                   EXSR      ValdTrFAMD
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrFAMD - Validate Facility Amendment Transaction details  *
      *                                                               *
      *****************************************************************
     C     ValdTrFAMD    BEGSR
      *                                                                                       CLE106
     C     WkCLE106      IFEQ      'Y'                                                        CLE106
     C                   EVAL      A5TNRF = S#UTN                                             CLE106
     C                   ENDIF                                                                CLE106
 
     C                   CALLB     'LEFAMDVAL'
 
      * Inputs
 
      * Return code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      ** Facility Amendment Transaction Details
     C                   PARM                    TranInFAMD
 
      * Value date of amendment
     C                   PARM                    W#VLDT            5 0
 
      * Generated by assignment
     C                   PARM                    A5GASS            1
      * Facility Amount
      * Facility Branch
      * Facility Branch details
      * Facility Currency
      * Facility Currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C                   PARM                    FcrvRVCR          1
     C                   PARM                    FcRECI            1
     C                   PARM                    FcDTEX            5 0
     C                   PARM                    FcCDTE            5 0
     C/COPY WNCPYSRC,LEH00252
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    A5PCOB            3
     C                   PARM                    A5TNRF           15
 
      * Facility run dates
      * Facility drawn amount
     C                   PARM                    @RUNA
     C                   PARM                    @OAMA
 
      * Outputs
      *
      * Amendment amount
     C                   PARM                    W#AAMT           13 0
 
      ** Facility Amendment Transaction Details OK inds
     C                   PARM                    OKTrFAMD
 
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
     C                   PARM                    WIdx              3 0
 
      * Valid Facility Amendment Transaction (DS) from/to caller
     C                   PARM                    ValidFAMD
 
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
 
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrFAMD
 
     C                   MOVE      *ALL'Y'       OKTrFAMD
 
     C                   CLEAR                   ValidFAMD
 
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
      * For Authorises and deletes, put the complete (pre-existing) deal
      *  into the Valid file record.
      * (Because incoming data are not validated by the VAL API)
     C                   IF           S#ACTN = 'X' OR
     C                                S#ACTN = 'D'
     C                   MOVE      FAMDFilFmt    ValidFAMD
     C                   ENDIF
                                                                                              CAP086
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_AMAUTO = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
     C     WkCLE106      IFEQ      'Y'                                                        CLE106
     C                   IF        S#ACTN = 'X'                                               CLE106
     C                   EVAL      V_AMASTS = 'A'                                             CLE106
     C                   ENDIF                                                                CLE106
     C                   EVAL      V_AMNPRT = S#NPRT                                          CLE106
     C                   EXSR      SRGetSTat                                                  CLE106
     C                   ENDIF                                                                CLE106
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
     C     WriteToDB     BEGSR
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UpdateDB      BEGSR
      *
     C                   CALLB     'LEFAMDUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN
 
      * Facility Amendment Details in file format
     C                   PARM                    ValidFAMD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OkTrFAMD
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
      * Sequence assigned
     C                   PARM                    A_SQNO            3
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     WCMT01        OREQ      'N'                                                        CSC022
     C     CSC022        ANDEQ     'Y'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
 
      ** Setup sequence number to pass back to APTRANVU on insert mode
 
     C     S#ACTN        IFEQ      'I'
     C     A_SQNO        ANDNE     *BLANKS
     C*****WIdx          ANDEQ     *ZERO                                                     BUG1371
     C                   EVAL                    S#SQNO = A_SQNO
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEP0026'     MsgIdArr(1)
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     WCMT01        IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * SRGETSTAT - Retrieve the record status text to be passed      *                       CLE106
      *    back to buffer.                                            *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
                                                                                              CLE106
     C     SRGETSTAT     BEGSR                                                                CLE106
                                                                                              CLE106
     C                   SELECT                                                               CLE106
     C                   WHEN      V_AMASTS = 'R'                                             CLE106
     C                   EVAL      ZAMSID   = 'LEF0285'                                       CLE106
     C                   EXSR      SRTEXT                                                     CLE106
     C                   EVAL      S_STAT   = ZAMSTX                                          CLE106
                                                                                              CLE106
     C                   WHEN      V_AMASTS = 'C'                                             CLE106
     C                   EVAL      ZAMSID   = 'LEF0286'                                       CLE106
     C                   EXSR      SRTEXT                                                     CLE106
     C                   EVAL      S_STAT   = ZAMSTX                                          CLE106
                                                                                              CLE106
     C                   WHEN      V_AMASTS = 'A'                                             CLE106
     C                   EVAL      ZAMSID   = 'LEF0287'                                       CLE106
     C                   EXSR      SRTEXT                                                     CLE106
     C                   EVAL      S_STAT   = ZAMSTX                                          CLE106
                                                                                              CLE106
     C                   ENDSL                                                                CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************                       CLE106
      *                                                               *                       CLE106
      * SRTEXT - Set up the text from the message file                *                       CLE106
      *                                                               *                       CLE106
      *****************************************************************                       CLE106
                                                                                              CLE106
     C     SRTEXT        BEGSR                                                                CLE106
                                                                                              CLE106
     C                   CALL      'Y2RVMGC'                                                  CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM                    ZAMSID                                       CLE106
     C                   PARM      'LERMSGF'     ZAMSGF                                       CLE106
     C                   PARM                    ZAMSDA                                       CLE106
     C                   PARM      *BLANKS       ZAMSTX                                       CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
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
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002                                    CLE106
     C                   PARM                    InfData500                                   CAP086
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
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
      /COPY WNCPYSRC,LEFAMDVU17
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Override LEFAMDLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
      ** Key Lists
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LEFAMDVU18
 
     C                   MOVE      *BLANKS       WFldNamArr
     C                   MOVE      *BLANKS       WMsgIDArr
     C                   MOVE      *BLANKS       WMsgDtaArr
     C                   Z-ADD     0             WIdx
 
      * Determine if CSC022 is switched on                                                    CSC022
      ** CSW022 is a mandatory feature already, so it is always on                          MD024398
                                                                                              CSC022
     C**********         CALLB     'AOSARDR0'                                        CSC022 MD024398
     C**********         PARM      *BLANKS       @RTCD                               CSC022 MD024398
     C**********         PARM      '*VERIFY'     @OPTN                               CSC022 MD024398
     C**********         PARM      'CSC022'      @SARD                               CSC022 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC022 MD024398
     C**********         IF        @RTCD = *BLANK                                    CSC022 MD024398
     C                   EVAL      CSC022 ='Y'                                                CSC022
     C                   EVAL      WCMT01 ='N'                                                CSC022
      * SCCMTJOB data area                                                                    CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      * Move data area to commitment array                                                    CSC022
     C                   IF        COMITNOM > 0                                               CSC022
     C                   MOVEA     COMITJOB      ARRJBNAM                                     CSC022
      *                                                                                       CSC022
      * Check if PSJOBNAME exist.                                                             CSC022
     C     PSJOBNAME     LOOKUP    ARRJBNAM                               17                  CSC022
     C                   IF        *IN17 = *ON                                                CSC022
     C                   EVAL      WCMT01= 'Y'                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      **********                                                                     CSC022 MD024398
     C**********         ELSE                                                        CSC022 MD024398
      **@rtcd*not found                                                              CSC022 MD024398
     C**********         IF        @RTCD <> '*NRF'                                   CSC022 MD024398
     C******LOCK         IN        LDA                                               CSC022 MD024398
     C**********         EVAL      DBPGM = 'LEFAMDVU'                                CSC022 MD024398
     C**********         EVAL      DBKEY = 'CSC022'                                  CSC022 MD024398
     C**********         EVAL      DBFILE ='SCSARDPD'                                CSC022 MD024398
     C**********         EVAL      DBASE  = 905                                      CSC022 MD024398
     C**********         OUT       LDA                                               CSC022 MD024398
     C**********         EXSR      *PSSR                                             CSC022 MD024398
     C**********         ENDIF                                                       CSC022 MD024398
     C**********         ENDIF                                                       CSC022 MD024398
                                                                                              CAP086
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
     C                   EVAL      DBPGM = 'LEFAMDVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 1                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CSC022
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           WkCLE106          1                          CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           WkCLE106                                     CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           WkCLE106                                     CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** ##OX1
OVRDBF FILE(LEFAMDLR) TOFILE(LEFAMDL0) SHARE(*NO)
