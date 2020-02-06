     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP bank to bank information')        *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIBTBI - Validate Bank to Bank Information                 *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15121           Date 25Oct07               *
      *                 BUG13014           Date 04Jan07               *
      *                 CFT032             Date 11Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15121 - Error in updating bank-to-bank info 1.  The value *
      *             from ordering customer 5 is being moved.          *
      *             Recompile only to get the correct format of       *
      *             FTIPY3PD.                                         *
      *  CFT032 - Account line in field 50X in MT103 (Recompile)      *
      *  BUG13014 - Ordering customer line 5 is repeated in Bank to   *
      *             Bank Information (Recompile).                     *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** Incoming Payments Lvl 2 2/2 Scrn details from incoming transaction
      ** - screen format
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 2 Scrn error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Complete Bank to Bank Information
     D DDBTB           DS           214
     D   WDBBI1                1     35
     D   WDBBI2               36     70
     D   WDBBI3               71    105
     D   WDBBI4              106    140
     D   WDBBI5              141    175
     D   WDBBI6              176    210
      *
      /COPY FTCPYSRC,SFTADDRILE
      *
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      **
     D ADLINE          S              1
     D ADSLON          S              1
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
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   Z-ADD     0             IDx
      *
     C                   CLEAR                   DDBTB
     C                   MOVEL     DDBBI1        WDBBI1
     C                   MOVEL     DDBBI2        WDBBI2
     C                   MOVEL     DDBBI3        WDBBI3
     C                   MOVEL     DDBBI4        WDBBI4
     C                   MOVEL     DDBBI5        WDBBI5
     C                   MOVEL     DDBBI6        WDBBI6
     C                   MOVEL     *BLANK        WADCK             1
      *
      ** Validate Bank to Bank Information
      *
     C                   EXSR      SRValBTOB
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKBBI1 = 'N' OR
     C                             OKBBI2 = 'N' OR
     C                             OKBBI3 = 'N' OR
     C                             OKBBI4 = 'N' OR
     C                             OKBBI5 = 'N' OR
     C                             OKBBI6 = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ELSE
      *
     C                   MOVEL     DDBBI1        IPBBI1
     C                   MOVEL     DDBBI2        IPBBI2
     C                   MOVEL     DDBBI3        IPBBI3
     C                   MOVEL     DDBBI4        IPBBI4
     C                   MOVEL     DDBBI5        IPBBI5
     C                   MOVEL     DDBBI6        IPBBI6
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValBTOB - Validate Bank to Bank Information                *
      *                                                               *
      *****************************************************************
     C     SRValBTOB     BEGSR
      *
      ** Validate Bank to Bank Information
      *
     C     DDBTB         IFNE      *BLANKS
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     DDBTB         ADDRSS
      *
      ** Do not check address lines unless address check Yes
      *
     C     WADCK         IFNE      'Y'
     C                   GOTO      EXBTB
     C                   ENDIF
      *
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN92         IFEQ      '1'
     C                   MOVEL     'N'           OKBBI1
     C                   ADD       1             IDx
     C                   MOVEL     'DDBBI1'      FldNamXAr(IDx)
     C                   MOVEL     DDBBI1        MsgDtaXAr(IDx)
     C                   MOVEL     'FTM2158'     MsgIDxAr(IDx)
     C                   ENDIF
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI1
     C                   ENDIF
      *
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI2
     C                   ENDIF
      *
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI3
     C                   ENDIF
      *
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI4
     C                   ENDIF
      *
     C     AD#5          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI5
     C                   ENDIF
      *
     C     AD#6          IFEQ      'Y'
     C                   MOVEL     'N'           OKBBI6
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXBTB         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDxAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
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
