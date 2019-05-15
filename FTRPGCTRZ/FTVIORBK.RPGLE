     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP ordering bank')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIORBK - Validate Ordering Bank                            *
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
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247390             Date 28May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195545             Date 13Jul01               *
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
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247390 - Applied fix 221361.                                 *
      *  221361 - Ordering Bank not appearing when warning FTM2070 is *
      *           overridden.                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  195545 - Cannot get through warning message FMT2070.         *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.  (Recompiled)           *
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
      ** Incoming Payments Lvl 1 1/2 Scrn details from incoming transaction
      ** - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments Lvl 2 Scrn error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Used for SWIFT validation
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
      *
      ** Complete Ordering Bank
     D WDOBK           DS           175
     D   WDOBK1                1     35
     D   WDOBK2               36     70
     D   WDOBK3               71    105
     D   WDOBK4              106    140
     D   WDOBK5              141    175
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
      *
      /COPY FTCPYSRC,SFTADDRILE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
     C                   MOVEL     *BLANKS       WDOBK
     C                   MOVEL     DDOBK1        WDOBK1
     C                   MOVEL     DDOBK2        WDOBK2
     C                   MOVEL     DDOBK3        WDOBK3
     C                   MOVEL     DDOBK4        WDOBK4
     C                   MOVEL     DDOBK5        WDOBK5
     C                   MOVEL     *BLANKS       WORBT             1
     C                   MOVEL     *BLANKS       WADCK             1
      *
      ** Validate Ordering Bank
      *
     C                   EXSR      SRValORBK
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKOBK1 = 'N' OR
     C                             OKOBK2 = 'N' OR
     C                             OKOBK3 = 'N' OR
     C                             OKOBK4 = 'N' OR
     C                             OKOBK5 = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ELSE
      *
     C                   IF        OKOBK1 = 'W'                                               195545
     C                   EVAL      RetCodeIn = 'WARN '                                        195545
     C                   ENDIF                                                                195545
      *                                                                                       195545
     C                   MOVE      DDOBK1        IPORB1
     C                   MOVE      DDOBK2        IPORB2
     C                   MOVE      DDOBK3        IPORB3
     C                   MOVE      DDOBK4        IPORB4
     C                   MOVE      DDOBK5        IPORB5
     C                   MOVEL     WORBT         IPORBT
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValORBK - Validate Ordering Bank                           *
      *                                                               *
      *****************************************************************
     C     SRValORBK     BEGSR
      *
      ** Ordering Bank is Optional
      *
     C     WDOBK         IFEQ      *BLANKS
     C                   GOTO      EXORBK
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     WDOBK         ADDRSS
      *
      ** If only 1st line entered then SWIFT address assumed
      ** If field does not begin with '/' and is not longer than 11
      ** characters, validate as a S.W.I.F.T. Address
      *
     C     ADCH26        IFEQ      *BLANKS
     C     ADEXSW        ANDEQ     *BLANKS
     C     ADSLSH        ANDNE     '/'
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   MOVEL     DDOBK1        CLSWTK           12
      *
     C                   EXSR      SWIFT
      *
     C     ##CSID        IFEQ      'Y'
     C     *IN31         IFEQ      '1'
     C                   MOVEL     'N'           OKOBK1
     C                   ADD       1             IDx
     C                   MOVEL     'DDOBK1'      FldNamXAR(IDx)
     C**********         MOVEL     CLSWTK        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2069'     MsgIDxAr(IDx)
     C                   GOTO      EXORBK
     C                   ENDIF
      *                                                                    d
      ** No SWIFT address record.
      *
     C     *IN32         IFEQ      '1'
     C     *IN31         ANDEQ     '0'
     C**********         MOVEL     'N'           OKOBK1                                       195545
     C                   MOVEL     'W'           OKOBK1                                       195545
     C                   ADD       1             IDx
     C**********         MOVEL     'DDOBK1'      FldNamXAR(IDx)                               195545
     C**********         MOVEL     DDOBK1        MsgDtaXAr(IDx)                               195545
     C**********         MOVEL     'FTM2070'     MsgIDxAr(IDx)                                195545
     C                   MOVEL     'DDOBK1'      WFldNmXAr(IDx)                               195545
     C**********         MOVEL     DDOBK1        WMsgDtXAr(IDx)                      195545 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDOBK1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDOBK1)                   MD000091
     C                   MOVEL     'FTM2070'     WMsgIDxAr(IDx)                               195545
     C                   MOVEL     'S'           WORBT                                        221361
     C                   GOTO      EXORBK
     C                   ENDIF
      *
     C                   MOVEL     'S'           WORBT
      *
      ** Exit as validation complete for S.W.I.F.T.
      *
     C                   GOTO      EXORBK
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate as an address
      ** No address line allowed
      *
     C     WADCK         IFNE      'Y'
     C                   MOVEL     'A'           WORBT
     C                   GOTO      EXORBK
     C                   ENDIF
      *
     C                   MOVEL     'Y'           ADLINE
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'N'           OKOBK1
     C                   ADD       1             IDx
     C                   MOVEL     'DDOBK1'      FldNamXAR(IDx)
     C**********         MOVEL     DDOBK1        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDOBK1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDOBK1)                   MD000091
     C                   MOVEL     'FTM2154'     MsgIDxAr(IDx)
     C                   ENDIF
      *
     C     *IN92         IFEQ      '1'
     C                   MOVEL     'N'           OKOBK1
     C                   ADD       1             IDx
     C                   MOVEL     'DDOBK1'      FldNamXAR(IDx)
     C**********         MOVEL     DDOBK1        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDOBK1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDOBK1)                   MD000091
     C                   MOVEL     'FTM2155'     MsgIDxAr(IDx)
     C                   ENDIF
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKOBK1
     C                   ENDIF
      *
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKOBK2
     C                   ENDIF
      *
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKOBK3
     C                   ENDIF
      *
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKOBK4
     C                   ENDIF
      *
     C     AD#5          IFEQ      'Y'
     C                   MOVEL     'N'           OKOBK5
     C                   ENDIF
      *
      ** If no errors then bank is an address
      *
     C                   IF        OKOBK1 <> 'N' AND
     C                             OKOBK2 <> 'N' AND
     C                             OKOBK3 <> 'N' AND
     C                             OKOBK4 <> 'N' AND
     C                             OKOBK5 <> 'N'
     C                   MOVEL     'A'           WORBT
     C                   ENDIF
      *
     C     EXORBK        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTSWFTCLE
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
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDxAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
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
