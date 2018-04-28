     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP intermediary bank')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIINBK - Validate Intermediary Bank                        *
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
      *  Last Amend No. MD000091           Date 07May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG8170            Date 14Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
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
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8170 - Validation of Fields in FT Incoming Payments       *
      *            Fields Intermediary Bank, SWIFT Reference and      *
      *            SWIFT sequence number should be validated          *
      *            accordingly. Also SWIFT Priority code should       *
      *            appear after Sequence Number field.                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Intermediary Bank Information
     D DDIBK           DS           175
     D  W0INB1                 1     35
     D  W0INB2                36     70
     D  W0INB3                71    105
     D  W0INB4               106    140
     D  W0INB5               141    175
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
      *                                                                                      BUG8170
      ** Index for arrays of error message ids, etc.                                         BUG8170
     D WIx             S              3P 0                                                   BUG8170
      *
     D ADSLON          S              1
     D ##CSID          S              1
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
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
     C                   EVAL      WIx = 0                                                   BUG8170
     C                   CLEAR                   DDIBK
     C                   MOVEL     DDINB1        W0INB1
     C                   MOVEL     DDINB2        W0INB2
     C                   MOVEL     DDINB3        W0INB3
     C                   MOVEL     DDINB4        W0INB4
     C                   MOVEL     DDINB5        W0INB5
     C                   MOVEL     *Blank        WINBT             1
      *
      ** Validate Intermediary Bank
      *
     C                   EXSR      SRValInBnk
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKINB1 = 'N' or
     C                             OKINB2 = 'N' or
     C                             OKINB3 = 'N' or
     C                             OKINB4 = 'N' or
     C                             OKINB5 = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   MOVE      DDINB1        IPINB1
     C                   MOVE      DDINB2        IPINB2
     C                   MOVE      DDINB3        IPINB3
     C                   MOVE      DDINB4        IPINB4
     C                   MOVE      DDINB5        IPINB5
     C                   MOVE      WINBT         IPINBT
     C                   ENDIF
      *
     C                   IF        OKINB1 = 'W' or                                           BUG8170
     C                             OKINB2 = 'W' or                                           BUG8170
     C                             OKINB3 = 'W' or                                           BUG8170
     C                             OKINB4 = 'W' or                                           BUG8170
     C                             OKINB5 = 'W'                                              BUG8170
     C                   EVAL      RetCodeIn = 'WARN '                                       BUG8170
     C                   ENDIF                                                               BUG8170
      *                                                                                      BUG8170
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALINBNK - Validate Intermediary Bank                      *
      *                                                               *
      *****************************************************************
     C     SRValInBnk    BEGSR
      *
     C     DDIBK         IFEQ      *Blanks
     C                   GOTO      EXINBK
     C                   ENDIF
      *
      ** Move in data for address validation
      *
     C                   MOVE      *Blanks       ADDRSS
     C                   MOVEL     DDIBK         ADDRSS
      *
      ** If only 1st line entered then SWIFT Address assumed
      ** Or first is '/' and second is SWIFT Address
      *
      *
      ** If field does not begin with '/' and is not longer than 11
      ** characters, validate as a S.W.I.F.T. Address
      *
     C     ADCH26        IFEQ      *Blanks
     C     ADEXSW        ANDEQ     *Blanks
     C     ADSLSH        ANDNE     '/'
     C     ADCH36        OREQ      *Blanks
     C     ADEXS2        ANDEQ     *Blanks
     C     ADSLSH        ANDEQ     '/'
     C     ADSLS2        ANDNE     '/'
      *
      ** First 11 characters should be key for CLSWT.
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     ADCHK1        CLSWTK           12
     C                   ELSE
     C                   MOVEL     ADCHK2        CLSWTK
     C                   ENDIF
      *
     C                   EXSR      SWIFT
      *
     C     ##CSID        IFEQ      'Y'
      *
     C     *IN31         IFEQ      *On
      *
      ** Highlight correct field
     C                   ADD       1             IDx
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     'N'           OKINB1
     C                   MOVEL     'DDINB1'      FldNamXAR(IDx)
     C                   ELSE
     C                   MOVEL     'N'           OKINB2
     C                   MOVEL     'DDINB2'      FldNamXAR(IDx)
     C                   ENDIF
      *
     C**********         MOVEL     CLSWTK        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2073'     MsgIdXAr(IDx)
     C                   GOTO      EXINBK
      *
     C                   ENDIF
      *
     C                   MOVEL     'S'           WINBT
      *
      ** No SWIFT address record.
      *
     C     *IN32         IFEQ      *On
     C     *IN31         ANDEQ     *Off
      *
      ** If text changed then warning needs to be changed
      *
     C     CLSWTK        IFNE      V#INB1
     C                   MOVEL     CLSWTK        V#INB1           35
     C                   ENDIF
      *
      ** Highlight correct field
     C**********         ADD       1             IDx                                         BUG8170
     C                   ADD       1             WIx                                         BUG8170
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     'W'           OKINB1
     C**********         MOVEL     'DDINB1'      FldNamXAR(IDx)                              BUG8170
     C                   MOVEL     'DDINB1'      WFldNmXAr(WIx)                              BUG8170
     C                   ELSE
     C                   MOVEL     'W'           OKINB2
     C**********         MOVEL     'DDINB2'      FldNamXAR(IDx)                              BUG8170
     C                   MOVEL     'DDINB2'      WFldNmXAr(WIx)                              BUG8170
     C                   ENDIF
      *
     C**********         MOVEL     CLSWTK        MsgDtaXAr(IDx)                              BUG8170
     C**********         MOVEL     'FTM2074'     MsgIdXAr(IDx)                               BUG8170
     C**********         MOVEL     CLSWTK        WMsgDtXAr(WIx)                     BUG8170 MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2074'     WMsgIdXAr(WIx)                              BUG8170
     C                   ENDIF
      *
      ** Exit as validation complete for S.W.I.F.T.
      *
     C                   GOTO      EXINBK
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Do not check address lines unless address check Yes
      *
     C     ##ADCK        IFNE      'Y'
     C                   MOVEL     'A'           WINBT
     C                   GOTO      EXINBK
     C                   END
      *
      ** Validate as an address
      *
     C                   MOVEL     'Y'           ADLINE            1
     C                   MOVEL     'FTM2319'     ADFLDM            7
     C                   MOVEL     'FTUSRMSG'    ADFLDF           10
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN91         IFEQ      *On
     C                   ADD       1             IDx
     C                   MOVEL     'N'           OKINB1
     C                   MOVEL     'DDINB1'      FldNamXAR(IDx)
     C**********         MOVEL     W0INB1        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(W0INB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(W0INB1)                   MD000091
     C                   MOVEL     'FTM2159'     MsgIdXAr(IDx)
     C                   ENDIF
      *
     C     *IN92         IFEQ      '1'
     C                   ADD       1             IDx
     C                   MOVEL     'N'           OKINB1
     C                   MOVEL     'DDINB1'      FldNamXAR(IDx)
     C**********         MOVEL     W0INB1        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(W0INB1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(W0INB1)                   MD000091
     C                   MOVEL     'FTM2159'     MsgIdXAr(IDx)
     C                   ENDIF
      *
      ** Illegal Characters found
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKINB1
     C                   END
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKINB2
     C                   END
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKINB3
     C                   END
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKINB4
     C                   END
     C     AD#5          IFEQ      'Y'
     C                   MOVEL     'N'           OKINB5
     C                   END
      *
     C                   IF        OKINB1 <> 'N' and
     C                             OKINB2 <> 'N' and
     C                             OKINB3 <> 'N' and
     C                             OKINB4 <> 'N' and
     C                             OKINB5 <> 'N'
     C                   MOVEL     'A'           WINBT
     C                   ENDIF
      *
     C     EXINBK        ENDSR
      *
      *****************************************************************
      *
      /EJECT
      /COPY FTCPYSRC,SFTSWFTCLE
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
      *                                                                                      BUG8170
      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG8170
     C                   PARM                    WFldNmXAr                                   BUG8170
     C                   PARM                    WMsgIDXAr                                   BUG8170
     C                   PARM                    WMsgDtXAr                                   BUG8170
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
