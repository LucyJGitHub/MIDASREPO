     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Funding participant control')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFPRTCTL - Funding Participant Control Update               *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             funding participant members within a syndicate.   *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 04Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CLE023             Date 12Apr02               *
      *                 CAP068  *CREATE    Date 21Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data   *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CLE023 - Recompiled due to changes to LEVFCLNPD.             *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FLEIFPRTPD O  A E             DISK    INFSR(*pssr)
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
 
      ** Funding Participant Details in screen format
     D FPRT          E DS                  EXTNAME(LEFPRTPD)
 
      ** Funding Participant Details OK indicator
     D FPRT_OK       E DS                  EXTNAME(LEEFPRTPD)
 
 
      ** Funding Participant Details in file format
     D FCLTYFMFmt    E DS                  EXTNAME(FCLTYFM)
     D***FcltyREC             455    523                                                      CGL029
     D***FcltyPAY             524   1082                                                      CGL029
     D  FcltyREC1            455    456                                                       CGL029
     D  FcltyREC2            469    523                                                       CGL029
     D  FcltyPAY1            524    525                                                       CGL029
     D  FcltyPAY2            538   1082                                                       CGL029
 
      ** New Funding Participant Details in file format record 'A'
     D LEVFCLMPD     E DS                  EXTNAME(LEVFCLMPD)
     D***LEVFCLMREC           455    523                                                      CGL029
     D***LEVFCLMPAY           524   1082                                                      CGL029
     D  LEVFCLMREC1          455    456                                                       CGL029
     D  LEVFCLMREC2          469    523                                                       CGL029
     D  LEVFCLMPAY1          524    525                                                       CGL029
     D  LEVFCLMPAY2          538   1082                                                       CGL029
 
      ** New Funding Participant Details in file format record 'B'
     D LEVFCLNPD     E DS                  EXTNAME(LEVFCLNPD)
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
     D***FLREC                  1     69                                                      CGL029
     D  FLREC1                 1      2                                                       CGL029
     D  FLREC2                21     75                                                       CGL029
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
     D***FLPAY                  1    559                                                      CGL029
     D  FLPAY1                 1      2                                                       CGL029
     D  FLPAY2                21    565                                                       CGL029
 
 
      ** Current Funding Participant Details in screen format
     D C_FPRT        E DS                  EXTNAME(LEFPRTPD)
     D                                     PREFIX(C_)
 
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD                                                CAP011
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
 
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
     D @PARM3        E DS                  EXTNAME(SDSETLPD)                                  222373
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF1MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF2MFPD)
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
      /SPACE 5
 
      * Initialisation
     C                   EXSR      INITPR
 
      ** Map incoming data into the screen fields
 
     C                   EXSR      MAPFLD
 
      * Access primary facility
 
     C                   MOVE      F1PMFC        S#PMFC
     C                   MOVE      F1PMFT        S#PMFT
     C                   MOVE      F1PMFN        S#PMFN
 
     C                   EXSR      ACSPFA
 
      *  If error in access of primary facility, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      ** Validate action code
 
     C                   EXSR      ValidateAc
 
      *  If error in validation of action code, fail this input
 
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
      * Inserts
      *  ======
 
     C     S#ACTN        WHENEQ    'I'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValidateSt
 
      *  Amends
      *  ======
 
     C     S#ACTN        WHENEQ    'A'
 
     C                   EXSR      ValidateTR
 
     C                   EXSR      ValdateAmd
 
     C                   EXSR      ValidateSt
 
      *  Reversals
      *  =========
 
     C     S#ACTN        WHENEQ    'R'
 
     C**********         MOVEL     FcltyREC      F_REC                                        CGL029
     C**********         MOVEL     FcltyPAY      F_PAY                                        CGL029
     C                   MOVEL     FcltyREC1     FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     FcltyREC2     FLREC2                                       CGL029
     C                   MOVEL     FcltyPAY1     FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     FcltyPAY2     FLPAY2                                       CGL029
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
 
     C                   MOVEL     F1RPLC        RPLOC             1
      *
      ** Syndicate member details
      *
     C                   CLEAR                   FPRT
     C     F1ACTN        IFEQ      'C'
     C                   MOVE      'R'           S#ACTN
     C                   ELSE
     C                   MOVE      F1ACTN        S#ACTN
     C                   ENDIF
      *
     C                   MOVEL     F1CNUM        S#CNUM
     C                   MOVEL     F1CNUM        S#CSSN
     C                   MOVE      F1FACT        S#FACT
     C     F1FCNO        IFNE      00
     C                   MOVE      F1FCNO        S#FCNO
     C                   ELSE
     C                   MOVE      *BLANK        S#FCNO
     C                   ENDIF
     C                   MOVE      F1INUM        S#INUM
      *
     C                   MOVEL     F1JDTE        S#JDTE
     C                   MOVE      F1JDTE        ##YEAR            2
     C                   MOVE      ##YEAR        S#JDTE
      *
     C                   MOVEL     F1VDTC        S#VDTC
     C                   MOVE      F1VDTC        ##YEAR
     C                   MOVE      ##YEAR        S#VDTC
      *
     C                   MOVE      F1SHTP        S#SHTP
     C     F1SHTP        IFEQ      'P'
     C                   MOVE      F1SHPC        S#SHAR
     C                   ELSE
     C                   MOVE      F1FAMT        S#SHAR
     C                   ENDIF
     C                   MOVE      F1RCSI        S#RCSI
     C                   MOVE      F1PASI        S#PASI
     C                   MOVE      F1SKIR        S#SKIR
     C                   MOVE      F1SKIS        S#SKIS
     C                   MOVE      F1SKFR        S#SKFR
     C                   MOVE      F1SKFS        S#SKFS
     C                   MOVE      F1NACD        S#NACD
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      F1RSTM        FLRSTM
     C                   MOVE      F1RONS        FLRONS
     C                   MOVE      F1RIBN        FLRIBN
     C                   MOVE      F1RIBA        FLRIBA
     C                   MOVE      F1ROBN        FLROBN
     C                   MOVE      F1ROCN        FLROCN
     C                   MOVE      F1OSDB        FLROBR
     C                   MOVE      F1SCCY        FLRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      F1PSTM        FLPSTM
     C                   MOVE      F1PONS        FLPONS
     C                   MOVE      F1PIBN        FLPIBN
     C                   MOVE      F1PIBA        FLPIBA
     C                   MOVE      F1POBN        FLPOBN
     C                   MOVE      F1POCN        FLPOCN
     C                   MOVE      F1CVMR        FLCVMR
     C                   MOVE      F1RCRN        FLRCRN
     C                   MOVE      F1RCRA        FLRCRA
     C                   MOVE      F1RVNO        FLRVNO
     C                   MOVE      F1AWBN        FLAWBN
     C                   MOVE      F1AWBA        FLAWBA
     C                   MOVE      F1BENN        FLBENN
     C                   MOVE      F1BENA        FLBENA
     C                   MOVE      F1DTP1        FLDTP1
     C                   MOVE      F1DTP2        FLDTP2
     C                   MOVE      F1DTP3        FLDTP3
     C                   MOVE      F1DTP4        FLDTP4
     C                   MOVE      F1DCHG        FLDCHG
     C                   MOVE      F1BTB1        FLBTB1
     C                   MOVE      F1BTB2        FLBTB2
     C                   MOVE      F1BTB3        FLBTB3
     C                   MOVE      F1BTB4        FLBTB4
     C                   MOVE      F1BTB5        FLBTB5
     C                   MOVE      F1BTB6        FLBTB6
     C                   MOVE      F1OMDB        FLPOBR
     C                   MOVE      F1SCCY        FLPSCY
     C                   MOVE      F1ICCY        FLIC72
      *                                                                   CEU004
      ** If CLE031 is switched on..                                                           CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F1REXR        ZFIELD           16                          CLE031
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
     C                   MOVE      F1PEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C                   PARM      *BLANK        PRTCD                                        CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C                   PARM      *BLANKS       ZAVAL            16                          CLE031
     C                   MOVEL     ZAVAL         FLPEXR                                       CLE031
      *                                                                                       CLE031
     C                   MOVE      F1SCCY        FLRSCY                                       CLE031
     C                   MOVE      F1REXI        FLREXI                                       CLE031
     C                   MOVE      F1PSCY        FLPSCY                                       CLE031
     C                   MOVE      F1PEXI        FLPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *
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
     C                   Z-ADD     BJRDNB        PMDTRC
     C                   Z-ADD     BJRDNB        PMDTPY
     C                   MOVE      FccyFCCY      PMRCCY
     C                   MOVE      FccyFCCY      PMPCCY
     C                   MOVE      *BLANK        PMFFND
     C                   MOVE      FcbrBranch    PMBRCA
     C                   MOVE      *BLANK        PMCMDP
     C                   Z-ADD     0             PMDBSE
     C                   MOVE      *BLANKS       PMERCD
     C                   Z-ADD     BJRDNB        PMRUND
 
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
     C                   PARM      *BLANKS       RetCodeIn
 
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
      * Access Prime Facility                                         *
      *****************************************************************
     C     ACSPFA        BEGSR
 
     C                   CALLB     'LE002510'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC            6
     C                   PARM                    S#PMFT            3
     C                   PARM                    S#PMFN            2
      *
      * OUTPUTS
      *
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
      * Prime Facility tranche/credit agreement ind
      * Prime Facility credit agreement customer, type & number
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
     C                   PARM                    FctrTRCA          2
     C**********         PARM                    FccaCANM          6 0                        CSD027
     C                   PARM                    FccaCANM          6                          CSD027
     C                   PARM                    FccaCAFT          3 0
     C                   PARM                    FccaCAFN          2 0
 
      * Primary customer name & town
     C                   PARM                    S#PRNM           20
     C                   PARM                    S#PRTN           10
 
      * Agent customer number, name & town
     C                   PARM                    S#ANUM            6
     C                   PARM                    S#CRNM           20
     C                   PARM                    S#CRTN           10
 
      * Primary facility amount edited
     C                   PARM                    S#FAMT           14
 
      * Field OK flags
     C                   PARM                    S#PMFCOK          1
     C                   PARM                    S#PMFTOK          1
     C                   PARM                    S#PMFNOK          1
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
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR
 
     C                   CALLB     'LEFPRTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      ' '           RESPMODE          1
 
      * Action, customer, facility type and facility number
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO
 
      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN
      *
      * OUTPUTS
 
      * Facility Details in file format
     C                   PARM                    FCLTYFMFmt
 
      * Action, customer, facility type and facility number OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok
     C                   PARM                    S#FACTok
     C                   PARM                    S#FCNOok
 
      * Customer number
     C                   PARM                    S#CNUM            6
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
 
      ** TNLU used in 'record updated by another WS' checking
 
     C                   Z-ADD     TNLU          H#TNLU
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR
 
     C                   CALLB     'LEFPRTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Funding Participant Details in screen format
     C                   PARM                    FPRT
 
      * Agent number
     C                   PARM                    S#ANUM            6
 
      * Prime Facility amount
      * Prime Facility branch
      * Prime Facility branch details
      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    W#FAMT           13 0
     C                   PARM                    FcbrBranch        3
     C                   PARM                    FcbrBICN          6
     C                   PARM                    FcbrMQSM         10
     C**********         PARM                    FcbrSYCU          6 0                        CSD027
     C                   PARM                    FcbrSYCU          6                          CSD027
     C                   PARM                    FccyFCCY          3
     C                   PARM                    FccyNBDP          1 0
 
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0
 
      * Front office inputs (if mode = 'B')
     C                   PARM                    F1PCOB
     C                   PARM                    F1TNRF
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      *
      * OUTPUTS
 
      * Field OK flags
     C                   PARM                    FPRT_OK
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *zero         WIdx
 
      * Valid Funding Participant Record 'A'
     C                   PARM                    LEVFCLMPD
      * Valid Funding Participant Record 'B'
     C                   PARM                    LEVFCLNPD
 
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
     C                   PARM                    @PARM3                                       222373
 
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
     C                   PARM      *BLANKS       RetCodeIn
 
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
 
     C**********         MOVEL     F_REC         LEVFCLMREC                                   CGL029
     C**********         MOVEL     F_PAY         LEVFCLMPAY                                   CGL029
     C                   MOVEL     FLREC1        LEVFCLMREC1                                  CGL029
     C                   MOVEL     FLRONS        FPRONS                                       CGL029
     C                   MOVEL     FLREC2        LEVFCLMREC2                                  CGL029
     C                   MOVEL     FLPAY1        LEVFCLMPAY1                                  CGL029
     C                   MOVEL     FLPONS        FPPONS                                       CGL029
     C                   MOVEL     FLPAY2        LEVFCLMPAY2                                  CGL029
     C                   MOVE      FLCVMR        CVMR
     C                   MOVE      FLPOBR        OMDB
     C                   MOVE      FLROBR        OSDB
     C                   MOVE      FLPSCY        SCCY
     C                   MOVE      FLRSCY        SCCY
     C                   MOVE      FLIC72        ICCY
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     FLREXR        REXR                                         CLE031
     C                   Z-ADD     FLPEXR        PEXR                                         CLE031
     C                   MOVE      FLREXI        REXI                                         CLE031
     C                   MOVE      FLPEXI        PEXI                                         CLE031
     C                   MOVE      FLRSCY        SCCY                                         CLE031
     C                   MOVE      FLPSCY        PSCY                                         CLE031
     C                   ENDIF                                                                CLE031
 
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
 
     C                   CALLB     'LEFPRTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Funding participant facility details in file format
     C                   PARM                    FCLTYFMFmt
      *
      * OUTPUTS
      *
      * Funding Participant Facility Details in screen format
     C                   PARM                    C_FPRT
 
      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
 
      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
 
     C                   CALLB     'LEFPRTAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New funding participant in Screen Format
     C                   PARM                    FPRT
      *
      * Current funding participant in Screen Format
     C                   PARM                    C_FPRT
      *
      * Current funding participant in File Format
     C                   PARM                    FCLTYFMFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FPRT_OK
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
 
     C                   EVAL      XMSGTYP = 'LEFPRT'
     C                   EVAL      XFOTRID = F1TNRF
     C                   EVAL      XFOASID = *BLANKS
     C                   EVAL      XRPRLN = 'B'
 
     C                   EVAL      FPFRNT = F1TNRF
     C                   EVAL      FPAFRT = *BLANKS
     C                   EVAL      FPREPA  = 'B'
 
     C                   WRITE     LEIFPRTD0
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
 
     C                   MOVE      F1MSGT        F2MSGT
     C                   MOVE      F1TRUS        F2TRUS
     C                   MOVE      F1TRWS        F2TRWS
     C                   MOVE      F1TNRF        F2TNRF
     C                   MOVE      F1TRSN        F2TRSN
     C                   MOVE      F1ACTN        F2ACTN
     C                   MOVE      F1TRDS        F2TRDS
     C                   MOVE      F1TRTS        F2TRTS
     C                   MOVE      F1NRBA        F2NRBA
     C                   MOVEL     'E'           F2MSGS
     C                   MOVEL     ZAMSID        F2MSGI
     C                   MOVEL     ZAMSTX        F2MSTX
     C                   MOVE      F1CNUM        F2CNUM
     C                   MOVE      F1FACT        F2FACT
     C                   MOVE      F1FCNO        F2FCNO
 
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
 
     C                   MOVE      F1MSGT        F2MSGT
     C                   MOVE      F1TRUS        F2TRUS
     C                   MOVE      F1TRWS        F2TRWS
     C                   MOVE      F1TNRF        F2TNRF
     C                   MOVE      F1TRSN        F2TRSN
     C                   MOVE      F1ACTN        F2ACTN
     C                   MOVE      F1TRDS        F2TRDS
     C                   MOVE      F1TRTS        F2TRTS
     C                   MOVE      F1NRBA        F2NRBA
     C                   MOVE      F1CNUM        F2CNUM
     C                   MOVE      F1FACT        F2FACT
     C     S#ACTN        IFEQ      'I'
     C                   MOVE      A_FCNO        F2FCNO
     C                   ELSE
     C                   MOVE      F1FCNO        F2FCNO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LEFPRTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      * Mode
     C                   PARM                    P#MODE            1
 
      * Action Code
     C                   PARM                    S#ACTN
 
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0
 
      * Funding Participant Details in file format record 'A'
     C                   PARM                    LEVFCLMPD
      * Funding Participant Details in file format record 'B'
     C                   PARM                    LEVFCLNPD
      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    FPRT_OK
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
      * Facility sequence assigned
 
     C                   PARM                    A_FCNO            2
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
 
     C* Override FCLTYXFN
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '       '     @RTCD             7            CAP011
     C                   PARM      '*FIRST '     @OPTN             7            CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD             6                          CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
 
     C                   MOVEL     'LERMSGF '    ZAMSGF
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
     C                   MOVE      'D'           F2MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)
