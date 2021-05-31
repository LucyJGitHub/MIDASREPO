     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee settlement control')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFESTCTU - Fee Settlement Control and update                *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             fee settlements.                                  *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054354           Date 23Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE073             Date 13May08               *
      *                 262843             Date 20Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 04Nov03               *
      *                 CAP084             Date 10Mar03               *
      *                 CLE031             Date 10Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072  *CREATE    Date 28Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054354 - Settlement of fee accrual for prior period for    *
      *             backdated notional change                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  262843 - Apply CORE fix 258669.                              *
      *  258669 - Default fee events settlement instruction first from*
      *           Fees Master if found, otherwise retrieve from       *
      *           Extended Settlement file.                           *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE106 - Syndications Manager                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Autorisation to the API's            *
      *           without it. (Recompile)                             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Valid file changed to match LEFEEAD - recompile     *
      *         - Use 24x7 runday                                     *
      *         - parms changed for LEFESTVAL                         *
      *         - Missing fields on display                           *
      *  CLE031 - Lending Enhancements.                               *
      *           LEFEED & LEFEEAD changed  - recompile               *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FLEIFESTPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPILSETPD O  A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FZATRNERRPDO  A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      ** Fee Settlement Details in screen format
     D FEST          E DS                  EXTNAME(LEFESTPD)
 
      ** Fee Settlement Details OK indicator
     D FEST_OK       E DS                  EXTNAME(LEEFESTPD)
 
      ** Fee Settlement Details in file format
     D LEFEEADFmt    E DS                  EXTNAME(LEFEEAD)
     D***LefeeaREC            124    192                                                      CGL029
     D***LefeeaPAY            193    751                                                      CGL029
     D  LefeeaREC1           124    125                                                       CGL029
     D  LefeeaREC2           138    192                                                       CGL029
     D  LefeeaPAY1           193    194                                                       CGL029
     D  LefeeaPAY2           207    751                                                       CGL029
 
      ** New Fee Settle ment Details in file format
     D LEVFESTPD     E DS                  EXTNAME(LEVFESTPD)
     D***LEVFESTREC           124    192                                                      CGL029
     D***LEVFESTPAY           193    751                                                      CGL029
     D LEVFESTOURS   E                     EXTFLD(QQOURS)                                     CGL029
     D  LEVFESTREC1          124    125                                                       CGL029
     D  LEVFESTREC2          138    192                                                       CGL029
     D  LEVFESTPAY1          193    194                                                       CGL029
     D  LEVFESTPAY2          207    751                                                       CGL029
                                                                                              258669
     D ##RECS        E DS                  EXTNAME(SDESSRPD)                                  258669
      * Receive settlement instructions in screen format                                      258669
                                                                                              258669
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)                                  258669
      * Pay settlement instructions in screen format                                          258669
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC**                1     69                                                      CGL029
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY**                1    559                                                      CGL029
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029
 
      ** Current Fee Settlement Details in screen format
     D C_FEST        E DS                  EXTNAME(LEFESTPD)
     D                                     PREFIX(C_)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIB        E DS                  EXTNAME(SETLIAB) INZ
     D SETLIBRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D SETLIBPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      ** Data structure for passing a parameter to synon screen
      ** handling program.
     D SETLIZ        E DS                  EXTNAME(SETLIAZ)
                                                                                              222373
     D Tran@PARM3    E DS                  EXTNAME(SDSETLPD)                                  222373
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF5MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF6MFPD)
                                                                                              CAP084
      ** 24X7 status dataarea                                                                 CAP084
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CAP084
                                                                                              CAP084
      ** SD data area                                                                         CAP084
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CAP084
 
      ** EXTERNAL DS FOR SAR DETAILS                                                          CAP084
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP084
                                                                                              CAP084
     D CSC011          S              1A   INZ('N')                                           CAP084
     D WProcDate       S                   LIKE(BJRDNB)                                       CAP084
     D PRTCD           S              7A                                                      CAP084
     D POPTN           S              7A                                                      CAP084
     D PSARD           S              6A                                                      CAP084
 
      /SPACE 5
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      * Inserts
      * =======
 
     C     S#ACTN        WHENEQ    'I'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
      *  Amends
      *  ======
 
     C     S#ACTN        WHENEQ    'A'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValdateAmd
 
     C                   EXSR      ValidateSt
 
      *  Deletions
      *  =========
 
     C     S#ACTN        WHENEQ    'D'
 
     C**********         MOVEL     LefeeaREC     F_REC                                        CGL029
     C**********         MOVEL     LefeeaPAY     F_PAY                                        CGL029
     C                   MOVEL     LefeeaREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LefeeaREC2    FLREC2                                       CGL029
     C                   MOVEL     LefeeaPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LefeeaPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      FASCCY        FLPSCY
     C                   MOVE      FASCCY        FLRSCY
     C                   MOVE      FAICCY        FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FAREXR        FLREXR                                       CLE031
     C                   Z-ADD     FAPEXR        FLPEXR                                       CLE031
     C                   MOVE      FAREXI        FLREXI                                       CLE031
     C                   MOVE      FAPEXI        FLPEXI                                       CLE031
     C                   MOVE      FASCCY        FLRSCY                                       CLE031
     C                   MOVE      FAPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
      *  Authorisations
      *  ==============
 
     C     S#ACTN        WHENEQ    'X'
 
     C**********         MOVEL     LefeeaREC     F_REC                                        CGL029
     C**********         MOVEL     LefeeaPAY     F_PAY                                        CGL029
     C                   MOVEL     LefeeaREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LefeeaREC2    FLREC2                                       CGL029
     C                   MOVEL     LefeeaPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LefeeaPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      FASCCY        FLPSCY
     C                   MOVE      FASCCY        FLRSCY
     C                   MOVE      FAICCY        FLIC72
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FAREXR        FLREXR                                       CLE031
     C                   Z-ADD     FAPEXR        FLPEXR                                       CLE031
     C                   MOVE      FAREXI        FLREXI                                       CLE031
     C                   MOVE      FAPEXI        FLPEXI                                       CLE031
     C                   MOVE      FASCCY        FLRSCY                                       CLE031
     C                   MOVE      FAPSCY        FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   ENDSL
 
     C     INVALID       TAG
 
      ** Do updates for this transaction
      ** according to whether it is valid or invalid
 
     C     Idx           IFEQ      0
     C                   EXSR      UPDAT_VAL
     C                   ENDIF
     C     Idx           IFNE      0
     C                   EXSR      UPDAT_INVAL
     C                   ENDIF
 
      **  Terminate program
 
     C                   SETON                                        LR
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      **  Map the input data read from the transmitted message.
      *****************************************************************
     C     MAPFLD        BEGSR
 
     C                   MOVEL     F5FIL3        RPLOC             1
      *
      ** Fee settlement details
      *
     C                   CLEAR                   FEST
     C                   MOVE      F5ACTN        S#ACTN
      *
     C                   MOVEL     F5CNUM        S#CSSN
     C                   MOVE      F5FACT        S#FACT
     C                   MOVE      F5FCNO        S#FCNO
     C                   MOVE      F5SEQR        S#FSEQ
     C                   MOVEL     F5VDTC        S#VDAT
     C                   MOVE      F5VDTC        ##YEAR            2
     C                   MOVE      ##YEAR        S#VDAT
     C                   MOVE      F5SADJ        S#SADJ
     C                   MOVE      F5TYPE        S#TYPE
     C                   MOVE      F5LOAN        S#LOAN                                       CLE073
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      F5RSTM        FLRSTM
     C                   MOVE      F5RONS        FLRONS
     C                   MOVE      F5RIBN        FLRIBN
     C                   MOVE      F5RIBA        FLRIBA
     C                   MOVE      F5ROBN        FLROBN
     C                   MOVE      F5ROCN        FLROCN
     C                   MOVEL     F5RONS        FLROBR
     C                   MOVE      F5SCCY        FLRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      F5PSTM        FLPSTM
     C                   MOVE      F5PONS        FLPONS
     C                   MOVE      F5PIBN        FLPIBN
     C                   MOVE      F5PIBA        FLPIBA
     C                   MOVE      F5POBN        FLPOBN
     C                   MOVE      F5POCN        FLPOCN
     C                   MOVE      F5CVMR        FLCVMR
     C                   MOVE      F5RCRN        FLRCRN
     C                   MOVE      F5RCRA        FLRCRA
     C                   MOVE      F5RVNO        FLRVNO
     C                   MOVE      F5AWBN        FLAWBN
     C                   MOVE      F5AWBA        FLAWBA
     C                   MOVE      F5BENN        FLBENN
     C                   MOVE      F5BENA        FLBENA
     C     35            SUBST     F5DTPN:1      FLDTP1
     C     35            SUBST     F5DTPN:36     FLDTP2
     C     35            SUBST     F5DTPN:71     FLDTP3
     C     35            SUBST     F5DTPN:106    FLDTP4
     C                   MOVE      F5DCHG        FLDCHG
     C     35            SUBST     F5BTBN:1      FLBTB1
     C     35            SUBST     F5BTBN:36     FLBTB2
     C     35            SUBST     F5BTBN:71     FLBTB3
     C     35            SUBST     F5BTBN:106    FLBTB4
     C     35            SUBST     F5BTBN:141    FLBTB5
     C     35            SUBST     F5BTBN:176    FLBTB6
     C                   MOVEL     F5PONS        FLPOBR
     C                   MOVE      F5SCCY        FLPSCY
     C                   MOVE      F5ICCY        FLIC72
      *
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F5REXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLREXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F5PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD             7                          CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLPEXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      F5SCCY        FLRSCY                                       CLE031
     C                   MOVE      F5REXI        FLREXI                                       CLE031
     C                   MOVE      F5PSCY        FLPSCY                                       CLE031
     C                   MOVE      F5PEXI        FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Setup the settlement screen fields (SETLIAB/SETLIAZ)
      *****************************************************************
     C     SETUP_SSCR    BEGSR
 
      ** Set action, customer, currencies and branch for settlement screen
 
     C                   MOVE      S#ACTN        PMACTC
     C                   MOVE      'LEND'        PMCPGM
     C                   MOVEL     S#CNUM        PMCSNM
     C                   Z-ADD     W#VDAT        PMDTRC
     C                   Z-ADD     W#VDAT        PMDTPY
     C                   MOVE      S#FCCY        PMRCCY
     C                   MOVE      S#FCCY        PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C******             Z-ADD     BJRDNB        PMRUND                                       CAP084
     C                   Z-ADD     WProcDate     PMRUND                                       CAP084
 
      ** Set settlement details valid flag
 
     C                   MOVE      'N'           PMSDTV
 
      ** Move settlement file fields to screen fields
 
     C                   EXSR      SET_FL2SC
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement file fields to screen fields (SETLIAB/SETLIAZ)*
      *****************************************************************
     C     SET_FL2SC     BEGSR
 
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
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEFESTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response Code
     C                   PARM      ' '           RESPMODE          1
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date
     C                   PARM                    S#ACTN            1
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
     C                   PARM                    S#VDAT            6
     C                   PARM                    S#LOAN            6                          CLE073
 
      *
      * OUTPUTS
 
      * Fee Settlement Details in file format
     C                   PARM                    LEFEEADFmt
     C                   PARM                    ##RECS                                       258669
     C                   PARM                    ##PAYS                                       258669
     C                   PARM                    F_REC                                        258669
     C                   PARM                    F_PAY                                        258669
 
      * Action, customer, facility type, facility number,
      * fee sequence number and value date OK indicators
     C                   PARM                    S#ACTNok          1
     C                   PARM                    S#CSSNok          1
     C                   PARM                    S#FACTok          1
     C                   PARM                    S#FCNOok          1
     C                   PARM                    S#FSEQok          1
     C                   PARM                    S#VDATok          1
     C                   PARM                    S#LOANok          1                          CLE073
 
      * Customer number
     C                   PARM                    S#CNUM            6
 
      * Fee currency and decimal places
     C                   PARM                    S#FCCY            3
     C                   PARM                    FecyNBDP          1 0
 
      * Fee type, fee code, fee narrative, fee amount due/past due
     C                   PARM                    S#FTYP           10
     C                   PARM                    S#FCOD            2
     C                   PARM                    S#FENV           20
     C                   PARM                    S#DUPD           18
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      ** TNLU used in 'record updated by another WS' checking
 
     C                   Z-ADD     FATNLU        H#TNLU
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   CALLB     'LEFESTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Fee Settlement Details in screen format
     C                   PARM                    FEST
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement settlement due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * Fee amount past due
     C                   PARM                    W#CPAM           13 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front Office Inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
     C                   PARM                    LEFEEADFmt                                 MD054354
     C                   PARM                    P_SIGN            1                        MD054354
      *
      * OUTPUTS
      * Status                                                                                CAP084
     C                   PARM                    S#STAT           10                          CAP084
      * Fee Type                                                                              CAP084
     C                   PARM                    S#FTYP           10                          CAP084
      * Fee Code                                                                              CAP084
     C                   PARM                    S#FCOD            2                          CAP084
      * Fee Code description                                                                  CAP084
     C                   PARM                    S#FENV           20                          CAP084
      * Fee Amount Due/Past Due                                                               CAP084
     C                   PARM                    S#DUPD           18                          CAP084
      * Field OK flags
     C                   PARM                    FEST_OK
 
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
 
      * Valid Fee Settlements
     C                   PARM                    LEVFESTPD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate settlement instructions
      *****************************************************************
     C     ValidateSt    BEGSR
 
      ** Setup the settlement screen fields (SETLIAB/SETLIAZ)
 
     C                   EXSR      SETUP_SSCR
 
      ** Call extended settlements input
 
     C                   CALL      'SD2410'
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
     C                   PARM                    Tran@PARM3                                   222373
 
      ** Terminate program if database error returned
 
     C     PMDBSE        IFNE      *ZERO
     C                   MOVEL     PMDBFL        DBFILE
     C                   Z-ADD     PMDBSE        DBASE
     C                   MOVEL     PMDBKY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If there are errors in the settlement screen
      ** log them
      ** Otherwise, update the file fields with the screen fields
 
     C     PMERCD        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEA1020'
     C                   ELSE
     C                   EXSR      SET_SC2FL
     C                   EXSR      SETTLEINS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Move settlement screen fields to file fields                  *
      *****************************************************************
     C     SET_SC2FL     BEGSR
 
     C                   CALLB     'LESTSC2FL'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
 
      * Screen receive and payment instructions
     C                   PARM                    SETLIB
     C                   PARM                    SETLIZ
      *
      * OUTPUTS
      *
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
 
      ** Funding Participant settlement instructions
 
     C**********         MOVEL     F_REC         LEVFESTREC                                   CGL029
     C**********         MOVEL     F_PAY         LEVFESTPAY                                   CGL029
     C                   MOVEL     FLREC1        LEVFESTREC1                                  CGL029
     C                   MOVEL     FLRONS        STRONS                                       CGL029
     C                   MOVEL     FLREC2        LEVFESTREC2                                  CGL029
     C                   MOVEL     FLPAY1        LEVFESTPAY1                                  CGL029
     C                   MOVEL     FLPONS        STPONS                                       CGL029
     C                   MOVEL     FLPAY2        LEVFESTPAY2                                  CGL029
     C                   MOVE      FLCVMR        STCVMR
     C                   MOVE      FLPOBR        STOMDB
     C                   MOVE      FLROBR        STOSDB
     C                   MOVE      FLPSCY        STSCCY
     C                   MOVE      FLRSCY        STSCCY
     C                   MOVE      FLIC72        STICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        STREXR                                       CLE031
     C                   Z-ADD     FLPEXR        STPEXR                                       CLE031
     C                   MOVE      FLREXI        STREXI                                       CLE031
     C                   MOVE      FLPEXI        STPEXI                                       CLE031
     C                   MOVE      FLRSCY        STSCCY                                       CLE031
     C                   MOVE      FLPSCY        STPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SETTLEINS: Settlement instructions                            *
      *****************************************************************
     C     SETTLEINS     BEGSR
 
      ** Receive Settlement details
 
     C     W#PTFI        IFEQ      *BLANK
 
     C                   MOVE      FLRSTM        STMETH
     C                   MOVE      FLRONS        STOURS
     C                   MOVEL     FLRIBN        STTHER
     C                   MOVE      FLROBR        STOSBR
 
     C                   MOVE      FLRSTM        STRSTM
     C                   MOVE      FLRONS        STRONS
     C                   MOVEL     FLRIBN        STRIBN
     C                   MOVEL     FLRIBA        STRIBA
     C                   MOVE      FLROBN        STROBN
     C                   MOVE      FLROCN        STROCN
     C                   MOVE      FLROBR        STOSDB
     C                   MOVE      FLRSCY        STSCCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        STREXR                                       CLE031
     C                   MOVE      FLREXI        STREXI                                       CLE031
     C                   ENDIF                                                                CLE031
 
      ** Payment Settlement details
 
     C                   ELSE
     C     W#PTFI        IFEQ      'P'
     C     W#PTFI        OREQ      'S'                                                        CLE106
     C     W#PTFI        OREQ      'R'                                                        CLE106
 
     C                   MOVE      FLPSTM        STMETH
     C                   MOVE      FLPONS        STOURS
     C                   MOVE      FLPIBN        STTHER
     C                   MOVE      FLPOBR        STOSBR
      *
     C                   MOVE      FLPSTM        STPSTM
     C                   MOVE      FLPONS        STPONS
     C                   MOVE      FLPIBN        STPIBN
     C                   MOVE      FLPIBA        STPIBA
     C                   MOVE      FLPOBN        STPOBN
     C                   MOVE      FLPOCN        STPOCN
     C                   MOVE      FLRCRN        STRCRN
     C                   MOVE      FLRCRA        STRCRA
     C                   MOVE      FLRVNO        STRVNO
     C                   MOVEL     FLAWBN        STAWBN
     C                   MOVE      FLAWBA        STAWBA
     C                   MOVEL     FLBENN        STBENN
     C                   MOVE      FLBENA        STBENA
     C                   MOVE      FLDTP1        STDTP1
     C                   MOVE      FLDTP2        STDTP2
     C                   MOVE      FLDTP3        STDTP3
     C                   MOVE      FLDTP4        STDTP4
     C                   MOVE      FLDCHG        STDCHG
     C                   MOVEL     FLBTB1        STBTB1
     C                   MOVEL     FLBTB2        STBTB2
     C                   MOVEL     FLBTB3        STBTB3
     C                   MOVEL     FLBTB4        STBTB4
     C                   MOVEL     FLBTB5        STBTB5
     C                   MOVEL     FLBTB6        STBTB6
     C                   MOVE      FLPOBR        STOMDB
     C                   MOVE      FLCVMR        STCVMR
     C                   MOVE      FLPSCY        STSCCY
     C                   MOVE      FLIC72        STICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLPEXR        STPEXR                                       CLE031
     C                   MOVE      FLPEXI        STPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate amendments
      *****************************************************************
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.
 
     C                   CALLB     'LEFESTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Fee Settlement details in file format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Fee Settlement Details in screen format
     C                   PARM                    C_FEST
 
      * Customer details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Fee currency and decimal places
     C*******            PARM                    S#FCCY            3                          CAP084
     C                   PARM                    FecyNBDP          1 0
 
      * Value date (alpha)
     C                   PARM                    S#VDTA            7
 
      * Settlement amount edited
     C                   PARM                    S#SADE           19
 
      * Record status
     C                   PARM                    S#STAT           10
      * Fee Amount Sign                                                                     MD054354
     C                   PARM                    P_SIGN            1                        MD054354
 
     C                   CALLB     'LEFESTAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New fee settlement in Screen Format
     C                   PARM                    FEST
      *
      * Current fee settlement in Screen Format
     C                   PARM                    C_FEST
      *
      * Current fee settlement in File Format
     C                   PARM                    LEFEEADFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FEST_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx             3 0
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if invalid transaction
      *****************************************************************
     C     UPDAT_INVAL   BEGSR
 
      ** If repair in back-office
 
     C     RPLOC         IFEQ      'B'
 
      ** Write to the invalid (repair) files
 
     C                   CALL      'LEC0215'
     C                   PARM                    XREPN
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    XTMST
     C                   WRITE     LEIFESTD0
     C                   WRITE     APILSETD0
     C                   EXSR      W_ZATRNERR
 
      ** Commit the database changes
 
     C                   COMMIT
 
     C                   ENDIF
 
      ** Get the text for the first error message
 
     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF
 
      ** Set up the returned message format
 
     C                   MOVE      F5MSGT        F6MSGT
     C                   MOVE      F5TRUS        F6TRUS
     C                   MOVE      F5TRWS        F6TRWS
     C                   MOVE      F5TNRF        F6TNRF
     C                   MOVE      F5TRSN        F6TRSN
     C                   MOVE      F5ACTN        F6ACTN
     C                   MOVE      F5TRDS        F6TRDS
     C                   MOVE      F5TRTS        F6TRTS
     C                   MOVE      F5NRBA        F6NRBA
     C                   MOVEL     'E'           F6MSGS
     C                   MOVEL     ZAMSID        F6MSGI
     C                   MOVEL     ZAMSTX        F6MSTX
     C                   MOVE      F5CNUM        F6CNUM
     C                   MOVE      F5FACT        F6FACT
     C                   MOVE      F5FCNO        F6FCNO
     C                   MOVE      F5SEQR        F6SEQR
     C                   MOVE      F5VDTC        F6VDTC
     C                   MOVE      F5LOAN        F6LOAN                                       CLE073
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Updates - if valid transaction
      *****************************************************************
     C     UPDAT_VAL     BEGSR
 
      ** Update the database
 
     C                   EXSR      UPD_DBASE
 
      ** If there were errors, rollback any database changes and increment
      ** the error index by 1 to drive the 'invalid' record processing
 
     C     RetCodeOut    IFNE      *BLANK
 
     C                   ADD       1             Idx
 
     C                   ROLBK
 
     C                   ELSE
 
      ** Commit the database changes
 
     C                   COMMIT
 
      ** Set up the returned message format
 
     C                   MOVE      F5MSGT        F6MSGT
     C                   MOVE      F5TRUS        F6TRUS
     C                   MOVE      F5TRWS        F6TRWS
     C                   MOVE      F5TNRF        F6TNRF
     C                   MOVE      F5TRSN        F6TRSN
     C                   MOVE      F5ACTN        F6ACTN
     C                   MOVE      F5TRDS        F6TRDS
     C                   MOVE      F5TRTS        F6TRTS
     C                   MOVE      F5NRBA        F6NRBA
     C                   MOVE      F5CNUM        F6CNUM
     C                   MOVE      F5FACT        F6FACT
     C                   MOVE      F5FCNO        F6FCNO
     C                   MOVE      F5SEQR        F6SEQR
     C                   MOVE      F5VDTC        F6VDTC
     C                   MOVE      F5LOAN        F6LOAN                                       CLE073
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFESTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN            1
 
      * Fee Settlement Details in file format
     C                   PARM                    LEVFESTPD
 
      * File Receive instructions
     C                   PARM                    F_REC
 
      * File Payment instructions
     C                   PARM                    F_PAY
 
      * Fee currency
     C                   PARM                    S#FCCY            3
 
      * Value date
     C                   PARM                    W#VDAT            5 0
 
      * Settlement amount
     C                   PARM                    W#SADJ           13 0
 
      * Settlement adjustment due date
     C                   PARM                    W#SADD            5 0
 
      * Participant Fee Indicator
     C                   PARM                    W#PTFI            1
 
      * TNLU of fee settlement record on LEFEEAD
     C                   PARM                    H#TNLU            5 0
 
      * Facility amount
      * Facility branch
      * Facility branch details
      * Facility currency
      * Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F5PCOB            3
     C                   PARM                    F5TNRF           15
     C                   PARM                    F5IUSR           10
     C                   PARM                    F5XUSR           10
     C                   PARM                    F5AUSR           10
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FEST_OK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx              3 0
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR
 
     C                   MOVE      XREPN         ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = XTMST
 
      *  Do while error messages found
      *  Write error messages to file
 
     C                   Z-ADD     1             #C                2 0
     C     #C            DOWLE     ArrayMax
     C     FldNameArr(#C)ANDNE     *BLANKS
     C                   MOVEL     FldNameArr(#C)ABFIELDNAM
     C                   MOVEL     MsgIdArr(#C)  ABMSGID
     C                   WRITE     ZATRNERRD0
     C                   ADD       1             #C
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial Processing                                            *
      *****************************************************************
     C     INITPR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MODE            1
     C                   PARM                    P#INMF
     C                   PARM                    P#OUMF
      *
      ** Access Bank Details
      *  ~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     901           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
                                                                                              CAP084
      ** Check if CSC011 is installed                                                         CAP084
     C                   CALL      'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANKS       PRTCD                                        CAP084
     C                   PARM      '*VERIFY'     POPTN                                        CAP084
     C                   PARM      'CSC011'      PSARD                                        CAP084
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP084
                                                                                              CAP084
     C                   IF        PRTCD = *Blanks                                            CAP084
                                                                                              CAP084
     C                   EVAL      CSC011 = 'Y'                                               CAP084
                                                                                              CAP084
     C                   IN        SC24X7                                                     CAP084
     C                   IN        SDSTAT                                                     CAP084
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
      ** Database error                                                                       CAP084
     C                   IF        PRTCD <> '*NRF'                                            CAP084
     C     *LOCK         IN        LDA                                                        CAP084
     C                   EVAL      DBKEY = 'CSC011'                                           CAP084
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP084
     C                   EVAL      DBASE = 900                                                CAP084
     C                   OUT       LDA                                                        CAP084
     C                   EXSR      *PSSR                                                      CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** If 24X7 Midas availability is installed and support system is                        CAP084
      ** active, used processing date from dataarea SC24X7 as the                             CAP084
      ** rundate.                                                                             CAP084
                                                                                              CAP084
     C                   IF        CSC011 = 'Y' AND                                           CAP084
     C                             S1SUPP = LIBR                                              CAP084
     C                   EVAL      WProcDate = S1DATE                                         CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      WProcDate = BJRDNB                                         CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Program exception error routine                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'D'           F6MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002