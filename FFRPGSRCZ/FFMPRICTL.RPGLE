     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Interface Controller')          *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Market Price Module              *
      *                                                               *
      *  FFMPRICTL - Market Price Interface Controller                *
      *                                                               *
      *  Function:  This module receives the data from the FF MPRI    *
      *             API, and passes it on to the validation and other *
      *             functions.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CAP183  *CREATE    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Valid Transaction file
     FFFVMPRIPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      ** Invalid Transactions
     FFFIMPRIPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
     FFFVMPRIL1 IF   E           K DISK    RENAME(FFVMPRID0:FFVMPRICHK)
     F                                     INFSR(*pssr)
     FFFVMPRIL0 IF   E           K DISK    RENAME(FFVMPRID0:FFVMPRICH1)
     F                                     INFSR(*pssr)
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Midas FF Instrument Types
     FINTYP     IF   E           K DISK
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFMPRIC001
 
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
     D/COPY ZACPYSRC,FVAL_ARRAY
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D TABMT           S              3    DIM(12) CTDATA PERRCD(1)
     D TABNO           S              2  0 DIM(12) ALT(TABMT)
 
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **------------------------------------------------------------------
 
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
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Transaction (new) in screen format
     D TranIn        E DS                  EXTNAME(FFMPRIPD)
 
      ** Valid Customer Securities Details layout
     D ValidTran     E DS                  EXTNAME(FFVMPRIPD)
     D                                     PREFIX(V_)
 
      ** (Current) Transaction record in file Format
     D TranFilFmt    E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(D_)
 
      ** (Current) Transaction in Screen Format - Main Details
     D TranScnFmt    E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@)
 
      ** Error indicators
     D OKTransDet    E DS                  EXTNAME(FFEMPRIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** FF Extention data Market Price - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFMPEXPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Switchable feature
     D PSARD           S              6A
 
      ** CSC011 enhancement
     D CSC011          S              1A   INZ('N')
 
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A   INZ(*BLANKS)
 
      ** Transaction number to be passed to APLOGTRAN
     D PTranCd         S             24A   INZ(*BLANKS)
 
      ** Associated transaction number
     D PATranCd        S             24A   INZ(*BLANKS)
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Transaction Reference
     D DDTRNN          DS
     D  DDISTT                 1      5
     D  DDMRK1                 1      2
     D  DDIST1                 3      5
     D  DDMTH1                 6      8
     D  DDYRN1                 9     10
     D  DDPCA1                11     11
     D  DDSTR1                12     27
     D   DDTRN@                1     11
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('FFMPRIUPC')
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
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepMPRI         S              1A   INZ('N')
      *
     D NDDSTRP         S             15P 8
      *
     D K@YRNO          S              2S 0
     D K@MNTH          S              2S 0
     D K@STRP          S             15P 8
      *
      ** 13,0S and 1,0S field for passing to FFVSTRKPR
     D Zero13S         S             13S 0 INZ(0)
     D Zero1S          S              1S 0 INZ(0)
      *
     D PDDACTN         S              1A
 
      ** APYOVR  parameter
     D wMember         S              2A
     D wMarketIns      S              5A
 
      ** Flags
     D POTCFlag        S              1A
     D wInstMissingF   S              1A
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFMPRIC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFMPRIC003
 
      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranIn
     C                   MOVEL     Extdata500    Extdata
      *
      ** Convert Month to numeric
     C     DDMTHN        LOOKUP    TABMT         TABNO                    86
     C                   IF        *IN86
     C                   Z-ADD     TABNO         #MTHNUM           2 0
     C                   ENDIF
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FFMPRIC004
 
      ** Check if valid transaction exists for Front Office ID
     C                   EXSR      ChkValMPRI
      *
      ** If valid transaction details does exist (even after delay), fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate Action Code and Key Fields
 
     C                   EXSR      ValidateAc
 
      ** If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if valid Transaction exists for Midas Transaction Number
     C                   EXSR      ChkValMiFf
      *
      ** If valid Transaction does exist (even after delay), fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid Transaction details file.
 
     C                   EXSR      RESETCYCLE
      /COPY WNCPYSRC,FFMPRIC005
      *
      /COPY WNCPYSRC,FFMPRIC006
 
      ** Processing depends upon Action Code
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
 
      ** Processing for Inserts
      /COPY WNCPYSRC,FFMPRIC007
     C                   EXSR      ValidateTr
 
      ** If error in validation of action code, fail this input
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      /COPY WNCPYSRC,FFMPRIC008
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'
 
      ** Processing for Amends or Changes
      /COPY WNCPYSRC,FFMPRIC009
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        DDACTN = 'A' AND GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranIn                                 99
     C                   IF        *in99
     C                   EVAL      RepMPRI = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substitution subroutine.
     C                   IF        RepMPRI = 'Y'
     C                   EXSR      DtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
      ** (End of "if DDACTN = 'A' AND GHSUBS <> *blank")
 
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,FFMPRIC010
 
      ** Validate if Amend
     C                   IF        DDACTN ='A'
     C                   EXSR      ValidateTr
      *
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FFMPRIC011
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,FFMPRIC012
 
     C                   IF        ARERRMOD <> *BLANK
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
 
      ** Processing for Error checking/write to database
      /COPY WNCPYSRC,FFMPRIC013
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,FFMPRIC014
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EVAL      ObjType = '*DTAARA'
 
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C                   IF        RETURN = *BLANK
 
      **------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFMPRIC015
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteLog - Setup data to be written to standard API log    *
      *               file.                                           *
      *  Calls: APLOGTRAN                                             *
      *                                                               *
      *****************************************************************
 
     C     SRWriteLog    BEGSR
 
      ** Setup value of TRANSDTL
     C                   EVAL      TRANSDTL = TranIn + ExtData500
 
      ** Initialise Deal no to pass
     C                   EVAL      PTranCd = DDTRN@
 
      ** Call program that will write to API standard log file.
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    TimeStamp
     C                   PARM                    PTranCd
     C                   PARM      *BLANKS       PATranCd
 
      ** If error occurred, perform abnormal termination
     C     ReturnCode    IFNE      *BLANKS
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *pssr
     C                   END
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Common header information (DS) from source system
     C                   PARM                    HeadIn
 
      ** Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    ExtData500
 
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'DRSMM'
 
      ** Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'FF'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access SAR details file to determine if MDF Switchable feature
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CSD006            1
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   END
 
 
      ** Determine if 24x7 Midas availability is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSC011'
     C                   EVAL      DBASE = 1
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APMPRIDTQ'
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFMPRIC018
 
     C                   ENDSR
      ********************************************************************
      *                                                                  *
      * ChkValMPRI - Routine to check if valid Transaction details exist *
      *                                                                  *
      ********************************************************************
     C     ChkValMPRI    BEGSR
 
      ** Check for transaction on Valid file
     C     APFOTranID    CHAIN     FFVMPRIL0                          99
 
      ** If record found...
     C                   IF        *IN99 = *OFF
 
      ** ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     FFVMPRIL0                          99
 
      ** Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'APFOTranID'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiFf - Routine to check if valid Transaction xxxxxxxxx  *
      *    exists for Midas Transaction number                        *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiFf    BEGSR
      *
     C                   MOVE      DDYRN1        K@YRNO
     C                   Z-ADD     #MTHNUM       K@MNTH
     C
      ** Key list for file FFVMPRIL1
     C     KyMPRI        KLIST
     C                   KFLD                    DDISTT
     C                   KFLD                    K@YRNO
     C                   KFLD                    K@MNTH
     C                   KFLD                    DDPCA1
     C                   KFLD                    NDDSTRP
      *
 
      ** Check for Transaction on Valid file
     C     KyMPRI        CHAIN     FFVMPRIL1                          99
 
      ** If record found...
     C                   IF        *IN99 = *OFF
 
      ** ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     KyMPRI        CHAIN     FFVMPRIL1                          99
 
      ** Error if still present
     C                   IF        *IN99 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISTC'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Transaction number supplied                                *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** if insert
      ** if not insert and Midas transaction ID is not present
      ** Otherwise
      *
     C                   EVAL      DDMRK1 = DDMRKT
     C                   EVAL      DDIST1 = DDISTC
     C                   EVAL      DDMTH1 = DDMTHN
     C                   EVAL      DDYRN1 = DDYRNO
     C                   EVAL      DDPCA1 = DDPCAL
     C                   EVAL      DDSTR1 = DDSTRP
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   IF        DDTRNN = *BLANKS
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = '      '
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate action code versus transaction IDs supplied
      ** The Transaction in file format from the ff database is retrieved
      ** as well.
 
     C                   RESET                   ReturnCode
      *
     C                   EVAL      PDDACTN = DDACTN
 
      ** Check if Instrument is OTC
     C                   EXSR      SrOTCCheck
 
     C                   IF        POTCFlag = 'Y'
     C                             OR wInstMissingF = 'Y'
     C                   EVAL      wMember = 'OT'
     C                   ELSE
     C                   EVAL      wMember = DDMRKT
     C                   ENDIF
 
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    wMember
      *
     C                   CALLB     'FFMPRIRTV'
      *
      ** Inputs
      *
      ** Return code
     C                   PARM      *BLANK        ReturnCode
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ** Response mode
     C                   PARM                    APRESPMODE        1
      *
      ** Action Code
     C                   PARM                    PDDACTN           1
      *
      ** Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      ** (Midas) Transaction Number
     C                   PARM                    DDTRNN
 
     C                   PARM      'K'           PSCRN             1
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      *
      ** Outputs
      *
      ** (Current) Transaction in file format
     C                   PARM                    TranFilFmt
      *
     C                   PARM                    OKTransDet
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Market Name
     C                   PARM                    PMrktNm          20
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PBusDat           7
      ** Valid Transaction details layout (DS) from/to caller
 
     C                   PARM                    InstTypes
 
     C                   PARM                    NDDSTRP
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
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
 
      ** For Amends, put the complete (pre-existing) Transaction into the Valid
      ** file record - fields in this will be updated during processing
 
     C                   MOVE      TranFilFmt    ValidTran
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      ** Validate Market Price Transaction details
 
     C                   EXSR      ValdTrMPRI
      *
      ** If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrMPRI - Validate Market Price Transaction details        *
      *                                                               *
      *****************************************************************
     C     ValdTrMPRI    BEGSR
 
     C                   CALLB     'FFMPRIVAL'
 
      ** Inputs
 
      ** Response mode
     C                   PARM                    RespMode          1
      ** Market Price Transaction Details
     C                   PARM                    TranIn
      ** Extra Data
     C                   PARM                    Extdata
      ** Strike Price
     C                   PARM                    NDDSTRP
      * Outputs
      *
      ** Market Price Transaction Details OK inds
     C                   PARM                    OkTransDet
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Market Price Transaction (DS) from/to caller
     C                   PARM                    ValidTran
      ** Valid Market Price Transaction (DS) from/to caller
     C                   PARM                    InstTypes
 
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
 
      ** If no errors were found:
      **    - set up additional data
      **    - write a record to the Valid file
      **    - use std message handler to report customer status
      ** If any errors were found:
      **    - write a record to the Invalid file
      **    - call the message handler to pass the errors back
      **    - use std message handler to report trade status
      ** The index to the error arrays is checked for presence/absence of
      ** errors
     
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
 
     C                   IF        Idx = 0
 
     C                   EXSR      SETUPVALID
     C                   WRITE     FFVMPRID0
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      ** Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
     C                   WRITE     FFIMPRID0
 
      ** If CSC011 is present and CTL is still running in the support
      ** system, write invalid details to APIlogfile.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EXSR      SRWriteLog
     C                   ENDIF
 
 
     C                   ENDIF
 
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
     C                   COMMIT
 
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
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   TranScnFmt
 
     C                   MOVE      *ALL'Y'       OkTransDet
 
     C                   CLEAR                   ValidTran
 
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
 
     C                   EVAL      DIMKTN = DDMKTN
     C                   EVAL      DIBUSD = DDBUSD
     C                   EVAL      DIACTN = DDACTN
     C                   EVAL      DIMRKT = DDMRKT
     C                   EVAL      DIISTC = DDISTC
     C                   EVAL      DIMTHN = DDMTHN
     C                   EVAL      DIYRNO = DDYRNO
     C                   EVAL      DIPCAL = DDPCAL
     C                   EVAL      DISTRP = DDSTRP
     C                   EVAL      DIISTN = DDISTN
     C                   EVAL      DINEWP = DDNEWP
     C                   EVAL      DINWPI = DDNWPI
     C                   EVAL      DIRSKF = DDRSKF
 
      ** Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DIFRNT = APFOTranID
     C                   EVAL      DIAFRT = APFOAsocID
     C                   EVAL      DIREPA = APRprLocn
     C                   MOVE      TimeStamp     DITMST
      *
     C                   EVAL      TranStatus = 'F'
      *
      /COPY WNCPYSRC,SDSECDC016
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
 
      *
     C                   IF        DDACTN = 'I'
     C                   EVAL      V_DVISTT = D_ISTT
     C                   EVAL      V_DVYRNO = D_YRNO
     C                   EVAL      V_DVMTHN = D_MTHN
     C                   EVAL      V_DVPCAL = D_PCAL
     C                   EVAL      V_DVSTRP = D_STRP
     C                   EVAL      V_DVPLEC = *ZEROS
     C                   EVAL      V_DVPBEC = *ZEROS
     C                   EVAL      V_DVPRSM = *ZEROS
     C                   ENDIF
      *
     C                   EVAL      V_DVRECI = *BLANK
     C                   EVAL      V_DVLCD  = *ZEROS
     C                   EVAL      V_DVTNLU = *ZEROS
      *
      ** For Deletes, put the complete (pre-existing) transaction
      ** into the Valid file record
     C                   IF        DDACTN = 'D'
     C                   EVAL      ValidTran = TranFilFmt
     C                   ENDIF
      *
      ** Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_DVCHTP = DDACTN
 
      ** Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_DVFRNT = APFOTranID
     C                   EVAL      V_DVAFRT = APFOAsocID
     C                   EVAL      V_DVREPA = APRprLocn
     C                   EVAL      V_DVTMST = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,SDSECDC017
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
      ** with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
 
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVEL(P)  DDTRN@        P@TRAN           20
      *
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
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
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20, from caller)
     C                   PARM                    P@TRAN
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
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
 
     C     DtaSubs       BEGSR
 
      ** Convert file fields to screen format
     C                   RESET                   ReturnCode
     C                   CALLB     'FFMPRICVT'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Input parameters
      ** Market Price Transaction - file formats
     C                   PARM                    TranFilFmt
      *
      ** Output parameters
      ** Market Price Transaction Details - screen formats
     C                   PARM                    TranScnFmt
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepMPRI = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranIn        IncData        2000
      ** Current Data
     C                   PARM      TranScnFmt    CurData        2000
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrOTCCheck - Check if instrument is OTC
      *****************************************************************
     C     SrOTCCheck    BEGSR
 
      ** Obtain five character instrument
     C                   EVAL      wMarketIns = DDISTT
 
      ** Chain to INTYP
     C     wMarketIns    CHAIN     INTYP
 
     C                   EVAL      POTCFlag = 'N'
     C                   EVAL      wInstMissingF = 'N'
     C                   IF        %FOUND(INTYP)
     C                   IF        ISTI = 'Y'
      ** If Found and Instrument Indicator is 'Y', assume that it is
      ** an OTC instrument.
     C                   EVAL      POTCFlag = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      wInstMissingF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
**  TABMT/TABNO
JAN01
FEB02
MAR03
APR04
MAY05
JUN06
JUL07
AUG08
SEP09
OCT10
NOV11
DEC12
