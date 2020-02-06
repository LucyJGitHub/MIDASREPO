     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security diary events database update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDEUPD - Security Diary Events database update            *
      *                                                               *
      *  Function: This module will perform the update of the Midas   *
      *            database for the Security Diary Events.            *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDERPR                                      *
      *                SESEDEUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD037742           Date 03Apr16               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 237063             Date 20Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 18Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAP084             Date 06Feb04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037742 - Security diary events - pool factor reversal.     *
      *             Additional fix to allow deletion of matured diary *
      *             event with a live position settlement.            *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Bypass setting of PModeX to '*FRONT' if module      *
      *           is called from Midas Plus interface.                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01-02      Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRSetRecTot - Setup total for the record.                    *
      *  SRChkOthUpd - Check for update by another workstation        *
      *  SRInsert - Insert Security Diary Events                      *
      *  SRAmend - Amend Security Diary Events                        *
      *  SRDelete - Delete Security Diary Events                      *
      *  SRFmtDat - Format date for display                           *
      *  SRErr - Routine for Exception Errors                         *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Diary Events - Detail
     FSEDEV     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Security Diary Events - Audit
     FSEDEVA    UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(F1)
      *
      ** Position Settlement by Security
     FPOSET3    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F2)
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** SE Diary events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
     D*NwDEFilFmt1             1    231                                                CSE065 237063
      *
      ** SE Diary events for file update - Midas file format
     D SedevUpdF     E DS                  EXTNAME(SEDEVD)
     D*SedevUpdF1              1    231                                                CSE065 237063
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(CH)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
                                                                                              CSC011
      ** Header information to be passed to APLOGTRAN                                         CSC011
     D PHead         E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** Externally described DS for SAR details                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(S)                        CSC011
                                                                                              CSC011
      ** DS for access programs - short data structure                                        CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC011
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
     D  EndOfFile             02     02
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Work variables
     D WType           S              1A
     D WSvSRMI         S              1A
     D WSDED           S              6A
     D WSvSDTP         S              7P 3
     D WOrSDTP         S              7P 3
     D WOlSDPC         S              7P 3
     D WSvSDTR         S             13P 0
     D WOlSRPT         S             13P 0
     D WOlSDPP         S             15P 0
     D WSvSDTA         S             15P 0
     D WOrSDTA         S             15P 0
      *
      ** Work parameters
     D PPROT           S              1A
     D PReDsp          S              1A
     D PACTN           S              1A
     D BJDFIN          S              1A
     D CSE010          S              1A
     D S01509          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSE065          S              1A                                                      CSE065
     D OKACTN          S              1A
     D OKSDSN          S              1A
     D OKSDED          S              1A
     D OKSDET          S              1A
     D PSDET           S              2A
     D PDBRN           S              3A
     D BJSBRC          S              3A
     D BVBVP           S              3P 0
     D PNatn           S              5P 0
     D BJRDNB          S              5P 0
     D PEventDat       S              5P 0
     D PMode           S              6A
     D PSDED           S              6A
     D PSDSN           S             10A
     D PFRNT           S             20A
     D PTimeStamp      S             26Z
      *
      ** Parameters for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameter list for ZAMSGTOOPR
     D PMsgSndRtn      S             10A
     D PDBError        S            132A
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
     D Wc              S              2P 0
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define parameter to be passed to APLOGTRAN.                                          CSC011
     D TRANSDTL        S           5800A   INZ(*BLANKS)                                       CSC011
                                                                                              CSC011
      ** Define Timestamp (alpha) variable                                                    CSC011
     D PTime           S             26A                                                      CSC011
                                                                                              CSC011
      ** Work field for Date to be passed to RTV module                                       CSC011
     D PDateRTV        S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** Define Return code                                                                   CSC011
     D PRetCode        S             10A                                                      CSC011
                                                                                              CSC011
      ** Define Deal no parameter for APLOGTRAN                                               CSC011
     D PDealno         S             18A                                                      CSC011
                                                                                              CSC011
      ** Define associated deal number                                                        CSC011
     D PADealNo        S             18A                                                      CSC011
                                                                                              CSC011
      ** Work variable for Diary event date -alpha                                            CSC011
     D WEventDate      S              5A                                                      CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Check for update by another workstation.
      *
     C                   EXSR      SRChkOthUpd
      *
      ** Continue processing if no errors found.
      *
     C                   IF        RetCodeIn = *BLANKS
      *
      ** Retrieve next available transaction number.
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM                    RetCodeOut
     C                   PARM                    PNATN
      *
      ** Perform corresponding processing for Insert, Amend and Delete.
     C     S2CHTP        CASEQ     'I'           SRInsert
     C     S2CHTP        CASEQ     'A'           SRAmend
     C     S2CHTP        CASEQ     'D'           SRDelete
     C                   ENDCS
 
     C                   ENDIF
 
     C                   IF        RetCodeIn = *BLANKS
      *
      ** Action type is amend, adjust totals.
      *
     C                   IF        S2CHTP = 'A'
      *
      ** Update any running total fields on succeeding records for
      ** event types 'MP' and 'PP'.
      *
     C                   IF        S2SDET = 'MP' OR  S2SDET = 'PP'
 
     C                   EVAL      EndOfFile = False
     C     KSedev        SETGT     SEDEV
 
     C                   DOW       EndOfFile = False
     C     S2SDSN        READE     SEDEV                                  02
 
     C                   IF        EndOfFile = False AND
     C                             RECI <> 'C' AND S2SDET = SDET
      *
      ** Input mode - add to total.
      *
     C                   IF        SDET = 'MP'
     C                   SUB       WOlSRPT       SDTR
     C                   ADD       S2SRPT        SDTR
     C                   ENDIF
 
     C                   IF        SDET = 'PP'
     C                   SUB       WOlSDPP       SDTA
     C                   ADD       S2SDPP        SDTA
     C                   SUB       WOlSDPC       SDTP
     C                   ADD       S2SDPC        SDTP
     C                   ENDIF
      *
      ** Update record.
      *
     C                   EXCEPT    UPDTOT
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
      *
      ** Fetch Audit record and update if found.  Otherwise, error.
      *
     C     1             CHAIN     SEDEVAF                            01
 
     C                   IF        RecNotFnd = False
 
     C                   SELECT
     C                   WHEN      S2CHTP = 'I'
     C                   EVAL      F1NOIN = F1NOIN + 1
     C                   EVAL      F1NORE = F1NORE + 1
 
     C                   WHEN      S2CHTP = 'A'
      *                                                                                       CSE031
      ** If Amending a Security of Event type 'IR' which has been                             CSE031
      ** actioned then update trailer with 1 Delete and 1 Insert.                             CSE031
      *                                                                                       CSE031
     C                   IF        CSE031 = 'Y' AND S2SDET = 'IR' AND                         CSE031
     C                             S2SDED < BJRDNB AND S2SDAD <> 0                            CSE031
     C                   EVAL      F1NOIN = F1NOIN + 1                                        CSE031
     C                   EVAL      F1NORE = F1NORE + 1                                        CSE031
     C                   EVAL      F1NODE = F1NODE + 1                                        CSE031
      *                                                                                       CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      F1NOAM = F1NOAM + 1
     C                   ENDIF                                                                CSE031
 
     C                   WHEN      S2CHTP = 'D'
     C                   EVAL      F1NODE = F1NODE + 1
     C                   ENDSL
 
     C                   EVAL      F1TNLU = PNATN
 
     C                   UPDATE    SEDEVAF
 
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SEDEVA'
     C                   EVAL      DBKEY  = 'AUDIT'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
                                                                                              CSC011
      ** If CSC011 is on and current system is in support system, convert                     CSC011
      ** trade details and settlement details in file format to screen                        CSC011
      ** format to be written to support log file                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CLEAR                   PRetCode                                     CSC011
     C                   EXSR      SRCONVERT                                                  CSC011
                                                                                              CSC011
      ** If there are no errors in conversion, proceed with writing to                        CSC011
      ** AP standard log file.                                                                CSC011
     C                   IF        PRetCode = *BLANKS                                         CSC011
     C                   EXSR      SRAPILOG                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
 
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetRecTot - Setup total for the record.                    *
      *                                                               *
      *****************************************************************
     C     SRSetRecTot   BEGSR
      *
      ** Initialise variables
      *
     C                   MOVE      *BLANK        WSvSRMI
     C                   Z-ADD     *ZEROS        WOrSDTA
     C                   Z-ADD     *ZEROS        WOrSDTP
     C                   Z-ADD     *ZEROS        WSvSDTA
     C                   Z-ADD     *ZEROS        WSvSDTP
     C                   Z-ADD     *ZEROS        WSvSDTR
     C                   Z-ADD     *ZEROS        WOlSRPT
     C                   Z-ADD     *ZEROS        WOlSDPP
     C                   Z-ADD     *ZEROS        WOlSDPC
      *
      ** Get initial payments for this security if no payments has
      ** been made yet for partly paid diary events.
      *
     C                   IF        S2SDET = 'PP'
 
     C     S2SDSN        SETGT     SEDEV
     C                   READP     SEDEV                                  02
 
     C                   DOW       EndOfFile = False
      *
      ** Check record is not a cancelled record.
      *
     C                   IF        RECI <> 'C'
      *
      ** Check same security.
     C                   IF        S2SDSN = SDSN
      *
      ** Check same event type.
     C                   IF        SDET = 'PP'
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   EVAL      EndofFile = True
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READP     SEDEV                                  02
     C                   ENDDO
 
     C                   ENDIF
      *
      ** Update totals.
      *
     C     KSedev        SETLL     SEDEV
     C                   READP     SEDEV                                  02
 
     C                   DOW       EndOfFile = False
 
     C                   IF        S2SDSN = SDSN
 
     C                   IF        RECI <> 'C'
 
     C                   SELECT
      *
      ** For Partly Paids, add Call Amount to 'To date' figure.
      ** Fetch previous total.
      *
     C                   WHEN      S2SDET = 'PP' AND SDET = 'PP'
     C                   Z-ADD     SDTA          WSvSDTA
     C                   Z-ADD     SDPP          WOlSDPP
     C                   Z-ADD     SDTP          WSvSDTP
     C                   Z-ADD     SDPC          WOlSDPC
     C                   LEAVE
      *
      ** For mortgage payments, add Repayment amount to
      ** 'To date' figure. Fetch previous total.
      *
     C                   WHEN      S2SDET = 'MP' AND SDET = 'MP'
     C                   Z-ADD     SDTR          WSvSDTR
     C                   Z-ADD     SRPT          WOlSRPT
     C                   MOVE      SRMI          WSvSRMI
     C                   LEAVE
      *
      ** For Redemption Calls and Puts, add Call Amount to 'To date' figure.
      ** Fetch previous total.
      *
     C                   WHEN      (S2SDET = 'RP' OR S2SDET = 'RC') AND
     C                             (SDET = 'RP' OR SDET = 'RC')
     C                   Z-ADD     SDTA          WSvSDTA
     C                   Z-ADD     SDTP          WSvSDTP
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDIF
      *
      ** Exit if not same security.
      *
     C                   ELSE
     C                   EVAL      EndOfFile = True
     C                   LEAVE
     C                   ENDIF
 
     C                   READP     SEDEV                                  02
 
     C                   ENDDO
      *
      ** If no event was read for Partly Paid event, get 'currently paid
      ** price' from security.
      *
     C                   IF        S2SDET = 'PP' AND EndofFile = True
     C                   MOVE      D1CPDP        WOrSDTA
     C                   MOVE      D1CPDP        WOrSDTP
     C                   ENDIF
      *
      ** Add above amounts to totals.
      *
     C                   IF        S2SDET = 'MP'
 
     C                   EVAL      S2SDTR = WSvSDTR + S2SRPT
      *
      ** Set Repayment Method indicator to 'Y' if previously so, or if
      ** Repayment amount entered
      *
     C                   IF        WSvSRMI = 'Y' OR S2SRPT > *ZERO
     C                   MOVE      'Y'           S2SRMI
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      S2SDTA = WSvSDTA + S2SDPP
     C                   EVAL      S2SDTP = WSvSDTP + S2SDPC
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOthUpd - Check for update by another workstation        *
      *                                                               *
      *****************************************************************
     C     SRChkOthUpd   BEGSR
      *
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive).
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    Ptype
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, set retrieve mode to blank  (Access using Midas
      ** transaction Id).
      *
     C                   EVAL      WType = PType
 
     C                   IF        S2CHTP <> 'I'
     C                   MOVEL     '1'           WType
     C                   ENDIF
 
     C**********         IF        WType = '0'                                                CAP084
     C                   IF        WType = '0'   AND                                          CAP084
      *                                                                                       CAP084
      ** Only set up Pmode to '*FRONT' if not called from Midas Plus                          CAP084
      ** API wrapper.                                                                         CAP084
      *                                                                                       CAP084
     C                             PSJobName <> 'QZDASOINIT'
     C                             AND PSJobName <> 'QSQSRVR'                                 247277
     C                   MOVE      '*FRONT'      PMode
     C                   ELSE
     C                   MOVE      *BLANKS       PMode
     C                   ENDIF
      *
      ** Format diary event date.
      *
     C                   MOVEL     *BLANKS       PSDED
     C                   IF        S2SDED = 99999
     C                   MOVE      '999999'      PSDED
     C                   ELSE
     C                   Z-ADD     S2SDED        PDateIn
     C                   EXSR      SRFmtDat
     C                   MOVE      PDateOut      PSDED
     C                   ENDIF
                                                                                              CSC011
      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
      ** and current system is support system.                                                CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      PDateRTV = S1DATE                                          CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      PDateRTV = BJRDNB                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *
      ** Retrieve details.
      *
     C                   CALLB     'SESEDERTV'
      *
      ** Input
      ** =====
      *
      ** Retun Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM      *BLANK        ARRespMode
      *
      ** Action Code
     C                   PARM      S2CHTP        PACTN
      *
      ** Front Office Transaction Id
     C                   PARM      S2FRNT        PFRNT
      *
      ** Security Shortname
     C                   PARM      S2SDSN        PSDSN
      *
      ** Event Date
     C                   PARM                    PSDED
      *
      ** Event Type
     C                   PARM      S2SDET        PSDET
      *
      ** Standing data
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ***SDBANK*- Run day number                                                              CSC011
     C**********         PARM                    BJRDNB                                       CSC011
      ** Processing Date                                                                      CSC011
     C                   PARM                    PDateRTV                                     CSC011
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** Switchable features
      ** ===================
      *
      ** SE Transaction Enhancement
     C                   PARM                    CSE010
      *
      ** Value Ccy to be Ccy of Issuer Payment
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** Output
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event Date
     C                   PARM                    OKSDED
      *
      ** OK Event Type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Security Details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event Date in numeric format.
     C                   PARM                    PEventDat
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation).
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode, simply check whether the Timestamp field
      ** has been updated since the original Incoming Security was
      ** fetched by this program.  In batch (API input), check return
      ** parameters from retrieve module for errors, and send
      ** message to system operator.
      *
      ** Interactive mode:
      *
     C                   IF        PType = '1'
 
     C                   IF        CHTMST <> S2TMST
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   ENDIF
      *
      ** Batch mode:
      *
     C                   ELSE
 
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
     C                             OKSDED = 'N' OR OKSDET = 'N'
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   Z-ADD     1             Wc
 
     C     Wc            DOWLE     ArrayMax
     C     FldNameArr(Wc)ANDNE     *BLANKS
     C                   CLEAR                   PDBError
     C                   EVAL      PDBError = MsgIDArr(Wc)
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM      *BLANKS       PDummyMsgID
     C                   PARM      *BLANKS       PDummyMsgF
     C                   ADD       1             Wc
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert Security Diary Events                      *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
      *
      ** Setup record's total
     C                   EXSR      SRSetRecTot
      *
      ** Check if record already exists in Security Diary Events file.
      ** Error if it already exists.
      *
     C     KSedev        CHAIN     SEDEVDF                            01
 
     C                   IF        RecNotFnd = False
 
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      SRErr
 
     C                   ELSE
      *
      ** Generate Timestamp.
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   EVAL      S2TMST = PTimestamp
     C                   EVAL      S2LCD  = BJRDNB
     C                   EVAL      S2TNLU = PNATN
      *
      ** Move valid file fields to fields for update
     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
     C                   ENDIF                                                                CSE065
 
     C                   ENDIF
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   MOVE      SDED          WEventDate                                   CSC011
     C                   EVAL      FRNT = 'MD' + SDSN + WEventDate +                          CSC011
     C                                    SDET                                                CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
 
     C                   WRITE     SEDEVDF                              99
      *
      ** DBError processing when error occurred during write.
      *
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend Security Diary Events                        *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
      *                                                                                       CSE031
      ** If Amending a Security of Event type 'IR' which has been                             CSE031
      ** actioned then Delete current event and Insert a new one.                             CSE031
      *                                                                                       CSE031
 B1  C                   IF        CSE031 = 'Y' AND S2SDET = 'IR' AND                         CSE031
     C                             S2SDED < BJRDNB AND S2SDAD <> 0                            CSE031
      *                                                                                       CSE031
      ** Delete this Diary Event                                                              CSE031
      ** -----------------------                                                              CSE031
      *                                                                                       CSE031
     C     KSedev        CHAIN     SEDEVDF                            01                      CSE031
      *                                                                                       CSE031
      ** Generate Timestamp.                                                                  CSE031
     C                   CALLB     'ZAGENTMSTM'                                               CSE031
     C                   PARM                    PTimestamp                                   CSE031
                                                                                              CSE031
     C                   EVAL      S2TMST = PTimestamp                                        CSE031
     C                   EVAL      S2LCD  = BJRDNB                                            CSE031
     C                   EVAL      S2TNLU = PNATN                                             CSE031
      *                                                                                       CSE031
      ** Move valid file fields to fields for update.                                         CSE031
     C**********         MOVEL     NwDEFilFmt    SedevUpdF                             CSE031 CSE065
     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE031
      ** Update record.                                                                       CSE031
     C                   MOVE      'C'           RECI                                         CSE031
     C                   MOVE      'D'           CHTP                                         CSE031
      *                                                                                       CSE031
     C                   UPDATE    SEDEVDF                              99                    CSE031
      *                                                                                       CSE031
      ** Insert a New Diary Event                                                             CSE031
      ** ------------------------                                                             CSE031
      *                                                                                       CSE031
      ** Retrieve next available transaction number.                                          CSE031
      *                                                                                       CSE031
     C                   CALLB     'ZTNLU1'                                                   CSE031
     C                   PARM                    RetCodeOut                                   CSE031
     C                   PARM                    PNATN                                        CSE031
      *                                                                                       CSE031
      ** Generate Timestamp.                                                                  CSE031
     C                   CALLB     'ZAGENTMSTM'                                               CSE031
     C                   PARM                    PTimestamp                                   CSE031
                                                                                              CSE031
     C                   EVAL      S2TMST = PTimestamp                                        CSE031
     C                   EVAL      S2LCD  = BJRDNB                                            CSE031
     C                   EVAL      S2TNLU = PNATN                                             CSE031
      *                                                                                       CSE031
      ** Move valid file fields to fields for update.                                         CSE031
     C**********         MOVEL     NwDEFilFmt    SedevUpdF                             CSE031 CSE065
     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE031
      ** Write record.                                                                        CSE031
     C                   MOVE      'D'           RECI                                         CSE031
     C                   MOVE      'I'           CHTP                                         CSE031
      *                                                                                       CSE031
     C                   WRITE     SEDEVDF                                                    CSE031
      *                                                                                       CSE031
 X1  C                   ELSE                                                                 CSE031
      *
      ** Setup record's total
     C                   EXSR      SRSetRecTot
      *
      ** Check if record already exists in Security Diary Events file.
      *
     C     KSedev        CHAIN     SEDEVDF                            01
      *
      ** Error if it does not exists.
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  004
     C                   OUT       LDA
     C                   EXSR      SRErr
 
     C                   ELSE
      *
      ** If transaction number changes, send error message "The last
      ** transaction was not applied to the database."
     C                   IF        TNLU <> S2TNLU
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   RETURN
     C                   ENDIF
      *
      ** Generate Timestamp.
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   EVAL      S2TMST = PTimestamp
     C                   EVAL      S2LCD  = BJRDNB
     C                   EVAL      S2TNLU = PNATN
      *
      ** Move valid file fields to fields for update
     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Update record
     C                   UPDATE    SEDEVDF                              99
      *
      ** DBError processing when error occurred during update.
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CSE031
 E1  C                   ENDIF                                                                CSE031
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete Security Diary Events                      *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
      *
      ** If there are any live position settlements for this security
      ** event, output message to screen, and prevent deletion.
      *
     C     S2SDSN        SETLL     POSETDF
     C     S2SDSN        READE     POSETDF                                02
 
     C                   DOW       EndofFile = False
     C                   IF        S2SDED = F2PDUD AND
     C                             S2SDET = F2PEVT AND
     C**********                   F2RECI = 'D'                                             MD037742
     C                             F2RECI = 'D' AND S2RECI = 'D'                            MD037742
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   RETURN
     C                   ENDIF
 
     C     S2SDSN        READE     POSETDF                                02
     C                   ENDDO
      *
      ** Check if record already exists in Security Diary Events file.
      *
     C     KSedev        CHAIN     SEDEVDF                            01
      *
      ** Error if it does not exists.
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  006
     C                   OUT       LDA
     C                   EXSR      SRErr
 
     C                   ELSE
      *
      ** If transaction number changes, send error message "The last
      ** transaction was not applied to the database."
     C                   IF        TNLU <> S2TNLU
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   RETURN
     C                   ENDIF
      *
      ** Generate Timestamp.
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   EVAL      S2TMST = PTimestamp
     C                   EVAL      S2LCD  = BJRDNB
     C                   EVAL      S2TNLU = PNATN
      *
      ** Move valid file fields to fields for update.
     C**********         MOVEL     NwDEFilFmt    SedevUpdF                                    CSE065
     C**********         MOVEL     NwDEFilFmt1   SedevUpdF1                            CSE065 237063
     C                   MOVEL     NwDEFilFmt    SedevUpdF                                    237063
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     S2SDAL        SDAL                                         CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        SDAL                                         CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Update record.
     C                   UPDATE    SEDEVDF                              99
      *
      ** DBError processing when error occurred during update.
     C                   IF        *IN99 = *ON
     C     *LOCK         IN        LDA
     C                   MOVE      S2SDED        WSDED
     C                   EVAL      DBKEY  = S2SDSN + WSDED + S2SDET
     C                   EVAL      DBFILE = 'SEDEVD'
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDat - Format date for display                           *
      *                                                               *
      *****************************************************************
     C     SRFmtDat      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CSC011
      *  SRCONVERT - convert Securitiy Diary Event details to screen  *                       CSC011
      *    ~~~~~~~   format before writing to standard API log file.  *                       CSC011
      *                                                               *                       CSC011
      *  Called by: Main Processing                                   *                       CSC011
      *  Calls    : SESEDELOG - Diary events support log setup module *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRCONVERT     BEGSR                                                                CSC011
                                                                                              CSC011
      ** Input:                                                                               CSC011
      ** SE Diary events in file format                                                       CSC011
      ** Date Format Indicator                                                                CSC011
      ** Enhancement S01509                                                                   CSC011
                                                                                              CSC011
      ** Output parameters:                                                                   CSC011
      ** Return Code                                                                          CSC011
      ** SE Diary events in screen format                                                     CSC011
     C                   CALLB     'SESEDELOG'                                                CSC011
     C                   PARM                    PRetCode                                     CSC011
     C                   PARM                    SedevUpdF                                    CSC011
     C                   PARM                    BJDFIN                                       CSC011
     C                   PARM                    S01509                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If error occurred in program, return with an error code.                             CSC011
     C                   IF        PRetCode <> *BLANKS                                        CSC011
     C                   EVAL      DBASE = 9                                                  CSC011
     C                   EVAL      DBFILE = 'SESEDELOG'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      *  SRAPILOG - write SE Diary Event details to standard log file *                       CSC011
      *                                                               *                       CSC011
      *  Called by: Main processing                                   *                       CSC011
      *  Calls    : APLOGTRAN - Log transaction from support dbase    *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRAPILOG      BEGSR                                                                CSC011
                                                                                              CSC011
     C                   CLEAR                   PHead                                        CSC011
      ** Fill up other neccessary information in the header to be used                        CSC011
      ** by APTRANLOG                                                                         CSC011
     C                   EVAL      APTGTTYPE = 'SESEDE'                                       CSC011
     C                   EVAL      APFOTRANID = S2FRNT                                        CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
                                                                                              CSC011
      ** Place event date to alpha field                                                      CSC011
     C                   MOVE      SDED          WEventDate                                   CSC011
                                                                                              CSC011
      ** Fill deal no. parameter with key values from SEDEV                                   CSC011
     C                   EVAL      PDealNo = SDSN + WEventDate + SDET                         CSC011
                                                                                              CSC011
      ** Input parameters:                                                                    CSC011
      ** Header information                                                                   CSC011
      ** SE Diary Event Details                                                               CSC011
      ** Timestamp                                                                            CSC011
      ** Event Identifier (deal no.)                                                          CSC011
                                                                                              CSC011
      ** Output parameter:                                                                    CSC011
      ** ReturnCode                                                                           CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       PRetCode                                     CSC011
     C                   PARM                    PHead                                        CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTime                                        CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If error occurred, return with an error to the calling program                       CSC011
     C                   IF        PRetCode <> *BLANKS                                        CSC011
     C                   EVAL      DBASE = 10                                                 CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBKEY = '*CALL'                                            CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
      *****************************************************************                       CSC011
      /EJECT                                                                                  CSC011
      *****************************************************************                       CSC011
      *                                                               *
      *  SRErr - Routine for Exception Errors                         *
      *                                                               *
      *****************************************************************
     C     SRErr         BEGSR
 
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
      *
      ** Terminate program.
      *
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Input
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** SE Diary events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Standing data
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** Switchable features
      ** ===================
      *
      ** SE Transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value Ccy to be Ccy of issuer payment
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** Key list for Security Diary Events details
     C     KSedev        KLIST
     C                   KFLD                    S2SDSN
     C                   KFLD                    S2SDED
     C                   KFLD                    S2SDET
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
                                                                                              CSC011
      ** Check if Midas 24x7 Availability is installed.                                       CSC011
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
     C                   EVAL      DBASE = 8                                                  CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANK                                             CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSE065
      ** Access SAR file to determine if CSE065 is installed                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSarD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** An NRF (No Record Found) return code is valid.                                       CSE065
      ** Issue database error only for error return codes.                                    CSE065
                                                                                              CSE065
     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
     C                             PRtcd <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKey = 'CSE065'                                           CSE065
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
     C                   EVAL      DBase = 011                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSC011
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
     OSEDEVDF   E            UPDTOT
     O                       SDTR
     O                       SDTA
     O                       SDTP
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
