     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV read function')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEDPMVRED - SE Depot Movement Transaction Read Function.     *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the SE Depot Movement File.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 222727             Date 05Nov03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *Create     Date 14May98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Auto-settle of trades. Amendment to allow SEDPMVSIN *
      *           to be called from SE4400 in 'E' mode.               *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled).   *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDPTMV     IF   E           K DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,SEDPMVEF01
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
 
      ** External DS for Bank Details
      ** DS for Access Programs, Short DS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      *
      ** Initialize Outputs
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @DPRNSel
     C                   MOVEL     *BLANK        @DPSSSel
      *
      ** Check for User Authority to Browse If Not Multi-Branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChkAut
     C                   END
      *
      ** Validate Ref Number and Security. (FOR POINTER)
      *
     C                   EXSR      SRValKey
      *
      ** Read Forward
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      SRRdFwd
     C                   ELSE
      *
      ** Read Backwards
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      SRRdBck
     C                   END
     C                   END
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdFwd - Read Forwards through SE Deals File                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdFwd       BEGSR
      *
      ** Position to current record on file
      *
     C     Transkey      KLIST
     C                   KFLD                    @@DPSSK          10
     C                   KFLD                    @@DPRNK           6
 
     C/COPY WNCPYSRC,SEDPMVEC01
     C     TransKey      SETGT     DPTMV
     C/COPY WNCPYSRC,SEDPMVEC02
      *
      ** Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     DPMV          OREQ      DPMVType
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file.
      *
     C/COPY WNCPYSRC,SEDPMVEC03
     C                   READ      DPTMV                                  99
     C/COPY WNCPYSRC,SEDPMVEC04
      *
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
      *
      ** No check required if called from another program eg SE4400                           CSE039
     C     CallProg      IfEq      *Blanks                                                    CSE039
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DPBA
     C                   PARM                    @@ERR
     C                   END
     C                   EndIf                                                                CSE039
      *
     C                   END
      *
      ** If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     DDDPRN        IFEQ      *BLANKS
     C                   MOVEL     'FXM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'FXM1002'     @ERRMS
     C                   END
      *
      ** Else, return the deal number read and security shortname
      *
     C                   ELSE
     C                   MOVE      DPRN          @DPRNSel
     C                   MOVE      DPSS          @DPSSSel
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdBck - Read Backwards Through the SE Deals File            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdBck       BEGSR
      *
      ** Position to current record on file
      *
     C/COPY WNCPYSRC,SEDPMVEC05
     C     TransKey      SETLL     DPTMV
     C/COPY WNCPYSRC,SEDPMVEC06
      *
      ** Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     DPMV          OREQ      DPMVType
     C     @@ERR         ANDEQ     *ZERO
      *
      ** Read from complete or requires authorization
      ** or from authorized
      *
     C/COPY WNCPYSRC,SEDPMVEC07
     C                   READP     DPTMV                                  99
     C/COPY WNCPYSRC,SEDPMVEC08
      *
      ** If multi-branching, check if authorized to look at deal (based
      ** on branch) but if invalid continue searching for valid branch
      *
      ** No check required if called from another program eg SE4400                           CSE039
     C     CallProg      IfEq      *Blanks                                                    CSE039
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DPBA
     C                   PARM                    @@ERR
     C                   END
     C                   EndIf                                                                CSE039
 
     C                   END
      *
      ** If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FXM1003'     @ERRMS
      *
      ** Else, return the deal number read
      *
     C                   ELSE
     C                   MOVE      DPRN          @DPRNSel
     C                   MOVE      DPSS          @DPSSSel
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Check for User Authority if not Multi-Branching    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRChkAut      BEGSR
 
      * If called from SE4400 (Securities Movements Enquiry) skip                             CSE039
      * SPF processing.                                                                       CSE039
     C     CallProg      IFEQ      *BLANKS                                                    CSE039
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Retrun Error Message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CSE039
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValKey - Validate Transaction Ref. No. and Security         *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Call : None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRValKey      BEGSR
      *
      **  Validate that the SE deal number is numeric or blank.
      *
     C                   TESTN                   DDDPRN               98
     C                   MOVE      DDDPRN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
 
     C     DDDPRN        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDDPRN        @@DPRNK           6
      *
      ** Return Error Messages
      *
     C                   ELSE
     C                   MOVEL     'MMA0425'     @ERRMS
     C                   RETURN
     C                   END
      *
      ** Security
      *
     C                   MOVE      DDDPSS        @@DPSSK          10
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Received Parameters
      ** -------------------
      *
      ** Action Code
      ** Depot Movement Type
      ** Reference Number (Pointer)
      ** Security (Pointer)
     C                   PARM                    DDACTN            1
     C                   PARM                    DPMVType          2
     C                   PARM                    CallProg         10                          CSE039
     C                   PARM                    DDDPRN            6
     C                   PARM                    DDDPSS           10
      *
      ** Read Forward Ind
      ** Read Backward Ind
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Error Message
     C                   PARM                    @ERRMS            7
      *
      ** Reference Number Read
      ** Security Read
     C                   PARM                    @DPRNSel          6
     C                   PARM                    @DPSSSel         10
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVRED'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,SEDPMVEC09
      *
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
(c) Misys International Banking Systems Ltd. 2001
