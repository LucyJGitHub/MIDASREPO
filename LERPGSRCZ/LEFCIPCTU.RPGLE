     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility details control')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPCTU - Facility Control Update                          *
      *                                                               *
      *  Function:  This program allows entry and maintenance of the  *
      *             facility                                          *
      *             It is a batch function.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD039655           Date 03Sep19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR937578A          Date 04Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3723            Date 19Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039655 - Facility cannot be rejected.                      *
      *             Pattern fix from MD-29208 and MD-34908.           *
      *           - Applied for MD052591.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE147 - Aggregate Facility                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00355                                 *
      *             WNCPYSRC,LEH00316                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG27041 - Incorrect mapping for MQ STCQ (Recompile)         *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3723- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************

     FLEIFCIPPD O  A E             DISK    INFSR(*pssr)
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

      * Facility in Screen Format
     D FacScnPrim    E DS                  EXTNAME(LEFCPPPD)
     D FacScnSeco    E DS                  EXTNAME(LEFCSPPD)

      * Error indicators
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)

      ** Facility FM Details in file format
     D FCLTYFMFmt    E DS                  EXTNAME(FCLTYFM) PREFIX(FM)
      ** Facility FN Details in file format
     D FCLTYFNFmt    E DS                  EXTNAME(FCLTYFN) PREFIX(FN)

      * Valid Facility FM layout
     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
      * Valid Facility FN layout
     D ValidFacn     E DS                  EXTNAME(LEVFCINPD) PREFIX(V_)

      * (Current) Facility in Screen Format - Primary Details
     D CurFcPrim     E DS                  EXTNAME(LEFCPPPD)
     D                                     PREFIX(C_)
      * (Current) Facility in Screen Format - Secondary Details
     D CurFcSeco     E DS                  EXTNAME(LEFCSPPD)
     D                                     PREFIX(C_)

      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for passing a parameter to synon screen
      ** handling program.

      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LEF1MFPD)
     D QQRONS1       E                     EXTFLD(QQRONS)                                     CGL029
     D QQPONS1       E                     EXTFLD(QQPONS)                                     CGL029

      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LEF2MFPD)

     D                 DS
     D  DDDTX5                 1      5
     D  DDDTX6                 1      6                                                      BUG3723
     D  DDDTS1A                1      1
     D  DDDTS2A                2      2
     D  DDDTS3A                3      3
     D  DDDTS4A                4      4
     D  DDDTS5A                5      5
     D  DDDTS6A                6      6                                                      BUG3723
      *  DS for rollover types
     D                 DS
     D  DDRTX6                 1      6
     D  DDRTS1A                1      1
     D  DDRTS2A                2      2
     D  DDRTS3A                3      3
     D  DDRTS4A                4      4
     D  DDRTS5A                5      5
     D  DDRTS6A                6      6
      *  DS for allowable currencies
     D                 DS
     D  DDACCY                 1     36
     D  DDCY01A                1      3
     D  DDCY02A                4      6
     D  DDCY03A                7      9
     D  DDCY04A               10     12
     D  DDCY05A               13     15
     D  DDCY06A               16     18
     D  DDCY07A               19     21
     D  DDCY08A               22     24
     D  DDCY09A               25     27
     D  DDCY10A               28     30
     D  DDCY11A               31     33
     D  DDCY12A               34     36

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
      *  ======

     C     DDACTN        WHENEQ    'I'

     C                   EXSR      ValidateTR

      *  Amends, Authorise, Reverse, Close
      *  =================================

     C     DDACTN        WHENEQ    'A'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'X'

     C                   EXSR      ValidateTR

     C                   EXSR      ValdateAmd

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
      ** Facility details
      *
     C                   CLEAR                   FacScnPrim
     C                   CLEAR                   FacScnSeco

      ** First screen
     C                   MOVE      F1ACTN        DDACTN
      *
     C                   MOVEL     F1CNUM        DDCSSN
     C                   MOVE      F1FACT        DDFACT
     C     F1FCNO        IFNE      00
     C                   MOVE      F1FCNO        DDFCNO
     C                   ELSE
     C                   MOVE      *BLANK        DDFCNO
     C                   ENDIF

     C                   MOVEL     F1BRCA        DDBRCA
     C                   MOVEL     F1FCCY        DDFCCY
     C                   MOVEL     F1FAMT        DDFAMT
     C                   MOVEL     F1OVPC        DDOVPC
     C                   MOVEL     F1FCTI        DDFCTI

     C                   MOVEL     F1DTAP        DDDTAP
     C                   MOVE      F1DTAP        W#TWO             2
     C                   MOVE      W#TWO         DDDTAP

     C                   MOVEL     F1RVCR        DDRVCR
     C                   MOVEL     F1MCCY        DDMCCY
     C                   MOVEL     F1SECI        DDSECI

     C                   MOVEL     F1DTEX        DDDTEX
     C                   MOVE      F1DTEX        W#TWO             2
     C                   MOVE      W#TWO         DDDTEX

     C                   MOVEL     F1CRSK        DDCRSK
     C                   MOVEL     F1MCSI        DDMCSI
     C                   MOVEL     F1NACD        DDNACD
     C                   MOVEL     F1MBFC        DDMBFC

     C                   MOVEL     F1DLFS        DDDLFS
     C                   MOVE      F1DLFS        W#TWO             2
     C                   MOVE      W#TWO         DDDLFS

     C                   MOVEL     F1NOMR        DDNOMR

     C                   MOVEL     F1RVDT        DDRVDT
     C                   MOVE      F1RVDT        W#TWO             2
     C                   MOVE      W#TWO         DDRVDT

     C                   MOVEL     F1RVFR        DDRVFR
     C                   MOVEL     F1RVDY        DDRVDY
     C                   MOVEL     F1ACOF        DDACOF
     C                   MOVEL     F1PRFC        DDPRFC
     C                   MOVEL     F1ORBR        DDORBR
     C                   MOVEL     F1TRCA        DDTRCA
     C                   MOVEL     F1CANM        DDCANM
     C                   MOVEL     F1CAFT        DDCAFT
     C                   MOVEL     F1CAFN        DDCAFN
     C                   MOVEL     F1NAR1        DDNAR1
     C                   MOVEL     F1NAR2        DDNAR2
     C                   MOVEL     F1NAR3        DDNAR3
     C                   MOVEL     F1NAR4        DDNAR4
     C                   MOVEL     F1BTIN        DDBTIN
     C                   MOVEL     F1BLDY        DDBLDY
     C                   MOVEL     F1ACSQ        DDACSQ

      ** Second screen
     C                   MOVEL     F1SYIN        DDSYIN
     C                   MOVEL     F1SYCP        DDSYCP
     C                   MOVEL     F1ANUM        DDANUM
     C                   MOVEL     F1DTPS        DDDTX5
     C                   MOVEL     DDDTS1A       DDDTS1
     C                   MOVEL     DDDTS2A       DDDTS2
     C                   MOVEL     DDDTS3A       DDDTS3
     C                   MOVEL     DDDTS4A       DDDTS4
     C                   MOVEL     DDDTS5A       DDDTS5
     C                   MOVEL     DDDTS6A       DDDTS6                                      BUG3723
     C                   MOVEL     F1DICB        DDDICB
     C                   MOVEL     F1RTPS        DDRTX6
     C                   MOVEL     DDRTS1A       DDRTS1
     C                   MOVEL     DDRTS2A       DDRTS2
     C                   MOVEL     DDRTS3A       DDRTS3
     C                   MOVEL     DDRTS4A       DDRTS4
     C                   MOVEL     DDRTS5A       DDRTS5
     C                   MOVEL     DDRTS6A       DDRTS6
     C                   MOVEL     DDRLPD        DDRLPD
     C                   MOVEL     DDLAID        DDLAID
     C                   MOVEL     DDCSEL        DDCSEL
     C                   MOVEL     F1ALCY        DDACCY
     C                   MOVEL     DDCY01A       DDCY01
     C                   MOVEL     DDCY02A       DDCY02
     C                   MOVEL     DDCY03A       DDCY03
     C                   MOVEL     DDCY04A       DDCY04
     C                   MOVEL     DDCY05A       DDCY05
     C                   MOVEL     DDCY06A       DDCY06
     C                   MOVEL     DDCY07A       DDCY07
     C                   MOVEL     DDCY08A       DDCY08
     C                   MOVEL     DDCY09A       DDCY09
     C                   MOVEL     DDCY10A       DDCY10
     C                   MOVEL     DDCY11A       DDCY11
     C                   MOVEL     DDCY12A       DDCY12

     C                   MOVEL     F1COMD        DDCOMD
     C                   MOVE      F1COMD        W#TWO             2
     C                   MOVE      W#TWO         DDCOMD

     C                   MOVEL     F1CDTE        DDCDTE
     C                   MOVE      F1CDTE        W#TWO             2
     C                   MOVE      W#TWO         DDCDTE

     C                   MOVEL     F1AVLD        DDAVLD
     C                   MOVE      F1AVLD        W#TWO             2
     C                   MOVE      W#TWO         DDAVLD

     C                   MOVEL     F1LPTP        DDLPTP
     C                   MOVE      F1LPBR        DDLPBR
     C                   MOVE      F1LPAM        DDLPAM
     C                   MOVEL     F1LPPS        DDLPPS
     C                   MOVEL     F1DFTP        DDDFTP
     C                   MOVEL     F1DFST        DDDFST
     C                   MOVEL     F1CAXR        DDCAXR
     C                   MOVEL     F1CMDI        DDCMDI

     C                   ENDSR

      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate the action
      *****************************************************************
     C     ValidateAc    BEGSR

     C                   CALLB     'LEFCIPRTV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn

      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      ' '           RESPMODE          1

      * Action, Front office, customer, facility type, facility number, branch
     C                   PARM                    DDACTN
     C                   PARM                    FOTRID           20
     C                   PARM                    F1TRUS
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDBRCA
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV            1                        MD039655
     C/COPY WNCPYSRC,LEH00355
      *
      * OUTPUTS

      * Facility FM Details in file format
     C                   PARM                    FCLTYFMFmt
      * Facility FN Details in file format
     C                   PARM                    FCLTYFNFmt

      * Action, customer, facility type and facility number OK indicators
     C                   PARM                    DDACTNok
     C                   PARM                    DDCSSNok
     C                   PARM                    DDFACTok
     C                   PARM                    DDFCNOok
     C/COPY WNCPYSRC,LEH00316

      * Reactivation indicator
     C                   PARM                    WREAC             1
      * New expiry date
     C                   PARM                    WNDTEX            5
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *zero         Idx

      ** TNLU used in 'record updated by another WS' checking

     C                   Z-ADD     FMTNLU        H#TNLU

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Validate transaction
      *****************************************************************
     C     ValidateTr    BEGSR

      * Validate Facility Primary details

     C                   EXSR      ValdFcPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Facility Secondary details

     C                   EXSR      ValdFcSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END

     C     EValidTr      ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * ValdFcPrim - Validate Facility Primary details                *
      *                                                               *
      *****************************************************************
     C     ValdFcPrim    BEGSR

     C                   CALLB     'LEFCIP1VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1
      * Mode
     C                   PARM                    ModeOfop          6
      ** Customer Primary Details
     C                   PARM                    FacScnPrim
      ** Customer Secondary Details                                                           CLE106
     C                   PARM                    FacScnSeco                                   CLE106
      ** Facility FM File format
     C                   PARM                    FcltyFMFmt
      ** Facility FN File format
     C                   PARM                    FcltyFNFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * CLE002
     C                   PARM                    CLE002
      * CLE005
     C                   PARM                    CLE005            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1

      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV                                     MD039655
      * OUTPUTS

      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcPrim

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm

      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacn

      * Facility amount has changed
     C                   PARM                    FacAmChg          1

      * Table OAM to be updated
     C                   PARM                    UpdOam            1

      * Start date used in the other validation module
     C                   PARM                    W#DTAP            5

      * Expiry date used in the other validation module
     C                   PARM                    W#DTEX            5

      * Facility decimal places used in the other validation module
     C                   PARM                    W#NBDP            1

      * CA currency used in the other validation module
     C                   PARM                    WCACCY            3

      * Facilty amount
     C                   PARM                    W#FAMT           13 0

      * Account officer to default
     C                   PARM                    WBLACF            1
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails        33                          CLE147

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFcSeco - Validate Facility Secondary details              *
      *                                                               *
      *****************************************************************
     C     ValdFcSeco    BEGSR

     C                   CALLB     'LEFCIP2VL'

      * INPUTS

      * Response mode
     C                   PARM                    RespMode          1
      ** Facility Primary Details
     C                   PARM                    FacScnPrim
      ** Facility Secondary Details
     C                   PARM                    FacScnSeco
      * Facility - file formats
     C                   PARM                    FcltyFmFmt
     C                   PARM                    FcltyFnFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    W#DTAP
      * Expiry date
     C                   PARM                    W#DTEX
      * Reactivation indicator
     C                   PARM                    WREAC
      * New Expiry date
     C                   PARM                    WNDTEX
      * Facility decimal places
     C                   PARM                    W#NBDP
      * OK indicator - field TRCA
     C                   PARM                    DDTRCAOK
      * OK indicator - field CAFT
     C                   PARM                    DDCAFTOK
      * OK indicator - field CAFN
     C                   PARM                    DDCAFNOK
      * CA currency used in the other validation module
     C                   PARM                    WCACCY
      * Facilty amount
     C                   PARM                    W#FAMT
      * Account officer to default
     C                   PARM                    WBLACF
      * Particiapnt Fclty indicator
     C                   PARM                    FMPRTR
      * Customer Extra Data file data
     C                   PARM                    ExtData
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
                                                                                            MD039655
      ** Reject Action Code                                                                 MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV                                     MD039655

      * OUTPUTS
      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcSeco

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacm

      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacn
      * Facility amount has changed                                                           222373
     C                   PARM                    FacAmChg          1                          222373
      * Table OAM to be updated                                                               222373
     C                   PARM                    UpdOam            1                          222373

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

     C                   CALLB     'LEFCIPCVT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Facility FM details in file format
     C                   PARM                    FCLTYFMFmt
      * Facility FN details in file format
     C                   PARM                    FCLTYFNFmt
      *
      * OUTPUTS
      *
      * Facility Details in screen format
     C                   PARM                    FacScnPrim
     C                   PARM                    FacScnSeco

     C                   CALLB     'LEFCIPAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Incoming Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    FacScnPrim
     C                   PARM                    FacScnSeco
      *
      * (Current) Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * CLE005
     C                   PARM                    CLE005
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007
      * CLE008
     C                   PARM                    CLE008
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
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
     C                   PARM                    DDREPN
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    DDTMESTMP

     C                   EVAL      DDFOTRANID = F1TNRF
     C                   EVAL      DDFOASOCID = *BLANKS
     C                   EVAL      DDRPRLOCN  = 'B'

     C                   WRITE     LEIFCIPD0
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
     C     DDACTN        IFEQ      'I'
     C                   MOVE      A_FCNO        A_FCNO            2
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
     C                   CALLB     'LEFCIPUPD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut

      * Mode
     C                   PARM                    P#MODE            1

      * Valid Facility file FM
     C                   PARM                    ValidFacm
      * Valid Facility file FN
     C                   PARM                    ValidFacn
     C                   PARM                    CLE008            1
     C                   PARM                    CSC011            1
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD            3                       AR937578A
     C                   PARM                    BJRDNB
      * TNLU of funding participant record on FCLTYFM/FN
     C                   PARM                    H#TNLU            5 0

      *
      * OUTPUTS
      *
      * Field OK flags
     C                   PARM                    OKFcPrim
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

     C**********         PARM                    A_FCNO            2                          222373
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Write to the transaction errors file                          *
      *****************************************************************
     C     W_ZATRNERR    BEGSR

     C                   MOVE      DDREPN        ##REPN            5
     C                   EVAL      ABFOTRNID  = 'LE' + ##REPN
     C                   EVAL      ABMIDASMOD = 'LE'
     C                   EVAL      ABMSGFILE  = ZAMSGF
     C                   EVAL      ABTMESTMP  = DDTMESTMP

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
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
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

      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF

      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
      *
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
      *
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF

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
