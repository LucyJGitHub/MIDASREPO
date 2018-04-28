     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SE Invalid securities browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSRPB - Invalid Securities Browse                        *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Securities for        *
      *              selection                                        *
      *            - picks off the selection made                     *
      *                                                               *
      *  Component of: SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL032             Date 05Jul04               *
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSC022             Date 24Feb04               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 27Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      *                 186611             Date 21Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE037 - Countervalue rounding                               *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *         - Recompiled.                                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  186611 - API Repair Queues : Review Delete Operation.        *
      *                                                               *
      *           To distinguish 'Delete' in Repair Queues between    *
      *                                                               *
      *              - Delete by action code 'Q' (Module 'RPB')       *
      *                (Message Refused by Midas)                     *
      *           and                                                 *
      *              - Delete after Main File updated (Module 'RPR')  *
      *                (Message Accepted by Midas)                    *
      *                                                               *
      *           Send a User Defined Journal Entry for the Invalid   *
      *           File and ensure Action Code is set to 'D'. So,      *
      *           Front Office system will receive a return message   *
      *           for Invalid File(s) ONLY when Message is refused    *
      *           by Midas.                                           *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FSESECSRDF CF   E             WORKSTN
     F                                     SFILE(SEISECSS0:W_Rrn)
      *
      ** Security details by timestamp & front office id
      ** - for record retrieval
     FSEISECSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEISECSD0:SEISECSX0)
     F                                     PREFIX(S:2)
      *
      ** Security details by front office ID & timestamp
      ** - for record update
     FSEISECSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S:2)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File by Type/FO ID/Timestamp                                         CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *
     F/COPY WNCPYSRC,SESECSPF01
     FSEISELX2L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     FSEISELX5L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
     FSEISELX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
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
      ** Array containing messages
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *
     D InvTr         E DS                  EXTNAME(SEISECSPD)
     D                                     PREFIX(S:2)
     D InvTrReg      E DS                  EXTNAME(SESERXPD)                                  CER001
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
                                                                                              CSC011
      ** SC24x7 Status Data Area                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
      ** DS for Access Programs                                                               CSC022
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for SAR Detail record                                                             CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
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
     D W_Err           S              1P 0
      *
      ** Work variables
     D W_Rrn           S              5P 0
     D W_Cnt           S              3P 0
 
     D DDBRSN          S              3A
     D SAFRT           S             20A
      *
      ** Invalid File names
     D InvFile1        S             10A
     D InvFile2        S             10A
     D InvFile3        S             10A
      *
      ** Invalid File Data
     D*InvFDta1********S           2000A                                                      CFT014
     D*InvFDta2********S           2000A                                                      CFT014
     D*InvFDta3********S           2000A                                                      CFT014
     D InvFDta1        S           4000A                                                      CFT014
     D InvFDta2        S           4000A                                                      CFT014
     D InvFDta3        S           4000A                                                      CFT014
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
      ** Parameters for SDRTVTXT
     D PMSGDNB         S              7A
     D PMSGNM          S             10A
     D PMSGTXT         S             80A
 
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
 
     D BJMRDT          S              7A
     D BJSBRC          S              3A
 
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PSecsSel        S             10A
     D PFOTranSel      S             20A
 
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S               Z                                                      CSC011
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *
     D ULX610          S              1A                                                      CER001
     D ULX004          S              1A                                                      CER001
     D ULX043          S              1A                                                      CER001
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
      ** Initialisation
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
      *                                                                                       CER001
      ** Close open files                                                                     CER001
      *                                                                                       CER001
     C                   IF        ULX610   = 'Y'                                             CER001
     C                   EXSR      SRClsExt                                                   CER001
     C                   ENDIF                                                                CER001
      *
      ** Return
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
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SEISECSC0
     C                   EVAL      *IN97 = *OFF
      *
      ** If previous transaction was not successful due to
      ** Sscurity detail being updated by another workstation,
      ** then display message on screen.
      *
     C                   IF        PErrUp = 'Y'
     C                   EVAL      ErrorMesg = ErrorText(1)
     C                   ELSE
     C                   EVAL      ErrorMesg = *BLANKS
     C                   ENDIF
      *
      ** Write the select screen footer to the screen.
      *
     C                   WRITE     SEISECSF1
      *
      ** Set file pointer to start of file.
      *
     C     *LOVAL        SETLL     SEISECSX0
      *
      ** Read an invalid security detail from file.
      *
     C                   EXSR      SRRdISecs
      *
      ** If no records exist - set up an error message.
      ** Display message 'No invalid transactions present'
      ** and then terminate.
      *
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'SEA0310'
     C                   EVAL      *IN10 = *OFF
     C                   TIME                    STIME
     C                   EXFMT     SEISECSEND
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
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       EndOfFile = False AND W_Cnt < 15
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Write the invalid security detail to the subfile.
      *
     C                   EVAL      SOPTN = *BLANKS
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SEISECSS0
      *
      ** Read next invalid security detail.
      *
     C                   EXSR      SRRdISecs
     C                   ENDDO
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
      *
     C                   TIME                    STIME
     C                   WRITE     SEISECSC0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
      *
     C                   READ      SEISECSC0                              99
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
     C                   READC     SEISECSS0                              99
      *
      ** Validate repair option code.
      *
     C                   IF        *IN99 = *OFF
     C                   EXSR      SRValidOpt
     C                   ENDIF
      *
      ** If 'E' is input, enquire upon invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'E'
     C                   EVAL      PTmeStpSel = STMST
     C                   EXSR      SREnqInv
     C                   EVAL      SOPTN = *BLANKS
     C                   ENDIF
      *
      ** If 'Q' is input, prompt for deletion of invalid transaction.
      *
     C                   IF        *IN99 = *OFF AND SOPTN = 'Q'
     C                   EXSR      SRProM_Delt
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
     C                   EVAL      PSecsSel = SSESN
     C                   EVAL      PFOTranSel = SFRNT
     C                   EVAL      PTmeStpSel = STMST
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
     C                   PARM                    W_Err
      *
      ** Return error message for user not authorized then terminate.
      *
     C                   IF        W_Err = 1
     C                   EVAL      PErrms = 'FXM0292'
     C                   EVAL      *IN10 = *ON
     C                   TIME                    STIME
     C                   EXFMT     SEISECSEND
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
      *  SRRdISecs - Read an invalid Security detail                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRdISecs     BEGSR
      *
      ** Read the invalid records file.
      *
     C                   READ      SEISECSX0                              96
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
      ** Input
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
     C                   PARM      *BLANKS       DDBRSN
      *
      ** Standing data
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** Output
      ** ======
      *
      ** Function keys
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
     C     ZATRNKX0      CHAIN     SEISECSX0                          99
      *                                                                                       CER001
      ** Pass the invalid extension transaction details to the enquiry.                       CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
     C                   EXSR      SREnqExt                                                   CER001
     C                   ENDIF                                                                CER001
      *
     C                   CALLB     'ZAINVTRENQ'
      *                             ==========
      ** Input
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
     C                   PARM      *BLANKS       SAFRT
      *
      ** Timestamp
     C                   PARM                    STMST
      *
      ** Invalid file names
     C                   PARM      'SEISECSPD'   InvFile1
     C                   PARM                    InvFile2
     C                   PARM                    InvFile3
      *
      ** Invalid file data
     C                   PARM      InvTr         InvFDta1
     C                   PARM                    InvFDta2
     C                   PARM                    InvFDta3
      *
      ** Output
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
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SREnqExt - Read extension transacstions details              *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SREnqExt      BEGSR                                                                CER001
      *                                                                                       CER001
      ** Read IML extension file                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C     ZATRNKX0      CHAIN     SEISELX2L0                                                 CER001
     C                   EVAL      L4LXPORE = #4LXPORE                                        CER001
      *                                                                                       CER001
     C     ZATRNKX0      CHAIN     SEISELX5L0                                                 CER001
     C                   EVAL      L6LXSECT = %CHAR(#6LXSECT)                                 CER001
     C                   EVAL      L6LXROFC = #6LXROFC                                        CER001
     C                   EVAL      L6LXRATC = #6LXRATC                                        CER001
     C                   EVAL      L6LXIM93 = %CHAR(#6LXIM93)                                 CER001
     C                   EVAL      L6LXCLAT = %CHAR(#6LXCLAT)                                 CER001
     C                   EVAL      L6LXSUBR = #6LXSUBR                                        CER001
     C                   EVAL      L6LXLUSU = %CHAR(#6LXLUSU)                                 CER001
     C                   EVAL      L6LXVOTR = #6LXVOTR                                        CER001
     C                   EVAL      L6LXSECD = #6LXSECD                                        CER001
     C                   EVAL      L6LXSNCD = #6LXSNCD                                        CER001
     C                   EVAL      L6LXEEEM = #6LXEEEM                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Read IBLC extension file                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX043   = 'Y'                                             CER001
     C     ZATRNKX0      CHAIN     SEISELX1L0                                                 CER001
     C                   EVAL      L6LXQUOT = #6LXQUOT                                        CER001
     C                   ENDIF                                                                CER001
     C                   EVAL      InvFile2 = 'SESERXPD'                                      CER001
     C                   EVAL      InvFDta2 = InvTrReg                                        CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      *                                                               *
      *  SRProM_Delt - Read details of the selected subfile record    *
      *                for deletion                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRProM_Delt   BEGSR
      *
     C                   CALLB     'ZAINVTRDEL'
      *                             ==========
      *
      ** Input
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
     C                   PARM      *BLANKS       SAFRT
      *
      ** Timestamp
     C                   PARM                    STMST
      *
      ** Narrative & field content 1 - 9
     C                   PARM                    DDNAR1
     C                   PARM      SSESN         DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      SSRPN         DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      SISSR         DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM      SNMCY         DDFLD4
     C                   PARM                    DDNAR5
     C                   PARM      SSITP         DDFLD5
     C                   PARM                    DDNAR6
     C                   PARM      SINCS         DDFLD6
     C                   PARM      *BLANKS       DDNAR7
     C                   PARM      *BLANKS       DDFLD7
     C                   PARM      *BLANKS       DDNAR8
     C                   PARM      *BLANKS       DDFLD8
     C                   PARM      *BLANKS       DDNAR9
     C                   PARM      *BLANKS       DDFLD9
      *
      ** Output
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
     C                   MOVE      STMST         PTmeStpSel
     C     ZATRNKD0      CHAIN     SEISECSD0                          99
     C                   IF        *IN99 = *OFF
      *                                                                         186611
     C                   MOVE      'D'           SACTN                          186611
     C                   MOVEL     *BLANKS       EntryData                      186611
     C                   MOVEL     *BLANKS       FileName                       186611
     C                   CALL      'RPC1600'                                    186611
     C                   PARM      InvTr         EntryData      3000            186611
     C                   PARM      'SEISECSPD'   FileName         10            186611
      *                                                                         186611
     C                   DELETE    SEISECSD0
                                                                                              CSC011
      ** Delete the record from the APILOGPD file                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SESECS'                                        CSC011
     C                   EVAL      KFrntOffID = SFRNT                                         CSC011
     C                   EVAL      KTimeStamp = STMST                                         CSC011
                                                                                              CSC011
     C     KAPILOG       CHAIN     APILOGL0                           89                      CSC011
                                                                                              CSC011
     C                   IF        *IN89 = *Off                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESECSPC01
      *                                                                                       CER001
      ** Delete invalid extension record                                                      CER001
      *                                                                                       CER001
     C                   IF        ULX610  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Delete IML extension file                                                            CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
      *                                                                                       CER001
     C     ZATRNKDX      CHAIN     SEISELXD4                                                  CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEISELXD4                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     ZATRNKDX      CHAIN     SEISELXD6                                                  CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEISELXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Delete IBLC extension file                                                           CER001
      *                                                                                       CER001
     C                   IF        ULX043  = 'Y'                                              CER001
     C     ZATRNKDX      CHAIN     SEISELXDL                                                  CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEISELXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
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
      ** Clear output
      *
     C                   MOVE      *OFF          PINKC
     C                   MOVE      *BLANKS       PErrMs
     C                   MOVE      *BLANKS       POpSel
     C                   MOVE      *BLANKS       PAcSel
     C                   MOVE      *BLANKS       PSecsSel
     C                   MOVE      *BLANKS       PFOTranSel
      *
     C                   CLEAR                   PTmeStpSel
      *                                                                                       CER001
      ** Open LUX extension file                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX610   = 'Y'                                             CER001
      *                                                                                       CER001
      ** Open IML extension file                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C                   OPEN      SEISELX2L0                                                 CER001
     C                   OPEN      SEISELX5L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Open IBLC extension file                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX043   = 'Y'                                             CER001
     C                   OPEN      SEISELX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVTXT - Retrieve text narrative for transaction deletion  *
      *                                                               *
      *****************************************************************
      *
     C     SRRTVTXT      BEGSR
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMSGDNB
     C                   PARM      'ZZGBMSGF  '  PMSGNM
     C                   PARM      *BLANKS       PMSGTXT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRClsExt - close LUX extension file                          *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRClsExt      BEGSR                                                                CER001
      *                                                                                       CER001
      ** Close IML extension file                                                             CER001
      *                                                                                       CER001
     C                   IF        ULX004   = 'Y'                                             CER001
     C                   CLOSE     SEISELX2L0                                                 CER001
     C                   CLOSE     SEISELX5L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Close IBLC extension file                                                            CER001
      *                                                                                       CER001
     C                   IF        ULX043   = 'Y'                                             CER001
     C                   CLOSE     SEISELX1L0                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
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
      ** Input
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
      ** Standing data
      ** =============
      *
      ** SDBANK - midas run date
     C                   PARM                    BJMRDT
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** Output
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
     C                   PARM                    PSecsSel
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
      ** Switchable feature CSC011                                                            CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SDATE = BJMRDT
     C                   EVAL      SJOBNAME = PSJOBNAME
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Key list
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    SFRNT
     C                   KFLD                    PTmeStpSel
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    SFRNT
                                                                                              CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *                                                                                       CER001
     C     ZATRNKDX      KLIST                                                                CER001
     C                   KFLD                    PTmeStpSel                                   CER001
     C                   KFLD                    SFRNT                                        CER001
      *
      ** Format text for invalid transaction deletion function.
      *
      *
      ** Security Shortname
     C                   MOVEL     'APA1073'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR1
      *
      ** Security Report Name
     C                   MOVEL     'APA1074'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR2
      *
      ** Issuer
     C                   MOVEL     'APA1075'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR3
      *
      ** Nominal currency
     C                   MOVEL     'APA1076'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR4
      *
      ** Investment Type
     C                   MOVEL     'APA1077'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR5
      *
      ** Incomplete Indicator
     C                   MOVEL     'APA1078'     PMSGDNB
     C                   EXSR      SRRTVTXT
     C                   MOVEL     PMSGTXT       DDNAR6
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD             7                          CSC022
     C                   Parm      '*VERIFY'     @OPTN             7                          CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 1                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CER001
      * Access SAR details file to see if ULX610 is installed.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX610'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  <> *BLANKS And                                      CER001
     C                             @RTCD  <> '*NRF   '                                        CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 003                                              CER001
     C                   EVAL      DBKEY   = 'ULX610'                                         CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = *BLANKS                                          CER001
     C                   EVAL      ULX610  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX610  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX004 - BCL/CSSF Statutory Reporting                                                CER001
      *                                                                                       CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   IF        ULX610  = 'Y'                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @Rtcd   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      * Access SAR details file to see if ULX043 is installed.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  <> *BLANKS And                                      CER001
     C                             @RTCD  <> '*NRF   '                                        CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 002                                              CER001
     C                   EVAL      DBKEY   = 'ULX043'                                         CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = *BLANKS                                          CER001
     C                   EVAL      ULX043  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX043  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
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
(c) Misys International Banking Systems Ltd. 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
