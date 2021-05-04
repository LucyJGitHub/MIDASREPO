     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements details repair')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMRPR - Trade Settlements Details Repair                 *
      *                                                               *
      *  Function: This module allows invalid Trade Settlements       *
      *            details to be 'repaired' and applied to the Midas  *
      *            database.                                          *
      *                                                               *
      *  Component of: SETRSMRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CAP182  *CREATE    Date 03Jan03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Use for LOOKUP command                          *
      *    99         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrScrnB   - Browse invalid Trade Settlements details         *
      *  SrRdnBrw  - Read Next Browse Subfile Record                  *
      *  SrScrnD   - Process Detail Screen                            *
      *  SrValD    - Validate input to detail screen.                 *
      *  SrScrnW   - Process Window Screen                            *
      *  SrScrnF   - Process Confirmation Screen                      *
      *  SrUpdate  - Update Files                                     *
      *  SrRtvTRSM - Retrieve Trade Settlements details.              *
      *  SrCvtTRSM - Converts Trade Settlements details from          *
      *              file to screen format.                           *
      *  SrDtaSubs - Data Substitution                                *
      *  SrSndMD   - Send error message to detail screen              *
      *  SrEndP    - Set Program to End                               *
      *  SrResetErr- Reset Error Fields                               *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
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
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas module flag - details
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Invalid Trade Settlement by Timestamp and Fromt Office Id
      ** - for record retrieval
     FSEITRSML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEITRSMD0:SEITRSMX0)
      *
      ** Invalid Trade Settlement by Timestamp and Fromt Office Id
      ** - for record update
     FSEITRSML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRSMR001
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
     D WEI             S              1    DIM(60)
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Backup arrays for error messages on 1st screen
     D FldNameAr1      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr1        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr1       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trade Settlement for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** SE Trade Settlement screen details retrieved from file
      ** - screen format
     D CrTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
     D                                     PREFIX(O)
      *
      ** SE Trade Details retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SE_)
      *
      ** SE Trade Settlement Screen error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Backup data structures for screen details
     D NwTS1ScnFmx   E DS                  EXTNAME(SETRSMPD)
     D                                     PREFIX(B)
      *
      ** Backup data structures for screen error indicators
     D SEETRSMx      E DS                  EXTNAME(SEETRSMPD)
     D                                     PREFIX(B)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Backup index for error messages on 1st screen
     D ID1             S              3P 0
      *
      ** Work index
     D Ex              S              3P 0
     D Fx              S              3P 0
     D WIx             S              3P 0
      *
      ** Mode of Operation
     D PMode           S              6A   INZ('*RPR  ')
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PResponse       S              1A   INZ('S')
      *
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested field)
     D PFormat         S             10A   INZ('SETRSMPD')
     D PField1         S             10A   INZ('DDSLPR')
     D PFieldNo        S              5P 0
     D WFldOffset1     S              5P 0
      *
      ** Parameter fields
     D PFOTrID         S             20A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PRDNB           S              1A
     D PEdtFld         S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PTRADSel        S              6A
     D PMVDTSel        S              6A
     D PFSETSel        S              1A
     D PREVESel        S              1A
     D PSSEQN          S              3  0
     D DDACTN          S              1A
     D PPayCcy         S              3A
     D PEvtDno         S              5P 0
     D PFOTranSel      S             20A
     D PTmeStpSel      S             26Z
     D PAmendOk        S              1A
     D PResetFld       S              1A
     D PReDsp          S              1A
     D PPROT           S              1A
      *
      ** Parameters for WN0010
     D PWPGM           S             10A   INZ('SETRSMRPR')
     D PWKEY           S              2A
     D PWACTION        S              1A
     D PWRTN           S              7A
     D PWSPARE         S            256A
      *
      ** Incoming and Current data
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Parameters for AOSARDR0
     D PSARD           S              6A
      *
      ** Work variables
     D WProcOnce       S              1A
     D WScrn           S              1A
     D WSUBSE1         S              1A
     D WDDTRDR         S              6A
     D WDDMVDT         S              6A
     D WDDFSET         S              1A
     D WDDREVE         S              1A
     D WRedisplay      S              1A
      *
      ** Parameters for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCyCd           S              3A
      *
     D PSCnum          S              6A
      *
      ** Parameters for ZDATE1
     D PDateAIn        S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Output screen fields
     D WDNOMS          S                   LIKE(DDNOMS)
     D WDVALS          S                   LIKE(DDVALS)
     D WDNARR          S                   LIKE(DDNARR)
     D WDSREF          S                   LIKE(DDSREF)
     D WDNOTM          S                   LIKE(DDNOTM)
     D WDMSGK          S                   LIKE(DDMSGK)
      *
     D KABFIELDID      S                   LIKE(ABFIELDID)
      *
      ** Function keys
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** SAR fields
     D CSE007          S              1A
     D CEU017          S              1A
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,SETRSMDTA
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SETRSMR002
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
      /COPY WNCPYSRC,SETRSMR003
      *
      ** Browse Invalid Trade Settlements details.
      *
     C                   IF        WScrn = 'B'
     C                   EXSR      SrScrnB
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMR004
      *
      ** Read Next Browse Subfile record.
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SrRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMR005
      *
      ** DO WHILE: Process Details Screen
      *
     C                   DOW       WScrn = 'D'
     C                   EXSR      SrScrnD
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRSMR006
      *
      ** Process Window screen.
      *
     C                   IF        WScrn = 'W'
     C                   EXSR      SrScrnW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMR007
      *
      ** Process Confirmation screen.
      *
     C                   IF        WScrn = 'F'
     C                   EXSR      SrScrnF
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMR008
      *
      ** Update files.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SrUpdate
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMR009
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SETRSMR010
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnB - Browse invalid Trade Settlement details            *
      *                                                               *
      *****************************************************************
     C     SrScrnB       BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
     C                   MOVE      *BLANK        PRDNB
      *
      ** Browse invalid Trade Settlement details.
     C                   CALLB     'SETRSMRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      'Y'           PBdSfl
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        PRdSfl
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs
      *
      ** Option Selected
     C                   PARM                    POpSel
      *
      ** Trade Number Selected
     C                   PARM                    PTRADSel
      *
      ** Movement Date Selected
     C                   PARM                    PMVDTSel
      *
      ** Full Settlement Selected
     C                   PARM                    PFSETSel
      *
      ** Reversal Selected
     C                   PARM                    PREVESel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
      *
      ** Reset Update Status of Previous Transaction flag.
      *
     C                   EVAL      PERRUP = *BLANK
      *
      ** If error occurred, set on external job switch U6.
      *
     C                   IF        PErrMs <> *BLANKS
     C                   MOVE      *ON           *INU6
     C                   ENDIF
      *
      ** Terminate program if F3 was taken in Browse screen or
      ** if error occurred.  Otherwise, read selected Browse
      ** Subfile record.
     C                   IF        PINKC = *ON OR
     C                             PErrMs <> *BLANKS
     C                   EXSR      SrEndP
     C                   ELSE
     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdnBrw - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
     C     SrRdNBrw      BEGSR
      *
      ** Read Next Browse Subfile record.
     C                   CALLB     'SETRSMRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      *BLANK        PBdSfl
      *
      ** Read Subfile Record
     C                   PARM      'Y'           PRdSfl
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs
      *
      ** Option Selected
     C                   PARM                    POpSel
      *
      ** Trade Number Selected
     C                   PARM                    PTRADSel
      *
      ** Movement Date Selected
     C                   PARM                    PMVDTSel
      *
      ** Full Settlement Selected
     C                   PARM                    PFSETSel
      *
      ** Reversal Selected
     C                   PARM                    PREVESel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
      *
      ** Terminate program if F3 was taken within Invalid
      ** Transaction Deletion function.
     C                   IF        PINKC = *ON
     C                   EXSR      SrEndP
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Display Browse screen if no invalid record read from subfile.
     C                   IF        POpSel = *BLANK
     C                   EVAL      WScrn = 'B'
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Clear Trade Settlement details in screen format
      ** from incoming transaction.
      *
     C                   CLEAR                   NwTS1ScnFmt
      *
      ** Clear Trade Settlement details in screen format
      ** retrieved from file.
      *
     C                   CLEAR                   CrTS1ScnFmt
      *
      ** Validate Record selected
     C                   EVAL      DDTRDR = PTRADSel
     C                   EVAL      DDMVDT = PMVDTSel
     C                   EVAL      DDFSET = PFSETSel
     C                   EVAL      DDREVE = PREVESel
     C                   EVAL      PFOTrID = PFOTranSel
      *
      ** If Insert, set Retrieve Mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and keyfields are present, set
      ** Retrieve Mode to blank.
     C                   IF        DDACTN = 'I'
 
     C                   EVAL      PMode = '*FRONT'
 
     C                   ELSE
 
     C                   IF        DDTRDR = *BLANK AND
     C                             DDMVDT = *BLANK AND
     C                             DDFSET = *BLANK AND
     C                             DDREVE = *BLANK
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate the key fields if update selected
     C                   IF        POpSel = 'U'
     C                   EVAL      PEdtFld = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   ENDIF
      *
     C                   EXSR      SrRtvTRSM
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process the
      ** transaction as coming from the repair function.
     C                   EVAL      PMode = '*RPR  '
      *
      ** If original Trade Settlement details were retrieved,
      ** convert details from file to screen format
 
     C                   EXSR      SrCvtTRSM
      *
      ** Save Key Fields
     C                   Movel     DDTRDR        WDDTRDR
     C                   Movel     DDMVDT        WDDMVDT
     C                   Movel     DDFSET        WDDFSET
     C                   Movel     DDREVE        WDDREVE
      *
      ** Access invalid Trade Settlement details file with Timestamp and
      ** Front Office Transaction Id.
     C     ZATRNKX0      CHAIN     SEITRSML0                          99
      *
      ** If original Trade Settlement details were retrieved,
      ** restore the key fileds retrieved from file.
     C                   IF        DDACTN <> 'I'
     C                   EVAL      DDTRDR = WDDTRDR
     C                   EVAL      DDMVDT = WDDMVDT
     C                   EVAL      DDFSET = WDDFSET
     C                   EVAL      DDREVE = WDDREVE
     C                   ENDIF
      *
      ** Not all data displayed on screen are coming in from external source
      *  Save the data coming in.
      *
      ** Nominal settled/Reversed
     C                   Eval      WDNOMS = DDNOMS
      ** Value settled/Reversed
     C                   Eval      WDVALS = DDVALS
      ** Narrative
     C                   Eval      WDNARR = DDNARR
      ** Settlement Reference
     C                   Eval      WDSREF = DDSREF
      ** Notification Method
     C                   Eval      WDNOTM = DDNOTM
      ** Message Key
     C                   Eval      WDMSGK = DDMSGK
      *
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
 
      ** Update the Screen with the incoming data
     C                   Eval      DDNOMS = WDNOMS
     C                   Eval      DDVALS = WDVALS
     C                   Eval      DDNARR = WDNARR
     C                   Eval      DDSREF = WDSREF
     C                   Eval      DDNOTM = WDNOTM
     C                   Eval      DDMSGK = WDMSGK
 
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NwTS1ScnFmt                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'Y'           WSUBSE1
     C                   ELSE
     C                   MOVE      'N'           WSUBSE1
     C                   ENDIF
      *
      ** Substitution character is present in the incoming transaction.
     C                   IF        WSUBSE1 = 'Y'
      *
      ** Do data substitution.
     C                   EXSR      SrDtaSubs
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If errors exist blank out Action Code so input cannot proceed.te
     C                   Move      'N'           WError            1
     C                   IF        OKTRDR = 'N' OR OKMVDT = 'N'
     C                             OR OKFSET = 'N' OR OKREVE = 'N'
     C                   Move      'Y'           WError
     C                   ENDIF
      *
      ** Save screen details.
     C                   EVAL      NwTS1ScnFmx = NwTS1ScnFmt
      *
      ** Send the Trade Settlements details validation error messages
      ** to detail screen.
     C                   EXSR      SrSndMD
      *
      ** Initialise work variable for defaulting.
      *
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display detail screen.
     C                   EVAL      WScrn = 'D'
 
     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnD - Process Detail Screen                              *
      *                                                               *
      *****************************************************************
     C     SrScrnD       BEGSR
      *
      ** Enable amendable fields and F5=Refresh.
     C                   IF        POpSel = 'U'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** Set Calling module to *RPR
     C                   Move      '*RPR'        CallerCode        4
      *
      ** Display detail screen.
     C                   CALLB     'SETRSM2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM      'Y'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** SE Trade Settlement screen error indicators
     C                   PARM                    SEETRSM
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      ** Save Warning Message Ids array of detail screen.
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SrEndP
      *
      ** F5 - refresh detail screen.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwTS1ScnFmt  = NwTS1ScnFmx
     C                   EVAL      SEETRSM = SEETRSMx
     C                   EVAL      FldNameArr = FldNameAr1
     C                   EVAL      MsgIdArr = MsgIdAr1
     C                   EVAL      MsgDtaArr = MsgDtaAr1
     C                   EVAL      IDx = ID1
      *
      ** F12 - cancel.  Read Next Subfile record or display
      ** Browse screen.
     C                   WHEN      PINKL = *ON
 
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
      *
      ** If Windows processing is on, clear any possible updates
      ** in Window function.
     C                   IF        BGWDPR = 'Y'
     C                   ROLBK
     C                   ENDIF
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to Details screen.
      *
     C                   IF        POpSel = 'U'
     C                   EXSR      SrValD
     C                   GOTO      EScrnD
     C                   ENDIF
      *
      ** If Windows processing is on and errors do not exist
      ** on detail screen, perform window processing.
      *
     C                   IF        BGWDPR = 'Y' AND
     C                             ID1 = 0
     C                   EVAL      WScrn = 'W'
     C                   GOTO      EScrnD
     C                   ENDIF
      *
      ** If errors exist on detail screen, read next subfile
      ** record or display browse screen instead.
      *
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSL
 
     C     EScrnD        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValD - Validate input to detail screen.                    *
      *                                                               *
      *****************************************************************
     C     SrValD        BEGSR
      *
      ** Revalidate the key fields
     C                   EXSR      SrRtvTRSM
      *
      ** If any field in error then redisplay the screen with error message
     C                   IF        OKTRDR = 'N' OR OKMVDT = 'N' OR
     C                             OKFSET = 'N' OR OKREVE = 'N'
     C                   EVAL      WError = 'Y'
     C                   GOTO      EValD
     C                   ELSE
      ** If previously there was error on the key field then retrieve the
      *  trade details again
     C                   IF        WError = 'Y'
     C                   EXSR      SrCvtTRSM
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
     C                   Eval      DDNOMS = WDNOMS
     C                   Eval      DDVALS = WDVALS
     C                   Eval      DDNARR = WDNARR
     C                   Eval      DDSREF = WDSREF
     C                   Eval      DDNOTM = WDNOTM
     C                   Eval      DDMSGK = WDMSGK
     C                   Eval      WError = 'N'
     C                   GOTO      EValD
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Validate entries made on the screen.
      *
     C                   CLEAR                   NwTSFilFmt
      *
     C                   CALLB     'SETRSMVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Action
     C                   PARM                    CSE007
      *
      ** Security Redenomination Euro Changes
     C                   PARM                    CEU017
      *
      *
      ** OUTPUT
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
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on detail
      ** screen, check if there are warnings which have not been
      ** displayed yet.
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx
      *
     C                   DOW       WiX <= WIDx AND WRedisplay = *BLANK
 
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SrResetErr
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Redisplay detail screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EValD
     C                   ENDIF
      *
      ** If Windows processing is on, display Window screen.
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'F'
     C                   ENDIF
 
     C     EValD         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnW - Process Window Screen                              *
      *                                                               *
      *****************************************************************
     C     SrScrnW       BEGSR
      *
      ** Protect details fields
     C                   EVAL      PEdtFld = 'N'
      *
      ** Write out screen to remove error messages.
     C                   CALLB     'SETRSM2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Trade Settlement screen error indicators
     C                   PARM                    SEETRSM
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'Y'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      *
      /COPY WNCPYSRC,SETRSMMV1
      *
      ** Call Window Manager.
     C                   CALL      'WN0010'
     C                   PARM      'SETRSMRPR'   PWPGM
     C                   PARM      *BLANKS       PWKEY
     C                   PARM      DDACTN        PWACTION
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PWRTN
     C                   PARM                    PWSPARE
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PWRTN = 'Y2U9999'
     C                   EXSR      SrEndP
      *
      ** F12 - cancel.  Display detail screen.
     C                   WHEN      PWRTN = 'USR0790'
     C                   EVAL      WScrn = 'D'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - proceed to confirmation screen.
     C                   IF        DDACTN = 'I' AND POpSel = 'U'
     C                   EVAL      WScrn = 'F'
     C                   ELSE
      *
      ** Read next browse subfile record if pending option still exist.
      ** Otherwise, display browse screen
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnF - Process Confirmation Screen                        *
      *                                                               *
      *****************************************************************
     C     SrScrnF       BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
     C                   EXSR      SrResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1) = 'MMM1031'
      *
     C                   Eval      PEdtFld = 'N'
      *
      ** Display Confirmation screen.
      *
     C                   CALLB     'SETRSM2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** SE Trade Settlement screen error indicators
     C                   PARM                    SEETRSM
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Save warning message ids array of this screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display detail screen.
     C                   WHEN      PINKL = *ON
     C                   EVAL      WScrn  = 'D'
      *
      ** Enter key was pressed.  Update files.
     C                   OTHER
     C                   EVAL      WScrn = 'U'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Update Files                                      *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR
      *
      ** Update all the remainig data required for file SETLED
      *
      ** Initialise fields
     C                   Z-Add     *Zeros        TotalValSet
     C                   Z-Add     *Zeros        VTSSSQN
     C                   Z-Add     *Zeros        VTSSDAM
     C                   Eval      VTSSSSN = *Blanks
     C                   Eval      VTSSCPN = *Blanks
      *
     C                   Eval      VTSRECI = 'D'
      *
      ** Trade Reference
     C                   Eval      VTSSTDR = DDTRDR
      *
      ** Settlement Sequence
     C     TSSQ          Add       1             VTSSSQN
      *
      ** Branch Code
     C                   Eval      VTSSBCA = DDBRCD
      *
      ** Movement Date
     C                   Eval      PDateAIn = DDMVDT
     C                   Exsr      SrZDate1
     C                   If        PErrorFlag = 'N'
     C                   Z-Add     PDaynoOut     VTSSEDE
     C                   EndIf
      *
      ** Settlement Indicator
     C                   If        DDFSET = *Blanks
     C                   Eval      VTSSFSI = 'N'
     C                   Else
     C                   Eval      VTSSFSI = DDFSET
     C                   EndIf
      *
      ** Reversal Indicator
     C                   If        DDREVE = *Blanks
     C                   Eval      VTSSRIN = 'N'
     C                   Else
     C                   Eval      VTSSRIN = DDREVE
     C                   EndIf
      *
      ** Reported on Security Ledger
     C                   Eval      VTSSRSL = *Blanks
      *
      ** Value Fully Settled Indicator
     C                   Select
     C     TOSV          WhenGt    0
     C                   Eval      VTSSFSL = 'P'
     C     TOSV          WhenLt    0
     C                   Eval      VTSSFSL = 'O'
     C     TOSV          Wheneq    0
     C                   Eval      VTSSFSL = 'F'
     C                   Endsl
      *
      ** Nominal fully settled indicator
     C                   Select
     C     TOSN          WhenGt    0
     C                   Eval      VTSSNFS = 'P'
     C     TOSN          WhenLt    0
     C                   Eval      VTSSNFS = 'O'
     C     TOSN          Wheneq    0
     C                   Eval      VTSSNFS = 'F'
     C                   Endsl
      *
      ** Over-settlement indicator
     C                   If        TOSV < 0
     C                   Eval      VTSSOSI = 'Y'
     C                   Else
     C                   Eval      VTSSOSI = *Blanks
     C                   EndIf
      *
      ** Discrepancy amount
     C                   If        DDFSET = 'Y'
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPO
     C                   Eval      PCyCd = TNMC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPI
     C                   Z-Add     TCTR          ZAMTCI
     C                   Z-Add     TDER          ZEXCH
     C                   Move      TMDI          ZMD
     C                   Move      TNMC          ZCCYI
     C                   Move      SETC          ZCCYO
     C                   Exsr      SrZconv
     C     TVSN          Add       TVSP          WValSet          15 0
     C     WValSet       Add       TOSV          TotalValSet      15 0
     C     TotalValSet   Sub       ZAMTCO        VTSSDAM
     C                   Else
     C                   Z-Add     0             VTSSDAM
     C                   EndIf
      *
      ** Discrepancy indicator
     C                   If        VTSSDAM <> *Zeros
     C                   Eval      VTSSDSI = 'Y'
     C                   Else
     C                   Eval      VTSSDSI = ' '
     C                   EndIf
      *
      ** Security shortname
     C                   Move      TDSS          VTSSSSN
      ** Counterparty number
     C                   Move      TCNR          VTSSCPN
      ** Market indicator
     C                   Move      TDMI          VTSSMKI
      ** Trade type
     C                   Move      TDTP          VTSSTET
      ** Settlement currency
     C                   Move      SETC          VTSSSCY
      ** Book Code
     C                   Move      TDBK          VTSSBOC
      ** Auto-Settled
     C                   Move      AUTS          VTSAUTS
      ** Last Change Date
     C                   Z-Add     BJRDNB        VTSLCD
      ** Change Type
     C                   Move      'I'           VTSCHTP
      *
      ** Process Agency
     C                   Eval      VTSSPAG = *Blanks
      *
      ** Access Securities Clients Details
     C                   If        DDFSET = 'Y'
     C                             Or DDREVR = 'Y' and TDFS <> 0
     C                   Move      TCNR          PSCnum
     C                   CallB     'AOSECSR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm                    PSCnum
     C     SDSECS        Parm      SDSECS        DSSDY
     C                   If        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile= 'SDSECSPD'
     C                   Eval      DBase = 009
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   If        BFCLAS = 'M'
     C                   If        ORDE <> *Zeros And ORDE <> 999999
     C                             Or ATRD = 'M'
     C                   If        DDFSET = 'Y'
     C                   Eval      VTSSPAG = 'P'
     C                   Endif
     C                   If        DDREVR = 'Y' and TDFS <> 0
     C                   Eval      VTSSPAG = 'R'
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** Notification Method
     C                   Eval      VTSNOTM = DDNOTM
      *
      ** Message Key
     C                   Eval      VTSMSGK = DDMSGK
      *
      ** Front Office Id.
     C                   EVAL      VTSFRNT = PFOTranSel
      *
      ** Update files.
      *
     C                   CALLB     'SETRSMUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Trade Settlement Details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        RetCodeOut = '*RECUPD'
     C                   ROLBK
     C                   ENDIF
     C     ZATRNKD0      CHAIN     SEITRSML1                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SEITRSML1
     C                   ENDIF
     C                   COMMIT
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      PERRUP = 'Y'
     C                   ELSE
     C                   EVAL      PERRUP = 'N'
     C                   ENDIF
      *
      ** Read Next Subfile record or display Browse screen.
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvTRSM - Retrieve Trade Settlement Details.               *
      *                                                               *
      *****************************************************************
     C     SrRtvTRSM     BEGSR
 
     C                   CALLB     'SETRSMRTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** Front office transaction Id
     C                   PARM                    PFOTrID
      *
      ** Trade Reference
     C                   PARM                    DDTRDR
      *
      ** Movement Date
     C                   PARM                    DDMVDT
      *
      ** Full Settlement
     C                   PARM                    DDFSET
      *
      ** Reversal
     C                   PARM                    DDREVE
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** STANDING DATA
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
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
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
      ** OK Trade Reference
     C                   PARM                    OKTRDR
      *
      ** OK Movement Date
     C                   PARM                    OKMVDT
      *
      ** OK Full Settlement
     C                   PARM                    OKFSET
      *
      ** OK Reversal
     C                   PARM                    OKREVE
      *
      ** Security Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtTRSM - Converts Security Trade Settlement details from  *
      *              file to screen format.                           *
      *                                                               *
      *****************************************************************
     C     SrCvtTRSM     BEGSR
 
     C                   CALLB     'SETRSMCVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
      ** Settlement Sequence Number
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
     C                   PARM                    PSSEQN
      *
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** SE Trade Settlement screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrTS1ScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDtaSubs - Data Substitution                                *
      *                                                               *
      *****************************************************************
     C     SrDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
     C                   IF        WSUBSE1 = 'Y'
 
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
 
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwTS1ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrTS1ScnFmt   PCurData
 
     C                   MOVEL     PIncData      NwTS1ScnFmt
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSndMD - Send error message to detail screen                *
      *                                                               *
      *****************************************************************
     C     SrSndMD       BEGSR
      *
      ** Reset array index.
     C                   EVAL      Ex = 0
      *
      ** If error occurred in updating last transaction,
      ** display error message on the screen (first message).
      *
     C                   IF        PERRUP = 'Y'
     C                   ADD       1             Ex
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     'APM1000'     MsgIdArr(Ex)
     C                   MOVE      'N'           PERRUP
     C                   ENDIF
      *
      ** If there are fundamental errors in this transaction, identify
      ** this fact.
     C                   IF        OKTRDR = 'N' OR OKMVDT = 'N'
     C                             OR OKFSET = 'N' OR OKREVE = 'N'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'APM0110'     MsgIdArr(Ex)
     C                   ENDIF
      *
      ** Initialise work array for error indicators.
     C                   MOVEA     SEETRSM       WEI
      *
      ** Read Trade Settlement details validation error messages for
      ** 1st screen.
     C                   EVAL      KABFIELDID = 0
 
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for 1st screen to array and set
      ** OK flag for field to 'N'.
     C                   DOW       *IN99 = *OFF AND
     C                             ABFIELDID > WFldOffSet1
 
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
     C                   IF        *IN98 <> *ON
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
 
     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset1   Fx
 
     C                   IF        Fx < 1 OR Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
 
     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
 
     C                   ENDDO
      *
      ** Update error indicators using work array.
     C                   MOVEA     WEI           SEETRSM
      *
      ** Save error indicators and messages on 1st screen.
     C                   MOVE      SEETRSM       SEETRSMx
     C                   MOVEA     FldNameArr    FldNameAr1
     C                   MOVEA     MsgIdArr      MsgIdAr1
     C                   MOVEA     MsgDtaArr     MsgDtaAr1
     C                   EVAL      ID1 = Ex
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEndP - Set Program to End                                  *
      *                                                               *
      *****************************************************************
     C     SrEndP        BEGSR
      *
      ** Rollback uncommitted file changes.
      *
     C                   ROLBK
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetErr - Reset Error Fields                              *
      *                                                               *
      *****************************************************************
     C     SrResetErr    BEGSR
      *
      ** Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
      *
      ** Initialise screen fields error indicators.
      *
     C                   EVAL      SEETRSM = *ALL'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCyCd
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = PCyCd
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Z-Add     1             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZconv - Convert an amount from one currency to another     *
      *                                                               *
      *****************************************************************
     C     SrZconv       Begsr
 
     C                   CallB     'ZCONV'
     C                   Parm                    ZAMTCI           15 0
     C                   Parm                    ZEXCH            13 8
     C                   Parm                    ZMD               1
     C                   Parm                    ZCCYI             3
     C                   Parm                    ZCCYO             3
     C                   Parm                    ZCDPI             1 0
     C                   Parm                    ZCDPO             1 0
     C                   Parm                    ZAMTCO           15 0
      *
     C                   Endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR
 
     C                   CallB     'ZDATE1'
     C                   Parm                    PDateAIn
     C                   Parm      *ZERO         PDaynoOut
     C                   Parm                    BJDFIN
     C                   Parm      *Blanks       PErrorFlag
 
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
     C     *INZSR        BEGSR
      *
      ** Access Bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access securities trading ICD details.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDSTRDPD'
     C                   EVAL      DBase = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBase = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDAPIPD'
     C                   EVAL      DBase = 004
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Corporate Actions' feature
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE007
     C                   ELSE
     C                   MOVEL     'N'           CSE007
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Securities Redenomination'
      ** feature is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CEU017
     C                   ELSE
     C                   MOVEL     'N'           CEU017
     C                   ENDIF
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access MMODF to determine if Strategic Risk Man. Ind is on
      *
     C                   READ      MMODF                                  01
      *
      ** Get the field number for the first field in 1st screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField1
     C                   PARM                    PFieldNo
 
     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset1 = PFieldNo - 1
      *
      ** If there was an error, default the offset to 13.
     C                   ELSE
     C                   EVAL      WFldOffset1 = 13
     C                   ENDIF
      *
      ** Define Key Lists.
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     ZATRNKD1      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    KABFIELDID
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    PFOTranSel
      *
      ** Initialise error fields.
     C                   EXSR      SrResetErr
      *
      ** Display Browse screen.
     C                   MOVE      'B'           WScrn
      *
      ** Can only output record to the primary file, so set action code to I
     C                   MOVE      'I'           DDACTN
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SETRSMR011
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
(c) Finastra International Limited 2003
