     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee input Log Setup Module')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEEMLOG - LE Fee Input Log Setup Module                    *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Fee Input details file into screen             *
      *             format to be used in writing records to the log   *
      *             file                                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG3813            Date 26Jul04               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG3813- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Record not found Indicator                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *  SRSETD - Set Settlment Instructions Input                    *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
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
 
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(CL_)
     FFCLTY     IF   E           K DISK
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(FA_)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)
 
      ** Midas LE API Feem File Record
 
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)
      ** Midas LE API Feem Detail Screen Format Definition File
 
      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)
 
      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PACTN           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSTS            S             24A
     D PCSTS           S             10A
     D TRANSDTL        S           5800A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Convert file fields into screen format
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Convert file fields into screen format              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRSETD, LEFEEMCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      DDACTN = PACTN
 
     C                   EVAL      WSYND  = 'N'
      *
      ** Access Loan details
      *
     C*****FELOAN        IFNE      *zero                                                      CLE148
     C     FELOAN        IFNE      *BLANKS                                                    CLE148
 
     C     KEY002        CHAIN     CLOAN                              78
 
      * Check if Fee against Syndicated Loan/Facility
 
     C     *IN78         IFEQ      '0'
     C     CL_PTYP       ANDNE     61
     C     CL_PTYP       ANDNE     62
     C     CL_PTYP       ANDNE     63
     C     CL_PTYP       ANDNE     70
     C     CL_PTYP       ANDNE     80                                                        BUG3813
      *                                                                                      BUG3813
     C     CL_LPFI       IFNE      *BLANKS
     C                   MOVE      'Y'           WSYND             1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Facility with Customer Det.
      *
     C     FEFACL        IFNE      *zero
     C                   Movel     FEFACL        WFAC03            3 0
     C                   Move      FEFACL        WFAC02            2 0
     C     KEY001        CHAIN     FCLTY                              78
 
     C     *IN78         IFEQ      '0'
     C     FA_SYIN       ANDEQ     'Y'
     C                   MOVE      'Y'           WSYND
     C                   ENDIF
 
     C     FEFACL        IFNE      *Zero
     C     FA_SYIN       ANDEQ     'Y'
     C     FA_PRTR       ANDNE     'I'
     C     FA_PRTR       ANDNE     'P'
     C                   MOVE      'Y'           WSYND
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Process Fee input
 
     C                   CALLB     'LEFEEMCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    CrFeFilFmt
      *
      * Loan in file formats
     C                   PARM                    ClilFilFmt
      *
      * Fclty in file formats
     C                   PARM                    FacmFilFmt
      *
      * CLE006
     C                   PARM                    CLE006            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      *
      * OUTPUTS
      *
      * Fee details in first screen format
     C                   PARM                    CrFeScnFmt
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI             1
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
     C                   EVAL      TRANSDTL = CrFeScnFmt
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Action Code
     C                   PARM                    PACTN
 
      ** Midas LE Fee file record
     C                   PARM                    CrFeFilFmt
 
      ** CLE006
     C                   PARM                    CLE006            1
 
      ** OUTPUT
      ** ======
 
      ** Data Replication Details Screen Format
     C                   PARM                    TRANSDTL
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
      *
      ** KLIST for file FCLTY
     C     KEY001        KLIST
     C                   KFLD                    FECNUM
     C                   KFLD                    WFAC03
     C                   KFLD                    WFAC02
     C                   KFLD                    WRCDT
      *
      ** KLIST for file CLOAN
     C     KEY002        KLIST
     C                   KFLD                    FELOAN
     C                   KFLD                    WRCDT
 
     C                   MOVE      'A'           WRCDT             1
      *                                                                                      BUG3813
      ** Determine if CLE028 for Flat Rate Personal Loans (Rule of 78s)                      BUG3813
      ** enhancement is installed.                                                           BUG3813
      *                                                                                      BUG3813
     C                   MOVE      'N'           CLE028            1                         BUG3813
     C                   CALLB     'AOSARDR0'                                                BUG3813
     C                   PARM      *BLANKS       @RTCD                                       BUG3813
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3813
     C                   PARM      'CLE028'      @SARD             6                         BUG3813
      *                                                                                      BUG3813
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3813
     C                   MOVE      'Y'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
     C     @RTCD         IFEQ      '*NRF'                                                    BUG3813
     C                   MOVE      'N'           CLE028                                      BUG3813
     C                   ELSE                                                                BUG3813
      *                                                                                      BUG3813
      ** DATABASE ERROR                                                                      BUG3813
      *                                                                                      BUG3813
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************BUG3813
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *BUG3813
     C                   MOVEL     @OPTN         DBKEY                          *************BUG3813
     C                   EXSR      *PSSR                                                     BUG3813
     C                   ENDIF                                                               BUG3813
     C                   ENDIF                                                               BUG3813
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
