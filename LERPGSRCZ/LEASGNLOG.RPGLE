     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Assignment support log setup module')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEASGNLOG - LE Assignments Support Log Setup Module          *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Assignments Details file into screen format    *
      *             to be used in writing records to the log file     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084             Date 02Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP070  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - Recompiled over changed LEASGNPD format.            *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
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

     D TRANFilFmt    E DS                  EXTNAME(LEPARTPD)
      ** Midas LE API ASGN File Record
     D  LepartREC             72    140
     D  LepartPAY            141    699

     D ASGNScnFmt    E DS                  EXTNAME(LEASGNPD)
      ** Midas LE API ASGN Format Definition File

     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)
      ** Midas SD File Extended Settlement Instruction - Pay

     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)
      ** Midas SD Screen Extended Settlement Instruction - Pay

     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)
      ** Midas SD File Extended Settlement Instruction - Receive

     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)
      ** Midas SD Screen Extended Settlement Instruction - Receive

     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)
      ** Midas SD File Extended Settlement Instruction - FRA/IRS

     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)
      ** Midas SD Screen Extended Settlement Instruction - FRA/IRS

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
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A

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
      *  Calls    : SRSETD, LEASGNCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR

     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      S#ACTN = PACTN

      ** Process Lending Assignments

     C                   EXSR      SRSETD

     C                   CALLB     'LEASGNCVT'

     C                   PARM                    RetCodeOut

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    TRANFilFmt
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * OUTPUTS
      *
     C                   PARM                    ASGNScnFmt

      * Assigned to customer details
     C                   PARM                    S#ASTN            6
     C                   PARM                    S#ASTX           10
     C                   PARM                    S#ATNM           20
     C                   PARM                    S#ATTN           10

      * Assigned from customer details
     C                   PARM                    S#ASFN            6
     C                   PARM                    S#ASFX           10
     C                   PARM                    S#AFNM           20
     C                   PARM                    S#AFTN           10

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE

     C                   CALLB     'ZASETINCVT'

     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM      *BLANKS       FRIRFilFmt
     C                   PARM      *BLANKS       PAYScnFmt
     C                   PARM      *BLANKS       RECScnFmt
     C                   PARM      *BLANKS       FRIRScnFmt
     C                   PARM      FccyFCCY      #TRCCY                                      CSF011A
     C                   PARM      FccyFCCY      #TPCCY                                      CSF011A

     C                   EVAL      TRANSDTL = ASGNScnFmt + RECScnFmt +
     C                                        PAYScnFmt

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

     C                   EVAL      RECFilFmt = LepartREC
     C                   EVAL      PAYFilFmt = LepartPAY
     C                   EVAL      FLPOBR = OMDB
     C                   EVAL      FLCVMR = CVMR
     C                   EVAL      FLPSCY = SCCY
     C                   EVAL      FLIC72 = ICCY
     C                   EVAL      FLROBR = OSDB
     C                   EVAL      FLRSCY = SCCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
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

      ** Midas LE Valid Assignments file record
     C                   PARM                    TRANFilFmt

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0

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
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     PRTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '908'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     POPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
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
(c) Finastra International Limited 2002
