     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Invalid internal funding deals browse')       *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDRPB - Invalid Internal Funding Deals Browse            *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of invalid Internal Funding      *
      *              Deals for selection                              *
      *            - picks off the selection made                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041294           Date 19Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 261516             Date 15Aug09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CSC022             Date 24Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse                                *
      *  MD046248 - Finastra Rebranding                               *
      *  261516 - Front office Transaction ID and Associated Front    *
      *           Office Transaction ID is getting swapped when       *
      *           repairing in Invalid ABFUND deals. To retrieve the  *
      *           correct Associated Front Office ID from ABFUND      *
      *           Invalid File when repairing deal inserted via API.  *
      *           Incorporate fix 257694 done in DBA3 release for     *
      *           Midas Plus release 1.4.                             *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *           (Recompile)                                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CSC011 - 24X7 Midas Availability                             *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         Show user not authorised to browse to screen    *
      *    61         Error Message                                   *
      *                                                               *
      *    95         CHAIN Operation in ABFUNDX0                     *                       261516
      *    96         End of File                                     *
      *    97         Clear Subfile                                   *
      *    98         Rollup  Indicator                               *
      *    99         End of ReadC                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSfl  - Build subfile                                    *
      *  SRChkAut  - Check for user authority if not multi branching  *
      *  SREnqInv  - Enquire an Invalid Transaction                   *
      *  SRInit    - Initialise Fields                                *
      *  SRPromDel - Prompt for Deletion                              *
      *  SRRdIDeal - Read an Invalid Deal                             *
      *  SRRdSflR  - Read Subfile Record                              *
      *  SRValRpr  - Validate Repair Option Code                      *
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
 
      ** AB Invalid Internal Funding Deals Browse
     FABFUNDRPDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(ABFUNDRPS1:WkSRRN)
 
      ** AB Invalid Internal Funding Deals - Tstmp/FOID
     FABIFUNDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ABIFUNDD0:ABIFUNDX0)
 
      ** AB Invalid Internal Funding Deals - FOID/Tstmp
     FABIFUNDL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
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
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D InvTr         E DS                  EXTNAME(ABIFUNDPD)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Associated Front Office ID
     D DDFOASOCID      S             20A
 
      ** Parameters fpr ZVACTU
     D ZACTN           S              1A
     D PErr            S              1  0
 
      ** Entry Parameters
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PFoTranSel      S             20A
     D PFoAsocSel      S             20A
     D PTMESTPSEL      S             26Z
 
      ** Command Keys
     D PINKC           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
 
      ** SDBANKPD field
     D BJMRDT          S              7A
     D BJSBRC          S              3A
 
      ** Subfile Relative Record Number
     D WkSRRN          S              5  0
 
      ** Successfil Insert Deal Number
     D PSIDN           S              6A
 
      ** Parameters for calling access object
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Work Variables
     D WkEOF           S              1A
     D WkCnt           S              3  0
 
      ** Invalid File Names
     D PInvFile1       S             10A
     D PInvFile2       S             10A
     D PInvFile3       S             10A
 
      ** Invalid file data
     D PInvFDta1       S           4000A
     D PInvFDta2       S           4000A
     D PInvFDta3       S           4000A
 
     D MsgDNb          S              7A
     D MsgNm           S             10A
     D MsgTxt          S             80A
 
      ** Narratives Content 1 - 9
     D DDNAR1          S             30A
     D DDNAR2          S             30A
     D DDNAR3          S             30A
     D DDNAR4          S             30A
     D DDNAR5          S             30A
     D DDNAR6          S             30A
     D DDNAR7          S             30A
     D DDNAR8          S             30A
     D DDNAR9          S             30A
 
      ** Field Contents 1 - 9
     D DDFLD1          S             35A
     D DDFLD2          S             35A
     D DDFLD3          S             35A
     D DDFLD4          S             35A
     D DDFLD5          S             35A
     D DDFLD6          S             35A
     D DDFLD7          S             35A
     D DDFLD8          S             35A
     D DDFLD9          S             35A
 
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A                                                      CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   CSC011
                                                                                              CSC011
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
 
      ** Initialise fields
 
     C                   EXSR      SRInit
 
      ** Build Sub-file
 
     C                   IF        PBdSfl = 'Y'
     C                   EXSR      SRBldSfl
     C                   END
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflR
     C                   END
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation of Fields                             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
 
     C                   EVAL      PErrms = *Blanks
     C                   EVAL      POpSel = *Blanks
     C                   EVAL      PAcSel = *Blanks
     C                   EVAL      PFOTranSel = *Blanks
     C                   EVAL      PFOAsocSel = *Blanks
     C                   CLEAR                   PTMESTPSEL
     C                   EVAL      PINKC = '0'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRChkAut                                           *
      *            SRRdIDeal                                          *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** Check for user Authority to Browse if not multi-branching
 
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      WkSRRN = 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN97 = *On
     C                   WRITE     ABFUNDRPC1
     C                   EVAL      *IN97 = *Off
 
      **  Write the select screen footer to the screen.
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
 
     C     PErrUp        IFEQ      'Y'
     C                   EVAL      *IN61 = *ON
     C                   ELSE
     C                   EVAL      *IN61 = *OFF
     C                   ENDIF
 
     C                   WRITE     ABFUNDRPF0
 
      **  Set file pointer to start of file
 
     C     *LOVAL        SETLL     ABIFUNDL0
 
      * Read an Invalid Deal
 
     C                   EXSR      SRRdIDeal
 
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
 
     C                   IF        WkEOF = 'Y'
     C                   EVAL      PErrMs = 'ABM0565'
     C                   EVAL      *IN10 = *OFF
     C                   EXFMT     ABFUNDRPF1
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *On
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       WkEOF <> 'Y' and *IN98 = *On
 
      **  Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = 0
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C                   DOW       WkEOF <> 'Y' and WkCnt < 14
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             WkSRRN
     C                   ADD       1             WkCNT
 
      **  Write the invalid deal to the subfile.
 
     C                   EVAL      #1OPT = *Blanks
     C                   Z-ADD     WkSRRN        #1SFRN
     C                   MOVE      #1TMST        #1TMSP
     C                   WRITE     ABFUNDRPS1
 
      ** Read an invalid deal
 
     C                   EXSR      SRRdIDeal
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     ABFUNDRPC1
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      ABFUNDRPC1                             99
 
      **  If F3, bypass further processing.
 
     C                   IF        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSflR - Read Subfile Record                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRValRpr                                           *
      *            SREnqInv                                           *
      *            SRPromDel                                          *
      *                                                               *
      *****************************************************************
     C     SRRdSflR      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       *IN99 = *On or #1OPT <> *Blanks
     C                   READC     ABFUNDRPS1                             99
 
      ** Validate repair option code
 
     C                   IF        *IN99 = *Off and #1OPT <> *BLANKS
      *                                                                                       261516
     C                   MOVE      #1TMSP        PTMESTPSEL                                   261516
      *                                                                                       261516
      ** If record is found in Subfile, retrieve its correct                                  261516
      ** Asscoiated Front Office ID from ABFUND Invalid File                                  261516
      *                                                                                       261516
     C     ZATRNKX0      CHAIN     ABIFUNDX0                          95                      261516
     C                   IF        *IN95 = *Off                                               261516
     C                   MOVE      #1AFRT        RealAssocID      20                          261516
     C                   ENDIF                                                                261516
     C                   EXSR      SRValRpr
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid transaction
 
     C                   IF        *IN99 = *Off and #1OPT = 'E'
     C                   MOVE      #1TMSP        PTMESTPSEL
     C                   EXSR      SREnqInv
     C                   EVAL      #1OPT = *Blanks
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        *IN99 = *Off and #1OPT = 'Q'
     C                   EXSR      SRPromDel
     C                   EVAL      #1OPT = *Blanks
     C                   ENDIF
 
     C                   ENDDO
 
      **  Return the selected option, action, front office transaction ID
      **  and front office associated transaction ID
 
     C                   IF        *IN99 <> *On and #1OPT <> *Blanks
 
     C                   EVAL      POpSel = #1OPT
     C                   EVAL      PAcSel = #1ACTN
     C                   EVAL      PFOTranSel = #1FRNT
     C**********         EVAL      PFOAsocSel = #1AFRT                                        261516
     C                   EVAL      PFOAsocSel = RealAssocID                                   261516
     C                   MOVE      #1TMSP        PTMESTPSEL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Check for user authority if not multi-branching    *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PErr
 
      ** Return error message for user not authorized then terminate.
 
     C                   IF        PErr = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   EVAL      *IN10 = *ON
     C                   EXFMT     ABFUNDRPF1
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdIDeal - Read an Invalid Deal                              *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRdIDeal     BEGSR
 
      **  Reset End of File indicator
 
     C                   EVAL      WkEOF = *Blanks
 
      **  Read the file.
 
     C                   READ      ABIFUNDL0                              96
 
      * End of File
 
     C                   IF        *IN96 = *On
     C                   EVAL      WkEOF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRpr   - Validate Repair Option Code                      *
      *                                                               *
      * Called by: SRRdFldR                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValRpr      BEGSR
 
     C                   CALLB     'ZAROPTVAL'
 
      ** Inputs
      ** ======
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Option code
      ** Front Office ID
      ** Booking Branch
      ** ICD Single branch code
 
     C                   PARM                    #1OPT
     C                   PARM                    #1FRNT
     C                   PARM                    #1BRC1
     C                   PARM                    BJSBRC
 
      ** Outputs
      ** =======
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  If F12, continue with next option
 
     C                   IF        PINKL = '1'
     C                   EVAL      #1OPT = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqInv- Enquire on invalid transaction                      *
      *                                                               *
      * Called by: SRRdSflR                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREnqInv      BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZATRNKX0      CHAIN     ABIFUNDX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
 
      ** Inputs
      ** ======
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action code
      ** Front Office ID
      ** Associated Front Office ID
      ** Timestamp
 
     C                   PARM                    #1ACTN
     C                   PARM                    #1FRNT
     C                   PARM                    #1AFRT
     C                   PARM                    #1TMSP
 
      ** Invalid file names
 
     C                   PARM      'ABIFUNDPD'   PInvFile1
     C                   PARM      *Blanks       PInvFile2
     C                   PARM      *Blanks       PInvFile3
     C                   PARM      *Blanks       InvFile4         10                        MD041294
 
      ** Invalid file data
 
     C                   PARM      InvTr         PInvFDta1
     C                   PARM      *Blanks       PInvFDta2
     C                   PARM      *Blanks       PInvFDta3
     C                   PARM      *Blanks       InvFDta4       4000                        MD041294
 
      ** Outputs
      ** =======
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPromDel - Prompt for Deletion                               *
      *                                                               *
      * Called by: SRRdSflR                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPromDel     BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
 
      ** Inputs
      ** ======
      ** Return Code
      ** Action code
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #1ACTN
 
      ** Front Office Trans ID & Front Office Associated Trans ID
 
     C                   PARM                    #1FRNT
     C                   PARM                    #1AFRT
 
      ** Timestamp
 
     C                   PARM                    #1TMSP
 
      ** Narrative & Field Content 1 - 9
 
     C                   PARM                    DDNAR1
     C                   PARM      #1DLNO        DDFLD1
     C                   PARM                    DDNAR2
     C                   PARM      #1STP1        DDFLD2
     C                   PARM                    DDNAR3
     C                   PARM      #1DDAT        DDFLD3
     C                   PARM                    DDNAR4
     C                   PARM      #1VDAT        DDFLD4
     C                   PARM                    DDNAR5
     C                   PARM      #1MDAT        DDFLD5
     C                   PARM                    DDNAR6
     C                   PARM      #1CCY         DDFLD6
     C                   PARM                    DDNAR7
     C                   PARM      #1AMNP        DDFLD7
     C                   PARM                    DDNAR8
     C                   PARM      #1RTSP        DDFLD8
     C                   PARM                    DDNAR9
     C                   PARM                    DDFLD9
 
      ** Outputs
      ** =======
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C                   IF        PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      **  If F10, delete invalid deal
 
     C                   IF        PINKJ = '1'
 
     C                   MOVE      #1TMSP        PTMESTPSEL
     C     ZATRNKD0      CHAIN     ABIFUNDD0                          99
 
     C                   IF        *IN99 = *Off
     C                   DELETE    ABIFUNDD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and LIBR = S1SUPP                             CSC011
     C                   EVAL      KMsgType = 'ABFUND'                                        CSC011
     C                   EVAL      KFrntOffID = #1FRNT                                        CSC011
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB
     C                   PARM      'ZZGBMSGF  '  MSGNM
     C                   PARM      *BLANK        MSGTXT
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls:     SRRtvTxt                                           *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
      ** Build Sub-file
      ** Read subfile record
      ** Error in update of previous deal
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PBdSfl
     C                   PARM                    PRdSfl
     C                   PARM                    PErrUp
 
      ** SDBANKPD fields
      ** Single Branch Code
      ** Midas Run Date
 
     C                   PARM                    BJSBRC
     C                   PARM                    BJMRDT
 
      ** Output Parameters
      ** Error Message
      ** Option Selected
      ** Action Selected
      ** FO Transaction ID Selected
      ** FO Associated Transaction ID Selected
      ** Timestamp of transaction selected
 
     C                   PARM                    PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PFOAsocSel
     C                   PARM                    PTMESTPSEL
 
      ** Command Keys
 
     C                   PARM                    PINKC
 
      ** Successful Insert Deal Number
 
     C                   PARM                    PSIDN
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSC022                                       CSC022
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1RUNA = BJMRDT
 
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        CSC022 = 'Y'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    #1FRNT
     C                   KFLD                    PTMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    #1FRNT
 
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                              CSC011
      ** Format text for invalid transaction deletion function
 
     C                   MOVEL     'APA1084'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR1
 
     C                   MOVEL     'APA1085'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR2
 
     C                   MOVEL     'APA1086'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR3
 
     C                   MOVEL     'APA1087'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR4
 
     C                   MOVEL     'APA1088'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR5
 
     C                   MOVEL     'APA1089'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR6
 
     C                   MOVEL     'APA1090'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR7
 
     C                   MOVEL     'APA1091'     MSGDNB
     C                   EXSR      SRRtvTxt
     C                   MOVEL     MSGTXT        DDNAR8
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
