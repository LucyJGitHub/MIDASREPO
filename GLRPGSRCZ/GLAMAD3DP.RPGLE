     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL A/c maintenance display - 3rd detl scrn')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD3DP -  Account Maintenance Display - Third Detail Scrn *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03Aug06               *
      *                 222549             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 12Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165  - Dual Withholding Tax (Recompile)                   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD027A- Conversion Of Customer Number to Alpha (additional) *
      *  222549 - API version of Accounts master enquiry should be    *
      *           used in the linked enquiry from the Customer Account*
      *           Balances Enquiry. Introduced linked enquiry         *
      *           processing in the API version of GL accounts        *
      *           maintenance.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FGLAMADDDF CF   E             WORKSTN IGNORE(GLAMADD1:GLAMADD2:
     F                                            GLAMADD4:GLAMADD5)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      *                                                               *
      *  ID F  C  H  L    FUNCTION OF INDICATORS                      *
      *                                                               *
      *  06 - Control Ind. for display of CMD6                        *
      *  18 - Transaction Charges                                     *
      *  29 - Retail Number is used                                   *
      *  41 - Authorise to Amend                                      *
      *  48 - Retail A/c No. Required                                 *
      *  32 - Enquiry Mode                                            *
      *  50-66 -  Field Error - highlight screen fields               *
      *  96 - Subfile control                                         *
      *  97 - Subfile end                                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------

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
     DEMSDS          E DS                  EXTNAME(EMDTA) DTAARA(EMSDS)                       222549
     D CUSTNO                141    146                                                       222549
     D*CUSTN****             141    146  0                                            222549 CSD027A
     D CUSTN                 141    146                                                      CSD027A
     D CURRCY                147    149                                                       222549
     D ACCODE                150    159                                                       222549
     D ACCDN                 150    159  0                                                    222549
     D ACCSEQ                160    161                                                       222549
     D ACSQN                 160    161  0                                                    222549
     D BRANCH                162    164                                                       222549
     D AREF15                141    161                                                       222549

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @Z0             S              1    DIM(17) CTDATA PERRCD(17)

     D @EI             S              1    DIM(17)

     D ZMUSER          DS            17
      ** ZMUSER data layout
     D  DBRN                  11     13

     D RUNDAT          DS            13
      ** Rundate data area
     D  AGMBIN                13     13

     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
     D NewAcCrdt     E DS                  EXTNAME(GLAMCIPD)
     D OKAcCrdt      E DS                  EXTNAME(GLEAMCIPD)
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for Retail Details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure

     D/COPY WNCPYSRC,GLAMA3XD01
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
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C     @INKC         IFEQ      '1'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Set screen indicators
     C                   EXSR      SRSETI
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OKAcCrdt      @EI
      *
      ** Set screen error inds according to status of 'OK' Flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     17
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
      *
      ** Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLAMADC1
     C                   WRITE     GLAMADD3
     C                   WRITE     GLAMADF2
      *
      ** Read details screen, if not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      GLAMADD3                               99
     C                   ENDIF
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKF         @INKF
     C                   MOVE      *INKI         @INKI
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *IN49         @IN49
      *
     C                   ENDSR

      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSETI - SET SCREEN INDICATORS
      *****************************************************************
     C     SRSETI        BEGSR
      *
     C                   MOVE      *OFF          *IN32
     C     DDACTN        IFEQ      'E'
     C                   MOVE      *ON           *IN32
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN29
     C     AMATYP        IFEQ      'R'
     C                   MOVE      *ON           *IN29
     C                   ENDIF
      *
      ** Retail Number Used
     C                   MOVE      *OFF          *IN48
     C     BMRANR        IFEQ      'Y'
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
      ** Prepare Amend Authorisation
     C                   MOVE      'A'           @ZACTN
     C                   MOVE      DBRN          @BRCA
     C                   MOVE      *OFF          *IN41
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRAUTH
     C     @ERR          IFEQ      0
     C                   MOVE      *ON           *IN41
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN41
     C                   ENDIF
      *                                                                                       222549
      ** Check if this is a linked enquiry                                                    222549
      *                                                                                       222549
     C     *LOCK         IN        EMSDS                                                      222549
     C                   MOVE      RQDTD         MODID             2                          222549
     C                   OUT       EMSDS                                                      222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   MOVEL     '1'           *IN36                                        222549
     C                   ENDIF                                                                222549
      *
      ** If enquiry mode and user authorised to amend and if account
      ** flagged for closure, seton indicator to forbid amend.
     C                   MOVE      *ON           *IN06
     C     *IN32         IFEQ      *ON
     C     *IN41         ANDEQ     *ON
     C     AMACST        IFEQ      'C'
     C     *IN36         OREQ      '1'                                                        222549
     C                   MOVE      *OFF          *IN06
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN18
     C     TCAL          IFEQ      'Y'
     C                   MOVE      *ON           *IN18
     C                   ENDIF
      *
      ** Enable/Disable Roll Function Keys
     C                   MOVE      *OFF          *IN25
     C     @EIN25        IFEQ      'Y'
     C     *IN36         ANDEQ     '0'                                                        222549
     C                   MOVE      *ON           *IN25
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMA3XC02
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAUTH - CHECK ACTION CODE AND BRANCH AUTHORITY
      *****************************************************************
     C     SRAUTH        BEGSR
      *
      ** Multi-branch system, user must be authorised to action on
      ** branch.
      *
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @BRCA             3
     C                   PARM                    @ERR              1 0
      *
     C                   ELSE
      *
      ** Single branch system, check user is authorised to action code
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      ** Account (IN SCREEN FORMAT - First & Third)
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcCrdt
      *
      * Fields in error
     C                   PARM                    OKAcCrdt
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only field
     C                   PARM                    DOCRCD
      *
      ** ICD
     C                   PARM                    TCAL              1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25            1
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKF             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKL             1
     C                   PARM                    @IN49             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ** GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ** GET RUNDAT to access multi-branching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD3DP'   DBPGM
     C                   OUT       LDA
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWSID
      *
      ** Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      *
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for GL *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY GLCPYSRC,MSGHNDDATA
     C/COPY WNCPYSRC,GLAMA3XC01
      **---------------------------------------------------------------
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
00000000000000000000
