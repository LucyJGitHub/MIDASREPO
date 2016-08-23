     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Customer Details')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0372R - Prompt for Withholding Tax Details Related Files.  *
      *                                                               *
      *  Function:  This module allows customer withholding tax       *
      *             details related functions to be edited.           *
      *                                                               *
      *  Component of: SD0372R                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGP001             Date 18Dec03               *
      *                 214914             Date 17Feb03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212166             Date 23Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186001             Date 08Nov00               *
      *                 186000             Date 08Nov00               *
      *                 185994             Date 08Nov00               *
      *                 186038             Date 07Nov00               *
      *                 186052             Date 30Oct00               *
      *                 186048             Date 30Oct00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGP001 - Global Processing (Recompile)                       *
      *  214914 - Call to AOCUSTR0 should not return *DBERR when      *
      *           customer flagged as requested for closure           *
      *  212166 - Call to AOCUSTR0 changed from CALLB to CALL to      *
      *           prevent DB error in Customer details maintenance.   *
      *  186001 - Withholding tax for User Holding                    *
      *  186000 - Tax Identification Number needs to be added to      *
      *           Customer Withholding Tax Details                    *
      *  185994 - Additional validation on documentation receive.     *
      *  186038 - Double tax treaty field should be mandatory if      *
      *           Documentation = 'Y', 'C' or 'L'                     *
      *  186052 - Double tax treaty field can be blank unless         *
      *           Documentation = 'Y'                                 *
      *  186048 - Tax basket should be mandatory if documetation = 'E'*
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    05         F5 key - refresh function available.            *
      *    09         F9 key - toggle between change/add mode.        *
      *                                                               *
      *    20-30      Field error indicators.                         *
      *    31         Error Indicator for Tax Identification Number   *                       186000
      *    80         Protect fields.                                 *
      *                                                               *
      *    81         Clear subfile page.                             *
      *                                                               *
      *    83         Record not found.                               *
      *    84         End of physical file reached.                   *
      *    85         End of sub-file reached.                        *
      *    87         Rollup/Rolldown key used.                       *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *InzSR - Initialise                                           *
      * *PsSR  - Error processing                                     *
      *                                                               *
      * SRBldBrw    - Build subfile page.                             *
      * SRReadRec   - Read record from file.                          *
      * SRFmtWit    - Format details for subfile.                     *
      * SRValUpdSfl - Check if valid option exist.                    *
      * SRClearErr  - Clear error arrays.                             *
      * SRValidate  - Validate subfile details.                       *
      * SRUpdDel    - Update file for record deletion.                *
      * SRUpdate    - Update file for record insert and amend.        *
      * SRFmtWitUpd - Format details for file update.                 *
      * SRAddMode   - Record insertion routine.                       *
      * SRClearSfl  - Clear subfile and error arrays.                 *
      * SRFmtDatI   - Format date for display.                        *
      * SRFmtDatO   - Format date for file update.                    *
      * SRSndMSg    - Send message to program message que.            *
      *                                                               *
      *    The *InzSR subroutine will only get called automatically   *
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
      ** Withholding Tax details screen display file.
     FSD0372RDF CF   E             WORKSTN
     F                                     SFILE(SD0372S0:W_Rrn)
     F                                     SFILE(SD0372S1:W_Rrn)
      *
      ** Withholding Tax Customer details by customer number and country tax
      ** treaty for file update.
     FSDWTCSL0  UF A E           K DISK    INFSR(*PsSR)
     F                                     COMMIT
     F                                     RENAME(SDWTCSD0:@WTCSL0)
      *
      ** Withholding Tax Customer details by customer number and country tax
      ** treaty live records for retrieve.
     FSDWTCSL1  IF   E           K DISK    INFSR(*PsSR)
     F                                     PREFIX(G1)
      *
      ** SD Standing Data Controls by filename for file update.
     FSDFCTLL0  UF   E           K DISK    INFSR(*PsSR)
     F                                     COMMIT
      *
      ** Securities Clients details for retrieval.
     FSDSECSL0  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Exemption codes details for retrieval.
     FSDEXEML1  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Recipient codes details for retrieval.
     FSDRPCDL1  IF   E           K DISK    INFSR(*PsSR)
      *
      ** Tax basket details for retrieval.
     FSDTXBSL1  IF   E           K DISK    INFSR(*PsSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      **    RunBefore  1A (for the PsSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefIxed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *****************************************************************
      /EJECT
      *****************************************************************
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
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External data structure for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS used for checking recursive updates.
     D CurDetlWT       DS
     D  SOPTN
     D  SCRTT
     D  SINTS
     D  SDCRC
     D  SDCEX
     D  SEXCD
     D  SBCWA
     D  SRPCD
     D  STXBS
     D  SRFSI
     D  SDBTT
     D  SWTIN                                                                                 186000
      *
     D OldDetlWT       DS
     D  SHRECI
     D  SHCRTT
     D  SHINTS
     D  SHDCRC
     D  SHDCEX
     D  SHEXCD
     D  SHBCWA
     D  SHRPCD
     D  SHTXBS
     D  SHRFSI
     D  SHDBTT
     D  SHWTIN                                                                                186000
      *
     D OrgDetlWT       DS
     D  WHRECI
     D  WHCRTT
     D  WHINTS
     D  WHDCRC
     D  WHDCEX
     D  WHEXCD
     D  WHBCWA
     D  WHRPCD
     D  WHTXBS
     D  WHRFSI
     D  WHDBTT
     D  WHTIN                                                                                 186000
      *
      ** Parameter list for ZDATE1 & ZDATE2
     D PDateIs         S              6A
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PDayNoOut       S              5P 0
     D PADateOut       S              7A
     D PErrorFlag      S              1A
      *
      ** Reset array for screen error indicators.
     D***WZeroise        S              1    DIM(11) CTDATA PERRCD(11)                        186000
     D WZeroise        S              1    DIM(12) CTDATA PERRCD(12)                          186000
      *
      ** Reset array for screen error indicators to active.
     D***WHighlight      S              1    DIM(11) CTDATA PERRCD(11)                        186000
     D WHighlight      S              1    DIM(12) CTDATA PERRCD(12)                          186000
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             83     83
     D  EndOfFile             84     84
     D  EndOfSFile            85     85
     D  RollUpKey             87     87
                                                                                              CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
                                                                                              CSC022
      ** Commitment Control Array                                                             CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PParmRTCD       S             10A
     D PParmCSNO       S              6A
     D PParmACTN       S              1A
 
     D PKeyC           S             10A
     D PKySt           S              7A
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PSARd           S              6A
 
     D WCOTT           S              2A
     D WScrn           S              1A
     D WError          S              1A
     D W_Err           S              5P 0
     D W_Rrn           S              5P 0
     D W_Trn           S              5P 0
     D W_Cnt           S              5P 0
 
     D CSE024          S              1A
 
     D WErrOnU         S              1A   INZ(*Blanks)
     D WLetter         S              6A   INZ(*Blanks)
     D WNumber         S              6  0
 
     D MainFlName      S             10A   INZ('SDWTCSPD  ')
 
     D DelRequested    S              1A   INZ(*Blanks)
     D FilUpdNeeded    S              1A   INZ(*Blanks)
     D SflUpdNeeded    S              1A   INZ(*Blanks)
      *
      ** Index for arrays of error message IDs
     D Ix              S              3P 0
     D IdX             S              3P 0
 
     D PMsgFl          S             10A   INZ('GBSDUSRMSG')
     D PMsgId          S             10A   INZ(*Blanks)
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
                                                                                              CSC022
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
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
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Fill sub-file with records.
      *
     C                   IF        WScrn = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
      *
      ** Display browse screen (sub-file active: fields are amendable)
      *
     C                   IF        WScrn = 'A'
     C                   EXSR      SRAddMode
     C                   ENDIF
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build subfile by Customer number and Country of   *
      *             Tax Treaty.                                       *
      *                                                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
      *
      ** Check if customer is classified as safe custody or
      ** discretionary, otherwise not allowed.
      *
     C     PParmCSNO     CHAIN     SDSECSL0                           83
 
     C**************     IF        RecNotFnd = True OR (BFCLAS <> 'S'           186001
     C**************               AND BFCLAS <> 'D')                           186001
     C                   IF        RecNotFnd = True OR (BFCLAS <> 'S'           186001
     C                             AND BFCLAS <> 'D'AND BFCLAS <> 'I')          186001
     C                   EVAL      PParmRTCD = '*CSNERR'
     C                   EVAL      WScrn = 'T'
     C                   GOTO      ESRBldBrw
     C                   ENDIF
      *
      ** Set pointer (customer no.) to start of key.
      *
     C     SCSNO         SETLL     SDWTCSL0
      *
      ** Read withholding tax record on file.
      *
     C                   EXSR      SRReadRec
      *
      ** If no single record read and action is insert or amend,
      ** go directly to 'Add' mode.  Else, return to caller with
      ** message 'No withholding tax details exist.'.
      *
     C                   IF        EndOfFile = True
 
     C                   IF        PParmACTN = 'I' OR PParmACTN = 'A'
     C                   EVAL      WScrn = 'A'
     C                   GOTO      ESRBldBrw
     C                   ELSE
     C                   EVAL      PParmRTCD = '*NRF   '
     C                   EVAL      WScrn = 'T'
     C                   GOTO      ESRBldBrw
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set footer for change mode and initialize subfile relative record
      ** number.
      *
     C                   EVAL      *IN95 = *On
     C                   EVAL      *IN99 = *On
      *
      ** Enable/disable field based on action code.
      ** Setup available function keys.
      *
     C                   IF        PParmACTN = 'E' OR PParmACTN = 'D'
     C                   EVAL      *IN05 = *Off
     C                   EVAL      *IN09 = *Off
     C                   EVAL      *IN80 = *On
     C                   ELSE
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN09 = *On
     C                   EVAL      *IN80 = *Off
     C                   ENDIF
      *
      ** Clear message subfile and reset subfile relative record number.
      *
     C                   EXSR      SRClearErr
     C                   CALL      'ZA0250'
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN81 = *On
     C                   WRITE     SD0372C0
     C                   EVAL      *IN81 = *Off
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      RollUpKey = True
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       RollUpKey = True OR WScrn = 'B'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile = False AND W_Cnt < 12 AND
     C                             SflUpdNeeded = *BLANK OR
     C                             EndOfFile = False AND W_Cnt < 12 AND
     C                             RollUpKey = True
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
     C                   Z-ADD     W_Rrn         SSFRN
     C                   Z-ADD     W_Rrn         W_Trn
      *
      ** Format fields for output.
     C                   EXSR      SRFmtWit
      *
      ** Write withholding tax details to subfile.
     C                   WRITE     SD0372S0
      *
      ** Read next record.
     C                   EXSR      SRReadRec
 
     C                   ENDDO
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write screen footer for the screen.
     C                   WRITE     SD0372F1
      *
      ** Write message sub-file for error messages.
     C                   WRITE     SD0372C2
      *
      ** Write and read the subfile control if records exist for browse processing.
     C                   IF        SSFRN <> 0
 
     C                   EXFMT     SD0372C0
 
     C                   SELECT
      *
      ** If F3, bypass further processing for this module.
     C                   WHEN      *INKC = *On
     C                   EVAL      PParmRTCD = 'Y2U9999'
     C                   EVAL      WScrn = 'T'
      *
      ** If F5, refresh screen.
     C                   WHEN      *INKE = *On
     C                   EXSR      SRClearErr
     C                   CALL      'ZA0250'
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN81 = *On
     C                   EVAL      WCRTT = *Blanks
     C                   WRITE     SD0372C0
     C                   EVAL      *IN81 = *Off
     C     SCSNO         SETLL     SDWTCSL0
     C                   EXSR      SRReadRec
      *
      ** If F9, set screen to add mode.
     C                   WHEN      *INKI = *On
     C                   EVAL      WCRTT = *Blanks
     C                   EVAL      WScrn = 'A'
      *
      ** If F12, bypass further processing this module.
     C                   WHEN      *INKL = *On
     C                   EVAL      PParmRTCD = 'USR0790'
     C                   EVAL      WScrn = 'T'
      *
      ** Enter key, process active subfile for update.
     C                   OTHER
 
     C                   IF        RollUpKey <> True
 
     C                   EXSR      SRValUpdSfl
      *
      ** Reset subfile to pointer if enter key selected instead of rollup
      ** key.
     C                   IF        SflUpdNeeded = *BLANK
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN81 = *On
     C                   WRITE     SD0372C0
     C                   EVAL      *IN81 = *Off
 
     C                   EVAL      WCOTT = WCRTT
     C     WithKey       SETLL     SDWTCSL0                           84
      *
      ** Display last record if pointer exceeds last record on file.
     C                   IF        EndOfFile = True
     C                   READP     SDWTCSL0                               84
     C                   ELSE
     C                   EXSR      SRReadRec
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      SSFRN = W_Err
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      W_Rrn = W_Trn
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      WScrn = 'A'
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadRec - Read record from file.                           *
      *                                                               *
      *****************************************************************
     C     SRReadRec     BEGSR
      *
      ** Read the file initially - if EndOfFile is set on, then the end of
      ** the file has been reached.  Read until a record is found or until
      ** no more records exist.
      *
     C                   DOU       EndOfFile = True OR WError = *Zero
      *
      ** Read the file by customer and country of tax treaty.
     C     PParmCSNO     READE     SDWTCSL0                               84
 
     C                   IF        EndOfFile = False
     C                   EVAL      WError = '0'
     C                   EVAL      OldDetlWT = OrgDetlWT
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtWit - Format Withholding Tax Details for output to SF.  *
      *                                                               *
      *****************************************************************
     C     SRFmtWit      BEGSR
      *
      ** Option.
      *
     C                   EVAL      SOPTN = *BLANK
      *
      ** Country of tax treaty.
      *
     C                   EVAL      SCRTT = WHCRTT
      *
      ** Intermediary status.
      *
     C                   EVAL      SINTS = WHINTS
      *
      ** Documentation received.
      *
     C                   EVAL      SDCRC = WHDCRC
      *
      ** Documentation expiry date.
      *
     C                   IF        WHDCEX <> *ZEROS
     C                   Z-ADD     WHDCEX        PDateIn
     C                   EXSR      SRFmtDatI
     C                   MOVEL     PDateOut      SDCEX
     C                   ELSE
     C                   EVAL      SDCEX = *Blanks
     C                   ENDIF
      *
      ** Exemption code.
      *
     C                   EVAL      SEXCD = WHEXCD
      *
      ** Backup withholding.
      *
     C                   EVAL      SBCWA = WHBCWA
      *
      ** Recipient code.
      *
     C                   EVAL      SRPCD = WHRPCD
      *
      ** Tax basket.
      *
     C                   EVAL      STXBS = WHTXBS
      *
      ** Report foreign source of income.
      *
     C                   EVAL      SRFSI = WHRFSI
      *
      ** Double tax treaty.
      *
     C                   EVAL      SDBTT = WHDBTT
      *                                                                                       186000
      ** Tax Identification Number                                                            186000
      *                                                                                       186000
     C                   EVAL      SWTIN = WHTIN                                              186000
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValUpdSfl - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
     C     SRValUpdSfl   BEGSR
      *
      ** Reset error arrays and clear message subfile.
      *
     C                   EXSR      SRClearErr
     C                   CALL      'ZA0250'
      *
      ** Read subfile if an option has been selected or a record has been
      ** changed.
      *
     C                   DOU       EndOfSfile = True
 
     C                   IF        WScrn = 'B'
     C                   READC     SD0372S0                               85
     C                   ELSE
     C                   READC     SD0372S1                               85
     C                   ENDIF
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
     C                   IF        EndOfSFile = False
      *
      ** Remember that atleast one record in the subfile has been changed.
     C                   EVAL      SflUpdNeeded = 'Y'
 
     C                   IF        CurDetlWT <> *BLANK
     C                   EVAL      Ix = 0
     C                   EXSR      SRValidate
     C                   ELSE
     C                   EVAL      FilUpdNeeded = *Blanks
     C                   ENDIF
      *
      ** Keep track of first subfile page with error.  This is used to
      ** position page on first occurence of error.
     C                   IF        W_Err = 0 AND IdX <> 0
     C                   EVAL      W_Err = W_Rrn
     C                   ENDIF
      *
      ** Update master file if no errors encountered.
     C                   IF        FilUpdNeeded = 'Y' AND SOPTN <> 'D'
     C                   EXSR      SRUpdate
     C                   EVAL      *IN94 = *Off
     C                   ELSE
     C                   EVAL      *IN94 = *On
     C                   ENDIF
      *
      ** Update current status of subfile record.
     C                   IF        WScrn = 'B'
     C                   UPDATE    SD0372S0
     C                   ELSE
 
     C                   IF        WScrn = 'A'
     C                   UPDATE    SD0372S1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Make sure that error indicators are reset after each update of
      ** the subfile record.
     C                   MOVEA     WZeroise      *IN(20)
     C                   EVAL      *IN94 = *Off
 
     C                   ENDDO
      *
      ** If more than 1 error message is to be displayed, seton
      ** rollup/rolldown key for error message subfile.
      *
     C                   IF        IdX > 1
     C                   EVAL      *IN99 = *Off
     C                   ELSE
 
     C                   IF        W_Err = 0
     C                   EVAL      W_Err = W_Rrn
     C                   ENDIF
 
     C                   EVAL      *IN99 = *On
     C                   ENDIF
      *
      ** During change mode, process delete request only if no more errors
      ** found.
      *
     C                   IF        WScrn = 'B' AND IdX = 0 AND
     C                             DelRequested = 'Y'
     C                   EXSR      SRUpdDel
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearErr - Clear DS for error arrays.                      *
      *                                                               *
      *****************************************************************
     C     SRClearErr    BEGSR
 
     C                   EVAL      Idx = 0
     C                   EVAL      W_Err = 0
     C                   EVAL      *IN99 = *On
     C                   EVAL      FilUpdNeeded = *BLANK
     C                   EVAL      SflUpdNeeded = *BLANK
     C                   EVAL      DelRequested = *BLANK
     C                   MOVEA     WZeroise      *IN(20)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate subfile record.                        *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
      ** Validate option, valid value is 'D' for delete record.
      *
     C                   IF        WScrn = 'B' AND SOPTN <> *BLANK AND
     C                             SOPTN <> 'D'
     C                   EVAL      *IN20 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7503'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   EVAL      *IN20 = *Off
 
     C                   IF        SOPTN = 'D'
     C                   EVAL      DelRequested = 'Y'
     C                   EVAL      FilUpdNeeded = 'Y'
     C                   GOTO      ESRValidate
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate country of tax treaty field.
      *
     C                   IF        WScrn = 'A'
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      '*Blanks '    PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    SCRTT
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        Prtcd <> *Blanks
     C                   EVAL      *IN21 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7504'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   EVAL      SCRTT = A4CNCD
      *
      ** Make sure no record for this country exist on file.
     C     WTaxKey       CHAIN     SDWTCSL1                           83
 
     C                   IF        RecNotFnd = False
     C                   EVAL      *IN21 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7505'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate intermediary status.
      *
     C                   IF        SINTS <> *Blanks AND SINTS <> 'WA ' AND
     C                             SINTS <> 'QI ' AND SINTS <> 'NQI' AND
     C                             SINTS <> 'FTE'
     C                   EVAL      *IN22 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7506'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   IF        (SINTS = 'NQI' OR SINTS = 'FTE') AND
     C                             CSE024 <> 'Y'
     C                   EVAL      *IN22 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7520'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN22 = *Off
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate documentation received field.
      *
      *                                                                         186001
      ** If the Contry of Tax is the same as residence and the                  186001
      ** classification of the customer is not 'I', then the                    186001
      ** documentation status can only have the following value,                186001
      ** 'U', 'D', 'E', 'C' or 'L'.                                             186001
      *                                                                         186001
     C**************     IF        SCRTT = BBCOLC                        185994 186001
     C                   IF        SCRTT = BBCOLC AND BFCLAS <> 'I'             186001
     C                   IF        SDCRC = *BLANK OR SDCRC <> 'U' AND           185994
     C                             SDCRC <> 'D' AND SDCRC <> 'E' AND            185994
     C                             SDCRC <> 'C' AND SDCRC <> 'L'                185994
     C                   EVAL      *IN23 = *On                                  185994
     C                   EVAL      Ix = Ix + 1                                  185994
     C                   EVAL      Idx = Idx + 1                                185994
     C                   EVAL      PMsgId = *Blanks                             185994
     C                   EVAL      PMsgId = 'USR7522'                           185994
     C                   EXSR      SRSndMsg                                     185994
     C                   ENDIF                                                  185994
     C                   ELSE                                                   185994
      *                                                                         185994
     C                   IF        SDCRC = *BLANK OR SDCRC <> 'Y' AND
     C                             SDCRC <> 'N' AND SDCRC <> 'D' AND
     C                             SDCRC <> 'U' AND SDCRC <> 'C' AND
     C                             SDCRC <> 'L' AND SDCRC <> 'I' AND
     C                             SDCRC <> 'E'
     C                   EVAL      *IN23 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7507'
     C                   EXSR      SRSndMsg
     C                   ENDIF                                                  185994
     C                   ENDIF                                                  185994
      *                                                                         186001
      ** If Customer is an internal customer, then documentation                186001
      ** status can only be 'Y'.                                                186001
      *                                                                         186001
     C                   IF        BFCLAS = 'I' and SDCRC = *BLANK              186001
     C                   EVAL      SDCRC = 'Y'                                  186001
     C                   ENDIF                                                  186001
                                                                                186001
     C                   IF        BFCLAS = 'I' and SDCRC <> 'Y'                186001
     C                   EVAL      *IN23 = *On                                  186001
     C                   EVAL      Ix = Ix + 1                                  186001
     C                   EVAL      Idx = Idx + 1                                186001
     C                   EVAL      PMsgId = *Blanks                             186001
     C                   EVAL      PMsgId = 'USR7523'                           186001
     C                   EXSR      SRSndMsg                                     186001
     C                   ENDIF                                                  186001
 
     C***********        ELSE                                                   185994
 
     C                   IF        *IN23 = *OFF                                 185994
     C                   IF        (SINTS = 'WA' OR SINTS = 'QI' OR
     C                             SINTS = 'NQI' OR SINTS = 'FTE') AND
     C                             SDCRC <> 'I'
     C                   EVAL      *IN23 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7508'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN23 = *Off
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate documentation expiry date.
      *
     C                   IF        SDCEX <> *Blanks
     C                   MOVE      *BLANKS       WNumber
     C                   MOVE      SDCEX         WNumber
     C                   EVAL      WLetter = *Blanks
     C                   MOVE      WNumber       WLetter
 
     C                   IF        WLetter = SDCEX
     C                   MOVE      *Blanks       PDateIs
     C                   MOVEL     SDCEX         PDateIs
     C                   EXSR      SRFmtDatO
     C                   ELSE
     C                   EVAL      PErrorFlag = 'Y'
     C                   ENDIF
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN24 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = IdX + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7509'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN24 = *Off
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate exemption code.
      *
     C                   IF        SEXCD <> *BLANK
     C     ExCoKey       CHAIN     SDEXEML1                           83
     C                   ENDIF
 
     C                   IF        SDCRC = 'E' AND SEXCD = *BLANK OR
     C                             SDCRC <> 'E' AND SEXCD <> *BLANK OR
     C                             RecNotFnd = True AND SEXCD <> *BLANK
     C                   EVAL      *IN25 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7510'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN25 = *Off
     C                   ENDIF
      *
      ** Validate backup withholding applicable field.
      *
     C                   IF        SBCWA <> *BLANK AND SBCWA <> 'Y' AND
     C                             SBCWA <> 'N'
     C                   EVAL      *IN26 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7511'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   IF        SINTS = 'QI ' AND SBCWA = 'Y'
     C                   EVAL      *IN26 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7521'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   EVAL      *IN26 = *Off
      *
      ** Default backup withholding applicable field if necessary.
      *
     C                   IF        SBCWA = *BLANK
 
     C                   IF        SDCRC = 'U' AND SINTS <> 'QI'
     C                   EVAL      SBCWA = 'Y'
     C                   ELSE
     C                   EVAL      SBCWA = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate recipient code.
      ** (This can be *BLANK if customer is internal customer)                  186001
      *
     C                   IF        BFCLAS <> 'I' OR ( BFCLAS = 'I' AND          186001
     C                             SRPCD <> *BLANK )                            186001
                                                                                186001
     C     RcCoKey       CHAIN     SDRPCDL1                           83
 
     C                   IF        RecNotFnd = True
     C                   EVAL      *IN27 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7512'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN27 = *Off
     C                   ENDIF
                                                                                186001
     C                   ENDIF                                                  186001
      *
      ** Validate tax basket.
      *
     C                   IF        STXBS <> *BLANK
     C     TxBsKey       CHAIN     SDTXBSL1                           83
     C                   ENDIF
 
     C                   IF        SDBTT = 'N' AND STXBS = *Blanks OR
     C                             SDCRC = 'E' AND STXBS = *Blanks OR           186048
     C                             RecNotFnd = True AND STXBS <> *Blanks
     C                   EVAL      *IN28 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7513'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN28 = *Off
     C                   ENDIF
      *
      ** Validate report foreign source income field.
      *
     C                   IF        SRFSI <> 'Y' AND SRFSI <> 'N'
     C                   EVAL      *IN29 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7514'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      *IN29 = *Off
     C                   ENDIF
      *
      ** Validate take advantage of double tax treaty field.
      *
     C                   IF        SDBTT <> 'Y' AND SDBTT <> 'N'
     C***********        IF        SDBTT = *BLANK AND SDCRC = 'U' OR            186052
     C***********                  SDBTT = *BLANK AND SDCRC = 'N'               186052
     C***********        EVAL      *IN30 = *Off                                 186052
     C***********        ELSE                                                   186052
     C                   IF        SDBTT <> *BLANK OR                           186052
     C                             SDBTT = *BLANK AND SDCRC = 'C' OR            186038
     C                             SDBTT = *BLANK AND SDCRC = 'L' OR            186038
     C                             SDBTT = *BLANK AND SDCRC = 'Y'               186052
     C                   EVAL      *IN30 = *On
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7515'
     C                   EXSR      SRSndMsg
     C                   ELSE                                                   186052
     C                   EVAL      *IN30 = *Off                                 186052
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN30 = *Off
     C                   ENDIF
      *
      ** Set record for update if no errors found.
      *
     C                   IF        Ix = 0
     C                   EVAL      FilUpdNeeded = 'Y'
     C                   ELSE
     C                   EVAL      FilUpdNeeded = 'N'
     C                   ENDIF
 
     C     ESRValidate   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdDel - Update file for record deletions.                 *
      *                                                               *
      *****************************************************************
     C     SRUpdDel      BEGSR
      *
      ** Read subfile for records awaiting deletion.
      *
     C                   DOU       EndOfSfile = True
 
     C                   READC     SD0372S0                               85
      *
      ** Apply deletion to master database.
     C                   IF        EndOfSFile = False
     C                   EXSR      SRUPDATE
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Make sure subfile page is rebuild every after successful record
      ** deletions on file.
      *
     C                   IF        IdX = 0
     C                   EVAL      SflUpdNeeded = *BLANK
     C                   EVAL      W_Rrn = 0
     C                   EVAL      SSFRN = W_Rrn
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update master file record.                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      WErrOnU = *Blanks
     C                   MOVEA     WZeroise      *IN(20)
 
     C                   EVAL      WCOTT = SCRTT
     C     WithKey       CHAIN     SDWTCSL0                           83
 
     C                   IF        WScrn = 'A'
      *
      ** Display error message "Record already existing." if appropriate.
     C                   IF        RecNotFnd = False
     C                   MOVEA     WHighlight    *IN(20)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrOnU = 'Y'
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7516'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EXSR      SRFmtWitUpd
     C                   WRITE     @WTCSL0
     C                   CLEAR                   CurDetlWT
     C                   ENDIF
 
     C                   ELSE
      *
      ** Display error message "Record missing on file." if appropriate.
     C                   IF        RecNotFnd = True
     C                   MOVEA     WHighlight    *IN(20)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrOnU = 'Y'
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7517'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
     C                   IF        OldDetlWT = OrgDetlWT
 
     C                   SELECT
     C                   WHEN      SOPTN = 'D'
     C                   DELETE    @WTCSL0
     C                   OTHER
     C                   EXSR      SRFmtWitUpd
     C                   UPDATE    @WTCSL0
     C                   ENDSL
 
     C                   ELSE
      *
      ** RECUPD, display error message "Record updated by another user." on
      ** screen.
     C                   MOVEA     WHighlight    *IN(20)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrOnU = 'Y'
     C                   EVAL      PMsgId = *Blanks
     C                   EVAL      PMsgId = 'USR7518'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Update standing data trailer record if no errors encountered.
      *
     C                   IF        WErrOnU <> 'Y'
     C     MainFlName    CHAIN     SDFCTLL0                           83
 
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBKey = MainFlName
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
 
     C                   SELECT
      *
      ** Insert.
     C                   WHEN      WHTYLC = 'I'
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   EVAL      AHNORC = AHNORC + 1
      *
      ** Amend.
     C                   WHEN      WHTYLC = 'A'
     C                   EVAL      AHNOAM = AHNOAM + 1
      *
      ** Delete.
     C                   WHEN      SOPTN = 'D'
     C                   EVAL      AHNODL = AHNODL + 1
     C                   EVAL      AHNORC = AHNORC - 1
     C                   ENDSL
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
      *
      ** If no errors encountered during update of detail and trailer file,
      ** then commit changes to database.
      *
     C                   IF        WErrOnU <> 'Y'
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF
 
     C     ESRUpdate     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtWitUpd - Format Withholding Tax Details for output to   *
      *                master file.                                   *
      *                                                               *
      *****************************************************************
     C     SRFmtWitUpd   BEGSR
      *
      ** Record Id (Live).
     C                   EVAL      WHRECI = 'D'
      *
      ** Customer number.
     C                   EVAL      WHCSNO = SCSNO
      *
      ** Country of tax treaty.
     C                   EVAL      WHCRTT = SCRTT
      *
      ** Intermediary status.
     C                   EVAL      WHINTS = SINTS
      *
      ** Documentation received.
     C                   EVAL      WHDCRC = SDCRC
      *
      ** Documentation expiry date.
     C                   EVAL      WHDCEX = PDayNoOut
      *
      ** Exemption code.
     C                   EVAL      WHEXCD = SEXCD
      *
      ** Backup withholding.
     C                   EVAL      WHBCWA = SBCWA
      *
      ** Recipient code.
     C                   EVAL      WHRPCD = SRPCD
      *
      ** Tax basket.
     C                   EVAL      WHTXBS = STXBS
      *
      ** Report foreign source of income.
     C                   EVAL      WHRFSI = SRFSI
      *
      ** Double tax treaty.
     C                   EVAL      WHDBTT = SDBTT
      *                                                                                       186000
      ** Tax Identification Number                                                            186000
     C                   EVAL      WHTIN  = SWTIN                                             186000
      *
      ** Last change date.
     C                   EVAL      WHLCD = BJRDNB
      *
      ** Type of last change.
     C                   IF        WScrn = 'A'
     C                   EVAL      WHTYLC = 'I'
     C                   ELSE
     C                   EVAL      WHTYLC = 'A'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAddMode - Processig for record insertion.                  *
      *                                                               *
      *****************************************************************
     C     SRAddMode     BEGSR
      *
      ** Set footer for add mode and initialize subfile relative record
      ** number.
      *
     C                   EVAL      EndOfFile = False
     C                   EVAL      *IN95 = *Off
     C                   EVAL      *IN99 = *On
      *
      ** Enable/disable field based on action code.
      ** Setup available function keys.
      *
     C                   EVAL      *IN05 = *On
     C                   EVAL      *IN09 = *On
     C                   EVAL      *IN80 = *Off
      *
      ** Clear message subfile and reset subfile relative record number.
      *
     C                   EXSR      SRClearSFL
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN81 = *On
     C                   WRITE     SD0372C1
     C                   EVAL      *IN81 = *Off
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      RollUpKey = True
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       RollUpKey = True OR WScrn = 'A'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             W_Cnt
      *
      ** Do this until the subfile page is full.
     C                   DOW       W_Cnt < 12 AND RollUpKey = True OR
     C                             W_Cnt < 12 AND *INKE = *On OR
     C                             W_Cnt < 12 AND SflUpdNeeded = *BLANK
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
     C                   Z-ADD     W_Rrn         SSFRN
     C                   Z-ADD     W_Rrn         W_Trn
     C                   WRITE     SD0372S1
     C                   ENDDO
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write screen footer for the screen.
     C                   WRITE     SD0372F1
      *
      ** Write message sub-file for error messages.
     C                   WRITE     SD0372C2
      *
      ** Write and read the subfile control.
     C                   EXFMT     SD0372C1
 
     C                   SELECT
      *
      ** If F3, bypass further processing for this module.
     C                   WHEN      *INKC = *On
     C                   EVAL      PParmRTCD = 'Y2U9999'
     C                   EVAL      WScrn = 'T'
      *
      ** If F5, refresh screen.
     C                   WHEN      *INKE = *On
     C                   EXSR      SRClearSFL
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN81 = *On
     C                   WRITE     SD0372C1
     C                   EVAL      *IN81 = *Off
      *
      ** If F9, set screen to add mode.
     C                   WHEN      *INKI = *On
     C                   EVAL      WScrn = 'B'
      *
      ** If F12, bypass further processing this module.
     C                   WHEN      *INKL = *On
     C                   EVAL      PParmRTCD = 'USR0790'
     C                   EVAL      WScrn = 'T'
      *
      ** Rollup, add more record to the subfile.
      ** Enter key, process active subfile for update.
     C                   OTHER
 
     C                   IF        RollUpKey <> True
 
     C                   EXSR      SRValUpdSfl
 
     C                   IF        IdX = 0
     C                   EXSR      SRClearSFL
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN81 = *On
     C                   WRITE     SD0372C1
     C                   EVAL      *IN81 = *Off
     C                   ELSE
     C                   EVAL      SSFRN = W_Err
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      W_Rrn = W_Trn
     C                   MOVEA     WZeroise      *IN(20)
     C                   EXSR      SRClearSFL
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearSFL - Clear DS for sub-file and reset error msgs.     *
      *                                                               *
      *****************************************************************
     C     SRClearSFL    BEGSR
      *
      ** Clear subfile subsets and attributes.
      *
     C                   CLEAR                   CurDetlWT
     C                   EXSR      SRClearErr
 
     C                   IF        RollUpKey <> True
     C                   CALL      'ZA0250'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDatI - Format date for display.                         *
      *                                                               *
      *****************************************************************
     C     SRFmtDatI     BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *Blanks       PADateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDatO- Format date for output to file.                   *
      *                                                               *
      *****************************************************************
     C     SRFmtDatO     BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIs
     C                   PARM      *ZERO         PDayNoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRSndMsg - Subroutine which sends messages to the program   *
      *              message que.                                     *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFl
     C                   PARM                    PMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *InzSR        BEGSR
      *
      ** Receive entry parameters.
      *
     C     *ENTRY        PLIST
      *
      ** Return code.
     C                   PARM                    PParmRTCD
      *
      ** Customer number.
     C                   PARM                    PParmCSNO
      *
      ** Action code.
     C                   PARM                    PParmACTN
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE024 (Withholding tax -
      ** Sub Account Processing) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE024'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *Blanks AND PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = 'CSE024'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase  = 002
     C                   OUT       LDA
     C                   EXSR      *PsSR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CSE024 = 'Y'
     C                   ELSE
     C                   EVAL      CSE024 = 'N'
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        PRTCD <> *BLANKS and                                       CSC022
     C                             PRTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 909                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      *
      ** Access customer details.
      ** Customer must exist, standard DBError if customer is not found.
      *
     C**********         CALLB     'AOCUSTR0'                                                 212166
     C                   CALL      'AOCUSTR0'                                                 212166
     C**********         PARM      '*DBERR'      PRtCd                                        214914
     C                   PARM      *Blanks       PRtCd                                        214914
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PParmCSNO     PKeyC
     C                   PARM      *Blanks       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   EVAL      SCSNO = BBCUST
     C                   EVAL      SCSSN = BBCSSN
     C                   EVAL      SCRNM = BBCRNM
     C                   EVAL      SCRTN = BBCRTN
      *
     C                   EVAL      SRUNA = BJMRDT
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
      *
      ** Key fields for withholding tax file - subfile pointer.
      *
     C     WithKey       KLIST
     C                   KFLD                    SCSNO
     C                   KFLD                    WCOTT
      *
      ** Key fields for withholding tax file - validation.
      *
     C     WTaxKey       KLIST
     C                   KFLD                    SCSNO
     C                   KFLD                    SCRTT
      *
      ** Key fields for exemption codes file.
      *
     C     ExCoKey       KLIST
     C                   KFLD                    SCRTT
     C                   KFLD                    SEXCD
      *
      ** Key fields for recipient codes file.
      *
     C     RcCoKey       KLIST
     C                   KFLD                    SCRTT
     C                   KFLD                    SRPCD
      *
      ** Key fields for tax basket file.
      *
     C     TxBsKey       KLIST
     C                   KFLD                    SCRTT
     C                   KFLD                    STXBS
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN99 = *On
     C                   EVAL      SPGMQ = '*'
      *
      ** Start by filling subfile with existing records.
      *
     C                   EVAL      WScrn = 'B'
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PsSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PsSR         BEGSR
 
     C                   IF        RunBefore = *BLANK
 
     C                   DUMP
 
     C                   EVAL      RunBefore = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  WZeroise
000000000000
**  WHighlight
111111111111
