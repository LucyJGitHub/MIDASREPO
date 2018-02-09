     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP transfer commission tariff')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVITRCT - Validate Transfer Commission Tariff               *
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
      *  Prev Amend No. MD000091           Date 06May13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
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
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
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
      ***Incoming*Payments*Lvl*2*Scrn*1/2*details*from*incoming*transaction     CFT014
      ***-*screen*format***********************************************         CFT014
     D*NwIP3ScnFmt***E DS                  EXTNAME(FTIPY3PD)                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)                    CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators***************         CFT014
     D*FTEIPY2****   E DS                  EXTNAME(FTEIPY2PD)                   CFT014
      ** Incoming Payments Lvl 2 Scrn 2 error indicators                        CFT014
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)                   CFT014
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
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
      ** Initialise work variable.
      *
     C                   EVAL      Idx = 0
      *
      ** Validate Transfer Commision Tariff.
      *
     C                   EXSR      SRValTRCT
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File field.
      *
     C                   IF        OKTRCT = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKTRCT <> 'N'
     C                   MOVE      DDTRCT        IPTRCT
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTRCT - Validate Transfer Commission Tariff              *
      *                                                               *
      *****************************************************************
      *
     C     SRValTRCT     BEGSR
      *
      ** Entry must be 1/2/3/4/5.
      *
     C     DDTRCT        IFNE      '1'
     C     DDTRCT        ANDNE     '2'
     C     DDTRCT        ANDNE     '3'
     C     DDTRCT        ANDNE     '4'
     C     DDTRCT        ANDNE     '5'
     C                   MOVE      'N'           OKTRCT
     C                   ADD       1             IDx
     C                   MOVEL     'DDTRCT'      FldNamXAR(IDx)
     C                   MOVEL     'FTM2055'     MsgIDxAr(IDx)
     C**********         MOVEL     DDTRCT        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDTRCT))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDTRCT)                   MD000091
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ***Incoming*Payments*Lvl*2*Scrn*1/2*details*from*incoming*transaction     CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP3ScnFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4ScnFmt                    CFT014
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDxAr
     C                   PARM                    MsgDtaXAr
      *
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY2                        CFT014
      ** Incoming Payments Lvl 2 Scrn 2 error indicators                        CFT014
     C                   PARM                    FTEIPY3                        CFT014
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
