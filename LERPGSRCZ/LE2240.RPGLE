     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Settlement Allocations Batch Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2240 - Settlement Allocations Batch Update                 *
      *                                                               *
      *  Function: This module will process the settlement allocation *
      *            messages in batch.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE038             Date 11May04               *
      *                 219608             Date 14Jul03               *
      *                 CLE034  *CREATE    Date 05May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *  219608 - Amendment of Settlement Allocations needs a 'Before'*
      *           image to ensure the right allocations are reversed. *
      *  CLE034 - Lending Enhancements.                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInsert   - Insert a record                                 *
      *  SRUpdate   - Update record                                   *
      *  SRSetKey   - Set key list for Settlement Allocation file     *
      *  SRWriteLog - Write transaction to Log file                   *
      *  SRMoveVal  - Move non-key message fields to file fields      *
      *               (valid)                                         *
      *  SRMoveInv  - Move message fields to file fields (invalid)    *
      *  SRMoveOut  - Move input message to output (return) message   *
      *               format                                          *
      *  SRFmtAmt   - Format amount/percentage fields                 *
      *  SRGenTMST  - Generate timestamp                              *
      *  SRSndMsg   - Sends messages to the program's message queue   *
      *                                                               *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLESTALL2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Settlement Allocation by Transact and Seq
 
     FLEISTLPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Settlement Allocation Input Invalid Data
 
     FAPVLOGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Valid Log File from Support Database
 
     FAPILOGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** API Invalid Log File from Support Database
                                                                                              219608
     FLEBSTLPD  O    E             DISK    INFSR(*PSSR) USROPN                                219608
     F                                     RENAME(LESTALD0:LEBSTLD0)                          219608
      ** Before Image of Settlement Allocations                                               219608
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ConstTMST       C                   CONST('0001-01-01-00.00.00.000000')
     D WConst1         C                   'Settlement09Postings'                             CLE038
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** PC Msg Fmt Settlement Allocations Xmit
     D PIMsgFmt      E DS                  EXTNAME(LESA1MPD)
 
      ** PC Msg Fmt Settlement Allocations Return
     D POMsgFmt      E DS                  EXTNAME(LESA2MPD)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** SDSTAT data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Currencies details                                                            CLE038
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CLE038
                                                                                              CLE038
      ** DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CLE038
      ** DS for access programs (long)                                                        CLE038
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CLE038
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PErrFlag        S              1
     D PInField        S             16
     D SAVFIELD        S             16                                                       CLE038
     D PDecimal        S              1  0
     D PDigits         S              2  0
     D PMsgID          S              7
     D PMsgFile        S             10
     D PMsgData        S            132
     D PMsgText        S            132
     D PRepNum         S              5  0
     D PDateIn         S              6
     D PDateOut        S              5  0
     D PMode           S              1
     D PTimestamp      S             26Z
     D PSysValK1       S             20A                                                      CLE038
     D PSysVal1        S            200A                                                      CLE038
     D PSysValK2       S             20A                                                      CLE038
     D PSysVal2        S            200A                                                      CLE038
     D PSysValK3       S             20A                                                      CLE038
     D PSysVal3        S            200A                                                      CLE038
     D PSysValK4       S             20A                                                      CLE038
     D PSysVal4        S            200A                                                      CLE038
     D PSysValK5       S             20A                                                      CLE038
     D PSysVal5        S            200A                                                      CLE038
     D PSysValK6       S             20A                                                      CLE038
     D PSysVal6        S            200A                                                      CLE038
     D PSysValK7       S             20A                                                      CLE038
     D PSysVal7        S            200A                                                      CLE038
     D PSysValK8       S             20A                                                      CLE038
     D PSysVal8        S            200A                                                      CLE038
     D PSysValK9       S             20A                                                      CLE038
     D PSysVal9        S            200A                                                      CLE038
     D PSysValK10      S             20A                                                      CLE038
     D PSysVal10       S            200A                                                      CLE038
 
      ** Work Variables
     D WRun            S              1
     D WLogValid       S              1
     D WError          S              1
     D WkTwo           S              2
     D WrkTMST         S             26Z
 
      ** Key Fields
     D KTYPE           S              4
     D KTMST           S             26Z
     D*KLNRF****       S              6  0                                                    CLE148
     D KLNRF           S              6                                                       CLE148
     D KVDAT           S              5  0
     D KLASQ           S              3  0
     D*KCNUM****       S              6  0                                                    CSD027
     D KCNUM           S              6                                                       CSD027
     D KFACL           S              5  0
     D KFESQ           S              2  0
     D KSEQ            S              5  0
 
      ** Switchable Features
     D CSC011          S              1
     D CLE038          S              1                                                       CLE038
     D CLE033          S              1                                                       CLE038
     D WSetl09Ccy      S              1A                                                      CLE038
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      ** Insert record
 
     C     *ISO          MOVE      PTempTMST     PTimestamp
     C                   IF        SA1ACT = 'I'
     C                   EXSR      SRInsert
     C                   ENDIF
 
      ** Amend/Delete record
 
     C                   IF        SA1ACT = 'A'  OR  SA1ACT = 'D'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   EXSR      SRMoveOut
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert a record                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInsert      BEGSR
 
     C                   IF        PTimestamp <> WrkTMST
     C                   EXSR      SRSetKey
 
      ** Get settlement allocation record with highest sequence number
 
     C     K2STAL        SETGT     LESTALL2
     C     K2STAL        READPE(N) LESTALL2
 
     C                   IF        NOT %EOF(LESTALL2)
     C                   EVAL      SEQ = SEQ + 1
     C                   EVAL      SA1SEQ = SEQ + 1
 
     C                   ELSE
 
      ** Generate timestamp
 
     C                   EVAL      SEQ = 1
     C                   EVAL      SA1SEQ = 1
     C                   EVAL      TMST = PTimestamp
     C                   EVAL      SA1TMS = PTimestamp
     C                   ENDIF
 
     C                   ELSE
 
      ** Generate timestamp
 
     C                   EXSR      SRGenTMST
     C                   ENDIF
 
     C                   EXSR      SRMoveVal
     C                   WRITE     LESTALD0
 
     C                   IF        CSC011 = 'Y'  AND  S1SUPP = LIBR
     C                   EVAL      WLogValid = 'V'
     C                   EXSR      SRWriteLog
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update record                                     *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   EXSR      SRSetKey
 
     C     K1STAL        CHAIN     LESTALL2
 
      ** Error if record to be updated is not found
 
     C                   IF        NOT %FOUND(LESTALL2)
     C                   EVAL      WError = 'E'
     C                   EVAL      PMsgID = 'LEA1105'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
      * Save 'before' image of allocation:                                                    219608
     C                   OPEN      LEBSTLPD                                                   219608
     C                   WRITE     LEBSTLD0                                                   219608
     C                   CLOSE     LEBSTLPD                                                   219608
 
     C                   SELECT
     C                   WHEN      SA1ACT = 'D'
     C                   EVAL      RECI = 'R'
 
     C                   WHEN      SA1ACT = 'A'
     C                   EXSR      SRMoveVal
     C                   ENDSL
 
      ** Update settlement allocation record
 
     C                   UPDATE    LESTALD0
 
     C                   IF        CSC011 = 'Y'  AND  S1SUPP = LIBR
     C                   EVAL      WLogValid = 'V'
     C                   EXSR      SRWriteLog
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetKey - Set key list for Settlement Allocation file       *
      *                                                               *
      *****************************************************************
 
     C     SRSetKey      BEGSR
 
     C                   EVAL      KTYPE = SA1TYP
     C                   IF        SA1ACT = 'I'
     C                   EVAL      KTMST = PTimestamp
     C                   ELSE
     C                   EVAL      KTMST = SA1TMS
     C                   ENDIF
     C                   EVAL      KLNRF = SA1LNR
     C                   EVAL      KLASQ = SA1LAS
     C                   EVAL      KCNUM = SA1CNM
     C                   EVAL      KFACL = SA1FAC
     C                   EVAL      KFESQ = SA1FSQ
     C                   EVAL      KSEQ = SA1SEQ
 
      ** Format Value Date
 
     C                   MOVEL     SA1VDT        PDateIn
     C                   MOVE      SA1VDT        WkTwo
     C                   MOVE      WkTwo         PDateIn
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM      *ZERO         PDateOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrFlag
 
     C                   EVAL      KVDAT = PDateOut
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteLog - Write transaction to Log files                  *
      *                                                               *
      *****************************************************************
 
     C     SRWriteLog    BEGSR
 
     C                   MOVEL     PIMsgFmt      APTRAN
     C                   EVAL      APSTMS = PTimestamp
     C                   EVAL      APMTYP = 'LE' + 'STAL'
     C                   EVAL      APSOFC = PCRF
 
     C                   IF        WLogValid = 'V'
     C                   WRITE     APVLOGD0
     C                   ELSE
     C                   WRITE     APILOGD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveVal - Move non-key message fields to file fields       *
      *              (valid)                                          *
      *                                                               *
      *****************************************************************
 
     C     SRMoveVal     BEGSR
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      TYPE = SA1TYP
     C                   EVAL      LNRF = SA1LNR
     C                   EVAL      LASQ = SA1LAS
     C                   EVAL      CNUM = SA1CNM
     C                   EVAL      FACL = SA1FAC
     C                   EVAL      FESQ = SA1FSQ
     C                   EVAL      PCRF = SA1PCR
     C                   EVAL      RSTM = SA1RSM
     C                   MOVE      SA1RNS        RONS
     C                   EVAL      RIBN = SA1RIB
     C                   EVAL      RIBA = SA1RBA
     C                   EVAL      ROBN = SA1ROB
     C                   EVAL      ROCN = SA1ROC
     C                   EVAL      ROBR = SA1RNS
     C                   EVAL      RSCY = SA1RSC
     C                   EVAL      REXI = SA1RXI
     C                   IF        SA1RXI = 'N'
     C                   EVAL      REXI = *BLANKS
     C                   ENDIF
     C                   EVAL      PSTM = SA1PSM
     C                   MOVE      SA1PNS        PONS
     C                   EVAL      PIBN = SA1PIB
     C                   EVAL      PIBA = SA1PBA
     C                   EVAL      POBN = SA1POB
     C                   EVAL      POCN = SA1POC
     C                   EVAL      RCRN = SA1RCR
     C                   EVAL      RCRA = SA1RCA
     C                   EVAL      RVNO = SA1RVN
     C                   EVAL      AWBN = SA1AWB
     C                   EVAL      AWBA = SA1ABA
     C                   EVAL      BENN = SA1BEN
     C                   EVAL      BENA = SA1BNA
     C                   EVAL      DTP1 = SA1DP1
     C                   EVAL      DTP2 = SA1DP2
     C                   EVAL      DTP3 = SA1DP3
     C                   EVAL      DTP4 = SA1DP4
     C                   EVAL      DCHG = SA1DCH
     C                   EVAL      BTB1 = SA1BB1
     C                   EVAL      BTB2 = SA1BB2
     C                   EVAL      BTB3 = SA1BB3
     C                   EVAL      BTB4 = SA1BB4
     C                   EVAL      BTB5 = SA1BB5
     C                   EVAL      BTB6 = SA1BB6
     C                   EVAL      POBR = SA1PNS
     C                   EVAL      CVMR = SA1CMR
     C                   EVAL      PSCY = SA1PSC
     C                   EVAL      IC72 = SA1C72
     C                   EVAL      PEXI = SA1PXI
     C                   IF        SA1PXI = 'N'
     C                   EVAL      PEXI = *BLANKS
     C                   ENDIF
     C                   EVAL      PTRF = SA1PTF
 
      ** Format Value Date
 
     C                   MOVEL     SA1VDT        PDateIn
     C                   MOVE      SA1VDT        WkTwo
     C                   MOVE      WkTwo         PDateIn
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM      *ZERO         PDateOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrFlag
 
     C                   EVAL      VDAT = PDateOut
 
      ** Receive Percentage
 
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1RPC
     C                   EVAL      PDecimal = 9
     C                   EVAL      PDigits  = 4
     C                   EXSR      SRFmtAmt
     C                   MOVE      PInField      RCPC
 
      ** Receive - Currency Exchange Rate
 
     C                   IF        SA1RXR <> *BLANKS
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1RXR
     C                   EVAL      PDecimal = 8
     C                   EVAL      PDigits  = 5
     C                   EXSR      SRFmtAmt
     C                   IF        PErrFlag  = 'N'
     C                             OR PInField = *ZEROS
     C                   MOVE      *BLANKS       REXR
     C                   ELSE
     C                   MOVE      PInField      REXR
     C                   ENDIF
     C                   ENDIF
 
      ** Pay Percentage
 
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1PPC
     C                   EVAL      PDecimal = 9
     C                   EVAL      PDigits  = 4
     C                   EXSR      SRFmtAmt
     C                   MOVE      PInField      PYPC
 
      ** Pay - Currency Exchange Rate
 
     C                   IF        SA1PXR <> *BLANKS
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1PXR
     C                   EVAL      PDecimal = 8
     C                   EVAL      PDigits  = 5
     C                   EXSR      SRFmtAmt
     C                   IF        PErrFlag  = 'N'
     C                             OR PInField = *ZEROS
     C                   MOVE      *BLANKS       PEXR
     C                   ELSE
     C                   MOVE      PInField      PEXR
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE038
     C                   EVAL      CCY = SA1CCY                                               CLE038
     C                   EVAL      RCBA = SA1BAR                                              CLE038
     C                   EVAL      PYBA = SA1BAP                                              CLE038
     C                   IF        RCBA = *BLANKS                                             CLE038
     C                   MOVEL     'P'           RCBA                                         CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        PYBA = *BLANKS                                             CLE038
     C                   MOVEL     'P'           PYBA                                         CLE038
     C                   ENDIF                                                                CLE038
     C                   IF        CLE038 = 'Y'                                               CLE038
                                                                                              CLE038
      ** Access Receive Currency Details                                                      CLE038
                                                                                              CLE038
     C                   EVAL      PCurr = RSCY                                               CLE038
     C                   IF        PCurr = *BLANKS                                            CLE038
     C                             OR PCurr <> *BLANKS AND CLE033 = 'Y'                       CLE038
     C                             AND RSTM = '09' AND WSetl09CCY = 'T'                       CLE038
     C                   EVAL      PCurr = CCY                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   CALL      'AOCURRR0'                                                 CLE038
     C                   PARM      *BLANKS       PRTCD                                        CLE038
     C                   PARM      '*KEY  '      POPTN                                        CLE038
     C                   PARM                    PCURR             3                          CLE038
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE038
                                                                                              CLE038
     C                   IF        PRTCD <> *BLANKS                                           CLE038
     C     *LOCK         IN        LDA                                                        CLE038
     C                   EVAL      DBFILE = 'SDCURRPD'                                        CLE038
     C                   EVAL      DBKEY  = RSCY                                              CLE038
     C                   EVAL      DBASE  = 6                                                 CLE038
     C                   OUT       LDA                                                        CLE038
     C                   EXSR      *PSSR                                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1RAM                                          CLE038
     C                   EVAL      PDecimal = A6NBDP                                          CLE038
     C                   EVAL      PDigits  = 13 - A6NBDP                                     CLE038
     C                   EXSR      SRFmtAmt                                                   CLE038
     C                   MOVE      PInField      RCAM                                         CLE038
                                                                                              CLE038
      ** Access Pay Currency Details                                                          CLE038
                                                                                              CLE038
     C                   EVAL      PCurr = PSCY                                               CLE038
     C                   IF        PCurr = *BLANKS                                            CLE038
     C                             OR PCurr <> *BLANKS AND CLE033 = 'Y'                       CLE038
     C                             AND PSTM = '09' AND WSetl09CCY = 'T'                       CLE038
     C                   EVAL      PCurr = CCY                                                CLE038
     C                   ENDIF                                                                CLE038
     C                   CALL      'AOCURRR0'                                                 CLE038
     C                   PARM      *BLANKS       PRTCD                                        CLE038
     C                   PARM      '*KEY  '      POPTN                                        CLE038
     C                   PARM                    PCURR             3                          CLE038
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE038
                                                                                              CLE038
     C                   IF        PRTCD <> *BLANKS                                           CLE038
     C     *LOCK         IN        LDA                                                        CLE038
     C                   EVAL      DBFILE = 'SDCURRPD'                                        CLE038
     C                   EVAL      DBKEY  = PSCY                                              CLE038
     C                   EVAL      DBASE  = 7                                                 CLE038
     C                   OUT       LDA                                                        CLE038
     C                   EXSR      *PSSR                                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   EVAL      PInField = *BLANKS                                         CLE038
     C                   EVAL      PInField = SA1PAM                                          CLE038
     C                   EVAL      PDecimal = A6NBDP                                          CLE038
     C                   EVAL      PDigits  = 13 - A6NBDP                                     CLE038
     C                   EXSR      SRFmtAmt                                                   CLE038
     C                   MOVE      PInField      PYAM                                         CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveInv - Move message fields to file fields (invalid)     *
      *                                                               *
      *****************************************************************
 
     C     SRMoveInv     BEGSR
 
     C                   EVAL      XREPN = PRepNum
     C                   EVAL      XMSID = PMsgID
     C                   EVAL      ITYPE = SA1TYP
     C                   EVAL      ITMST = SA1TMS
     C                   EVAL      IPCRF = SA1PCR
     C                   EVAL      ILNRF = SA1LNR
     C                   EVAL      IVDAT = SA1VDT
     C                   EVAL      ILASQ = SA1LAS
     C                   EVAL      ICNUM = SA1CNM
     C                   EVAL      IFACL = SA1FAC
     C                   EVAL      IFESQ = SA1FSQ
     C                   EVAL      ISEQ  = SA1SEQ
     C                   EVAL      IRCPC = SA1RPC
     C                   EVAL      IRSTM = SA1RSM
     C                   EVAL      IRONS = SA1RNS
     C                   EVAL      IRIBN = SA1RIB
     C                   EVAL      IRIBA = SA1RBA
     C                   EVAL      IROBN = SA1ROB
     C                   EVAL      IROCN = SA1ROC
     C                   EVAL      IRSCY = SA1RSC
     C                   EVAL      IREXR = SA1RXR
     C                   EVAL      IREXI = SA1RXI
     C                   EVAL      IPYPC = SA1PPC
     C                   EVAL      IPSTM = SA1PSM
     C                   EVAL      IPONS = SA1PNS
     C                   EVAL      IPIBN = SA1PIB
     C                   EVAL      IPIBA = SA1PBA
     C                   EVAL      IPOBN = SA1POB
     C                   EVAL      IPOCN = SA1POC
     C                   EVAL      IRCRN = SA1RCR
     C                   EVAL      IRCRA = SA1RCA
     C                   EVAL      IRVNO = SA1RVN
     C                   EVAL      IAWBN = SA1AWB
     C                   EVAL      IAWBA = SA1ABA
     C                   EVAL      IBENN = SA1BEN
     C                   EVAL      IBENA = SA1BNA
     C                   EVAL      IDTP1 = SA1DP1
     C                   EVAL      IDTP2 = SA1DP2
     C                   EVAL      IDTP3 = SA1DP3
     C                   EVAL      IDTP4 = SA1DP4
     C                   EVAL      IDCHG = SA1DCH
     C                   EVAL      IBTB1 = SA1BB1
     C                   EVAL      IBTB2 = SA1BB2
     C                   EVAL      IBTB3 = SA1BB3
     C                   EVAL      IBTB4 = SA1BB4
     C                   EVAL      IBTB5 = SA1BB5
     C                   EVAL      IBTB6 = SA1BB6
     C                   EVAL      ICVMR = SA1CMR
     C                   EVAL      IPSCY = SA1PSC
     C                   EVAL      IIC72 = SA1C72
     C                   EVAL      IPEXR = SA1PXR
     C                   EVAL      IPEXI = SA1PXI
     C                   EVAL      IPTRF = SA1PTF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveOut - Move input message to output (return) message fmt*
      *                                                               *
      *****************************************************************
 
     C     SRMoveOut     BEGSR
 
     C                   EVAL      SA2MST = SA1MST
     C                   EVAL      SA2TUS = SA1TUS
     C                   EVAL      SA2TWS = SA1TWS
     C                   EVAL      SA2TRF = SA1TRF
     C                   EVAL      SA2TSN = SA1TSN
     C                   EVAL      SA2ACT = SA1ACT
     C                   EVAL      SA2TDS = SA1TDS
     C                   EVAL      SA2TTS = SA1TTS
     C                   EVAL      SA2NRB = SA1NRB
     C                   EVAL      SA2FL4 = *BLANKS
     C                   EVAL      SA2MGS = WError
     C                   EVAL      SA2MSI = PMsgID
     C                   EVAL      SA2MTX = PMsgText
     C                   EVAL      SA2TYP = SA1TYP
     C                   IF        SA1ACT <> 'I'
     C                   EVAL      SA2TMS = SA1TMS
     C                   ENDIF
     C                   EVAL      SA2LNR = SA1LNR
     C                   EVAL      SA2VDT = VDAT
     C                   EVAL      SA2LAS = SA1LAS
     C                   EVAL      SA2CNM = SA1CNM
     C                   EVAL      SA2FAC = SA1FAC
     C                   EVAL      SA2FSQ = SA1FSQ
     C                   EVAL      SA2SEQ = SA1SEQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenTMST - Generate timestamp                               *
      *                                                               *
      *****************************************************************
 
     C     SRGenTMST     BEGSR
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
 
     C                   EVAL      SEQ = 1
     C                   EVAL      SA1SEQ = 1
     C                   EVAL      TMST = PTimestamp
     C                   EVAL      SA1TMS = PTimestamp
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount/percentage fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
 
     C                   EVAL      SAVFIELD = PInField                                        CLE038
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PErrFlag
     C                   PARM                    PInField
     C                   PARM                    PDecimal
     C                   PARM                    PDigits
     C     SAVFIELD      IFNE      *BLANKS                                                    CLE038
     C     PInField      ANDEQ     *BLANKS                                                    CLE038
     C                   EVAL      PErrFlag = 'Y'                                             CLE038
     C                   ENDIF                                                                CLE038
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Sends messages to the program's message queue     *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
     C                   DUMP
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PMsgID            7
     C                   PARM                    PMsgFile         10
     C                   PARM                    PMsgData        132
     C                   PARM                    PMsgText        132
 
     C                   IF        WError = 'E'
     C                   IF        SA1RLC = 'B'
 
     C                   CALL      'LEC0215'
     C                   PARM                    PRepNum           5 0
 
     C                   EXSR      SRMoveInv
     C                   WRITE     LEISTLD0
 
     C                   IF        CSC011 = 'Y'  AND  S1SUPP = LIBR
     C                   EVAL      WLogValid = 'I'
     C                   EXSR      SRWriteLog
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRMoveOut
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PIMsgFmt
     C                   PARM                    POMsgFmt
     C                   PARM                    PTempTMST        26
 
      ** Set message file to be used
 
     C                   EVAL      PMsgFile = 'LERMSGF'
     C     *ISO          MOVE      ConstTMST     WrkTMST
     C     *ISO          MOVE      PTempTMST     PTimestamp
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
                                                                                              CLE038
      ** Check if CLE038 is installed                                                         CLE038
                                                                                              CLE038
     C                   CALL      'AOSARDR0'                                                 CLE038
     C                   PARM      *BLANKS       PRTCD                                        CLE038
     C                   PARM      '*VERIFY'     POPTN                                        CLE038
     C                   PARM      'CLE038'      PSARD                                        CLE038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE038
                                                                                              CLE038
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE038
     C     *LOCK         IN        LDA                                                        CLE038
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE038
     C                   EVAL      DBKEY  = 'CLE038'                                          CLE038
     C                   EVAL      DBASE  = 3                                                 CLE038
     C                   OUT       LDA                                                        CLE038
     C                   EXSR      *PSSR                                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   IF        PRTCD = *BLANKS                                            CLE038
     C                   EVAL      CLE038 = 'Y'                                               CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      CLE038 = 'N'                                               CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
      ** If CLE038 is on                                                                      CLE038
                                                                                              CLE038
     C                   IF        CLE038 = 'Y'                                               CLE038
                                                                                              CLE038
      ** Check if CLE033 is installed                                                         CLE038
                                                                                              CLE038
     C                   CALL      'AOSARDR0'                                                 CLE038
     C                   PARM      *BLANKS       PRTCD                                        CLE038
     C                   PARM      '*VERIFY'     POPTN                                        CLE038
     C                   PARM      'CLE033'      PSARD                                        CLE038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE038
                                                                                              CLE038
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE038
     C     *LOCK         IN        LDA                                                        CLE038
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE038
     C                   EVAL      DBKEY  = 'CLE033'                                          CLE038
     C                   EVAL      DBASE  = 4                                                 CLE038
     C                   OUT       LDA                                                        CLE038
     C                   EXSR      *PSSR                                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   IF        PRTCD = *BLANKS                                            CLE038
     C                   EVAL      CLE033 = 'Y'                                               CLE038
     C                   ELSE                                                                 CLE038
     C                   EVAL      CLE033 = 'N'                                               CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
      ** If CLE033 is on                                                                      CLE038
                                                                                              CLE038
     C                   IF        CLE033 = 'Y'                                               CLE038
                                                                                              CLE038
      ** Retrieve Settlement09Postings value - use settlement currency?                       CLE038
                                                                                              CLE038
     C                   EVAL      PSysValK1 = WConst1                                        CLE038
     C                   EXSR      SRAOSVAL                                                   CLE038
                                                                                              CLE038
     C                   IF        PRTCD = *BLANKS                                            CLE038
     C                   EVAL      WSetl09Ccy = PSysVal1                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDIF                                                                CLE038
     C                   ENDIF                                                                CLE038
 
      ** Key list for LESTALL2
 
     C     K1STAL        KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KTMST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASQ
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
     C                   KFLD                    KSEQ
 
      ** Key list for LESTALL2 (without sequence number)
 
     C     K2STAL        KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KTMST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASQ
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CLE038
      *****************************************************************                       CLE038
      *                                                               *                       CLE038
      *  SRAOSVAL - Access System Values                              *                       CLE038
      *                                                               *                       CLE038
      *****************************************************************                       CLE038
     C     SRAOSVAL      BEGSR                                                                CLE038
                                                                                              CLE038
      ** Access System Values                                                                 CLE038
                                                                                              CLE038
     C                   CALL      'AOSVALR0'                                                 CLE038
     C                   PARM      *BLANKS       PRTCD                                        CLE038
     C                   PARM                    PSysValK1                                    CLE038
     C                   PARM                    PSysVal1                                     CLE038
     C                   PARM                    PSysValK2                                    CLE038
     C                   PARM                    PSysVal2                                     CLE038
     C                   PARM                    PSysValK3                                    CLE038
     C                   PARM                    PSysVal3                                     CLE038
     C                   PARM                    PSysValK4                                    CLE038
     C                   PARM                    PSysVal4                                     CLE038
     C                   PARM                    PSysValK5                                    CLE038
     C                   PARM                    PSysVal5                                     CLE038
     C                   PARM                    PSysValK6                                    CLE038
     C                   PARM                    PSysVal6                                     CLE038
     C                   PARM                    PSysValK7                                    CLE038
     C                   PARM                    PSysVal7                                     CLE038
     C                   PARM                    PSysValK8                                    CLE038
     C                   PARM                    PSysVal8                                     CLE038
     C                   PARM                    PSysValK9                                    CLE038
     C                   PARM                    PSysVal9                                     CLE038
     C                   PARM                    PSysValK10                                   CLE038
     C                   PARM                    PSysVal10                                    CLE038
                                                                                              CLE038
     C                   IF        PRTCD <> *BLANKS                                           CLE038
     C     *LOCK         IN        LDA                                                        CLE038
     C                   EVAL      DBFILE =  'SDSVALJ0'                                       CLE038
     C                   EVAL      DBKEY  =  PSysValK1                                        CLE038
     C                   EVAL      DBASE  =  5                                                CLE038
     C                   OUT       LDA                                                        CLE038
     C                   EXSR      *PSSR                                                      CLE038
     C                   ENDIF                                                                CLE038
                                                                                              CLE038
     C                   ENDSR                                                                CLE038
      *****************************************************************                       CLE038
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   EVAL      WError = 'D'
     C                   EVAL      PMsgID = 'LEL0035'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
