     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities amend checking for screen 2')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS2MD - Securities Amend Checking for Screen 2           *
      *                                                               *
      *  Function: This module compares the fields of an amended      *
      *            security details against those currently on        *
      *            file.  This program also checks whether all fields *
      *            amended are amendable, and if not, an error        *
      *            message will be sent to calling module.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 16May13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 26May05               *
      *                 CAP084             Date 10Jul03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205427             Date 02May02               *
      *                 CSE031             Date 14Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CAP084 - Use ZCMPAMTS to compare amount                      *
      *  CSE037 - Countervalue rounding - recompile only              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  205427 - Addition to CSE032 changes. Allow Yield Basis to be *
      *           initialised if now required on setting on feature.  *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Events
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(SEDEVDF)
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
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(A)
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities Screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IDx             S              3P 0
     D KSDET           S              2A   INZ('CP')
      *
      ** Entry parameter fields
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D BGRKMG          S              1A
     D CSE005          S              1A
     D CSE007          S              1A
     D CEU017          S              1A
     D CSE031          S              1A                                                      CSE031
     D CSE071          S              1A                                                      CSE071
     D PPROT           S              1A
     D PPrCpn          S              1A
 
     D WAmt1           S             15A
     D WAAmt2          S             15A
      *
      ** Parameters for module ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
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
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRCompare
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C                   IF        IDx > 0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C                   IF        IDx > 0 AND PResetFld = 'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCompare - Routine to compare fields from file and the      *
      *              amended screen fields                            *
      *                                                               *
      *****************************************************************
     C     SRCompare     BEGSR
 
     C                   EXSR      SRSetInds
      *
      ** Coupon Rate is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN69
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDCPNR        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDCPNR       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCPNR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon Rate'                           MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon Rate'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCPNR = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Base Rate Code not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF
     C                   IF        ADDBASC <> DDBASC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBASC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Base Rate Code'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Base Rate Code'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKBASC = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Base Rate/Spread is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBASS        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBASS       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBASS'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Base Rate/Spread'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Base Rate/Spread'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKBASS = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Spread Indicator is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF
     C                   IF        ADDSPRI <> DDSPRI
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSPRI'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Spread Indicator'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Spread Indicator'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSPRI = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Minimum Coupon is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF OR *IN94
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDMCPN        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDMCPN       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMCPN'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Minimum Coupon'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Minimum Coupon'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMCPN = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Maturity Date 2 is not amendable.
      *
     C                   IF        (*IN69 AND *IN80 AND *IN86 AND
     C                             *IN85 = *OFF) OR *IN87 OR *IN66 = *OFF
     C                   IF        ADDMATY2 <> DDMATY2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMATY2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Maturity Date'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Maturity Date'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMATY2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Maturity Date Indicator 2 is not amendable.
      *
     C                   IF        (*IN69 AND *IN86) OR
     C                             *IN80 = *OFF OR *IN66= *OFF
     C                   IF        ADDMDTI2 <> DDMDTI2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMDTI2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Maturity Date Ind.'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Maturity Date Ind.'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMDTI2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Longterm Maturity Indicator is not amendable.
      *
     C                   IF        *IN66 = *OFF AND ADDLTMI <> DDLTMI
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDLTMI'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Longterm Maturity Ind.'                MD000091
     C                   EVAL      MsgDtaTmp = 'Longterm Maturity Ind.'                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKLTMI = 'N'
     C                   ENDIF
      *
      ** Day Basis is not amendable.
      *
     C                   IF        *IN66 = *OFF OR (*IN69 AND *IN85 = *OFF)
     C                   IF        ADDDYBS2 <> DDDYBS2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDYBS2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Day Basis'                             MD000091
     C                   EVAL      MsgDtaTmp = 'Day Basis'                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDYBS2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Divisor Basis is not amendable.
      *
     C                   IF        *IN66 = *OFF OR (*IN69 AND *IN85 = *OFF)
     C                   IF        ADDDVBS2 <> DDDVBS2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDVBS2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Divisor Basis'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Divisor Basis'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDVBS2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Interest Adj. is not amendable.
      *
     C                   IF        *IN66 = *OFF AND ADDIADJ <> DDIADJ
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDIADJ'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Interest Adj.'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Interest Adj.'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKIADJ = 'N'
     C                   ENDIF
      *
      ** Contingent Liability Ind. is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN69
     C                   IF        ADDCNLI2 <> DDCNLI2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCNLI2'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Contingent Liab. Ind.'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Contingent Liab. Ind.'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCNLI2 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Initial Date is not amendable.
      *
     C                   IF        *IN66 = *OFF AND ADDITLD <> DDITLD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDITLD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Initial Date'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Initial Date'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKITLD = 'N'
     C                   ENDIF
      *
      ** First Coupon is not amendable.
      *
     C                   IF        *IN66 = *OFF AND ADDFCPN <> DDFCPN
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDFCPN'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'First Coupon'                          MD000091
     C                   EVAL      MsgDtaTmp = 'First Coupon'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKFCPN = 'N'
     C                   ENDIF
      *
      ** Coupon/Rate Ind. is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN91 = *OFF
 
     C                   IF        ADDCR01 <> DDCR01
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 1'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 1'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR01 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR02 <> DDCR02
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 2'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 2'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR02 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR03 <> DDCR03
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 3'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 3'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR03 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR04 <> DDCR04
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 4'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 4'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR04 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR05 <> DDCR05
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 5'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 5'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR05 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR06 <> DDCR06
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 6'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 6'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR06 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR07 <> DDCR07
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 7'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 7'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR07 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR08 <> DDCR08
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 8'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 8'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR08 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR09 <> DDCR09
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 9'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 9'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR09 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR10 <> DDCR10
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 10'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 10'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR10 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR11 <> DDCR11
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR11'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 11'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 11'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR11 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCR12 <> DDCR12
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCR12'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Ind. 12'                   MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Ind. 12'                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCR12 = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Rate Change Frequency is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF
     C                   IF        ADDRCFQ <> DDRCFQ
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRCFQ'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Rate Change Frequency'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Rate Change Frequency'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRCFQ = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Next Change Date is not amendable.
      *
     C                   IF        *IN66 = *OFF OR *IN84 = *OFF
     C                   IF        ADDNCHD <> DDNCHD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRCFQ'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Next Change Date'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Next Change Date'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKNCHD = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Initial Dividend Date is not amendable.
      *
     C                   IF        *IN67 = *OFF AND ADDIDIV <> DDIDIV
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDIDIV'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Initial Dividend Date'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Initial Dividend Date'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKIDIV = 'N'
     C                   ENDIF
      *
      ** Next Expected Dividend is not amendable.
      *
     C                   IF        *IN67 = *OFF AND ADDNEXD <> DDNEXD
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDNEXD'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Next Expected Dividend'                MD000091
     C                   EVAL      MsgDtaTmp = 'Next Expected Dividend'                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKNEXD = 'N'
     C                   ENDIF
      *
      ** Roll Fwd Dividend is not amendable.
      *
     C                   IF        *IN67 = *OFF OR *IN81 = *OFF
     C                   IF        ADDRFDI <> DDRFDI
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRFDI'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Roll Fwd Dividend'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Roll Fwd Dividend'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRFDI = 'N'
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSE031
      ** Coupon/Rate Dates are only amendable if Auto fix indicator                           CSE031
      ** is 'N' and Business Day Convention is 'N'.                                           CSE031
      *                                                                                       CSE031
     C                   IF        *IN20 = *OFF                                               CSE031
      *
      ** Coupon/Rate Days or Dividend Payment Dates is not amendable.
      *
     C                   IF        (*IN66 = *OFF AND *IN67 = *OFF) OR
     C                             *IN91 = *OFF
 
     C                   IF        ADDCD01 <> DDCD01
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 1'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 1'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 1'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 1'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD01 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD02 <> DDCD02
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 2'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 2'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 2'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 2'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD02 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD03 <> DDCD03
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 3'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 3'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 3'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 3'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD03 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD04 <> DDCD04
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 4'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 4'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 4'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 4'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD04 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD05 <> DDCD05
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 5'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 5'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 5'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 5'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD05 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD06 <> DDCD06
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 6'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 6'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 6'
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 6'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD06 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD07 <> DDCD07
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 7'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 7'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 7'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 7'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD07 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD08 <> DDCD08
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 8'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 8'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 8'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 8'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD08 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD09 <> DDCD09
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 9'               MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 9'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 9'                     MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 9'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD09 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD10 <> DDCD10
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 10'              MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 10'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 10'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 10'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD10 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD11 <> DDCD11
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD11'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 11'              MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 11'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 11'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 11'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD11 = 'N'
     C                   ENDIF
 
     C                   IF        ADDCD12 <> DDCD12
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCD12'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   IF        *IN67
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 12'              MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 12'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 12'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 12'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
     C                   EVAL      OKCD12 = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                       CSE031
     C                   ELSE                                                                 CSE031
      *                                                                                       CSE031
     C                   IF        ADDBCNV = 'N'                                              CSE031
      ** Fields are amendable.                                                                CSE031
     C                   ELSE                                                                 CSE031
     C                   IF        ADDCD01 <> DDCD01                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD01'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 1'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 1'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 1'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 1'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD01 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD02 <> DDCD02                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD02'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 2'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 2'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 2'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 2'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD02 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD03 <> DDCD03                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD03'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 3'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 3'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 3'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 3'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD03 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD04 <> DDCD04                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD04'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 4'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 4'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 4'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 4'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD04 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD05 <> DDCD05                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD05'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 5'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 5'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 5'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 5'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD05 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD06 <> DDCD06                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD06'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 6'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 6'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 6'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 6'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD06 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD07 <> DDCD07                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD07'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 7'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 7'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 7'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 7'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD07 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD08 <> DDCD08                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD08'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 8'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 8'             CSE031 MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 8'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 8'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD08 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD09 <> DDCD09                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD09'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 9'        CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 9'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 9'              CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 9'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD09 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD10 <> DDCD10                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD10'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 10'       CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 10'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 10'             CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 10'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD10 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD11 <> DDCD11                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD11'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 11'       CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 11'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 11'             CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 11'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD11 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        ADDCD12 <> DDCD12                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDCD12'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0518'                                 CSE031
     C                   IF        *IN67                                                      CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Dividend Payment Date 12'       CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Dividend Payment Date 12'                   MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ELSE                                                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Coupon/Rate Day 12'             CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Coupon/Rate Day 12'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF                                                                CSE031
     C                   EVAL      OKCD12 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      *
      ** Maturity Date 1 is not amendable.
      *
     C                   IF        (*IN80  = *OFF AND *IN94 AND
     C                             *IN85 = *OFF) OR (*IN80 AND *IN94 AND
     C                             *IN86 AND *IN85 = *OFF) OR
     C                             (*IN87 AND *IN85) OR *IN68 = *OFF
     C                   IF        ADDMATY1 <> DDMATY1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMATY1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Maturity Date'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Maturity Date'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMATY1 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Maturity Date Ind. 1 is not amendable.
      *
     C                   IF        (*IN94 AND *IN86) OR
     C                             *IN80 = *OFF OR *IN68 = *OFF
     C                   IF        ADDMDTI1 <> DDMDTI1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDMDTI1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Maturity Date Ind.'                    MD000091
     C                   EVAL      MsgDtaTmp = 'Maturity Date Ind.'                         MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKMDTI1 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Day Basis 1 is not amendable.
      *
     C                   IF        (*IN69 AND *IN85 = *OFF) OR *IN68 = *OFF
     C                   IF        ADDDYBS1 <> DDDYBS1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDYBS1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Day Basis'                             MD000091
     C                   EVAL      MsgDtaTmp = 'Day Basis'                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDYBS1 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Divisor Basis is not amendable.
      *
     C                   IF        (*IN69 AND *IN85 = *OFF) OR *IN68 = *OFF
     C                   IF        ADDDVBS1 <> DDDVBS1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDVBS1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Divisor Basis'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Divisor Basis'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDVBS1 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Contingent Liab. Ind. is not amendable.
      *
     C                   IF        *IN89 OR *IN68 = *OFF OR *IN94
     C                   IF        ADDCNLI1 <> DDCNLI1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCNLI1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Contingent Liab. Ind.'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Contingent Liab. Ind.'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCNLI1 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Initial Payment is not amendable.
      *
     C                   IF        *IN93 = *OFF OR *IN69
     C*****              IF        ADDSINP <> DDSINP                                          CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      ADDSINP       ZCMPAMT1         25                          CAP084
     C                   PARM      DDSINP        ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSINP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Initial Payment'                       MD000091
     C                   EVAL      MsgDtaTmp = 'Initial Payment'                            MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSINP = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Fully Paid Price is not amendable.
      *
     C                   IF        *IN93 = *OFF OR *IN69
     C*****              IF        ADDSFPP <> DDSFPP                                          CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      ADDSFPP       ZCMPAMT1         25                          CAP084
     C                   PARM      DDSFPP        ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSFPP'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Fully Paid Price'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Fully Paid Price'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSFPP = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Risk Customer is not amendable.
      *
     C                   IF        *IN80 = *OFF
     C                   IF        ADDRSKC <> DDRSKC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDRSKC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Risk Customer'                         MD000091
     C                   EVAL      MsgDtaTmp = 'Risk Customer'                              MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKRSKC = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Drawer is not amendable.
      *
     C                   IF        *IN80 = *OFF
     C                   IF        ADDDRWR <> DDDRWR
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDRWR'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Drawer'                                MD000091
     C                   EVAL      MsgDtaTmp = 'Drawer'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDRWR = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Business Day Convention is not amendable.
      *
     C                   IF        *IN82 = *OFF
     C                   IF        ADDBCNV <> DDBCNV
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBCNV'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Business Day Convention'               MD000091
     C                   EVAL      MsgDtaTmp = 'Business Day Convention'                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKBCNV = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Issue Amount is not amendable.
      *
     C                   IF        *IN83 = *OFF AND ADDISA1 <> DDISA1
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDISA1'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Issue Amount'                          MD000091
     C                   EVAL      MsgDtaTmp = 'Issue Amount'                               MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKISA1 = 'N'
     C                   ENDIF
      *
      ** Convertible Ind. is not amendable.
      *
     C                   IF        *IN85 = *OFF
     C                   IF        ADDSCVI <> DDSCVI
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSCVI'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Convertible Ind.'                      MD000091
     C                   EVAL      MsgDtaTmp = 'Convertible Ind.'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSCVI = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Price Basis is not amendable.
      *
     C                   IF        ADDSPBS <> DDSPBS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSPBS'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Price Basis'                           MD000091
     C                   EVAL      MsgDtaTmp = 'Price Basis'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSPBS = 'N'
     C                   ENDIF
      *
      ** Yield Basis is not amendable.
      ** except for CSE032 validation change. Allow field entry or removal.                   205427
      *
     C                   IF        DDSYBS <> *BLANKS AND ADDSYBS <> *BLANKS                   205427
     C                   IF        ADDSYBS <> DDSYBS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSYBS'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Yield Basis'                           MD000091
     C                   EVAL      MsgDtaTmp = 'Yield Basis'                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKSYBS = 'N'
     C                   ENDIF
     C                   ENDIF                                                                205427
      *
      ** Compounding Frequency is not amendable.
      *
     C                   IF        *IN92 = *OFF AND ADDCMFQ <> DDCMFQ
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDCMFQ'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Compounding Frequency'                 MD000091
     C                   EVAL      MsgDtaTmp = 'Compounding Frequency'                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKCMFQ = 'N'
     C                   ENDIF
      *
      ** Discount Basis is not amendable.
      *
     C                   IF        *IN92 = *OFF AND ADDDSCB <> DDDSCB
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDSCB'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Discount Basis'                        MD000091
     C                   EVAL      MsgDtaTmp = 'Discount Basis'                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDSCB = 'N'
     C                   ENDIF
      *
      ** Discount Last Coupon is not amendable.
      *
     C                   IF        *IN92 = *OFF AND ADDDSLC <> DDDSLC
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDDSLC'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C**********         EVAL      MsgDtaArr(IDx) = 'Discount Last Coupon'                  MD000091
     C                   EVAL      MsgDtaTmp = 'Discount Last Coupon'                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKDSLC = 'N'
     C                   ENDIF
                                                                                              CSE031
      *                                                                                       CSE031
      ** If CSE031 is on and processing type is 3 or 8.                                       CSE031
      *                                                                                       CSE031
     C                   IF        *IN20 = *ON                                                CSE031
     C                   IF        ADDBCNV = 'N'                                              CSE031
      *                                                                                       CSE031
      ** Last Coupon Date.                                                                    CSE031
     C                   IF        ADDLCPN <> DDLCPN                                          CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDLCPN'                                 CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0517'                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Last Coupon Date'               CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Last Coupon Date'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKLCPN = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        ADDBCNV = DDBCNV                                           CSE031
      *                                                                                       CSE031
      ** Next Coupon Date.                                                                    CSE031
     C                   IF        ADDNCD <> DDNCD                                            CSE031
     C                   EVAL      IDx = IDx + 1                                              CSE031
     C                   EVAL      FldNameArr(IDx) = 'DDNCD'                                  CSE031
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0517'                                 CSE031
     C**********         EVAL      MsgDtaArr(IDx) = 'Next Coupon Date'               CSE031 MD000091
     C                   EVAL      MsgDtaTmp = 'Next Coupon Date'                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      OKNCD = 'N'                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAmt - Align amount                                        *
      *                                                               *
      *****************************************************************
 
     C     SRZAmt        BEGSR
 
     C                   Z-ADD     11            ZADIG
     C                   Z-ADD     7             ZADEC
 
     C                   CALL      'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInds - Set conditioning indicators                      *
      *                                                               *
      *****************************************************************
     C     SRSetInds     BEGSR
      *
      ** Reset work indicators.
      *
     C                   MOVEA     '0000'        *IN(66)
     C                   MOVEA     '0000000000'  *IN(80)
     C                   MOVEA     '01000'       *IN(90)
     C                   MOVEL     'N'           PPrCpn
 
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7') OR
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND
     C                             PPROT <> '4' AND PPROT <> '7' AND
     C                             PPROT <> '9')
     C                   EVAL      *IN66 = *ON
     C                   ENDIF
 
     C                   IF        PPROT = '4' OR PPROT = '7'
     C                   EVAL      *IN67 = *ON
     C                   ENDIF
 
     C                   IF        S1STBS = 'D' OR
     C                             (S1STBS = 'Y' AND PPROT = '9')
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
 
     C                   IF        INCS = 'C'
     C                   EVAL      *IN69 = *ON
     C                   ENDIF
 
     C                   IF        PPROT = '9'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
 
     C                   IF        BGRKMG = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   IF        S1ERPY = 'Y'
     C                   EVAL      *IN83 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PPROT = '3' OR PPROT = '5' OR
     C                             PPROT = '8'
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
 
     C                   IF        CSE007 = 'Y' OR CEU017 = 'Y'
     C                   EVAL      *IN85 = *ON
     C                   ENDIF
 
     C                   IF        S1INCS = 'C' AND MDTI = 'F'
     C                   EVAL      *IN86 = *ON
     C                   ENDIF
 
     C                   IF        *IN85 = *OFF
     C                   IF        INCS = 'C' AND MATY <> 99999 AND
     C                             PPROT <> '9'
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
     C                   ELSE
     C                   IF        S1STBS <> 'P'
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PPROT = '2' OR PPROT = '4' OR
     C                             PPROT = '7'
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
 
     C**********         IF        PPROT = '3' AND CSE005 = 'Y'                               CSE031
     C                   IF        PPROT = '3' AND CSE005 = 'Y' OR                            CSE031
     C                             PPROT = '8' AND CSE005 = 'Y' AND                           CSE031
     C                             CSE031 = 'Y'                                               CSE031
     C                             OR CSE071 = 'Y' AND (PPROT = '1' OR                        CSE071
     C                             PPROT = '3' OR PPROT = '5' OR PPROT = '6' OR               CSE071
     C                             PPROT = '8' OR PPROT = '9')                                CSE071
     C                   EVAL      *IN82 = *ON
     C     SECKEY        CHAIN     SNDEVDF                            91
     C                   ENDIF
 
     C                   IF        DDSYBS = 'AU'
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
     C                   IF        S1PPDI = 'Y'
     C                   EVAL      *IN93 = *ON
     C                   ENDIF
 
     C                   IF        *IN68 AND *IN69
     C                   EVAL      *IN94 = *ON
     C                   ENDIF
 
     C                   IF        CSE031 = 'Y'                                               CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
     C                   EVAL      *IN20 = *ON                                                CSE031
     C                   EVAL      *IN91 = *ON                                                CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   IF        CSE071 = 'Y'                                               CSE071
     C                   IF        PPROT = '1' OR PPROT = '3' OR PPROT = '5' OR               CSE071
     C                             PPROT = '6' OR PPROT = '8' OR PPROT = '9'                  CSE071
     C                   EVAL      *IN20 = *ON                                                CSE071
     C                   EVAL      *IN91 = *ON                                                CSE071
     C                   ENDIF                                                                CSE071
     C                   ENDIF                                                                CSE071
      *                                                                                       CSE071
     C                   IF        *IN91 = *OFF
     C                   MOVEL     'Y'           PPrCpn
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
     C     SRResetFlds   BEGSR
      *
      ** Coupon Rate.
      *
     C                   IF        OKCPNR = 'N'
     C                   EVAL      ADDCPNR = DDCPNR
     C                   ENDIF
      *
      ** Base Rate Code.
      *
     C                   IF        OKBASC = 'N'
     C                   EVAL      ADDBASC = DDBASC
     C                   ENDIF
      *
      ** Initial Dividend Date.
      *
     C                   IF        OKIDIV = 'N'
     C                   EVAL      ADDIDIV = DDIDIV
     C                   ENDIF
      *
      ** Base Rate/Spread.
      *
     C                   IF        OKBASS = 'N'
     C                   EVAL      ADDBASS = DDBASS
     C                   ENDIF
      *
      ** Next Expected Dividend.
      *
     C                   IF        OKNEXD = 'N'
     C                   EVAL      ADDNEXD = DDNEXD
     C                   ENDIF
      *
      ** Spread Indicator.
      *
     C                   IF        OKSPRI = 'N'
     C                   EVAL      ADDSPRI = DDSPRI
     C                   ENDIF
      *
      ** Roll Fwd Dividend.
      *
     C                   IF        OKRFDI = 'N'
     C                   EVAL      ADDRFDI = DDRFDI
     C                   ENDIF
      *
      ** Minimum Coupon.
      *
     C                   IF        OKMCPN = 'N'
     C                   EVAL      ADDMCPN = DDMCPN
     C                   ENDIF
      *
      ** Maturity Date 2.
      *
     C                   IF        OKMATY2 = 'N'
     C                   EVAL      ADDMATY2 = DDMATY2
     C                   ENDIF
      *
      ** Maturity Date Indicator 2.
      *
     C                   IF        OKMDTI2 = 'N'
     C                   EVAL      ADDMDTI2 = DDMDTI2
     C                   ENDIF
      *
      ** Longterm Maturity Indicator.
      *
     C                   IF        OKLTMI = 'N'
     C                   EVAL      ADDLTMI = DDLTMI
     C                   ENDIF
      *
      ** Day Basis 2.
      *
     C                   IF        OKDYBS2 = 'N'
     C                   EVAL      ADDDYBS2 = DDDYBS2
     C                   ENDIF
      *
      ** Divisor Basis 2.
      *
     C                   IF        OKDVBS2 = 'N'
     C                   EVAL      ADDDVBS2 = DDDVBS2
     C                   ENDIF
      *
      ** Day Basis 1.
      *
     C                   IF        OKDYBS1 = 'N'
     C                   EVAL      ADDDYBS1 = DDDYBS1
     C                   ENDIF
      *
      ** Maturity Date 1.
      *
     C                   IF        OKMATY1 = 'N'
     C                   EVAL      ADDMATY1 = DDMATY1
     C                   ENDIF
      *
      ** Maturity Date Indicator 1.
      *
     C                   IF        OKMDTI1 = 'N'
     C                   EVAL      ADDMDTI1 = DDMDTI1
     C                   ENDIF
      *
      ** Interest Adj.
      *
     C                   IF        OKIADJ = 'N'
     C                   EVAL      ADDIADJ = DDIADJ
     C                   ENDIF
      *
      ** Divisor Basis 1.
      *
     C                   IF        OKDVBS1 = 'N'
     C                   EVAL      ADDDVBS1 = DDDVBS1
     C                   ENDIF
      *
      ** Contingent Liability Ind. 2.
      *
     C                   IF        OKCNLI2 = 'N'
     C                   EVAL      ADDCNLI2 = DDCNLI2
     C                   ENDIF
      *
      ** Contingent Liability Ind. 1.
      *
     C                   IF        OKCNLI1 = 'N'
     C                   EVAL      ADDCNLI1 = DDCNLI1
     C                   ENDIF
      *
      ** Initial Date.
      *
     C                   IF        OKITLD = 'N'
     C                   EVAL      ADDITLD = DDITLD
     C                   ENDIF
      *
      ** First Coupon.
      *
     C                   IF        OKFCPN = 'N'
     C                   EVAL      ADDFCPN = DDFCPN
     C                   ENDIF
      *
      ** Initial Payment.
      *
     C                   IF        OKSINP = 'N'
     C                   EVAL      ADDSINP = DDSINP
     C                   ENDIF
      *
      ** Fully Paid Price.
      *
     C                   IF        OKSFPP = 'N'
     C                   EVAL      ADDSFPP = DDSFPP
     C                   ENDIF
      *
      ** Risk Customer.
      *
     C                   IF        OKRSKC = 'N'
     C                   EVAL      ADDRSKC = DDRSKC
     C                   ENDIF
      *
      ** Drawer.
      *
     C                   IF        OKDRWR = 'N'
     C                   EVAL      ADDDRWR = DDDRWR
     C                   ENDIF
      *
      ** Business Day Convention.
      *
     C                   IF        OKBCNV = 'N'
     C                   EVAL      ADDBCNV = DDBCNV
     C                   ENDIF
      *
      ** Coupon Rate Days.
      *
     C                   IF        OKCD01 = 'N'
     C                   EVAL      ADDCD01 = DDCD01
     C                   ENDIF
     C                   IF        OKCD02 = 'N'
     C                   EVAL      ADDCD02 = DDCD02
     C                   ENDIF
     C                   IF        OKCD03 = 'N'
     C                   EVAL      ADDCD03 = DDCD03
     C                   ENDIF
     C                   IF        OKCD04 = 'N'
     C                   EVAL      ADDCD04 = DDCD04
     C                   ENDIF
     C                   IF        OKCD05 = 'N'
     C                   EVAL      ADDCD05 = DDCD05
     C                   ENDIF
     C                   IF        OKCD06 = 'N'
     C                   EVAL      ADDCD06 = DDCD06
     C                   ENDIF
     C                   IF        OKCD07 = 'N'
     C                   EVAL      ADDCD07 = DDCD07
     C                   ENDIF
     C                   IF        OKCD08 = 'N'
     C                   EVAL      ADDCD08 = DDCD08
     C                   ENDIF
     C                   IF        OKCD09 = 'N'
     C                   EVAL      ADDCD09 = DDCD09
     C                   ENDIF
     C                   IF        OKCD10 = 'N'
     C                   EVAL      ADDCD10 = DDCD10
     C                   ENDIF
     C                   IF        OKCD11 = 'N'
     C                   EVAL      ADDCD11 = DDCD11
     C                   ENDIF
     C                   IF        OKCD12 = 'N'
     C                   EVAL      ADDCD12 = DDCD12
     C                   ENDIF
      *
      ** Coupon/Rate Indicator.
      *
     C                   IF        OKCR01 = 'N'
     C                   EVAL      ADDCR01 = DDCR01
     C                   ENDIF
     C                   IF        OKCR02 = 'N'
     C                   EVAL      ADDCR02 = DDCR02
     C                   ENDIF
     C                   IF        OKCR03 = 'N'
     C                   EVAL      ADDCR03 = DDCR03
     C                   ENDIF
     C                   IF        OKCR04 = 'N'
     C                   EVAL      ADDCR04 = DDCR04
     C                   ENDIF
     C                   IF        OKCR05 = 'N'
     C                   EVAL      ADDCR05 = DDCR05
     C                   ENDIF
     C                   IF        OKCR06 = 'N'
     C                   EVAL      ADDCR06 = DDCR06
     C                   ENDIF
     C                   IF        OKCR07 = 'N'
     C                   EVAL      ADDCR07 = DDCR07
     C                   ENDIF
     C                   IF        OKCR08 = 'N'
     C                   EVAL      ADDCR08 = DDCR08
     C                   ENDIF
     C                   IF        OKCR09 = 'N'
     C                   EVAL      ADDCR09 = DDCR09
     C                   ENDIF
     C                   IF        OKCR10 = 'N'
     C                   EVAL      ADDCR10 = DDCR10
     C                   ENDIF
     C                   IF        OKCR11 = 'N'
     C                   EVAL      ADDCR11 = DDCR11
     C                   ENDIF
     C                   IF        OKCR12 = 'N'
     C                   EVAL      ADDCR12 = DDCR12
     C                   ENDIF
      *
      ** Rate Change Frequency.
      *
     C                   IF        OKRCFQ = 'N'
     C                   EVAL      ADDRCFQ = DDRCFQ
     C                   ENDIF
      *
      ** Next Change Date.
      *
     C                   IF        OKNCHD = 'N'
     C                   EVAL      ADDNCHD = DDNCHD
     C                   ENDIF
      *
      ** Issue Amount 1.
      *
     C                   IF        OKISA1 = 'N'
     C                   EVAL      ADDISA1 = DDISA1
     C                   ENDIF
      *
      ** Convertible Indicator.
      *
     C                   IF        OKSCVI = 'N'
     C                   EVAL      ADDSCVI = DDSCVI
     C                   ENDIF
      *
      ** Price Basis.
      *
     C                   IF        OKSPBS = 'N'
     C                   EVAL      ADDSPBS = DDSPBS
     C                   ENDIF
      *
      ** Yield Basis.
      *
     C                   IF        OKSYBS = 'N'
     C                   EVAL      ADDSYBS = DDSYBS
     C                   ENDIF
      *
      ** Compounding Frequency.
      *
     C                   IF        OKCMFQ = 'N'
     C                   EVAL      ADDCMFQ = DDCMFQ
     C                   ENDIF
      *
      ** Discount Basis.
      *
     C                   IF        OKDSCB = 'N'
     C                   EVAL      ADDDSCB = DDDSCB
     C                   ENDIF
      *
      ** Discount Last Coupon.
      *
     C                   IF        OKDSLC = 'N'
     C                   EVAL      ADDDSLC = DDDSLC
     C                   ENDIF
      *                                                                                       CSE031
      ** Last Coupon Date.                                                                    CSE031
      *                                                                                       CSE031
     C                   IF        OKLCPN = 'N'                                               CSE031
     C                   EVAL      ADDLCPN = DDLCPN                                           CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Next Coupon Date.                                                                    CSE031
      *                                                                                       CSE031
     C                   IF        OKNCD = 'N'                                                CSE031
     C                   EVAL      ADDNCD = DDNCD                                             CSE031
     C                   ENDIF                                                                CSE031
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Securities retrieved from file file format
     C                   PARM                    CrSEFilFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Investment processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Interest Risk Management
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Securities Screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Protect Coupon Rate/Inds Indicator
     C                   PARM                    PPrCpn
      *
      ** Key to access SNDEVD records
     C     SECKEY        KLIST
     C                   KFLD                    SESN
     C                   KFLD                    KSDET
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
      *
**  CPY@
(c) Finastra International Limited 2001
