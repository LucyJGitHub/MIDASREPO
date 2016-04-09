     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Customer Income Report Prompt')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7604P - Customer Income Report Prompt                      *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user  selection input of Customer Income      *
      *             Report                                            *
      *                                                               *
      *  Component of: SE7604 Customer Income Report                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer Income Report display file.
     FSE7604DF  CF   E             WORKSTN
      *
      ** Beneficial owners details file.
     FSDBNFOL2  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-60     Field Error - highlight screen fields              *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *                                                               *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Country code details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Externally described
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Externally described DS for Securities Trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Output DS
     D POutFlds        DS            49
     D  PFDAT                  1      6A
     D  PTDAT                  7     12A
     D  PCTAX                 13     14A
     D  PETYP                 15     16A
     D  PCNUM                 17     22A
     D  PBOWN                 23     48A
     D  PCDOC                 49     49A
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PINKC           S              1A
      *
      ** Work Fields
     D WFDat           S              5P 0
     D WTDat           S              5P 0
     D WScrn           S              1A
     D PReDsp          S              1A
      *
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
      *
      ** Parameters for ZDATE1
     D PDate           S              6A
     D PDaynoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Retention variables
     D WK3N            S              3P 0
     D WK3NX           S              3P 0
     D WRetDat         S              5P 0
      *
      ** Parameters for module AOCTRYR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARd           S              6A
      *
      ** Parameters for module AOCUSTR1
     D PCust           S             10A
     D PCnCd           S              2A
     D PKyst           S              7A
      *
     D WBCust          S              6A
     D WCnum           S              6A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAction         S              1A
     D PCmd            S              1A
      *
      ** Switchable features
     D CSE007          S              1A
     D CEU017          S              1A
     D S01496          S              1A
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
      ** Initialise.
      *
     C                   EXSR      SRInit
      *
      ** Process inputs.
      *
     C                   EXSR      SRProc
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
      *
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
      *
      ** Do while SCREEN : Read details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        PINKC = *ON
     C                   EVAL      PCmd = 'E'
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
     C                   ENDIF
     C                   ENDDO
      *
      ** Do file update.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   POutFlds
     C                   CLEAR                   SFDAT
     C                   CLEAR                   STDAT
     C                   CLEAR                   SCTAX
     C                   CLEAR                   SETYP
     C                   CLEAR                   SCUST
     C                   CLEAR                   SBOWN
     C                   CLEAR                   SCDOC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
      *
      ** Validate details entered.
      *
     C                   EXSR      SRValFDat
     C                   EXSR      SRValTDat
     C                   EXSR      SRValCTax
     C                   EXSR      SRValETyp
     C                   EXSR      SRValCust
     C                   EXSR      SRValBOwn
     C                   EXSR      SRValCDoc
      *
      ** If no errors, update output parameter field.
      *
     C                   IF        *IN10 = *OFF AND *IN11= *OFF AND
     C                             *IN12 = *OFF AND *IN13= *OFF AND
     C                             *IN14 = *OFF AND *IN15= *OFF AND
     C                             *IN16 = *OFF AND PReDsp <> 'Y'
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update output parameter fields                    *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      PFDAT = SFDAT
     C                   EVAL      PTDAT = STDAT
     C                   EVAL      PCTAX = SCTAX
     C                   EVAL      PETYP = SETYP
     C                   EVAL      PCNUM = WCNum
     C                   EVAL      PBOWN = SBOWN
     C                   EVAL      PCDOC = SCDOC
 
     C                   EVAL      WScrn = 'E'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
      *
      ** Call screen message handler.
      *
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
      *
      ** Write message subfile, details and footer screens.
      *
     C                   TIME                    STIME
     C                   WRITE     SE7604C1
     C**********         WRITE     SE7604D1                                                 AR656294
     C                   WRITE     SE7604F1
     C                   WRITE     SE7604D1                                                 AR656294
      *
      ** Read details screen.
      *
     C                   READ      SE7604D1                               01
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000000'     *IN(10)
     C                   EVAL      PReDsp = 'N'
      *
      ** Set return keys.
      *
     C                   EVAL      PINKC = *INKC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFDat - Validate From Date field                         *
      *                                                               *
      *****************************************************************
     C     SRValFDat     BEGSR
      *
      ** Must be numeric.
      *
     C                   TESTN                   SFDAT                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN10 = *ON
     C                   MOVEL     'SEA0400'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValFDat
     C                   ENDIF
      *
      ** Check if valid date.
      *
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      SFDAT         PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN10 = *ON
     C                   MOVEL     'SEA0400'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValFDat
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     WFDat
     C                   Z-ADD     *ZERO         WK3N
     C                   EVAL      WK3NX = 31 * 18
      *
      ** Calculate retention date.
      *
     C                   IF        S01496 = 'Y' OR
     C                             CSE007 = 'Y' OR
     C                             CEU017 = 'Y'
     C                   EVAL      WK3N = 31 * BVROPS
     C                   ELSE
     C                   EVAL      WK3N = 31 * BVROST
     C                   ENDIF
      *
     C                   IF        WK3N < WK3NX
     C                   EVAL      WK3N = WK3NX
     C                   ENDIF
 
     C                   EVAL      WRetDat = BJRDNB - WK3N
      *
      ** Error if From Date is less than Retention date.
      *
     C                   IF        WFDAT < WRetDat
     C                   EVAL      *IN10 = *ON
     C                   MOVEL     'SEA0401'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C     EValFDat      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTDat - Validate To Date field                           *
      *                                                               *
      *****************************************************************
     C     SRValTDat     BEGSR
      *
      ** Must be numeric.
      *
     C                   TESTN                   STDAT                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   MOVEL     'SEA0402'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValTDat
     C                   ENDIF
      *
      ** Must be a valid date.
      *
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      STDAT         PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   MOVEL     'SEA0402'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValTDat
     C                   ENDIF
 
     C                   Z-ADD     PDaynoOut     WTDat
      *
      ** Error if From Date is greater than To Date.
      *
     C                   IF        WFDAT > WTDAT
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN11 = *ON
     C                   MOVEL     'SEA0403'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C     EValTDat      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCTax - Validate Country of Tax Treaty                   *
      *                                                               *
      *****************************************************************
     C     SRValCTax     BEGSR
      *
      ** Scan for question mark selection.
      *
     C     '?'           SCAN      SCTAX                                  01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Check if valid country code.
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SCTAX         PCnCd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
 
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      SCTAX = *BLANKS
     C                   ELSE
     C                   EVAL      *IN12 = *ON
     C                   MOVEL     'SEA0404'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      SCTAX = A4CNCD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValETyp - Validate Event Type                              *
      *                                                               *
      *****************************************************************
     C     SRValETyp     BEGSR
      *
      ** If entered, event type must only be 'CP' or 'DV'.
      *
     C                   IF        SETYP <> *BLANKS AND
     C                             SETYP <> 'CP' AND
     C                             SETYP <> 'DV'
     C                   EVAL      *IN13 = *ON
     C                   MOVEL     'SEA0405'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCust - Validate Customer Number                         *
      *                                                               *
      *****************************************************************
     C     SRValCust     BEGSR
      *
      ** Validate if not equal to blanks.
      *
     C                   EVAL      WCNum = *BLANKS
 
     C                   IF        SCUST <> *BLANKS
      *
      ** Scan for question mark selection.
     C     '?'           SCAN      SCUST                                  01
     C                   IF        *IN01 = *ON
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** Check if customer is a valid customer.
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SCUST         PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtcd = *BLANKS
      *
      ** If question mark used, display selected customer number.
     C                   IF        *IN01 = *ON
     C                   EVAL      SCUST = BBCUST
     C                   ENDIF
      *
      ** Check if Securities customer with classification class
      ** of 'S' or 'D'.
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    BBCUST
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   ENDIF
 
     C                   IF        PRtcd  <> *BLANKS OR
     C                             (BFCLAS <> 'D' AND
     C                             BFCLAS <> 'S')
 
     C                   IF        PRtCd = '*NOSEL '
     C                   EVAL      SCUST = *BLANKS
     C                   ELSE
     C                   EVAL      *IN14 = *ON
     C                   MOVEL     'SEA0406'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WCNum = BBCUST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValBOwn - Validate Beneficial Owner                        *
      *                                                               *
      *****************************************************************
     C     SRValBOwn     BEGSR
      *
      ** Validate if not equal to blanks.
      *
     C                   IF        SBOWN <> *BLANKS
      *
      ** Error if customer is blank.
     C                   IF        SCUST = *BLANKS
     C                   EVAL      *IN15 = *ON
     C                   MOVEL     'SEA0407'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValBOwn
     C                   ENDIF
      *
      ** Check if numeric.
     C                   TESTN                   SBOWN                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN15 = *ON
     C                   MOVEL     'SEA0408'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValBOwn
     C                   ENDIF
      *
      ** If valid customer number entered, check if beneficiary
      ** owner has its first 6 digits equal to customer number.
     C                   MOVEL     SBOWN         WBCust
     C                   IF        WBCust <> WCNum AND
     C                             *IN14 = *OFF
     C                   EVAL      *IN15 = *ON
     C                   MOVEL     'SEA0408'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValBOwn
     C                   ENDIF
      *
      ** Check if value exists in Beneficiary Owner file.
     C     KBOWN         CHAIN     SDBNFOL2                           01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      *IN15 = *ON
     C                   MOVEL     'SEA0409'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValBOwn
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValBOwn      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCDoc - Validate Customer Documentation Received         *
      *              Status                                           *
      *                                                               *
      *****************************************************************
     C     SRValCDoc     BEGSR
      *
      ** Validate if not equal to blanks.
      *
     C                   IF        SCDOC <> *BLANKS
      *
      ** Error if Beneficial Owner and Customer Number are entered.
     C                   IF        SBOWN <> *BLANKS OR
     C                             SCUST <> *BLANKS
     C                   EVAL      *IN16 = *ON
     C                   MOVEL     'SEA0410'     PMsgId
     C                   EXSR      SRSndM
     C                   GOTO      EValCDoc
     C                   ENDIF
      *
      ** If entered, must be 'Y', 'N' 'D', 'U', 'C', 'I' or 'E'.
     C                   IF        SCDOC <> 'Y' AND
     C                             SCDOC <> 'N' AND
     C                             SCDOC <> 'D' AND
     C                             SCDOC <> 'U' AND
     C                             SCDOC <> 'C' AND
     C                             SCDOC <> 'I' AND
     C                             SCDOC <> 'E'
     C                   EVAL      *IN16 = *ON
     C                   MOVEL     'SEA0411'     PMsgId
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValCDoc      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAction
     C                   PARM                    PCmd
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   Z-ADD     2             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE007 (Corporate
      ** Actions) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      'CSE007'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE007'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE007 = 'Y'
     C                   ELSE
     C                   EVAL      CSE007 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU017 (EMU Securities
      ** Redomination) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CEU017'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     4             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CEU017 = 'Y'
     C                   ELSE
     C                   EVAL      CEU017 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01496 (PB Securities
      ** Trading Enhancements) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01496'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01496'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     5             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      S01496 = 'Y'
     C                   ELSE
     C                   EVAL      S01496 = 'N'
     C                   ENDIF
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'SEUSRMSG'
      *
      ** Define key list for Beneficiary Owners file
     C     KBOwn         KLIST
     C                   KFLD                    WCNum
     C                   KFLD                    SCTAX
     C                   KFLD                    SBOWN
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVE      *ON           *IN25
     C                   MOVEL     '*'           SPGM
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
(c) Misys International Banking Systems Ltd. 2001
