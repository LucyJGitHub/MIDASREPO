     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
/*OVRF*: OVRDBF SDCSX1PD SDCSXXPD                                   : *
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities Trading Cust Depot Ref Maint.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Customer Details                       *
      *                                                               *
      *  SDCDRFSFL - Customer Depot Reference Validation              *
      *                                                               *
      *  Function:  This module is for entry, amendment or deletion   *
      *             of customer depot references.  The program will   *
      *             display the subfile screen, validate the screen   *
      *             by calling SDCDRFVAL and update the temporary     *
      *             work file.                                        *
      *                                                               *
      *  Component of:                                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 240601             Date 02Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022   *CREATE   Date 29Mar01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240601 - Apply fix 240346                                    *
      *  240346 - In Enquiry don't authorise option F9=ADD            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Securities Trading Depot Reference Maintenance Display File
     FSDCSDRDF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SDCSDRS1:WkSRRN)
     F                                     SFILE(SDCSDRS2:WkSRRN2)
 
      ** Temporary Customer Depository Reference File by Customer Shortname
     FSDCSX1PD  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Customer Depository Reference file by Customer Number
     FSDCSDRL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid Customer Depository Reference file by Customer Number
     FSDICSDRL1 IF A E           K DISK    PREFIX(I)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
 
     D/COPY ZACPYSRC,MSGHNDDCL
 
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
 
     D/COPY ZACPYSRC,APICTLARR
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  RecNotFnd             02     02
     D  ScanFnd               03     03
     D  SelOptn               11     11
     D  DepoName              12     12
     D  DepoRef               13     13
     D  ConfirmDel            14     14
     D  ReqInsert             15     15
     D  DepNamSrch            16     16
     D  OptnErr               20     20
     D  DpNamErr              21     21
     D  DpRefErr              22     22
     D  SFleClr               91     91
     D  Sfl1Active            92     92
     D  SFleNxtChg            93     93
     D  Sfl2Active            94     94
     D  SFleEnd               95     95
     D  RollUp                98     98
     D  NoSflChgRec           99     99
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Customer Depository Reference
     D PSecDetDS     E DS                  EXTNAME(SDSECDPD)
 
      ** Customer Depository Reference
     D PDepRefDS     E DS                  EXTNAME(SDCSDSPD)
     D                                     PREFIX(W)
 
      ** Customer Depository OK Indicators
     D PEDepRefDS    E DS                  EXTNAME(SDECSDRPD)
 
      ** Valid Customer Depository
     D PVDepRefDS    E DS                  EXTNAME(SDVCSDRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Work Message Id array
     D WkMsgArr        S                   LIKE(MsgIdArr)
     D                                     DIM(ArrayMax)
     D WkFldArr        S                   LIKE(FldNameArr)
     D                                     DIM(ArrayMax)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D WkSRRN          S              5  0
     D WkSRRN2         S              5  0
     D WLRcdNum        S              5  0
     D WkCnt           S              3  0
     D WkCnt2          S              3  0
     D WkAction        S              1A
     D EndOfSubFile    S              3  0
     D FirstPass       S              1A
     D PKeySts         S              7A
     D PCNum           S             10A
     D PMode           S              1A
     D DeleteReq       S              1A
     D InitFlag        S              1A
     D ReadRecFlg      S              1A
     D KDTCUST         S              6A
     D KDTDPSN         S             10A
     D KeyFlag         S              1A
     D WChgFlg         S              1A
     D WGotoCnf        S              1A
     D WVsbFlg         S              1A
     D WEnqOnly        S              1A
     D WNotEnq         S              1A
     D WEndRPR         S              1A
     D WNoTran         S              1A
 
     D PDepNam         S             10A
     D PClasftn        S              1A
     D PDepRef         S             20A
     D PRespMode       S              1A
     D PRunMode        S              3A
 
     D PZMsgPgm        S             10A
     D PZMsgMod        S             10A
     D PZMsgProc       S             10A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WkIdx           S              3P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialisation routine
 
     C                   IF        InitFlag <> *ON
     C                   EXSR      SRInit
     C                   ENDIF
 
     C                   DOW       PMode = 'P'
 
      ** Perform subfile processing
 
     C                   EXSR      SRProSfl
 
     C                   ENDDO
 
     C                   DOW       PMode = 'E'
 
      ** Perform empty subfile processing
 
     C                   EXSR      SREmpSfl
 
     C                   ENDDO
 
     C                   IF        PMode = 'C'
 
      ** Perform confirmation processing
 
     C                   EXSR      SRConfirm
 
     C                   ENDIF
 
     C                   IF        PMode = 'U'
 
      ** Perform update processing
 
     C                   EXSR      SRUpdate
 
     C                   ENDIF
 
     C                   IF        PMode = 'T'
 
      ** Return to calling program
 
     C                   EVAL      InitFlag = *OFF
     C                   CLOSE     SDCSX1PD
     C                   RETURN
 
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialization processing                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Access SDCUSTPD to retrieve security customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DDCUSN        PCNum
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      #1CUSN = BBCUST
     C                   EVAL      #1CSSN = BBCSSN
     C                   EVAL      #1CRNM = BBCRNM
     C                   EVAL      #1CRTN = BBCRTN
 
     C                   EVAL      PMode = 'P'
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      EndOfSubFile = 12
     C                   EVAL      InitFlag = *ON
     C                   EVAL      ReadRecFlg = *OFF
     C                   OPEN      SDCSX1PD
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Perform subfile build processing
 
     C                   IF        PRunMode = 'SIN'
     C                   EXSR      SRBldSfl
     C                   ELSE
     C                   EXSR      SRBldSfl2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile Processing                           *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** If first time in
 
     C                   IF        FirstPass = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SDCSDRC1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = *OFF
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN = WLRcdNum
     C                   EVAL      WkAction = ' '
 
      ** Read record for subfile processing.
 
     C                   IF        ReadRecFlg = *OFF
     C                   EXSR      SRReadRec
     C                   EVAL      ReadRecFlg = *ON
     C                   ENDIF
 
      ** Read temporary file PF/SDCSX1PD
 
     C                   IF        KeyFlag <> 'Y'
     C     *LOVAL        SETLL     SDCSX1PD
     C                   ELSE
     C     Key02         SETGT     SDCSX1PD
     C                   ENDIF
     C                   READ      SDCSX1PD                               01
 
      ** Setup field (amendable or protected)
 
     C                   SELECT
 
      ** Insert
 
     C                   WHEN      ActionCode = 'I'
     C                   EVAL      WVsbFlg = 'I'
     C                   EXSR      SRFldVsb
 
      ** Amend
 
     C                   WHEN      ActionCode = 'A'
     C                   EVAL      WVsbFlg = 'A'
     C                   EXSR      SRFldVsb
 
      ** Delete
 
     C                   WHEN      ActionCode = 'D'
     C                   EVAL      WVsbFlg = 'D'
     C                   EXSR      SRFldVsb
 
      ** Enquire
 
     C                   WHEN      ActionCode = 'E'
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
 
     C                   ENDSL
 
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkCnt < EndOfSubfile AND EndOfFile = *OFF
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN = WkSRRN + 1
 
      ** Format subfile fields
 
     C                   EVAL      #1OPTN = *BLANK
     C                   EVAL      #1DPNU = DTDPOT
     C                   EVAL      #1DPNM = DTDPSN
     C                   EVAL      #1DPRF = DTREFN
     C                   EVAL      #1DREF = #1DPRF
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN        #1SFRN
     C                   WRITE     SDCSDRS1
     C                   EVAL      KDTCUST = DDCUSN
     C                   EVAL      KDTDPSN = #1DPNM
 
      ** Read temporary file PF/SDCSX1PD
 
     C                   READ      SDCSX1PD                               01
 
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = *OFF
     C     Key02         READPE    SDCSX1PD                               01
     C                   ELSE
     C                   EVAL      SFleEnd = *ON
     C                   ENDIF
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN        WLRcdNum
 
     C                   IF        WkCnt = 0
 
     C                   IF        ActionCode = 'I'
     C                   EVAL      PMode = 'E'
     C                   EVAL      FirstPass = 'Y'
 
      ** Perform subfile initialisation processing
 
     C                   EXSR      SRIntSfl
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A' or ActionCode = 'E'
     C                   EVAL      MsgIdArr(1) = 'USR9115'
     C                   EVAL      FldNameArr(1) = '*ANY'
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN
     C                   Z-ADD     1             #1SFRN
     C                   CLEAR                   #1DPNU
     C                   CLEAR                   #1DPNM
     C                   CLEAR                   #1DPRF
     C                   CLEAR                   #1DREF
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
     C                   IF        ActionCode = 'A'                                           240346
     C                   EVAL      ReqInsert  = *ON
     C                   ENDIF                                                                240346
     C                   WRITE     SDCSDRS1
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - Build Subfile Processing for repair.              *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
 
      ** If first time in
 
     C                   IF        FirstPass = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SDCSDRC1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = *OFF
     C                   EVAL      WEndRPR = 'N'
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN = WLRcdNum
 
      ** Read invalids file LF/SDICSDRL1
 
     C     DDCUSN        SETLL     SDICSDRL1
     C     DDCUSN        READE     SDICSDRL1                              01
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file
 
     C                   DOW       EndOfFile = *OFF
 
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN = WkSRRN + 1
 
      ** Access SDCUSTPD to retrieve security customer details
 
     C                   EVAL      PCNum = IDDDPOT
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '       '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCNum
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        @RtCd = *BLANKS
 
      ** Format subfile fields
 
     C                   EVAL      #1OPTN = *BLANK
     C                   EVAL      #1DPNU = BBCUST
     C                   EVAL      #1DPNM = BBCSSN
     C                   EVAL      #1DPRF = IDDREFN
     C                   EVAL      #1DREF = *BLANKS
     C                   EVAL      #1ACTN = IDDACTN
 
     C                   ELSE
 
     C                   IF        IDDACTN <> 'I'
     C                   EVAL      WEndRPR = 'Y'
     C                   ENDIF
     C                   EVAL      DpNamErr = *ON
     C                   EVAL      #1OPTN = *BLANK
     C                   EVAL      #1DPNU = IDDDPOT
     C                   EVAL      #1DPNM = IDDDPOT
     C                   EVAL      #1DPRF = IDDREFN
     C                   EVAL      #1DREF = *BLANKS
     C                   EVAL      #1ACTN = IDDACTN
     C                   ENDIF
 
      ** Setup field (amendable or protected)
 
     C                   SELECT
 
      ** Insert
 
     C                   WHEN      IDDACTN = 'I'
     C                   EVAL      WNotEnq = 'Y'
     C                   EVAL      WVsbFlg = 'I'
     C                   EXSR      SRFldVsb
 
      ** Amend
 
     C                   WHEN      IDDACTN = 'A'
     C                   EVAL      WNotEnq = 'Y'
     C                   EVAL      WVsbFlg = 'A'
     C                   EXSR      SRFldVsb
 
      ** Delete
 
     C                   WHEN      IDDACTN = 'D'
     C                   EVAL      #1OPTN = 'D'
     C                   EVAL      WNotEnq = 'Y'
     C                   EVAL      WVsbFlg = 'D'
     C                   EXSR      SRFldVsb
 
      ** Enquire
 
     C                   WHEN      IDDACTN = 'E'
     C                   EVAL      WEnqOnly = 'Y'
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
 
     C                   ENDSL
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN        #1SFRN
     C                   EVAL      SFleNxtChg = *ON
     C                   WRITE     SDCSDRS1
 
      ** Read invalids file LF/SDICSDRL1
 
     C     DDCUSN        READE     SDICSDRL1                              01
 
     C                   ENDDO
 
     C                   IF        WKCnt <= EndOfSubfile
     C                   EVAL      SFleEnd = *ON
     C                   ELSE
     C                   EVAL      SFleEnd = *OFF
     C                   ENDIF
 
     C                   EVAL      SFleNxtChg = *OFF
 
 
     C                   IF        WkCnt = 0
 
     C                   EVAL      WNoTran = 'Y'
     C                   EVAL      MsgIdArr(1) = 'USR9119'
     C                   EVAL      FldNameArr(1) = '*ANY'
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN
     C                   Z-ADD     1             #1SFRN
     C                   CLEAR                   #1DPNU
     C                   CLEAR                   #1DPNM
     C                   CLEAR                   #1DPRF
     C                   CLEAR                   #1DREF
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
     C                   WRITE     SDCSDRS1
 
     C                   ELSE
 
     C                   IF        WEnqOnly <> 'Y' AND WNotEnq = 'Y'
     C                   EXSR      SRValSfl
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReadRec - Read record for subfile processing                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadRec     BEGSR
 
      ** Read record from LF/SDCSDRL0
 
     C     DDCUSN        SETLL     SDCSDRL0
     C     DDCUSN        READE     SDCSDRL0                               01
 
     C                   DOW       EndOfFile = *OFF
 
      ** Access SDCUSTPD to retrieve security customer details
 
     C                   IF        EndOfFile = *OFF
 
     C                   EVAL      PCNum = DRDPOT
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCNum
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      DTCUST = DDCUSN
     C                   EVAL      DTDPOT = DRDPOT
     C                   EVAL      DTDPSN = BBCSSN
     C                   EVAL      DTREFN = DRREFN
 
     C                   WRITE     SDCSXXD0
 
     C                   ENDIF
 
      ** Read record from LF/SDCSDRL0
 
     C     DDCUSN        READE     SDCSDRL0                               01
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProSfl - Main Subfile Processing                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRProSfl      BEGSR
 
     C                   IF        PRunMode = 'RPR'
     C                   EVAL      ReqInsert  = *OFF
     C                   EVAL      WkSRRN = 1
     C                   EVAL      #1SFRN = 1
     C                   IF        WEndRPR = 'Y'
 
      ** Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      ** first by the user
 
     C                   Eval      WkFldArr = *BLANKS
     C                   Eval      WkMsgArr = *BLANKS
     C                   MOVEA     FldNameArr    WkFldArr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     WkFldArr      FldNameArr(2)
     C                   MOVEA     MsgIdArr      WkMsgArr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     WkMsgArr      MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   WRITE     SDCSDRF0
     C                   EVAL      Sfl1Active = *ON
     C                   EVAL      Sfl2Active = *OFF
     C                   WRITE     SDCSDRC3
     C                   EXFMT     SDCSDRC1
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      ReturnCode = 'SDA0002'
     C                   EVAL      PMode = 'T'
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      ReturnCode = 'SDA0003'
     C                   EVAL      PMode = 'T'
 
      ** F9 Pressed
 
     C                   WHEN      *INKI = *ON
     C                   EVAL      PMode = 'E'
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRIntSfl
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = *ON
     C                   IF        PRunMode = 'SIN'
     C                   EVAL      KeyFlag = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
 
     C                   OTHER
     C                   IF        ActionCode <> 'E' OR WEndRPR <> 'Y' OR
     C                             WNoTran <> 'Y'
     C                   EXSR      SRValSfl
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREmpSfl - Empty Subfile Processing                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREmpSfl      BEGSR
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   WRITE     SDCSDRF0
     C                   EVAL      Sfl1Active = *ON
     C                   EVAL      Sfl2Active = *OFF
     C                   WRITE     SDCSDRC3
     C                   EXFMT     SDCSDRC1
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      ReturnCode = 'SDA0002'
     C                   EVAL      PMode = 'T'
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      PMode = 'P'
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = *ON
     C                   EXSR      SRIntSfl
 
     C                   OTHER
     C                   EVAL      WkAction = 'I'
     C                   EXSR      SRValSfl
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIntSfl - Initialise Subfile Processing                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRIntSfl      BEGSR
 
      ** If first time in then build subfile
 
     C                   IF        FirstPass = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SDCSDRC1
     C                   EVAL      SFleClr = *OFF
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = *OFF
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Setup screen indicators
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN = WLRcdNum
     C                   EVAL      WVsbFlg = 'I'
     C                   EXSR      SRFldVsb
     C                   EVAL      OptnErr = *OFF
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
 
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkCnt < EndOfSubfile
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN = WkSRRN + 1
 
     C                   CLEAR                   #1DPNU
     C                   CLEAR                   #1DPNM
     C                   CLEAR                   #1DPRF
     C                   CLEAR                   #1DREF
     C                   Z-ADD     WkSRRN        #1SFRN
     C                   WRITE     SDCSDRS1
 
     C                   ENDDO
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN        WLRcdNum
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValSfl - Validate Subfile Processing                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValSfl      BEGSR
 
     C                   IF        PRunMode = 'RPR' AND WEndRPR = 'Y'
     C                   GOTO      EndVal
     C                   ENDIF
 
      ** Check if Depot Name Search is used.
 
     C                   IF        ActionCode = 'A' AND #1DNAM <> *BLANK
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      KDTCUST = DDCUSN
     C                   EVAL      KDTDPSN = #1DNAM
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      PMode = 'P'
     C                   GOTO      EndVal
     C                   ELSE
     C                   EVAL      KeyFlag = 'N'
     C                   ENDIF
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SDCSDRC2
     C                   EVAL      SFleClr = *OFF
 
      ** Process validation of fields
 
      ** Read subfile
 
     C                   EVAL      WkIdx  = 0
     C                   EVAL      WkCnt2 = 1
     C                   EVAL      DeleteReq = 'N'
     C                   EVAL      WkSRRN = 1
     C                   EVAL      WkSRRN2 = 1
     C                   READC     SDCSDRS1                               01
 
     C                   IF        PRunMode = 'SIN'
 
     C                   IF        EndOfFile = *ON
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      PMode = 'P'
     C                   GOTO      EndVal
     C                   ENDIF
 
     C                   IF        WkAction = 'I'
     C                   EVAL      WDDACTN = WkAction
     C                   ELSE
     C                   EVAL      WDDACTN = ActionCode
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WDDCUST = DDCUSN
     C                   EVAL      WGotoCnf = *OFF
 
     C                   DOW       EndOfFile = *OFF
 
     C                   EVAL      WChgFlg = 'N'
     C                   IF        WkAction = 'I'  OR #1ACTN = 'I'
 
     C     '?'           SCAN      #1DPNM                                 03
 
     C                   IF        ScanFnd = True
     C                   EVAL      WDDDPOT = #1DPNM
     C                   ELSE
 
      ** Access SDCUSTPD to retrieved customer details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '       '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    #1DPNM
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      WDDDPOT = #1DPNM
     C                   ELSE
     C                   EVAL      WDDDPOT = BBCUST
     C                   EVAL      #1DPNU  = BBCUST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WDDDPOT = #1DPNU
     C                   ENDIF
     C                   EVAL      WDDREFN = #1DPRF
 
     C                   SELECT
 
     C                   WHEN      #1OPTN = *BLANK AND #1DREF = *BLANKS OR
     C                             #1OPTN = *BLANK AND #1DPRF <> #1DREF
 
     C                   IF        PRunMode = 'RPR'
     C                   EVAL      WDDACTN = #1ACTN
     C                   ENDIF
 
     C                   EVAL      WGotoCnf = *ON
 
      ** Call validation module to validate details
 
     C                   CALLB     'SDCDRFVAL'
 
      ** Input
      ** ======
      ** Response Mode
      ** Customer Depository Reference
      ** Securities Client Details
 
     C                   PARM                    PRespMode
     C                   PARM                    PDepRefDS
     C                   PARM                    PSecDetDs
 
      ** Output
      ** ======
      ** Customer Depository OK Indicators
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PEDepRefDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Valid Customer Depository
 
     C                   PARM                    PVDepRefDS
 
      ** Update error indicators
 
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
     C                   IF        WkAction = 'I' AND DSDPOT <> *BLANKS OR
     C                             #1ACTN = 'I' AND DSDPOT <> *BLANKS
     C                   EVAL      #1DPNM = DSDPOT
     C                   EVAL      #1DPNU = DSDPOT
     C                   ENDIF
     C                   EVAL      #1DPRF = DSREFN
     C                   SELECT
     C                   WHEN      DDDPOTOK = 'N'
     C                   EVAL      DpNamErr = *ON
     C                   IF        PRunMode = 'RPR' AND #1ACTN <> 'I'
     C                   EVAL      WEndRPR = 'Y'
     C                   ENDIF
     C                   WHEN      DDREFNOK = 'N'
     C                   EVAL      DpRefErr = *ON
     C                   ENDSL
 
      ** Move MsgIdArr to WkMsgArr if idx <> 1
 
     C                   IF        Idx <> 0
     C                   IF        WkAction = 'I'
     C                   EVAL      #1DPNM = WDDDPOT
     C                   ENDIF
     C                   EVAL      #1DPRF = WDDREFN
     C                   EVAL      WkMsgArr(WkCnt2) = MsgIdArr(Idx)
     C                   EVAL      WkFldArr(WkCnt2) = FldNameArr(Idx)
     C                   EVAL      WkCnt2 = WkCnt2 + 1
     C                   EVAL      WkIdx = WkIdx + Idx
     C                   ENDIF
 
     C                   WHEN      #1OPTN = 'D'
 
     C                   EVAL      WGotoCnf = *ON
     C                   EVAL      #2DPNU = #1DPNU
     C                   EVAL      #2DPNM = #1DPNM
     C                   EVAL      #2DPRF = #1DPRF
     C                   Z-ADD     WkSRRN2       #2SFRN
     C                   EVAL      SFleNxtChg = *ON
     C                   WRITE     SDCSDRS2
     C                   EVAL      SFleNxtChg = *OFF
     C                   EVAL      DeleteReq = 'Y'
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
 
      ** If option selected not equal to 'D' and not equal to blank
 
     C                   WHEN      #1OPTN <> 'D' AND #1OPTN <> *BLANK
 
     C                   EVAL      WkMsgArr(WkCnt2) = 'USR9114'
     C                   EVAL      WkFldArr(WkCnt2) = '*ANY'
     C                   EVAL      OptnErr = *ON
     C                   EVAL      WkCnt2 = WkCnt2 + 1
     C                   EVAL      WkIdx = WkIdx + 1
 
     C                   ENDSL
 
      ** Update record in subfile
 
     C                   EVAL      SFleNxtChg = *ON
     C                   UPDATE    SDCSDRS1
     C                   EVAL      SFleNxtChg = *OFF
 
     C                   EVAL      OptnErr = *OFF
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
 
      ** Read subfile
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   READC     SDCSDRS1                               01
 
     C                   ENDDO
 
     C                   EVAL      WkSRRN = 1
     C                   EVAL      #1SFRN = 1
 
     C                   IF        WkIdx = 0 AND WGotoCnf = *ON
 
      ** Continue to confirmation screen
 
     C                   EVAL      PMode = 'C'
 
     C                   ELSE
 
     C                   EVAL      OptnErr = *OFF
     C                   EVAL      DpNamErr = *OFF
     C                   EVAL      DpRefErr = *OFF
     C                   MOVEA     WkMsgArr      MsgIdArr
     C                   MOVEA     WkFldArr      FldNameArr
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Process subfile screen
 
     C                   IF        WkAction = 'I' AND PRunMode = 'SIN'
     C                   EVAL      PMode = 'E'
     C                   ELSE
     C                   EVAL      PMode = 'P'
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndVal        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConfirm - Confirmation Subfile Processing                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRConfirm     BEGSR
 
      ** Output delete confirmation if delete requested
 
     C                   IF        DeleteReq = 'Y'
 
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
     C                   EVAL      ConfirmDel = *ON
     C                   WRITE     SDCSDRF0
     C                   EVAL      Sfl1Active = *OFF
     C                   EVAL      Sfl2Active = *ON
     C                   IF        WkSRRN2 > EndOfSubfile
     C                   EVAL      SFleEnd = *OFF
     C                   ELSE
     C                   EVAL      SFleEnd = *ON
     C                   ENDIF
     C                   WRITE     SDCSDRC3
     C                   EVAL      #2SFRN = 1
     C                   EXFMT     SDCSDRC2
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      ReturnCode = 'SDA0002'
     C                   EVAL      PMode = 'T'
     C                   GOTO      EndConfirm
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = *ON
 
     C                   IF        PRunMode = 'SIN'
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      PMode = 'P'
     C                   ELSE
     C                   EVAL      ReturnCode = 'SDA0003'
     C                   EVAL      PMode = 'T'
     C                   ENDIF
 
     C                   GOTO      EndConfirm
 
     C                   WHEN      *INKJ = *ON
 
      ** Do delete updates
 
     C                   EXSR      SRDelUpdate
 
     C                   OTHER
     C                   GOTO      EndConfirm
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Confirm validated entries
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = *ON
     C                   WRITE     SDCSDRC2
     C                   EVAL      SFleClr = *OFF
 
      ** Read subfile
 
     C                   EVAL      WkSRRN = 1
     C                   EVAL      WkSRRN2 = 1
     C                   READC     SDCSDRS1                               01
 
     C                   DOW       EndOfFile = *OFF
 
     C                   IF        #1OPTN = *BLANK AND #1DPRF <> #1DREF OR
     C                             #1OPTN = *BLANK AND #1DREF = *BLANKS OR
     C                             #1OPTN = *BLANK AND PRunMode = 'RPR'
     C                   EVAL      #2DPNU = #1DPNU
     C                   EVAL      #2DPNM = #1DPNM
     C                   EVAL      #2DPRF = #1DPRF
     C                   Z-ADD     WkSRRN2       #2SFRN
     C                   EVAL      SFleNxtChg = *ON
     C                   WRITE     SDCSDRS2
     C                   EVAL      SFleNxtChg = *OFF
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   ENDIF
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   READC     SDCSDRS1                               01
 
     C                   ENDDO
 
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   EVAL      WVsbFlg = 'E'
     C                   EXSR      SRFldVsb
     C                   WRITE     SDCSDRF0
     C                   EVAL      Sfl1Active = *OFF
     C                   EVAL      Sfl2Active = *ON
     C                   IF        WkSRRN2 = 1
     C                   EVAL      PMode = 'T'
     C                   GOTO      EndConfirm
     C                   ENDIF
     C                   IF        WkSRRN2 > EndOfSubfile
     C                   EVAL      SFleEnd = *OFF
     C                   ELSE
     C                   EVAL      SFleEnd = *ON
     C                   ENDIF
     C                   EVAL      WMsgIDArr(1) = 'USR9116'
     C                   EVAL      WFldNamArr(1) = '*ANY'
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
     C                   WRITE     SDCSDRC3
     C                   EVAL      #2SFRN = 1
     C                   EXFMT     SDCSDRC2
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = *ON
     C                   IF        DeleteReq = 'Y'
     C                   ROLBK
     C                   ENDIF
     C                   EVAL      ReturnCode = 'SDA0002'
     C                   EVAL      PMode = 'T'
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = *ON
 
     C                   IF        DeleteReq = 'Y'
     C                   ROLBK
     C                   ENDIF
     C                   IF        PRunMode = 'SIN'
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      PMode = 'P'
     C                   ELSE
     C                   EVAL      ReturnCode = 'SDA0003'
     C                   EVAL      PMode = 'T'
     C                   ENDIF
 
 
     C                   OTHER
 
      ** Do updates
 
     C                   EVAL      PMode = 'U'
 
     C                   ENDSL
 
     C     EndConfirm    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelUpdate - Delete update file Processing                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDelUpdate   BEGSR
 
     C                   EVAL      WkSRRN2 = 1
     C                   READC     SDCSDRS2                               01
     C                   DOW       EndOfFile = *OFF
     C                   EVAL      WDDDPOT = #2DPNU
     C     Key01         CHAIN     SDCSDRL0                           02
     C                   IF        RecNotFnd = *OFF
     C                   DELETE    SDCSDRD0
     C                   ELSE
     C                   EVAL      DBKEY = WDDCUST + WDDDPOT
     C                   EVAL      DBFILE = 'SDCSDRL0'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   READC     SDCSDRS2                               01
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update to file Processing                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      WkSRRN2 = 1
     C                   READC     SDCSDRS2                               01
     C                   DOW       EndOfFile = *OFF
     C                   EVAL      WDDDPOT = #2DPNU
     C     Key01         CHAIN     SDCSDRL0                           02
     C                   IF        RecNotFnd = *OFF
 
      ** Amend
 
     C                   EVAL      DRCUST = WDDCUST
     C                   EVAL      DRDPOT = #2DPNU
     C                   EVAL      DRREFN = #2DPRF
     C                   UPDATE    SDCSDRD0
     C                   ELSE
 
      ** Insert
 
     C                   EVAL      DRCUST = WDDCUST
     C                   EVAL      DRDPOT = #2DPNU
     C                   EVAL      DRREFN = #2DPRF
     C                   WRITE     SDCSDRD0
     C                   ENDIF
     C                   READC     SDCSDRS2                               01
     C                   ENDDO
 
     C                   EVAL      PMode = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrMsg - Clear message subfile and data                     *
      *                                                               *
      * Called by: SRInit, SRProSfl, SREmpSfl, SRConfirm              *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRClrMsg      BEGSR
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WkMsgArr
     C                   CLEAR                   WkFldArr
     C                   EVAL      Idx = 0
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFldVsb - Format field visibility                            *
      *                                                               *
      * Called by: SRInit, SRProSfl, SREmpSfl                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFldVsb      BEGSR
 
     C                   SELECT
 
     C                   WHEN      WVsbFlg = 'I'
 
      ** Enable depot name and depot reference field for insert
 
     C                   EVAL      SelOptn    = *OFF
     C                   EVAL      DepoName   = *ON
     C                   EVAL      DepoRef    = *ON
     C                   EVAL      ConfirmDel = *OFF
     C                   EVAL      ReqInsert  = *OFF
     C                   EVAL      DepNamSrch = *OFF
 
     C                   WHEN      WVsbFlg = 'A'
 
      ** Enable depot reference for amendment and F9 (insert)
 
     C                   EVAL      SelOptn    = *ON
     C                   EVAL      DepoName   = *OFF
     C                   EVAL      DepoRef    = *ON
     C                   EVAL      ConfirmDel = *OFF
     C                   EVAL      ReqInsert  = *ON
     C                   EVAL      DepNamSrch = *ON
 
     C                   WHEN      WVsbFlg = 'D'
 
      ** Protect all fields and enable F10 (confirm delete)
 
     C                   EVAL      SelOptn    = *OFF
     C                   EVAL      DepoName   = *OFF
     C                   EVAL      DepoRef    = *OFF
     C                   EVAL      ConfirmDel = *ON
     C                   EVAL      ReqInsert  = *OFF
     C                   EVAL      DepNamSrch = *OFF
 
     C                   WHEN      WVsbFlg = 'E'
 
      ** Protect all fields
 
     C                   EVAL      SelOptn    = *OFF
     C                   EVAL      DepoName   = *OFF
     C                   EVAL      DepoRef    = *OFF
     C                   EVAL      ConfirmDel = *OFF
     C                   EVAL      ReqInsert  = *OFF
     C                   EVAL      DepNamSrch = *OFF
 
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP2
 
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
 
      ** Input
      ** ======
      ** Action Code
      ** Securities Client Details
      ** Return Code
      ** Run Mode
 
     C                   PARM                    ActionCode
     C                   PARM                    PSecDetDs
     C                   PARM                    ReturnCode
     C                   PARM                    PRunMode
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1RUNA = BJMRDT
 
      ** Set up constant parameters for sending/clearing messages
 
     C                   EVAL      PZMsgPgm = PSProcPgm
     C                   EVAL      PZMsgMod = PSProcMod
     C                   EVAL      PZMsgProc = PSProcName
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'SD'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Message subfile control and program queue initialisation.
 
     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #3PGMQ = '*'
 
      ** Keylist for accessing SDCSDRL0.
 
     C     Key01         KLIST
     C                   KFLD                    WDDCUST
     C                   KFLD                    WDDDPOT
 
      ** Keylist for accessing SDCSX1PD.
 
     C     Key02         KLIST
     C                   KFLD                    KDTCUST
     C                   KFLD                    KDTDPSN
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
