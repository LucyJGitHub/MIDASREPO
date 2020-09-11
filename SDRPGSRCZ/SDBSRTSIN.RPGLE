     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base Rate Details Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTSIN - SD Base Rate Input                               *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Base Rates                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      *                 213558             Date 22Jan03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 03Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  213558 - MDF Rate Maintenance Time/Date Stamp amendable      *
      *  CSD012 - Standing Data Authorisation                         *
      *  CSD006 - Market Data Feed                                    *
      *                                                               *
      *****************************************************************
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D CrBsFilFmt    E DS                  EXTNAME(SDBSRTPD)
      ** Current Deal in File Format
 
     D CrBsScnFmt    E DS                  EXTNAME(SDBSRSPD)
      * (Current) Deal in Screen Format
     D                                     PREFIX(@)
 
     D NwBsFilFmt    E DS                  EXTNAME(SDVBSRTPD)
     D                                     PREFIX(V)
      ** New Deal in File Format
 
     D NwBsScnFmt    E DS                  EXTNAME(SDBSRSPD)
      ** New Deal in Screen Format
 
     D ExtData       E DS                  EXTNAME(SDBSEXPD)
      ** FX Extra Data - File (D/B) format
 
     D SDEBSRT       E DS                  EXTNAME(SDEBSRTPD)
      ** Error indicators
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules details accessed via access program
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Externally described DS for switchable feature details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
     D @CCI@M          DS
      ** Current Control Indicators for Main Detail Screen
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKN                 6      6
     D  @EINKP                 7      7
 
     D @PCI@M          DS             7
 
      * Re-display Main details screen, in case of amends or inserts
     D REDSPLY         S              1A   INZ('Y')
      ** Previous Control Indicators for main detail screen
                                                                                              CSD012
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  wComitjobs             4    103                                                       CSC022
      ** External DS for Commitment Control Data Area                                         CSC022
                                                                                              CSC022
     D wComitarr       S             10A   DIM(10)                                            CSC022
      ** Commitment Control Array                                                             CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Switchable features
     D CSD006          S              1A                                                      CSD006
     D CSW005          S              1A
     D CSW011          S              1A
     D CSW200          S              1A
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqBaseRateMaint')                      CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Commitment Control Variables                                                         CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D wSkip           S              1A   INZ('N')                                           CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDBSRTS008
 
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
      /COPY WNCPYSRC,SDBSRTS001
 
      * READ NEXT BROWSE SUBFILE RECORD
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTS002
 
      * DO WHILE SCREEN: MAIN DETAILS
      *
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
      *
      /COPY WNCPYSRC,SDBSRTS003
 
      * SCREEN: CONFIRMATION OF INPUT
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTS006
 
      * DO FILE UPDATES
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SDBSRTS007
 
      * TERMINATE PROGRAM
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDBSRTS009
 
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
     C     SCRN@M        BEGSR
      *
      *
      * Update 'previous' key fields & screen control indicator
      *
     C                   MOVEL(P)  DDACTN        @PACTN            1
     C                   MOVEL(P)  DDCYCD        @PCYCD            3
     C                   MOVEL(P)  DDBSRC        @PBSRC            2
     C                   MOVEL(P)  @CCI@M        @PCI@M
 
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDBSRTDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwBsScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    SDEBSRT
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
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM                    @HDTFD            1
     C                   PARM                    CLRSCRN
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       SDEBSRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      *
      * If Enter is taken from main screen and key fields are blank, show the browse
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           SRENDP
      *
      * CK/7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           SRROLL
      *
      * CK/8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           SRROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           SRCANC
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     SRVALM
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALM - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SRVALM        BEGSR
      *
      * Retrieve deal details
      *
     C                   EXSR      SRRTV
      *
      * If any of key fields are not OK
      * Re-output screen with error messages on it
      *
     C                   IF        DDACTNOK  = 'N' OR
     C                             DDCYCDOK  = 'N' OR
     C                             DDBSRCOK  = 'N'
     C                   GOTO      EVAL@M
     C                   END
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete, or enquire or action is
      * amdned and key fields have changed
      * Put the deal on the main details screen
      *
     C                   IF          DDACTN    =     'D'  OR
     C                               DDACTN    =     'E'  OR
     C                               DDACTN    =     'A'  AND
     C                               DDACTN    <>    @PACTN  OR
     C                               DDACTN    =     'A'  AND
     C                               DDCYCD    <>    @PCYCD  OR
     C                               DDACTN    =     'A'  AND
     C                               DDBSRC    <>    @PBSRC
     C                   EXSR      SRCVT
     C                   ENDIF
      *
     C                   IF          DDCYCD    <>    @PCYCD  AND
     C                               DDACTN    <>    'I'     OR
     C                               DDBSRC    <>    @PBSRC  OR
     C                               DDACTN    <>    @PACTN  OR
     C                               @CCI@M    <>    @PCI@M
     C                   EVAL      REDSPLY = 'Y'
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrBsFilFmt    NwBsFilFmt
      *
      * IF CK/10 TAKEN, GO ONTO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Update Deal in File Format
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrBsFilFmt    NwBsFilFmt
      *
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Deal in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       SDEBSRT
     C                   CLEAR                   NwBsFilFmt
      * IF AMEND
 
      * Update Deal in File Format
      *
      *
      * Update Deal in File Format
      *
     C                   MOVEL     CrBsFilFmt    NwBsFilFmt
 
     C                   IF        REDSPLY = 'Y'
     C                   EVAL      REDSPLY = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *
      * Validate security details
      *
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDTFR= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'SDBSRTVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwBsScnFmt
     C                   PARM                    ExtData
     C                   PARM                    SDEBSRT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwBsFilFmt
     C                   PARM                    CSD006                                       CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103

      * If errors returned
 
     C                   IF        IDX = 0 AND WIDX = 0
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   ENDIF
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      * SRROLL - ROLL BACKWARDS & FORWARDS THROUGH DEALS FILE
      *****************************************************************
     C     SRROLL        BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
      * READ NEXT OR PREVIOUS RECORD ON DEALS FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
      *
     C                   CALLB     'SDBSRTRED'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCYCD
     C                   PARM                    DDBSRC
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    @ERRMS            7
     C                   PARM                    @CYCD             3
     C                   PARM                    @BSRC             2
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * If deal read
      *
     C     @CYCD         IFNE      *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @CYCD         DDCYCD
     C                   MOVEL     @BSRC         DDBSRC
     C                   EXSR      SRRTV
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      SRCVT
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SDBSRTBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCYCD
     C                   PARM                    DDBSRC
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        @CYCD
     C                   PARM      *BLANK        @BSRC
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKI
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      SRENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SDBSRTBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDCYCD
     C                   PARM                    DDBSRC
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @CYCD             3
     C                   PARM      *BLANK        @BSRC             2
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKI             1
 
      *
      * IF DEAL READ FROM SUBFILE
      *
     C                   IF         @BSRC <>   *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @BSRC         DDBSRC
     C                   MOVEL     @CYCD         DDCYCD
     C                   MOVEL     'N'           REDSPLY
 
     C                   EXSR      SRRTV
      *                                                                                       CSD012
      * Stay on browse screen if there is an error on customer nu r nu                        CSD012
      *                                                                                       CSD012
     C     DDACTNOK      IFEQ      'N'                                                        CSD012
     C     DDBSRCOK      OREQ      'N'                                                        CSD012
     C                   MOVEL     'R'           @SCRN                                        CSD012
     C                   GOTO      EndRDNBRW                                                  CSD012
     C                   ENDIF                                                                CSD012
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the deal on the main details screen
      *
     C                   EXSR      SRCVT
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   ENDIF
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
     C***********        ENDSR                                                                CSD012
     C     EndRdnBRW     ENDSR                                                                CSD012
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTV  - RETRIEVE SECURITY
      *****************************************************************
     C     SRRTV         BEGSR
      *
      * RETRIEVE SECURITY
      *
     C                   CALLB     'SDBSRTRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Currency Code
     C                   PARM                    DDCYCD
      *
      * Base Rate Currency
     C                   PARM                    DDBSRC
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    CrBsFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      * OK - Security
     C                   PARM      *BLANK        DDCYCDOK
      *
      * OK - Customer Shortname
     C                   PARM      *BLANK        DDBSRCOK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      * ICD
     C                   PARM                    BGN4ST
      *
      * Base Rate Shortname
     C                   PARM                    DDBSRS
      *
      * Base Rate Name
     C                   PARM                    DDBSRN
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCVT  - PUT A DEAL ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     SRCVT         BEGSR
      *
      * Call program to fill screen fields with data from FXDEALPP
      *
     C                   CALLB     'SDBSRTCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    CrBsFilFmt
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    NwBsScnFmt
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103
      *
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NwBsScnFmt    CrBsScnFmt
 
     C                   ENDSR
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & deal number; detail fields = rest)
      * (Action code can only be 'I', 'A', 'E', 'D', or 'X')
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   MOVEL     'N'           @HDTFD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * (Action codes I, A, X display settlement details automatically)
      * (No futher screens are available from action code D)
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVEL     'Y'           @EINKN
     C                   ELSE
     C                   MOVEL     'N'           @EINKN
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
      *
     C                   MOVEL     'Y'           @HDTFD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KN = COMMAND KEY 14 = SETTLEMENT DETAILS
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKN
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCANC - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     SRCANC        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C                   MOVEL     *BLANK        NwBsScnFmt
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   ENDIF
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       SDEBSRT
      *
      * Validate deal details
      *
     C                   IF        DDACTN = 'A'                                               213558
      * blank out timestamp and request id when amending via screen                           213558
      * therefore won't show on tolerance report                                              213558
     C                   EVAL      DDDTFR= *BLANKS                                            213558
     C                   EVAL      DDDFTS= *BLANKS                                            213558
     C                   ENDIF                                                                213558
     C                   CALLB     'SDBSRTVAL'
     C                   PARM                    RespMode
     C                   PARM                    NwBsScnFmt
     C                   PARM                    ExtData
     C                   PARM                    SDEBSRT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwBsFilFmt
     C                   PARM                    CSD006                                       CSD006
     C                   PARM                    CSW005
     C                   PARM                    CSW011
     C                   PARM                    CSW200
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'SDBSRTDSP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwBsScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    SDEBSRT
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
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM                    @HDTFD
     C                   PARM                    CLRSCRN
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    DDBLRT            1                          CSD103
     C                   PARM                    DDLBDY            2                          CSD103
     C                   PARM                    DDLODY            2                          CSD103
     C                   PARM                    DDPDLY            2                          CSD103
     C                   PARM                    DDBADJ           14                          CSD103
     C                   PARM                    DDAVOP            1                          CSD103
     C                   PARM                    DDBRAC            2                          CSD103
     C                   PARM                    DDWGHT            1                          CSD103
     C                   PARM                    DDLBAC            2                          CSD103
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       SDEBSRT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           SRENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
 
     C                   EVAL      VBVTYLC = DDACTN
 
     C                   CALLB     'SDBSRTUPD'
     C                   PARM      *BLANKS       RETURNCODE
     C                   PARM                    NwBsFilFmt
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C                   IF        RETURNCODE <> *BLANK
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   else                                                                 CSC022
     C                   If        wSkip <> 'Y'                                               CSC022
     C                   Rolbk                                                                CSC022
     C                   else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   IF        RETURNCODE =  '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   If        CSC022 = 'N' or                                            CSC022
     C                             (wSkip = 'N' and CSC022 = 'Y')                             CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C                   IF        RETURNCODE =   '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   MOVEL     'N'           CLRSCRN
     C                   ENDIF
     C
      *
     C** If update not done due to error in Background Update of TABLETK file
      ** Send message 'Unable to update' to screen.
     C
     C                   IF        RETURNCODE =   '*ERTBTK'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR0015'     MsgIdArr(1)
     C                   MOVEL     'N'           CLRSCRN
     C                   ENDIF
     C
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NwBsScnFmt
     C                   MOVEL     'Y'           CLRSCRN           1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRENDP - END PROGRAM
      *****************************************************************
     C     SRENDP        BEGSR
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      * Parameters
     C     *ENTRY        PLIST
      * INPUTS
      *
      * Dummy, to re-use the menu control pgm for SD, SDC0001
      *
     C                   PARM                    DUMMY1            6
      *
      * Dummy, to re-use the menu control pgm for SD, SDC0001
      *
     C                   PARM                    DUMMY2            1
                                                                                              CSD012
     C* Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDBSRTSIN'   DBPGM
      *
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
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
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if
      ** FRA/IRS  MT34*/ MT36* Message generation is installed
      *
     C                   MOVEL     'N'           CSW005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW005
     C                   ENDIF
 
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006                                       CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW011'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW011
     C                   ELSE
     C                   MOVE      'N'           CSW011
     C                   ENDIF
 
      ** Check if CSD012 is installed                                                         CSD012
     C                   CALL      'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANKS                                                    CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Base Rate Authorisation is ON                              CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     1             DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'SDBSRTSIN'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Base Rate Authorisation is On set to Authorise                                    CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 is on.                                CSC022
      *                                                                                       CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Database Error                                                                       CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> *BLANKS and                                       CSC022
     C                             @RTCD <> '*NRF   '                                         CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBASE = 903                                                CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   ExSr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *BLANK                                             CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   In        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        Comitnum > 0                                               CSC022
     C                   MoveA     wComitjobs    wComitarr                                    CSC022
     C     psJobname     Lookup    wComitarr                              10                  CSC022
     C                   If        *IN10                                                      CSC022
     C                   Eval      wSkip = 'Y'                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
     C                   CALL      'SWIF2000'
     C                   PARM      *BLANKS       @RTCD
      *
     C     @RTCD         IFEQ      'CSW200'
     C                   MOVE      'Y'           CSW200
     C                   ELSE
     C                   MOVE      'N'           CSW200
     C                   ENDIF
 
     C                   EVAL      ISDAFlag = '1'
     C                   IF        CSW005  =  'Y'  OR
     C                             CSW011  =  'Y'  AND
     C                             CSW200  =  'Y'
     C                   EVAL      ISDAFlag = '0'
     C                   ENDIF
      *
      * Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDBSRTS010
 
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
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
