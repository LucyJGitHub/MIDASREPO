     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Item Interface Controller')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITPCTL - Journal Batch Entry Item Interface Controller    *
      *                                                               *
      *  Function: This program validates Journal Batch Entry items   *
      *            for input into the Midas database.                 *
      *            - If errors exist in the incoming entry, its Valid *
      *              Indicator will be set to 'N', which will prevent *
      *              Database Update program from accepting the       *
      *              journal batch.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD052075           Date 07Jun19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 14Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236204             Date 18Sep06               *
      *                 240684             Date 26Jun06               *
      *                 237621             Date 10Jan06               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG9073            Date 02Aug05               *
      *                 CRE023             Date 29Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 CMM121             Date 29Jun04               *
      *                 BUG2948            Date 03Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 TCA102             Date 02Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 07Sep03               *
      *                 212722             Date 15Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052075 - [CGL150] Warning message should be displayed when *
      *           the system defaults the value date.                 *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for midas plus                       *
      *  236204 - Do not check Retail ICD if retail module is not     *
      *           active.                                             *
      *  240684 - Applied fix 237621.                                 *
      *  237621 - Upgrade CGL037 Journal Entry only.
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG9073 - Batch Number and Batch Item not populated in valid *
      *           file due to changes in GLBITPVAL for MidasPlus      *
      *  CRE023 - 2 O'clock Flag Update to MidasPlus.                 *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:GLBITPCC09,GLBITPC002            *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'. (recompile)*
      *  CGL014 - Collaterals Processing                              *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - API Wrappers.                                       *
      *  212722 - If there are errors then only write to the valid    *
      *           file if the repair location is in the back office   *
      *           Use associated front office id on items             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid JE Items file
     FGLVBITPPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Valid JE Items Additional Info file                                                  246418
     FGLVBIPXPD UF A E             DISK    INFSR(*PSSR)                                       246418
     F                                     COMMIT                                             246418
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITPC001
                                                                                              CER001
     FGLVBPLX1PDUF A E             DISK    USROPN                                             CER001
      ***  Midas IBLC 2002 GL BITP - Valid File - LU Window                                   CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FGLIBPLX1PDUF A E             DISK    USROPN                                             CER001
      ***  Midas IBLC 2002 GL BITP - Invalid File - LU Window                                 CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
      *
      ** MIDAS Valid Journal Batch Entry Items Addnl Inf                                    BUG23742
      *                                                                                     BUG23742
     FGLVMNARPD UF A E             DISK    INFSR(*PSSR)                                     BUG23742
     F                                     COMMIT                                           BUG23742
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
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
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Message Header (DS)
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction (DS)
     D PTranIn       E DS                  EXTNAME(GLBITPPD)
      *
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** JE Items Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITPPD)
     D  WIndOK                 1     20    DIM(20) INZ('Y')
      *                                                                                       246418
      ** Valid JE Item Additional Information (DS) - for file update                          246418
     D PVBITPX       E DS                  EXTNAME(GLVBIPXPD)                                 246418
      *
      ** JE Items Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBPEXPD)
      *
      ** GL Accounts Extra Data                                                               CER001
     D RegData       E DS                  EXTNAME(GLBPRXPD)                                  CER001
      *                                                                                       CER001
      ** JE Additional Info Data for CGL013                                                   246418
     D PAddInfo      E DS                  EXTNAME(GLBITPXPD)                                 246418
      *                                                                                       246418
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for Retail ICD Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACD3       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      *                                                                                     BUG23742
      ** Data structure based on valid file GLVMNARPD                                       BUG23742
      *                                                                                     BUG23742
     D GLVNARR       E DS                  EXTNAME(GLVMNARPD)                               BUG23742
      *                                                                                     BUG23742
     D GLMNARR         DS           770                                                     BUG23742
      *                                                                                     BUG23742
     D  PAddNarr1              1    500                                                     BUG23742
     D  PAddNarr2            501    770                                                     BUG23742
      *                                                                                     BUG23742
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
     D/COPY WNCPYSRC,GLBITPCD01
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIdx            S              3P 0
      *
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Field (500A) to receive the incoming transaction
     D PTrans500       S            500A
      *                                                                                       246418
      ** Field (500A) to receive the incoming Extra Data                                      246418
     D PAddInfo500     S            500A                                                      246418
     D PAddInf1500     S            500A                                                    BUG23742
     D PAddInf2500     S            500A                                                    BUG23742
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
     D RegData500      S            500A                                                      CER001
      *
      ** Module ID, to be passed to the Message Handler
     D PModuleID       S              2A
      *
      ** Action code defaults to 'I' for insert
     D PAction         S              1A   INZ('I')
      *
      ** Timestamp for the transaction
     D PTimeStamp      S               Z
      *
     D PObject         S             10A   INZ('GLBITPUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list).
     D PClrPgmMsgQ     S              1A   INZ('Y')
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
      *
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Overall Transaction status, to be passed to the Message Handler
     D PTranStatus     S              1A
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define SAR flag for Cheque book processing                                           CRE019
     D CRE019          S              1A   INZ('N')                                           CRE019
                                                                                              CRE019
      ** Processing Date                                                                      CSC011
     D WRDAY           S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
      *                                                                                       CRE023
      ** Variable used by CRE023                                                              CRE023
      *                                                                                       CRE023
     D CRE023          S              1                                                       CRE023
      *                                                                                       246418
      ** Switchable feature CGL013                                                            246418
     D CGL013          S              1                                                       246418
      *                                                                                       246418
      ** Switchable feature CGL013                                                          BUG23742
      *                                                                                     BUG23742
     D CER030          S              1A                                                    BUG23742
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITPC002
      *
     D/COPY QWINDSRC,GLBITPSDTA                                                               CER001
                                                                                              CER001
     D PDATA           DS          1024                                                       CER001
     D  #1CUST                 1      6                                                       CER001
     D  #1CYCD                 7      9                                                       CER001
     D  #1BTNB                10     12                                                       CER001
     D  #1BINB                13     15  0                                                    CER001
     D  #1DCIN                16     16                                                       CER001
     D  #DFMPA                17     30                                                       CER001
     D  #1FOTR                31     50                                                       CER001
     D  #1TMST                51     76Z                                                      CER001
      *                                                                                       CER001
      ** Valid Extended Journal entry interface in File Format                                CER001
     D ValidFilExtL  E DS                  EXTNAME(GLVBPLX1PD)                                CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsExtL   E DS                  EXTNAME(GLEBPLX1PD)                                CER001
      *                                                                                       CER001
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
      /COPY WNCPYSRC,GLBITPC003
      *
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
      *
     C                   MOVEL     PTrans500     PTranIn
     C/COPY WNCPYSRC,GLBITPCC01
     C                   MOVEL     PExtdata500   PExtdata
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   MOVEL     PAddInfo500   PAddInfo                                     246418
      *                                                                                     BUG23742
     C                   MOVEL     PAddInf1500   PAddNarr1                                  BUG23742
     C                   MOVEL     PAddInf2500   PAddNarr2                                  BUG23742
      *                                                                                     BUG23742
     C/COPY WNCPYSRC,GLBITPCC02
      *
      ** Generate a timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,GLBITPC004
      *
      ** Process transaction.
      *
     C                   EXSR      SRValdTran
      *
      /COPY WNCPYSRC,GLBITPC005
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,GLBITPC006
      *
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
     C                   ELSE
      *
      ** Processing for Error checking/write to database
      *
      /COPY WNCPYSRC,GLBITPC007
      ** ULX607 - API Luxembourg - Function GLBITP                                            CER001
      *                                                                                       CER001
     C     ULX607        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExtL                                  CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   MOVE      B2CUST        #1CUST                                       CER001
     C                   MOVE      B2CYCD        #1CYCD                                       CER001
     C                   MOVE      DDPTAM        #DFMPA                                       CER001
     C                   MOVE      B2BTNB        #1BTNB                                       CER001
     C                   MOVE      B2BINB        #1BINB                                       CER001
     C                   MOVE      B2DCIN        #1DCIN                                       CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   CALLB     'GLBPLX2VL'                                                CER001
     C                   PARM                    Paction                                      CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExtL                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExtL                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     ULX607        IFEQ      'Y'                                                        CER001
     C                   EVAL      #LLXJEBTNB = B2BTNB                                        CER001
     C                   EVAL      #LLXJEBINB = B2BINB                                        CER001
     C                   EVAL      #LLXJEFOTR = APFOTranID                                    CER001
     C                   EVAL      #LLXJETMES = PTimeStamp                                    CER001
     C                   WRITE     GLVBPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C     ULX607        IFEQ      'Y'                                                        CER001
     C                   EVAL      #LLXFOTR = APFOTranID                                      CER001
     C                   EVAL      #LLXTMES = PTimeStamp                                      CER001
     C                   WRITE     GLIBPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
     C                   EXSR      SRChkWrite
      *
      /COPY WNCPYSRC,GLBITPC008
      *
      ** Send data queue entry to prompt to DB update program.
      *
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM      *BLANK        PReturn
      *
     C     PReturn       IFEQ      *BLANK
      *
      ** Check if any messages are already on the data queue.
      ** No need to send duplicate prompt messages.
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLBITPC009
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   CLEAR                   PVBITP
     C                   CLEAR                   GLVNARR                                    BUG23742
      *
      ** Numeric fields within PVBITP have to be reset explicitly as
      ** there are long alpha fileds overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields.
      *
     C                   Z-ADD     *ZERO         B2BINB
     C                   Z-ADD     *ZERO         B2RACN
     C                   Z-ADD     *ZERO         B2PTAM
     C**********         Z-ADD     BJRDNB        B2PTDT                                       CSC011
     C                   Z-ADD     WRDAY         B2PTDT                                       CSC011
     C                   Z-ADD     *ZERO         B2VLDT
     C                   Z-ADD     *ZERO         B2RRNM
     C                   Z-ADD     *ZERO         B2SPFC
     C                   Z-ADD     *ZERO         B2NITM
     C                   Z-ADD     *ZERO         B2OAMT
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
     C                   RESET                   FldNoArr
      *
     C                   RESET                   PFlagsOK
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdTran - Routine to validate the main transaction        *
      *               details                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRValdTran    BEGSR
      *
     C                   CALLB     'GLBITPVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    APRespMode
      *
      ** Associated Front Office Id
     C                   PARM                    APFOAsocId
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
                                                                                              246418
      ** JE Items Additional Info                                                             246418
     C                   PARM                    PAddInfo                                     246418
      *                                                                                     BUG23742
      ** JE Items Additional Narratives                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    GLMNARR                                    BUG23742
      *
      ** JE Items Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRDAY                                        CSC011
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centres Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Management Accounts
     C                   PARM                    BGNVST
      *
      ** SDRETL - No. of Days Forward Value
     C                   PARM                    BMNDFV
      *
      ** TABTBRE - Charge for Multiple Transactions
     C                   PARM                    PCMTR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Account Posting Narrative feature
     C                   PARM                    CEU013
      *
      ** Block GL Accounts feature
     C                   PARM                    CGL002
      *                                                                                       CAP084
      ** Security on Journal Entry feature                                                    CAP084
     C                   PARM                    CGL008            1                          CAP084
      *                                                                                       CRE019
      ** Cheque book processing feature                                                       CRE019
     C                   PARM                    CRE019                                       CRE019
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              237621
      ** Account Access Security                                                              237621
     C                   PARM                    CGL037            1                          237621
                                                                                              246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013                                       246418
      *                                                                                     BUG23742
      ** CER030 feature                                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    CER030                                     BUG23742
     C/COPY WNCPYSRC,GLBITPCC10
      *
      ** OUTPUT
      ** ======
      *
      ** JE Items Error Indicators (DS)
     C                   PARM                    PFlagsOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/msg data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
     C/COPY WNCPYSRC,GLBITPCC09
     C                   PARM                    CRE023                                       CRE023
      ** Valid JE Item (DS) - for file update                                                 246418
     C                   PARM                    PVBITPX                                      246418
      ** CGL150 Default Value Date 'Y'                                                      MD052075
     C                   PARM                    VDFLTF            1                        MD052075
      *                                                                                      BUG9073
      ** Setup batch number and batch item when there is no error                            BUG9073
      *                                                                                      BUG9073
     C                   IF        Idx = 0                                                   BUG9073
     C                   IF        DDBINB <> *BLANKS                                         BUG9073
     C                   MOVE(P)   DDBINB        ZFIELD                                      BUG9073
      *                                                                                      BUG9073
     C                   CALLB     'ZALIGN'                                                  BUG9073
     C                   PARM                    ZalignOK          1                         BUG9073
     C                   PARM                    ZFIELD           16                         BUG9073
     C                   PARM      *ZERO         ZADEC             1 0                       BUG9073
     C                   PARM      3             ZADIG             2 0                       BUG9073
                                                                                             BUG9073
     C                   MOVE      ZFIELD        B2BINB                                      BUG9073
     C                   ENDIF                                                               BUG9073
     C                   IF        DDBTNB <> *BLANKS                                         BUG9073
     C                   MOVE      DDBTNB        B2BTNB                                      BUG9073
     C                   ENDIF                                                               BUG9073
      *                                                                                     BUG23742
     C                   EVAL      %SUBST(GLVNARR:9) = GLMNARR                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                               BUG9073
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkWrite - Routine for writing records to database and     *
      *               for sending of messages                         *
      *                                                               *
      *****************************************************************
      *
     C     SRChkWrite    BEGSR
      *
      ** The index to the error arrays is checked for
      ** presence/absence of errors.
      *
      ** If any errors were found:
      ** - set Valid Indicator to 'N'.
      ** - set Transaction Status to 'F'.
      *
      ** If no errors were found:
      ** - set Valid Indicator to 'Y'.
      ** - set Transaction Status to 'S'.
      *
      ** Set up additional data.
      *
      ** Use std message handler to report errors and transaction
      ** status.
      *
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
      *
      ** If errors exist, set Valid Indicator to 'N' and Transaction
      ** Status to F (Failure); otherwise, set Valid Indicator to 'Y'
      ** and Transaction Status to S (Success).
      *
     C     Idx           IFGT      *ZERO
     C                   EVAL      B2VALI = 'N'
     C                   EVAL      PTranStatus = 'F'
     C                   ELSE
     C                   EVAL      B2VALI = 'Y'
     C                   EVAL      PTranStatus = 'S'
     C                   ENDIF
      *
      ** Set up other fields.
      *
     C                   EXSR      SRSetOFld
     C/COPY WNCPYSRC,GLBITPCC07
      *
      ** Write transaction record to Valid JE Items file.
      ** If errors exist then only write if repair location is                                212722
      ** in the backoffice.                                                                   212722
      *
     C     Idx           IFEQ      *ZERO                                                      212722
     C     Idx           ORGT      *ZERO                                                      212722
     C     APRPRLOCN     ANDEQ     'B'                                                        212722
     C                   WRITE     GLVBITPD0
      *                                                                                       246418
     C     CGL013        IFEQ      'Y'                                                        246418
     C     PVBITPX       ANDNE     *BLANKS                                                    246418
     C                   EVAL      B3PTDT = BJRDNB                                            246418
     C                   EVAL      B3BTNB = B2BTNB                                            246418
     C                   EVAL      B3BINB = B2BINB                                            246418
     C                   WRITE     GLVBIPXD0                                                  246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C     CER030        IFEQ      'Y'                                                      BUG23742
     C     GLVNARR       ANDNE     *BLANKS                                                  BUG23742
      *                                                                                     BUG23742
     C                   EVAL      FPTDT = BJRDNB                                           BUG23742
     C                   EVAL      FBTNB = B2BTNB                                           BUG23742
     C                   EVAL      FBINB = B2BINB                                           BUG23742
      *                                                                                     BUG23742
     C                   WRITE     GLVMNARD0                                                BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                                212722
      *
      ** Call standard message handler.
      *
     C                   EXSR      SRMsgHdl
      *
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetOFld - Set up additional fields that are needed on the  *
      *              file record                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRSetOFld     BEGSR
      *
      ** Update record with Message Header data.
      *
     C                   EVAL      B2FRNT = APFOTranID
     C                   EVAL      B2AFRT = APFOAsocID
     C                   EVAL      B2TMST = PTimeStamp
      *
      /COPY WNCPYSRC,GLBITPC010
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors.
      *
     C                   Z-ADD     1             W1
      *
     C                   DO        ArrayMax
      *
     C     FldNameArr(W1)IFNE      *BLANKS
      *
     C                   Z-ADD     1             W2
     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           01
     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             W1
     C                   ENDDO
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANKS       ReturnCode
      *
      ** Repair location (1A, from caller)
     C                   PARM                    APRprLocn
      *
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      *
      ** List of messages (Array of message ids - from caller )
     C                   PARM                    MsgIDArr
      *
      ** List of field numbers (Array of unsigned int. from caller)
     C                   PARM                    FldNoArr
      *
      ** List of field names (Array of field names - from caller)
     C                   PARM                    FldNameArr
      *
      ** List of message data entries (Array of data entries from caller)
     C                   PARM                    MsgDtaArr
      *
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      *
      ** Midas module ID (2A)
     C                   PARM                    PModuleID
      *
      ** Midas transaction ID (20A, Front Office ID)
     C*************      PARM                    B2FRNT                                       212722
     C                   PARM                    B2AFRT                                       212722
      *
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      *
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    PAction
      *
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    PTranStatus
      *
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      *
      ** The following three parameters are needed when messages are
      ** to be displayed on a screen
      *
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      *
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      *
      ** The transaction's timestamp
     C                   PARM                    PTimeStamp
      *
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      *
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    PClrPgmMsgQ
      *
     C                   ENDSR
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
     C/COPY WNCPYSRC,GLBITPCC03
     C     *ENTRY        PLIST
      *
      ** Common Message Header information (DS) from source system
     C                   PARM                    PHeadIn
      ** Transaction information in a single large field from
      ** from source system
     C                   PARM                    PTrans500
      *
      ** Extra Transaction information in a single large field
      ** from source system
     C                   PARM                    PAddInfo500                                  246418
     C                   PARM                    PAddInf1500                                BUG23742
     C                   PARM                    PAddInf2500                                BUG23742
     C                   PARM                    RegData500                                   CER001
     C/COPY WNCPYSRC,GLBITPCC05
     C                   PARM                    PExtData500
     C/COPY WNCPYSRC,GLBITPCC06
      *
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C/COPY WNCPYSRC,GLBITPCC04
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      #MsgFile = 'GLUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      ** Set up the name of the module ID, used to make the transaction
      ** number unique.
      *
     C                   EVAL      PModuleID = 'GL'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Retail III ICD details to check if Charge for
      ** Multiple Transactions is 'Y'.
      *
     C     BGNXST        IFEQ      'Y'
     C                   CALL      'SD9343'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      *BLANK        PCMTR             1
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'TABTBRE'     DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                                236204
      *
      ** Access Retail ICD details.
      *
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                236204
      *
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Posting Narrative feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU013'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU013'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL002
      ** (Block GL Accounts feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL002'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL002            1
     C                   ELSE
     C                   MOVEL     'N'           CGL002
     C                   ENDIF
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APBITPDTQ'
     C                   EVAL      WRDAY = BJRDNB                                             CSC011
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBase = 008                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     PRTCD         IFEQ      *BLANKS                                                    CSC011
     C                   MOVE      'Y'           CSC011                                       CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVE      'N'           CSC011                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If 24x7 Midas availability is installed and program is running                       CSC011
      ** in the support system, set the control date to the processing                        CSC011
      ** date held in dtaara SC24X7                                                           CSC011
     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
     C                   EVAL      WRDAY = S1DATE                                             CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
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
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 9                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
                                                                                              CRE019
      ** Determine if Cheque book processing is installed                                     CRE019
                                                                                              CRE019
     C                   CALLB     'AOSARDR0'                                                 CRE019
     C                   PARM      *BLANKS       PRTCD                                        CRE019
     C                   PARM      '*VERIFY'     POPTN                                        CRE019
     C                   PARM      'CRE019'      PSARD                                        CRE019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE019
                                                                                              CRE019
      ** An NRF (No Record Found) return code is valid.                                       CRE019
      ** Issue database error only for error return codes.                                    CRE019
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CRE019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE019
     C                   EVAL      DBKey = 'CRE019'                                           CRE019
     C                   EVAL      DBase = 009                                                CRE019
     C                   EXSR      *PSSR                                                      CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CRE019
     C     PRTCD         IFEQ      *BLANKS                                                    CRE019
     C                   MOVE      'Y'           CRE019                                       CRE019
     C                   ENDIF                                                                CRE019
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 11                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              237621
      ** Access SAR file to determine if CGL037 is installed.                                 237621
                                                                                              237621
     C                   CALLB     'AOSARDR0'                                                 237621
     C                   PARM      *BLANKS       PRTCD                                        237621
     C                   PARM      '*VERIFY'     POPTN                                        237621
     C                   PARM      'CGL037'      PSARD                                        237621
     C     SCSARD        PARM      SCSARD        DSFDY                                        237621
                                                                                              237621
      ** An NRF (No Record Found) return code is valid.  Issue database error                 237621
      ** only for error return codes.                                                         237621
                                                                                              237621
     C     PRTCD         IFNE      *BLANKS                                                    237621
     C     PRTCD         ANDNE     '*NRF   '                                                  237621
     C                   MOVEL     'CGL037'      DBKEY                                        237621
     C                   MOVEL     'SCSARDPD'    DBFILE                                       237621
     C                   Z-ADD     012           DBASE                                        237621
     C                   EXSR      *PSSR                                                      237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C     PRTCD         IFEQ      *BLANK                                                     237621
     C                   MOVE      'Y'           CGL037            1                          237621
     C                   ELSE                                                                 237621
     C                   MOVE      'N'           CGL037                                       237621
     C                   ENDIF                                                                237621
                                                                                              237621
     C/COPY WNCPYSRC,GLBITPCC08
      *                                                                                       CRE023
     C                   EVAL      CRE023 = 'N'                                               CRE023
     C                   CALLB     'AOSARDR0'                                                 CRE023
     C                   PARM      *BLANKS       PRTCD                                        CRE023
     C                   PARM      '*VERIFY'     POPTN                                        CRE023
     C                   PARM      'CRE023'      PSARD                                        CRE023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE023
      *                                                                                       CRE023
      ** An NRF (No Record Found) return code is valid. Issue database                        CRE023
      ** error only for error return codes.                                                   CRE023
      *                                                                                       CRE023
     C                   IF        PRTCD <> *BLANKS AND                                       CRE023
     C                             PRTCD <> '*NRF   '                                         CRE023
     C                   EVAL      DBKEY = 'CRE023'                                           CRE023
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE023
     C                   EVAL      DBASE = 10                                                 CRE023
     C                   EXSR      *PSSR                                                      CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
     C     PRTCD         IFEQ      *BLANK                                                     CRE023
     C                   EVAL      CRE023 = 'Y'                                               CRE023
     C                   ENDIF                                                                CRE023
      *                                                                                       CRE023
      *                                                                                       246418
      ** Access SAR details file to determine if MT94x Messages Generation                    246418
      ** processing is switched ON                                                            246418
      *                                                                                       246418
     C                   EVAL      CGL013 = 'N'                                               246418
     C                   CALLB     'AOSARDR0'                                                 246418
     C                   PARM      *BLANKS       PRTCD                                        246418
     C                   PARM      '*VERIFY'     POPTN                                        246418
     C                   PARM      'CGL013'      PSARD                                        246418
     C     SCSARD        PARM      SCSARD        DSFDY                                        246418
      *                                                                                       246418
      ** An NRF (No Record Found) return code is valid. Issue database                        246418
      ** error only for error return codes.                                                   246418
      *                                                                                       246418
     C                   IF        PRTCD <> *BLANKS AND                                       246418
     C                             PRTCD <> '*NRF   '                                         246418
     C                   EVAL      DBKEY = 'CGL013'                                           246418
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246418
     C                   EVAL      DBASE = 014                                                246418
     C                   EXSR      *PSSR                                                      246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   IF        PRTCD = *BLANK                                             246418
     C                   EVAL      CGL013 = 'Y'                                               246418
     C                   ENDIF                                                                246418
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITPC011
      ** ULX607 - API Luxembourg - Function GLBITP                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX607            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX607'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX607                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND @RTCD <> '*NRF   '                   CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX607'                                          CER001
     C                   EVAL      DBASE  = 12                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      GLVBPLX1PD                                                 CER001
     C                   OPEN      GLIBPLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND @RTCD <> '*NRF   '                   CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX043'                                          CER001
     C                   EVAL      DBASE  = 13                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                     BUG23742
     C                   CALLB     'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRTCD                                      BUG23742
     C                   PARM      '*VERIFY'     POPTN                                      BUG23742
     C                   PARM      'CER030'      PSARD                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
      ** An NRF (No Record Found) return code is valid.  Issue database error               BUG23742
      ** only for error return codes.                                                       BUG23742
      *                                                                                     BUG23742
     C     PRTCD         IFNE      *BLANKS                                                  BUG23742
     C     PRTCD         ANDNE     '*NRF   '                                                BUG23742
     C                   MOVEL     'CER030'      DBKEY                                      BUG23742
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG23742
     C                   Z-ADD     015           DBASE                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C     PRTCD         IFEQ      *BLANK                                                   BUG23742
     C                   MOVEL     'Y'           CER030                                     BUG23742
     C                   ELSE                                                               BUG23742
     C                   MOVEL     'N'           CER030                                     BUG23742
     C                   ENDIF                                                              BUG23742
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
(c) Finastra International Limited 2001
