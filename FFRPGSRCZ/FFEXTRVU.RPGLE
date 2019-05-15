     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded fs and os int controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options module                           *
      *                                                               *
      *  FFEXTRVU - FF Exchange-Traded Futures and Options validate   *
      *             and update                                        *
      *                                                               *
      *  Function: This program validates Exchange-Traded Futures and *
      *            Options transactions for input into the Midas      *
      *            database.                                          *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CAP208             Date 06Dec10               *
      *                 BUG28010           Date 13Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26902           Date 20Jan10               *
      *                 BUG26918           Date 19Jan09               *
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240193             Date 12Jul06               *
      *                 239740             Date 29May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      *                 CAP084  *CREATE    Date 23Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BUG28010 - FFC0770 00001 Database Error                      *
      *  BUG26902 - Amendment in EXTR is not working                  *
      *  BUG26918 - Extra projects found in Drop 1 sources            *
      *           - Physically delete codes of CAP201 and CSC022      *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  240193 - Apply fix 239740.                                   *
      *  239740 - Recompiled over changes FFSETLVAL module.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Current transactions (Keyed by transaction number)
     FFFEXTRL0  IF   E           K DISK    INFSR(*pssr)
     F
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
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
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming transaction in screen format
     D TranInEXTR    E DS                  EXTNAME(FFEXTRPD)
 
      * Valid file layout
     D ValidEXTR     E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(V_)
 
      * Current transaction record in file format
     D EXTRFilFmt    E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(D_)
 
      * Current transaction in screen format
     D CurTrEXTR     E DS                  EXTNAME(FFEXTRPD)
     D                                     PREFIX(@)
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (old) in screen format
     D                                     PREFIX(OC)
 
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Broker settlement instructions (old) in screen format
     D                                     PREFIX(OB)
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer Settlement Instructions (new) in screen format
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Broker Settlement Instructions (new) in screen format
 
     D ValidSett     E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
      ** Valid (new) settlement instructions in file format; prefixed
      ** with VS for settlements.
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas module flags
 
      * Extra data in file format
     D ExtData       E DS                  EXTNAME(FFETEXPD)
 
      * Error indicators
     D OKTrEXTR      E DS                  EXTNAME(FFEEXTRPD)
 
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** The customer settlement details OK flags
 
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** The broker settlement details OK flags
 
     D ValidLUX      E DS                  EXTNAME(FFVTNLX1PD)                                CAP191
      ** The valid extended exchange-trade in file format                                     CAP191
                                                                                              CAP191
     D SVRCD         E DS                  EXTNAME(FFTRX2PD)                                  CAP191
      ** The transaction file for futures & options                                           CAP191
                                                                                              CAP191
     D RegData       E DS                  EXTNAME(FFETRXPD)                                  CAP191
      ** The exchange-traded reg extra data layout                                            CAP191
                                                                                              CAP191
     D OkFlagsExt    E DS                  EXTNAME(FFEETLX1PD)                                CAP191
      ** The errors indicators extended field file                                            CAP191
                                                                                              CAP191
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TRADACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Trading details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DEALACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RETLACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Retail ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  FODAACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D InstTypes     E DS                  EXTNAME(INTYPD)
      ** Instrument types
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
 
      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      * Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Flag to indicate that the FFEXTRRTV is not being called
      ** as a linked enquiry.
     D LinkEnq         S              1A   INZ('N')
 
      ** Flag indicating whether details for customer or broker are
      ** required.
     D CustBrokFl      S              1A
 
      ** Customer or broker number
     D*CustBrokNo***** S              6S 0                                                    CSD027
     D CustBrokNo      S              6A                                                      CSD027
 
      ** Enhanced OTCs feature flag (not used, but passed as a blank PARM)
     D CFF001          S              1A
 
      ** CFF007 enhancement
     D CFF007          S              1A
 
      ** S01457 enhancement                                                                   222373
     D S01457          S              1A                                                      222373
 
      ** PB customer indicator - broker
     D PPBBFLG         S              1A
 
      ** PB customer indicator - customer
     D PPBCFLG         S              1A
      ** Customer/Broker Flag (Y = Broker, N = Customer)
     D BrokerFlag      S              1A
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Flags to indicate that the broker and/or customer settlements
      ** are in error.
     D BrokSetErr      S              1A   INZ('N')
     D CustSetErr      S              1A   INZ('N')
 
      ** Flags to indicate that the broker and/or customer charges and
      ** commission fields are in error.
     D BrokCCErr       S              1A   INZ('N')
     D CustCCErr       S              1A   INZ('N')
 
      ** Transaction status text field
     D StatusText      S             24A
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
 
      **                                                                                      CAP191
     D PRegData500     S            500A                                                      CAP191
     D @TimeStamp      S             26A                                                      CAP191
     D AAuth           S              1A                                                      CAP191
     D FRNT            S             20A                                                      CAP191
     D AFRT            S             20A                                                      CAP191
     D ULX604          S              1A                                                      CAP191
     D @@FIND          S              1A                                                      CAP191
     D DummyTRTY       S              1A                                                      CAP191
     D Module          S              2A   INZ('FF')                                          CAP191
     D v_SystemTime    S              6S 0                                                    CAP191
                                                                                              CAP191
      **                                                                                      CAP191
     D DATALUX         DS          1024                                                       CAP191
     D  #1FLD1                 1      6S 0                                                    CAP191
     D  #1ISTT                 1      5                                                       CAP191
     D  #1TNBR                 6     11                                                       CAP191
     D  #1MRKT                12     13                                                       CAP191
     D  #1FOTR                14     33                                                       CAP191
     D  #1TMST                34     59Z                                                      CAP191
                                                                                              CAP191
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
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInEXTR
     C                   EVAL      NewBrStScn = Trans5002
     C                   EVAL      NewCuStScn = Trans5003
     C                   EVAL      RegData = PRegData500                                      CAP191
     C                   EVAL      Extdata = Extdata500
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Apply the overrides for the FF multimembered files
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    SMRKT
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         SACTN = 'I'
                                                                                              CAP191
     C                   IF        ULX604 = 'Y'                                               CAP191
     C                   IF        L6LXCABR = *Blanks                                         CAP191
     C                   EVAL      L6LXCABR = 'N'                                             CAP191
     C                   ENDIF                                                                CAP191
     C                   IF        L6LXTIME = *Blanks                                         CAP191
     C                   TIME                    v_SystemTime                                 CAP191
     C                   MOVE      v_SystemTime  L6LXTIME                                     CAP191
     C                   ENDIF                                                                CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
                                                                                              CAP191
     C                   IF        ULX604 = 'Y'                                               CAP191
     C                   EXSR      ValidateLUX                                                CAP191
     C                   IF        Idx <> *zero                                               CAP191
     C                   GOTO      INVALID                                                    CAP191
     C                   ENDIF                                                                CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   EXSR      ValidateCC
     C                   EXSR      ValidateSt
 
      * Processing for amends or changes
     C                   WHEN         SACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
                                                                                              CAP191
     C                   IF        ULX604 = 'Y'                                               CAP191
     C                   EXSR      ValidateLUX                                                CAP191
     C                   IF        Idx <> *zero                                               CAP191
     C                   GOTO      INVALID                                                    CAP191
     C                   ENDIF                                                                CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   EXSR      ValidateCC
     C                   EXSR      ValidateSt
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
 
      * Remerge buffer with all relevant data structures
     C**********         EVAL                    Buffer = TranInEXTR                          CAP191
     C                   EVAL      Buffer = TranInEXTR + NewBrStScn + NewCuStScn              CAP191
     C                              + @TimeStamp + AAuth + RegData + ExtData                  CAP191
     C                              + FRNT + AFRT                                             CAP191
 
     C                   RETURN
 
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
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    PRegData500                                  CAP191
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
     C                   PARM                    @TimeStamp                                   CAP191
     C                   PARM                    AAuth                                        CAP191
     C                   PARM                    FRNT                                         CAP191
     C                   PARM                    AFRT                                         CAP191
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Get the Dealing ICD
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Get the retail ICD
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
 
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFODA        PARM      SDFODA        DSFDY
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
     C                   EVAL      DBASE  = 3                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
 
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,FFEXTR01
                                                                                              CAP191
     C                   EVAL      ULX604 = 'N'                                               CAP191
                                                                                              CAP191
      ** Determine if ULX604 is installed                                                     CAP191
                                                                                              CAP191
     C                   CALLB     'AOSARDR0'                                                 CAP191
     C                   PARM      *BLANKS       @RTCD                                        CAP191
     C                   PARM      '*VERIFY'     @OPTN                                        CAP191
     C                   PARM      'ULX604'      @SARD                                        CAP191
     C                   PARM      SCSARD        DSFDY                                        CAP191
                                                                                              CAP191
     C                   IF        @RTCD <> *blanks and @RTCD <> '*NRF   '                    CAP191
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP191
     C                   EVAL      DBKEY  = 'ULX604'                                          CAP191
     C                   EVAL      DBASE  = 5                                                 CAP191
     C                   EXSR      *PSSR                                                      CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   IF        @RTCD = *blanks                                            CAP191
     C                   EVAL      ULX604 = 'Y'                                               CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   EVAL      @RTCD = *blanks                                            CAP191
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the Sk database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFEXTRRTV'
 
      ** Return code
     C                   PARM                    ReturnCode
      ** Inputs to called procedure
      ** --------------------------
      ** Mode = '*FRONT' (Front-office processing)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      ** Response mode
     C                   PARM      'S'           APRESPMODE
      ** Action Code
     C                   PARM                    SACTN
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Market
     C                   PARM                    SMRKT
      ** Flag to indicate module is (not) being called as a linked enquiry
     C                   PARM                    LinkEnq
      ** Bank details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** Outputs from called procedure
      ** -----------------------------
      ** Transaction in file format
     C                   PARM                    EXTRFilFmt
      ** Settlements in file format
     C                   PARM                    ValidSett
      ** Instrument types
     C                   PARM                    InstTypes
      ** OK - Action code
     C                   PARM                    OKACTN
      ** OK - Deal Number
     C                   PARM                    OKTNBR
      * OK - Market
     C                   PARM                    OKMRKT
      ** Error fields/message IDs/message data (arrays)
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index
     C                   PARM                    Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DftSettmts - Apply default settlement instructions if none    *
      *              have been supplied                               *
      *                                                               *
      *****************************************************************
 
     C     DftSettmts    BEGSR
 
      ** If ANY of the Settlements fields have been entered, bypass this
      ** routine.
      ** Otherwise, use modules which will use Standard Settlement
      ** Instructions to apply defaults.
 
     C                   IF            (NewBrStScn = *blank)
     C                             AND (NewCuStScn = *blank)
 
      ** First do broker instructions,
      ** if the broker has been entered, and is not '*'
     C                   IF            SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
 
     C                   EVAL      CustBrokFl = 'B'
     C                   EVAL      CustBrokNo = V_BOCO
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      ** Outputs
      ** -------
      **                     Return code
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      ** Inputs
      ** ------
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    SMRKT
      ** Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale)
     C                   PARM                    STRTY
      ** Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
 
      ** Next do customer instructions,
      ** if the customer has been entered.
     C                   IF        SCUSC <> *blanks
 
     C                   EVAL      CustBrokFl = 'C'
     C                   EVAL      CustBrokNo = V_CUSC
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      ** Outputs
      ** -------
      **                     Return code
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      ** Inputs
      ** ------
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    SMRKT
      ** Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale)                                                  222373
     C                   PARM                    STRTY                                        222373
      ** Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing
 
     C                   MOVE      EXTRFilFmt    ValidEXTR
 
      * Include all data structures required. If Settle details not included copy FXFXDLVU/MMDEAM
      *
 
      * If API requires a convert insert here...
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate transaction details
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFEXTRVAL'
      ** Outputs
      ** -------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      * Transaction Details OK flags (data structure, from/to caller)
     C                   PARM                    OKTrEXTR
      * Array index (3,0P, from/to caller)
     C                   PARM                    Idx
      ** Field name array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Field name array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    WMsgDtaArr
      ** Valid transaction layout (data structure, from/to caller)
     C                   PARM                    ValidEXTR
      ** The branch details format (data structure, from SDBRCHPD)
     C                   PARM                    SDBRCH
      ** The current trading date (Midas day number)
     C                   PARM                    CTDATE
      ** Instrument details (DS based on INTYPD)
     C                   PARM                    InstTypes
      ** PB customer indicator - broker
     C                   PARM                    PPBBFLG
      ** PB customer indicator - customer
     C                   PARM                    PPBCFLG
 
      ** Inputs
      ** ------
      ** Response mode (1A), from source system common header
     C                   PARM                    APRESPMODE
      ** Transaction information (data structure, from source system)
     C                   PARM                    TranInEXTR
      * Extension data
     C                   PARM                    ExtData
      ** Bank details (data structure based on SDBANKPD)
     C                   PARM                    SDBANK
      ** Module flags (data structure based on SDMMODPD)
     C                   PARM                    SDMMOD
      ** General Ledger ICD (data structure, from SDGELRPD)
     C                   PARM                    SDGELR
      ** Futures and Options ICD (data structure based on SDFODAPD)
     C                   PARM                    SDFODA
      ** Dealing ICD (data structure based on SDDEALPD)
     C                   PARM                    SDDEAL
      ** Portfolio Management ICD (data structure based on SDPORTPD)
     C                   PARM                    SDPORT
      ** CFF007 enhancement
     C                   PARM                    CFF007
     C                   PARM                    S01457                                       222373
 
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *                                                               *
      *****************************************************************
     C     ValidateSt    BEGSR
 
      ** FFSETLVAL is called twice, once for broker settlement instructions
      ** and once for customer settlement instructions.
 
     C                   RESET                   BrokSetErr
     C                   RESET                   CustSetErr
 
      ** 1. Broker (if broker defined)
      ** ---------
     C                   IF        SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
 
     C                   EVAL      CustBrokFl = 'B'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    V_TRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_BOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_CUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 enhancement
     C                   PARM                    CFF007
      ** PB customer indicator - broker
     C                   PARM                    PPBBFLG
      ** PB customer indicator - customer
     C                   PARM                    PPBCFLG
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      BrokSetErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDIF
 
      ** 2. Customer (if customer defined)
      ** -----------
     C                   IF        SCUSC <> *blanks
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    V_TRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_BOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    V_CUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 enhancement
     C                   PARM                    CFF007
      ** PB customer indicator - broker
     C                   PARM                    PPBBFLG
      ** PB customer indicator - customer
     C                   PARM                    PPBCFLG
      ** Collateral Processing enhancement                                                    CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustSetErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateCC - Validate the charges and commission details      *
      *                                                               *
      *****************************************************************
 
     C     ValidateCC    BEGSR
 
      ** FFVCHGCOM is called twice, once for broker charges and commissions
      ** and once for customer charges and commissions.
 
     C                   RESET                   BrokCCErr
     C                   RESET                   CustCCErr
 
      ** 1. Broker
      ** ---------
     C                   EVAL      BrokerFlag = 'Y'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewBrStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Broker Chrg./Comm. Pattern
     C                   PARM                    VSBCPT
      ** Market
     C                   PARM                    SMRKT
      ** Instrument
     C                   PARM                    SISTC
      ** No. of contracts
     C                   PARM                    V_NUCO
      ** Action code
     C                   PARM                    SACTN
      ** Broker
     C                   PARM                    SBOCO
      ** CFF007 Enhancement
     C                   PARM                    CFF007
      ** PB customer indicator
     C                   PARM                    PPBBFLG
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      BrokCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
      ** 2. Customer
      ** -----------
     C                   EVAL      BrokerFlag = 'N'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    ValidSett
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    ISCY
      ** Broker Chrg./Comm. Pattern
     C                   PARM                    VSBCPT
      ** Market
     C                   PARM                    SMRKT
      ** Instrument
     C                   PARM                    SISTC
      ** No. of contracts
     C                   PARM                    V_NUCO
      ** Action code
     C                   PARM                    SACTN
      ** Broker
     C                   PARM                    SBOCO
      ** CFF007 Enhancement
     C                   PARM                    CFF007
      ** PB customer indicator
     C                   PARM                    PPBCFLG
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      * This subroutine calls a procedure which checks whether it
      * was valid to amend any of the fields which have been
      * changed.  Some are never amendable and some depend upon ICD
      * settings as to whether they are amendable.
 
      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.
 
      * These fields are then compared with the fields on the input
      * transaction.
 
      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.
 
      * Convert file format to screen format
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRCVT'
 
 
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      ** Old transaction in file format
     C                   PARM                    EXTRFilfmt
      ** Bank details ICD
     C                   PARM                    SDBANK
      ** Dealing ICD
     C                   PARM                    SDDEAL
      ** Module flags
     C                   PARM                    SDMMOD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Outputs
      ** -------
      ** Old transaction in screen format
     C                   PARM                    CurTrEXTR
      ** Transaction Status
     C                   PARM                    StatusText
      ** CFF007 enhancement
     C                   PARM                    CFF007
 
      ** FFSETLCVT is called twice, once for broker settlement instructions
      ** and once for customer settlement instructions.
 
     C                   EVAL      CustBrokFl = 'B'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CurCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    CurBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    ValidSett
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Instrument currency
     C                   PARM                    ISCY
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CurCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    CurBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    ValidSett
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Instrument currency
     C                   PARM                    ISCY
 
      * If any errors overwrite previous error information
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
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
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
 
     C                   CLEAR                   CurTrEXTR
 
     C                   MOVE      *ALL'Y'       OKTrEXTR
 
     C                   CLEAR                   ValidEXTR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
      *
     C                   IF        STNBR = *Blanks                                            CAP191
     C                   RESET                   ReturnCode                                   CAP191
     C                   CALLB     'ZATRNRTV'                                                 CAP191
     C                   PARM                    ReturnCode                                   CAP191
     C                   PARM                    Module                                       CAP191
     C                   PARM                    DummyTRTY                                    CAP191
     C                   PARM                    STNBR                                        CAP191
     C                   PARM                    V_TNBR                                       CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
     C                   IF        SACTN <> 'D'                                               CAP191
     C                   EVAL      VSTNBR = V_TNBR                                            CAP191
     C                   ELSE                                                                 CAP191
     C                   EVAL      ValidEXTR = EXTRFilFmt                                     CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
      * Set the field of the valid EXTR file (FFVTRANPD)                                      CAP191
     C                   EVAL      V_FRNT = FRNT                                              CAP191
     C                   EVAL      V_AFRT = AFRT                                              CAP191
     C                   EVAL      V_REPA = ' '                                               CAP191
                                                                                              CAP191
      * Set the field of the valid settlements file (FFVSETLPD)                               CAP191
     C                   EVAL      VSFRNT = APFOTRANID                                        CAP191
     C                   EVAL      VSAFRT = APFOASOCID                                        CAP191
     C                   EVAL      VSREPA = APRPRLOCN                                         CAP191
     C                   EVAL      VSTMST = TimeStamp                                         CAP191
                                                                                              CAP191
      * Set file field(s) that are needed for all action codes
     C                   EVAL      V_CHTP = SACTN
     C                   EVAL      VSTNBR = V_TNBR
 
      **Include*header*fields*that*need*to*be*o/p*to*the*valid*file****                     BUG26902
     C**********         IF        SACTN <> 'I' and @TimeStamp <> *Blanks            CAP191 BUG26902
     C**********         EVAL      V_TMST = TimeStamp                                       BUG26902
     C**********         ENDIF                                                       CAP191 BUG26902
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      * Update
     C                   CALLB     'FFTRANUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid transaction
     C                   PARM                    ValidEXTR
      ** The instrument details (data structure)
     C                   PARM                    InstTypes
      ** The settlement details (data structure)
     C                   PARM                    ValidSett
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C**********         PARM                    TransType                                  BUG26902
     C                   PARM      'EXTR'        TransType                                  BUG26902
      ** New OTC instrument Y/N
     C                   PARM                    NewOTCInst        1
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on
     C                   PARM                    CFF001
      ** General Ledger ICD (SDGELRPD data structure
     C                   PARM                    SDGELR
      ** Midas module flags
     C                   PARM                    SDMMOD
      ** Trade and book positions reconcilable flag (from SDFODAPD)
     C                   PARM                    BXTBRC
 
     C                   IF        ULX604 = 'Y'                                               CAP191
     C                   IF        ReturnCode <> 'Error' and                                  CAP191
     C                             ReturnCode <> '*RECUPD'                                    CAP191
     C                   MOVE      STNBR         #6LXFFTNBR                                   CAP191
     C                   EVAL      @@FIND = 'Y'                                               CAP191
     C                   EVAL      ReturnCode = *Blanks                                       CAP191
     C                   EVAL      SVRCD = *Blanks                                            CAP191
     C                   CALLB     'FFTRAN2UP'                                                CAP191
     C                   PARM                    SACTN                                        CAP191
     C                   PARM                    ReturnCode                                   CAP191
     C                   PARM                    @@FIND                                       CAP191
     C                   PARM                    ValidLUX                                     CAP191
     C                   PARM                    SVRCD                                        CAP191
     C                   ENDIF                                                                CAP191
     C                   ENDIF                                                                CAP191
                                                                                              CAP191
      ** If no errors, update settlement instructions
 
     C                   IF        ReturnCode <> 'Error'
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid settlement instructions; broker
      ** and customer.
     C                   PARM                    ValidSett
      ** The format containing the valid transaction (data structure)
     C                   PARM                    ValidEXTR
      ** The instrument details (data structure)
     C                   PARM                    InstTypes
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** CFF007 enhancement
     C                   PARM                    CFF007
      ** PB customer indicator (Broker)
     C                   PARM                    PPBBFLG
      ** PB customer indicator (Customer)
     C                   PARM                    PPBCFLG
 
      ** End of "If ReturnCode <> 'Error'
     C                   ENDIF
 
      * If there were any errors in the update function, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C*****@RTCD         IFNE      *BLANK                                                   BUG28010
     C*****@RTCD         ANDNE     '*RECUPD'                                                BUG28010
     C     ReturnCode    IFNE      *BLANK                                                   BUG28010
     C     ReturnCode    ANDNE     '*RECUPD'                                                BUG28010
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
 
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************                       CAP191
      /EJECT                                                                                  CAP191
      *****************************************************************                       CAP191
      *                                                               *                       CAP191
      * ValidateLUX - Validate Extension Details                      *                       CAP191
      *                                                               *                       CAP191
      *****************************************************************                       CAP191
                                                                                              CAP191
     C     ValidateLUX   BEGSR                                                                CAP191
                                                                                              CAP191
     C                   MOVEL     TNBR          #1TNBR                                       CAP191
     C                   CALLB     'FFEXTR2VL'                                                CAP191
     C                   PARM                    SACTN                                        CAP191
     C                   PARM                    DATALUX                                      CAP191
     C                   PARM                    RegData                                      CAP191
     C                   PARM                    OkFlagsExt                                   CAP191
     C                   PARM                    FldNameArr                                   CAP191
     C                   PARM                    MsgIDArr                                     CAP191
     C                   PARM                    MsgDtaArr                                    CAP191
     C                   PARM                    Idx                                          CAP191
     C                   PARM                    WFldNamArr                                   CAP191
     C                   PARM                    WMsgIDArr                                    CAP191
     C                   PARM                    WMsgDtaArr                                   CAP191
     C                   PARM                    WIdx                                         CAP191
     C                   PARM                    ValidLUX                                     CAP191
                                                                                              CAP191
     C                   ENDSR                                                                CAP191
                                                                                              CAP191
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Error array index (3,0P)
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
