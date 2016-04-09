     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP Senders correspondent')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISCOR - Validate Sender's Correspondent                   *
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
      *  Last Amend No. MD000091           Date 06May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248080             Date 06Jun07               *
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
      *  248080 - Applied fix 240225.                                 *
      *  240225 - Use warning array index and flag as warning not err.*
      *           FTM2072 is warning not error so use warning array   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      ** Incoming Payments Lvl 2 Scrn error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      ** Index for arrays of warning message ids etc                                          240225
     D WIx             S              3P 0                                                    240225
      *
      ** Used for SWIFT validation
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
      *
      ** Complete Sender's Correspondence
     D WDSNC           DS           175
     D   WDSNC1                1     35
     D   WDSNC2               36     70
     D   WDSNC3               71    105
     D   WDSNC4              106    140
     D   WDSNC5              141    175
      *
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
      *
      /COPY FTCPYSRC,SFTADDRILE
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
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
     C                   Z-ADD     0             WIx                                          240225
      *
     C                   CLEAR                   WDSNC
     C                   MOVEL     DDSNC1        WDSNC1
     C                   MOVEL     DDSNC2        WDSNC2
     C                   MOVEL     DDSNC3        WDSNC3
     C                   MOVEL     DDSNC4        WDSNC4
     C                   MOVEL     DDSNC5        WDSNC5
     C                   MOVEL     *BLANK        WPSNCT            1
     C                   MOVEL     *BLANK        WADCK             1
      *
      ** Validate Sender's Correspondent
      *
     C                   EXSR      SRValSNDC
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKSNC1 = 'N' OR
     C                             OKSNC2 = 'N' OR
     C                             OKSNC3 = 'N' OR
     C                             OKSNC4 = 'N' OR
     C                             OKSNC5 = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ELSE
      *
     C                   MOVE      DDSNC1        IPSNC1
     C                   MOVE      DDSNC2        IPSNC2
     C                   MOVE      DDSNC3        IPSNC3
     C                   MOVE      DDSNC4        IPSNC4
     C                   MOVE      DDSNC5        IPSNC5
     C                   MOVE      WPSNCT        IPSNCT
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValSNDC - Validate Sender's Correspondent                  *
      *                                                               *
      *****************************************************************
     C     SRValSNDC     BEGSR
      *
      ** Senders Correspondent is optional
      ** It becomes mandatory if CFT014 is on and Third Reimbursement           CFT014
      ** Institution was entered by the user.                                   CFT014
      *
     C     WDSNC         IFEQ      *BLANKS
     C     CFT014        IFEQ      'Y'                                          CFT014
     C     PDDTRIB       ANDNE     *BLANKS                                      CFT014
     C                   MOVEL     'N'           OKSNC1                         CFT014
     C                   MOVEL     'N'           OKSNC2                         CFT014
     C                   MOVEL     'N'           OKSNC3                         CFT014
     C                   MOVEL     'N'           OKSNC4                         CFT014
     C                   MOVEL     'N'           OKSNC5                         CFT014
     C                   ADD       1             IDX                            CFT014
     C                   MOVEL     'DDSNC1'      FldNamXAR(IDX)                 CFT014
     C                   MOVEL     'FTM5008'     MsgIdXAr(IDX)                  CFT014
     C                   ENDIF                                                  CFT014
     C                   GOTO      EXSNC
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     WDSNC         ADDRSS
      *
      ** If only 1st line entered then SWIFT address assumed
      ** Or first is '/' and second is SWIFT Address
      ** If field does not begin with '/' and is not longer than 11
      ** characters, validate as a S.W.I.F.T. Address
      *
     C     ADCH26        IFEQ      *BLANKS
     C     ADEXSW        ANDEQ     *BLANKS
     C     ADSLSH        ANDNE     '/'
     C     ADCH36        OREQ      *BLANKS
     C     ADEXS2        ANDEQ     *BLANKS
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
     C     *IN31         IFEQ      '1'
     C                   MOVEL     'N'           OKSNC1
     C                   ADD       1             IDX
     C***********        MOVEL     'DDSND1'      FldNamXAR(IDX)                 CFT014
     C                   MOVEL     'DDSNC1'      FldNamXAR(IDX)                 CFT014
     C**********         MOVEL     CLSWTK        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2071'     MsgIdXAr(IDX)
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     'N'           OKSNC1
     C                   ELSE
     C                   MOVEL     'N'           OKSNC2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     'S'           WPSNCT
      *
      ** No SWIFT address record.
      *
     C     *IN32         IFEQ      '1'
     C     *IN31         ANDEQ     '0'
      *
      ** If text changed then warning needs to be changed
      *
     C     CLSWTK        IFNE      DDSNC1
     C                   MOVEL     'N'           OKSNC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDSNC1'      FldNamXAR(IDX)
     C                   MOVEL     CLSWTK        DDSNC1
     C                   ENDIF
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     'N'           OKSNC1
     C                   ELSE
     C                   MOVEL     'N'           OKSNC2
     C                   ENDIF
     C************       MOVEL     'N'           OKSNC1                                       240225
     C************       ADD       1             IDX                                          245022
     C***********        MOVEL     'DDSND1'      FldNamXAR(IDX)                 CFT014
     C************       MOVEL     'DDSNC1'      FldNamXAR(IDX)                        CFT014 240225
     C************       MOVEL     CLSWTK        MsgDtaXAr(IDX)                               240225
     C************       MOVEL     'FTM2072'     MsgIdXAr(IDX)                                240225
     C                   MOVEL     'W'           OKSNC1                                       240225
     C                   ADD       1             WIx                                          240225
     C                   MOVEL     'DDSNC1'      WFldNmXAr(WIx)                               240225
     C**********         MOVEL     CLSWTK        WMsgDtXAr(WIx)                      240225 MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2072'     WMsgIDXAr(WIx)                               240225
     C                   ENDIF
      *
      ** Exit as validation complete for S.W.I.F.T.
      *
     C                   GOTO      EXSNC
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate as an address
      ** Allow only '/' in first line
      *
     C     WADCK         IFNE      'Y'
     C                   MOVEL     'A'           WPSNCT
     C                   GOTO      EXSNC
     C                   ENDIF
      *
     C                   MOVEL     'Y'           ADLINE            1
     C                   MOVEL     'Y'           ADSLON            1
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'N'           OKSNC1
     C                   ADD       1             IDX
     C***********        MOVEL     'DDSND1'      FldNamXAR(IDX)                 CFT014
     C                   MOVEL     'DDSNC1'      FldNamXAR(IDX)                 CFT014
     C**********         MOVEL     DDSNC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSNC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDSNC1)                   MD000091
     C                   MOVEL     'FTM2156'     MsgIdXAr(IDX)
     C                   ENDIF
      *
     C     *IN92         IFEQ      '1'
     C                   MOVEL     'N'           OKSNC1
     C                   ADD       1             IDX
     C***********        MOVEL     'DDSND1'      FldNamXAR(IDX)                 CFT014
     C                   MOVEL     'DDSNC1'      FldNamXAR(IDX)                 CFT014
     C**********         MOVEL     DDSNC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDSNC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDSNC1)                   MD000091
     C                   MOVEL     'FTM2157'     MsgIdXAr(IDX)
     C                   ENDIF
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKSNC1
     C                   ENDIF
      *
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKSNC2
     C                   ENDIF
      *
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKSNC3
     C                   ENDIF
      *
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKSNC4
     C                   ENDIF
      *
     C     AD#5          IFEQ      'Y'
     C                   MOVEL     'N'           OKSNC5
     C                   ENDIF
      *
      ** If no errors then bank is an address
      *
     C                   IF        OKSNC1 <> 'N' and
     C                             OKSNC2 <> 'N' and
     C                             OKSNC3 <> 'N' and
     C                             OKSNC4 <> 'N' and
     C                             OKSNC5 <> 'N'
     C                   MOVEL     'A'           WPSNCT
     C                   ENDIF
      *
     C     EXSNC         ENDSR
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
      *                                                                         CFT014
      ** Third Reimbursement Institution from screen 1                          CFT014
     C                   PARM                    PDDTRIB          34            CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
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
(c) Misys International Banking Systems Ltd. 2001
