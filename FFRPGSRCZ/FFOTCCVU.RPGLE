     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC Validate + Update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  FFOTCCVU - Midas FF Currency OTC Validate + Update           *
      *                                                               *
      *  Function: This program validates FF OTC transactions for     *
      *            input into the Midas database.                     *
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
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG8119            Date 20Oct05               *
      *                 BUG6274            Date 18Mar05               *
      *                 BUG4737            Date 17Nov04               *
      *                 BUG4728            Date 10Nov04               *
      *                 BUG4693            Date 30Oct04               *
      *                 BUG4258            Date 13Sep04               *
      *                 BUG3014            Date 10Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 23Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  BUG6274- Premium amount does not revise on first confirmation*
      *           for insert                                          *
      *  BUG4737 - Unable to authorise transaction because WIP do     *
      *            not have correct data.                             *
      *  BUG4728 - Fix for object is similar to BUG4693. Fix is       *
      *            annotated as BUG4693.                              *
      *  BUG4693 - Serious Midas Error for OTCO/OTCC API              *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  BUG3014- DB error occurs when entering OTCC                  *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
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
 
     D/COPY ZACPYSRC,FVAL_ARRAY
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.                                                           BUG4737
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4737
                                                                                             BUG4737
      ** Array of error message IDs                                                          BUG4737
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4737
     D                                     LIKE(#MsgID)                                      BUG4737
                                                                                             BUG4737
      ** Array of error message data.                                                        BUG4737
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4737
     D                                     LIKE(#MsgData)                                    BUG4737
                                                                                             BUG4737
      ** Array of message files to check                                                     BUG4737
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4737
                                                                                             BUG4737
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
 
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      * Incoming header
 
     D TranInOTCC    E DS                  EXTNAME(FFOTCCPD)
      * Incoming transaction in screen format
 
     D DummyTIn      E DS                  EXTNAME(FFOTCOPD)
      ** Dummy incoming Transaction in screen format
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (new) in screen format
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Broker Settlement Instructions (new) in screen format
      ** (not used for OTCs, but required by some called procedures).
 
     D ValidOTCC     E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(V_)
      * Valid file layout
      *                                                                                       CER001
     D ValidLUX      E DS                  EXTNAME(FFVTNLX1PD)                                CER001
      ** Lux Valids Extension File                                                            CER001
 
     D ValidSett     E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
      ** Valid (new) settlement instructions in file format; prefixed
      ** with VS for settlements.
 
     D OTCCFilFmt    E DS                  EXTNAME(TRANSD)
      * Current transaction record in file format
 
     D OTSTFilFmt    E DS                  EXTNAME(TRSETD)
     D                                     PREFIX(@)
      ** Transaction Settlement details in file format
 
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Market centre details
 
     D CurTrOTCC     E DS                  EXTNAME(FFOTCCPD)
     D                                     PREFIX(@)
      * Current transaction in screen format
 
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions (old) in screen format
     D                                     PREFIX(OC)
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
     D                                     PREFIX(OB)
      ** Broker settlement instructions (old) in screen format
 
     D ExtData       E DS                  EXTNAME(FFOTEXPD)
      * Extra data in file format
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(FFOTRXPD)                                  CER001
      ** Extra data in file format                                                            CER001
 
     D OKTrOTCC      E DS                  EXTNAME(FFEOTCCPD)
      * Error indicators
 
     D OKDummyDS     E DS                  EXTNAME(FFEOTCOPD)
     D                                     PREFIX(A)
      ** The OK flags for the OTCO transaction details
 
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** The customer settlement details OK flags
 
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** The broker settlement details OK flags
      ** (not used for OTCs, but required by some called procedures).
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * External DS for bank details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DEALACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  TRADACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Trading details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RETLACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Retail ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  FODAACCD     E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      * External DS for SAR details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs - short data structure
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D     Msg1        S                   LIKE(#MsgID)
      * Error message field(s)
 
     D AmIdx           S              3P 0 INZ(0)
      * Index for arrays of error message ids etc in amend validation
 
     D Idx             S              3P 0 INZ(0)
      * Index for arrays of error message ids etc
 
     D Trans5001       S            500A
     D Trans5002       S            500A
      * Fields (500A) to receive the incoming transaction
 
     D ExtData500      S            500A
      * Field (500A) to receive the incoming Extra Data
     D RegData500      S            500A                                                      CER001
      ** Field (500A) to receive the incoming Extra Data (Regional)                           CER001
 
     D Ix              S              3P 0
     D Iy              S              3P 0
      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
 
     D TimeStamp       S               Z
      * Timestamp for the transaction
 
     D CTDATE          S                   LIKE(BJRDNB)
      ** The current trading date
 
     D BrokerFlag      S              1A   INZ('N')
      ** Customer/Broker Flag (Y = Broker, N = Customer)
 
     D CustCCErr       S              1A   INZ('N')
      ** Flags to indicate that the customer charges and
      ** commission fields are in error.
 
     D CustSetErr      S              1A   INZ('N')
      ** Flags to indicate that the customer settlements
      ** are in error.
 
     D*CustBrokNo      S              6S 0                                                    CSD027
     D CustBrokNo      S              6A                                                      CSD027
      ** Customer or broker number
 
     D Module          S              2A   INZ('FF')
      ** Module ID
 
     D ResetErrs       S              1A   INZ('N')
      ** Error reset required in amend processing
 
     D CustBrokFl      S              1A   INZ('C')
      ** Flag indicating whether details for customer or broker are
      ** required (broker does not apply for OTCs)
 
     D NewInst         S              1A   IMPORT
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CER001
      ** Extended Futures and Options File                                                    CER001
     D SVRCD         E DS                  EXTNAME(FFTRX2PD)                                  CER001
      *                                                                                       CER001
      ** Error fields indicators                                                              CER001
     D OkFlagsDS     E DS                  EXTNAME(FFEOTLX1PD)                                CER001
      *                                                                                       CER001
      ** Data passed from caller program                                                      CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
     D  #1ISTT                 1      5                                                       CER001
     D  #1TNBR                 6     11                                                       CER001
     D  #1MRKT                12     13                                                       CER001
     D  #1FOTR                14     33                                                       CER001
     D  #1TMST                34     59Z                                                      CER001
      *                                                                                       CGL029
      ** Flag to indicate that new instrument details must be written
      ** (imported from module FFVOTCCTYP)
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
 
     D v_SystemTime    S              6  0                                                    CER001
                                                                                              CER001
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
     C                   MOVEL     Trans5001     TranInOTCC
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   EVAL      NewCuStScn = Trans5002
     C                   MOVEL     Extdata500    Extdata
     C                   EVAL      DummyTIn = *BLANKS
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM      'OT'          OTCMember         3
                                                                                             BUG4737
      ** Save Action Code for later use                                                      BUG4737
     C                   MOVE      SACTN         @SACTN            1                         BUG4737
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      * Processing depends upon action code
     C                   SELECT
 
      * Processing for inserts
     C                   WHEN         SACTN = 'I'
      *                                                                                       CER001
      ** Default system time for the first occurence                                          CER001
      *                                                                                       CER001
     C                   IF        ULX605 = 'Y'                                               CER001
     C                   IF        L6LXCABR = *Blank                                          CER001
     C                   EVAL      L6LXCABR = 'N'                                             CER001
     C                   ENDIF                                                                CER001
     C                   IF        L6LXTIME = *Blank                                          CER001
     C                   TIME                    v_SystemTime                                 CER001
     C                   MOVE      v_SystemTime  L6LXTIME                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   EXSR      ValidateTr
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
     C                   IF        ULX605 = 'Y'                                               CER001
                                                                                              CER001
     C                   EXSR      ValidateLUX                                                CER001
     C     Idx           IFNE      0                                                          CER001
     C                   GOTO      INVALID                                                    CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   EXSR      DftSettmts
 
      ** Validate the charges and commission details
     C                   EXSR      ValidateCC
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
     C                   EXSR      ValidateSt
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      ** Validate Private Banking Fields
 
     C     CFF007        IFEQ      'Y'
     C     BGN4ST        ANDEQ     'Y'
     C                   EXSR      ValidatePB
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   ENDIF
 
      * Processing for amends or changes
     C                   WHEN         SACTN = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                              CER001
     C                   IF        ULX605 = 'Y'                                               CER001
                                                                                              CER001
     C                   EXSR      ValidateLUX                                                CER001
     C     Idx           IFNE      0                                                          CER001
     C                   GOTO      INVALID                                                    CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
 
      ** Validate the charges and commission details
     C                   EXSR      ValidateCC
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      ** Validate the settlement instructions
     C                   EXSR      ValidateSt
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      ** Check that the amendment is legitimate
     C                   EXSR      ValdateAmd
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate Private Banking Fields
 
     C     CFF007        IFEQ      'Y'
     C     BGN4ST        ANDEQ     'Y'
     C                   EXSR      ValidatePB
 
      *  If errors in validation, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   ENDIF
 
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
 
      ** Remove the multimembered file overrides for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
     C                   SETON                                        LR
 
      ** If action is for Update, get the correct record information                         BUG4737
      ** from file                                                                           BUG4737
     C                   IF        UpdateYN = 'Y'                                            BUG4737
     C                             AND Idx = 0                                               BUG8119
     C                   Z-ADD     V_TNBR        @TNBR             6 0                       BUG4737
     C                   MOVE      @TNBR         DDTRNO_IN                                   BUG4737
     C                   CALL      'FFOTCCR'                                                 BUG4737
     C                   PARM                    @AuthComp         1                         BUG4737
     C                   PARM                    @FwdBck           1                         BUG4737
     C                   PARM                    DDTRNO_IN         6                         BUG4737
     C                   PARM                    Buffer                                      BUG4737
     C                   PARM                    @FldNameArr                                 BUG4737
     C                   PARM                    @MsgIDArr                                   BUG4737
     C                   PARM                    @MsgDtaArr                                  BUG4737
     C                   PARM                    @MsgFArray                                  BUG4737
     C                   PARM                    @APIRetC          1                         BUG4737
     C                   MOVEL     @SACTN        Buffer                                      BUG4737
     C                   ELSE                                                                BUG4737
      * Remerge buffer with all relevant data structures
     C**********         EVAL      Buffer = TranInOTCC + NewCuStScn + ExtData                 CER001
     C                   EVAL      Buffer = TranInOTCC + NewCuStScn                           CER001
     C                                      + @TimeStamp                                     BUG4258
     C**********                   + SPREM + NEWINST                                          CER001
     C                             + SPREM + NEWINST + RegData + ExtData                      CER001
     C                   ENDIF                                                               BUG4737
 
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
     C                   PARM                    RegData500                                   CER001
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
     C                   PARM                    @TimeStamp       26                         BUG4258
     C                   PARM                    SPREM            15                         BUG6274
 
     C                   EVAL      MsgFArray(1) = 'FFUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FFOTCC02
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   EVAL      CTDATE = BJRDNB
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Access Dealing ICD
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
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
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
     C                   EVAL      CFF001 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *blank
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Determine if CFF007 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFF007
     C                   ELSE
     C                   MOVE      'N'           CFF007
     C                   ENDIF
 
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 001                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
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
                                                                                BUG3014
      ** Determine if S01457 is installed                                       BUG3014
                                                                                BUG3014
     C                   EVAL      S01457 = 'N'                                 BUG3014
     C                   CALLB     'AOSARDR0'                                   BUG3014
     C                   PARM      '       '     @RTCD                          BUG3014
     C                   PARM      '*VERIFY'     @OPTN                          BUG3014
     C                   PARM      'S01457'      @SARD             6            BUG3014
     C     SCSARD        PARM      SCSARD        DSFDY                          BUG3014
                                                                                BUG3014
     C                   IF        @RTCD = *blank                               BUG3014
     C                   EVAL      S01457 = 'Y'                                 BUG3014
     C                   ENDIF                                                  BUG3014
      *                                                                                       CER001
      ** Check if enhancement ULX605 is on                                                    CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX605            1                          CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX605'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX605'                                          CER001
     C                   EVAL      DBASE  = 4                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRTCD = *BLANKS                                            CER001
     C                   EVAL      ULX605 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *  Hook to enable non-core initial processing to be included
     D/COPY WNCPYSRC,FFOTCC01
 
     C                   ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValidateLUX  - Validate Extension Details                     *                       CER001
      *                                                               *                       CER001
      * Calls:                                                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     ValidateLUX   BEGSR                                                                CER001
     C                   MOVE      TNBR          #1TNBR                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FFOTCC3VL'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsDS                                    CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
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
      * The Transaction in file format from the FF database is retrieved
      * as well.
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFOTCCRTV'
      *
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
      *
      * Action Code
     C                   PARM                    SACTN             1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Transaction Number
     C                   PARM      STNBR         DDTRNN            6
 
      ** Module being called as linked enquiry (1A)
     C                   PARM      'N'           LnkEnq            1
      * Standing Data and multi-branching indicator
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    BGMBIN
 
      ** Transaction type
 
     C                   PARM      'OTCC'        TransType         4
      *
      * Outputs
      *
      * (Current) Transaction in file format
     C                   PARM                    OTCCFilFmt
 
      ** (Current) transaction settlement details in file format
     C                   PARM                    OTSTFilFmt
      ** Instrument Types
     C                   PARM                    InstType
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDTrnnOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
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
 
     C                   IF        NewCuStScn = *blank
 
     C                   EVAL      CustBrokFl = 'C'
     C                   EVAL      CustBrokNo = V_CUSC
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      **                     Return code
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    DummyMark         2
      ** Instrument code
     C                   PARM                    DummyInst         3
      ** Transaction type (purchase or sale) (1A)
     C                   PARM                    STRTY
      ** Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateCC - Validate the charges and commission details      *
      *                                                               *
      *****************************************************************
 
     C     ValidateCC    BEGSR
 
     C                   RESET                   CustCCErr
 
      ** Customer
      ** --------
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
     C                   PARM                    V_ISCY
      ** Broker Chrg./Comm. Pattern
     C                   PARM                    ITBCPT
      ** Market
     C                   PARM      *Blanks       PMRKT             2
      ** Instrument
     C                   PARM      *Blanks       PISTC             3
      ** No. of contracts
     C                   PARM                    V_NUCO
      ** Action code
     C                   PARM                    SACTN
      ** Broker
     C                   PARM                    V_BOCO
      ** Futures and Options Enhancement for Private Banking
     C                   PARM                    CFF007
      ** PB customer indicator
     C                   PARM                    PPBFLG
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDSR
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
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidatePB - Validate Private Banking Details                 *
      *                                                               *
      *****************************************************************
      *
     C     ValidatePB    BEGSR
 
     C                   CALLB     'FFOTCC2VL'
      ** Outputs
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    OKTrOTCC
     C                   PARM                    OKDummyDS
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    ValidOTCC
     C                   PARM                    InstType
      ** Inputs
     C                   PARM                    TranInOTCC
     C                   PARM                    DummyTIn
     C                   PARM                    NewInst
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM      'OTCC'        TransType
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing
 
     C                   MOVE      OTCCFilFmt    ValidOTCC
 
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFSETLCVT'
 
      ** Outputs
 
     C                   PARM                    ReturnCode
     C                   PARM                    CurCuStScn
     C                   PARM                    CurBrStScn
 
      ** Inputs
 
     C                   PARM                    OTSTFilFmt
     C                   PARM                    CustBrokFl
     C                   PARM                    STNBR
     C                   PARM                    ISCY
 
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
 
     C                   CALLB     'FFOTCCVAL'
 
      * Outputs
      *
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** OTCC Transaction Details OK inds
     C                   PARM                    OKTrOTCC
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Valid OTCC Transaction (DS) from/to caller
     C                   PARM                    ValidOTCC
      ** The branch details format (data structure, from SDBRCHPD)
     C                   PARM                    SDBRCH
      ** The current trading date (Midas day number)
     C                   PARM                    CTDATE
      ** Instrument details (DS based on INTYPD)
      ** Instrument Types
     C                   PARM                    InstType
      * Premium
     C                   PARM                    SPREM
      ** PB customer indicator
     C                   PARM                    PPBFLG            1
 
      * Inputs
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Transaction Details
     C                   PARM                    TranInOTCC
      * Extra Data
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
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** CFF007 Enhancement
     C                   PARM                    CFF007
     C                   PARM                    S01457            1            BUG3014
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Validate the settlement instructions             *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
     C                   RESET                   CustSetErr
 
      ** Customer
      ** --------
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
     C                   PARM                    V_ISCY
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
      ** CFF007 Enhancement
     C                   PARM                    CFF007
      ** PB customer indicator
     C                   PARM                    PPBBFLG           1
      ** PB customer indicator
     C                   PARM                    PPBFLG
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure to ensure that the correct details get
      ** written to the invalid files.
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustSetErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
     C                   ENDSR
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
     C                   CALLB     'FFOTCCCVT'
      * Ensure correct parameters for this CVT function
      *
      * Output Parameters
      *
      * Return Code
     C                   PARM      *BLANKS       RetCodeIn
      *
      * OTCC Transaction Details File Format
     C                   PARM                    OTCCFilFmt
      * Instrument types
     C                   PARM                    InstType
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * Output Parameters
 
      * OTCC Transaction Details Screen Format
     C                   PARM                    CurTrOTCC
      * Premium
     C*******************PARM                    SPREM            15                         BUG6274
     C                   PARM                    WPREM            15                         BUG6274
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF001 Enhancement
     C                   PARM                    CFF001            1
      ** CFF007 Enhancement
     C                   PARM                    CFF007            1
 
      *
      * Insert correct parameters for this CVT function
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFOTCCAMD'
      *
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      ** Transaction Details OK flags (DS) from/to caller
     C                   PARM                    OKTrOTCC
      ** Customer Settlement OK flags(DS) from/to caller
     C                   PARM                    OKCustSet
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInOTCC
      ** New Customer Settlement details in screen format
     C                   PARM                    NewCuStScn
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrOTCC
      ** Old Customer Settlement Details in Screen Format
     C                   PARM                    CurCuStScn
      * (Current) Deal in file format
     C                   PARM                    OTCCFilfmt
      ** Bank details ICD
     C                   PARM                    SDBANK
      ** Midas module flags
     C                   PARM                    SDMMOD
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** Portfolio Management Details
     C                   PARM                    SDPORT
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs
      ** CFF007 Enhancement
     C                   PARM                    CFF007
 
 
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
 
     C                   CLEAR                   CurTrOTCC
     C                   CLEAR                   CurCuStScn
     C                   CLEAR                   CurBrStScn
 
     C                   MOVE      *ALL'Y'       OKTrOTCC
     C                   MOVE      *ALL'Y'       OKDummyDS
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKBrokSet
 
     C                   CLEAR                   ValidOTCC
     C                   CLEAR                   ValidSett
 
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
      * If transaction number not defined (on insert),
      * get next available transaction number.
     C                   IF        STNBR = *blank
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY         1
     C                   PARM                    STNBR
     C                   PARM                    V_TNBR
 
     C                   ENDIF
 
     C                   IF        SACTN <> 'D'
     C                   EVAL      VSTNBR = V_TNBR
     C                   ELSE
     C                   EVAL      ValidOTCC = OTCCFilFmt
     C                   EVAL      ValidSett = OTSTFilFmt
     C                   ENDIF
 
     C                   EVAL      V_CHTP  = SACTN
                                                                                             BUG4258
      * Restore Timestamp from the original record                                           BUG4258
     C                   IF        SACTN <> 'I'                                              BUG4258
     C                             AND @TIMESTAMP <> *BLANKS                                 BUG4693
     C                   MOVEL     @TimeStamp    V_TMST                                      BUG4258
     C                   ENDIF                                                               BUG4258
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
 
      ** Update the main transaction details
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid transaction
     C                   PARM                    ValidOTCC
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** The settlement details (data structure)
     C                   PARM                    ValidSett
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C                   PARM      'OTCC'        TransType
      ** New OTC instrument Y/N
     C                   PARM                    NewInst
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on
     C                   PARM                    CFF001
      ** General Ledger ICD (SDGELRPD data structure
     C                   PARM                    SDGELR
      ** Midas modules (DS, from SDMMODPD)
     C                   PARM                    SDMMOD
      ** Trade and book positions reconcilable flag (from SDFODAPD)
     C                   PARM                    BXTBRC
 
     C                   IF        ULX605 = 'Y'                                               CER001
                                                                                              CER001
     C                   IF        ReturnCode <> 'Error' and                                  CER001
     C                             ReturnCode <> '*RECUPD'                                    CER001
     C                   MOVE      STNBR         #6LXFFTNBR                                   CER001
     C                   CALLB     'FFTRAN2UP'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM      *BLANKS       ReturnCode                                   CER001
     C                   PARM      'Y'           @@FIND            1                          CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   PARM      *BLANKS       SVRCD                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
      ** If no errors, update settlement instructions.
     C                   IF        ReturnCode <> 'Error' and
     C                             ReturnCode <> '*RECUPD'
 
      * Update the settlement instructions.
     C                   CALLB     'FFSETLUPD'
      * Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      *
      *  Inputs
      *  ~~~~~~
      ** The format containing the valid settlements (data structure)
     C                   PARM                    ValidSett
      ** The format containing the valid transaction (data structure)
     C                   PARM                    ValidOTCC
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** CFF007 enhancement
     C                   PARM                    CFF007
      ** PB customer indicator (Broker)
     C                   PARM                    PPBBFLG
      ** PB customer indicator (Customer)
     C                   PARM                    PPBFLG
 
     C                   ENDIF
      *
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     ReturnCode    IFNE      *BLANK
     C     ReturnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     ReturnCode    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
 
     C                   EndIf
 
 
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
