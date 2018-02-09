     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements invalid browse')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMRPB - Invalid Trade Settlement Browse                  *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Trade Settlement      *
      *              Details for selection                            *
      *            - picks off the selection made                     *
      *                                                               *
      *  Component of: SETRSMRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      *                 CAP182  *CREATE    Date 12Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *             (Recompile)                                       *
      *  AR656294 - HATS issue (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
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
      *  SrBldSfl   - Build the subfile for the browse screen         *
      *  SrRdsflR   - Read details of the selected subfile record     *
      *  SrChAutn   - Check for user authority if not multi-branching *
      *  SrRdITrsm  - Read an invalid Trade Settlement Details        *
      *  SrValidOpt - Validate Repair option code                     *
      *  SrEnqInv   - Enquire on invalid transaction                  *
      *  SrProMDelt - Read details of the selected subfile record     *
      *               for deletion                                    *
      *  SrInit     - Initialisation                                  *
      *  SrRtvTxt   - Retrieve text narrative for trans deletion      *
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
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FSETRSMRPDFCF   E             WORKSTN
     F                                     SFILE(SETRSMRPS0:WRrn)
      *
      ** Trade Settlement details by timestamp & front office id
      ** - for record retrieval
     FSEITRSML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEITRSMD0:SEITRSMX0)
     F                                     PREFIX(S:2)
      *
      ** Trade Settlement details by front office ID & timestamp
      ** - for record update
     FSEITRSML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S:2)
     F                                     COMMIT
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
     D InvTr         E DS                  EXTNAME(SEITRSMPD)
     D                                     PREFIX(S:2)
     D  QQPAYI1      E                     EXTFLD(QQPAYI)                                     CGL029
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
     D PTRADSel        S              6A
     D PMVDTSel        S              6A
     D PFSETSel        S              1A
     D PREVESel        S              1A
     D PFOTranSel      S             20A
 
     D PACTN           S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     ISEITRSMX0                                                                               CGL029
     I              QQPAYI                      QQPAYI2                                       CGL029
     ISEITRSMD0                                                                               CGL029
     I              QQPAYI                      QQPAYI3                                       CGL029
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
     C                   EXSR      SrInit
      *
      ** Build subfile.
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** Read subfile record.
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SrRdsflR
     C                   ENDIF
      *
      ** Return.
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build the subfile for the browse screen           *
      *                                                               *
      *****************************************************************
      *
     C     SrBldSfl      BEGSR
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SrChAutn
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
     C                   WRITE     SETRSMRPC0
     C                   EVAL      *IN97 = *OFF
      *
      ** If previous transaction was not successful due to
      ** Settlement detail being updated by another workstation,
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
     C                   WRITE     SETRSMRPF0
      *
      ** Set file pointer to start of file.
      *
     C     *LOVAL        SETLL     SEITRSMX0
      *
      ** Read an invalid Trade Settlement detail from file.
      *
     C                   EXSR      SrRdITrsm
      *
      ** If no records exist - set up an error message.
      ** Display message 'No invalid transactions present'
      ** and then terminate.
      *
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'SEA0390'
     C                   EVAL      *IN10 = *OFF
     C                   TIME                    STIME
     C                   EXFMT     SETRSMRPF1
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
      ** Write the invalid Trade Settlement detail to the subfile.
      *
     C                   EVAL      SOPTN = *BLANKS
     C                   Z-ADD     WRrn          SSFRN
     C                   MOVE      STMST         SSTMST
     C                   WRITE     SETRSMRPS0
      *
      ** Read next invalid Trade Settlement Details.
      *
     C                   EXSR      SrRdITrsm
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   TIME                    STIME
     C                   WRITE     SETRSMRPC0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      SETRSMRPC0                             99
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
      *  SrRdsflR - Read details of the selected subfile record       *
      *                                                               *
      *****************************************************************
      *
     C     SrRdsflR      BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     *ON
     C     SOPTN         ORNE      *BLANKS
     C                   READC     SETRSMRPS0                             99
      *
      ** Validate repair option code.
      *
     C                   IF        *IN99 = *OFF AND SOPTN <> *BLANKS
     C                   EXSR      SrValidOpt
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'E'
     C                   MOVE      SSTMST        PTmeStpSel
     C                   EXSR      SrEnqInv
     C                   EVAL      SOPTN = *BLANKS
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'Q'
     C                   EXSR      SrProMDelt
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
     C                   EVAL      PTRADSel = STRDR
     C                   EVAL      PMVDTSel = SMVDT
     C                   EVAL      PFSETSel = SFSET
     C                   EVAL      PREVESel = SREVE
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
     C     SrChAutn      BEGSR
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
     C                   EXFMT     SETRSMRPF1
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
      *  SrRdITrsm - Read an invalid Trade Settlement                 *
      *                                                               *
      *****************************************************************
      *
     C     SrRdITrsm     BEGSR
      *
      ** Read the invalid records file.
      *
     C                   READ      SEITRSMX0                              96
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValidOpt - Validate Repair option code                     *
      *                                                               *
      *****************************************************************
      *
     C     SrValidOpt    BEGSR
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
      *  SrEnqInv - Enquire on invalid transaction                    *
      *                                                               *
      *****************************************************************
      *
     C     SrEnqInv      BEGSR
      *
      ** Pass the invalid transaction details to the enquiry.
      *
     C     ZATRNKX0      CHAIN     SEITRSMX0                          99
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
     C                   PARM      'I'           PACTN
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
     C                   PARM      'SEITRSMPD'   InvFile1
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
      *  SrProMDelt - Read details of the selected subfile record     *
      *               for deletion                                    *
      *                                                               *
      *****************************************************************
      *
     C     SrProMDelt    BEGSR
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
     C                   PARM      'I'           PACTN
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
     C                   PARM      STRDR         DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      SMVDT         DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      SFSET         DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM      SREVE         DDFLD4
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
      ** If F10, delete invalid Trade Settlement Details
      *
     C                   IF        PINKJ = *ON
     C                   MOVE      SSTMST        PTmeStpSel
     C     ZATRNKD0      CHAIN     SEITRSMD0                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SEITRSMD0
     C                   ENDIF
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SrInit        BEGSR
      *
      ** Clear output.
      *
     C                   MOVE      *OFF          PINKC
     C                   MOVE      *BLANKS       PErrMs
     C                   MOVE      *BLANKS       POpSel
     C                   MOVE      *BLANKS       PTRADSel
     C                   MOVE      *BLANKS       PMVDTSel
     C                   MOVE      *BLANKS       PFSETSel
     C                   MOVE      *BLANKS       PREVESel
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
      *  SrRtvTxt - Retrieve text narrative for transaction deletion  *
      *                                                               *
      *****************************************************************
      *
     C     SrRtvTxt      BEGSR
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
      ** Front office transaction id selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of transaction selected
     C                   PARM                    PTmeStpSel
      *
      ** Command key
     C                   PARM                    PINKC
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
      *
      *
      ** Format text for invalid transaction deletion function.
      *
      ** Trade Number
     C                   MOVEL     'APA0091'     PMsgDNb
     C                   EXSR      SrRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR1
      *
      ** Movement Date
     C                   MOVEL     'APA0084'     PMsgDNb
     C                   EXSR      SrRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR2
      *
      ** Full Settled
     C                   MOVEL     'APA1139'     PMsgDNb
     C                   EXSR      SrRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR3
      *
      ** Reversal Indicator
     C                   MOVEL     'APA1140'     PMsgDNb
     C                   EXSR      SrRtvTxt
     C                   MOVEL     PMsgTxt       DDNAR4
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
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
(c) Finastra International Limited 2003
