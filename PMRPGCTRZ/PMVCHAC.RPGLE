     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Account')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVCHAC    - Validate Portfolio Charges Customer Settlement  *
      *               Account                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      ** Accounts file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Retail Accounts file
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMTBF)
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** DS for Portfolio Charges Customer Settlement Account
     D                 DS
     D***WCUSA**                1     12                                                      CGL029
     D  WCUSA                  1     18                                                       CGL029
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6A                                                      CSD027
     D***WACOD**                7     10  0                                                   CGL029
     D***WACSQ**               11     12  0                                                   CGL029
     D  WACOD                  7     16  0                                                    CGL029
     D  WACSQ                 17     18  0                                                    CGL029
     D  WCSA1                  1     10  0
     D***WCSA2**               11     12                                                      CGL029
     D  WCSA2                 11     18                                                       CGL029
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Acess Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
      *
      ** Portfolio Charges Customer Settlement Currency number
      ** of decimal positions
     D P1PNCSDP        S              1S 0
     D DDCUSA          S             18                                                       CGL029
     D P1PNCUSA        S             18                                                       CGL029
     D W_CUSA2         S              8                                                       CGL029
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
     C                   MOVE      *BLANK        RETCODEIN
      *
     C                   MOVE      *BLANK        FLDNAMXAR
     C                   MOVE      *BLANK        MSGIDXAR
     C                   MOVE      *BLANK        MSGDTAXAR
     C                   Z-ADD     0             IDX
      *
     C                   CLEAR                   WCUSA
     C                   MOVE      '0'           *IN02
     C                   Z-ADD     0             A6NBDP
     C                   Z-ADD     1             Cntr              2 0
      *
      ** Validate Portfolio Charges Customer Settlement Account.
      *
     C                   EXSR      SRACNT
      *
     C     OKCSCY        IFEQ      'N'
     C     OKCUSA        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKCSCY        IFNE      'N'
     C                   EVAL      P1PNCSCY = DDCSCY
     C                   EVAL      P1PNCSDP = A6NBDP
     C                   ENDIF
      *
     C     OKCUSA        IFNE      'N'
     C     OKBRCA        ANDNE     'N'
     C                   EVAL      P1PNCUSA = DDCUSA
     C                   EVAL      P1PNCUSB = DDBRCA
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACNT - Validate Portfolio Charges Customer Settlement      *
      *           Account                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRACNT        BEGSR
      *
      ** Validate Portfolio Charges Customer Settlement Currency
      ** if entered or if Charge Codes exists.
      *
     C     DDCSCY        IFNE      *BLANKS
     C     ChrgCodeExist OREQ      'Y'
     C                   EXSR      SRCSCY
     C                   ENDIF
      *
     C     DDCUSA        IFEQ      *BLANKS
     C     DDBRCA        ANDEQ     *BLANKS
      *
      ** Validation routine if Portfolio Charges Customer
      ** Settlement Account has not been entered
      *
     C                   EXSR      SRACNT_1
      *
     C                   ELSE
      *
      ** Validation routine if Portfolio Charges Customer
      ** Settlement Account has been entered
      *
     C                   EXSR      SRACNT_2
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSCY - Validate Portfolio Charges Customer Settlement      *
      *           Currency                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCSCY        BEGSR
      *
      ** If not entered (and Charge Codes exist), default
      ** Settlement Currency to Customer's Base Currency.
      *
     C     DDCSCY        IFEQ      *BLANKS
     C                   MOVE      QBCSBY        DDCSCY
     C                   ENDIF
      *
      ** Access currency details.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY'        POPTN             7
     C                   PARM      DDCSCY        PKEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKCSCY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSCY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11301'     MSGIDXAR(IDX)
     C                   ELSE
     C                   MOVEL     PKEY          DDCSCY
     C                   ENDIF
      *
     C     ESRCSCY       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACNT_1 - Validation routine if Portfolio Charges Customer  *
      *             Settlement Account has not been entered           *
      *                                                               *
      *****************************************************************
      *
     C     SRACNT_1      BEGSR
      *
      ** Portfolio Charges Customer Settlement Account must be
      ** entered if Charge Codes exist.
      *
     C     ChrgCodeExist IFEQ      'Y'
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDCUSA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11302'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACNT_2 - Validation routine if Portfolio Charges Customer  *
      *             Settlement Account has been entered               *
      *                                                               *
      *****************************************************************
      *
     C     SRACNT_2      BEGSR
      *
     C                   MOVE      *BLANKS       W_CUSA10         10
     C**********         MOVE      *BLANKS       W_CUSA2           2                          CGL029
     C                   MOVE      *BLANKS       W_CUSA2                                      CGL029
      *
      ** Test if entry is a 12-digit or 10-digit input.
      *
     C                   TESTN                   DDCUSA               01
      *
     C     *IN01         IFEQ      '0'
     C                   MOVEL     DDCUSA        W_CUSA10
     C                   MOVE      DDCUSA        W_CUSA2
     C                   TESTN                   W_CUSA10             01
      *
      ** Error if entry is not a 12-digit or 10-digit input.
      *
     C     *IN01         IFEQ      '0'
     C     W_CUSA2       ORNE      *BLANKS
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDCUSA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11303'     MSGIDXAR(IDX)
      *
     C                   goto      ESRACNT_2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     DDCUSA        WCUSA
      *
      ** Validate if retail account entered is valid.
      *
     C     WCSA2         IFEQ      *BLANKS
      *
     C     WCSA1         CHAIN     ACNUMTBF                           01
      *
      ** If live account found, test retail indicators.
      *
     C     *IN01         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   EXSR      SRTestRI
     C                   ENDIF
      *
     C     *IN01         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *IN02         OREQ      '0'
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDCUSA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11303'     MSGIDXAR(IDX)
      *
     C                   goto      ESRACNT_2
     C                   ENDIF
      *
      ** Branch of account should be equal to Customer
      ** Settlement Branch entered.
      *
     C     BRCA          IFNE      DDBRCA
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDBRCA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11304'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** Currency of account should be equal to Customer
      ** Settlement Currency entered.
      *
     C     CCY           IFNE      DDCSCY
     C                   MOVE      'N'           OKCSCY
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDCUSA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11338'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If 12 alpha account entered, entry must be a valid
      ** account when combined with Customer Settlement
      ** Currency and Branch on screen.
      *
     C                   MOVEL     DDCSCY        WCUCY
     C                   MOVEL     DDBRCA        WBRCA
     C     KACCNT        CHAIN     ACCNTABF                           01
      *
      ** If live account found, test retail indicators.
      *
     C     *IN01         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   EXSR      SRTestRI
     C                   ENDIF
      *
     C     *IN01         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *IN02         OREQ      '0'
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDCUSA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11304'     MSGIDXAR(IDX)
      *
     C                   goto      ESRACNT_2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If system is not multi-branching, Branch entered must be
      ** equal to the branch code in Bank's Details file.
      *
     C     BGMBIN        IFEQ      'N'
     C     BJSBRC        ANDNE     DDBRCA
     C                   MOVE      'N'           OKCUSA
     C                   MOVE      'N'           OKBRCA
     C                   ADD       1             IDX
     C                   MOVEL     'DDBRCA'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11304'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     ESRACNT_2     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTestRI - Test bit settings for retail indicators for       *
      *             account used for Portfolio Charges Customer       *
      *             Settlement Account                                *
      *                                                               *
      *****************************************************************
      *
     C     SRTestRI      BEGSR
      *
     C                   MOVE      '0'           *IN02
     C                   TESTB     '23'          RETB                 02
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
      ** Return code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - incoming
     C                   PARM                    DDCSCY            3
      *
      ** Portfolio Charges Customer Settlement Account
      ** - incoming
     C**********         PARM                    DDCUSA           12                          CGL029
     C                   PARM                    DDCUSA                                       CGL029
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - incoming
     C                   PARM                    DDBRCA            3
      *
      ** SDPLCS - Portfolio Customer's Base Currency
     C                   PARM                    QBCSBY            3
      *
      ** Portfolio Charge Codes Exist indicator
     C                   PARM                    ChrgCodeExist     1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Multi-branching Indicator
     C                   PARM                    BGMBIN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - OK indicator
     C                   PARM                    OKCSCY            1
      *
      ** Portfolio Charges Customer Settlement Account
      ** - OK indicator
     C                   PARM                    OKCUSA            1
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - OK indicator
     C                   PARM                    OKBRCA            1
      *
      ** Portfolio Charges Customer Settlement Currency
      ** - for file update
     C                   PARM                    P1PNCSCY          3
      *
      ** Portfolio Charges Customer Settlement Currency
      ** number of decimal positions - for file update
     C                   PARM                    P1PNCSDP
      *
      ** Portfolio Charges Customer Settlement Account
      ** - for file update
     C**********         PARM                    P1PNCUSA         12                          CGL029
     C                   PARM                    P1PNCUSA                                     CGL029
      *
      ** Portfolio Charges Customer Settlement Branch
      ** - for file update
     C                   PARM                    P1PNCUSB          3
      *
      ** Key list
      *
     C     KACCNT        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCUCY             3
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA             3
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
(c) Misys International Banking Systems Ltd. 2001
