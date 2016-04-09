     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility input log setup module')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPLOG - LE Facility Input Log Setup Module               *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Facility Input details file into screen        *
      *             format to be used in writing records to the log   *
      *             file                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3723 - Recompile due to changes to LEFCSPPD.              *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
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
 
     D TRFMFilFmt    E DS                  EXTNAME(FCLTYFM)
     D TRFNFilFmt    E DS                  EXTNAME(FCLTYFN) PREFIX(FN)
 
      ** Midas LE API FCIP File Record
 
     D FacScnPrim    E DS                  EXTNAME(LEFCPPPD)
      ** Midas LE API FCIP First Screen Format Definition File
 
     D FacScnSeco    E DS                  EXTNAME(LEFCSPPD)
      ** Midas LE API FCIP Second Screen Format Definition File
 
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
      *  Calls    : SRSETD, LEFCIPCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      DDACTN = PACTN
 
      ** Process Facility input
 
     C                   CALLB     'LEFCIPCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    TRFMFilFmt
     C                   PARM                    TRFNFilFmt
      *
      * OUTPUTS
      *
      * Facility details in first screen format
     C                   PARM                    FacScnPrim
      * Facility details in second screen format
     C                   PARM                    FacScnSeco
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
     C                   EVAL      TRANSDTL = FacScnPrim + FacScnSeco
 
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
 
      ** Midas LE Facility FM file record
     C                   PARM                    TRFMFilFmt
      ** Midas LE Facility FN file record
     C                   PARM                    TRFNFilFmt
 
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
(c) Misys International Banking Systems Ltd. 2002
