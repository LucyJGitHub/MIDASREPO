     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Sold Support Log Setup Module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSLOG - Negotiable Assets Sold Support Log Setup Module  *
      *                                                               *
      *  Function:  This module will convert detail fields of NA's    *
      *             Sold Details file into screen format to be used   *
      *             in writing records to the log file.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL018             Date 03Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
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
 
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA
      ** LDA and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------+
 
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
 
     D NASSFilFmt    E DS                  EXTNAME(MMDENSPP)
      ** Midas MM NAs Sold File
 
     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)
      ** Midas SD File Extended Settlement Instruction - Pay
 
     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)
      ** Midas SD File Extended Settlement Instruction - Receive
 
     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)
      ** Midas SD File Extended Settlement Instruction - FRA/IRS
 
     D NASSScnFmt    E DS                  EXTNAME(MMNASSPD)
      ** Midas MM API Incoming Message Definition File for NAs Sold
 
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)
      ** Midas SD Screen Extended Settlement Instruction - Pay
 
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)
      ** Midas SD Screen Extended Settlement Instruction - Receive
 
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)
      ** Midas SD Screen Extended Settlement Instruction - FRA/IRS
 
     D ExtDataDS     E DS                  EXTNAME(MMNSEXPD)
      ** Midas MM API Negotiable Asset Sold Extra Data Layout File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PACTN           S              1
     D PDSTS           S             24
     D TRANSDTL        S           5800
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
      *  Calls    : SRSINS, MMNASSCVT, ZASETINCVT                     *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *BLANKS
 
      ** Set Settlement Instructions input
 
     C                   EXSR      SRSINS
 
     C                   EVAL      DDACTN = PACTN
 
      ** Call NAs Convert Module
 
     C                   CALLB     'MMNASSCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    NASSFilFmt
     C                   PARM                    NASSScnFmt
     C                   PARM                    PDSTS
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
      ** Call Settlement Instructions Convert Module
 
     C                   CALLB     'ZASETINCVT'
     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM      *BLANKS       FRIRFilFmt
     C                   PARM      *BLANKS       PAYScnFmt
     C                   PARM      *BLANKS       RECScnFmt
     C                   PARM      *BLANKS       FRIRScnFmt
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
 
     C                   EVAL      TRANSDTL = NASSScnFmt + RECScnFmt +
     C                                        PAYScnFmt + ExtDataDS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSINS - Set Settlement Instructions Input                   *
      *                                                               *
      *  Called by: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSINS        BEGSR
 
      ** Payment Fields
 
     C                   EVAL      FLPSTM = HMPSTM
     C                   EVAL      FLPONS = HMPONS
     C                   EVAL      FLPIBN = HMPIBN
     C                   EVAL      FLPIBA = HMPIBA
     C                   EVAL      FLPOBN = HMPOBN
     C                   EVAL      FLPOCN = HMPOCN
     C                   EVAL      FLRCRN = HMRCRN
     C                   EVAL      FLRCRA = HMRCRA
     C                   EVAL      FLRVNO = HMRVNO
     C                   EVAL      FLAWBN = HMAWBN
     C                   EVAL      FLAWBA = HMAWBA
     C                   EVAL      FLBENN = HMBENN
     C                   EVAL      FLBENA = HMBENA
     C                   EVAL      FLDTP1 = HMDTP1
     C                   EVAL      FLDTP2 = HMDTP2
     C                   EVAL      FLDTP3 = HMDTP3
     C                   EVAL      FLDTP4 = HMDTP4
     C                   EVAL      FLDCHG = HMDCHG
     C                   EVAL      FLBTB1 = HMBTB1
     C                   EVAL      FLBTB2 = HMBTB2
     C                   EVAL      FLBTB3 = HMBTB3
     C                   EVAL      FLBTB4 = HMBTB4
     C                   EVAL      FLBTB5 = HMBTB5
     C                   EVAL      FLBTB6 = HMBTB6
     C                   EVAL      FLPOBR = HMORBR
     C                   EVAL      FLCVMR = HMCVMR
     C                   EVAL      FLPSCY = HMSTCY
     C                   EVAL      FLIC72 = HMIC72
 
      ** Receipt Fields
 
     C                   EVAL      FLRSTM = HMRSTM
     C                   EVAL      FLRONS = HMRONS
     C                   EVAL      FLRIBN = HMRIBN
     C                   EVAL      FLRIBA = HMRIBA
     C                   EVAL      FLROBN = HMROBN
     C                   EVAL      FLROCN = HMROCN
     C                   EVAL      FLROBR = HMROBR
     C                   EVAL      FLRSCY = HMSTCY
 
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
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
     C                   PARM                    PACTN
 
      ** Negotiable Assets Sold File
 
     C                   PARM                    NASSFilFmt
 
      ** OUTPUT
      ** Transaction Details
 
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
** CPY@
(c) Misys International Banking Systems Ltd. 2001
