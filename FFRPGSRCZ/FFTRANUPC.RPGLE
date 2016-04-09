     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Trades database update controller')           *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFTRANUPC - Futures and options trades database update       *
      *              controller                                       *
      *                                                               *
      *  Function:  This module provides the database update control  *
      *             function for futures and options trades           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CAS002             Date 14Jan02               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFF006             Date 28Nov00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 24Feb99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  201589 - Change to check a new locking dataarea FFTRANLCK    *
      *           to determine whether this DBU is already active.    *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CFF006 - Fractional Ticks Enhancement.                       *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  147775 - General FF API fixes                                *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Valid FF transactions
     FFFVTRANPD UF   E             DISK    COMMIT INFSR(*pssr)
     F                                     RENAME(TRANSDF : FFVTRAND0)
 
      ** Valid FF instrument details (for OTCs without a predefined
      ** instrument)
     FFFVINSTL0 UF   E           K DISK    COMMIT INFSR(*pssr)
     F                                     PREFIX(VI)
 
      ** Valid settlement instructions
     FFFVSETLL0 UF   E           K DISK    COMMIT INFSR(*pssr)
     F                                     RENAME(TRSETDF : FFVSETLD0)
     F                                     PREFIX(SI)
 
      ** Instrument details
     FINTYP     IF   E           K DISK    PREFIX(IT)
 
      ** Valid FF transactions with errors from this function
     FFFVETRANPDO    E             DISK    USROPN COMMIT INFSR(*pssr)
     F                                     RENAME(TRANSDF : FFVTRANERR)
 
      ** Valid FF transactions by front-office ID and timestamp, for
      ** reaccessing record if there is an error.
     FFFVTRANL0 UF   E           K DISK    USROPN COMMIT INFSR(*pssr)
     F                                     RENAME(TRANSDF : FFVTRANL)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFTRANU001
      *                                                                                       CER001
     FFFVTNLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FFFVEETX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(FFVTNLXD6:FFVTNLXD6R)                       CER001
     FFFVEOTX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(FFVTNLXD6:FFVTNLXD6S)                       CER001
      *                                                                                       CER001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **--------------------------------------------------------------------------------------------
 
      ** The following /COPY line includes the definitions for fields           CAP006
      ** used in checking whether there are messages on the data queue.         CAP006
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
 
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
 
      ** Database error message string for sending to operator
     D DBerrUpd        C                   'DB error in FF transactions +
     D                                     database update'
 
      ** The lock states used for the allocation data area
     D Exclusive       C                   '*EXCL'
     D ShareRead       C                   '*SHRRD'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Named indicators -------------------------------------------
      ** ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦
     D  NoRecFound            99     99
      ** ¦
      ** ¦ Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦
      ** +----------------------------------------------------------------
 
     D FFVTRAN       E DS                  EXTNAME(FFVTRANPD)
      ** Externally described data structure for valid exchange-traded
      ** transactions.
 
     D FFVSETL       E DS                  EXTNAME(FFVSETLPD) PREFIX(SI)
      ** Externally described data structure for valid settlement
      ** instructions.
 
     D InstType      E DS                  EXTNAME(INTYP) PREFIX(IT)
      ** Data structure for instrument details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
 
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CFF007
      ** Very long data structure for access objects                                          CFF007
                                                                                              CFF007
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger information
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CFF007
      ** Customer Details                                                                     CFF007
                                                                                              CFF007
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * Module details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** Long Access Object Data Structure                                                    CGL029
                                                                                              CGL029
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APTRANDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
      ** Data area allocation fields
      ** ---------------------------
     D Object          S             10A   INZ('FFTRANUPC')
     D LockObj         S             10A   INZ('FFTRANLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockState       S              7A
     D LockStateE      S              7A   INZ('*EXCL')                                       201589
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
 
      ** Key fields for LF/FFVTRANL0
     D KFrontOff       S                   LIKE(FRNT)
     D KTimestamp      S                   LIKE(TMST)
 
      ** Database error message string for sending to operator
     D DBerror         S            132A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Flag for Enhanced OTCs feature
     D CFF001          S              1A
 
      ** Flag for Fractional Ticks Enhancement                                                CFF006
     D CFF006          S              1A                                                      CFF006
                                                                                              CFF006
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
      ** Private Banking customer indicator                                                   CFF007
     D PPBBFLG         S              1                                                       CFF007
     D PPBCFLG         S              1                                                       CFF007
                                                                                              CFF007
      ** Flag to indicate whether or not settlement instructions were
      ** entered
     D SettleIns       S              1A   INZ('Y')
 
      ** A second 'run before' flag for the additional piece of the PSSR
     D RunBefore2      S                   LIKE(RunBefore) INZ('N')
 
      ** The member to override the multimembered database files to
     D OvrMember       S              2A
 
     D PKEY1           S             10                                                       CFF007
     D PKYST           S              7                                                       CFF007
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFTRANU002
                                                                                              CER001
      ** New valid extended Exchange-Traded File                                              CER001
     D FFVTNLX6      E DS                  EXTNAME(FFVTNLX1L0)                                CER001
     D FFVTNLX6S     E DS                  EXTNAME(FFVTNLX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listing
 
      ** +--- Start of Main processing -----------------------------------
      ** ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is
      ** ¦ executed at program activation.
      ** ¦
      ** +----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFTRANU003
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APTRANDTQ'                       CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C                   DOW       DtqDta <> 'END'
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
 
      ** If data queue entry is 'END', leave the DOW loop at this point
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
 
      ** If data queue entry says run, first lock allocation data area
     C     DtqDta        IFEQ      'GO'
 
      ** Set lock state to exclusive
     C                   EVAL      LockState = Exclusive
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
 
      /COPY WNCPYSRC,FFTRANU004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FFVTRANPD
 
      ** Read valid transaction; *in99 is mapped to the variable NoRecFound
     C                   READ      FFVTRAND0                              99
     C                   DOW       NoRecFound = False
 
      ** Set the value to tell the called module what type of transaction
      ** it is processing.  If the month number is zero, it is an OTC.
      ** Also apply database overrides.
     C                   IF        MTHN = 0
     C                   EVAL      TransType = OTCCurr
     C                   EVAL      OvrMember = 'OT'
 
     C                   ELSE
     C                   EVAL      TransType = ExchTrade
 
      ** The member to override to is the market code, which is the
      ** first two characters of the instrument type.
     C                   EVAL      OvrMember = %subst(ISTT : 1 : 2)
 
     C                   ENDIF
      **                 (End of "if MTHN = 0")
 
      ** Apply the overrides
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    OvrMember
 
      /COPY WNCPYSRC,FFTRANU005
 
     C                   EVAL      KFrontOff  = FRNT
     C                   EVAL      KTimestamp = TMST
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower-level modules
      ** will include the key information
     C                   EVAL      ARFOTranID = FRNT
     C                   EVAL      ARFOAsocID = AFRT
     C                   EVAL      ARRprLocn  = REPA
 
      ** Initialize Error indicator & New OTC instrument indicator
 
     C                   EVAL      ErrorFound = 'N'
     C                   EVAL      NewOTCInst = 'N'
 
      ** Get the customer and broker settlement details.
 
     C     KVTran        CHAIN     FFVSETLL0                          99
 
      ** If no record was found, it is an error
 
     C                   IF        NoRecFound = True
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      ERROR
     C                   ENDIF
 
      ** Get the instrument details
 
     C                   CLEAR                   InstType
     C     ISTT          CHAIN     INTYP                              99
 
      ** If no record was found, and the transaction is an
      ** exchange-traded instrument, it is an error
 
     C                   IF        NoRecFound = True AND
     C                             TransType = ExchTrade
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      ERROR
     C                   ENDIF
 
      ** If no record found, and the transaction is an OTC, access the
      ** valid instruments file (OTCs do not need a predefined
      ** instrument, but can define the instrument details on input).
 
     C                   IF        NoRecFound = True AND
     C                             TransType = OTCCurr
     C     KVTran        CHAIN     FFVINSTL0                          99
 
      ** If no record is found at this point, it is an error
 
     C                   IF        NoRecFound = True
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      ERROR
     C                   ENDIF
 
      ** Copy the fields from the valid instrument details record to the
      ** data structure based on INTYPD for passing to the update function.
 
      /COPY WNCPYSRC,FFTRANU006
 
     C                   EXSR      CpyInstDta
 
      /COPY WNCPYSRC,FFTRANU007
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFTRANU008
 
      ** Call the submodules to do the database updates
     C                   EXSR      CallUpdMod
 
      /COPY WNCPYSRC,FFTRANU009
      *                                                                                       CER001
     C     ReturnCode    IFEQ      *BLANKS                                                    CER001
      *                                                                                       CER001
      ** Retrieve Extended valid record                                                       CER001
      *                                                                                       CER001
     C     ULX604        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     ULX605        OREQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     TNBR          CHAIN     FFVTNLX1L0                         89                      CER001
      *                                                                                       CER001
      ** FF Extended database update                                                          CER001
      *                                                                                       CER001
     C                   MOVE      TNBR          #6LXFFTNBR                                   CER001
     C                   CALLB     'FFTRAN2UP'                                                CER001
     C                   PARM                    CHTP                                         CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM      'Y'           @@FIND            1                          CER001
     C                   PARM                    FFVTNLX6                                     CER001
     C                   PARM      *BLANK        FFVTNLX6S                                    CER001
      *                                                                                       CER001
     C     ReturnCode    IFEQ      *BLANK                                                     CER001
     C                   DELETE    FFVTNLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C     ERROR         TAG
                                                                                              CER001
      *                                                                                       CER001
      ** If an error has occurred, reaccess record in error and remove from                   CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C     ReturnCode    IFEQ      '*ERROR '                                                  CER001
     C     ReturnCode    OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C     ULX604        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
     C     ULX605        OREQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
      *                                                                                       CER001
     C     TNBR          CHAIN     FFVTNLX1L0                         89                      CER001
      *                                                                                       CER001
     C     ULX604        IFEQ      'Y'                                                        CER001
     C                   WRITE     FFVTNLXD6R                                                 CER001
     C                   ENDIF                                                                CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C                   WRITE     FFVTNLXD6S                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   DELETE    FFVTNLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
      ** If no error, commit the database updates; otherwise roll them
      ** back.
     C                   IF        ReturnCode <> 'Error' AND
     C                             ReturnCode <> '*RECUPD' AND
     C                             ErrorFound <> 'Y'
 
     C                   DELETE    FFVTRAND0
 
      ** The delete of an FFVINSTD0 record may or may not be valid; the
      ** error indicator acts like a MONMSG in CL, to trap invalid
      ** deletes.  There is no error if the delete is invalid.
      ** Similarly for FFVSETLPD.
     C                   DELETE    FFVINSTD0                            99
     C                   DELETE    FFVSETLD0                            99
 
     C                   COMMIT
     C/COPY WNCPYSRC,FFTRANUPC1
 
     C                   ELSE
 
      ** Perform error processing, including rollback
     C                   EXSR      TransError
 
      ** End of "If ReturnCode <> 'Error' and ErrorFound <> 'Y'"
     C                   ENDIF
 
      ** Remove the multimembered file overrides
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
      ** Read valid transaction
     C                   READ      FFVTRAND0                              99
 
      ** End of "DOW records on valid file"
     C                   ENDDO
 
 
      ** Unlock allocation data area
     C                   EVAL      LockState = Exclusive
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    Return
 
      ** End of "if data queue entry = 'GO'"
     C                   ENDIF
 
      ** End of "Do while data queue entry <> 'END'"
     C                   ENDDO
 
      ** Unlock allocation data area
     C                   EVAL      LockState = ShareRead
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    Return
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFTRANU010
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFTRANU011
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallUpdMod - Call the submodules to update the database       *
      *                                                               *
      *****************************************************************
 
     C     CallUpdMod    BEGSR
 
      ** Change TransType from 'OTCC' to 'OTCO' for non-currency OTC                          CAP166
                                                                                              CAP166
     C                   IF        TransType = OTCCurr and ITISPT <> 5                        CAP166
     C                   EVAL      TransType = OTCOvar                                        CAP166
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** FF database update
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid transaction
     C                   PARM                    FFVTRAN
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** The settlement details (data structure)
     C                   PARM                    FFVSETL
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C                   PARM                    TransType
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
 
      ** If no errors, update settlement instructions
 
     C                   IF        ReturnCode <> 'Error'
 
      ** Determine if customer is a PB customer when CFF007 is installed                      CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
                                                                                              CFF007
     C                   MOVEL     BOCO          PKEY1                                        CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*KEY   '     @OPTN                                        CFF007
     C                   PARM                    PKEY1                                        CFF007
     C                   PARM                    PKYST                                        CFF007
     C     SDCUST        PARM      SDCUST        DSLDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVEL     BBPRBA        PPBBFLG                                      CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   MOVEL     CUSC          PKEY1                                        CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*KEY   '     @OPTN                                        CFF007
     C                   PARM                    PKEY1                                        CFF007
     C                   PARM                    PKYST                                        CFF007
     C     SDCUST        PARM      SDCUST        DSLDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVEL     BBPRBA        PPBCFLG                                      CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid settlement instructions; broker
      ** and customer.
     C                   PARM                    FFVSETL
      ** The format containing the valid transaction (data structure)
     C                   PARM                    FFVTRAN
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator (Broker)                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator (Customer)                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
      ** End of "If ReturnCode <> 'Error'
     C                   ENDIF
 
      ** If either called module returned errors, error processing will be
      ** performed by the caller of this subroutine.
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TransError - Processing for a transaction in error            *
      *                                                               *
      *****************************************************************
 
     C     TransError    BEGSR
 
     C                   ROLBK
 
      /COPY WNCPYSRC,FFTRANU012
 
      ** If an error has occurred, reaccess record in error (because
      ** the rollback will have lost the lock) and remove
      ** from the file to prevent program processing the same record again.
     C                   OPEN      FFVTRANL0
     C     KVTran        CHAIN     FFVTRANL0                          99
 
      ** Write details of record to error file (same format as FFVTRANL0).
     C                   OPEN      FFVETRANPD
     C                   WRITE     FFVTRANERR
 
      ** Remove record from valid file.
     C                   DELETE    FFVTRANL
 
     C                   COMMIT
 
     C                   CLOSE     FFVTRANL0
     C                   CLOSE     FFVETRANPD
 
     ** Send message to system operator
     C                   RESET                   ReturnCode
     C                   CLEAR                   DBError
     C                   EVAL      DBerror = DBErrUpd
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CpyInstDta - Copy the instrument fields from the FFVINSTPD    *
      *              format to the INTYPD format.                     *
      *                                                               *
      *****************************************************************
 
     C     CpyInstDta    BEGSR
 
     C                   EVAL      NewOTCInst = 'Y'
 
     C                   EVAL      ITRECI = VIRECI
     C                   EVAL      ITISTT = VIISTT
     C                   EVAL      ITISTI = VIISTI
     C                   EVAL      ITISPT = VIISPT
     C                   EVAL      ITISCY = VIISCY
     C                   EVAL      ITQOTC = VIQOTC
     C                   EVAL      ITTKDM = VITKDM
      *                                                                                       CFF006
      ** If CFF006 is installed, default value of the Fractional Ticks                        CFF006
      ** Processed field to 'N' only if the ticks denominator is 100.                         CFF006
     C                   IF        CFF006 = 'Y' AND ITTKDM = 100                              CFF006
     C                   EVAL      ITFRTK = 'N'                                               CFF006
     C                   ENDIF                                                                CFF006
                                                                                              CFF006
     C                   EVAL      ITMNPF = VIMNPF
     C                   EVAL      ITTKVL = VITKVL
     C                   EVAL      ITCTAM = VICTAM
     C                   EVAL      ITCMRF = VICMRF
     C                   EVAL      ITOTHC = VIOTHC
     C                   EVAL      ITPUPF = VIPUPF
     C                   EVAL      ITFTDT = VIFTDT
     C                   EVAL      ITSETD = VISETD
     C                   EVAL      ITAEIN = VIAEIN
     C                   EVAL      ITCCAM = VICCAM
     C                   EVAL      ITCTCY = VICTCY
     C                   EVAL      ITFTTM = VIFTTM
     C                   EVAL      ITINNR = VIINNR
     C                   EVAL      ITUNSE = VIUNSE                                            CFF007
     C                   EVAL      ITTECO = VITECO                                            CFF007
     C                   EVAL      ITTNAT = VITNAT                                            CFF007
     C                   EVAL      ITCRIK = VICRIK                                            CFF007
     C                   EVAL      ITCCYR = VICCYR                                            CFF007
     C                   EVAL      ITTWEI = VITWEI                                            CFF007
 
     C                   EVAL      ITPLMIIT = VIPLMIIT                                        CAP166
     C                   EVAL      ITPLMITM = VIPLMITM                                        CAP166
     C                   EVAL      ITPLMIMD = VIPLMIMD                                        CAP166
     C                   EVAL      ITPLMICP = VIPLMICP                                        CAP166
     C                   EVAL      ITPLMICF = VIPLMICF                                        CAP166
     C                   EVAL      ITPLMIPC = VIPLMIPC                                        CAP166
     C                   EVAL      ITPLMIVT = VIPLMIVT                                        CAP166
     C                   EVAL      ITPLMIPM = VIPLMIPM                                        CAP166
     C                   EVAL      ITPLMIPG = VIPLMIPG                                        CAP166
     C                   EVAL      ITPLMIRG = VIPLMIRG                                        CAP166
     C                   EVAL      ITPLMICR = VIPLMICR                                        CAP166
                                                                                              CAP166
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
      *  Check if an existing DBU_TRAN job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      ** Access SAR Details to determine whether Enhanced OTCs is present
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF001'      @SARD             6
 
     C                   IF        @RTCD = *blank
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Access SAR Details to determine whether FF Fractional Ticks                          CFF006
      ** enhancement is installed                                                             CFF006
     C                   CALLB     'AOSARDR0'                                                 CFF006
     C                   PARM      '       '     @RTCD                                        CFF006
     C                   PARM      '*VERIFY'     @OPTN                                        CFF006
     C                   PARM      'CFF006'      @SARD                                        CFF006
                                                                                              CFF006
     C                   IF        @RTCD = *blank                                             CFF006
     C                   EVAL      CFF006 = 'Y'                                               CFF006
     C                   ELSE                                                                 CFF006
     C                   EVAL      CFF006 = 'N'                                               CFF006
     C                   ENDIF                                                                CFF006
                                                                                              CFF006
      ** Access SAR Details to determine whether Futures and Options                          CFF007
      ** enhancement for Private Banking is installed.                                        CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      @SARD                                        CFF007
                                                                                              CFF007
     C                   IF        @RTCD = *blanks                                            CFF007
     C                   EVAL      CFF007 = 'Y'                                               CFF007
     C                   ELSE                                                                 CFF007
     C                   EVAL      CFF007 = 'N'                                               CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** General Ledger Details
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Access the Midas modules file for the multibranching indicator
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDFODA        PARM      SDFODA        DSFDY
 
 
 
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *   of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
 
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
 
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
 
      *   Processing   *EXCL       No        None        No         None
 
     C                   EVAL      LockState = ShareRead
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Key lists
      ** ---------
 
      ** LF/FFVTRANL0
     C     KVTran        KLIST
     C                   KFLD                    KFrontOff
     C                   KFLD                    KTimestamp
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFTRANU013
      *                                                                                       CER001
      ** ULX604 - API Luxembourg - Function FFEXTR                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX604            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX604'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX604                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX604'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 1                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX605 - API Luxembourg - Function FFOTCC                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX605            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX605'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX605                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX605'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 2                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - Comissariat aux Bourses                                                     CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX008            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX008'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 3                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX604        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FFVTNLX1L0                                                 CER001
     C                   OPEN      FFVEETX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
     C                   OPEN      FFVEOTX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ULX605        IFEQ      'Y'                                                        CER001
     C     ULX008        ANDEQ     'Y'                                                        CER001
     C     ULX604        ANDEQ     'N'                                                        CER001
     C                   OPEN      FFVTNLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      ** This is the version without an ENDSR, because additional
      ** processing is added.
     C/COPY ZACPYSRC,PSSR_ILENE
      **--------------------------------------------------------------------------------------------
 
      ** Whatever has gone wrong, execute the TransError subroutine,
      ** so that the current transaction is logged to the appropriate
      ** error file, and is removed from the the valid file so that
      ** it won't be processed again.
      ** Then end this procedure.
     C                   IF        RunBefore2 <> 'Y'
     C                   EVAL      RunBefore2 = 'Y'
     C                   EXSR      TransError
 
      ** Unlock the allocation data area (both types of lock).  This
      ** may not be strictly necessary, but is useful for testing.
     C                   EVAL      LockState = Exclusive
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    Return
 
     C                   EVAL      LockState = ShareRead
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    Return
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
