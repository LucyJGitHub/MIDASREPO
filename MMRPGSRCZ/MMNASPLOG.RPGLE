     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased Support Log Setup Module')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPLOG - MM NAs Purchased Support Log Setup Module        *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             NAs Purchased Details file into screen format     *
      *             to be used in writing records to the log file.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL018             Date 03Feb04               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
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
 
     D NASPFilFmt    E DS                  EXTNAME(MMVNASPPD)
      ** Midas MM Valid NAs Purchased
 
     D NASPScnFmt    E DS                  EXTNAME(MMNASPPD)
      ** Midas MM API DEAM Format Definition File
 
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
 
     D NASPExtDta    E DS                  EXTNAME(MMNPEXPD)
      ** Midas MM NA Purchased Extra Data Layout File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PACTN           S              1A
     D PSTS            S             24A
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
      *  Calls    : SRSETD, MMNASPCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
 
     C                   EVAL      DDACTN = PACTN
 
     C                   EXSR      SRSETD
 
     C                   CALLB     'MMNASPCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    NASPFilFmt
     C                   PARM                    NASPScnFmt
     C                   PARM                    PSTS
 
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
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
 
     C                   EVAL      TRANSDTL = NASPScnFmt + RECScnFmt +
     C                                        PAYScnFmt + NASPExtDta
 
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
 
     C                   EVAL      FLPSTM = IHPSTM
     C                   EVAL      FLPONS = IHPONS
     C                   EVAL      FLPIBN = IHPIBN
     C                   EVAL      FLPIBA = IHPIBA
     C                   EVAL      FLPOBN = IHPOBN
     C                   EVAL      FLPOCN = IHPOCN
     C                   EVAL      FLRCRN = IHRCRN
     C                   EVAL      FLRCRA = IHRCRA
     C                   EVAL      FLRVNO = IHRVNO
     C                   EVAL      FLAWBN = IHAWBN
     C                   EVAL      FLBENN = IHBENN
     C                   EVAL      FLBENA = IHBENA
     C                   EVAL      FLDTP1 = IHDTP1
     C                   EVAL      FLDTP2 = IHDTP2
     C                   EVAL      FLDTP3 = IHDTP3
     C                   EVAL      FLDTP4 = IHDTP4
     C                   EVAL      FLDCHG = IHDCHG
     C                   EVAL      FLBTB1 = IHBTB1
     C                   EVAL      FLBTB2 = IHBTB2
     C                   EVAL      FLBTB3 = IHBTB3
     C                   EVAL      FLBTB4 = IHBTB4
     C                   EVAL      FLBTB5 = IHBTB5
     C                   EVAL      FLBTB6 = IHBTB6
     C                   EVAL      FLPOBR = IHBRCA
     C                   EVAL      FLCVMR = IHCVMR
     C                   EVAL      FLPSCY = IHSTCY
     C                   EVAL      FLIC72 = IHIC72
 
      ** Receipt Fields
 
     C                   EVAL      FLRSTM = IHRSTM
     C                   EVAL      FLRONS = IHRONS
     C                   EVAL      FLRIBN = IHRIBN
     C                   EVAL      FLRIBA = IHRIBA
     C                   EVAL      FLROBN = IHROBN
     C                   EVAL      FLROCN = IHROCN
     C                   EVAL      FLROBR = IHROBR
     C                   EVAL      FLRSCY = IHSTCY
 
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
 
      ** Midas MM Valid NAs Purchased file record
     C                   PARM                    NASPFilFmt
 
      ** OUTPUT
      ** ======
 
      ** Data Replication Details Screen Format
     C                   PARM                    TRANSDTL
 
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
(c) Misys International Banking Systems Ltd. 2001
