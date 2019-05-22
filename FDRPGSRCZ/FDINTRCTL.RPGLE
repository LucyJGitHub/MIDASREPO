     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM interest rates interface controller')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDINTRCTL - FD MM Interest Rates Interface Controller        *
      *                                                               *
      *  Function: This Program Validates MM Interest Rates Input     *
      *            into the Midas database.                           *
      *            Even though no data is passed in the action code,  *
      *            the implied action code of this function is always *
      *            I (=Insert) = overwrite existing data if it        *
      *                          already exists for currency          *
      *            The decision as to whether to write to the Valid   *
      *            or Invalid file and the call to the Message        *
      *            Handler will take place in this module.            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG5977             Date 24Mar05               *
      *                 BUG1625            Date 19May04               *
      *                 222727             Date 05Nov03               *
      *                 214637             Date 09Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 20Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 01May01               *
      *                 CAP058             Date 13Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG5977 - Reverse 222727 (this was needed to correct errors in*
      *           APINCOMMSG/CAP083 - these have now been corrected)  *
      *  BUG1625 - Commitment Control Changes for MidasPlus           *
      *  222727 - Release 5.0 errors (Format of messages corrupted)   *
      *  214637 - Incorrect API definition files used                 *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid MM Interest Rates
     FFDVINTRPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
                                                                                CAP058
      ** Invalid MM Interest Rates                                              CAP058
     FFDIINTRPD UF A E             DISK    INFSR(*PSSR)                         CAP058
     F                                     COMMIT                               CAP058
 
     FFDVINTRL1 IF   E           K DISK    RENAME(FDVINTRD0:FDVINTRCHK)
     FFDVINTRLA IF   E           K DISK    RENAME(FDVINTRD0:FDVINTRBRW)         CAP058
     FFDVINTRLB IF   E           K DISK    RENAME(FDVINTRD0:FDVINTRLND)         CAP058
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                CSD006
      ** MDF Request Details by Request Id                                      CSD006
     FSDMDFRL1  IF   E           K DISK    INFSR(*PSSR)                         CSD006
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FDINTRC001
 
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
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming MM Interest Rates Record (split into 2 data structures)
     D*TranIn1**     E DS                  EXTNAME(FDINTR1PD)                   CAP058
     D*TranIn2**     E DS                  EXTNAME(FDINTR2PD)                   CAP058
     D TranIn        E DS                  EXTNAME(FDINTRPD)                    CAP058
     D**TranIn1*******         1    312                                                CAP058 214637
     D**TranIn2*******       313    638                                                CAP058 214637
     D**TranIn1*******         1    312                                                222727 BG5977
     D**TranIn2*******       313    638                                                222727 BG5977
                                                                                CAP058
      * (Current) Transaction in Screen Format - Main Details                   CAP058
     D CurTrTran     E DS                  EXTNAME(FDINTRPD)                    CAP058
     D                                     PREFIX(@)                            CAP058
 
      * Valid MM Interest Rates layout
     D ValidINTR     E DS                  EXTNAME(FDVINTRPD)
 
      * (Current) MM Interest Rates record in File Format
     D INTRFilFmt    E DS                  EXTNAME(FDVINTRPD)
     D                                     PREFIX(V)
                                                                                CAP058
      ** Previous Interest Rates Detail in File Format                          CAP058
     D PrvIRFilFmt   E DS                  EXTNAME(FDVINTRPD)                   CAP058
     D                                     PREFIX(P)                            CAP058
 
 
      ** Flags to indicate whether MM interest rates fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEINTRPD)
 
 
      * MM Interest Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FDIREXPD)
                                                                                CAP058
      ** Interest Rates Validation Workfields                                   CAP058
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)                   CAP058
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
                                                                                CAP058
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP058
      ** External DS for Switchable Features                                    CAP058
                                                                                CSD006
     D SDMAPC        E DS                  EXTNAME(SDMAPCPD)                    CSD006
      ** External DS for Market Data Feeds Mapping Codes                        CSD006
                                                                                CAP058
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP058
      ** External DS for API ICD                                                CAP058
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                             BUG1625
      ** Jobs Handling Commitment Control                                                    BUG1625
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1625
     D  COMITARR               4    103                                                      BUG1625
                                                                                             BUG1625
      ** Array of Commitment Job Names                                                       BUG1625
     D COMITJOB        S             10A   DIM(10)                                           BUG1625
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields to receive the incoming MM interest rates record
     D Trans5001       S            500A
     D Trans5002       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** The transaction's status
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A   INZ('FD')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Fields for data area locking
     D Object          S             10A   INZ('FDINTRUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Parameters and work fields for ZAMSGTOOPR
     D LongError       S            132A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
                                                                                CAP058
      ** Flags to indicate whether substitution is required in                  CAP058
      ** each of the various parts the transaction                              CAP058
     D RepTran         S              1A   inz('N')                             CAP058
                                                                                              CSC011
      ** Fields defined for CSC011                                                            CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A   INZ('N')                                          BUG1625
     D CNT             S              3  0                                                   BUG1625
     D COMITSKIP       S              1A                                                     BUG1625
     D TRANSDTL        S           5800A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FDINTRC002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FDINTRC003
 
      * Incoming interest rates are in 2 500A fields, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break those 500A by loading them into the
      * appropriate (externally described) data structures.
     C*****              MOVEL     Trans5001     TranIn1                                      214637
     C*****              MOVEL     Trans5002     TranIn2                                      214637
     C*****              Eval      TranIn = Trans5001 + Trans5002                      214637 222727
     C******             MOVEL     Trans5001     TranIn1                               222727 BG5977
     C******             MOVEL     Trans5002     TranIn2                               222727 BG5977
     C                   Eval      TranIn = Trans5001 + Trans5002                             BG5977
     C                   MOVEL     Extdata500    Extdata
 
      ** Check if the Data Request Id is existing                               CSD006
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
     C                   EXSR      SrCHKDRID                                    CSD006
     C                   ENDIF                                                  CSD006
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      ** Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FDINTRC004
 
      *  Check if MM interest rates record is valid
 
     C                   EXSR      ChkValINTR
      *
      *  If valid int rates do exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid MM interest rates file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,FDINTRC005
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,FDINTRC006
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
      *                                                                         CAP058
      * Check for the existence of the replacement character; if this is        CAP058
      * used, only the changed data has been sent, and all occurrences of       CAP058
      * the replacement character must be replaced with the corresponding       CAP058
      * character from the original transaction.                                CAP058
     C                   if        GHSUBS <> *blank                             CAP058
                                                                                CAP058
     C     GHSUBS        SCAN      TranIn                                 99    CAP058
     C                   IF        *in99                                        CAP058
     C                   EVAL      RepTran = 'Y'                                CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** If any of the flags set above is true, do the data                     CAP058
      ** substution subroutine.                                                 CAP058
     C                   IF        RepTran = 'Y'                                CAP058
     C                   EXSR      DtaSubs                                      CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   ENDIF                                                  CAP058
      **                 (End of "GHSUBS <> *blank")                            CAP058
 
      ** Validate the main details of the transaction
 
      /COPY WNCPYSRC,FDINTRC007
     C                   EXSR      ValidateTr
 
      /COPY WNCPYSRC,FDINTRC008
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      ** prompting the database update program (LogError SR
      ** includes a RETURN).
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,FDINTRC009
 
     C                   IF        ARERRMOD <> *blank
     C                   EXSR      LogError
     C                   ENDIF
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,FDINTRC010
     C                   EXSR      CheckWrite
 
      /COPY WNCPYSRC,FDINTRC011
 
      ** If valid, send data queue entry to prompt DB update program
     C                   IF        Idx = 0
     C                   EXSR      SndPrompt
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FDINTRC012
 
      *****************************************************************         CSD006
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrCHKDRID - Check Data Request Id                             *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrCHKDRID     BEGSR                                                  CSD006
                                                                                CSD006
      ** Initialise API Request type workfield                                  CSD006
                                                                                CSD006
     C                   EVAL      WAPIT = *BLANK                               CSD006
                                                                                CSD006
      ** If the Request Data Id is entered, check to Request Details File       CSD006
      ** if existing                                                            CSD006
                                                                                CSD006
     C     DDDTFR        IFNE      *BLANK                                       CSD006
                                                                                CSD006
     C     DDDTFR        CHAIN     SDMDFRL1                           81        CSD006
                                                                                CSD006
      ** Access Market Data Feed Mapping Code to get the Request type           CSD006
                                                                                CSD006
     C     *IN81         IFEQ      FALSE                                        CSD006
     C                   CALL      'AOMAPCR0'                                   CSD006
     C                   PARM      *BLANK        @RTCD                          CSD006
     C                   PARM      '*KEY   '     @OPTN                          CSD006
     C                   PARM      MRMAPC        PMAPCD           32            CSD006
     C     SDMAPC        PARM      SDMAPC        DSFDY                          CSD006
                                                                                CSD006
      ** Database error                                                         CSD006
                                                                                CSD006
     C     @RTCD         IFNE      *BLANKS                                      CSD006
     C                   MOVEL     'SDMAPCPD'    DBFILE                         CSD006
     C                   Z-ADD     3             DBASE                          CSD006
     C                   MOVEL     MRMAPC        DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WAPIT = MCAPIT                               CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValINTR - Routine to check if valid interest rates record  *
      *              exists for currency.                             *
      *                                                               *
      *****************************************************************
 
     C     ChkValINTR    BEGSR
 
      * Check for MM interest rates record on Valid file
     C     CAP058        IFEQ      'N'                                          CAP058
     C     DDCCY         CHAIN     FDVINTRL1                          99
     C                   ELSE                                                   CAP058
     C                   EXSR      SrChkVINTR                                   CAP058
     C                   ENDIF                                                  CAP058
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     CAP058        IFEQ      'N'                                          CAP058
     C     DDCCY         CHAIN     FDVINTRL1                          99
     C                   ELSE                                                   CAP058
     C                   EXSR      SrChkVINTR                                   CAP058
     C                   ENDIF                                                  CAP058
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
      *
     C                   ENDSR
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrChkVINTR - Routine to check if valid interest rates         *         CAP058
      *              records exist for Front Office Id                *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
                                                                                CAP058
     C     SrChkVINTR    BEGSR                                                  CAP058
                                                                                CAP058
      ** Check borrow rate                                                      CAP058
                                                                                CAP058
     C                   SELECT                                                 CAP058
     C     WAPIT         WHENEQ    'B'                                          CAP058
     C     APFOTranID    CHAIN     FDVINTRLA                          99        CAP058
                                                                                CAP058
      ** Check lending rate                                                     CAP058
                                                                                CAP058
     C     WAPIT         WHENEQ    'L'                                          CAP058
     C     APFOTranID    CHAIN     FDVINTRLB                          99        CAP058
                                                                                CAP058
      ** Otherwise, check both rates                                            CAP058
                                                                                CAP058
     C                   OTHER                                                  CAP058
     C     APFOTranID    CHAIN     FDVINTRLA                          99        CAP058
     C     *IN99         IFEQ      TRUE                                         CAP058
     C     APFOTranID    CHAIN     FDVINTRLB                          99        CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDSL                                                  CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              currency supplied.                               *
      *              Implied action code is always 'I', therefore,    *
      *              simply validate that currency exists.            *
      *****************************************************************
 
     C     ValidateAc    BEGSR
 
      * Validate action code versus currency code supplied.
      * The MM interest rates record in file format from the FD database is
      * retrieved as well.
      *                                                                         CAP058
      *  We assume no substitution has been defined for the transaction ID      CAP058
      *                                                                         CAP058
      ** Check for the existence of the replacement character at the            CAP058
      ** Transaction Id level.                                                  CAP058
     C                   IF        CAP058 <> 'N'                                CAP058
     C                   IF        GHSUBS <> *blank                             CAP058
     C     GHSUBS        SCAN      DDCCY         SubForTRNN        2 0          CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      'I'                                          CAP058
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP058
     C                   ELSE                                                   CAP058
     C     DDCCY         IFEQ      *BLANK                                       CAP058
     C     SubForTRNN    ORNE      0                                            CAP058
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP058
     C                   ELSE                                                   CAP058
     C                   MOVEL     '      '      ModeofOp                       CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FDINTRRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
     C***********        PARM      '*FRONT'      ModeofOp          6            CAP058
     C                   PARM                    ModeofOp          6            CAP058
      *
      * Response mode
     C                   PARM                    APRESPMODE
 
      * Action Code
     C                   PARM                    DDACTN
 
      * Currency
     C                   PARM                    DDCCY
      * Currency name                                                           CAP058
     C                   PARM                    DDCYNM           32            CAP058
                                                                                CAP058
      ** Front Office Id                                                        CAP058
                                                                                CAP058
     C                   PARM                    APFOTranId                     CAP058
 
      * OUTPUTS
 
      * (Current) MM interest rates record in file format
     C                   PARM                    INTRFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Currency
     C                   PARM                    DDCcyOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    ValWrkFlds                     CAP058
                                                                                CAP058
      ** Save previous interest rate details                                    CAP058
                                                                                CAP058
     C                   MOVEL     INTRFilFMT    PrvIRFilFmt                    CAP058
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main int rates details   *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   CALLB     'FDINTRVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
     C                   PARM                    ModeOfOp                       CAP058
      * Transaction information (DS) from source system
     C***********        PARM                    TranIn1                        CAP058
     C***********        PARM                    TranIn2                        CAP058
     C                   PARM                    TranIn                         CAP058
     C                   PARM                    ExtData
     C                   PARM                    PrvIRFilFmt                    CAP058
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C                   PARM                    WIdx
      * Valid MM Interest Rates layout (DS) from/to caller
     C                   PARM                    ValidINTR
     C                   PARM                    ValWrkFlds                     CAP058
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SndPrompt - Send a message to prompt the database updater     *
      *                                                               *
      *****************************************************************
 
     C     SndPrompt     BEGSR
 
      ** Check if update program active using Allocate Object API
      ** No prompting necessary if program is running
     C                   CLEAR                   Return
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
     C                   IF        Return = *blank
 
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
      * Check/Write - Routine to control checking of error status and *
      *    sending of messgaes/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *   - set up additional data
      *   - write a record to the Valid file
      *   - use std message handler to report MM interest rates status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report MM interest rates status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
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
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     FDVINTRD0
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C     Idx           IFGT      0
     C     CAP058        IFNE      'Y'                                          CAP058
     C                   EVAL      TranStatus = 'F'
     C                   ELSE                                                   CAP058
     C                   EXSR      SETUPINVAL                                   CAP058
      *                                                                         CAP058
      ** Only write to invalid files if repair in back office                   CAP058
      *                                                                         CAP058
     C     APRprLocn     IFEQ      'B'                                          CAP058
     C                   WRITE     FDIINTRD0                                    CAP058
                                                                                              CSC011
      ** If support system is active, write invalid transaction to                            CSC011
      ** log file via APLOGTRAN standard module.                                              CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn + ExtData                                CSC011
     C                   EVAL      APTGTTYPE = 'FDINTR'                                       CSC011
     C                   MOVEL     DDCCY         PDealNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKey = PDealNum                                           CSC011
     C                   EVAL      DBFile = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBase = 5                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
      ***********                                                               CAP058
      **N.B.*Repair*location*is*front*office*for*MM*interest*rates.****         CAP058
      **Therefore,*do*NOT*write*to*invalid*files.**********************         CAP058
      *
      * Execute message handling routine.
      *
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C     CSC022        IFEQ      'N'                                                       BUG1625
     C                   COMMIT
     C                   ELSE                                                                BUG1625
     C     COMITSKIP     IFNE      'Y'                                                       BUG1625
     C                   COMMIT                                                              BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF                                                               BUG1625
 
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
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   MOVE      *ALL'Y'       OKFlagsDS
 
     C                   CLEAR                   ValidINTR
     C                   CLEAR                   CurTrTran                      CAP058
 
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
                                                                                CAP058
      ** For Delete put the complete (pre-existing) deal                        CAP058
      ** into the Valid file record                                             CAP058
                                                                                CAP058
     C                   IF        DDACTN = 'D'                                 CAP058
     C                   MOVEL     INTRFilFmt    ValidINTR                      CAP058
     C                   EVAL      FYCHTP = DDACTN                              CAP058
     C                   ENDIF                                                  CAP058
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      FYREPA = APRprLocn
                                                                                CAP058
      ** If insert, a new timestamp must be written on the valid file, otherwiseCAP058
      ** use the previous timestamp                                             CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      'I'                                          CAP058
     C                   EVAL      FYTMESTMP = TimeStamp
     C                   ELSE                                                   CAP058
     C                   EVAL      FYTMESTMP = VFYTMESTMP                       CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C     CAP058        IFEQ      'Y'                                          CAP058
     C                   SELECT                                                 CAP058
     C     WAPIT         WHENEQ    'B'                                          CAP058
     C                   EVAL      FYBOFR = APFOTranID                          CAP058
     C                   EVAL      FYBORP = APRprLocn                           CAP058
                                                                                CAP058
      ** If insert, a new timestamp must be written on the valid file, otherwiseCAP058
      ** use the previous timestamp                                             CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      'I'                                          CAP058
     C                   EVAL      FYBOTM = TimeStamp                           CAP058
     C                   ELSE                                                   CAP058
     C                   EVAL      FYBOTM = VFYBOTM                             CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C     WAPIT         WHENEQ    'L'                                          CAP058
     C                   EVAL      FYLEFR = APFOTranID                          CAP058
     C                   EVAL      FYLERP = APRprLocn                           CAP058
                                                                                CAP058
      ** If insert, a new timestamp must be written on the valid file, otherwiseCAP058
      ** use the previous timestamp                                             CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      'I'                                          CAP058
     C                   EVAL      FYLETM = TimeStamp                           CAP058
     C                   ELSE                                                   CAP058
     C                   EVAL      FYLETM = VFYLETM                             CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   OTHER                                                  CAP058
     C                   EVAL      FYBOFR = APFOTranID                          CAP058
     C                   EVAL      FYLEFR = APFOTranID                          CAP058
     C                   EVAL      FYBORP = APRprLocn                           CAP058
     C                   EVAL      FYLERP = APRprLocn                           CAP058
                                                                                CAP058
      ** If insert, a new timestamp must be written on the valid file, otherwiseCAP058
      ** use the previous timestamp                                             CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      'I'                                          CAP058
     C                   EVAL      FYBOTM = TimeStamp                           CAP058
     C                   EVAL      FYLETM = TimeStamp                           CAP058
     C                   ELSE                                                   CAP058
     C                   EVAL      FYBOTM = VFYBOTM                             CAP058
     C                   EVAL      FYLETM = VFYLETM                             CAP058
     C                   ENDIF                                                  CAP058
 
     C                   ENDSL                                                  CAP058
     C                   ENDIF                                                  CAP058
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,FDINTRC013
 
     C                   ENDSR
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SETUPINVAL - Set up additional fields that are needed on the  *         CAP058
      *              Invalid file record.                             *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SETUPINVAL    BEGSR                                                  CAP058
                                                                                CAP058
      ** Include Header fields that need to be o/p to the Invalid files         CAP058
                                                                                CAP058
     C                   EVAL      DDFOTRANID = APFOTranID                      CAP058
     C                   EVAL      DDRPRLOCN = APRprLocn                        CAP058
     C                   EVAL      DDTMESTMP = TimeStamp                        CAP058
                                                                                CAP058
     C                   EVAL      TranStatus = 'F'                             CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LogError - Send a message to the system operator for invalid  *
      *            transactions, and exit.                            *
      *                                                               *
      *****************************************************************
     C     LogError      BEGSR
 
      ** Set up the message to send to the operator
     C                   CLEAR                   LongError
     C                   RESET                   ReturnCode
     C                   EVAL      LongError = ProcErr + '   ' + ARERRMOD
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    ReturnCode
     C                   PARM                    LongError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
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
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVE      *BLANKS       CCY6A
     C                   MOVEL     DDCCY         CCY6A             6
 
     C                   MOVEL     CCY6A         PTranID          20                          CAP033
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Repair location (1A, from caller)
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
     C***********        PARM      *BLANKS       APFOTranID                     CAP058
     C                   PARM                    APFOTranID                     CAP058
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    CCY6A                                        CAP033
     C                   PARM                    PTranID                                      CAP033
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
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * DtaSubs - Data Substitution                                   *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
                                                                                CAP058
     C     DtaSubs       begsr                                                  CAP058
                                                                                CAP058
      * Convert file fields to screen format                                    CAP058
     C                   RESET                   ReturnCode                     CAP058
     C                   CALLB     'FDINTRCVT'                                  CAP058
     C                   PARM                    ReturnCode                     CAP058
     C                   PARM                    INTRFilFmt                     CAP058
     C                   PARM                    CurTrTran                      CAP058
     C                   PARM                    ValWrkFlds                     CAP058
                                                                                CAP058
      ** Substitute the data for the various parts of the transaction,          CAP058
      ** dependent on the flags that were set earlier.                          CAP058
                                                                                CAP058
     C                   if        RepTran = 'Y'                                CAP058
                                                                                CAP058
     C                   clear                   IncData                        CAP058
     C                   clear                   CurData                        CAP058
     C                   RESET                   ReturnCode                     CAP058
     C                   CALLB     'APDTASUBS'                                  CAP058
      * Return Code                                                             CAP058
      * Substitution character                                                  CAP058
      * Incoming Data                                                           CAP058
      * Current Data                                                            CAP058
     C                   PARM                    ReturnCode                     CAP058
     C                   PARM                    GHSUBS                         CAP058
     C                   PARM      TranIn        IncData        2000            CAP058
     C                   PARM      CurTrTran     CurData        2000            CAP058
                                                                                CAP058
     C                   MOVEL     IncDATA       TranIn                         CAP058
                                                                                CAP058
     C                   endif                                                  CAP058
                                                                                CAP058
     C                   endsr                                                  CAP058
                                                                                CAP058
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information in a single large field from source system
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CSD006
      ** Access SAR details file to see if CSD006 is installed.                 CSD006
                                                                                CSD006
     C                   CALL      'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD006
                                                                                CSD006
     C                   IF        @RTCD <> *Blanks AND                         CSD006
     C                             @RTCD <> '*NRF   '                           CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   Z-ADD     2             DBASE                          CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   IF        @RTCD = *Blanks                              CSD006
     C                   MOVEL     'Y'           CSD006                         CSD006
     C                   ELSE                                                   CSD006
     C                   MOVEL     'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Access SAR details file to see if CAP058 is installed.                 CAP058
                                                                                CAP058
     C                   CALL      'AOSARDR0'                                   CAP058
     C                   PARM      *BLANKS       @RTCD                          CAP058
     C                   PARM      '*VERIFY'     @OPTN                          CAP058
     C                   PARM      'CAP058'      @SARD                          CAP058
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP058
                                                                                CAP058
     C                   IF        @RTCD <> *Blanks AND                         CAP058
     C                             @RTCD <> '*NRF   '                           CAP058
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP058
     C                   Z-ADD     2             DBASE                          CAP058
     C                   MOVEL     'CAP058'      DBKEY                          CAP058
     C                   EXSR      *PSSR                                        CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   IF        @RTCD = *Blanks                              CAP058
     C                   MOVEL     'Y'           CAP058            1            CAP058
     C                   ELSE                                                   CAP058
     C                   MOVEL     'N'           CAP058                         CAP058
     C                   ENDIF                                                  CAP058
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 4                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                      BUG1625
      ** Access SAR details file to determine if CSC022 switchable feature                   BUG1625
      ** is switched on                                                                      BUG1625
     C                   CALLB     'AOSARDR0'                                                BUG1625
     C                   PARM      *BLANKS       PRtCd                                       BUG1625
     C                   PARM      '*VERIFY'     POptn                                       BUG1625
     C                   PARM      'CSC022'      PSard                                       BUG1625
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG1625
                                                                                             BUG1625
     C                   IF        PRtCd = *Blanks                                           BUG1625
                                                                                             BUG1625
     C                   EVAL      CSC022 = 'Y'                                              BUG1625
     C                   IN        SCCMTJOB                                                  BUG1625
     C                   Z-ADD     1             CNT                                         BUG1625
     C                   MOVEL     *BLANKS       COMITSKIP                                   BUG1625
     C                   MOVEA     COMITARR      COMITJOB                                    BUG1625
     C     COMITNUM      IFGT      0                                                         BUG1625
     C     CNT           DOWLE     COMITNUM                                                  BUG1625
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                             BUG1625
     C                   MOVEL     'Y'           COMITSKIP                                   BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ADD       1             CNT                                         BUG1625
     C                   ENDDO                                                               BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ELSE                                                                BUG1625
      ** Database error                                                                      BUG1625
                                                                                             BUG1625
     C                   IF        PRtCd <> '*NRF'                                           BUG1625
     C     *LOCK         IN        LDA                                                       BUG1625
     C                   EVAL      DBKEY = 'CSC022'                                          BUG1625
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG1625
     C                   EVAL      DBASE = 006                                               BUG1625
     C                   OUT       LDA                                                       BUG1625
     C                   EXSR      *PSSR                                                     BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ENDIF                                                               BUG1625
      *                                                                         CAP058
      ** Access API ICD via access program                                      CAP058
     C                   CALLB     'AOAPIR0'                                    CAP058
     C                   PARM      '*DBERR '     @RTCD                          CAP058
     C                   PARM      '*FIRST '     @OPTN                          CAP058
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP058
      *                                                                         CAP058
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APINTRDTQ'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FDINTRC014
 
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
