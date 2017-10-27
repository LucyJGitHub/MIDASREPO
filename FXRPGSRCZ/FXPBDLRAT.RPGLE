     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal range authorise by front office ID')     *
      *****************************************************************
      *                                                               *
      *  Midas - Foriegn Exchange Dealing Module                      *
      *                                                               *
      *  FXPBDLRAT - FX DEAL RANGE AUTHORIZATION                      *
      *              By Front Office ID.                              *
      *                                                               *
      *  Function:  This input function allows range authorization    *
      *             of all FX deals by Front Office Id.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CFX114             Date 15Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052  *CREATE    Date 22Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXPBDLGC02                       *
      *           Core hooks added:FXPBDLGD01                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP052 - Deal Range Authorisation (By Front Office ID.)      *
      *                                                               *
      *****************************************************************
 
     FFXPBDLRDF CF   E             WORKSTN INFSR(*PSSR)
 
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
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** data structure for data to output 'authorized' message
     D @ADAT           DS            46
     D  @ADAT1                 1      6
     D  @ADAT2                 7     26
     D  @ADAT3                27     45
 
      ** data structure for data to output 'failed' message
     D @FDTA           DS            45
     D  @FDT1                  1      6
     D  @FDT2                  7     26
     D  @FDT3                 27     45
 
 
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)
 
      ** Array of fields in with warning                                                      CAS004
     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
                                                                                              CAS004
      ** Array of warning error message IDs                                                   CAS004
     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
                                                                                              CAS004
      ** Array of warning error message data                                                  CAS004
     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004
 
     D DEALFilFmt    E DS                  EXTNAME(FXDEALPP)
 
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
     D WIdx            S              3P 0                                                    CAS004
     D/COPY WNCPYSRC,FXPBDLGD01
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CAS004
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
 
      ** If authorizations are not required
 
     C     BNFXAU        IFEQ      'N'
     C                   EXSR      NOINPUT
     C                   ENDIF
 
      **  Main processing
      **  Loop until CK/3 taken
 
     C     *INKC         DOWEQ     False
     C                   EXSR      MAIN
     C                   ENDDO
      *
      * TERMINATE PROGRAM
      *
     C                   MOVE      True          *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     FXPBDLS0
     C                   WRITE     FXPBDLD1
     C                   WRITE     FXPBDLF1
     C                   READ      FXPBDLD1                               99
 
      ** If CK/3 taken, bypass
 
     C     *INKC         CABEQ     True          EMAIN
 
      ** Validate screen input
 
     C                   EXSR      VALSIN
 
      ** If validation not OK, bypass
 
     C     *IN50         CABEQ     True          EMAIN
 
      ** Initialize count of authorizattions and failed authorizations
 
     C                   Z-ADD     0             @CNTAU            6 0
     C                   Z-ADD     0             @CNTFL            6 0
 
      ** Authorize all unauthorized FX deals
 
     C                   EXSR      AUTHFXDL
 
      ** Output authorized count message
 
     C                   MOVEL     'MMM0266'     @MSGID
     C                   MOVE      @CNTAU        @ADAT1
     C                   MOVEL     DDFDLN        @ADAT2
     C                   MOVEL     DDLDLN        @ADAT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @ADAT
 
      ** Output failure count message
 
     C     @CNTFL        IFNE      0
     C                   MOVEL     'MMM1048'     @MSGID
     C                   MOVE      @CNTFL        @FDT1
     C                   MOVEL     DDFDLN        @FDT2
     C                   MOVEL     DDLDLN        @FDT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @FDTA
     C                   ENDIF
      *
     C     EMAIN         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHFXDL - Authorize all unauthorized FX deals
      *****************************************************************
     C     AUTHFXDL      BEGSR
 
      * Read FX deals
 
     C                   MOVEL     NXTFTID       DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READFXDL
 
      ** Do while not EOF
 
     C     @ERRMS        DOWEQ     *BLANK
 
      ** If deal is not deleted
 
     C     FHDDLT        IFNE      'D'
 
      ** Error in retrieve
 
     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   MOVEL     @FTRED        DDFRTN
     C                   ELSE
 
      ** Update Fx deal
 
     C                   EXSR      UPDTFXDL
     C                   ENDIF
     C                   ENDIF
 
      * Read FX Deals
 
     C                   EXSR      READFXDL
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDTFXDL - UPDATE FX DEAL
      *****************************************************************
     C     UPDTFXDL      BEGSR
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        FHLACT
      *
      * FOREIGN EXCHANGE DATABASE UPDATES
      *
     C                   CALLB     'FXFXDLUPF'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DEALFilFmt
     C/COPY WNCPYSRC,FXPBDLGC02
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'FXFXDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DEALFilFmt
     C                   ENDIF
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,FXPBDLGC01
     C                   ADD       1             @CNTAU
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READFXDL - READ THROUGH FX DEALS
      *****************************************************************
     C     READFXDL      BEGSR
      *
     C                   CALLB     'FXFXDLRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * DEAL Front Office Pointer
     C                   PARM                    DDFRTN           20
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * If no deal read, treat like EOF
      *
     C     @FTRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   ENDIF
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADFXDL
      *
      * Check whether past last deal number
      *
     C     @FTRED        IFGT      DDLDLN
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @FTRED        FOTRID
     C                   EXSR      RTVFXDL
     C                   ENDIF
      *
     C     EREADFXDL     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFXDL - RETRIEVE FX DEAL
      *****************************************************************
     C     RTVFXDL       BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'FXFXDLRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '*FRONT'      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO            6
      *
      * Booking branch
     C                   PARM                    DDBRSN            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DEALFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN            1
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRSN            1
      *
      * OK - Originating branch
     C                   PARM      *BLANK        OKORBR            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM      *ZEROS        WIdx                                         CAS004
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'ZA0250'
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN10
     C                   MOVE      '0'           *IN11
      *
      ** First Front Office Id must be entered
      *
     C     DDFDLN        IFEQ      *BLANKS
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN10
     C                   ENDIF
      *
      ** Second Front Office Id must be enterd
      *
     C     DDLDLN        IFEQ      *BLANKS
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN11
     C                   ENDIF
      *
     C     DDFDLN        IFEQ      *BLANKS
     C     DDLDLN        OREQ      *BLANKS
     C                   MOVEL     'FXM0500'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   GOTO      EVALSI
     C                   ENDIF
      *
      ** Second Id must be less than first Front Office Id
      *
     C     DDLDLN        IFLT      DDFDLN
     C                   MOVEL     'FXM0501'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN11
     C                   GOTO      EVALSI
     C                   ENDIF
      *
      ** Look for at least one deal
      *
     C                   MOVEL     DDFDLN        DDFRTN
     C                   MOVE      *BLANKS       @RDFWD
     C                   MOVE      'Y'           @RDBCK
     C                   EXSR      READFXDL
      *
     C                   MOVEL     @FTRED        NXTFTID          20
     C                   MOVEL     NXTFTID       DDFRTN
     C                   MOVE      'Y'           @RDFWD
     C                   MOVE      *BLANKS       @RDBCK
     C                   EXSR      READFXDL
      *
      ** Error if not at least one record to authorize
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     'MMM1029'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      True          *IN50
     C                   MOVE      True          *IN10
     C                   ENDIF
      *
     C     EVALSI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * NOINPUT - NO INPUT SCREEN
      *****************************************************************
     C     NOINPUT       BEGSR
      *
      ** Write message, present screen and end program
      *
     C                   MOVEL     'MMM0159'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
 
     C                   MOVE      True          *IN13
     C                   TIME                    DDTIME
     C                   WRITE     FXPBDLS0
     C                   WRITE     FXPBDLD1
     C                   WRITE     FXPBDLF1
     C                   READ      FXPBDLD1                               99
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXPBDLRAT'   DBPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      True          *IN40
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** Get DEALING ICD
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
**  CCPY@
(c) Misys International Banking Systems Ltd. 2001
