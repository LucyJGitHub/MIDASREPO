     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Interface Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATCTL - Yield Rates Interface Controller                 *
      *                                                               *
      *  Function:  This Program Validates Yield Rates Input into     *
      *             the Midas database.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS008             Date 16Jun04               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 208179             Date 05Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  208179 - 24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Valid Yield Rates
     FSDVYRATPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid Yield Rates
     FSDIYRATPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Valid Yield Rates Retrieve (Front Office)
     FSDVYRATL0 IF   E           K DISK    RENAME(SDVYRATD0:SDVYRATCH0)
 
      ** Valid Yield Rates Retrieve (Yield Curve/Currency/Int. Calc Method/Timestamp)
     FSDVYRATL1 IF   E           K DISK    RENAME(SDVYRATD0:SDVYRATCH1)
 
      ** Field Sequence Numbers
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDYRATC001
 
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
      *  SRCHKYRAT  - Routine to check if valid yield rates record    *
      *               exists for front office Id                      *
      *  SRCHKMYRAT -  Routine to check Midas valid yield rates re    *
      *                records exists in the valid records file       *
      *  SRVACTION  -  Routine to validate action code versus the     *
      *                yield rate supplied                            *
      *  SRVTRANS   -  Routine to validate the main yield rates       *
      *                details                                        *
      *  SRCVTYRAT  - Convert yield rates details from file to        *
      *               screen format                                   *
      *  SRSNDPRMPT - Send a message to prompt the database updater   *
      *  SRCHKWRITE - Routine to control checking of error status and *
      *               sending of messages/writing to the database     *
      *  SRRESETFLD -  Reset error information that is gradually      *
      *                updated during each run of this program        *
      *  SRSETVLD   -  Set up additional fields that are needed on    *
      *                the Valid file record.                         *
      *  SRSETINVLD -  Set up additional fields that are needed on    *
      *               the Invalid file record.                        *
      *  SRLOGERROR - Send a message to the system operator for       *
      *               invalid transactions, and exit.                 *
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
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLAR1
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
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
 
      ** Maturity Date
     D PDFcAr          S             14    DIM(98)
 
      ** Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Incoming Yield Rates Record (split into 4 data structures)
     D TranIn        E DS                  EXTNAME(SDYRATPD)
     D**TranIn1*               1    491                                                       CAS008
     D**TranIn2*             492    991                                                       CAS008
     D**TranIn3*             992   1491                                                       CAS008
     D**TranIn4*            1492   1971                                                       CAS008
     D  TranIn1                1    493                                                       CAS008
     D  TranIn2              494    993                                                       CAS008
     D  TranIn3              994   1493                                                       CAS008
     D  TranIn4             1494   1973                                                       CAS008
 
      ** Current Transaction in Screen Format - Main Details
     D CurYRTran     E DS                  EXTNAME(SDYRATPD)
     D                                     PREFIX(C_)
 
      ** Valid Yield Rates layout
     D ValidYRAT     E DS                  EXTNAME(SDVYRATPD)
 
      ** Current Yield Rates Record in File Format
     D YRATFilFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(V_)
 
      ** Previous Yield Rates Detail in File Format
     D PrvYRFilFmt   E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(P_)
 
      ** Flags to indicate whether yield rates fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SDEYRATPD)
 
      ** Yield Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SDYREXPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR details                                                          208179
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  208179
                                                                                              208179
      ** 24X7 status data area                                                                208179
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     208179
                                                                                              208179
      ** SD data area                                                                         208179
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     208179
                                                                                              208179
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields to receive the yield rates record
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D A               S              3P 0
     D B               S              3P 0
 
      ** Parameters for data substitution program
     D IncData         S           2000
     D CurData         S           2000
 
      ** Work fields for data substitution
     D WSubForTR01     S              2  0
     D WSubForTR02     S              2  0
     D WSubForTR03     S              2  0
 
      ** SDYRAT key fields
     D KYLDC           S              5
     D KYCCY           S              3
     D KYICM           S              1
 
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
     D ModuleID        S              2A   INZ('SD')
 
      ** Timestamp for the transaction
     D PTimestamp      S               Z
 
      ** Fields for data area locking
     D PObject         S             10A   INZ('SDYRATUPC')
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
 
      ** Fields defined for 208179                                                            208179
                                                                                              208179
     D CSC011          S              1A                                                      208179
     D TRANSDTL        S           5800A                                                      208179
     D PDealNum        S             18A                                                      208179
     D PADealNo        S             18A                                                      208179
     D PSard           S              6A                                                      208179
                                                                                              208179
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDYRATC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDYRATC003
 
      ** Incoming interest rates are in 4 500A fields, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break those 500A by loading them into the
      ** appropriate (externally described) data structures.
 
     C                   MOVEL     Trans5001     TranIn1
     C                   MOVEL     Trans5002     TranIn2
     C                   MOVEL     Trans5003     TranIn3
     C                   MOVEL     Trans5004     TranIn4
     C                   MOVEL     Extdata500    Extdata
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      SRRESETFLD
 
      /COPY WNCPYSRC,SDYRATC004
 
      ** Check if yield rates record exists for front office Id in the valid
      ** records file
 
     C                   EXSR      SRCHKYRAT
 
      ** If valid YRAT details does exist (even after delay), fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Check if yield rates record exists in the valid
      ** records file
 
     C                   EXSR      SRCHKMYRAT
 
      ** If valid YRAT details does exist (even after delay), fail this input
 
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Reset variables again in case the details have been corrupted
      ** by previous chain to valid YRAT file
 
     C                   EXSR      SRRESETFLD
 
      /COPY WNCPYSRC,SDYRATC005
 
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
 
     C                   WHEN      #0ACTN = 'I'
 
      ** Validate the main details of the transaction
 
      /COPY WNCPYSRC,SDYRATC007
 
     C                   EXSR      SRVTRANS
 
      /COPY WNCPYSRC,SDYRATC008
 
      ** Amend
 
     C                   WHEN      #0ACTN = 'A'
 
      /COPY WNCPYSRC,SKFfffC009
 
      ** Convert original securities details from file
      ** to screen format
 
     C                   EXSR      SRCVTYRAT
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
 
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      TranIn                                 80
     C                   IF        *IN80
     C                   EVAL      RepTran = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
 
     C                   IF        RepTran = 'Y'
     C                   EXSR      SRDTASUBS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate the main details of the transaction
 
      /COPY WNCPYSRC,SDYRATC010
 
     C                   EXSR      SRVTRANS
 
      /COPY WNCPYSRC,SDYRATC011
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      **  Check for exception error from any program lower in the stack
      **  If error detected, send message to system operator and
      **  return to calling program without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN)
 
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,SDYRATC012
 
     C                   IF        ARERRMOD <> *BLANK
     C                   EXSR      SRLOGERROR
     C                   ENDIF
 
      ** Processing for Error checking/write to database
 
      /COPY WNCPYSRC,SDYRATC013
 
     C                   EXSR      SRCHKWRITE
 
      /COPY WNCPYSRC,SDYRATC014
 
      ** If valid, send data queue entry to prompt DB update program
 
     C                   IF        Idx = 0
     C                   EXSR      SRSNDPRMPT
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDYRATC015
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKYRAT   - Routine to check if valid yield rates record    *
      *               exists for front office Id                      *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZACDELAY    - Apply delay job                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCHKYRAT     BEGSR
 
      ** Check for front office id in the valid records file
 
     C     APFOTRANID    CHAIN     SDVYRATL0                          80
 
      ** If record found, delay then repeat check
 
     C                   IF        *IN80 = *OFF
     C                   CALLB     'ZACDELAY'
     C     APFOTRANID    CHAIN     SDVYRATL0                          80
 
      ** Error if still present
 
     C                   IF        *IN80 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameAr2(Idx) = '#0YLDC'
     C                   EVAL      MsgIDAr2(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKMYRAT  - Routine to check Midas valid yield rates re     *
      *               records exists in the valid records file        *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZACDELAY    - Apply delay job                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCHKMYRAT    BEGSR
 
      ** Check for yield rates record on Valid file
 
     C                   EVAL      KYLDC = #0YLDC
     C                   EVAL      KYCCY = #0YCCY
     C                   EVAL      KYICM = #0YICM
 
     C     KYIELDR1      CHAIN     SDVYRATL1                          80
 
      ** If record found, delay then repeat check
 
     C                   IF        *IN80 = *OFF
     C                   CALLB     'ZACDELAY'
 
     C     KYIELDR1      CHAIN     SDVYRATL1                          80
 
      ** Error if still present
 
     C                   IF        *IN80 = *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameAr2(Idx) = '#0YLDC'
     C                   EVAL      MsgIDAr2(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVACTION   - Routine to validate action code versus the      *
      *               yield rate supplied                             *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATRTV   - YRAT retrieve module                            *
      *                                                               *
      *****************************************************************
 
     C     SRVACTION     BEGSR
 
      ** Validate action code versus yield rate supplied. Check
      ** for the existence of the replacement character at the
      ** Transaction Id level
 
     C                   IF        GHSUBS <> *BLANK
     C     GHSUBS        SCAN      #0YLDC        WSubForTR01
     C     GHSUBS        SCAN      #0YCCY        WSubForTR02
     C     GHSUBS        SCAN      #0YICM        WSubForTR03
     C                   ENDIF
 
      ** If insert, set retrieve mode to '*FRONT' (Access using Front
      ** Office Id).  Otherwise, if not insert and midas yield rate
      ** is present, set retrieve mode to blank (Access using Midas
      ** Security shortname)
 
     C                   IF        #0ACTN = 'I'
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   IF        #0YLDC = *BLANK OR #0YCCY = *BLANK OR
     C                             #0YICM = *BLANK OR WSubForTR01 <> 0 OR
     C                             WSubForTR02 <> 0 OR WSubForTR03 <> 0
     C                   EVAL      PModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      PModeofOp = *BLANK
     C                   ENDIF
     C                   ENDIF
 
      ** Call Retrieve Module
 
     C                   CALLB     'SDYRATRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PModeofOp
     C                   PARM                    APRESPMODE
     C                   PARM                    #0ACTN
     C                   PARM                    #0YLDC
     C                   PARM                    #0YCCY
     C                   PARM                    #0YICM
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    APFOTRANID
     C                   PARM                    YRATFilFmt
     C                   PARM                    OKACTN
     C                   PARM                    OKYLDC
     C                   PARM                    OKYCCY
     C                   PARM                    OKYICM
     C                   PARM                    OKYCFQ
     C                   PARM                    OKSPDY                                       CAS008
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIdAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM      'N'           PKYCFQ
 
      ** Save previous yield rate details
 
     C                   EVAL      PrvYRFilFmt = YRATFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTRANS   - Routine to validate the main yield rates details *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATVAL   - YRAT validation module                          *
      *                                                               *
      *****************************************************************
 
     C     SRVTRANS      BEGSR
 
      ** Call validation module
 
     C                   CALLB     'SDYRATVAL'
     C                   PARM                    APRespMode
     C                   PARM                    PModeofOp
     C                   PARM                    TranIn
     C                   PARM                    ExtData
     C                   PARM                    PrvYRFilFmt
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    WIdx
     C                   PARM                    PMatAr
     C                   PARM                    ValidYRAT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCVTYRAT   - Convert yield rates details from file to        *
      *               screen format                                   *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATCVT   - YRAT convert module                             *
      *                                                               *
      *****************************************************************
 
     C     SRCVTYRAT     BEGSR
 
     C                   CALLB     'SDYRATCVT'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    YRATFilFmt
     C                   PARM                    CurYRTran
     C                   PARM      *BLANKS       PMatAr
     C                   PARM      *BLANKS       PDFcAr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDPRMPT  - Send a message to prompt the database updater   *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * APCALCOBJ   - Allocate an object                              *
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
     D/COPY ZACPYSRC,DTAQCHK
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
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SRSETVLD    - Set up valid file                               *
      * SRSETINVLD  - Set up invalid file                             *
      * SRCALMSGHD  - API message handler                             *
      *                                                               *
      *****************************************************************
 
     C     SRCHKWRITE    BEGSR
 
      ** Write record to valid file if no error found
 
     C                   IF        Idx = 0
     C                   EXSR      SRSETVLD
     C                   WRITE     SDVYRATD0
     C                   EXSR      SRCALMSGHD
     C                   ENDIF
 
     C                   IF        Idx > 0
     C                   EXSR      SRSETINVLD
 
      ** Only write to invalid files if repair in back office
 
     C                   IF        APRPRLOCN = 'B'
     C                   WRITE     SDIYRATD0
     C                   ENDIF
                                                                                              208179
      ** If support system is active, write invalid transaction to                            208179
      ** log file via APLOGTRAN standard module.                                              208179
                                                                                              208179
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         208179
                                                                                              208179
     C                   EVAL      TRANSDTL = TranIn + ExtData                                208179
     C                   EVAL      APTGTTYPE = 'SDYRAT'                                       208179
     C                   EVAL      PDealNum = #0YLDC + #0YCCY + #0YICM                        208179
                                                                                              208179
     C                   CALLB     'APLOGTRAN'                                                208179
     C                   PARM      *BLANKS       RetCodeOut                                   208179
     C                   PARM                    HeadIn                                       208179
     C                   PARM                    TRANSDTL                                     208179
     C                   PARM                    PTimestamp                                   208179
     C                   PARM                    PDealNum                                     208179
     C                   PARM      *BLANKS       PADealNo                                     208179
                                                                                              208179
     C                   IF        RetCodeOut <> *Blanks                                      208179
     C                   EVAL      DBKEY = PDealNum                                           208179
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       208179
     C                   EVAL      DBASE = 4                                                  208179
     C                   EXSR      *PSSR                                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   ENDIF                                                                208179
                                                                                              208179
 
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
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRESETFLD    BEGSR
 
     C                   RESET                   FldNameAr2
     C                   RESET                   MsgIDAr2
     C                   RESET                   MsgDtaAr2
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamAr2
     C                   RESET                   WMsgIDAr2
     C                   RESET                   WMsgDtaAr2
     C                   RESET                   WIdx
 
     C                   RESET                   FldNoAr2
 
     C                   EVAL      OKFlagsDS = *ALL'Y'
 
     C                   CLEAR                   ValidYRAT
     C                   CLEAR                   CurYRTran
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETVLD    - Set up additional fields that are needed on the *
      *               Valid file record.                              *
      *                                                               *
      * Called By : SRCHKWRITE subroutine                             *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETVLD      BEGSR
 
      ** For Delete put the complete (pre-existing) trans
      ** into the Valid file record
 
     C                   IF        #0ACTN = 'D'
     C                   EVAL      ValidYRAT = YRATFilFmt
     C                   EVAL      FSCHTP = #0ACTN
     C                   ENDIF
 
      ** For Enquire put the details retrieved from file directly to
      ** the valid record data structure
 
     C                   IF        #0ACTN = 'E'
     C                   EVAL      ValidYRAT = YRATFilFmt
     C                   ENDIF
 
      ** Include Header fields that need to be o/p to the Valid file
 
     C                   EVAL      FSRPRL = APRPRLOCN
 
      ** If insert, a new timestamp must be written on the valid file, otherwise
      ** use the previous timestamp
 
     C     #0ACTN        IFEQ      'I'
     C                   EVAL      FSTMES = PTimestamp
     C                   ELSE
     C                   EVAL      FSTMES = P_FSTMES
     C                   ENDIF
 
     C                   EVAL      FSFOTR = APFOTRANID
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,SDYRATC017
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETINVLD  - Set up additional fields that are needed on the *
      *               Invalid file record.                            *
      *                                                               *
      * Called By : SRCHKWRITE subroutine                             *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETINVLD    BEGSR
 
      ** Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      #0FOTR = APFOTRANID
     C                   EVAL      #0RPRL = APRPRLOCN
     C                   MOVEL     PTimestamp    #0TMES
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,SDYRATC016
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOGERROR - Send a message to the system operator for        *
      *              invalid transactions, and exit.                  *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZAMSGTOOPR  - Send message to system operator                 *
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
      * Called By : SRCHKWRITE subroutine                             *
      *                                                               *
      * Calls :                                                       *
      * ZAMSGHNDL1  - API message handler                             *
      *                                                               *
      *****************************************************************
 
     C     SRCALMSGHD    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      ** with errors
 
     C                   Z-ADD     1             A
     C                   DO        ArrayMax3
 
     C                   IF        FldNameAr2(A) <> *BLANKS
 
     C                   Z-ADD     1             B
     C     FldNameAr2(A) LOOKUP    FieldAr2(B)                            80
     C                   EVAL      FldNoAr2(A) = FldSeqAr2(B)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             A
     C                   ENDDO
 
     C                   EVAL      PTRANID = #0YLDC + #0YCCY + #0YICM
 
     C                   CALLB     'ZAMSGHNDL1'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    APRPRLOCN
     C                   PARM                    APCNFVALFO
     C                   PARM                    MsgIDAr2
     C                   PARM                    FldNoAr2
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    APFOTRANID
     C                   PARM                    ModuleID
     C                   PARM                    PTRANID
     C                   PARM                    #MsgFile
     C                   PARM                    #0ACTN
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
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * APDTASUBS   - Data substitution                               *
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
     C                   PARM      TranIn        IncData
     C                   PARM      CurYRTran     CurData
 
     C                   MOVEL     IncDATA       TranIn
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    HeadIn
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    ExtData500
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Keylist for SDYRATL1
 
     C     KYIELDR1      KLIST
     C                   KFLD                    KYLDC
     C                   KFLD                    KYCCY
     C                   KFLD                    KYICM
 
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
 
     C                   EVAL      #MsgFile = 'SDUSRMSG'
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
                                                                                              208179
      ** Check if CSC011 is installed                                                         208179
                                                                                              208179
     C                   EVAL      CSC011 = 'N'                                               208179
                                                                                              208179
     C                   CALLB     'AOSARDR0'                                                 208179
     C                   PARM      *BLANKS       PRtCd                                        208179
     C                   PARM      '*VERIFY'     POptn                                        208179
     C                   PARM      'CSC011'      PSard                                        208179
     C     SCSARD        PARM      SCSARD        DSFDY                                        208179
                                                                                              208179
      ** Database error                                                                       208179
                                                                                              208179
     C                   IF        (PRtCd <> *BLANKS) and                                     208179
     C                             (PRtCd <> '*NRF   ')                                       208179
     C                   EVAL      DBKEY = 'CSC011'                                           208179
     C                   EVAL      DBFILE = 'SCSARDPD'                                        208179
     C                   EVAL      DBASE = 3                                                  208179
     C                   EXSR      *PSSR                                                      208179
     C                   ENDIF                                                                208179
                                                                                              208179
     C                   IF        PRtCd = *BLANKS                                            208179
     C                   EVAL      CSC011 = 'Y'                                               208179
     C                   IN        SDSTAT                                                     208179
     C                   IN        SC24X7                                                     208179
     C                   ENDIF                                                                208179
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APYRATDTQ'
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDYRATC018
 
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
(c) Finastra International Limited 2001
