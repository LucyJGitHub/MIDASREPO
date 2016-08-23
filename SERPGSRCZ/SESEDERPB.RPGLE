     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid security diary events browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDERPB - Invalid Security Diary Events Browse             *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Security Diary        *
      *              Events for selection                             *
      *            - picks off the selection made                     *
      *                                                               *
      *  Component of: SESEDERPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL031             Date 05Jul04               *
      *  Prev Amend No. BUG2064            Date 29May04               *
      *                 BUG2604            Date 18May04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL031 - Taxation of Savings Income                          *
      *  BUG2064 - Initialization of CSC022.                          *
      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    96         Use for chaining to file                        *
      *    98         Use for subfile manipulation                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSfl - Build the subfile for the browse screen           *
      *  SRRdsflR - Read details of the selected subfile record       *
      *  SRChAutn - Check for user authority if not multi-branching   *
      *  SRRdISede - Read an invalid Security detail                  *
      *  SRValidOpt - Validate Repair option code                     *
      *  SREnqInv - Enquire on invalid transaction                    *
      *  SRProMDelt - Read details of the selected subfile record     *
      *                for deletion                                   *
      *  SRInit - Initialisation                                      *
      *  SRRtvTxt - Retrieve text narrative for transaction deletion  *
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
      ** Browse screen
     FSESEDERPDFCF   E             WORKSTN
     F                                     SFILE(SESEDERPS0:WRrn)
      *
      ** Security details by timestamp & front office id
      ** - for record retrieval
     FSEISEDEL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEISEDED0:SEISEDEX0)
     F                                     PREFIX(S:2)
      *
      ** Security details by front office ID & timestamp
      ** - for record update
     FSEISEDEL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S:2)
     F                                     COMMIT
                                                                                              CSC011
      ** API invalid log file                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
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
      **    True       logical = *ON (for indcator processing)
      **    False      logical = *OFF (for indcator processing)
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
      * Array to hold Commitment Job Names                                                   BUG2604
     D CmtJobNArr      S             10A   DIM(10)                                           BUG2604
                                                                                             BUG2604
      ** Commitment Control Data Area                                                        BUG2604
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2604
     D  wComitJob              4    103                                                      BUG2604
                                                                                             BUG2604
      ** External DS for SAR details                                                         BUG2604
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG2604
                                                                                             BUG2604
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                  BUG2604
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG2604
                                                                                             BUG2604
     D InvTr         E DS                  EXTNAME(SEISEDEPD)
     D                                     PREFIX(S:2)
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
     D  EndOfFile             96     96
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Timestamp selected
     D PTmeStpSel      S             26Z
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Parameters for ZVACTU
     D ZACTN           S              1A
     D PErr            S              1P 0
      *
      ** Work variables
     D WRrn            S              5P 0
     D WCnt            S              3P 0
 
     D PBrSn           S              3A
     D PAFrt           S             20A
      *
      ** Invalid File names
     D InvFile1        S             10A
     D InvFile2        S             10A
     D InvFile3        S             10A
      *
      ** Invalid File Data
     D InvFDta1        S           4000A
     D InvFDta2        S           4000A
     D InvFDta3        S           4000A
      *
      ** Narratives and Field contents
     D DDNAR1          S             30A
     D DDNAR2          S             30A
     D DDNAR3          S             30A
     D DDNAR4          S             30A
     D DDNAR5          S             30A
     D DDNAR6          S             30A
     D DDNAR7          S             30A
     D DDNAR8          S             30A
     D DDNAR9          S             30A
 
     D DDFLD1          S             35A
     D DDFLD2          S             35A
     D DDFLD3          S             35A
     D DDFLD4          S             35A
     D DDFLD5          S             35A
     D DDFLD6          S             35A
     D DDFLD7          S             35A
     D DDFLD8          S             35A
     D DDFLD9          S             35A
      *
      ** Function keys
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
      *
      ** Parameters for SDRtvTxt
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
 
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
 
     D BJMRDT          S              7A
     D BJSBRC          S              3A
 
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PSdsnSel        S             10A
     D PSdedSel        S              6A
     D PSdetSel        S              2A
     D PFOTranSel      S             20A
                                                                                              CGL031
      ** Parameter for RPC1600                                                                CGL031
     D EntryData       S           3000A                                                      CGL031
     D FileName        S             10A                                                      CGL031
                                                                                              CSC011
      ** Define variable for enhancement CSC011                                               CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Work field for Message type                                                          CSC011
     D WMTYP           S                   LIKE(APMTYP)                                       CSC011
 
      ** Work variables forBUG2604                                                           BUG2604
     DBUG2604          S              1A   INZ('N')                                          BUG2604
     D wCommitSkip     S              1A   INZ('N')                                          BUG2604
     D CSC022          S              1A                                                     BUG2064
                                                                                             BUG2604
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
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Build subfile.
      *
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdsflR
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
      *  SRBldSfl - Build the subfile for the browse screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChAutn
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             WRrn
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESEDERPC0
     C                   EVAL      *IN97 = *OFF
      *
      ** If previous transaction was not successful due to
      ** Sscurity detail being updated by another workstation,
      ** then display message on screen.
      *
     C                   IF        PErrUp = 'Y'
     C                   EVAL      *IN61 = *ON
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C                   ENDIF
      *
      ** Write the select screen footer to the screen.
      *
     C                   WRITE     SESEDERPF0
      *
      ** Set file pointer to start of file.
      *
     C     *LOVAL        SETLL     SEISEDEX0
      *
      ** Read an invalid security detail from file.
      *
     C                   EXSR      SRRdISede
      *
      ** If no records exist - set up an error message.
      ** Display message 'No invalid transactions present'
      ** and then terminate.
      *
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'SEA0390'
     C                   EVAL      *IN10 = *OFF
     C                   TIME                    STIME
     C                   EXFMT     SESEDERPF1
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      ** Read records from the file into the subfile until a page
      ** has been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
      *
     C                   DOW       EndOfFile = False AND *IN98 = *ON
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             WCnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       EndOfFile = False AND WCnt < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WRrn
     C                   ADD       1             WCnt
      *
      ** Write the invalid security detail to the subfile.
      *
     C                   EVAL      SOPTN = *BLANKS
     C                   Z-ADD     WRrn          SSFRN
     C                   MOVE      STMST         SSTMST
     C                   WRITE     SESEDERPS0
      *
      ** Read next invalid security detail.
      *
     C                   EXSR      SRRdISede
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   TIME                    STIME
     C                   WRITE     SESEDERPC0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      SESEDERPC0                             99
      *
      ** If F3, bypass further processing.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdsflR - Read details of the selected subfile record       *
      *                                                               *
      *****************************************************************
      *
     C     SRRdsflR      BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     *ON
     C     SOPTN         ORNE      *BLANKS
     C                   READC     SESEDERPS0                             99
      *
      ** Validate repair option code.
      *
     C                   IF        *IN99 = *OFF AND SOPTN <> *BLANKS
     C                   EXSR      SRValidOpt
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'E'
     C                   MOVE      SSTMST        PTmeStpSel
     C                   EXSR      SREnqInv
     C                   EVAL      SOPTN = *BLANKS
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'Q'
     C                   EXSR      SRProMDelt
     C                   EVAL      SOPTN = *BLANKS
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option, action and front office
      ** transaction id.
      *
     C                   IF        *IN99 <> *ON AND SOPTN <> *BLANKS
     C                   EVAL      POpSel= SOPTN
     C                   EVAL      PAcSel= SACTN
     C                   EVAL      PSdsnSel = SSDSN
     C                   EVAL      PSdedSel = SSDED
     C                   EVAL      PSdetSel = SSDET
     C                   EVAL      PFOTranSel = SFRNT
     C                   MOVE      SSTMST        PTmeStpSel
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChAutn - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRChAutn      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PErr
      *
      ** Return error message for user not authorized then terminate.
      *
     C                   IF        PErr = 1
     C                   EVAL      PErrms = 'FXM0292'
     C                   EVAL      *IN10 = *ON
     C                   TIME                    STIME
     C                   EXFMT     SESEDERPF1
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdISede - Read an invalid Security detail                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRdISede     BEGSR
      *
      ** Read the invalid records file.
      *
     C                   READ      SEISEDEX0                              96
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidOpt - Validate Repair option code                     *
      *                                                               *
      *****************************************************************
      *
     C     SRValidOpt    BEGSR
      *
     C                   CALLB     'ZAROPTVAL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Option code
     C                   PARM                    SOPTN
      *
      ** Front office id
     C                   PARM                    SFRNT
      *
      ** Booking branch
     C                   PARM      *BLANKS       PBrSn
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys.
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        PINKC = *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, continue with next option.
      *
     C                   IF        PINKL = *ON
     C                   MOVEL     *BLANKS       SOPTN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnqInv - Enquire on invalid transaction                    *
      *                                                               *
      *****************************************************************
      *
     C     SREnqInv      BEGSR
      *
      ** Pass the invalid transaction details to the enquiry.
      *
     C     ZATRNKX0      CHAIN     SEISEDEX0                          99
      *
     C                   CALLB     'ZAINVTRENQ'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action code
     C                   PARM                    SACTN
      *
      ** Front office Id
     C                   PARM                    SFRNT
      *
      ** Associated front office transaction id
     C                   PARM      *BLANKS       PAFrt
      *
      ** Timestamp
     C                   PARM                    SSTMST
      *
      ** Invalid file names
     C                   PARM      'SEISEDEPD'   InvFile1
     C                   PARM                    InvFile2
     C                   PARM                    InvFile3
      *
      ** Invalid file data
     C                   PARM      InvTr         InvFDta1
     C                   PARM                    InvFDta2
     C                   PARM                    InvFDta3
      *
      ** OUTPUT
      ** ======
      *
      * Function keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        PINKC = *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProMDelt - Read details of the selected subfile record     *
      *               for deletion                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRProMDelt    BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *                             ==========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action code
     C                   PARM                    SACTN
      *
      ** Front office transaction id
     C                   PARM                    SFRNT
      *
      ** Associated front office transaction id
     C                   PARM      *BLANKS       PAFrt
      *
      ** Timestamp
     C                   PARM                    SSTMST
      *
      ** Narrative & field content 1 - 9
     C                   PARM                    DDNAR1
     C                   PARM      SSDSN         DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      SSDED         DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      SSDET         DDFLD3
     C                   PARM      *BLANKS       DDNAR4
     C                   PARM      *BLANKS       DDFLD4
     C                   PARM      *BLANKS       DDNAR5
     C                   PARM      *BLANKS       DDFLD5
     C                   PARM      *BLANKS       DDNAR6
     C                   PARM      *BLANKS       DDFLD6
     C                   PARM      *BLANKS       DDNAR7
     C                   PARM      *BLANKS       DDFLD7
     C                   PARM      *BLANKS       DDNAR8
     C                   PARM      *BLANKS       DDFLD8
     C                   PARM      *BLANKS       DDNAR9
     C                   PARM      *BLANKS       DDFLD9
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      *OFF          PINKC
     C                   PARM      *OFF          PINKJ
     C                   PARM      *OFF          PINKL
      *
      ** If F3, bypass further processing.
      *
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F10, delete invalid security detail.
      *
     C                   IF        PINKJ = *ON
     C                   MOVE      SSTMST        PTmeStpSel
     C     ZATRNKD0      CHAIN     SEISEDED0                          99
     C                   IF        *IN99 = *OFF
     C                   MOVE      'D'           SACTN                                        CGL031
     C                   MOVEL     *BLANKS       EntryData                                    CGL031
     C                   MOVEL     *BLANKS       FileName                                     CGL031
     C                   CALL      'RPC1600'                                                  CGL031
     C                   PARM      InvTr         EntryData                                    CGL031
     C                   PARM      'SEISEDEPD'   FileName                                     CGL031
     C                   DELETE    SEISEDED0
     C                   ENDIF
                                                                                              CSC011
      ** Also delete corresponding record in API standard log file                            CSC011
      ** if CSC011 is present and user is still in support system.                            CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      WMTYP = 'SESEDE'                                           CSC011
     C     KAPILOG       CHAIN     APILOGL0                           71                      CSC011
                                                                                              CSC011
      ** If record found                                                                      CSC011
     C     *IN71         IFEQ      '0'                                                        CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
     C                   COMMIT
     C                   EndIf                                                               BUG2604
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Clear output.
      *
     C                   MOVE      *OFF          PINKC
     C                   MOVE      *BLANKS       PErrMs
     C                   MOVE      *BLANKS       POpSel
     C                   MOVE      *BLANKS       PAcSel
     C                   MOVE      *BLANKS       PSdsnSel
     C                   MOVE      *BLANKS       PSdedSel
     C                   MOVE      *BLANKS       PSdetSel
     C                   MOVE      *BLANKS       PFOTranSel
      *
     C                   CLEAR                   PTmeStpSel
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTxt - Retrieve text narrative for transaction deletion  *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvTxt      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgDNb
     C                   PARM      'ZZGBMSGF  '  PMsgNm
     C                   PARM      *BLANKS       PMsgTxt
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
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Build subfile
     C                   PARM                    PBdSfl
      *
      ** Read subfile record
     C                   PARM                    PRdSfl
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas run date
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Action selected
     C                   PARM                    PAcSel
      *
      ** Securities selected
     C                   PARM                    PSdsnSel
      *
      ** Event Date selected
     C                   PARM                    PSdedSel
      *
      ** Event Type selected
     C                   PARM                    PSdetSel
      *
      ** Front office transaction id selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of transaction selected
     C                   PARM                    PTmeStpSel
      *
      ** Command key
     C                   PARM                    PINKC
                                                                                              CSC011
      ** CSC011 Enhancement                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
                                                                                              CSC011
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SDATE = BJMRDT
     C                   EVAL      SJOBNAME = PSJOBNAME
      *
      ** Key list.
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    SFRNT
     C                   KFLD                    PTmeStpSel
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    SFRNT
                                                                                              CSC011
      ** Key List for access to API standard log file                                         CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    WMTYP                                        CSC011
     C                   KFLD                    SFRNT                                        CSC011
     C                   KFLD                    PTmeStpSel                                   CSC011
                                                                                              CSC011
      ** Retrieve values held in data areas SC24X7 and SDSTAT                                 CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Format text for invalid transaction deletion function.
      *
      ** Security Shortname.
      *
     C                   MOVEL     'APA1073'     PMsgDNb
     C                   EXSR      SRRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR1
      *
      ** Event Date.
     C                   MOVEL     'APA1081'     PMsgDNb
     C                   EXSR      SRRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR2
      *
      ** Event Type.
     C                   MOVEL     'APA1082'     PMsgDNb
     C                   EXSR      SRRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR3
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Access SAR details file to determine if Commitment Control                          BUG2604
      ** Changes is switched on.                                                             BUG2604
      *                                                                                      BUG2604
     C                   CallB     'AOSARDR0'                                                BUG2604
     C                   Parm      *BLANKS       @RTCD                                       BUG2604
     C                   Parm      '*VERIFY'     @OPTN                                       BUG2604
     C                   Parm      'CSC022'      @SARD                                       BUG2604
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
                                                                                             BUG2604
     C                   If        @RTCD = *BLANKS                                           BUG2604
      *                                                                                      BUG2604
     C                   Eval      CSC022 = 'Y'                                              BUG2604
     C                   In        SCCMTJOB                                                  BUG2604
     C                   If        ComitNum > 0                                              BUG2604
      *                                                                                      BUG2604
      ** Check if Current Job exists in the Commitment Job Names                             BUG2604
      ** Data Area.                                                                          BUG2604
      *                                                                                      BUG2604
     C                   MoveA     wComitJob     CmtJobNArr                                  BUG2604
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                 BUG2604
     C                   If        *IN20                                                     BUG2604
     C                   Eval      wCommitSkip = 'Y'                                         BUG2604
     C                   EndIf                                                               BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   Else                                                                BUG2604
      *                                                                                      BUG2604
      ** Database error                                                                      BUG2604
      *                                                                                      BUG2604
     C                   If        @RTCD <> '*NRF'                                           BUG2604
     C     *LOCK         In        LDA                                                       BUG2604
     C                   Eval      DBKey = 'CSC022'                                          BUG2604
     C                   Eval      DBPgm = 'SESEDERPB'                                       BUG2604
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2604
     C                   Eval      DBase = 1                                                 BUG2604
     C                   Out       LDA                                                       BUG2604
     C                   ExSr      *PSSR                                                     BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
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
(c) Misys International Banking Systems Ltd. 2001
