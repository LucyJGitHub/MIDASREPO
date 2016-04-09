     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment support log setup module')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFPRTLOG - LE Funding Participant Support Log Setup Module  *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Funding Participant Details file into screen   *
      *             format to be used in writing records to the log   *
      *             file.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068  *CREATE    Date 22Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs with 24x7 Midas Availability            *
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
 
     D TRANFilFmt    E DS                  EXTNAME(FCLTYFM)
     D  FcltyREC             455    523
     D  FcltyPAY             524   1082
      ** Midas LE API FPRT File Record
 
     D FPRTScnFmt    E DS                  EXTNAME(LEFPRTPD)
      ** Midas LE API FPRT Format Definition File
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D  FLREC                  1     69
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D  FLPAY                  1    559
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB) INZ
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** Midas SD Dealing Data
 
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
      *  Calls    : SRSETD, LEFPRTCVT, LESTFL2SC                      *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      S#ACTN = PACTN
 
      ** Process Funding Participants
 
     C                   EXSR      SRSETD
 
     C                   CALLB     'LEFPRTCVT'
 
     C                   PARM                    RetCodeOut
 
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    TRANFilFmt
      *
      * OUTPUTS
      *
     C                   PARM                    FPRTScnFmt
 
      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
 
      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
     C                   CALLB     'LESTFL2SC'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
      *
      * OUTPUTS
      *
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
 
     C                   EVAL      TRANSDTL = FPRTScnFmt + SETLIB  +
     C                                        SETLIZ
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETD - Set Settlement Instructions Input                   *
      *                                                               *
      *  Called by: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRSETD        BEGSR
 
     C                   MOVEL     FcltyREC      F_REC
     C                   MOVEL     FcltyPAY      F_PAY
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
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
 
      ** Midas LE Valid Funding Participants file record
     C                   PARM                    TRANFilFmt
      ** OUTPUT
      ** ======
 
      ** Data Replication Details Screen Format
     C                   PARM                    TRANSDTL
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
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
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
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
