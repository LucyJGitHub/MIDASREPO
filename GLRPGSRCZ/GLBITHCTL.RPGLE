     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Header Interface Controller')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHCTL - Journal Batch Entry Header Interface Controller  *
      *                                                               *
      *  Function: This program validates Journal Batch Entry headers *
      *            for input into the Midas database.                 *
      *            - All entries will be inserted as a new batch and  *
      *              all will be written to the Valid records file.   *
      *            - If errors exist in the incoming entry, its Valid *
      *              Indicator will be set to 'N', which will prevent *
      *              Database Update program from accepting the       *
      *              journal batch.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054696           Date 29Oct19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1078953          Date 18Jan13               *
      *                 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243860             Date 20Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7895            Date 18Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG2948            Date 03Jun04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG711             Date 19Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 12Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186207             Date 26Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054696 - Journal Entries Avoid Shadow Postings Update.     *
      *             Add Shadow Post Indicator in BITH API (SOAP/JMS). *      
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1078953 - Blank Batch Number is not accepted by the system *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Has total and No. of Items added  to     *
      *           Header input screen. Recompiled only.               *
      *  243860  - No detail entries written on GLJENPPD              *
      *  BUG7895 - Action code field added to GLBITHPD (Recompiled)   *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG2948 - Do not allow change of Multi-branch field from     *
      *            'Y' to 'N'.                                        *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG711 - Recompiled due to change in GLBITHPD                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  186207 - Journal Entry API error. Generate validation        *
      *           error for duplicate FO Id.                          *
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
      ** Valid JE Headers file
     FGLVBITHPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                         186207
      ** Valid JE Headers file by Front Office ID                               186207
     FGLVBITHL2 IF   E           K DISK    INFSR(*PSSR)                         186207
     F                                     RENAME(GLVBITHD0:GLVBITHD2)          186207
     F                                     PREFIX(X2)                           186207
      *                                                                         186207
      ** JE Headers file by Front Office ID                                     186207
     FGLJENHL3  IF   E           K DISK    INFSR(*PSSR)                         186207
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITHC001
      *
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
     D PTranIn       E DS                  EXTNAME(GLBITHPD)
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
                                                                                             BUG2948
      ** Current JE Header (DS)                                                              BUG2948
     D CurFilJENH    E DS                  EXTNAME(GLJENHPD)                                 BUG2948
     D  QQACCF1      E                     EXTFLD(QQACCF)                                    BUG2948
     D  QQACCT1      E                     EXTFLD(QQACCT)                                    BUG2948
      *
      ** JE Headers Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITHPD)
     D  WIndOK                 1      7    DIM(7) INZ('Y')
      *
      ** JE Headers Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBHEXPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
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
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
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
     D PObject         S             10A   INZ('GLBITHUPC')
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
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** External DS for SAR Details                                                          CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                            MD054696
      ** JE Headers Shadow Post Indicator                                                   MD054696
     D DDSHPI          S              1A                                                    MD054696
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITHC002
      *
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
      /COPY WNCPYSRC,GLBITHC003
      *
      ** Incoming transaction is in a 500A field, so that a common CLP
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break that 500A by loading it into the
      ** appropriate (externally described) data structure.
      *
     C                   eval      B1WSID=*BLANKS                                             243860
     C                   MOVEL     PTrans500     PTranIn
     C                   MOVEL     PExtdata500   PExtdata
      *                                                                         186207
      ** Check if Front Office ID has already been used.                        186207
      *                                                                         186207
     C     B1FRNT        CHAIN     GLVBITHL2                          60        186207
     C                   IF        *IN60 = *OFF                                 186207
     C                   ADD       1             Idx                            186207
     C                   EVAL      FldNameArr(Idx) = 'DDFRNT'                   186207
     C                   EVAL      MsgIDArr(Idx) = 'GLX0417'                    186207
     C                   ELSE                                                   186207
      *                                                                         186207
      ** Continue checking JE Headers master file if not yet found.             186207
      *                                                                         186207
     C     B1FRNT        CHAIN     GLJENHL3                           60        186207
     C                   IF        *IN60 = *ON                                  186207
     C                   ADD       1             Idx                            186207
     C                   EVAL      FldNameArr(Idx) = 'DDFRNT'                   186207
     C                   EVAL      MsgIDArr(Idx) = 'GLX0417'                    186207
     C                   ENDIF                                                  186207
     C                   ENDIF                                                  186207
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
      /COPY WNCPYSRC,GLBITHC004
      *
      ** Process transaction.
      *
     C                   EXSR      SRValdTran
      *
      /COPY WNCPYSRC,GLBITHC005
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,GLBITHC006
      *
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      PMQErrlong  = *BLANK
     C                   MOVEL     ProcErr       WMQError
     C                   MOVE      ARERRMOD      WMQError         28
     C                   MOVEL     WMQError      PMQErrlong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn        10
     C                   PARM                    PMQErrlong      132
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
      /COPY WNCPYSRC,GLBITHC007
      *
     C                   EXSR      SRChkWrite
      *
      /COPY WNCPYSRC,GLBITHC008
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
      /COPY WNCPYSRC,GLBITHC009
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
     C                   CLEAR                   PVBITH
      *
      ** Numeric fields within PVBITH have to be reset explicitly as
      ** there are long alpha fields overlapping these which cause the
      ** CLEAR to put blanks in the numeric fields.
      *
     C                   Z-ADD     *ZERO         B1HICC
     C                   Z-ADD     *ZERO         B1HDCC
     C                   Z-ADD     *ZERO         B1HINC
     C                   Z-ADD     *ZERO         B1HIIN
     C                   Z-ADD     *ZERO         B1HDIN
     C                   Z-ADD     *ZERO         B1HINI
     C                   Z-ADD     *ZERO         B1SPTT
     C                   Z-ADD     *ZERO         B1NIST
     C                   Z-ADD     *ZERO         B1RACF
     C                   Z-ADD     *ZERO         B1AMTF
     C                   Z-ADD     *ZERO         B1RACT
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
     C                   CALLB     'GLBITHVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Response Mode
     C**********         PARM                    APRESPMODE                                   CAP084
     C                   PARM      'S'           APRESPMODE                                   CAP084
      ** from Java only                                                                       243860
     C                   PARM      'N'           fromJava          1                          243860
      *                                                                                    AR1078953
      ** Front Office Transaction ID                                                       AR1078953
     C                   PARM                    APFOTranID                                AR1078953
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
      *
      ** JE Headers Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Mandatory Batch No./ No. of Items
     C                   PARM                    BKMHTN
      *                                                                                     MD054696
      ** Batch Header - Shadow Post Indicator                                               MD054696
     C                   PARM                    DDSHPI                                     MD054696
      *
      ** OUTPUT
      ** ======
      *
      ** JE Headers Error Indicators (DS)
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
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
                                                                                             BUG2948
      ** Current JE Header File Format                                                       BUG2948
     C                   PARM                    CurFilJENH                                  BUG2948
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
      ** !                                                            !
      ** ! At a later date, this routine will have to cater for       !
      ** ! warning messages.  The following logic will have to be     !
      ** ! inserted before "If no errors were found", in the          !
      ** ! above comments (and the code):                             !
      ** !                                                            !
      ** ! If 'Ignore warning messages' (from API ICD) is 'N', AND    !
      ** ! any warning messages were returned (WIdx <> 0)             !
      ** !                                                            !
      ** ! -   If errors exist                                        !
      ** !     -     Add the warning array index to the error array   !
      ** !           index                                            !
      ** !     -     Append the contents of the warning arrays to the !
      ** !           end of the error arrays                          !
      ** ! -   Else                                                   !
      ** !     -     Set the error array index equal to the warning   !
      ** !           array index                                      !
      ** !     -     Copy the contents of the warning arrays to the   !
      ** !           error arrays                                     !
      ** ! -   Endif                                                  !
      ** !                                                            !
      ** ! Endif                                                      !
      ** !                                                            !
      ** ! Note that the "If errors exist ... Else ... " block above  !
      ** ! can probably be implemented unconditionally (ie the same   !
      ** ! logic will apply whether errors exist as well as warnings  !
      ** ! or not).  It is shown in the above form for clarity.       !
      ** !                                                            !
      ** +------------------------------------------------------------+
      *
      ** If errors exist, set Valid Indicator to 'N' and Transaction
      ** Status to F (Failure); otherwise, set Valid Indicator to 'Y'
      ** and Transaction Status to S (Success).
      *
     C     Idx           IFGT      *ZERO
     C                   EVAL      B1VALI = 'N'
     C                   EVAL      PTranStatus = 'F'
     C                   ELSE
     C                   EVAL      B1VALI = 'Y'
     C                   EVAL      PTranStatus = 'S'
     C                   ENDIF
      *
      ** Set up other fields.
      *
     C                   EXSR      SRSetOFld
      *
      ** Write transaction record to Valid JE Headers file.
      *
     C                   WRITE     GLVBITHD0
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
     C                   EVAL      B1FRNT = APFOTranID
     C                   EVAL      B1AFRT = APFOAsocID
     C                   EVAL      B1TMST = PTimeStamp
      *
      ** Default Batch Status to Held.
      *
     C                   EVAL      B1BTSF = 'H'
      *
      ** Type of Journal is Interface.
      *
     C                   EVAL      B1TOJE = 'I'
      *
      /COPY WNCPYSRC,GLBITHC010
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
     C                   PARM                    B1FRNT
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
     C**********         PARM                    APRespMode                                   CAP084
     C                   PARM      'S'           APRespMode                                   CAP084
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
     C     *ENTRY        PLIST
      *
      ** Common Message Header information (DS) from source system
     C                   PARM                    PHeadIn
      *
      ** Transaction information in a single large field from
      ** from source system
     C                   PARM                    PTrans500
      *
      ** Extra Transaction information in a single large field
      ** from source system
     C                   PARM                    PExtData500
      *
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
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
     C                   EVAL      DBASE = 3                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APBITHDTQ'
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITHC011
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
