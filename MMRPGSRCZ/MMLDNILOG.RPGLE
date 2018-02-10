     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits Support Log Setup Module')     *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNILOG - MM Loans/Deposits Support Log Setup Module       *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             MM Loan/Deposit/CD Issued Details file into       *
      *             screen format to be used in writing records       *
      *             to the log file.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 30Oct03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *           (Recompile)                                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CSC011 - 24x7 Midas Availability                             *
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
 
     FABFUNDL0  IF   E           K DISK    INFSR(*PsSr)
      ** Midas AB Internal Funding Deals by Deal No.
 
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
 
     D TRANFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      ** Internal Loan File Record
 
     D TRANFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
      ** Internal Deal File Record
 
     D LDNIScnFmt    E DS                  EXTNAME(MMLDNIPD)
      ** Midas MM API LDNI Format Definition File
 
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
 
     D LDNIInfDta    E DS                  EXTNAME(MMLDIFPD)
      ** Midas MM LDNI Interface Data Format Definition Layout
 
     D LDNIExtDta    E DS                  EXTNAME(MMLDEXPD)
      ** Midas MM LDNI Extra Data Layout File
 
     D FUNDScnFmt    E DS                  EXTNAME(ABFUNDPD)
      ** Midas AB FUND API Screen Format Definition File
 
     D FUNDExtDta    E DS                  EXTNAME(ABFUEXPD)
     D                                     PREFIX(F)
      ** Midas AB FUND Internal Funding Deals Extra Data Layout File
 
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
     D PSTSA           S              7A
     D PCDES           S             30A
     D PCDES2          S             30A
     D PSTS            S             24A
     D PCSTS           S             10A
     D TRANSDTL        S           5800A
     D WIntLoan        S              6  0
                                                                                              222373
     D CAS004          S              1A                                                      222373
 
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
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
      *  Calls    : SRSETD, ABFUNDCVT, MMLDNICVT, ZASETINCVT          *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
     C                   EVAL      TRANFilFmt2 = *BLANKS
     C
     C                   EVAL      DDACTN = PACTN
 
      ** Process Internal Funding deals
 
     C                   IF        IKMTYP = 'ID' OR
     C                             IKMTYP = 'IL'
 
     C                   IF        IKMTYP = 'ID'
 
      ** Access internal loan
 
     C                   MOVEL     IKDADN        WIntLoan
 
     C     WIntLoan      CHAIN     ABFUNDL0                           01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      DBKEY = IKDADN
     C                   EVAL      DBFILE = 'ABFUNDL0'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALLB     'ABFUNDCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    PACTN
     C                   PARM                    TRANFilFmt2
     C                   PARM                    TRANFilFmt
     C                   PARM                    BJDFIN
     C                   PARM                    BNDCSP
     C                   PARM                    CAS004                                       222373
     C                   PARM                    FUNDScnFmt
     C                   PARM                    PSTSA
     C                   PARM                    PCDES
     C                   PARM                    PCDES2
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   EVAL      TRANSDTL = FUNDScnFmt + FUNDExtDta
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Loans and Deposits deals
 
     C                   ELSE
 
     C                   EXSR      SRSETD
 
     C                   CALLB     'MMLDNICVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    TRANFilFmt
     C                   PARM                    LDNIScnFmt
     C                   PARM                    PSTS
     C                   PARM                    PCSTS
 
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
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A
 
     C                   EVAL      TRANSDTL = LDNIScnFmt + RECScnFmt +
     C                                        PAYScnFmt + LDNIInfDta +
     C                                        LDNIExtDta
 
     C                   ENDIF
 
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
 
     C                   EVAL      FLPSTM = IKPSTM
     C                   EVAL      FLPONS = IKPONS
     C                   EVAL      FLPIBN = IKPIBN
     C                   EVAL      FLPIBA = IKPIBA
     C                   EVAL      FLPOBN = IKPOBN
     C                   EVAL      FLPOCN = IKPOCN
     C                   EVAL      FLRCRN = IKRCRN
     C                   EVAL      FLRCRA = IKRCRA
     C                   EVAL      FLRVNO = IKRVNO
     C                   EVAL      FLAWBN = IKAWBN
     C                   EVAL      FLBENN = IKBENN
     C                   EVAL      FLBENA = IKBENA
     C                   EVAL      FLDTP1 = IKDTP1
     C                   EVAL      FLDTP2 = IKDTP2
     C                   EVAL      FLDTP3 = IKDTP3
     C                   EVAL      FLDTP4 = IKDTP4
     C                   EVAL      FLDCHG = IKDCHG
     C                   EVAL      FLBTB1 = IKBTB1
     C                   EVAL      FLBTB2 = IKBTB2
     C                   EVAL      FLBTB3 = IKBTB3
     C                   EVAL      FLBTB4 = IKBTB4
     C                   EVAL      FLBTB5 = IKBTB5
     C                   EVAL      FLBTB6 = IKBTB6
     C                   EVAL      FLPOBR = IKPOBR
     C                   EVAL      FLCVMR = IKCVMR
     C                   EVAL      FLPSCY = IKSTCY
     C                   EVAL      FLIC72 = IKIC72
 
      ** Receipt Fields
 
     C                   EVAL      FLRSTM = IKRSTM
     C                   EVAL      FLRONS = IKRONS
     C                   EVAL      FLRIBN = IKRIBN
     C                   EVAL      FLRIBA = IKRIBA
     C                   EVAL      FLROBN = IKROBN
     C                   EVAL      FLROCN = IKROCN
     C                   EVAL      FLROBR = IKROBR
     C                   EVAL      FLRSCY = IKSTCY
 
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
 
      ** Midas MM Valid loan/deposit file record
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
 
      ** Access Dealing ICD Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 901
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
(c) Finastra International Limited 2001
