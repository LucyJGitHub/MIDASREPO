     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single CCY Retrieve IRC Details Module')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCXSTRTV - Cross CCY Extra Settlement Details Retrieve      *
      *              Module                                           *
      *                                                               *
      *  Function:  This module will format extra settlement details  *
      *             for the exchange of principal: value date pay/    *
      *             receive settlement instructions and maturity      *
      *             date pay/receive settlement instructions.         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  30 - Chain Indicator                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      * SRVALS - Set Value Date Settlement Instructions               *
      * SRMATS - Set Maturity Date Settlement Instructions            *
      * SRFRMT - Convert Settlement Instructions to Screen Format     *
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
 
     FDLGXSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S)
      ** Midas DL Extra Settlement Instructions for Cross Currency
      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
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
 
     D RECSScnFmt    E DS                  EXTNAME(SDESSRPD)
 
     D PAYSScnFmt    E DS                  EXTNAME(SDESSPPD)
 
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)
 
     D VRECScnFmt    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(VR)
 
     D VPAYScnFmt    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(VP)
 
     D MRECScnFmt    E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(MR)
 
     D MPAYScnFmt    E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(MP)
 
     D DLGXST        E DS                  EXTNAME(DLGXSTPD)
     D                                     PREFIX(S)
     D  RECFilFmt             10     84
     D  PAYFilFmt             85    653
     D  FRIRFilFmt           654   1303
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PDeal           S              6A
     D KDeal           S              6  0
     D KEvntCode       S              3A
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRProc
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      VRECScnFmt = *Blanks
     C                   EVAL      VPAYScnFmt = *Blanks
     C                   EVAL      MRECScnFmt = *Blanks
     C                   EVAL      MPAYScnFmt = *Blanks
 
     C                   EXSR      SRVALS
     C                   EXSR      SRMATS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRVALS - Set Value Date Settlement Instructions            *
      *                                                               *
      * Called by: SR/SRPROC                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVALS        BEGSR
 
     C                   EVAL      KEvntCode = 'VAL'
 
     C                   EXSR      SRFRMT
     C                   EVAL      VRECScnFmt = RECSScnFmt
     C                   EVAL      VPAYScnFmt = PAYSScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRMATS - Set Maturity Date Settlement Instructions         *
      *                                                               *
      * Called by: SR/SRMATS                                          *
      *                                                               *
      *****************************************************************
 
     C     SRMATS        BEGSR
 
     C                   EVAL      KEvntCode = 'MAT'
 
     C                   EXSR      SRFRMT
     C                   EVAL      MRECScnFmt = RECSScnFmt
     C                   EVAL      MPAYScnFmt = PAYSScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRFRMT - Convert Settlement Instructions to Screen Format  *
      *                                                               *
      * Called by: SR/SRVALS, SR/SRMATS                               *
      *                                                               *
      *****************************************************************
 
     C     SRFRMT        BEGSR
 
     C                   EVAL      RECSScnFmt = *Blanks
     C                   EVAL      PAYSScnFmt = *Blanks
     C                   EVAL      FRIRScnFmt = *Blanks
 
     C                   MOVEL     PDeal         KDeal
 
     C     KDLGXSTL1     CHAIN     DLGXSTL1                           30
 
     C                   IF        *IN30 = *OFF
     C                   CALLB     'ZASETINCVT'
     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM                    FRIRFilFmt
     C                   PARM                    PAYSScnFmt
     C                   PARM                    RECSScnFmt
     C                   PARM                    FRIRScnFmt
     C                   PARM                    InRCCY                                      CSF011A
     C                   PARM                    InPCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PDeal
     C                   PARM                    VRECScnFmt
     C                   PARM                    VPAYScnFmt
     C                   PARM                    MRECScnFmt
     C                   PARM                    MPAYScnFmt
 
     C     KDLGXSTL1     KLIST
     C                   KFLD                    KDeal
     C                   KFLD                    KEvntCode
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
