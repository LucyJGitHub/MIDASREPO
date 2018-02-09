     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee adjustment Support Log Setup Module')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEADLOG - LE Fee Adjustment Support Log Setup Module       *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Fee Adjustment Details file into screen format *
      *             to be used in writing records to the log file     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CLE073 - Calculated Loan Based Fees (Recompile)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it (Recompile)                              *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
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
 
     D TRANFilFmt    E DS                  EXTNAME(LEVFEADPD)
      ** Midas LE API FEAD File Record
 
     D FEADScnFmt    E DS                  EXTNAME(LEFEADPD)
      ** Midas LE API FEAD Format Definition File
 
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
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
 
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
      *  Calls    : SRSETD, LEFEADCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      S#ACTN = PACTN
 
      ** Process Lending Fee Adjustments
 
     C                   EXSR      SRSETD
 
     C                   CALLB     'LEFEADCVT'
 
     C                   PARM      *BLANKS       RetCodeOut
 
      * Fee Adjustment details in file format
     C                   PARM                    TRANFilFmt
      *
      * OUTPUTS
      *
      *
      * Fee Adjustment Details in screen format
     C                   PARM                    FEADScnFmt
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Adjustment amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
 
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
     C                   PARM      ADFCCY        InRCCY                                      CSF011A
     C                   PARM      ADFCCY        InPCCY                                      CSF011A
 
     C                   EVAL      TRANSDTL = FEADScnFmt + RECScnFmt +
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
 
      ** Payment Fields
 
     C                   EVAL      FLPSTM = ADPSTM
     C                   EVAL      FLPONS = ADPONS
     C                   EVAL      FLPIBN = ADPIBN
     C                   EVAL      FLPIBA = ADPIBA
     C                   EVAL      FLPOBN = ADPOBN
     C                   EVAL      FLPOCN = ADPOCN
     C                   EVAL      FLRCRN = ADRCRN
     C                   EVAL      FLRCRA = ADRCRA
     C                   EVAL      FLRVNO = ADRVNO
     C                   EVAL      FLAWBN = ADAWBN
     C                   EVAL      FLBENN = ADBENN
     C                   EVAL      FLBENA = ADBENA
     C                   EVAL      FLDTP1 = ADDTP1
     C                   EVAL      FLDTP2 = ADDTP2
     C                   EVAL      FLDTP3 = ADDTP3
     C                   EVAL      FLDTP4 = ADDTP4
     C                   EVAL      FLDCHG = ADDCHG
     C                   EVAL      FLBTB1 = ADBTB1
     C                   EVAL      FLBTB2 = ADBTB2
     C                   EVAL      FLBTB3 = ADBTB3
     C                   EVAL      FLBTB4 = ADBTB4
     C                   EVAL      FLBTB5 = ADBTB5
     C                   EVAL      FLBTB6 = ADBTB6
     C                   EVAL      FLPOBR = ADOMDB
     C                   EVAL      FLCVMR = ADCVMR
     C                   EVAL      FLPSCY = ADSCCY
     C                   EVAL      FLIC72 = ADICCY
 
      ** Receipt Fields
 
     C                   EVAL      FLRSTM = ADRSTM
     C                   EVAL      FLRONS = ADRONS
     C                   EVAL      FLRIBN = ADRIBN
     C                   EVAL      FLRIBA = ADRIBA
     C                   EVAL      FLROBN = ADROBN
     C                   EVAL      FLROCN = ADROCN
     C                   EVAL      FLROBR = ADOSDB
     C                   EVAL      FLRSCY = ADSCCY
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     ADREXR        FLREXR                                       CLE031
     C                   Z-ADD     ADPEXR        FLPEXR                                       CLE031
     C                   MOVE      ADREXI        FLREXI                                       CLE031
     C                   MOVE      ADPEXI        FLPEXI                                       CLE031
     C                   MOVE      ADSCCY        FLRSCY                                       CLE031
     C                   MOVE      ADPSCY        FLPSCY                                       CLE031
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
 
      ** Midas LE Valid Fees Adjustments file record
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
