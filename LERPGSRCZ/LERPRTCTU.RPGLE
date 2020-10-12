     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Risk participant control')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LERPRTCTL - Risk Participant Control                         *
      *                                                               *
      *  Function:  This program allows entry and maintenance of      *
      *             the risk participant members within a syndicate   *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 29Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP069  *CREATE    Date 18Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAP069 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FLEIRPRTPD O  A E             DISK    INFSR(*pssr)
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
      ** The following /COPY includes the standard declares:
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

      ** Risk Participant Details in screen format
     D RPRT          E DS                  EXTNAME(LERPRTPD)

      ** Risk Participant Details OK indicator
     D RPRT_OK       E DS                  EXTNAME(LEERPRTPD)

      ** Risk Participant Details in file format
     D LEPARTPDFmt   E DS                  EXTNAME(LEPARTPD)
     D***LeRPRTREC             72    140                                                      CGL029
     D***LeRPRTPAY            141    699                                                      CGL029
     D  LeRPRTREC1            72     73                                                       CGL029
     D  LeRPRTREC2            86    140                                                       CGL029
     D  LeRPRTPAY1           141    142                                                       CGL029
     D  LeRPRTPAY2           155    699                                                       CGL029

      ** Valid Risk Participant Details in file format
     D LEVRPRTPD     E DS                  EXTNAME(LEVRPRTPD)
     D***V_REC                 72    140                                                      CGL029
     D***V_PAY                141    699                                                      CGL029
     D  VLREC1                72     73                                                       CGL029
     D  VLREC2                86    140                                                       CGL029
     D  VLPAY1               141    142                                                       CGL029
     D  VLPAY2               155    699                                                       CGL029

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

      ** Current Risk Participant Details in screen format
     D C_RPRT        E DS                  EXTNAME(LERPRTPD)
     D                                     PREFIX(C_)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

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
     D P#INMF        E DS                  EXTNAME(LER1MFPD)
     D P#INMFRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P#INMFPONS    E                     EXTFLD(QQPONS)                                     CGL029

      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LER2MFPD)

      /SPACE 5

      * Initialisation
     C                   EXSR      INITPR

      ** Map incoming data into the screen fields

     C                   EXSR      MAPFLD

      * Access primary facility

     C                   MOVE      R1CNUM        S#PMFC
     C                   MOVE      R1FACT        S#PMFT
     C                   MOVE      R1FCNO        S#PMFN

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

      *  Deletions
      *  =========

     C     S#ACTN        WHENEQ    'D'

     C**********         MOVEL     LeRPRTREC     F_REC                                        CGL029
     C**********         MOVEL     LeRPRTPAY     F_PAY                                        CGL029
     C                   MOVEL     LeRPRTREC1    FLREC1                                       CGL029
     C                   MOVEL     RONS          FLRONS                                       CGL029
     C                   MOVEL     LeRPRTREC2    FLREC2                                       CGL029
     C                   MOVEL     LeRPRTPAY1    FLPAY1                                       CGL029
     C                   MOVEL     PONS          FLPONS                                       CGL029
     C                   MOVEL     LeRPRTPAY2    FLPAY2                                       CGL029
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      SCCY          FLRSCY
     C                   MOVE      ICCY          FLIC72

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

     C                   MOVEL     R1RPLC        RPLOC             1
      *
      ** Syndicate member details
      *
     C                   CLEAR                   RPRT
     C                   MOVE      R1ACTN        S#ACTN
      *
     C                   MOVEL     R1MNUM        S#CNUM
     C                   MOVEL     R1MNUM        S#CSSN
     C                   MOVEL     R1INUM        S#INUM
      *
     C                   MOVEL     R1JDTE        S#JDTE
     C                   MOVE      R1JDTE        ##YEAR            2
     C                   MOVE      ##YEAR        S#JDTE
      *
     C                   MOVE      R1SHTP        S#SHTP
     C     R1SHTP        IFEQ      'P'
     C                   MOVE      R1SHPC        S#SHAR
     C                   ELSE
     C                   MOVE      R1SHAM        S#SHAR
     C                   ENDIF
     C                   MOVE      R1FEBR        S#FEBR
     C                   MOVE      R1FERA        S#FERA
     C                   MOVE      R1FERS        S#FERS
     C                   MOVE      R1DRTP        S#DRTP
     C                   MOVE      R1DRST        S#DRST
      *
      ** Receive instructions
      *
     C                   CLEAR                   F_REC
     C                   MOVE      R1RSTM        FLRSTM
     C                   MOVE      R1RONS        FLRONS
     C                   MOVE      R1RIBN        FLRIBN
     C                   MOVE      R1RIBA        FLRIBA
     C                   MOVE      R1ROBN        FLROBN
     C                   MOVE      R1ROCN        FLROCN
     C                   MOVEL     R1RONS        FLROBR
     C                   MOVE      R1SCCY        FLRSCY
      *
      ** Payment instructions
      *
     C                   CLEAR                   F_PAY
     C                   MOVE      R1PSTM        FLPSTM
     C                   MOVE      R1PONS        FLPONS
     C                   MOVE      R1PIBN        FLPIBN
     C                   MOVE      R1PIBA        FLPIBA
     C                   MOVE      R1POBN        FLPOBN
     C                   MOVE      R1POCN        FLPOCN
     C                   MOVE      R1CVMR        FLCVMR
     C                   MOVE      R1RCRN        FLRCRN
     C                   MOVE      R1RCRA        FLRCRA
     C                   MOVE      R1RVNO        FLRVNO
     C                   MOVE      R1AWBN        FLAWBN
     C                   MOVE      R1AWBA        FLAWBA
     C                   MOVE      R1BENN        FLBENN
     C                   MOVE      R1BENA        FLBENA
     C     35            SUBST     R1DTP1:1      FLDTP1
     C     35            SUBST     R1DTP1:36     FLDTP2
     C     35            SUBST     R1DTP1:71     FLDTP3
     C     35            SUBST     R1DTP1:106    FLDTP4
     C                   MOVE      R1DCHG        FLDCHG
     C     35            SUBST     R1BTB1:1      FLBTB1
     C     35            SUBST     R1BTB1:36     FLBTB2
     C     35            SUBST     R1BTB1:71     FLBTB3
     C     35            SUBST     R1BTB1:106    FLBTB4
     C     35            SUBST     R1BTB1:141    FLBTB5
     C     35            SUBST     R1BTB1:176    FLBTB6
     C                   MOVEL     R1PONS        FLPOBR
     C                   MOVE      R1SCCY        FLPSCY
     C                   MOVE      R1ICCY        FLIC72
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
     C                   PARM      *BLANK        RetCodeIn

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

     C                   CALLB     'LE002520'
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

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR

     C                   CALLB     'LERPRTRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      ' '           RESPMODE          1

      * Action and customer
     C                   PARM                    S#ACTN
     C                   PARM                    S#CSSN

      * Primary facility customer, type & number
     C                   PARM                    S#PMFC
     C                   PARM                    S#PMFT
     C                   PARM                    S#PMFN

      * Prime facility branch
     C                   PARM                    FcbrBranch
      *
      * OUTPUTS

      * Participant Details in file format
     C                   PARM                    LEPARTPDFmt

      * Action and customer OK indicators
     C                   PARM                    S#ACTNok
     C                   PARM                    S#CSSNok

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

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR

     C                   CALLB     'LERPRTVAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1

      * Risk Participant Details in screen format
     C                   PARM                    RPRT

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

      * Front office inputs (if mode = 'B')
     C                   PARM                    R1PCOB
     C                   PARM                    R1TNRF
      *
      * OUTPUTS

      * Field OK flags
     C                   PARM                    RPRT_OK
      *
      * Syndicate customer number
     C                   PARM                    S#CNUM            6
      * Syndicate member customer name/town
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10
      * Introducing customer name/town
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10
      *
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

      * Valid Risk Participant Details
     C                   PARM                    LEVRPRTPD

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
     C                   PARM      *BLANK        RetCodeIn

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

      ** Risk Participant settlement instructions

     C**********         MOVEL     F_REC         V_REC                                        CGL029
     C**********         MOVEL     F_PAY         V_PAY                                        CGL029
     C                   MOVEL     FLREC1        VLREC1                                       CGL029
     C                   MOVEL     FLRONS        ASRONS                                       CGL029
     C                   MOVEL     FLREC2        VLREC2                                       CGL029
     C                   MOVEL     FLPAY1        VLPAY1                                       CGL029
     C                   MOVEL     FLPONS        ASPONS                                       CGL029
     C                   MOVEL     FLPAY2        VLPAY2                                       CGL029
     C                   MOVE      FLCVMR        ASCVMR
     C                   MOVE      FLPOBR        ASOMDB
     C                   MOVE      FLROBR        ASOSDB
     C                   MOVE      FLPSCY        ASSCCY
     C                   MOVE      FLRSCY        ASSCCY
     C                   MOVE      FLIC72        ASICCY

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

     C                   CALLB     'LERPRTCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Risk participant details in file format
     C                   PARM                    LEPARTPDFmt

      * Prime Facility currency
      * Prime Facility currency decimal places
     C                   PARM                    FccyFCCY
     C                   PARM                    FccyNBDP
      *
      * OUTPUTS
      *
      * Risk Participant Details in screen format
     C                   PARM                    C_RPRT

      * Syndicate member details
     C                   PARM                    S#CNUM            6
     C                   PARM                    S#CSNM           10
     C                   PARM                    S#SRNM           20
     C                   PARM                    S#SRTN           10

      * Introducing customer details
     C                   PARM                    S#IRNM           20
     C                   PARM                    S#IRTN           10

     C                   CALLB     'LERPRTAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * New risk participant in Screen Format
     C                   PARM                    RPRT
      *
      * Current risk participant in Screen Format
     C                   PARM                    C_RPRT
      *
      * Current risk participant in File Format
     C                   PARM                    LEPARTPDFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    RPRT_OK
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

     C                   EVAL      XMSGTYP = 'LERPRT'
     C                   EVAL      XFOTRID = R1TNRF
     C                   EVAL      XFOASID = *BLANKS
     C                   EVAL      XRPRLN = 'B'

     C                   EVAL      DDFRNT     = R1TNRF
     C                   EVAL      DDAFRT     = *BLANKS
     C                   EVAL      DDREPA     = 'B'

     C                   WRITE     LEIRPRTD0
     C                   WRITE     APILSETD0
     C                   EXSR      W_ZATRNERR

      ** Commit the database changes

     C                   COMMIT

     C                   ENDIF

      ** Get the text for the first error message

     C                   MOVEL     MsgIDArr(1)   ZAMSID
     C     ZAMSID        IFNE      *BLANK
     C                   CALL      'Y2RVMGC'                            9999
     C                   PARM                    @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM      *BLANK        ZAMSDA          132
     C                   PARM      *BLANK        ZAMSTX          132
     C                   ENDIF

      ** Set up the returned message format

     C                   MOVE      R1MSGT        R2MSGT
     C                   MOVE      R1TRUS        R2TRUS
     C                   MOVE      R1TRWS        R2TRWS
     C                   MOVE      R1TNRF        R2TNRF
     C                   MOVE      R1TRSN        R2TRSN
     C                   MOVE      R1ACTN        R2ACTN
     C                   MOVE      R1TRDS        R2TRDS
     C                   MOVE      R1TRTS        R2TRTS
     C                   MOVE      R1NRBA        R2NRBA
     C                   MOVEL     'E'           R2MSGS
     C                   MOVEL     ZAMSID        R2MSGI
     C                   MOVEL     ZAMSTX        R2MSTX
     C                   MOVE      R1CNUM        R2CNUM
     C                   MOVE      R1FACT        R2FACT
     C                   MOVE      R1FCNO        R2FCNO
     C                   MOVE      R1MNUM        R2MNUM
     C                   MOVE      R1INUM        R2INUM

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

     C                   MOVE      R1MSGT        R2MSGT
     C                   MOVE      R1TRUS        R2TRUS
     C                   MOVE      R1TRWS        R2TRWS
     C                   MOVE      R1TNRF        R2TNRF
     C                   MOVE      R1TRSN        R2TRSN
     C                   MOVE      R1ACTN        R2ACTN
     C                   MOVE      R1TRDS        R2TRDS
     C                   MOVE      R1TRTS        R2TRTS
     C                   MOVE      R1NRBA        R2NRBA
     C                   MOVE      R1CNUM        R2CNUM
     C                   MOVE      R1FACT        R2FACT
     C                   MOVE      R1FCNO        R2FCNO
     C                   MOVE      R1MNUM        R2MNUM
     C                   MOVE      R1INUM        R2INUM

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update the Database                                           *
      *****************************************************************
     C     UPD_DBASE     BEGSR
      *
     C                   CALLB     'LERPRTUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Action Code
     C                   PARM                    S#ACTN

      * Risk Participant Details in file format
     C                   PARM                    LEVRPRTPD

      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    RPRT_OK
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

      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     902           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

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
     C                   MOVE      'D'           R2MSGS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
