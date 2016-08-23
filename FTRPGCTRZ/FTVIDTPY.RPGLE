     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP details of payment')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIDTPY - Validate Details of Payments                      *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
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
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
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
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)
      *
      ** DS for Details of Payment
     D DDPAY           DS           140
     D  W0DTP1                 1     35
     D  W0DTP2                36     70
     D  W0DTP3                71    105
     D  W0DTP4               106    140
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
     D ADSLON          S              1
     D ##CSID          S              1
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
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
     C                   CLEAR                   DDPAY
     C                   MOVEL     DDDTP1        W0DTP1
     C                   MOVEL     DDDTP2        W0DTP2
     C                   MOVEL     DDDTP3        W0DTP3
     C                   MOVEL     DDDTP4        W0DTP4
      *
      ** Validate Details of Payments
      *
     C                   EXSR      SRValDPay
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKDTP1 = 'N' or
     C                             OKDTP2 = 'N' or
     C                             OKDTP3 = 'N' or
     C                             OKDTP4 = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKDTP1 <> 'N'
     C                   MOVE      DDDTP1        IPDTP1
     C                   ENDIF
      *
     C                   IF        OKDTP2 <> 'N'
     C                   MOVE      DDDTP2        IPDTP2
     C                   ENDIF
      *
     C                   IF        OKDTP3 <> 'N'
     C                   MOVE      DDDTP3        IPDTP3
     C                   ENDIF
      *
     C                   IF        OKDTP4 <> 'N'
     C                   MOVE      DDDTP4        IPDTP4
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALDPAY - Validate Details of Payments                     *
      *                                                               *
      *****************************************************************
     C     SRValDPay     BEGSR
      *
     C     DDPAY         IFNE      *Blanks
      *
      ** Do not check address lines unless address check Yes
      *
     C     ##ADCK        IFNE      'Y'
     C                   GOTO      EXDPAY
     C                   ENDIF
      *
      ** Prevent first check in ADCHK subroutine
      *
     C                   MOVEL     ' '           ADLINE            1
      *
     C                   MOVE      *Blanks       ADDRSS
     C                   MOVEL     DDPAY         ADDRSS
      *
     C                   MOVEL     'FTM2317'     ADFLDM            7
     C                   MOVEL     'FTUSRMSG'    ADFLDF           10
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN92         IFEQ      *On
     C                   ADD       1             IDx
     C                   MOVEL     'N'           OKDTP1
     C                   MOVEL     'DDDTP1'      FldNamXAR(IDx)
     C                   MOVEL     DDDTP1        MsgDtaXAr(IDx)
     C                   MOVEL     'FTM2161'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKDTP1
     C                   ENDIF
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKDTP2
     C                   ENDIF
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKDTP3
     C                   ENDIF
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKDTP4
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXDPAY        ENDSR
      *
      *****************************************************************
      *
      /EJECT
      /COPY FTCPYSRC,SFTADDRCLE
      *
      /EJECT
      /COPY FTCPYSRC,SFTADDRSC1
      *
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
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
     C                   MOVE      *Blanks       ##ADCK            1
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
(c) Misys International Banking Systems Ltd. 2001
