     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR IRC Support Log Setup Module')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS ILE Module                                   *
      *                                                               *
      *  IRIRCLOG - IRC Support Log Setup Module                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Function:  This module logs updated additional IRC schedules *
      *             to the 24x7 valid log file when the support       *
      *             system is active.                                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11456           Date 11May06               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP043  *CREATE    Date 02May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11456-Screen-definition file should be alpha              *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLDTSCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDTSCD0:DLDTSCD1)
     FDLDTSCL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDTSCD0:DLDTSCD2)
     FDLDTSCL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDTSCD0:DLDTSCD3)
     FDLDTSCL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDTSCD0:DLDTSCD4)
     FDLCFSCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLCFSCD0:DLCFSCD1)
     FDLCFSCL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLCFSCD0:DLCFSCD2)
     FDLPCSCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLPCSCD0:DLPCSCD1)
     FDLPCSCL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLPCSCD0:DLPCSCD2)
 
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
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Last processing date (82nd PRDT) UR/UP/TR/TP
     D PLastPRDT       DS
     D WLastPRDT               1     12P 0 DIM(4)
 
      ** Header DS
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      ** Our Rate Change Dates (IRCs)
     D OurRDTSCScn   E DS                  EXTNAME(IRDTSCPD) PREFIX(OR)
     D ORDatesAlp              1    492A   DIM(82)
 
      ** Our Interest Payment Dates (IRCs)
     D OurPDTSCScn   E DS                  EXTNAME(IRDTSCPD) PREFIX(OI)
     D OPDatesAlp              1    492A   DIM(82)
 
      ** Their Rate Change Dates (IRCs)
     D ThrRDTSCScn   E DS                  EXTNAME(IRDTSCPD) PREFIX(TR)
     D TRDatesAlp              1    492A   DIM(82)
 
     D ThrPDTSCScn   E DS                  EXTNAME(IRDTSCPD) PREFIX(TI)
      ** Their Interest Payment Dates (IRCs)
     D TPDatesAlp              1    492A   DIM(82)
 
      ** Our Cash Flow (IRCs)
     D OurCFSCScn    E DS                  EXTNAME(IRCFSCPD) PREFIX(UC)
     D OurCashD                1    492    DIM(82)
     D OurCashA              493   1640    DIM(82)
 
      ** Their Cash Flow (IRCs)
     D ThrCFSCScn    E DS                  EXTNAME(IRCFSCPD) PREFIX(TC)
     D ThrCashD                1    492    DIM(82)
     D ThrCashA              493   1640    DIM(82)
 
      ** Our Principal Change (IRCs)
     D OurPCSCScn    E DS                  EXTNAME(IRPCSCPD) PREFIX(UP)
     D OurPrinD                1    492    DIM(82)
     D OurPrinA              493   1804    DIM(82)
     D OurPrinI             1805   1886    DIM(82)
 
      ** Their Principal Change (IRCs)
     D ThrPCSCScn    E DS                  EXTNAME(IRPCSCPD) PREFIX(TP)
     D ThrPrinD                1    492    DIM(82)
     D ThrPrinA              493   1804    DIM(82)
     D ThrPrinI             1805   1886    DIM(82)
 
      ** SIRS Extra data DS
     D SIRSExtDta    E DS                  EXTNAME(IRSSEXPD) PREFIX(S)
 
      ** CIRS Extra data DS
     D CIRSExtDta    E DS                  EXTNAME(IRCSEXPD) PREFIX(C)
 
      ** CACF Extra data DS
     D CACFExtDta    E DS                  EXTNAME(IRCPEXPD) PREFIX(F)
 
      ** Trailer file DS
     D TrailerDS     E DS                  EXTNAME(IRTRSCPD)
 
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)
 
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)
 
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)
 
     D VPAYScnFmt    E DS                  EXTNAME(SDESSPPD) PREFIX(V)
 
     D VRECScnFmt    E DS                  EXTNAME(SDESSRPD) PREFIX(V)
 
     D MPAYScnFmt    E DS                  EXTNAME(SDESSPPD) PREFIX(M)
 
     D MRECScnFmt    E DS                  EXTNAME(SDESSRPD) PREFIX(M)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data Structure used by Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data Structure used by Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCAMT           S             15P 0
     D WDLNO           S              6S 0
     D PDATFMT         S              1A
     D PDealNum        S              6S 0
     D WMsgType        S             32A
     D WOurNBDP        S              1  0
     D WThrNBDP        S              1  0
     D WOTINUR         S              1A
     D WOTINUI         S              1A
     D WOTINTR         S              1A
     D WOTINTI         S              1A
     D WRCIPUR         S              1A
     D WRCIPUI         S              1A
     D WRCIPTR         S              1A
     D WRCIPTI         S              1A
     D WPRDTUR         S              5P 0
     D WPRDTUI         S              5P 0
     D WPRDTTR         S              5P 0
     D WPRDTTI         S              5P 0
     D WOTINUC         S              1A
     D WOTINTC         S              1A
     D WOTINUP         S              1A
     D WOTINTP         S              1A
     D Timestamp       S             26A
     D TRANSDTL        S           5800A
     D PDealNm         S             18A
     D PADealNo        S             18A
     D X               S              2P 0
     D PZDAYNO         S              5  0
     D PZFIELD         S             16A
     D PZADEC          S              1  0
     D PDATE           S              6  0
     D PADATE          S              7A
     D PCURR           S              3A
     D POurCCy         S              3A
     D PThrCCy         S              3A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PBGN2ST         S              1A
     D PFunction       S              4A
     D PFrontID        S             20A
     D WIncDec         S              1A
     D WLog            S              1A
     D WLogTran        S              1A
     D PInfData        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise log indicator work field
 
     C                   EVAL      WLogTran = 'N'
 
      ** Set up front office Id of the transaction to be logged
 
     C                   IF        PFrontID <> *BLANK
     C                   EVAL      APFOTRANID = PFrontID
     C                   EVAL      APFOASOCID = PFrontID
     C                   ENDIF
 
      ** Main Processing
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProc - Process IRC sched retrieval and logging              *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
      ** Set deal number key
 
     C                   EVAL      WDLNO = PDealNum
 
     C                   IF        PFunction <> 'CACF'
 
      ** Process DTSC records
 
     C                   EXSR      SRDTSC
 
      ** Process CFSC records
 
     C                   EXSR      SRCFSC
 
     C                   ENDIF
 
      ** Process PCSC records
 
     C                   EXSR      SRPCSC
 
      ** Process Trailer
 
     C                   EXSR      SRTRSC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDTSC - Process DTSC retrieval and logging                   *
      *                                                               *
      *****************************************************************
     C     SRDTSC        BEGSR
 
      ** Set key to the 82nd processing date in the file for 'UR'
      ** (1st set of 82 records already processed in IRIRCRTV module)
 
     C                   EVAL      WOTINUR = 'U'
     C                   EVAL      WRCIPUR = 'R'
     C                   EVAL      WPRDTUR = WLastPRDT(1)
 
     C     KDTSCPrUR     SETGT     DLDTSCL1
 
      ** Set key to the 82nd processing date in the file for 'UP'
      ** (1st set of 82 records already processed in IRIRCRTV module)
 
     C                   EVAL      WOTINUI = 'U'
     C                   EVAL      WRCIPUI = 'P'
     C                   EVAL      WPRDTUI = WLastPRDT(2)
 
     C     KDTSCPrUI     SETGT     DLDTSCL2
 
      ** Set key to the 82nd processing date in the file for 'TR'
      ** (1st set of 82 records already processed in IRIRCRTV module)
 
     C                   EVAL      WOTINTR = 'T'
     C                   EVAL      WRCIPTR = 'R'
     C                   EVAL      WPRDTTR = WLastPRDT(3)
 
     C     KDTSCPrTR     SETGT     DLDTSCL3
 
      ** Set key to the 82nd processing date in the file for 'TP'
      ** (1st set of 82 records already processed in IRIRCRTV module)
 
     C                   EVAL      WOTINTI = 'T'
     C                   EVAL      WRCIPTI = 'R'
     C                   EVAL      WPRDTTI = WLastPRDT(4)
 
     C     KDTSCPrTI     SETGT     DLDTSCL4
 
      ** Log data per 82 records
 
     C                   EVAL      WLOG = 'Y'
 
     C                   DOW       (WLOG = 'Y')
 
      ** Retrieve 82 records for 'UR' then log to log file
 
     C     KDTSCUR       READE     DLDTSCL1
 
     C                   EVAL      X = 1
     C                   CLEAR                   OurRDTSCScn
 
     C                   DOW       NOT %EOF(DLDTSCL1) AND X < 83
     C                   EXSR      SRDTSCFmt
     C                   MOVE      PDATE         ORDatesAlp(X)
     C     KDTSCUR       READE     DLDTSCL1
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLDTSCL1) AND (X = 83)
     C     KDTSCUR       READPE    DLDTSCL1
     C                   ENDIF
     C                   ENDDO
 
      ** Retrieve 82 records for 'UP' then log to log file
 
     C     KDTSCUI       READE     DLDTSCL2
 
     C                   EVAL      X = 1
     C                   CLEAR                   OurPDTSCScn
 
     C                   DOW       NOT %EOF(DLDTSCL2) AND X < 83
     C                   EXSR      SRDTSCFmt
     C                   MOVE      PDATE         OPDatesAlp(X)
     C     KDTSCUI       READE     DLDTSCL2
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLDTSCL2) AND (X = 83)
     C     KDTSCUI       READPE    DLDTSCL2
     C                   ENDIF
     C                   ENDDO
 
      ** Retrieve 82 records for 'TR' then log to log file
 
     C     KDTSCTR       READE     DLDTSCL3
 
     C                   EVAL      X = 1
     C                   CLEAR                   ThrRDTSCScn
 
     C                   DOW       NOT %EOF(DLDTSCL3) AND X < 83
     C                   EXSR      SRDTSCFmt
     C                   MOVE      PDATE         TRDatesAlp(X)
     C     KDTSCTR       READE     DLDTSCL3
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLDTSCL3) AND (X = 83)
     C     KDTSCTR       READPE    DLDTSCL3
     C                   ENDIF
     C                   ENDDO
 
      ** Retrieve 82 records for 'TP' then log to log file
 
     C     KDTSCTI       READE     DLDTSCL4
 
     C                   EVAL      X = 1
     C                   CLEAR                   ThrPDTSCScn
 
     C                   DOW       NOT %EOF(DLDTSCL4) AND X < 83
     C                   EXSR      SRDTSCFmt
     C                   MOVE      PDATE         TPDatesAlp(X)
     C     KDTSCTI       READE     DLDTSCL4
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLDTSCL4) AND (X = 83)
     C     KDTSCTI       READPE    DLDTSCL4
     C                   ENDIF
     C                   ENDDO
 
      ** Log data to log file if either is not blank otherwise, end DTSC
      ** processing
 
     C                   IF        (OurRDTSCScn <> *BLANK) OR
     C                             (OurPDTSCScn <> *BLANK) OR
     C                             (ThrRDTSCScn <> *BLANK) OR
     C                             (ThrPDTSCScn <> *BLANK)
     C                   EXSR      SRDTSCLog
     C                   ELSE
     C                   EVAL      WLOG = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFSC - Process CFSC retrieval and logging                   *
      *                                                               *
      *****************************************************************
     C     SRCFSC        BEGSR
 
      ** Set the pointer to the first non-processed date of our cash flow
 
     C                   EVAL      WOTINUC = 'U'
 
     C     KCFSCUC       SETLL     DLCFSCL1
 
      ** Set the pointer to the first non-processed date of their cash flow
 
     C                   EVAL      WOTINTC = 'T'
 
     C     KCFSCTC       SETLL     DLCFSCL2
 
      ** Log data per 82 records
 
     C                   EVAL      WLOG = 'Y'
 
     C                   DOW       (WLOG = 'Y')
 
      ** Retrieve 82 records for 'U' then log to log file
 
     C     KCFSCUC       READE     DLCFSCL1
 
     C                   EVAL      X = 1
     C                   CLEAR                   OurCFSCScn
 
     C                   DOW       NOT %EOF(DLCFSCL1) AND X < 83
     C                   EVAL      PZADEC = WOurNBDP
     C                   EXSR      SRCFSCFmt
     C                   MOVE      PDATE         OurCashD(X)
     C                   MOVE      PZFIELD       OurCashA(X)
     C     KCFSCUC       READE     DLCFSCL1
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLCFSCL1) AND (X = 83)
     C     KCFSCUC       READPE    DLCFSCL1
     C                   ENDIF
     C                   ENDDO
 
      ** Retrieve 82 records for 'T' then log to log file
 
     C     KCFSCTC       READE     DLCFSCL2
 
     C                   EVAL      X = 1
     C                   CLEAR                   ThrCFSCScn
 
     C                   DOW       NOT %EOF(DLCFSCL2) AND X < 83
     C                   EVAL      PZADEC = WThrNBDP
     C                   EXSR      SRCFSCFmt
     C                   MOVE      PDATE         ThrCashD(X)
     C                   MOVE      PZFIELD       ThrCashA(X)
     C     KCFSCTC       READE     DLCFSCL2
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLCFSCL2) AND (X = 83)
     C     KCFSCTC       READPE    DLCFSCL2
     C                   ENDIF
     C                   ENDDO
 
      ** Log data to log file if either is not blank otherwise, end CFSC
      ** processing
 
     C                   IF        (OurCFSCScn <> *BLANK) OR
     C                             (ThrCFSCScn <> *BLANK)
     C                   EXSR      SRCFSCLog
     C                   ELSE
     C                   EVAL      WLOG = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPCSC - Process PCSC retrieval and logging                   *
      *                                                               *
      *****************************************************************
     C     SRPCSC        BEGSR
 
      ** Set the pointer to the first non-processed date of our principal change
 
     C                   IF        PFunction = 'CIRS'
     C                   EVAL      WOTINUP = 'U'
     C                   EVAL      WOTINTP = 'T'
     C                   ELSE
     C                   EVAL      WOTINUP = *BLANK
     C                   EVAL      WOTINTP = *BLANK
     C                   ENDIF
 
     C     KPCSCUP       SETLL     DLPCSCL1
 
      ** Set the pointer to the first non-processed date of their principal change
 
     C                   IF        PFunction = 'CIRS'
     C     KPCSCTP       SETLL     DLPCSCL2
     C                   ENDIF
 
      ** Log data per 82 records
 
     C                   EVAL      WLOG = 'Y'
 
     C                   DOW       (WLOG = 'Y')
 
      ** Retrieve 82 records for 'U' then log to log file
 
     C     KPCSCUP       READE     DLPCSCL1
 
     C                   EVAL      X = 1
     C                   CLEAR                   OurPCSCScn
 
     C                   DOW       NOT %EOF(DLPCSCL1) AND X < 83
     C                   EVAL      PZADEC = WOurNBDP
     C                   EXSR      SRPCSCFmt
     C                   MOVE      PDATE         OurPrinD(X)
     C                   MOVE      PZFIELD       OurPrinA(X)
     C                   MOVE      WIncDec       OurPrinI(X)
     C     KPCSCUP       READE     DLPCSCL1
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLPCSCL1) AND (X = 83)
     C     KPCSCUP       READPE    DLPCSCL1
     C                   ENDIF
     C                   ENDDO
 
      ** Retrieve 82 records for 'T' then log to log file
 
     C                   IF        PFunction = 'CIRS'
 
     C     KPCSCTP       READE     DLPCSCL2
 
     C                   EVAL      X = 1
     C                   CLEAR                   ThrPCSCScn
 
     C                   DOW       NOT %EOF(DLPCSCL2) AND X < 83
     C                   EVAL      PZADEC = WThrNBDP
     C                   EXSR      SRPCSCFmt
     C                   MOVE      PDATE         ThrPrinD(X)
     C                   MOVE      PZFIELD       ThrPrinA(X)
     C                   MOVE      WIncDec       ThrPrinI(X)
     C     KPCSCTP       READE     DLPCSCL2
     C                   EVAL      X = X + 1
 
      ** If counter is 83 and there are still records to process, set the pointer back
      ** to the previous record so that upon READE again, the correct record (83rd) will
      ** retrieved
 
     C                   IF        NOT %EOF(DLPCSCL2) AND (X = 83)
     C     KPCSCTP       READPE    DLPCSCL2
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** Log data to log file if either is not blank otherwise, end PCSC
      ** processing
 
     C                   IF        (OurPCSCScn <> *BLANK) OR
     C                             (ThrPCSCScn <> *BLANK) AND
     C                             (PFunction = 'CIRS')
     C                   EXSR      SRPCSCLog
     C                   ELSE
     C                   EVAL      WLOG = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRSC - Process Trailer                                      *
      *                                                               *
      *****************************************************************
     C     SRTRSC        BEGSR
 
      ** Log trailer to log file only when log indicator is set to 'Y'
 
     C                   IF        (WLogTran = 'Y')
     C                   EXSR      SRTRSCLog
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDTSCFmt - Convert DTSC field to screen format               *
      *                                                               *
      *****************************************************************
     C     SRDTSCFmt     BEGSR
 
     C                   EVAL      PZDAYNO = *ZERO
 
     C                   EVAL      PZDAYNO = PRDT
     C                   EXSR      SRZDate2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFSCFmt - Convert CFSC fields to screen format              *
      *                                                               *
      *****************************************************************
     C     SRCFSCFmt     BEGSR
 
     C                   EVAL      PZDAYNO = *ZERO
     C                   EVAL      PZFIELD = *BLANK
 
     C                   EVAL      PZDAYNO = PRDT
     C                   EXSR      SRZDate2
 
     C                   MOVE      CFLA          PZFIELD
     C                   EXSR      SRZEdit
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPCSCFmt - Convert PCSC fields to screen format              *
      *                                                               *
      *****************************************************************
     C     SRPCSCFmt     BEGSR
 
     C                   EVAL      WIncDec = *BLANK
     C                   EVAL      PZDAYNO = *ZERO
     C                   EVAL      PZFIELD = *BLANK
 
     C                   EVAL      PZDAYNO = PRDT
     C                   EXSR      SRZDate2
 
     C                   MOVE      PAMT          PZFIELD
     C                   EXSR      SRZEdit
 
     C                   IF        PBGN2ST = 'Y'
     C                   IF        CAMT < 0
     C                   Z-SUB     CAMT          WCAMT
     C                   EVAL      WIncDec = 'D'
     C                   ELSE
     C                   Z-ADD     CAMT          WCAMT
     C                   EVAL      WIncDec = 'I'
     C                   ENDIF
 
     C                   EVAL      PZFIELD = *BLANK
     C                   MOVE      WCAMT         PZFIELD
     C                   EXSR      SRZEdit
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDTSCLog - Log Transaction to Log file                       *
      *                                                               *
      *****************************************************************
     C     SRDTSCLog     BEGSR
 
      ** Setup message type
 
     C                   SELECT
 
     C                   WHEN      PFunction = 'CIRS'
     C                   EVAL      WMsgType = 'IRCIRI'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurRDTSCScn +
     C                                        OurPDTSCScn +
     C                                        ThrRDTSCScn +
     C                                        ThrPDTSCScn +
     C                                        CIRSExtDta
 
     C                   WHEN      PFunction = 'SIRS'
     C                   EVAL      WMsgType = 'IRSIRI'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurRDTSCScn +
     C                                        OurPDTSCScn +
     C                                        ThrRDTSCScn +
     C                                        ThrPDTSCScn +
     C                                        SIRSExtDta
     C                   ENDSL
 
     C                   EXSR      SRLogTran
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCFSCLog - Log Transaction to Log file                       *
      *                                                               *
      *****************************************************************
     C     SRCFSCLog     BEGSR
 
      ** Setup message type
 
     C                   SELECT
 
     C                   WHEN      PFunction = 'CIRS'
     C                   EVAL      WMsgType = 'IRCICF'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurCFSCScn +
     C                                        ThrCFSCScn +
     C                                        CIRSExtDta
 
     C                   WHEN      PFunction = 'SIRS'
     C                   EVAL      WMsgType = 'IRSICF'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurCFSCScn +
     C                                        ThrCFSCScn +
     C                                        SIRSExtDta
     C                   ENDSL
 
     C                   EXSR      SRLogTran
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPCSCLog - Log Transaction to Log file                       *
      *                                                               *
      *****************************************************************
     C     SRPCSCLog     BEGSR
 
      ** Setup message type
 
     C                   SELECT
 
     C                   WHEN      PFunction = 'CIRS'
     C                   EVAL      WMsgType = 'IRCIPC'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurPCSCScn +
     C                                        ThrPCSCScn +
     C                                        CIRSExtDta
 
     C                   WHEN      PFunction = 'SIRS'
     C                   EVAL      WMsgType = 'IRSIPC'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurPCSCScn +
     C                                        SIRSExtDta
 
     C                   WHEN      PFunction = 'CACF'
     C                   EVAL      WMsgType = 'IRCAPC'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL = OurPCSCScn +
     C                                        CACFExtDta
 
     C                   ENDSL
 
     C                   EXSR      SRLogTran
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRSCLog - Log Trailer to log file                           *
      *                                                               *
      *****************************************************************
     C     SRTRSCLog     BEGSR
 
      ** Setup message type
 
     C                   SELECT
 
     C                   WHEN      PFunction = 'CIRS'
     C                   EVAL      WMsgType = 'IRCITR'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL =  TrailerDS +
     C                                         RECScnFmt +
     C                                         PAYScnFmt +
     C                                         FRIRScnFmt +
     C                                         VRECScnFmt +
     C                                         VPAYScnFmt +
     C                                         MRECScnFmt +
     C                                         MPAYScnFmt +
     C                                         PInfData +
     C                                         CIRSExtDta
 
     C                   WHEN      PFunction = 'SIRS'
     C                   EVAL      WMsgType = 'IRSITR'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL =  TrailerDS +
     C                                         RECScnFmt +
     C                                         PAYScnFmt +
     C                                         FRIRScnFmt +
     C                                         PInfData +
     C                                         SIRSExtDta
 
     C                   WHEN      PFunction = 'CACF'
     C                   EVAL      WMsgType = 'IRCATR'
 
      ** Setup TRANSDTL log parameter
 
     C                   EVAL      TRANSDTL =  TrailerDS +
     C                                         RECScnFmt +
     C                                         PAYScnFmt +
     C                                         FRIRScnFmt +
     C                                         PInfData +
     C                                         CACFExtDta
 
     C                   ENDSL
 
     C                   EXSR      SRLogTran
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRZDate2 - Call to ZDATE2 module                                 *
      *                                                                  *
      ********************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDAYNO
     C                   PARM      BJDFIN        PDATFMT
     C                   PARM      *ZERO         PDATE
     C                   PARM      *BLANK        PADATE
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRZEdit - Call to ZEDIT module                                   *
      *                                                                  *
      ********************************************************************
 
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM                    PZADEC
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRLogTran  - Logs the transaction to log file via                *
      *              APLOGTRAN module                                    *
      *                                                                  *
      ********************************************************************
 
     C     SRLogTran     BEGSR
 
      ** Write transaction to the log file via APLOGTRAN standard module
 
     C                   EVAL      APTGTTYPE = WMsgType
     C                   MOVEL     WDLNO         PDealNm
     C                   EVAL      PADealNo = PDealNm
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNm
     C                   PARM                    PADealNo
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNm
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WLogTran = 'Y'
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
     C                   PARM                    RetCodeIn
     C                   PARM                    PFunction
     C                   PARM                    PFrontID
     C                   PARM                    PDealNum
     C                   PARM                    PLastPRDT
     C                   PARM                    POurCcy
     C                   PARM                    PThrCcy
     C                   PARM                    PBGN2ST
     C                   PARM                    RECScnFmt
     C                   PARM                    PAYScnFmt
     C                   PARM                    FRIRScnFmt
     C                   PARM                    VRECScnFmt
     C                   PARM                    VPAYScnFmt
     C                   PARM                    MRECScnFmt
     C                   PARM                    MPAYScnFmt
     C                   PARM                    PInfData
 
      ** Define key list for our rate
 
     C     KDTSCPrUR     KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUR
     C                   KFLD                    WRCIPUR
     C                   KFLD                    WPRDTUR
 
     C     KDTSCUR       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUR
     C                   KFLD                    WRCIPUR
 
      ** Define key list for our interest payment
 
     C     KDTSCPrUI     KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUI
     C                   KFLD                    WRCIPUI
     C                   KFLD                    WPRDTUI
 
     C     KDTSCUI       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUI
     C                   KFLD                    WRCIPUI
 
      ** Define key list for their rate
 
     C     KDTSCPrTR     KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTR
     C                   KFLD                    WRCIPTR
     C                   KFLD                    WPRDTTR
 
     C     KDTSCTR       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTR
     C                   KFLD                    WRCIPTR
 
      ** Define key list for our interest payment
 
     C     KDTSCPrTI     KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTI
     C                   KFLD                    WRCIPTI
     C                   KFLD                    WPRDTTI
 
     C     KDTSCTI       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTI
     C                   KFLD                    WRCIPTI
 
      ** Define key list for our cash flow
 
     C     KCFSCUC       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUC
 
      ** Define key list for their cash flow
 
     C     KCFSCTC       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTC
 
      ** Define key list for our principal change
 
     C     KPCSCUP       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINUP
 
      ** Define key list for their principal change
 
     C     KPCSCTP       KLIST
     C                   KFLD                    WDLNO
     C                   KFLD                    WOTINTP
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD  <> *BLANKS
     C                   EVAL      RetCodeIn = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access currency details to get the number of decimal places using the
      ** received parameter (Ours)
 
     C                   IF        POurCCY <> *BLANK
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      POurCCY       PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      RetCodeIn = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        WOurNBDP
     C                   ENDIF
     C                   ENDIF
 
      ** Access currency details to get the number of decimal places using the
      ** received parameter (Theirs)
 
     C                   IF        PThrCCY <> *BLANK
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PThrCCY       PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      RetCodeIn = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCURR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        WThrNBDP
     C                   ENDIF
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
