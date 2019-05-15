     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details Screen Input')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLSIN - Collateral Details Screen Input                  *
      *                                                               *
      *  Function: This module will control the calls to all the      *
      *            lower level collateral modules. It will also       *
      *            call the collateral allocations screen input       *
      *            module and the collateral narrative details        *
      *            screen input module.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL072             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018             Date 26Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CGL072 - Allow GL Accounts as Collateral                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *  CGL011 - Collateral Processing for Midas DBA (Phase 1)       *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLCOLLS001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Collateral Definition Details from incoming transaction
      ** - in screen format
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      *
      ** Initial screen fields
     D  NwCoScnInt             1     64
      ** First screen fields
     D  NwCoScn1st            65    306
      ** Second screen fields
     D**NwCoScn2nd           307    654                                                       CGL029
     D  NwCoScn2nd           307    666                                                       CGL029
      ** Third screen fields
     D**NwCoScn3rd           655    740                                                       CGL029
     D  NwCoScn3rd           667    752                                                       CGL029
      *
      ** Collateral Definition Details - for file update
     D NwCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      *
      ** Collateral Definition Details retrieved from file
      ** - in file format
     D CrCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(P_)
      *
      ** Error indicators
     D OKCoScnFld    E DS                  EXTNAME(GLECOLPD)
      *
      ** Initial screen error inds
     D  IndInitial             1     12
      ** First screen error inds
     D  IndFirst              13     43
      ** Second screen error inds
     D  IndSecond             44     73
      ** Third screen error inds
     D  IndThird              74     84
      *
      ** Previous First screen fields
     D PrCoScn1st      S                    LIKE(NwCoScn1st)
      ** Previous Second screen fields
     D PrCoScn2nd      S                    LIKE(NwCoScn2nd)
      ** Previous Third screen fields
     D PrCoScn3rd      S                    LIKE(NwCoScn3rd)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Dealing Data
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D/COPY QWINDSRC,GLCOLLSDTA
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDX             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDX            S              3P 0
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D RespMode        S              1A   INZ('S')
      *
      ** Lending Amount Change indicator
     D WLendChg        S              1A   IMPORT                               CGL011
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLCOLLS002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,GLCOLLS003
      *
      ** DO WHILE screen: Initial screen
      *
     C     ScrnMode      DOWEQ     'I'
     C                   EXSR      SRINITIAL
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS004
      *
     C     ScrnMode      IFEQ      'G'
     C                   EXSR      SRALLOCATE
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLCOLLS005
      *
     C     ScrnMode      IFEQ      'N'
     C                   EXSR      SRNARRATIVE
     C                   ENDIF
      *
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C     ScrnMode      IFEQ      'Z'                                                        CGL018
     C                   EXSR      SRRWASSET                                                  CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
      /COPY WNCPYSRC,GLCOLLS006
      *
      ** DO WHILE Screen: First detail screen
      *
     C     ScrnMode      DOWEQ     '1'
     C                   EXSR      SRFIRST
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS007
      *
      ** DO WHILE Screen: Second detail screen
      *
     C     ScrnMode      DOWEQ     '2'
     C                   EXSR      SRSECOND
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS008
      *
      ** DO WHILE Screen: Third detail screen
      *
     C     ScrnMode      DOWEQ     '3'
     C                   EXSR      SRTHIRD
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS009
      *
      ** DO WHILE Screen: Browser screen
      *
     C     ScrnMode      DOWEQ     'B'
     C                   EXSR      SRBROWSER
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS010
      *
      ** DO WHILE Screen: Select Browser records
      *
     C     ScrnMode      DOWEQ     'R'
     C                   EXSR      SRSELBRW
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLCOLLS011
      *
     C     ScrnMode      IFEQ      'W'
     C                   EXSR      SRWINDOW
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLCOLLS012
      *
     C     ScrnMode      IFEQ      'U'
     C     WLendChg      IFEQ      'Y'
     C                   MOVE      'G'           ScrnMode
     C                   ELSE
     C                   EXSR      SRUPDATE
     C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLCOLLS013
      *
      ** Terminate Program.
      *
     C     ScrnMode      IFEQ      'T'
     C                   ROLBK                                                  CGL018
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLCOLLS014
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINITIAL - Initial screen processing                        *
      *                                                               *
      *****************************************************************
     C     SRINITIAL     BEGSR
      *
      ** Issue rollback to clear any possible updates in window functions
     C                   ROLBK
      *
     C                   MOVE      'I'           ScrnStart         1
     C                   MOVE      'I'           ScrnPrev          1
     C                   MOVE      *Blank        WLendChg
     C                   MOVEL     'N'           ConfInd
      *
     C                   EXSR      SRDISPLAY
     C                   EXSR      SRRESETERR
      *
     C     PINKC         CASEQ     True          SREND
     C     PINKL         CASEQ     True          SRCANCEL
     C                   CAS                     SRVALINIT
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDISPLAY - Screen display processing                        *
      *                                                               *
      *****************************************************************
     C     SRDISPLAY     BEGSR
      *
      ** Call collateral details display module
     C                   CALLB     'GLCOLLDSP'
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Collateral details (in screen format)
     C                   PARM                    NwCoScnFmt
      *
      ** Fields in error
     C                   PARM                    OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Screen Mode
     C                   PARM                    ScrnMode
      *
      ** Enquiry Mode
     C                   PARM                    PENQ
      *
     C                   PARM                    CGL012
      *
      ** Collateral Processing Type
     C                   PARM                    CDCOPT
      *
      ** Genera/Specific Indicator
     C                   PARM                    CDGNSP
      *
      ** Enabled function keys
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Allocation
      ** KQ = Command key 16 = Narrative Details
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKR                                       CGL018
      *
      ** Successful Inserted Collateral
     C                   PARM                    WSCREF           10
      *
      ** Confirmation indicator
     C                   PARM                    ConfInd           1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Function Keys Taken
     C                   PARM      False         PINKC             1
     C                   PARM      False         PINKJ             1
     C                   PARM      False         PINKL             1
     C                   PARM      False         PINKP             1
     C                   PARM      False         PINKQ             1
     C                   PARM      False         PINKR             1                          CGL018
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND - Terminate processing                                 *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
      *
     C                   MOVEL     'T'           ScrnMode
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCANCEL - Cancellation processing                           *
      *                                                               *
      *****************************************************************
     C     SRCANCEL      BEGSR
      *
     C     ScrnMode      IFEQ      'I'
     C     ScrnMode      OREQ      '1'
     C     ScrnMode      OREQ      'B'
     C                   MOVEL     'N'           PEINKJ
     C                   MOVEL     'N'           PEINKP
     C                   MOVEL     'N'           PEINKQ
     C                   EVAL      PEINKR = 'N'                                               CGL018
     C                   CLEAR                   NwCoFilFmt
     C                   CLEAR                   NwCoScn1st
     C                   CLEAR                   NwCoScn2nd
     C                   CLEAR                   NwCoScn3rd
     C     ScrnMode      IFEQ      'I'
     C     ScrnMode      OREQ      'B'
     C                   CLEAR                   NwCoScnInt
     C                   ENDIF
     C                   ENDIF
      *
     C     ScrnMode      IFEQ      '2'
     C     ScrnMode      OREQ      '3'
     C     ScrnMode      OREQ      'W'
     C                   MOVEL     'N'           PEINKJ
     C                   MOVEL     'Y'           PEINKQ
     C                   MOVEL     'N'           PEINKP
     C                   EVAL      PEINKR = 'Y'                                               CGL018
     C     DDGNSP        IFEQ      'G'
     C                   MOVEL     'Y'           PEINKP
     C                   ENDIF
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           PEINKJ
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      ScrnMode  = ScrnPrev
      *
     C                   SELECT
     C     ScrnMode      WHENEQ    'I'
     C     ScrnMode      OREQ      'B'
     C                   MOVEL     'I'           ScrnPrev
     C     ScrnMode      WHENEQ    'R'
     C                   MOVEL     'B'           ScrnPrev
     C     ScrnMode      WHENEQ    '1'
     C                   MOVEL     ScrnStart     ScrnPrev
     C     ScrnMode      WHENEQ    '2'
     C                   MOVEL     '1'           ScrnPrev
     C     ScrnMode      WHENEQ    '3'
     C                   MOVEL     '2'           ScrnPrev
     C                   ENDSL
      *
     C                   MOVEL     'N'           ConfInd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCONVERT - Convert File Data to Screen Format               *
      *                                                               *
      *****************************************************************
     C     SRCONVERT     BEGSR
      *
      ** Call collateral details convrt module
     C                   CALLB     'GLCOLLCVT'
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Collateral details (file format)
     C                   PARM                    CrCoFilFmt
      *
     C                   PARM                    CGL012
      *
      ** Collateral details (in screen format)
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM      *BLANKS       TransStat
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALINIT - Initial Screen Validation                        *
      *                                                               *
      *****************************************************************
     C     SRVALINIT     BEGSR
      *
     C                   EXSR      SRRETRIEVE
      *
     C     IndInitial    IFEQ      *ALL'Y'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     *BLANK
     C                   EXSR      SRCONVERT
     C                   MOVEL     CrCoFilFmt    NwCoFilFmt
     C                   ENDIF
      *
     C     DDACTN        IFNE      *BLANK
     C     DDACTN        IFEQ      'G'
     C                   MOVEL     'G'           ScrnMode
     C                   ENDIF
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C     DDACTN        IFEQ      'Z'                                                        CGL018
     C                   EVAL      ScrnMode = 'Z'                                             CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
     C     DDACTN        IFEQ      'N'
     C                   MOVEL     'N'           ScrnMode
     C                   ENDIF
     C     DDACTN        IFNE      'G'
     C     DDACTN        ANDNE     'N'
     C                   MOVEL     '1'           ScrnMode
     C                   MOVE      'I'           ScrnPrev
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'B'           ScrnMode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRETRIEVE - Retrieve Collateral Details                     *
      *                                                               *
      *****************************************************************
     C     SRRETRIEVE    BEGSR
      *
      ** Call the collateral details retieve module
      *
     C                   CALLB     'GLCOLLRTV'
      *
      ** INPUT PARAMETERS:
      *
      ** Initial screen fields
     C                   PARM                    DDACTN
     C                   PARM                    DDCREF
     C                   PARM                    DDREVF
     C                   PARM                    DDREQR
     C                   PARM                    DDSENT
     C                   PARM                    DDSCMP
     C                   PARM                    DDSBRC
     C                   PARM                    DDSCOL
     C                   PARM                    DDSCNU
     C                   PARM                    DDSCCY
     C                   PARM                    DDSVAL
     C                   PARM                    DDSGNS
      *
     C                   PARM                    CGL012
      *
      ** Mode of operation
     C                   PARM      *BLANKS       ModeOp            6
      *
      ** Response Mode
     C                   PARM      'S'           RespMode
      *
      ** Front Office Id
     C                   PARM      *BLANKS       FOTRID           20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       CrCoFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK
     C                   PARM      *BLANK        DDCREFOK
     C                   PARM      *BLANK        DDREVFOK
     C                   PARM      *BLANK        DDREQROK
     C                   PARM      *BLANK        DDSENTOK
     C                   PARM      *BLANK        DDSCMPOK
     C                   PARM      *BLANK        DDSBRCOK
     C                   PARM      *BLANK        DDSCOLOK
     C                   PARM      *BLANK        DDSCNUOK
     C                   PARM      *BLANK        DDSCCYOK
     C                   PARM      *BLANK        DDSVALOK
     C                   PARM      *BLANK        DDSGNSOK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRALLOCATE - Collateral Allocations processing               *
      *                                                               *
      *****************************************************************
     C     SRALLOCATE    BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C     DDCREF        ANDEQ     *BLANKS
     C                   EXSR      SRGENREFNO
     C                   MOVEL     PGENREF       CDCREF
     C                   MOVEL     PGENREF       DDCREF
     C                   ENDIF
      *
     C                   MOVEL     'C'           WConvert          1
     C                   EXSR      SRConvAmt
      *
      ** Call collateral allocations detail screen input module
     C                   CALL      'GLCOLASIN'
      *
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      DDACTN        PACTION           1
     C                   PARM                    DDCREF
     C                   PARM                    DDCCY
     C                   PARM                    PPctAllo         11
     C                   PARM                    DDLAMT
     C                   PARM                    POLenVal         16
     C                   PARM                    PTotAllo         16
     C                   PARM      *BLANK        PALCUPD           1
     C                   PARM      *BLANK        PNARSEL           1
     C                   PARM      False         PINKC
     C                   PARM      *BLANK        PRWASEL           1                          CGL018
      *
     C     RetCodeOut    IFNE      *BLANKS
      *
     C                   SELECT
     C     RetCodeOut    WHENEQ    'Y2U9999'
     C                   EXSR      SREND
     C     RetCodeOut    WHENEQ    'USR0790'
     C                   EXSR      SRCANCEL
     C                   OTHER
     C                   MOVEL     DDCREF        DBKEY
     C                   MOVEL     'GLCOLASIN   'DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     PALCUPD       WHENEQ    'Y'
     C                   MOVEL     'U'           ScrnMode
     C                   MOVE      *Blank        WLendChg
     C                   MOVEL     'N'           WConvert
     C                   EXSR      SRConvAmt
     C     PNARSEL       WHENEQ    'Y'
     C                   MOVEL     'N'           ScrnMode
     C     PRWASEL       WHENEQ    'Y'                                                        CGL018
     C                   MOVEL     'Z'           ScrnMode                                     CGL018
     C                   OTHER
     C                   EXSR      SRCANCEL
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNARRATIVE - Narrative Details processing                   *
      *                                                               *
      *****************************************************************
     C     SRNARRATIVE   BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C     DDCREF        ANDEQ     *BLANKS
     C                   EXSR      SRGENREFNO
     C                   MOVE      PGENREF       CDCREF
     C                   MOVE      PGENREF       DDCREF
     C                   ENDIF
      *
      ** Call collateral narrative detail screen input module
     C                   CALL      'GLCOLNSIN'
      *
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      DDACTN        PACTION
     C                   PARM                    DDCREF
     C                   PARM                    DDGNSP
     C                   PARM      *BLANK        PNARUPD           1
     C                   PARM      *BLANK        PALCSEL           1
     C                   PARM      False         PINKC
      *
     C     RetCodeOut    IFNE      *BLANKS
      *
     C                   SELECT
     C     RetCodeOut    WHENEQ    'Y2U9999'
     C                   EXSR      SREND
     C     RetCodeOut    WHENEQ    'USR0790'
     C                   EXSR      SRCANCEL
     C                   OTHER
     C                   MOVEL     DDCREF        DBKEY
     C                   MOVEL     'GLCOLNSIN   'DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C     PNARUPD       WHENEQ    'Y'
     C                   MOVEL     'U'           ScrnMode
     C     PALCSEL       WHENEQ    'Y'
     C                   MOVEL     'G'           ScrnMode
     C                   OTHER
     C                   EXSR      SRCANCEL
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFIRST - First Detail Screen processing                     *
      *                                                               *
      *****************************************************************
     C     SRFIRST       BEGSR
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'Y'           PEINKJ
     C                   ENDIF
      *
     C                   MOVEL     '1'           ScrnMode
     C                   MOVEL     'N'           PEINKP
     C     DDGNSP        IFEQ      'G'
     C                   MOVEL     'Y'           PEINKP
     C                   ENDIF
     C                   MOVE      'Y'           PEINKQ
     C                   MOVE      'Y'           PEINKR                                       CGL018
     C                   MOVE      'N'           WriteOnly
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           PEINKP
     C                   MOVE      'N'           PEINKQ
     C                   MOVE      'N'           PEINKR                                       CGL018
     C                   ENDIF
      *
     C                   MOVEL     NwCoScn1st    PrCoScn1st
     C                   EXSR      SRDISPLAY
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F3 is pressed...
     C     PINKC         WHENEQ    True
     C                   EXSR      SREND
      *
      ** F12 is pressed...
     C     PINKL         WHENEQ    True
     C                   EXSR      SRCANCEL
      *
      ** F10 is pressed...
     C     PINKJ         WHENEQ    True
     C/COPY WNCPYSRC,GLCOLLSC03
     C                   MOVEL     'U'           ScrnMode
     C/COPY WNCPYSRC,GLCOLLSC04
      *
      ** Validation processing...
     C                   OTHER
     C                   EXSR      SRVALFIRST
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALFIRST - First Detail Screen Validation processing       *
      *                                                               *
      *****************************************************************
     C     SRVALFIRST    BEGSR
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'D'
     C     PENQ          ANDNE     'E'
     C     DDACTN        ANDNE     'X'
      *
      ** Call the first detail screen validation module
     C                   CALLB     'GLCOLL1VL'
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Old Collateral Record
     C                   PARM                    CrCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
      *
     C                   ENDIF
      *
     C     IndFirst      IFEQ      *ALL'Y'
     C     NwCoScn1st    ANDEQ     PrCoScn1st
      *
     C                   SELECT
      ** F15 is pressed...
     C     PINKP         WHENEQ    True
     C                   MOVEL     'G'           ScrnMode
     C                   MOVEL     '1'           ScrnPrev
      ** F16 is pressed...
     C     PINKQ         WHENEQ    True
     C                   MOVEL     'N'           ScrnMode
     C                   MOVEL     '1'           ScrnPrev
      ** F17 is pressed...                                                                    CGL018
     C     PINKR         WHENEQ    True                                                       CGL018
     C                   EVAL      ScrnMode = 'Z'                                             CGL018
     C                   EVAL      ScrnPrev = '1'                                             CGL018
      *
     C                   OTHER
     C                   MOVEL     '2'           ScrnMode
     C                   MOVEL     '1'           ScrnPrev
     C                   EXSR      SRRESETERR
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** If all fields are ok and screen has changed, redisplay screen.
     C     IndFirst      IFEQ      *ALL'Y'
     C     NwCoScn1st    ANDNE     PrCoScn1st
     C                   MOVEL     'Y'           ConfInd
     C                   ELSE
     C                   MOVEL     'N'           ConfInd
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSECOND - Second Detail Screen processing                   *
      *                                                               *
      *****************************************************************
     C     SRSECOND      BEGSR
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'Y'           PEINKJ
     C                   ENDIF
      *
     C                   MOVEL     '2'           ScrnMode
     C                   MOVEL     'N'           PEINKP
     C     DDGNSP        IFEQ      'G'
     C                   MOVEL     'Y'           PEINKP
     C                   ENDIF
     C                   MOVE      'Y'           PEINKQ
     C                   MOVE      'Y'           PEINKR                                       CGL018
     C                   MOVE      'N'           WriteOnly
      *
     C     DDACTN        IFEQ      'I'
     C     CDCOPT        ANDEQ     'C'
     C                   MOVE      'N'           PEINKP
     C                   MOVE      'N'           PEINKQ
     C                   MOVE      'N'           PEINKR                                       CGL018
     C                   ENDIF
      *
     C                   MOVEL     NwCoScn2nd    PrCoScn2nd
     C                   Z-ADD     WIDX          P_WIDX            3 0
     C                   EXSR      SRDISPLAY
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F3 is pressed...
     C     PINKC         WHENEQ    True
     C                   EXSR      SREND
      *
      ** F12 is pressed...
     C     PINKL         WHENEQ    True
     C                   EXSR      SRCANCEL
      *
      ** F10 is pressed...
     C     PINKJ         WHENEQ    True
     C                   MOVEL     'U'           ScrnMode
      *
      ** Validation processing...
     C                   OTHER
     C                   EXSR      SRVALSECOND
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSECOND - Second Detail Screen Validation processing     *
      *                                                               *
      *****************************************************************
     C     SRVALSECOND   BEGSR
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'D'
     C     PENQ          ANDNE     'E'
     C     DDACTN        ANDNE     'X'
      *
      ** Call the second detail screen validation module
     C                   CALLB     'GLCOLL2VL'
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
     C                   PARM                    CGL072                                       CGL072
      *
     C                   ENDIF
      *
     C     'N'           SCAN      IndSecond                              70
      *
     C     *IN70         IFEQ      *OFF
     C     WIDX          ANDEQ     P_WIDX
     C     NwCoScn2nd    ANDEQ     PrCoScn2nd
      *
     C                   SELECT
      ** F15 is pressed...
     C     PINKP         WHENEQ    True
     C                   MOVEL     'G'           ScrnMode
     C                   MOVEL     '2'           ScrnPrev
      ** F16 is pressed...
     C     PINKQ         WHENEQ    True
     C                   MOVEL     'N'           ScrnMode
     C                   MOVEL     '2'           ScrnPrev
      ** F17 is pressed...                                                                    CGL018
     C     PINKR         WHENEQ    True                                                       CGL018
     C                   EVAL      ScrnMode = 'Z'                                             CGL018
     C                   EVAL      ScrnPrev = '2'                                             CGL018
      ** Delete Mode and F10 not pressed...
     C     DDACTN        WHENEQ    'D'
     C     CDCOPT        ANDNE     'C'
      *
     C                   OTHER
     C     CDCOPT        IFEQ      'C'
     C                   MOVEL     '3'           ScrnMode
     C                   MOVEL     '2'           ScrnPrev
     C                   ELSE
     C                   MOVEL     'W'           ScrnMode
     C                   MOVEL     '2'           ScrnPrev
     C                   ENDIF
     C                   EXSR      SRRESETERR
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** If all fields are ok and screen has changed, redisplay screen.
     C     *IN70         IFEQ      *OFF
     C     WIDX          ANDEQ     P_WIDX
     C     NwCoScn2nd    ANDNE     PrCoScn2nd
     C                   MOVEL     'Y'           ConfInd
     C                   ELSE
     C                   MOVEL     'N'           ConfInd
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTHIRD - Third Detail Screen processing                     *
      *                                                               *
      *****************************************************************
     C     SRTHIRD       BEGSR
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'Y'           PEINKJ
     C                   ENDIF
      *
     C                   MOVEL     '3'           ScrnMode
     C                   MOVEL     'N'           PEINKP
     C     DDGNSP        IFEQ      'G'
     C                   MOVEL     'Y'           PEINKP
     C                   ENDIF
     C                   MOVE      'Y'           PEINKQ
     C                   MOVE      'Y'           PEINKR                                       CGL018
      *
     C                   MOVEL     NwCoScn3rd    PrCoScn3rd
     C                   EXSR      SRDISPLAY
     C                   EXSR      SRRESETERR
      *
     C                   SELECT
      *
      ** F3 is pressed...
     C     PINKC         WHENEQ    True
     C                   EXSR      SREND
      *
      ** F12 is pressed...
     C     PINKL         WHENEQ    True
     C                   EXSR      SRCANCEL
      *
      ** F10 is pressed...
     C     PINKJ         WHENEQ    True
     C                   MOVEL     'U'           ScrnMode
      *
      ** Validation processing...
     C                   OTHER
     C                   EXSR      SRVALTHIRD
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALTHIRD - Third Detail Screen Validation processing       *
      *                                                               *
      *****************************************************************
     C     SRVALTHIRD    BEGSR
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'D'
     C     PENQ          ANDNE     'E'
     C     DDACTN        ANDNE     'X'
      *
      ** Call the third detail screen validation module
     C                   CALLB     'GLCOLL3VL'
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat
      *
      ** Mode of Operation
     C                   PARM      'S'           RespMode
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM      *ALL'Y'       OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         Idx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *Zero         WIdx
      *
     C                   ENDIF
      *
     C     IndThird      IFEQ      *ALL'Y'
     C     NwCoScn3rd    ANDEQ     PrCoScn3rd
      *
     C                   SELECT
      ** F15 is pressed...
     C     PINKP         WHENEQ    True
     C                   MOVEL     'G'           ScrnMode
     C                   MOVEL     '3'           ScrnPrev
      ** F16 is pressed...
     C     PINKQ         WHENEQ    True
     C                   MOVEL     'N'           ScrnMode
     C                   MOVEL     '3'           ScrnPrev
      ** F17 is pressed...                                                                    CGL018
     C     PINKR         WHENEQ    True                                                       CGL018
     C                   EVAL      ScrnMode = 'Z'                                             CGL018
     C                   EVAL      ScrnPrev = '3'                                             CGL018
      ** Delete Mode and F10 not pressed...
     C     DDACTN        WHENEQ    'D'
      *
     C                   OTHER
     C                   MOVEL     'W'           ScrnMode
     C                   MOVEL     '3'           ScrnPrev
     C                   EXSR      SRRESETERR
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** If all fields are ok and screen has changed, redisplay screen.
     C     IndThird      IFEQ      *ALL'Y'
     C     NwCoScn3rd    ANDNE     PrCoScn3rd
     C                   MOVEL     'Y'           ConfInd
     C                   ELSE
     C                   MOVEL     'N'           ConfInd
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBROWSER - Browser Screen processing                        *
      *                                                               *
      *****************************************************************
     C     SRBROWSER     BEGSR
      *
     C                   MOVEL     'B'           ScrnStart
     C                   MOVEL     'I'           ScrnPrev
     C                   MOVEL     *BLANK        WRdNBrw
     C                   MOVE      *Blank        WLendChg
     C                   MOVEL     'N'           ConfInd
      *
      ** Call the browser module
     C                   CALLB     'GLCOLLBRW'
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Initial screen fields
     C                   PARM                    DDREVF
     C                   PARM                    DDREQR
     C                   PARM                    DDSENT
     C                   PARM                    DDSCMP
     C                   PARM                    DDSBRC
     C                   PARM                    DDSCOL
     C                   PARM                    DDSCNU
     C                   PARM                    DDSCCY
     C                   PARM                    DDSVAL
     C                   PARM                    DDSGNS
      *
      ** Enquiry Mode
     C                   PARM                    PENQ
      *
     C                   PARM                    CGL012
      *
      ** Build subfile
     C                   PARM      'Y'           PBDSFL            1
      *
      ** Read subfile record
     C                   PARM      'N'           PRDSFL            1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Function key taken
     C                   PARM      False         PINKC
     C                   PARM      False         PINKI             1
     C                   PARM      False         PINKL
      *
      ** Error message
      ** Display file action
      ** Collateral Reference selected
     C                   PARM      *BLANKS       PERRMS            7
     C                   PARM      *BLANK        POPSEL            1
     C                   PARM      *BLANKS       PCOSEL           10
      *
      ** F3 is taken
     C     PINKC         IFEQ      True
     C                   EXSR      SREND
     C                   ENDIF
      *
      ** F12 is taken
     C     PINKL         IFEQ      True
     C                   EXSR      SRCANCEL
     C                   ENDIF
      *
      ** F9 is taken
     C     PINKI         IFEQ      True
     C                   MOVEL     '1'           ScrnMode
     C                   MOVE      'B'           ScrnPrev
     C                   MOVEL     'I'           DDACTN
     C                   MOVEL     *BLanks       DDCREF
     C                   CLEAR                   NwCoScn1st
     C                   CLEAR                   NwCoScn2nd
     C                   CLEAR                   NwCoScn3rd
     C                   CLEAR                   NwCoFilFmt
     C                   ENDIF
      *
      ** If error message returned from browse, send it to initial screen
      *
     C     PERRMS        IFNE      *BLANKS
     C                   EXSR      SNDM@I
     C                   MOVE      'I'           SCRNMODE
     C                   ENDIF
      *
      ** If no function key is taken...
     C     PINKC         IFEQ      False
     C     PINKI         ANDEQ     False
     C     PINKL         ANDEQ     False
     C     PERRMS        ANDEQ     *BLANK
     C                   MOVEL     'R'           ScrnMode
     C                   MOVEL     'Y'           WRdNBrw
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSELBRW - Selected Browser Records processing               *
      *                                                               *
      *****************************************************************
     C     SRSELBRW      BEGSR
      *
      ** Call the browser module
     C                   CALLB     'GLCOLLBRW'
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Initial screen fields
     C                   PARM                    DDREVF
     C                   PARM                    DDREQR
     C                   PARM                    DDSENT
     C                   PARM                    DDSCMP
     C                   PARM                    DDSBRC
     C                   PARM                    DDSCOL
     C                   PARM                    DDSCNU
     C                   PARM                    DDSCCY
     C                   PARM                    DDSVAL
     C                   PARM                    DDSGNS
      *
      ** Enquiry Mode
     C                   PARM                    PENQ
      *
     C                   PARM                    CGL012
      *
      ** Build subfile
     C                   PARM      'N'           PBDSFL            1
      *
      ** Read subfile record
     C                   PARM      'Y'           PRDSFL            1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Function key taken
     C                   PARM      False         PINKC
     C                   PARM      False         PINKI
     C                   PARM      False         PINKL
      *
      ** Error message
      ** Display file action
      ** Collateral Reference selected
     C                   PARM      *BLANKS       PERRMS            7
     C                   PARM      *BLANK        POPSEL            1
     C                   PARM      *BLANKS       PCOSEL           10
      *
     C                   MOVEL     POPSEL        DDACTN
     C                   MOVEL     PCOSEL        DDCREF
      *
      ** If error message returned from browse, send it to initial screen
      *
     C     PERRMS        IFNE      *BLANKS
     C                   EXSR      SNDM@I
     C                   MOVE      'I'           SCRNMODE
     C                   GOTO      EndSelBrw
     C                   ENDIF
      *
     C     DDACTN        IFNE      *BLANK
      *
     C     DDACTN        IFEQ      'G'
     C                   MOVEL     'G'           ScrnMode
     C                   MOVE      'R'           ScrnPrev
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'N'
     C                   MOVEL     'N'           ScrnMode
     C                   MOVE      'R'           ScrnPrev
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'
     C                   MOVEL     '1'           ScrnMode
     C                   MOVE      'R'           ScrnPrev
     C                   ENDIF
      *
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C     DDACTN        IFEQ      'Z'                                                        CGL018
     C                   EVAL      ScrnMode = 'Z'                                             CGL018
     C                   EVAL      ScrnPrev = 'R'                                             CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
      *
     C                   EXSR      SRRETRIEVE
     C                   EXSR      SRCONVERT
     C                   MOVEL     CrCoFilFmt    NwCoFilFmt
      *
     C                   ELSE
     C                   MOVEL     'B'           ScrnMode
     C                   MOVEL     *Blank        WRdNBrw
     C                   ENDIF
      *
     C     EndSelBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDM@I - Send a message to initial screen                     *
      *                                                               *
      *****************************************************************
     C     SNDM@I        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     PERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   ENDIF
      *
      ** Invalid action code.
      *
     C     PERRMS        IFEQ      'COL0002'
     C     PERRMS        OREQ      'COL0003'
     C     PERRMS        OREQ      'COL0008'
     C     PERRMS        OREQ      'COL0009'
     C     PERRMS        OREQ      'COL0013'
     C                   MOVE      'N'           DDACTNOK
     C                   ENDIF
      *
      ** User not allowed to action code.
      *
     C     PERRMS        IFEQ      'COL0014'
     C                   MOVE      'N'           DDACTNOK
     C                   ENDIF
      *
      ** Invalid Review from.
      *
     C     PERRMS        IFEQ      'COL0015'
     C                   MOVE      'N'           DDREVFOK
     C                   ENDIF
      *
      ** Invalid Requiring Authorisation.
      *
     C     PERRMS        IFEQ      'COL0016'
     C                   MOVE      'N'           DDREQROK
     C                   ENDIF
      *
      ** Invalid Select Entity Level.
      *
     C     PERRMS        IFEQ      'COL0017'
     C                   MOVE      'N'           DDSENTOK
     C                   ENDIF
      *
      ** Invalid Select Company.
      *
     C     PERRMS        IFEQ      'COL0018'
     C     PERRMS        OREQ      'COL0019'
     C                   MOVE      'N'           DDSCMPOK
     C                   ENDIF
      *
      ** Invalid Select Branch.
      *
     C     PERRMS        IFEQ      'COL0020'
     C     PERRMS        OREQ      'COL0021'
     C                   MOVE      'N'           DDSBRCOK
     C                   ENDIF
      *
      ** Invalid Select Collateral Type.
      *
     C     PERRMS        IFEQ      'COL0022'
     C                   MOVE      'N'           DDSCOLOK
     C                   ENDIF
      *
      ** Invalid Select Collateral Customer.
      *
     C     PERRMS        IFEQ      'COL0023'
     C                   MOVE      'N'           DDSCNUOK
     C                   ENDIF
      *
      ** Invalid Select Collateral Currency.
      *
     C     PERRMS        IFEQ      'COL0024'
     C                   MOVE      'N'           DDSCCYOK
     C                   ENDIF
      *
      ** Invalid Select Collateral Value.
      *
     C     PERRMS        IFEQ      'COL0025'
     C                   MOVE      'N'           DDSVALOK
     C                   ENDIF
      *
      ** Invalid Select General/Specific Indicator.
      *
     C     PERRMS        IFEQ      'COL0026'
     C                   MOVE      'N'           DDSGNSOK
     C                   ENDIF
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATE - Update processing                                 *
      *                                                               *
      *****************************************************************
     C     SRUPDATE      BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'I'           CDTYLC
     C     DDCREF        IFEQ      *BLANKS
     C                   EXSR      SRGENREFNO
     C                   MOVEL     PGENREF       CDCREF
     C                   ENDIF
     C     CGL012        IFEQ      'Y'
     C                   MOVEL     'C'           CDAUTH
     C                   ELSE
     C                   MOVEL     'A'           CDAUTH
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'D'           CDTYLC
     C                   MOVEL     'A'           CDAUTH
     C                   MOVEL     'N'           PEINKJ
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'G'
     C     DDACTN        OREQ      'N'
     C                   MOVEL     'A'           CDTYLC
     C     CGL012        IFEQ      'Y'
     C     CDAUTH        IFEQ      'A'
     C                   MOVEL     'R'           CDAUTH
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'A'           CDAUTH
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'X'
     C     CGL012        ANDEQ     'Y'
     C                   MOVEL     'X'           CDTYLC
     C                   ENDIF
      *
      ** Call the update module
     C                   CALLB     'GLCOLLUPD'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    NwCoFilFmt
     C                   PARM                    CGL012
     C/COPY WNCPYSRC,GLCOLLSC01
      *
     C     RetCodeOut    IFNE      *Blanks
     C     RetCodeOut    ANDNE     '*RECUPD'
     C                   MOVEL     '*RECUPD     'DBKEY
     C                   MOVEL     'GLCOLLUPD   'DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     RetCodeOut    IFNE      '*RECUPD'
     C                   COMMIT
     C                   MOVEL     PGENREF       WSCREF
     C                   ELSE
     C                   Z-ADD     1             IDX
     C                   MOVEL     '*ANY        'FldNameArr(1)
     C                   MOVEL     'COL0001'     MsgIDArr(1)
     C                   MOVEL     *BLANKS       MsgDtaArr(1)
     C                   MOVEL     'COL0001'     PERRMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   NwCoFilFmt
     C                   CLEAR                   NwCoScn1st
     C                   CLEAR                   NwCoScn2nd
     C                   CLEAR                   NwCoScn3rd
     C                   MOVEL     'I'           ScrnMode
     C     RetCodeOut    IFEQ      *Blanks
     C                   MOVEL     *BLank        DDACTN
     C                   MOVEL     *BLanks       DDCREF
     C                   MOVEL     *Blanks       PALCUPD
     C                   MOVEL     ScrnStart     ScrnMode
     C     WRdNBrw       IFEQ      'Y'
     C                   MOVEL     'R'           ScrnMode
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGENREFNO - Generate Reference Number processing            *
      *                                                               *
      *****************************************************************
     C     SRGENREFNO    BEGSR
      *
      ** Call the generate reference module
     C                   CALLB     'GLCOLLGEN'
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Module
     C                   PARM      'GL'          PMODULE           2
      *
      ** Transaction Type
     C                   PARM      'C'           PTTYPE            1
      *
      ** Front Office Id
     C                   PARM      *BLANKS       FOTRID
      *
      ** OUTPUT PARAMETER:
      *
      ** Generated Reference
     C                   PARM      *BLANKS       PGENREF          10
      *
     C     RetCodeOut    IFNE      *BLANKS
     C                   ROLBK
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'GLCOLLGEN   'DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWINDOW - Window processing                                 *
      *                                                               *
      *****************************************************************
     C     SRWINDOW      BEGSR
      *
      ** If Window Processing...
     C     BGWDPR        IFEQ      'Y'
      *
      ** Setup parameters
     C                   MOVEL     *Blanks       TransStat
     C                   MOVEL     *ALL'Y'       OkCoScnFld
     C                   MOVEL     *BLANKS       FldNameArr
     C                   MOVEL     *BLANKS       MsgIDArr
     C                   MOVEL     *BLANKS       MsgDtaArr
     C                   MOVEL     *BLANKS       WFldNamArr
     C                   MOVEL     *BLANKS       WMsgIDArr
     C                   MOVEL     *BLANKS       WMsgDtaArr
     C                   MOVEL     'N'           PEINKJ
     C                   MOVEL     'N'           PEINKP
     C                   MOVEL     'N'           PEINKQ
     C                   MOVEL     'N'           PEINKR                                       CGL018
     C                   MOVEL     'Y'           WriteOnly
      *
     C                   MOVEL     ScrnPrev      ScrnMode
     C                   EXSR      SRDISPLAY
     C                   MOVEL     'N'           WriteOnly
      *
     C     DDACTN        IFEQ      'I'
     C     DDCREF        ANDEQ     *Blanks
     C                   EXSR      SRGENREFNO
     C                   MOVEL     PGENREF       CDCREF
     C                   MOVEL     PGENREF       DDCREF
     C                   ENDIF
     C/COPY WNCPYSRC,GLCOLLSC02
      *
     C                   CALL      'WN0010'
     C                   PARM      'GLCOLLSIN'   WWPgm            10
     C                   PARM      *BLanks       WWFKey            2
     C                   PARM      DDACTN        WWACTN            1
     C                   PARM                    DATA
     C                   PARM      *Blanks       WWRTCD            7
     C                   PARM                    WWSPARE         256
      *
     C                   ELSE
      *
     C                   MOVEL     *Blanks       WWRTCD
     C                   ENDIF
      *
     C     WWRTCD        IFEQ      'Y2U9999'
     C                   EXSR      SREND
     C                   ELSE
      *
     C     WWRTCD        IFEQ      'USR0790'
      *
     C     WRdNBrw       IFEQ      'Y'
     C                   MOVEL     'R'           ScrnMode
     C                   ELSE
     C                   EXSR      SRCANCEL
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDACTN        IFEQ      'E'
     C     WRdNBrw       IFEQ      'Y'
     C                   MOVEL     'R'           ScrnMode
     C                   ELSE
     C                   CLEAR                   NwCoScn1st
     C                   CLEAR                   NwCoScn2nd
     C                   CLEAR                   NwCoScn3rd
     C                   MOVEL     *Blank        DDACTN
     C                   MOVEL     *Blanks       DDCREF
     C                   MOVEL     ScrnStart     ScrnMode
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'U'           ScrnMode
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvAmt - Amount conversion of Collateral Statistics       *
      *                                                               *
      *****************************************************************
     C     SRConvAmt     BEGSR
      *
      ** Get currency number of decimal places
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     DDCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing ICD
      *
     C**********         CallB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*FIRST '     POPTN
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   Z-ADD     009           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert amount to numeric
      *
     C                   IF        WConvert = 'N'
      *
      ** Set up parameter for ZA0840
      *
     C                   Z-ADD     A6NBDP        @@IDP             3 0
     C     15            SUB       @@IDP         @@IINT            3 0
     C                   MOVE      *Blanks       @@ALPH           16
     C                   MOVE      'N'           @@MTID            1
      *
      ** Convert Total allocated amount field from char to numeric
      *
     C                   MOVEL     PTotAllo      @@ALPH
      *
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD            1 0
     C                   PARM                    @@AMT            15 0
     C                   PARM                    BNDCSP
      *
      ** No error found on conversion
      *
     C     RETCODEOUT    IFEQ      *BLANKS
     C                   Z-ADD     @@AMT         CDTOTA
     C                   ELSE
     C                   MOVEL     PTotAllo      DBKEY
     C                   MOVEL     'ZA0840  '    DBFILE
     C                   Z-ADD     010           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert Allocation percentage field from char to numeric
      *
     C                   MOVE      *Blanks       @@ALPH
     C                   MOVEL     PPctAllo      @@ALPH
     C                   Z-ADD     7             @@IDP
     C     15            SUB       @@IDP         @@IINT
 
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD            1 0
     C                   PARM                    @@AMT            15 0
     C                   PARM                    BNDCSP
      *
      ** No error found on conversion
      *
     C     RETCODEOUT    IFEQ      *BLANKS
     C     @@AMT         DIV       10000000      CDPCTA
     C                   ELSE
     C                   MOVEL     PPctAllo      DBKEY
     C                   MOVEL     'ZA0840  '    DBFILE
     C                   Z-ADD     011           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Convert from numeric to char
      *
     C                   IF        WConvert = 'C'
      *
      ** Set up parameter for ZA0921
      *
     C                   Z-ADD     A6NBDP        W@CDP             1 0
      *
      ** Total Allocated
      *
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    CDTOTA
     C                   PARM                    W@CDP
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTP           16
     C                   PARM                    @@AMTD           17
 
     C                   MOVE      @@AMTP        PTotAllo
      *
      ** Old Lending Value
      *
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    P_CDLAMT
     C                   PARM                    W@CDP
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTP
     C                   PARM                    @@AMTD
 
     C                   MOVE      @@AMTP        POLenVal
 
      ** Percentage Allocation
 
     C     CDPCTA        MULT      10000000      @@PCT5           15 0
     C                   Z-ADD     7             W@CDP
 
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@PCT5
     C                   PARM                    W@CDP
     C                   PARM                    BNDCSP
     C                   PARM                    @@AMTP
     C                   PARM                    @@AMTD
 
     C                   MOVE      @@AMTP        PPctAllo
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CGL018
      *****************************************************************                       CGL018
      *                                                               *                       CGL018
      *  SRRWASSET - Risk Weighted Assets                             *                       CGL018
      *                                                               *                       CGL018
      *****************************************************************                       CGL018
     C     SRRWASSET     BEGSR                                                                CGL018
                                                                                              CGL018
     C     DDACTN        IFEQ      'I'                                                        CGL018
     C     DDCREF        ANDEQ     *BLANKS                                                    CGL018
     C                   EXSR      SRGENREFNO                                                 CGL018
     C                   MOVE      PGENREF       CDCREF                                       CGL018
     C                   MOVE      PGENREF       DDCREF                                       CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
      ** Collateral Risk Weighted Asset Codes                                                 CGL018
      *                                                                                       CGL018
     C                   CALL      'GLC001241'                                                CGL018
     C                   PARM      *BLANK        RTCD              7                          CGL018
     C                   PARM                    DDACTN                                       CGL018
     C                   PARM                    DDCREF                                       CGL018
     C                   PARM                    DDDESC                                       CGL018
     C                   PARM      *blank        RWAUpd            1                          CGL018
      *                                                                                       CGL018
     C     RTCD          IFNE      *BLANKS                                                    CGL018
                                                                                              CGL018
     C                   IF        RTCD = 'Y2U9999'                                           CGL018
     C                   EXSR      SREND                                                      CGL018
     C                   ELSE                                                                 CGL018
                                                                                              CGL018
     C                   MOVEL     DDCREF        DBKEY                                        CGL018
     C                   MOVEL     'GLC001241'   DBFILE                                       CGL018
     C                   Z-ADD     13            DBASE                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   ENDIF                                                                CGL018
     C                   ELSE                                                                 CGL018
                                                                                              CGL018
     C                   IF        RWAUpd = 'Y'                                               CGL018
     C                   EVAL      ScrnMode = 'U'                                             CGL018
     C                   EVAL      PEINKR = 'N'                                               CGL018
     C                   ELSE                                                                 CGL018
      *                                                                                       CGL018
     C                   EXSR      SRCANCEL                                                   CGL018
     C                   ENDIF                                                                CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
     C                   ENDSR                                                                CGL018
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERR - Reset errors fields                             *
      *                                                               *
      *****************************************************************
     C     SRRESETERR    BEGSR
      *
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   MOVEL     *ALL'Y'       OKCoScnFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameter
     C     *ENTRY        PLIST
     C                   PARM                    PENQ              1
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLSIN  ' DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL012
      ** (Collateral Authorisations) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL012'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL012'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     'N'           CGL012
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL012            1
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL018
     C                   Z-ADD     12            DBASE                                        CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      ** Access SAR details file to determine if CGL072 is on.                                CGL072
      *                                                                                       CGL072
     C                   CALLB     'AOSARDR0'                                                 CGL072
     C                   PARM      *BLANKS       @RTCD                                        CGL072
     C                   PARM      '*VERIFY'     @OPTN                                        CGL072
     C                   PARM      'CGL072'      @SARD                                        CGL072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL072
      *                                                                                       CGL072
     C     @RTCD         IFEQ      *BLANK                                                     CGL072
     C                   MOVE      'Y'           CGL072            1                          CGL072
     C                   ELSE                                                                 CGL072
     C                   MOVE      'N'           CGL072                                       CGL072
     C                   END                                                                  CGL072
      *
      ** Set read next browse record
     C                   MOVEL     *BLANK        WRdNBrw           1
      *
      ** Blank out screen fields.
     C                   CLEAR                   NwCoScnFmt
      *
      ** Start on initial screen.
      *
     C                   CLEAR                   NwCoFilFmt
     C                   MOVEL     *BLANKS       TransStat         7
     C                   MOVEL     'I'           ScrnMode          1
     C                   MOVEL     'N'           PEINKJ            1
     C                   MOVEL     'N'           PEINKP            1
     C                   MOVEL     'N'           PEINKQ            1
     C                   MOVEL     'N'           PEINKR            1                          CGL018
     C                   MOVEL     'N'           WriteOnly         1
     C                   MOVEL     *Blank        PAlcUpd
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLCOLLS015
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
