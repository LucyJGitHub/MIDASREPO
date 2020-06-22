     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *: OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)          : *         CPB002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio defns retrieve + actn/key val')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDM2RV - Portfolio Definition Retrieve                   *
      *               (With Action Code/Customer/Portfolio Reference  *
      *               Validation)                                     *
      *                                                               *
      *  Function: This module retrieves the Portfolio Definition     *
      *            from the database.  As it does, it validates the   *
      *            action code, customer, and portfolio reference.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT113             Date 01Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 209092             Date 04Sep02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *  HUT113 - Full Private Banking Functionality in FM            *
      *           Addition of hooks HUT113_001 to HUT113_003 and      *
      *           HUT113_034 and HUT113_035.                          *
      *           Add MD052257                                        *
      *    MD052257A - System still accepts alphanumeric portfolio    *
      *                000A to 000I for portfolio reference and   *
      *                error message was issued for the valid         *
      *                portfolio reference.                           *
      *    MD052257 - System accepts input of alphanumeric portfolio  *
      *               '000G' and '000A' as Portfolio Reference        *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  209092 - If PM off, customer not PB but is requested as a PB *
      *           customer, do not send msg PMA1014                   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      ** Portfolio Definition Details
      ** - all records
      ** - keyed on customer and portfolio reference
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Portfolio Definition Details
      ** - keyed on Front Office ID
     FPMPORTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PMPORTP0:PMPORFOI)
      *
      ** Pool Portfolio Definition Details
     FPMPPTDPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Live Pool Portfolio Definition Details
     FPMPPTML1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Portfolio Totals
     FPMPOTTPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Charges file
     FPMCHRGPD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                         CPB002
      ** Customer Private Banking Details                                       CPB002
     FSDPBDSLR  IF   E           K DISK    INFSR(*PSSR)                         CPB002
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
      ** Arrays for Portfolio Reference validation
      *
     D WNUMA           S              1    DIM(36) PERRCD(36) CTDATA
     D WDDPREF         S              1    DIM(4)
      *
      ** Original Portfolio Definition Details
      ** - read from file
     D PMPORT        E DS                  EXTNAME(PMPORTPD)
      *
      ** Original Portfolio Definition Details
      ** - for output
     D PPORTFILFMT   E DS                  EXTNAME(PMVPFDMPD)
      *
      ** Externally described DS for Portfolio Management
      ** Customer Details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                         CPB002
      ** DS for Access Programs - very long data structure                      CPB002
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
     D/COPY WNCPYSRC,HUT113_001                                                 HUT113
      *
      ** DS for Multibranching Checking
     D ZMUSER          DS            17
     D  WBRCH                 11     13
      *
      ** DS for REVIEW FROM (used by *SIN function)
     D PREVIEW         DS            10
     D  DDPNP8                 1      6
     D  DDPORT                 7     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc.
     D Ix              S              3P 0
      *
      ** Index for portfolio reference array
     D Ctr             S              1P 0
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
     C                   EXSR      SRINIT
      *
      ** If the mode is 'Front Office Transaction Interface',
      ** do (extra) validation for Front Office Transaction Interface.
      *
     C     PMODE         IFEQ      '*FRONT'
     C                   EXSR      SRVFRNT
      *
      ** No further validation if errors occurred.
      *
     C     PDDACTNOK     IFEQ      'N'
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For SCREEN INPUT function, perform an initial validation
      ** of action code, customer, portfolio reference and
      ** REVIEW FROM if the latter is supplied.
      *
     C     PMODE         IFEQ      '*SIN  '
     C     PREVIEW       ANDNE     *BLANK
      *
     C                   EXSR      SRVALRVW
      *
      ** No further validation if REVIEW FROM is supplied in the
      ** SCREEN INPUT function.
      *
     C                   RETURN
     C                   ENDIF
      *
      ** Validate action code, customer and portfolio reference.
      *
     C                   EXSR      SRVALACT
      *
      ** No further validation if errors occurred.
      *
     C     PDDACTNOK     IFEQ      'N'
     C     PDDCSNMOK     OREQ      'N'
     C     PDDPREFOK     OREQ      'N'
      *
     C                   RETURN
      *
     C                   ENDIF
      *
      ** Additional validation for Insert
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      SRVALI
     C                   ENDIF
      *
      ** Additional validation for Amend
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      SRVALA
     C                   ENDIF
      *
      ** Additional validation for Closure
      *
     C     DDACTN        IFEQ      'C'
     C                   EXSR      SRVALC
     C                   ENDIF
      *
      ** Additional validation for Enquire
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      SRVALE
     C                   ENDIF
      *
      ** If action code is not insert and fields are valid,
      ** move file values to output parameter.
      *
     C     DDACTN        IFNE      'I'
     C     PDDACTNOK     ANDEQ     'Y'
     C     PDDCSNMOK     ANDEQ     'Y'
     C     PDDPREFOK     ANDEQ     'Y'
      *
     C                   MOVE      PMPORT        PPORTFILFMT
      *
     C                   ENDIF
      *
      ** No further validation if errors occurred.
      *
     C     PDDACTNOK     IFEQ      'N'
     C     PDDCSNMOK     OREQ      'N'
     C     PDDPREFOK     OREQ      'N'
      *
     C                   RETURN
      *
     C                   ENDIF
      *
      ** Access Security Checking.
      *
     C     PRESPONSE     IFEQ      'S'
      *
      ** If single-branching,
      ** ACCESS SECURITY CHECKING - SINGLE-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
      *
     C                   EXSR      SRACSSES
     C                   ENDIF
      *
      ** If multi-branching,
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
      *
     C                   EXSR      SRACSSEM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Initialise output parameters.
      *
     C                   CLEAR                   PPORTFILFMT
     C                   MOVEL     'Y'           PDDACTNOK
     C                   MOVEL     'Y'           PDDPREFOK
     C                   MOVEL     'Y'           PDDCSNMOK
     C                   MOVEL     'Y'           PREVIEWOK
      *
     C                   MOVEL     *BLANKS       QBCSBY
     C                   MOVEL     *BLANKS       PQBCSBY
     C                   MOVEL     *BLANKS       PMCUST
     C                   MOVEL     *BLANKS       PBBRCD
     C                   MOVEL     *BLANKS       PBACOC
      *
     C                   Z-ADD     0             WDPREF            4 0
      *
     C                   CLEAR                   PMPORT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFRNT - Routine to validate Front Office Transaction       *
      *            Interface                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRVFRNT       BEGSR
      *
      ** Error if action code is not I(Insert), A(Amend), C(Closure),
      ** E(Enquire).
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'E'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'PMA1002'     MSGIDARR(Ix)
     C                   ENDIF
      *
      ** Error if Front Office Transaction ID is blank.
      *
     C     PFOTRID       IFEQ      *BLANK
     C                   MOVE      'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'APM0201'     MSGIDARR(Ix)
     C                   goto      ESRVFRNT
     C                   ENDIF
      *
      ** Access Portfolio Definition Details file using Front Office
      ** Transaction ID.
      *
     C     PFOTRID       CHAIN     PMPORFOI                           01
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Front Office Transaction ID can't be present already.
      *
     C     *IN01         IFEQ      '0'
     C                   MOVE      'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'APM0202'     MSGIDARR(Ix)
     C                   MOVEL     PFOTRID       MSGDTAARR(Ix)
     C                   goto      ESRVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction ID must be present.
      *
     C     *IN01         IFEQ      '1'
     C                   MOVE      'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'APM0203'     MSGIDARR(Ix)
     C                   MOVEL     PFOTRID       MSGDTAARR(Ix)
      *
     C                   ELSE
      *
      ** If not insert, update Midas Portfolio Definition keys.
      *
     C                   MOVE      *BLANKS       DDCSNM
     C                   MOVEL     PNCNUM        DDCSNM
     C                   MOVEL     PNPTFR        DDPREF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRVFRNT      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALRVW - Validation of action code, customer, portfolio    *
      *             reference, and REVIEW FROM for SCREEN INPUT       *
      *             function                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRVALRVW      BEGSR
      *
      ** If REVIEW FROM is supplied,
      ** ==========================
      *
      ** action code must be blank.
      *
     C     DDACTN        IFNE      *BLANK
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'PM11114'     MSGIDARR(Ix)
     C                   ENDIF
      *
      ** customer must be blank.
      *
     C     DDCSNM        IFNE      *BLANKS
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FLDNAMEARR(Ix)
     C                   MOVEL     'PM11114'     MSGIDARR(Ix)
     C                   ENDIF
      *
      ** portfolio reference must be blank.
      *
     C     DDPREF        IFNE      *BLANKS
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPREF'      FLDNAMEARR(Ix)
     C                   MOVEL     'PM11114'     MSGIDARR(Ix)
     C                   ENDIF
      *
      ** REVIEW FROM Customer must be supplied.
      *
     C     DDPNP8        IFEQ      *BLANK
     C                   MOVEL     'N'           PREVIEWOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPNP8'      FLDNAMEARR(Ix)
     C                   MOVEL     'PM11102'     MSGIDARR(Ix)
      *
     C                   ELSE
      *
      ***If*REVIEW FROM Customer is supplied, input must be numeric.                          CSD027
      **********                                                                              CSD027
     C**********         TESTN                   DDPNP8               01                      CSD027
     C**********         MOVE      DDPNP8        W_TEST            1                          CSD027
     C**********         TESTZ                   W_TEST                   02                  CSD027
      **********                                                                              CSD027
     C******IN01         IFEQ      '0'                                                        CSD027
     C******IN02         OREQ      '0'                                                        CSD027
      **********                                                                              CSD027
     C**********         MOVEL     'N'           PREVIEWOK                                    CSD027
     C**********         ADD       1             Ix                                           CSD027
     C**********         MOVEL     'DDPNP8'      FLDNAMEARR(Ix)                               CSD027
     C**********         MOVEL     'PMA1006'     MSGIDARR(Ix)                                 CSD027
      **********                                                                              CSD027
     C**********         ENDIF                                                                CSD027
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALACT - Routine to validate action code, customer and     *
      *             portfolio reference                               *
      *           - A different validation routine is performed if    *
      *             REVIEW FROM is supplied in SCREEN INPUT function  *
      *                                                               *
      *****************************************************************
      *
     C     SRVALACT      BEGSR
      *
      ** Error if action code is not I(Insert), A(Amend), C(Closure),
      ** E(Enquire).
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'E'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'PMA1002'     MSGIDARR(Ix)
      *
     C                   ENDIF
      *
      ** Error if customer is blank.
      *
     C     DDCSNM        IFEQ      *BLANKS
      *
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FldNameArr(Ix)
     C                   MOVEL     'PMA1003'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      ** If Customer has been supplied, check if '?' exists on
      ** Customer field if module is called by *CTL function.
      *
     C     PMODE         IFEQ      '*FRONT'
     C     '?'           SCAN      DDCSNM                                 01
     C                   ELSE
     C                   EVAL      *IN01 = '0'
     C                   ENDIF
      *
      ** Continue process if no '?' character on Customer field or
      ** module is not called by *CTL function.
      *
     C     *IN01         IFEQ      '0'
      *
      ***Test*if Customer is numeric.                                                         CSD027
      **********                                                                              CSD027
     C**********         MOVEL     DDCSNM        WDCSNM1           6                          CSD027
     C**********         MOVE      DDCSNM        WDCSNM2           4                          CSD027
     C**********         TESTN                   WDCSNM1              9898                    CSD027
      **********                                                                              CSD027
     C******IN98         IFEQ      '0'                                                        CSD027
     C*****WDCSNM2       ORNE      *BLANKS                                                    CSD027
     C**********         MOVEL     '*CSHT  '     PKEY                                         CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     '*CNUM  '     PKEY                                         CSD027
     C**********         ENDIF                                                                CSD027
      *
      ** Access customer details.
      *
     C**********         CALLB     'AOCUSTR0'                                   CPB002
     C                   CALLB     'AOCUSTR1'                                   CPB002
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DDCSNM        PCNUM            10
     C                   PARM                    PKEY              7
     C*****SDCUST        PARM      SDCUST        DSSDY                          CPB002
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB002
      *
      ** Error if Customer not found.
      *
     C     PRTCD         IFNE      *BLANKS
      *
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FldNameArr(Ix)
     C                   MOVEL     'PMA1015'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      ** If Customer found, set branch code and account officer code
      ** for output.
      *
     C                   EVAL      PBBRCD = BBBRCD
     C                   EVAL      PBACOC = BBACOC
      *
     C                   MOVEL     BBCUST        WCNUM
     C                   MOVEL     WCNUM         DDCSNM
      *                                                                         CPB002
     C     WCNUM         CHAIN     SDPBDSLR                           01        CPB002
      *
      ** Check if action code is allowed.
      ** - Insert and Closure not allowed in the *SIN function if
      **   customer is a Private Banking Customer.
      *
     C     PMODE         IFEQ      '*SIN  '
     C     BBPRBA        ANDEQ     'Y'
      *
     C/COPY WNCPYSRC,HUT113_002                                                 HUT113
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'C'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'PMA1012'     MSGIDARR(Ix)
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Error if '?' exists on customer and module is called by
      ** *CTL function.
      *
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FldNameArr(Ix)
     C                   MOVEL     'PMA1015'     MsgIdArr(Ix)
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If no errors in Customer, process it further.
      *
     C     PDDCSNMOK     IFNE      'N'
      *
      ** If Portfolio Management module is installed, retrieve
      ** PM Customer details.
      *
     C     BGPFMG        IFEQ      'Y'
     C                   MOVEL     DDCSNM        WCSNM
     C                   CALLB     'AOPLCSR0'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM                    WCSNM            10
     C     SDPLCS        PARM      SDPLCS        DSSDY
      *
      ** Error if not PM Customer nor PB Customer.
      *
     C     PRTCD         IFNE      *BLANKS
     C     QBTYLC        OREQ      'D'
      *
     C     BBPRBA        IFNE      'Y'
     C     PBREPB        ANDNE     'Y'                                          CPB002
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FldNameArr(Ix)
     C                   MOVEL     'PMA1013'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       DDCSNM
     C**********         MOVEL     QBCUST        WCNUM             6 0                        CSD027
     C                   MOVEL     QBCUST        WCNUM             6                          CSD027
     C                   MOVEL     WCNUM         DDCSNM
      *
     C                   EVAL      PMCUST = 'Y'
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If PM is not installed, customer should be a PB Customer.
      ** or requested as a PB Customer.                                         209092
      *
     C     BBPRBA        IFNE      'Y'
     C     PBREPB        ANDNE     'Y'                                          209092
     C                   MOVEL     'N'           PDDCSNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCSNM'      FldNameArr(Ix)
     C                   MOVEL     'PMA1014'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Error if Portfolio Reference is blank.
      *
     C     DDPREF        IFEQ      *BLANKS
      *
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPREF'      FldNameArr(Ix)
     C                   MOVEL     'PMA1004'     MsgIdArr(Ix)

     C                   ELSE
      *
      ** Validate supplied Portfolio Reference.
      *
     C/COPY WNCPYSRC,HUT113_034                                                 HUT113
     C                   TESTN                   DDPREF               10
      *
     C     *IN10         IFEQ      '1'
      *
     C/COPY WNCPYSRC,HUT113_035                                                 HUT113
      *
     C                   MOVEL     DDPREF        WDPREF
      *
     C     WDPREF        IFLT      1
     C     WDPREF        ORGT      99
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPREF'      FldNameArr(Ix)
     C                   MOVEL     'PMA1011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPREF'      FldNameArr(Ix)
     C                   MOVEL     'PMA1011'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALI - Routine to validate action code 'I'                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALI        BEGSR
      *
      ** Record should not be existing.
      *
     C     WKEY1         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      '0'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11107'     MsgIdArr(Ix)
      *
     C                   ELSE
      *
      ** Read charges file.  If charges found for this portfolio,
      ** delete them.
      *
     C     WKEY1         SETLL     PMCHRGPD
      *
     C     *IN01         DOUEQ     '1'
      *
     C     WKEY1         READE     PMCHRGPD                               01
      *
     C     *IN01         IFEQ      '0'
     C                   DELETE    PMCHRGP0
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALA - Routine to validate action code 'A'                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALA        BEGSR
      *
      ** Check if record is existing.
      *
     C     WKEY1         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      '1'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11108'     MsgIdArr(Ix)
     C                   goto      ESRVALA
     C                   ENDIF
      *
      ** Portfolio Definition is existing but in progress to be closed.
      *
     C     PNRECI        IFEQ      'D'
     C     PNDPCL        ANDNE     0
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11116'     MsgIdArr(Ix)
     C                   goto      ESRVALA
     C                   ENDIF
      *
      ** Portfolio Definition is closed.
      *
     C     PNRECI        IFNE      'D'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11117'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     ESRVALA       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALC - Routine to validate action code 'C'                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALC        BEGSR
      *
      ** Check if record is existing.
      *
     C     WKEY1         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      '1'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FLDNAMEARR(Ix)
     C                   MOVEL     'PM11108'     MSGIDARR(Ix)
     C                   goto      ESRVALC
     C                   ENDIF
      *
      ** Portfolio Definition is existing but is not live.
      *
     C     PNRECI        IFNE      'D'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11117'     MsgIdArr(Ix)
     C                   goto      ESRVALC
     C                   ENDIF
      *
      ** Test if portfolio is a pool portfolio.
      *
     C     WKEY1         CHAIN     PMPPTDPD                           01
      *
     C     *IN01         IFEQ      '0'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11119'     MsgIdArr(Ix)
     C                   goto      ESRVALC
     C                   ENDIF
      *
      ** Test if portfolio is attached to a pool portfolio.
      *
     C     WKEY1         CHAIN     PMPPTML1                           01
      *
     C     *IN01         IFEQ      '0'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11120'     MsgIdArr(Ix)
     C                   goto      ESRVALC
     C                   ENDIF
      *
      ** If Bank Portfolio is supported, portfolio must not have
      ** any transactions/positions against it.
      *
     C     FCPORS        IFEQ      'B'
      *
     C     WKEY1         CHAIN     PMPOTTP0                           01
      *
     C     *IN01         IFEQ      '0'
      *
     C     QCPTPA        IFNE      *ZERO
     C     QCPTNA        ORNE      *ZERO
     C     QCPTMV        ORNE      *ZERO
     C     QCPVPA        ORNE      *ZERO
     C     QCPVNA        ORNE      *ZERO
     C     QCPTMV        ORNE      *ZERO
     C     QCPTAI        ORNE      *ZERO
     C     QCPTNI        ORNE      *ZERO
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PMA0016'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRVALC       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALE - Routine to validate action code 'E'                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALE        BEGSR
      *
      ** Check if record is existing.
      *
     C     WKEY1         CHAIN     PMPORTPD                           01
      *
     C     *IN01         IFEQ      '1'
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM11109'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACSSES - Access Security Checking for Single-Branching     *
      *                                                               *
      *****************************************************************
      *
     C     SRACSSES      BEGSR
      *
      ** Check if user is authorised to action code.
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    PERR              1 0
      *
      ** Action code is invalid for user.
      *
     C     PERR          IFNE      *ZERO
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM02000'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACSSEM - Access Security Checking for Multi-Branching      *
      *                                                               *
      *****************************************************************
      *
     C     SRACSSEM      BEGSR
      *
      ** Check if user is authorised to action code.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN
     C                   PARM      WBRCH         ZBR               3
     C                   PARM                    PERR
      *
      ** Action code is invalid for user.
      *
     C     PERR          IFNE      *ZERO
      *
     C                   MOVEL     'N'           PDDACTNOK
     C                   MOVEL     'N'           PDDCSNMOK
     C                   MOVEL     'N'           PDDPREFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'PM02000'     MsgIdArr(Ix)
     C                   ENDIF
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
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMODE             6
      *
      ** Response Mode
     C                   PARM                    PRESPONSE         1
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** Front Office Transaction ID
     C                   PARM                    PFOTRID          20
      *
      ** Portfolio Reference
     C                   PARM                    DDPREF            4
      *
      ** Customer
     C                   PARM                    DDCSNM           10
      *
      ** REVIEW FROM key fields to position browse display in
      ** SCREEN INPUT function
     C                   PARM                    PREVIEW
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS            1
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG            1
      *
      ** OUTPUT
      ** ======
      *
      ** Original Portfolio Definition Details in file format
     C                   PARM                    PPORTFILFMT
      *
      ** OK Action Code
     C                   PARM                    PDDACTNOK         1
      *
      ** OK Portfolio Reference
     C                   PARM                    PDDPREFOK         1
      *
      ** OK Customer
     C                   PARM                    PDDCSNMOK         1
      *
      ** OK REVIEW FROM (for *SIN function only)
     C                   PARM                    PREVIEWOK         1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMEARR
     C                   PARM                    MSGIDARR
     C                   PARM                    MSGDTAARR
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM      QBCSBY        PQBCSBY           3
      *
      ** Portfolio Management Customer flag
     C                   PARM                    PMCUST            1
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    PBBRCD            3
      *
      ** SDCUST - Account Officer Code of incoming customer
     C                   PARM                    PBACOC            2
      *
      ** Get default branch of user.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ** Key list for access to PMPORTPD
      *
     C     WKEY1         KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    DDPREF
      *
     C/COPY WNCPYSRC,HUT113_003                                                 HUT113
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
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
**  WNUMA
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
