     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees interface controller')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFECTL - Dealing Fees Interface Controller                *
      *                                                               *
      *  Function: This program will processes incoming Dealing Fees  *
      *            messages from Meridian Interface and determine     *
      *            whether they are valid or invalid.                 *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS009  *CREATE    Date 06Jun04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL Valid Dealing Fees
     FDLVDLFEPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas DL Invalid Dealing Feess
     FDLIDLFEPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas DL Valid Dealing Fees by Front Ofc ID
     FDLVDLFEL0 IF   E           K DISK    RENAME(DLVDLFED0:DLVDLFECH0)
 
      ** Midas DL Valid Dealing Fees by Deal Number/Timestamp
     FDLVDLFEL1 IF   E           K DISK    RENAME(DLVDLFED0:DLVDLFECH1)
 
      ** Field Sequence Numbers
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Hook to enable non-core files to be included
     F/COPY WNCPYSRC,DLDLFEC001
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  80  - Scan/Chain/Lookup indicator                            *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
 
      *  SRCALMSGHD - Call the Message Handling module                *
      *  SRDTASUBS  - Data Substitution                               *
      *  *INZSR     - Program Initialisation                          *
      *  *PSSR      - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes definitions for thefields
      ** #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member.
     D/COPY ZACPYSRC,PROCPARMS
      **--------------------------------------------------------------------------------------------
 
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
     D WProcErr        C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Dealing Fee Transaction
     D TranInDLFE    E DS                  EXTNAME(DLDLFEPD)
 
      ** Valid Dealing Fee layout
     D ValidDLFE     E DS                  EXTNAME(DLVDLFEPD)
 
      ** Current Transaction in Screen Format - Main Details
     D CurDFScnFmt   E DS                  EXTNAME(DLDLFEPD)
     D                                     PREFIX(V_)
 
      ** Current Dealing Fee Record in File Format
     D CurDFFilFmt   E DS                  EXTNAME(DLVDLFEPD)
     D                                     PREFIX(C_)
 
      ** Previous Dealing Fee Detail in File Format
     D PrvDFFilFmt   E DS                  EXTNAME(DLVDLFEPD)
     D                                     PREFIX(P_)
 
      ** Flags to indicate whether dealing fee fields are valid
     D OKFlagsDS     E DS                  EXTNAME(DLEDLFEPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Pay Settlement Instructions
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
 
      ** Receive Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
 
      ** FRA/IRS Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
 
      ** DL Money market & loans deals details
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
 
      ** DL Money market & loans deals details
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields to receive the dealing fee record
     D Trans500        S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D A               S              3P 0
     D B               S              3P 0
 
      ** Parameters for data substitution program
     D IncData         S           2000
     D CurData         S           2000
 
      ** Work fields for data substitution
     D WSubForTR01     S              2  0
 
      ** DLDLFE key fields
     D KDLNO           S              6  0
     D KFSEQ           S              2  0
 
      ** Access object parameters
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Transaction Id
     D PTRANID         S             20
 
      ** Mode of operation
     D PModeofOp       S              6A
 
      ** The transaction's status
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('DL')
 
      ** Timestamp for the transaction
     D PTimestamp      S               Z
 
      ** Fields for data area locking
     D PObject         S             10A   INZ('DLDLFEUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A   INZ('*DTAARA')
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcobj         S              1A   INZ('Y')
     D PReturn         S              7A
 
      ** Parameters and work fields for ZAMSGTOOPR
     D PLongError      S            132A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgId     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepTran         S              1A   INZ('N')
 
      ** Other fields
     D PKYCFQ          S              1A
     D DDSTAT          S             16A
 
     D CSC011          S              1A
     D TRANSDTL        S           5800A
     D PDealNum        S             18A
     D PADealNo        S             18A
     D PSard           S              6A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     D/COPY WNCPYSRC,DLDLFEC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C/COPY WNCPYSRC,DLDLFEC003
 
      ** Incoming dealing fees are in a 500A field so that a common CLP
      ** can be used between this module and the one that reads the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structures.
     C                   MOVEL     Trans500      TranInDLFE
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
      ** Reset variables gradually updated
     C                   EXSR      SRRESETFLD
 
     C/COPY WNCPYSRC,DLDLFEC004
 
      ** Check if dealing fees record exists for front office Id in the valid
      ** records file
     C                   EXSR      SRCHKDLFE
 
      ** If valid DLFE details does exist (even after delay), fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if dealing fees record exists in the valid
      ** records file
     C                   EXSR      SRCHKMDLFE
 
      ** If valid DLFE details does exist (even after delay), fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid DLFE file
     C                   EXSR      SRRESETFLD
 
     C/COPY WNCPYSRC,DLDLFEC005
 
      ** Validate Action Code
     C                   EXSR      SRVACTION
 
      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction
     C                   SELECT
 
      ** Insert
     C                   WHEN      DDACTN = 'I'
 
     C/COPY WNCPYSRC,DLDLFEC007
 
      ** Validate the main details of the transaction
     C                   EXSR      SRVTRANS
 
     C/COPY WNCPYSRC,DLDLFEC008
 
      ** Amend or Delete
     C                   WHEN      DDACTN = 'A' OR
     C                             DDACTN = 'D'
 
     C/COPY WNCPYSRC,DLDLFEC009
 
      ** Convert original dealing fees details from file to screen format
     C                   EXSR      SRCVTDLFE
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        DDACTN = 'A' AND
     C                             GHSUBS <> *BLANK
     C     GHSUBS        SCAN      TranInDLFE
     C                   IF        %FOUND
     C                   EVAL      RepTran = 'Y'
     C                   ENDIF
 
      ** If the flag above is set true, process data substitution
     C                   IF        RepTran = 'Y'
     C                   EXSR      SRDTASUBS
     C                   ENDIF
     C                   ENDIF
 
     C/COPY WNCPYSRC,DLDLFEC010
 
      ** Validate the main details of the transaction
     C                   EXSR      SRVTRANS
 
     C/COPY WNCPYSRC,DLDLFEC011
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Check for exception error from any program lower in the stack
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program (LogError subroutine
      ** includes a RETURN)
 
     C                   IN        APDUMP
 
     C/COPY WNCPYSRC,DLDLFEC012
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EXSR      SRLOGERROR
     C                   ENDIF
 
     C/COPY WNCPYSRC,DLDLFEC013
 
      ** Processing for Error checking/write to database
     C                   EXSR      SRCHKWRITE
 
     C/COPY WNCPYSRC,DLDLFEC014
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EXSR      SRSNDPRMPT
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
      * Hook to enable non-core subroutines to be included
     C/COPY WNCPYSRC,DLDLFEC015
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKDLFE   - Routine to check if valid dealing fees record    *
      *               exists for front office Id                      *
      *                                                               *
      *****************************************************************
 
     C     SRCHKDLFE     BEGSR
 
      ** Check for front office id in the valid records file
     C     APFOTRANID    CHAIN     DLVDLFEL0
 
      ** If record found, delay then repeat check
     C                   IF        %FOUND(DLVDLFEL0)
     C                   CALLB     'ZACDELAY'
     C     APFOTRANID    CHAIN     DLVDLFEL0
 
      ** Error if still present
     C                   IF        %FOUND(DLVDLFEL0)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKMDLFE  - Routine to check Midas valid dealing fees       *
      *               records exists in the valid records file        *
      *                                                               *
      *****************************************************************
 
     C     SRCHKMDLFE    BEGSR
 
      ** Check for dealing fees record on Valid file
     C                   MOVE      DDDLNO        KDLNO
     C                   MOVE      DDFSEQ        KFSEQ
     C     KDEALFEE      CHAIN     DLVDLFEL1
 
      ** If record found, delay then repeat check
     C                   IF        %FOUND(DLVDLFEL1)
     C                   CALLB     'ZACDELAY'
     C     KDEALFEE      CHAIN     DLVDLFEL1
 
      ** Error if still present
     C                   IF        %FOUND(DLVDLFEL1)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVACTION   - Routine to validate action code versus the      *
      *               dealing fees supplied                           *
      *                                                               *
      *****************************************************************
 
     C     SRVACTION     BEGSR
 
      ** Validate action code versus dealing fee supplied. Check
      ** for the existence of the replacement character at the
      ** Transaction Id level
     C                   IF        GHSUBS <> *BLANK
     C     GHSUBS        SCAN      TranInDLFE    WSubForTR01
     C                   ENDIF
 
      ** If insert, set retrieve mode to '*FRONT' (Access using Front
      ** Office Id).  Otherwise, if not insert and midas dealing fee
      ** is present, set retrieve mode to blank (Access using Midas
      ** Security shortname)
     C                   IF        DDACTN = 'I'
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   IF        TranInDLFE = *BLANK OR
     C                             WSubForTR01 <> *ZERO
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      PModeofOp = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      ** Call Retrieve Module
     C                   CALLB     'DLDLFERTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PModeofOp
     C                   PARM                    APRESPMODE
     C                   PARM                    DDACTN
     C                   PARM                    APFOTRANID
     C                   PARM                    DDDLNO
     C                   PARM                    DDFSEQ
     C                   PARM                    CurDFFilFmt
     C                   PARM                    OKACTN
     C                   PARM                    OKDLNO
     C                   PARM                    OKFSEQ
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    DealsDtlC
     C                   PARM                    DealsDtlD
 
      ** Save previous dealing fees details
     C                   EVAL      PrvDFFilFmt = CurDFFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTRANS   - Routine to validate the main dealing fees details *
      *                                                               *
      *****************************************************************
 
     C     SRVTRANS      BEGSR
 
      ** Call validation module
 
     C                   CALLB     'DLDLFEVAL'
     C                   PARM                    APRespMode
     C                   PARM                    TranInDLFE
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidDLFE
     C                   PARM                    DealsDtlC
     C                   PARM                    DealsDtlD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCVTDLFE   - Convert dealing fees details from file to        *
      *               screen format                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCVTDLFE     BEGSR
 
     C                   CALLB     'DLDLFECVT'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CurDFFilFmt
     C                   PARM                    CurDFScnFmt
     C                   PARM                    DDSTAT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDPRMPT  - Send a message to prompt the database updater   *
      *                                                               *
      *****************************************************************
 
     C     SRSNDPRMPT    BEGSR
 
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
 
     C                   CLEAR                   PReturn
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
 
     C                   IF        PReturn = *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     C/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKWRITE  - Routine to control checking of error status and *
      *               sending of messages/writing to the database     *
      *                                                               *
      *****************************************************************
 
     C     SRCHKWRITE    BEGSR
 
      ** Write record to valid file if no error found
 
     C                   IF        Idx = 0
     C                   EXSR      SRSETVLD
     C                   WRITE     DLVDLFED0
     C                   EXSR      SRCALMSGHD
     C                   ENDIF
 
     C                   IF        Idx > 0
     C                   EXSR      SRSETINVLD
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     DLIDLFED0
     C                   ENDIF
 
      ** If support system is active, write invalid transaction to
      ** log file via APLOGTRAN standard module.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
 
     C                   EVAL      TRANSDTL = TranInDLFE
     C                   EVAL      APTGTTYPE = 'DLDLFE'
     C                   EVAL      PDealNum = DDDLNO + DDFSEQ
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    PTimestamp
     C                   PARM                    PDealNum
     C                   PARM      *BLANKS       PADealNo
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      DBKEY = PDealNum
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
 
      ** Execute message handling routine
 
     C                   EXSR      SRCALMSGHD
     C                   ENDIF
 
     C                   COMMIT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETFLD  - Reset error information that is gradually       *
      *               updated during each run of this program         *
      *                                                               *
      *****************************************************************
 
     C     SRRESETFLD    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIdArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   FldNoArr
 
     C                   EVAL      OKFlagsDS = *ALL'Y'
 
     C                   CLEAR                   ValidDLFE
     C                   CLEAR                   CurDFScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETVLD    - Set up additional fields that are needed on the *
      *               Valid file record.                              *
      *                                                               *
      *****************************************************************
 
     C     SRSETVLD      BEGSR
 
      ** For Delete put the complete (pre-existing) trans
      ** into the Valid file record
 
     C                   IF        DDACTN = 'D'
     C                   EVAL      ValidDLFE = CurDFFilFmt
     C                   EVAL      DLLCDT = DDACTN
     C                   ENDIF
 
      ** For Enquire put the details retrieved from file directly to
      ** the valid record data structure
 
     C                   IF        DDACTN = 'E'
     C                   EVAL      ValidDLFE = CurDFFilFmt
     C                   ENDIF
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C                   EVAL      DLREPA = APRPRLOCN
 
      ** If insert, a new timestamp must be written on the valid file, otherwise
      ** use the previous timestamp
 
     C     DDACTN        IFEQ      'I'
     C                   EVAL      DLTMST = PTimestamp
     C                   ELSE
     C                   EVAL      DLTMST = P_DLTMST
     C                   ENDIF
 
     C                   EVAL      DLFRNT = APFOTRANID
 
     C                   EVAL      TranStatus = 'S'
 
     C/COPY WNCPYSRC,DLDLFEC017
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETINVLD  - Set up additional fields that are needed on the *
      *               Invalid file record.                            *
      *                                                               *
      *****************************************************************
 
     C     SRSETINVLD    BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   MOVEL     PTimestamp    DDTMST
 
     C                   EVAL      TranStatus = 'F'
 
     C/COPY WNCPYSRC,DLDLFEC016
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOGERROR - Send a message to the system operator for        *
      *              invalid transactions, and exit.                  *
      *                                                               *
      *****************************************************************
 
     C     SRLOGERROR    BEGSR
 
      ** Set up the message to send to the operator
 
     C                   CLEAR                   PLongError
     C                   RESET                   ReturnCode
     C                   EVAL      PLongError = WProcErr + '   ' + ARERRMOD
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    PLongError
     C                   PARM                    PDummyMsgId
     C                   PARM                    PDummyMsgF
 
      ** Indicate the failing module to the caller
 
     C                   EVAL      APRETCODE = ARERRMOD
 
      ** Remove the failing module's details from the dump information
      ** data area.
 
     C     *LOCK         IN        APDUMP
     C                   CLEAR                   ARERRMOD
     C                   OUT       APDUMP
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCALMSGHD  - Call the Message Handling module                *
      *                                                               *
      *****************************************************************
 
     C     SRCALMSGHD    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      ** with errors
 
     C                   Z-ADD     1             A
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(A) <> *BLANKS
 
     C                   Z-ADD     1             B
     C     FldNameArr(A) LOOKUP    FieldArr(B)                            80
     C                   EVAL      FldNoArr(A) = FldSeqArr(B)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             A
     C                   ENDDO
 
     C                   EVAL      PTRANID = DDDLNO + DDFSEQ
 
     C                   CALLB     'ZAMSGHNDLE'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO
     C                   PARM                    MsgIdArr
     C                   PARM                    FldNoArr
     C                   PARM                    FldNameArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    APFOTRANID
     C                   PARM                    ModuleID
     C                   PARM                    PTRANID
     C                   PARM                    #MsgFile
     C                   PARM                    DDACTN
     C                   PARM                    TranStatus
     C                   PARM                    APRESPMODE
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   PARM                    APRPYQUEUE
     C                   PARM                    PTimestamp
     C                   PARM                    MsgFArray
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDTASUBS - Data Substitution                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDTASUBS     BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepTran = 'Y'
 
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM      TranInDLFE    IncData
     C                   PARM      CurDFScnFmt   CurData
 
     C                   MOVEL     IncDATA       TranInDLFE
 
     C                   ENDIF
 
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
     C                   PARM                    HeadIn
     C                   PARM                    Trans500
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    ExtData500
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Keylist for DLDLFEL1
 
     C     KDEALFEE      KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KFSEQ
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
 
     C                   EVAL      #MsgFile = 'DLUSRMSG'
     C                   EVAL      MSGFArray(1) = 'DRSMM'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access Bank details via access program
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD  <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Database error
 
     C                   IF        PRTCD  <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APDLFEDTQ'
 
      ** Hook to enable non-core initial processing to be included
     C/COPY WNCPYSRC,DLDLFEC018
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
