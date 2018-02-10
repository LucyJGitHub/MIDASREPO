     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Invalid portfolio definitions repair')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMRPR - Invalid Portfolio Definitions Repair             *
      *                                                               *
      *  Function:  This function allows invalid Portfolio            *
      *             Definitions to be 'repaired' and applied to the   *
      *             Midas database.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Transaction errors
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      *
      ** Invalid Portfolio Definitions for input
     FPMIPFDML0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PMIPFDMD0:PMIPFDMX0)
      *
      ** Invalid Portfolio Definitions for update
     FPMIPFDML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** Invalid Log File                                                                     CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,PMPFDMR001
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
     D WEI             S              1    DIM(60)
      ** Override Database Table                                                CPB002
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)            CPB002
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     D NwDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
      *
      ** Portfolio Definition Details - for file update
     D NwDfFilFmt    E DS                  EXTNAME(PMVPFDMPD)
     D  PInvestInds           81     84
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     D CrDfScnFmt    E DS                  EXTNAME(PMPFDMPD)
     D                                     PREFIX(PS)
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     D CrDfFilFmt    E DS                  EXTNAME(PMPORTPD)
      *
      ** Incoming Extra Data
     D PExtData      E DS                  EXTNAME(PMPFEXPD)
      *
      ** Error indicators
     D PMEPMD        E DS                  EXTNAME(PMEPFDMPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Portfolio Details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Custody Fees
     D SDSCFE        E DS                  EXTNAME(SDSCFEPD)
      *
      ** Externally described DS for API ICD Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data Structure for last update
     D WLUP            DS
     D   WDLUP                 1      2  0
     D   WMLUP                 3      5
     D   WYLUP                 6      7  0
      *
      ** The Investment Policy Indicators are input-capable only
      ** on the Screen Input (*SIN) function:
      ** - (DDIPIN) Instrument nvestment Policy Indicator
      ** - (DDCYIN) Currency Investment Policy Indicator
      ** - (DDYPIN) Country of Risk Investment Policy Indicator
      ** - (DDNPIN) Industry Investment Policy Indicator
      ** For *CTL and *RPR, since no values are being received
      ** from the MQ Series, they are just defaulted to the file values.
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     D PCurInvestI     DS             4
      *
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PRespMode       S              1A   INZ('S')
      *
      ** Timestamp selected
     D PTMESTPSEL      S             26Z
      *
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field)
     D Format          S             10A   INZ('PMPFDMPD')
     D Field           S             10A   INZ('DDACTN')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
      *
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(PTMESTPSEL)                                   CSC011
                                                                                              CSC011
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,PMPFDMR002
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
      /COPY WNCPYSRC,PMPFDMR003
      *
      ** DO Screen: Browse invalid Portfolio Definitions
      *
     C     WSCRN         IFEQ      'B'
     C                   EXSR      SRSCRN_B
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMR004
      *
      ** Read next browse subfile record
      *
     C     WSCRN         IFEQ      'R'
     C                   EXSR      SRRDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMR005
      *
      ** DO WHILE Screen: Main details
      *
     C     WSCRN         DOWEQ     'M'
     C                   EXSR      SRSCRN_M
     C                   ENDDO
      *
      /COPY WNCPYSRC,PMPFDMR006
      *
      ** Screen: Confirmation of input
      *
     C     WSCRN         IFEQ      'F'
     C                   EXSR      SRSCRN_F
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMR007
      *
      ** Do file updates.
      *
     C     WSCRN         IFEQ      'U'
     C                   EXSR      SRUPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMR008
      *
      ** Terminate program.
      *
     C     WSCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDMR009
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_B - Browse Invalid Portfolio Definitions              *
      *                                                               *
      *****************************************************************
      *
     C     SRSCRN_B      BEGSR
      *
      ** Reset Read Next Browse Subfile Record flag.
      *
     C                   MOVEL     *BLANK        WRDNB             1
      *
      ** Build Browse Subfile.
      *
     C                   CALLB     'PMPFDMRPB'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build subfile
     C                   PARM      'Y'           PBDSFL            1
      *
      ** Read subfile record
     C                   PARM      *BLANK        PRDSFL            1
      *
      ** Error in update of previous transaction
     C                   PARM                    PERRUP            1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM      *BLANK        PERRMS            7
      *
      ** Option selected
     C                   PARM                    POPSEL            1
      *
      ** Action selected
     C                   PARM                    PACSEL            1
      *
      ** Customer Selected
     C                   PARM                    PCSNMSEL         10
      *
      ** Portfolio Reference Selected
     C                   PARM                    PPREFSEL          4
      *
      ** Front Office Transaction ID selected
     C                   PARM                    PFOTRANSEL       20
      *
      ** Timestamp of transaction selected
     C                   PARM                    PTMESTPSEL
      *
      ** Command key
     C                   PARM      '0'           PINKC             1
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Reset error update flag.
      *
     C                   MOVE      'N'           PERRUP
      *
      ** If error occurred, set on external switch.
      *
     C     PERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   ENDIF
      *
      ** If F3 taken in Browse Screen or if error occurred, end
      ** program.  Else, read selected Browse subfile record.
      *
     C     PINKC         IFEQ      '1'
     C     PERRMS        ORNE      *BLANK
      *
     C                   EXSR      SRENDP
     C                   ELSE
      *
     C                   MOVE      'Y'           WRDNB
     C                   MOVEL     'R'           WSCRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDNBRW - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
      *
     C     SRRDNBRW      BEGSR
      *
     C                   CALLB     'PMPFDMRPB'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build subfile
     C                   PARM      *BLANK        PBDSFL
      *
      ** Read subfile record
     C                   PARM      'Y'           PRDSFL
      *
      ** Error in update of previous transaction
     C                   PARM                    PERRUP
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM      *BLANK        PERRMS
      *
      ** Option selected
     C                   PARM      *BLANK        POPSEL
      *
      ** Action selected
     C                   PARM      *BLANK        PACSEL
      *
      ** Customer Selected
     C                   PARM      *BLANK        PCSNMSEL
      *
      ** Portfolio Reference Selected
     C                   PARM      *BLANK        PPREFSEL
      *
      ** Front Office Transaction ID selected
     C                   PARM      *BLANK        PFOTRANSEL
      *
      ** Timestamp of transaction selected
     C                   PARM                    PTMESTPSEL
      *
      ** Command key
     C                   PARM      '0'           PINKC
                                                                                              CSC011
      ** CSC011 Enhancement is installed                                                      CSC011
                                                                                              CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** If F3 taken within invalid transaction deletion function,
      ** end program.  Else, continue processing.
      *
     C     PINKC         IFEQ      '1'
     C                   EXSR      SRENDP
      *
     C                   goto      ESRRDNBRW
     C                   ENDIF
      *
      ** If no invalid Portfolio Definition read from subfile,
      ** go to browse screen.
      *
     C     POPSEL        IFEQ      *BLANK
     C                   MOVEL     'B'           WSCRN
      *
     C                   goto      ESRRDNBRW
     C                   ENDIF
      *
      ** Prior to retrieve of the corresponding record of
      ** the invalid Portfolio Definition in the master
      ** database file, reset fields.
      *
     C                   EXSR      SRResetFld
      *
      ** Retrieve Portfolio Definition details.
      *
     C                   MOVEL     PACSEL        DDACTN
     C                   MOVEL     PCSNMSEL      DDCSNM
     C                   MOVE      PPREFSEL      DDPREF
     C                   MOVEL     PFOTRANSEL    FOTRID
      *
      ** If Insert, set retrieve mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and Midas transaction Id is present,
      ** set retrieve mode to blank (Access using Midas transaction Id).
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     '*FRONT'      PMODE
     C                   ELSE
      *
     C     DDCSNM        IFEQ      *BLANK
     C     DDPREF        ANDEQ     *BLANK
     C                   MOVEL     '*FRONT'      PMODE
     C                   ELSE
     C                   MOVEL     '      '      PMODE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      SRRTVDEF
      *
     C                   MOVEL     '      '      PMODE
      *
      ** If original Portfolio Definition details were retrieved,
      ** convert details in screen format.
      *
     C     DDACTN        IFNE      'I'
     C     PNRECI        ANDNE     *BLANK
     C                   EXSR      SRPUTD_M
      *
      ** Save customer and portfolio reference retrieved, in
      ** module/RTV, from the master database file using front
      ** office ID.
      *
     C                   MOVEL     DDCSNM        WDDCSNM          10
     C                   MOVEL     DDPREF        WDDPREF           4
     C                   ENDIF
      *
      ** Access invalid Portfolio Definitions file with timestamp
      ** and front office transaction ID to set main details
      ** screen.
      *
     C     ZATRNKX0      CHAIN     PMIPFDMX0                          99
      *
      ** Restore customer and portfolio reference retrieved, in
      ** module/RTV, from the master database file using front
      ** office ID.
      *
     C     DDACTN        IFNE      'I'
     C     PNRECI        ANDNE     *BLANK
     C                   MOVEL     WDDCSNM       DDCSNM
     C                   MOVEL     WDDPREF       DDPREF
     C                   ENDIF
      *
      ** Save Date Closed retrieved from the invalid records file.
     C                   MOVEL     DDDPCL        WDDDPCL           6
      *
      ** For Closure and Enquiry, overwrite details from invalid
      ** records file with the details from the master database
      ** file.
      *
     C     DDACTN        IFEQ      'C'
     C     PNRECI        ANDNE     *BLANK
     C     DDACTN        OREQ      'E'
     C     PNRECI        ANDNE     *BLANK
     C                   MOVEL     CrDfScnFmt    NwDfScnFmt
     C                   ENDIF
      *
      ** For Closure, restore Date Closed retrieved from the
      ** invalid records file.
      *
     C     DDACTN        IFEQ      'C'
     C     PNRECI        ANDNE     *BLANK
     C                   MOVEL     WDDDPCL       DDDPCL
     C                   ENDIF
      *
      ** If action code is insert, set Portfolio Definition Date Opened
      ** to rundate.
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     WRUNDATE      DDDPOP            6
     C                   ENDIF
      *
      ** If Portfolio Definition was retrieved and this is an amendment,
      *
     C     PNRECI        IFNE      *BLANK
     C     DDACTN        ANDEQ     'A'
      *
      ** Data Substitution - Transaction Details
      *
     C     GHSUBS        IFNE      *BLANK
     C     GHSUBS        SCAN      NwDfScnFmt                             99
      *
     C     *IN99         IFEQ      *ON
     C                   EXSR      SRDtaSubs
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If action code or Portfolio Definition keys were NOT OK
      ** and option is not enquire, blank out action code
      ** so that the input cannot proceed.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCSNM        OREQ      'N'
     C     OKPREF        OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF
      *
      ** Send the Portfolio Definition error messages to
      ** the main details screen.
      *
     C                   EXSR      SRSNDM_M
      *
      ** Go to main details screen.
      *
     C                   MOVEL     'M'           WSCRN
      *
     C     ESRRDNBRW     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
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
      ** Incoming Transaction
     C                   CLEAR                   NwDfScnFmt
      *
      ** Portfolio Definition Details - for file update
     C                   CLEAR                   NwDfFilfmt
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPOP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNBCGD
     C                   Z-ADD     *ZERO         P1PNCSDP
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C                   Z-ADD     *ZERO         P1PNMGTP
     C                   Z-ADD     *ZERO         P1PNINTP
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   CLEAR                   CrDfScnFmt
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   CLEAR                   CrDfFilFmt
      *
     C                   Z-ADD     *ZERO         PNPCDP
     C                   Z-ADD     *ZERO         PNDPOP
     C                   Z-ADD     *ZERO         PNDPCL
     C                   Z-ADD     *ZERO         PNVLDM
     C                   Z-ADD     *ZERO         PNVLND
     C                   Z-ADD     *ZERO         PNPDGS
     C                   Z-ADD     *ZERO         PNPDGF
     C                   Z-ADD     *ZERO         PNBCGD
     C                   Z-ADD     *ZERO         PNCSDP
     C                   Z-ADD     *ZERO         PNCASD
     C                   Z-ADD     *ZERO         PNCASN
     C                   Z-ADD     *ZERO         PNTYSM
     C                   Z-ADD     *ZERO         PNPSDT
     C                   Z-ADD     *ZERO         PNACSQ
      *
      ** Incoming Extra Data
     C                   CLEAR                   PExtData
      *
     C                   CLEAR                   PCurInvestI
      *
     C                   MOVE      *ALL'Y'       PMEPMD
      *
     C                   MOVE      *BLANKS       DDDPOP
     C                   MOVE      *BLANKS       PDDDELT
      *
     C                   MOVE      *BLANK        AmendOK
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVDEF - Retrieve Portfolio Definition Details             *
      *                                                               *
      *****************************************************************
      *
     C     SRRTVDEF      BEGSR
      *
     C                   CALLB     'PMPFDM2RV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE             6
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF
      *
      ** Customer Number
     C                   PARM                    DDCSNM
      *
      ** REVIEW FROM key fields to position browse display in
      ** SCREEN INPUT function
     C                   PARM      *BLANKS       PREVIEW          10
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    CrDfFilFmt
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Portfolio Reference
     C                   PARM                    OKPREF
      *
      ** OK Customer
     C                   PARM                    OKCSNM
      *
      ** OK REVIEW FROM (for *SIN function only)
     C                   PARM                    OKVIEW            1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC            2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPUTD_M - Convert Original Portfolio Definition Details     *
      *             to screen format                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPUTD_M      BEGSR
      *
     C                   CALLB     'PMPFDM2CT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Portfolio Definition Details retrieved from file
      ** - in file format
     C                   PARM                    CrDfFilFmt
      *
      ** Action code from incoming transaction
     C                   PARM                    DDACTN
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Futures & Options
     C                   PARM                    BGFUOP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    CrDfScnFmt
      *
      ** Investment Policy Indicators retrieved from file
      ** - for display
     C                   PARM                    PCurInvestI
      *
      ** Date Opened retrieved from file - in screen format
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT          16
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM_M - Send Portfolio Definition error messages to the   *
      *             main details screen                               *
      *                                                               *
      *****************************************************************
      *
     C     SRSNDM_M      BEGSR
      *
      ** Reset array index.
      *
     C                   Z-ADD     0             Ex                3 0
      *
      ** If error occurred in updating last transaction,
      ** display error message on the screen (first message).
      *
     C     PERRUP        IFEQ      'Y'
     C                   ADD       1             Ex
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     'APM1000'     MsgIdArr(Ex)
     C                   MOVE      'N'           PERRUP
     C                   ENDIF
      *
      ** Add Portfolio Definition details errors.
      *
     C                   ADD       IDx           Ex
      *
      ** If there are fundamental errors in this transaction,
      ** identify this fact (last message).
      *
     C     OKACTN        IFEQ      'N'
     C     OKCSNM        OREQ      'N'
     C     OKPREF        OREQ      'N'
     C                   ADD       1             Ex
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     'APM0110'     MsgIdArr(Ex)
     C                   ENDIF
      *
      ** Initialise error indicators.
      *
     C                   MOVEA     PMEPMD        WEI
      *
      ** Read error messages for Portfolio Definition.
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to main details
      ** screen and set OK flag for field to 'N'.
      *
     C     *IN99         DOWEQ     '0'
      *
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in msg array, disregard it
      ** to avoid duplicate messages from being displayed.
      *
     C     *IN98         IFNE      '1'
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
      *
     C                   Z-ADD     ABFIELDID     Fx                3 0
     C                   SUB       FldOffset     Fx
     C     Fx            IFLT      1
     C     Fx            ORGT      60
     C                   Z-ADD     1             Fx
     C                   ENDIF
     C                   MOVE      'N'           WEI(Fx)
      *
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     WEI           PMEPMD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_M - Process Main Details screen                       *
      *                                                               *
      *****************************************************************
      *
     C     SRSCRN_M      BEGSR
      *
      ** Enable/disable detail fields on main screen
      ** if changes to the data are allowed
      ** (key fields = action code, customer & portfolio reference;
      ** detail fields = rest).
      *
     C     POPSEL        IFEQ      'E'
     C     POPSEL        OREQ      'N'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      ' '
     C                   MOVEL     'N'           PEDTFD
     C                   ELSE
     C                   MOVEL     'Y'           PEDTFD
     C                   ENDIF
      *
      ** Enable/disable Portfolio Date Closed field.
      *
     C     DDACTN        IFEQ      'C'
     C     POPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           PEDT_DPCL
     C                   ELSE
     C                   MOVEL     'N'           PEDT_DPCL
     C                   ENDIF
      *
      ** Write/read display screen.
      *
     C                   CALLB     'PMPFDM3DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For this function, the values are the same as those
      **   kept on file.
     C                   PARM                    PCurInvestI
      *
      ** Date Opened in screen format
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT
      *
      ** Enable Portfolio Date Closed field
     C                   PARM                    PEDT_DPCL         1
      *
      ** Display Investment Policy Indicators
     C                   PARM      'N'           PSIN80            1
      *
      ** Enable detail fields
     C                   PARM                    PEDTFD            1
      *
      ** Enable function keys
     C                   PARM      'N'           PEINKA            1
     C                   PARM      'N'           PEINKG            1
     C                   PARM      'N'           PEINKH            1
     C                   PARM      'N'           PEINKP            1
     C                   PARM      'N'           PEINKY            1
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
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
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKA             1
     C                   PARM      '0'           PINKC             1
     C                   PARM      '0'           PINKG             1
     C                   PARM      '0'           PINKH             1
     C                   PARM      '0'           PINKL             1
     C                   PARM      '0'           PINKP             1
     C                   PARM      '0'           PINKY             1
      *
      ** Reset error fields.
      *
     C                   MOVE      *ALL'Y'       PMEPMD
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   SELECT
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F12- Read records from the subfile or return to browse
      ** screen.
      *
     C     PINKL         WHENEQ    '1'
      *
     C     WRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     'B'           WSCRN
     C                   ENDIF
      *
      ** ENTER - Validate input to main details screen only if option
      ** selected is amend, action code of transaction is not enquire
      ** and key fields are not in error (key fields = action code,
      ** customer & reference).  Else, read records from the subfile
      ** or return to browse screen.
      *
     C                   OTHER
      *
     C     POPSEL        IFEQ      'U'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     ' '
      *
     C                   EXSR      SRVAL_M
      *
     C                   ELSE
      *
     C     WRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
     C                   MOVEL     'B'           WSCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL_M - Validate input to main details screen              *
      *                                                               *
      *****************************************************************
      *
     C     SRVAL_M       BEGSR
      *
      ** Prior to validation, initialise error fields.
      *
     C                   MOVE      *ALL'Y'       PMEPMD
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
      ** If action code is not Insert, put the Portfolio Definition
      ** details retrieved from the master database file into the
      ** update file record.  Fields will be updated during
      ** processing.
      *
     C     DDACTN        IFNE      'I'
     C                   MOVEL     CrDfFilFmt    NwDfFilFmt
     C                   ENDIF
      *
      ** If action code is Insert, initialise Portfolio
      ** Definition for file update and default Date Opened
      ** to rundate.
      *
     C     DDACTN        IFEQ      'I'
     C                   CLEAR                   NwDfFilFmt
      *
     C                   Z-ADD     *ZERO         P1PNPCDP
     C                   Z-ADD     *ZERO         P1PNDPCL
     C                   Z-ADD     *ZERO         P1PNVLDM
     C                   Z-ADD     *ZERO         P1PNVLND
     C                   Z-ADD     *ZERO         P1PNPDGS
     C                   Z-ADD     *ZERO         P1PNPDGF
     C                   Z-ADD     *ZERO         P1PNBCGD
     C                   Z-ADD     *ZERO         P1PNCSDP
     C                   Z-ADD     *ZERO         P1PNCASD
     C                   Z-ADD     *ZERO         P1PNCASN
     C                   Z-ADD     *ZERO         P1PNTYSM
     C                   Z-ADD     *ZERO         P1PNPSDT
     C                   Z-ADD     *ZERO         P1PNACSQ
      *
     C                   Z-ADD     BJRDNB        P1PNDPOP
     C                   Z-ADD     BJRDNB        PNDPOP
      *
      ** If customer is not PM Customer, default mandatory
      ** fields.
      *
     C     PMCUST        IFNE      'Y'
     C                   EVAL      P1PNIPIN = 'N'
     C                   EVAL      P1PNCYIN = 'N'
     C                   EVAL      P1PNYPIN = 'N'
     C                   EVAL      P1PNNPIN = 'N'
     C                   EVAL      P1PNMNGI = 'M'
     C                   EVAL      P1PNRPYP = 'N'
     C                   Z-ADD     99999         P1PNPSDT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If action code is Amend, validate whether non-amendable
      ** fields have been changed.
      *
     C     DDACTN        IFEQ      'A'
      *
     C                   CALLB     'PMPFDM2AD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Portfolio Definition Details retrieved from file
      ** - in screen format
     C                   PARM                    CrDfScnFmt
      *
      ** Date Opened retrieved from file
      ** - in screen format
     C                   PARM                    DDDPOP
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           RESETERRS         1
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Amendments OK
     C                   PARM                    AmendOK           1
      *
     C                   ENDIF
      *
      ** Validate Portfolio Definition details.
      *
     C                   CALLB     'PMPFDM2VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Incoming Portfolio Definition Details - screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For this function, the values are the same as those
      **   kept on file.
     C                   PARM                    PInvestInds
      *
      ** Incoming Extra Data
     C                   PARM                    PExtData
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    PNDPOP
      *
      ** Original Performance Start Date
     C                   PARM                    PNPSDT
      *
      ** Original Pledge Finish Date
     C                   PARM                    PNPDGF
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    BBACOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDGELR - Profit Centre Defaults Used?
     C                   PARM                    BKPCDU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFMt
      *
      ** If errors exist, re-display main details screen with
      ** error messages.
      *
     C     IDx           IFNE      0
      *
     C                   goto      ESRVAL_M
     C                   ENDIF
      *
      ** Go to Confirmation screen.
      *
     C                   MOVEL     'F'           WSCRN
      *
     C     ESRVAL_M      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_F - Process screen: Confirmation of input             *
      *             used for Inserts & Amends                         *
      *                                                               *
      *****************************************************************
      *
     C     SRSCRN_F      BEGSR
      *
      ** Transaction is valid or only warnings exist.  Output warning
      ** messages before the message "Press enter to apply transaction
      ** to database or F12 to change".
      *
     C                   Z-ADD     1             Ix                3 0
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         70
     C                   MOVEL     '*ANY'        WFldNamArr(Ix)
     C                   MOVEL     'MMM1031'     WMsgIdArr(Ix)
      *
      ** Write/read display screen.
      *
     C                   CALLB     'PMPFDM3DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Portfolio Definition Details from incoming transaction
      ** - in screen format
     C                   PARM                    NwDfScnFmt
      *
      ** Investment Policy Indicators from incoming transaction
      ** - For this function, the values are the same as those
      **   kept on file.
     C                   PARM                    PCurInvestI
      *
      ** Date Opened in screen format
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    DDDPOP
      *
      ** CLOSED/CLOSURE REQUEST narrative - for display
     C                   PARM                    PDDDELT
      *
      ** Enable Portfolio Date Closed field
     C                   PARM      'N'           PEDT_DPCL
      *
      ** Display Investment Policy Indicators
     C                   PARM      'N'           PSIN80
      *
      ** Enable detail fields
     C                   PARM      'N'           PEDTFD
      *
      ** Enable function keys
     C                   PARM      'N'           PEINKA
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKP
     C                   PARM      'N'           PEINKY
      *
      ** Portfolio Definition Fields OK indicators
     C                   PARM                    PMEPMD
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
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDSCFE - Custody Fees Group for Portfolio
     C                   PARM                    FBFGCP
      *
      ** SDMMOD - Future & Options
     C                   PARM                    BGFUOP
      *
      ** SDMMOD - Portfolio Lending
     C                   PARM                    BGLMCR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Safe Custody Fees feature
     C                   PARM                    S01464
      *
      ** Profit Centre feature
     C                   PARM                    CAC003
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           PINKA
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
     C                   PARM      '0'           PINKY
      *
      ** Reset error fields.
      *
     C                   MOVE      *ALL'Y'       PMEPMD
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   SELECT
      *
      ** F3 - End program.
      *
     C     PINKC         WHENEQ    '1'
     C                   EXSR      SRENDP
      *
      ** F12 - Return to main details screen.
      *
     C     PINKL         WHENEQ    '1'
     C                   MOVEL     'M'           WSCRN
      *
      ** ENTER - Update records.
      *
     C                   OTHER
     C                   MOVEL     'U'           WSCRN
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATS - Files update                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDATS      BEGSR
      *
      ** Set Details for Insert.
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'D'           P1PNRECI
     C                   MOVEL     DDCSNM        P1PNCNUM
     C                   MOVEL     DDPREF        P1PNPTFR
     C                   ENDIF
      *
      ** Set Details for Insert, Amend and Closure.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EVAL      WLUP = BJMRDT
     C                   EVAL      P1PNDLUP = WDLUP
     C                   EVAL      P1PNMLUP = WMLUP
     C                   EVAL      P1PNYLUP = WYLUP
     C                   EVAL      P1PNTLUP = PSRUNTIME
     C                   EVAL      P1PNLCD  = BJRDNB
     C                   EVAL      P1PNTNLU = *ZERO
     C                   ENDIF
      *
      ** Move action code to last change type to affect changes.
      *
     C                   EVAL      P1PNCHTP = DDACTN
      *
      ** Move header details.
      *
     C                   EVAL      P1PNFRNT = PFOTRANSEL
      *
      ** Update Portfolio Definitions file.
      *
     C                   CALLB     'PMPFDMUPD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       PRETCD            7
      *
      ** Portfolio Definition Details - for file update
     C                   PARM                    NwDfFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *                                                                         CPB002
      ** SDMMOD - Private Banking                                               CPB002
     C                   PARM                    BGN4ST                         CPB002
      *
      ** If there were any errors in the update function,
      ** rollback any updates and end this program.
      ** Otherwise, delete the invalid Portfolio Definition
      ** actioned and commit the updates.
      *
     C     PRETCD        IFNE      *BLANK
     C     PRETCD        ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C     ZATRNKD0      CHAIN     PMIPFDMD0                          99
     C     *IN99         IFEQ      '0'
     C                   DELETE    PMIPFDMD0
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'PMPFDM'                                        CSC011
     C                   EVAL      KFrntOffID = PFOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = PTMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
     C                   COMMIT
     C                   ENDIF
      *
      ** If error occurred in updating last transaction,
      ** set on flag to display message on 'browse' screen.
      *
     C     PRETCD        IFEQ      '*RECUPD'
     C                   MOVE      'Y'           PERRUP
     C                   ELSE
     C                   MOVE      'N'           PERRUP
     C                   ENDIF
     C
      *
      ** If records are still to be read from the subfile, read them.
      *
     C     WRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WSCRN
     C                   ELSE
      *
      ** Else, return to the browse screen.
      *
     C                   MOVEL     'B'           WSCRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP - End program                                         *
      *                                                               *
      *****************************************************************
      *
     C     SRENDP        BEGSR
      *
     C                   MOVEL     'T'           WSCRN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Portfolio Definition Data Substitution           *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Substitution character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwDfScnFmt    IncDATA        2000
      *
      ** Current Data
     C                   PARM      CrDfScnfmt    CurDATA        2000
      *
     C                   MOVEL     IncDATA       NwDfScnFmt
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
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
      ** Acces Midas General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDPORT        PARM      SDPORT        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAC003
      ** (Profit Centre) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAC003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAC003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Switch on Profit Centre feature if Analytical Accounting is
      ** also switched on.
      *
     C     PRTCD         IFEQ      *BLANK
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVEL     'Y'           CAC003            1
     C                   ELSE
     C                   MOVEL     'N'           CAC003
     C                   ENDIF
      *
      ** Access SAR file to determine if S01464 (Safe Custody Fees)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01464'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01464'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01464            1
     C                   ELSE
     C                   MOVEL     'N'           S01464
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE =  9                                                 CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      ** If Safe Custody Fees is installed, access ICD details.
      *
     C     S01464        IFEQ      'Y'
      *
     C                   CALL      'AOSCFER0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSCFE        PARM      SDSCFE        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDSCFEPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   MOVEL     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
      *
     C                   IF        ReturnCode = *BLANK
     C                   EVAL      FldOffset = FieldNo - 1
      *
      ** If there was an error, default the offset to 13
      *
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
      *
      ** Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    PFOTRANSEL
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      ** Convert Rundate to date format.
      *
     C                   MOVE      BJRDNB        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVEL     *BLANKS       WRUNDATE          6
     C                   MOVEL     ZDATE         WRUNDATE
      *
      ** Start on Browse Screen.
      *
     C                   MOVEL     'B'           WSCRN             1
                                                                                CPB002
     C* Override SDPBDSLR                                                       CPB002
     C                   Z-ADD     50            MESLEN           15 5          CPB002
     C                   CALL      'QCMDEXC'                                    CPB002
     C                   PARM                    ##OX1                          CPB002
     C                   PARM                    MESLEN                         CPB002
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,PMPFDMR010
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
** ##OX1
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
