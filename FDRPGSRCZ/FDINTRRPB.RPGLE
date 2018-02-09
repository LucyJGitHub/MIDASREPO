     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM interest rates repair browse')
      *****************************************************************
      *                                                               *
      *  Midas - FD ILE Module                                        *
      *                                                               *
      *  FDINTRRPB - Invalid Interest Rate Details Browse             *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *            - will build and display a sub-file of invalid     *
      *              interest rates which the user is authorised      *
      *              to view.                                         *
      *            - picks off the interest rate that the user        *
      *              has selected.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG1625            Date 19May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 20Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG1625 - Commitment Control Changes for MidasPlus           *
      *  CSC011 - 24X7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed (recompile)              *
      *  CAP058 - Market Data Feeds                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFDINTRRDF CF   E             WORKSTN
     F                                     SFILE(FDINTRS0:@@RRN)
     FFDIINTRL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDIINTRD0:FDIINTRX0)
     FFDIINTRL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
     ** API Invalid Log File                                                                  CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       95  Subfile Next Change                                 *
      *       96  End of File                                         *
      *       97  Subfile Clear                                       *
      *       98  Rollup                                              *
      *       99  Read error                                          *
      *       LR  End of Program                                      *
      *                                                               *
      *       KC  Function Key - F13 (Program Exit)                   *
      *       KL  Function Key - F12 (Cancel)                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTION                                   *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrBLDSFL      - Build Sub-File                           *
      *      SrMOVDET      - Move Invalid Interest Details to Subfile *
      *      SrRDSFLR      - Read Sub-File processing                 *
      *      SrVALROPT     - Validate Repair Option Code              *
      *      SrENQINV      - Enquire on Invalid Interest Rates        *
      *      SrFMTRAT      - Format Borrow/Lend Rate to Screen Format *
      *      SrPROMDELT    - Prompt for Deletion                      *
      *      SrRDIINTR     - Read an Invalid Interest Rates           *
      *      SrCHAUT       - Check for User Autority if not Multi-    *
      *                      Branching                                *
      *      SrRTVTXT      - Retrieve text                            *
      *      SrINIT        - Initialisation                           *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      ZAROPTVAL     - Repair Option Code Validation            *
      *      ZAINVTRENQ    - Invalid Transaction Enquiry              *
      *      ZAINVTRDEL    - Invalid Transaction Deletion             *
      *      ZVACTU        - Validate Authority                       *
      *      SDRTVTXT      - Retrieve Multi-language Message Id       *
      *      AOBANKR0      - Access Object for Bank Details           *
      *                                                               *
      *****************************************************************
 
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
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
 
     D InvIr         E DS                  EXTNAME(FDIINTRPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D ErrorText       S             52    DIM(1) CTDATA PERRCD(1)
      ** Array containing messages
                                                                                             BUG1625
      ** Jobs Handling Commitment Control                                                    BUG1625
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG1625
     D  COMITARR               4    103                                                      BUG1625
                                                                                             BUG1625
      ** Array of Commitment Job Names                                                       BUG1625
     D COMITJOB        S             10A   DIM(10)                                           BUG1625
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Input Parameter (Build Subfile ind., Read Subfile ind. and Update Error ind.)
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PERRUP          S              1A
 
      ** Output Parameter (Error Message Id, Option Selected, Action Code,
      ** Front Office Id, Transaction Reference and Timestamp)
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PACSEL          S              1A
     D PFOTRANSEL      S             20A
     D PTRNN           S              3A
     D PTMESTPSEL      S             26Z
 
      ** Function Keys (included in output parameter - F3 and F12)
     D PINKC           S              1A
     D PINKL           S              1A
 
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A                                                     BUG1625
     D CNT             S              3  0                                                   BUG1625
     D COMITSKIP       S              1A                                                     BUG1625
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   CSC011
 
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
 
      ** Initialization
 
     C                   EXSR      SrINIT
 
      ** Build subfile
 
     C     PBDSFL        IFEQ      'Y'
     C                   EXSR      SrBLDSFL
     C                   ENDIF
 
      ** Read subfile record
 
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      SrRDSFLR
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL - Build Subfile                                      *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL      BEGSR
 
      ** Check for user authority to browse if not multi-branching
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      **  Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN             5 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDINTRC0
     C                   MOVE      '0'           *IN97
 
      **  If previous transaction was not successful due to deal being
      **  updated by another workstation then display message on screen
 
     C     PERRUP        IFEQ      'Y'
     C                   MOVEL     ErrorText(1)  ERRORMSG
     C                   ELSE
     C                   MOVE      *BLANKS       ERRORMSG
     C                   ENDIF
 
      **  Write the select screen footer and header to the screen.
 
     C                   WRITE     FDINTRH0
     C                   WRITE     FDINTRF0
 
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     FDIINTRL0
 
      ** Read an invalid transaction
 
     C                   EXSR      SrRDIINTR
 
      **  If no records exist - set up an error message.
      **  Display a message 'No invalid transactions present'
      **  then terminate
 
     C     EndOfFile     IFEQ      TRUE
     C                   MOVEL     'FDM0601'     PERRMS
     C                   EXFMT     FDINTREND
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      **  Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = TRUE
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C     EndOfFile     DOWEQ     FALSE
     C     *IN98         ANDEQ     TRUE
 
      **  Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             @@CNT             3 0
 
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
 
     C     EndOfFile     DOWEQ     FALSE
     C     @@CNT         ANDLT     16
 
      **  Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      **  Move invalid interest rate details to subfile
 
     C                   EXSR      SrMOVDET
 
      **  Write the invalid interest rate details to the subfile
 
     C                   EVAL      DDSELT = *BLANK
     C                   Z-ADD     @@RRN         DDRLRN
     C                   WRITE     FDINTRS0
 
      ** Read next invalid interest rate
 
     C                   EXSR      SrRDIINTR
     C                   ENDDO
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     FDINTRC0
 
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
 
     C                   READ      FDINTRC0                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      TRUE
     C                   EVAL      PINKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C     *INKL         IFEQ      '1'
     C                   EVAL      PINKL = TRUE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMOVDET - Move Invalid Interest Details to Subfile          *
      *                                                               *
      *****************************************************************
     C     SrMOVDET      BEGSR
 
     C                   EVAL      DDOBRW = DDBR01
     C                   EVAL      DDOLND = DDLR01
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRDSFLR - Read Sub-File processing                          *
      *                                                               *
      *****************************************************************
     C     SrRDSFLR      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       (*IN99 = TRUE) OR (DDSELT <> *BLANK)
     C                   READC     FDINTRS0                               99
 
      ** Validate repair option code
 
     C     *IN99         IFEQ      FALSE
     C                   EXSR      SrVALROPT
     C                   ENDIF
 
      ** If 'E' is input, enquire upon invalid interest rate
 
     C                   IF        (*IN99 = FALSE) AND (DDSELT = 'E')
     C                   MOVE      DDTMESTMP     PTMESTPSEL
     C                   EXSR      SrENQINV
     C                   MOVE      *BLANK        DDSELT
     C                   ENDIF
 
      ** If 'Q' is input, prompt for deletion of invalid transaction
 
     C                   IF        (*IN99 = FALSE) AND (DDSELT = 'Q')
     C                   EXSR      SrPROMDELT
     C                   MOVEL     *BLANK        DDSELT
     C                   ENDIF
     C                   ENDDO
 
      **  Return the selected option, action, transaction Id, front office
      **  Id and timestamp
 
     C                   IF        (*IN99 = FALSE) AND (DDSELT <> *BLANK)
     C                   MOVE      DDSELT        POPSEL
     C                   MOVE      DDACTN        PACSEL
     C                   MOVE      DDCCY         PTRNN
     C                   MOVE      DDFOTRANID    PFOTRANSEL
     C                   MOVE      DDTMESTMP     PTMESTPSEL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALROPT  - Validate Repair Option Code                      *
      *                                                               *
      *****************************************************************
     C     SrVALROPT     BEGSR
 
     C                   CALLB     'ZAROPTVAL'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDSELT
     C                   PARM                    DDFOTRANID
     C                   PARM                    PBOOKBRC          3
     C                   PARM                    BJSBRC
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      **  If F3, bypass further processing.
 
     C     PINKC         IFEQ      TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F12, continue with next option
 
     C     PINKL         IFEQ      TRUE
     C                   MOVEL     *BLANK        DDSELT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrENQINV - Enquire on Invalid Interest Rates                  *
      *                                                               *
      *****************************************************************
     C     SrENQINV      BEGSR
 
      ** Pass the invalid transaction details to the enquiry
 
     C     ZAINTRX0      CHAIN     FDIINTRX0                          99
 
     C                   CALLB     'ZAINVTRENQ'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    DDTMESTMP
     C                   PARM      'FDIINTRPD'   InvFile1         10
     C                   PARM      '         '   InvFile2         10
     C                   PARM      '         '   InvFile3         10
     C                   PARM      InvIR         InvFDta1       4000
     C                   PARM      *BLANKS       InvFDta2       4000
     C                   PARM      *BLANKS       InvFDta3       4000
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
 
     C     PINKC         IFEQ      TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPROMDELT - Prompt for Deletion                              *
      *                                                               *
      *****************************************************************
     C     SrPROMDELT    BEGSR
 
     C                   CALLB     'ZAINVTRDEL'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDFOTRANID
     C                   PARM                    DDFOASOCID
     C                   PARM                    DDTMESTMP
     C                   PARM                    DDNAR1           30
     C                   PARM      DDCCY         DDFLD1           35
     C                   PARM                    DDNAR2           30
     C                   PARM      DDOBRW        DDFLD2           35
     C                   PARM                    DDNAR3           30
     C                   PARM      DDOLND        DDFLD3           35
     C                   PARM                    DDNAR4           30
     C                   PARM                    DDFLD4           35
     C                   PARM                    DDNAR5           30
     C                   PARM                    DDFLD5           35
     C                   PARM                    DDNAR6           30
     C                   PARM                    DDFLD6           35
     C                   PARM                    DDNAR7           30
     C                   PARM                    DDFLD7           35
     C                   PARM                    DDNAR8           30
     C                   PARM                    DDFLD8           35
     C                   PARM                    DDNAR9           30
     C                   PARM                    DDFLD9           35
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ             1
     C                   PARM      '0'           PINKL
 
      ** If F3, bypass further processing.
 
     C     PINKC         IFEQ      TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F10, delete invalid transaction
 
     C     PINKJ         IFEQ      TRUE
     C                   MOVE      DDTMESTMP     PTMESTPSEL
     C     ZAINTRD0      CHAIN     FDIINTRD0                          99
     C     *IN99         IFEQ      FALSE
     C                   DELETE    FDIINTRD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'FDINTR'                                        CSC011
     C                   EVAL      KFrntOffID = DDFOTRANID                                    CSC011
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
     C     CSC022        IFEQ      'N'                                                       BUG1625
     C                   COMMIT
     C                   ELSE                                                                BUG1625
     C     COMITSKIP     IFNE      'Y'                                                       BUG1625
     C                   COMMIT                                                              BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRDIINTR - Read an Invalid Interest Rates                    *
      *                                                               *
      *****************************************************************
     C     SrRDIINTR     BEGSR
 
      **  Read the file.
 
     C                   READ      FDIINTRL0                              96
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCHAUT - Check for User Authority if not Multi-Branching     *
      *                                                               *
      *****************************************************************
     C     SrCHAUT       BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    PERR              1 0
 
      ** Return error message
 
     C     PERR          IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRTVTXT - Retrieve text                                      *
      *                                                               *
      *****************************************************************
     C     SrRTVTXT      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM      'ZZGBMSGF  '  MSGNM            10
     C                   PARM      *BLANK        MSGTXT           80
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrINIT - Initialization                                       *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
      *                                                                                       CSC011
      * If 24x7 is present then journal APILOGL0                                              CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y')                                             CSC011
     C                   OPEN      APILOGL0                             22                    CSC011
     C                   ENDIF                                                                CSC011
 
      ** Clear Outputs
 
     C                   MOVE      *BLANK        PERRMS
     C                   MOVE      *BLANK        POPSEL
     C                   MOVE      *BLANK        PACSEL
     C                   MOVE      *BLANK        PTRNN
     C                   MOVE      *BLANK        PFOTRANSEL
     C                   CLEAR                   PTMESTPSEL
     C                   MOVE      '0'           PINKC
     C                   MOVE      '0'           PINKL
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PBDSFL
     C                   PARM                    PRDSFL
     C                   PARM                    PERRUP
     C                   PARM                    PERRMS
     C                   PARM                    POPSEL
     C                   PARM                    PACSEL
     C                   PARM                    PTRNN
     C                   PARM                    PFOTRANSEL
     C                   PARM                    PTMESTPSEL
     C                   PARM                    PINKC
     C                   PARM                    PINKL
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSC022                                      BUG1625
 
      ** Initialize program name
 
     C                   MOVEL     'FDINTRRPB'   DBPGM
 
      ** Move workstation ID to screen field.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSC011
      ** Access SDSTAT and SC24X7 if CSC011 is installed                                      CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ENDIF                                                                CSC011
 
     C                   IF        CSC022 = 'Y'                                              BUG1625
                                                                                             BUG1625
     C                   IN        SCCMTJOB                                                  BUG1625
     C                   Z-ADD     1             CNT                                         BUG1625
     C                   MOVEL     *BLANKS       COMITSKIP                                   BUG1625
     C                   MOVEA     COMITARR      COMITJOB                                    BUG1625
     C     COMITNUM      IFGT      0                                                         BUG1625
     C     CNT           DOWLE     COMITNUM                                                  BUG1625
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                             BUG1625
     C                   MOVEL     'Y'           COMITSKIP                                   BUG1625
     C                   ENDIF                                                               BUG1625
     C                   ADD       1             CNT                                         BUG1625
     C                   ENDDO                                                               BUG1625
     C                   ENDIF                                                               BUG1625
                                                                                             BUG1625
     C                   ENDIF                                                               BUG1625
 
      ** Key Lists
 
     C     ZAINTRD0      KLIST
     C                   KFLD                    DDFOTRANID
     C                   KFLD                    PTMESTPSEL
     C     ZAINTRX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    DDFOTRANID
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
 
      ** Format text for invalid transaction deletion function
 
     C                   MOVEL     'APA0017'     MSGDNB
     C                   EXSR      SrRTVTXT
     C                   MOVEL     MSGTXT        DDNAR1
     C                   MOVEL     'APA0300'     MSGDNB
     C                   EXSR      SrRTVTXT
     C                   MOVEL     MSGTXT        DDNAR2
     C                   MOVEL     'APA0301'     MSGDNB
     C                   EXSR      SrRTVTXT
     C                   MOVEL     MSGTXT        DDNAR3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  Array of error messages - ErrorText
The last transaction was not applied to the database
