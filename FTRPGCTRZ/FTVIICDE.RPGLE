     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP Instruction Code')                *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIICDE - Validate IP Instruction Code                      *
      *                                                               *
      *  Function:  This module validates the Instruction Code lines. *
      *             This is a component of FTIPAYCTL, FTIPAYRPR,      *
      *             FTIPAYSIN, and service program for level 2        *
      *             validation modules.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206             Date 03Jul06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *Create    Date 25May00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW206 - SWIFT 2006 Standard Changes                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - Swift 2001 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      /COPY FTCPYSRC,SFTVALCSLE

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Incoming Payments Lvl 2 Scrn 2 details
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)

      ** Incoming Payments Lvl 2 Scrn 2 file 2 details
     D NwIP4AScnFmt  E DS                  EXTNAME(FTIPY4APD)

      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D OKIPY3DS      E DS                  EXTNAME(FTEIPY3PD)

      ** Table of Instruction Codewords
     D*TABICD***       S              4    DIM(12) CTDATA PERRCD(1)                           CSW202
     D TABICD          S              4    DIM(13) CTDATA PERRCD(1)                           CSW202

      ** General-purpose Instruction Code array
     D WA1             S             35    DIM(5)
      *                                                                                       CSW201
      ** General-purpose Instruction Code array                                               CSW201
     D Codeword        S              4A   DIM(5)                                             CSW201
      *                                                                                       CSW201
      ** Array of Instruction codewords in correct order                                      CSW201
     D*WICOR****       S              4    DIM(12) CTDATA PERRCD(12)                   CSW201 CSW202
     D WICOR           S              4    DIM(13) CTDATA PERRCD(13)                          CSW202

     D                 DS
     D WICDDS                  1    175
     D  WICD1                  1     35
     D  WICD2                 36     70
     D  WICD3                 71    105
     D  WICD4                106    140
     D  WICD5                141    175

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error messages
     D Idx             S              3P 0

      ** General index variable
     D J               S              3P 0

      ** Switchable feature indicator                                                         CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** SWIFT 2002 Switchable Feature Indicator                                              CSW202
     D CSW202          S              1A                                                      CSW202
                                                                                              CSW202
      ** Return Code when calling SWIF2002                                                    CSW202
     D PRetrnCde       S              7A                                                      CSW202
                                                                                              CSW202
      ** SWIFT 2006 Switchable Feature Indicator                                              CSW206
     D CSW206          S              1A                                                      CSW206
                                                                                              CSW206
      ** Account with Bank field                                                              CSW201
     D*IPACBK***       S             12A                                               CSW201 CGL029
     D IPACBK          S             18A                                                      CGL029
                                                                                              CSW201
      ** Work Variables for Switchable feature CSW201                                         CSW201
     D WDuplicate      S              1A                                                      CSW201
     D WInvalidCombi   S              1A                                                      CSW201
     D X               S              1S 0                                                    CSW201
     D Y               S              1S 0                                                    CSW201
     D WIn             S              2P 0                                                    CSW201
     D WIz             S              2P 0                                                    CSW201
     D Wx              S              2P 0                                                    CSW201
     D Wj              S              2P 0                                                    CSW201
                                                                                              CSW201
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      Idx = 0
     C                   EVAL      ErrorFound = 'N'                                           CSW201
     C                   EVAL      WICD1 = DDICD1
     C                   EVAL      WICD2 = DDICD2
     C                   EVAL      WICD3 = DDICD3
     C                   EVAL      WICD4 = DDICD4
     C                   EVAL      WICD5 = DDICD5

     C                   EXSR      SRICDE

      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRICDE - Validation of Instruction Code.                     *
      *****************************************************************
     C     SRICDE        BEGSR

      *
      ** Entry is optional

     C                   IF        (WICDDS = *BLANKS)
     C                   EVAL      I2INICD1 = *BLANKS
     C                   EVAL      I2INICD2 = *BLANKS
     C                   EVAL      I2INICD3 = *BLANKS
     C                   EVAL      I2INICD4 = *BLANKS
     C                   EVAL      I2INICD5 = *BLANKS
     C                   GOTO      EXICDE
     C                   ENDIF

      *
      ** If Bank Operation Code is 'SSTD' or 'SPAY', entry is prohibited

     C                   IF        (DDBOCD = 'SSTD') OR (DDBOCD = 'SPAY')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5011'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKICD1 = 'N'
     C                   EVAL      OKICD2 = 'N'
     C                   EVAL      OKICD3 = 'N'
     C                   EVAL      OKICD4 = 'N'
     C                   EVAL      OKICD5 = 'N'
     C                   GOTO      EXICDE
     C                   ENDIF

      *
      ** There should be no blank line preceding a nonblank line among
      **   the Instruction Code lines

     C                   IF        (DDICD1 = *BLANK AND DDICD2 <> *BLANK)   OR
     C                             (DDICD2 = *BLANK AND DDICD3 <> *BLANK)   OR
     C                             (DDICD3 = *BLANK AND DDICD4 <> *BLANK)   OR
     C                             (DDICD4 = *BLANK AND DDICD5 <> *BLANK)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5012'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD1'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKICD1 = 'N'
     C                   EVAL      OKICD2 = 'N'
     C                   EVAL      OKICD3 = 'N'
     C                   EVAL      OKICD4 = 'N'
     C                   EVAL      OKICD5 = 'N'
     C                   GOTO      EXICDE
     C                   ENDIF

      *
      ** Validation that is done on each of the 5 Instruction Code
      **    fields
      *

     C                   MOVEA     *BLANKS       WA1
     C                   MOVEA     WICDDS        WA1
     C                   EVAL      J = 0
     C                   MOVEA     *BLANKS       Codeword                                     CSW201

     C                   DOW       (J < 5)

     C                   EVAL      J = J + 1

     C                   IF        (WA1(J) = *BLANKS)
     C                   LEAVE
     C                   ENDIF

     C                   MOVEL     WA1(J)        WCHR04            4
     C                   MOVE      WA1(J)        WCHR31           31
     C                   MOVEL     WCHR31        WCHR05TH          1
     C                   MOVE      WCHR31        WCHR30           30
     C                   MOVEL     WCHR04        Codeword(J)                                  CSW201
     C     WCHR04        LOOKUP    TABICD                                 40
      *
     C                   SELECT

      ** Check if positions 1-4 is a valid codeword.
                                                                                              CSW206
     C                   WHEN      WCHR04 = 'BONL' AND                                        CSW206
     C                             CSW206 = 'Y'                                               CSW206
     C                   EVAL      Idx = Idx + 1                                              CSW206
     C                   EVAL      MsgIdXAr = 'FTM5601'                                       CSW206
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                           CSW206 MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'                                           CSW206
     C                   EXSR      SROKFLG                                                    CSW206
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   WHEN      (*IN40 = *OFF)
     C                             OR (WCHR04 = 'REPA' AND CSW202 = 'N')                      CSW202
     C                   EVAL      Idx = Idx + 1
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr = 'FTM5500'                                       CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr = 'FTM5013'
     C                   ENDIF                                                                CSW202
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG

      ** When Bank Operation Code is 'SPRI', codeword should be
      ** 'SDVA', 'TELB', 'PHOB' or 'INTC'.
     C                   WHEN      (DDBOCD = 'SPRI') AND
     C                             (WCHR04 <> 'SDVA') AND
     C                             (WCHR04 <> 'TELB') AND
     C                             (WCHR04 <> 'PHOB') AND
     C                             (WCHR04 <> 'INTC')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5014'
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG

      ** Pos. 5-35 should not contain additional information
      ** when codeword is not PHON/PHOB/PHOI/TELE/TELB/TELI/HOLD.
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, additional                            CSW202
      ** information may also be entered if codeword 'REPA' is used.                          CSW202
                                                                                              CSW202
     C                   WHEN      (WCHR31 <> *BLANKS) AND
     C                             (WCHR04 <> 'PHON') AND
     C                             (WCHR04 <> 'PHOB') AND
     C                             (WCHR04 <> 'PHOI') AND
     C                             (WCHR04 <> 'TELE') AND
     C                             (WCHR04 <> 'TELB') AND
     C                             (WCHR04 <> 'TELI') AND
     C                             (WCHR04 <> 'HOLD')
     C                             AND (WCHR04 <> 'REPA')                                     CSW202
     C                   EVAL      Idx = Idx + 1
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr = 'FTM5501'                                       CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr = 'FTM5015'
     C                   ENDIF                                                                CSW202
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG

      ** Codeword must be followed by '/' if additional info is
      ** supplied in pos. 6-35.
     C                   WHEN      (WCHR31 <> *BLANKS) AND
     C                             (WCHR05TH <> '/')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5016'
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG

      ** Additional info must be supplied in pos. 6-35 when '/' has
      ** been entered after the codeword.
     C                   WHEN      (WCHR05TH = '/') AND
     C                             (WCHR30 = *BLANKS)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5029'
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG

      ** Additional info in pos. 6-35 should be valid SWIFT characters.
     C                   WHEN      (WCHR30 <> *BLANKS)
     C                   MOVEL     *BLANKS       FLD              35
     C                   MOVEL     WCHR30        FLD
     C                   EXSR      SWSET
     C                   IF        (*IN99 = *ON)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5030'
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EXSR      SROKFLG
     C                   ENDIF
      *                                                                                       CSW201
      ** If CSW201 = 'Y', and Intermediary Bank is not entered, codewords                     CSW201
      ** TELI and PHOI are prohibited                                                         CSW201
     C                   WHEN      (CSW201 = 'Y'  AND                                         CSW201
     C                             DDINB1 = *BLANKS AND                                       CSW201
     C                             DDINB2 = *BLANKS AND                                       CSW201
     C                             DDINB3 = *BLANKS AND                                       CSW201
     C                             DDINB4 = *BLANKS AND                                       CSW201
     C                             DDINB5 = *BLANKS AND                                       CSW201
     C                             WCHR04 = 'TELI')                                           CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   EXSR      SROKFLG                                                    CSW201
      *                                                                                       CSW201
     C                   WHEN      (CSW201 = 'Y'  AND                                         CSW201
     C                             DDINB1 = *BLANKS AND                                       CSW201
     C                             DDINB2 = *BLANKS AND                                       CSW201
     C                             DDINB3 = *BLANKS AND                                       CSW201
     C                             DDINB4 = *BLANKS AND                                       CSW201
     C                             DDINB5 = *BLANKS AND                                       CSW201
     C                             WCHR04 = 'PHOI')                                           CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   EXSR      SROKFLG                                                    CSW201
      ** If CSW201 = 'Y', and Account with Bank is not entered, codewords                     CSW201
      ** TELE and PHON are prohibited                                                         CSW201
     C                   WHEN      (CSW201 = 'Y'  AND                                         CSW201
     C                             IPACBK = *BLANKS AND                                       CSW201
     C                             WCHR04 = 'TELE')                                           CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   EXSR      SROKFLG                                                    CSW201
      *                                                                                       CSW201
     C                   WHEN      (CSW201 = 'Y'  AND                                         CSW201
     C                             IPACBK = *BLANKS AND                                       CSW201
     C                             WCHR04 = 'PHON')                                           CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WCHR04                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR04))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR04)                   MD000091
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   EXSR      SROKFLG                                                    CSW201
      *
     C                   ENDSL

     C                   ENDDO
                                                                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      X = 5                                                      CSW201
     C                   EVAL      WDuplicate = 'N'                                           CSW201
     C                   EVAL      WInvalidCombi = 'N'                                        CSW201
     C                   DOW       (X > 1 AND                                                 CSW201
     C                             WDuplicate = 'N' AND                                       CSW201
     C                             WInvalidCombi = 'N')                                       CSW201
     C                   IF        (Codeword(X) <> *BLANKS)                                   CSW201
     C                   EVAL      Y = X - 1                                                  CSW201
     C                   DOW       (Y >= 1 AND                                                CSW201
     C                             WDuplicate = 'N' AND                                       CSW201
     C                             WInvalidCombi = 'N')                                       CSW201
     C                   IF        (Codeword(X) = Codeword(Y))                                CSW201
     C                   EVAL      WDuplicate = 'Y'                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   IF        (Codeword(X)='SDVA' AND Codeword(Y)='HOLD' OR              CSW201
     C                              Codeword(X)='SDVA' AND Codeword(Y)='CHQB' OR              CSW201
     C                              Codeword(X)='INTC' AND Codeword(Y)='BONL' OR              CSW201
     C                              Codeword(X)='INTC' AND Codeword(Y)='HOLD' OR              CSW201
     C                              Codeword(X)='INTC' AND Codeword(Y)='CHQB' OR              CSW201
     C                              Codeword(X)='CORT' AND Codeword(Y)='BONL' OR              CSW201
     C                              Codeword(X)='CORT' AND Codeword(Y)='HOLD' OR              CSW201
     C                              Codeword(X)='CORT' AND Codeword(Y)='CHQB' OR              CSW201
     C                              Codeword(X)='HOLD' AND Codeword(Y)='CHQB' OR              CSW201
     C                              Codeword(X)='PHOB' AND Codeword(Y)='TELB' OR              CSW201
     C                              Codeword(X)='PHON' AND Codeword(Y)='TELE' OR              CSW201
     C                              Codeword(X)='PHOI' AND Codeword(Y)='TELI' OR              CSW201
     C                              (CSW202 = 'Y' AND ((Codeword(X) = 'REPA'                  CSW202
     C                              AND Codeword(Y)='HOLD')OR(Codeword(X)='REPA'              CSW202
     C                              AND Codeword(Y)='CHQB')OR(Codeword(X)='REPA'              CSW202
     C                              AND Codeword(Y)='BONL')OR(Codeword(X)='REPA'              CSW202
     C                              AND Codeword(Y)='CORT'))) OR                              CSW202
     C                              Codeword(Y)='SDVA' AND Codeword(X)='HOLD' OR              CSW201
     C                              Codeword(Y)='SDVA' AND Codeword(X)='CHQB' OR              CSW201
     C                              Codeword(Y)='INTC' AND Codeword(X)='BONL' OR              CSW201
     C                              Codeword(Y)='INTC' AND Codeword(X)='HOLD' OR              CSW201
     C                              Codeword(Y)='INTC' AND Codeword(X)='CHQB' OR              CSW201
     C                              Codeword(Y)='CORT' AND Codeword(X)='BONL' OR              CSW201
     C                              Codeword(Y)='CORT' AND Codeword(X)='HOLD' OR              CSW201
     C                              Codeword(Y)='CORT' AND Codeword(X)='CHQB' OR              CSW201
     C                              Codeword(Y)='HOLD' AND Codeword(X)='CHQB' OR              CSW201
     C                              Codeword(Y)='PHOB' AND Codeword(X)='TELB' OR              CSW201
     C                              Codeword(Y)='PHON' AND Codeword(X)='TELE' OR              CSW201
     C                              Codeword(Y)='PHOI' AND Codeword(X)='TELI')                CSW201
     C                              OR (CSW202 = 'Y' AND ((Codeword(Y)= 'REPA'                CSW202
     C                              AND Codeword(X)='HOLD')OR(Codeword(Y)='REPA'              CSW202
     C                              AND Codeword(X)='CHQB')OR(Codeword(Y)='REPA'              CSW202
     C                              AND Codeword(X)='BONL')OR(Codeword(Y)='REPA'              CSW202
     C                              AND Codeword(X)='CORT')))                                 CSW202
     C                   EVAL      WInvalidCombi = 'Y'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      Y = Y - 1                                                  CSW201
     C                   ENDDO                                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      X = X - 1                                                  CSW201
     C                   ENDDO                                                                CSW201
      *                                                                                       CSW201
      ** If CSW021 = 'Y', and there is more than one instruction code entered                 CSW201
      ** no same codeword must be used more than once                                         CSW201
     C                   IF        (WDuplicate = 'Y' OR                                       CSW201
     C                              WInvalidCombi = 'Y')                                      CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   IF        WDuplicate = 'Y'                                           CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5048'                                  CSW201
     C                   ENDIF                                                                CSW201
     C                   IF        WInvalidCombi = 'Y'                                        CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5504'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5049'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   ENDIF                                                                CSW201
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   EVAL      Y = J                                                      CSW201
     C                   EVAL      J = X + 1                                                  CSW201
     C                   EXSR      SROKFLG                                                    CSW201
     C                   EVAL      J = Y                                                      CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If there are no more errors, and there is more than 1 instruction code               CSW201
      ** entered, then check order of sequence.                                               CSW201
      *                                                                                       CSW201
     C                   Z-ADD     1             Wj                                           CSW201
     C     *BLANK        LOOKUP    Codeword(Wj)                           01                  CSW201
     C                   IF        *IN01                                                      CSW201
     C                   EVAL      Wj = Wj - 1                                                CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      Wj = 5                                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND ErrorFound = 'N' AND                      CSW201
     C                             Wj > 1                                                     CSW201
     C                   Z-ADD     1             WIn                                          CSW201
                                                                                              CSW201
     C                   DOW       WIn < Wj                                                   CSW201
                                                                                              CSW201
     C                   Z-ADD     1             Wx                                           CSW201
     C     Codeword(WIn) LOOKUP    WICOR(Wx)                              01                  CSW201
     C                   EVAL      WIz = WIn + 1                                              CSW201
                                                                                              CSW201
     C                   IF        *IN01 AND WIz <= (Wj + 1)                                  CSW201
     C     Codeword(WIz) LOOKUP    WICOR(Wx)                              01                  CSW201
                                                                                              CSW201
     C                   IF        *IN01 = *OFF                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5503'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5210'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   EVAL      FldNamXAr(Idx) = 'DDICD1'                                  CSW201
     C                   EVAL      OKICD1 = 'N'                                               CSW201
     C                   EVAL      OKICD2 = 'N'                                               CSW201
     C                   EVAL      OKICD3 = 'N'                                               CSW201
     C                   EVAL      OKICD4 = 'N'                                               CSW201
     C                   EVAL      OKICD5 = 'N'                                               CSW201
     C                   EVAL      ErrorFound = 'Y'                                           CSW201
     C                   LEAVE                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      WIn = WIn + 1                                              CSW201
                                                                                              CSW201
     C                   ENDDO                                                                CSW201
     C                   ENDIF                                                                CSW201

     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INICD1 = DDICD1
     C                   EVAL      I2INICD2 = DDICD2
     C                   EVAL      I2INICD3 = DDICD3
     C                   EVAL      I2INICD4 = DDICD4
     C                   EVAL      I2INICD5 = DDICD5
     C                   ENDIF

     C     EXICDE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROKFLG - Sets off the appropriate OK flag.                  *
      *****************************************************************
     C     SROKFLG       BEGSR

     C                   SELECT
     C                   WHEN      (J = 1)
     C                   EVAL      OKICD1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD1'
     C                   WHEN      (J = 2)
     C                   EVAL      OKICD2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD2'
     C                   WHEN      (J = 3)
     C                   EVAL      OKICD3 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD3'
     C                   WHEN      (J = 4)
     C                   EVAL      OKICD4 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD4'
     C                   WHEN      (J = 5)
     C                   EVAL      OKICD5 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'DDICD5'
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** O: Return Code
     C                   PARM                    ReturnCode
      *
      ***********
      ** INPUT **
      ***********
      *
      ** Incoming Payments Lvl 2 Scrn 2 details
     C                   PARM                    NwIP4ScnFmt
      ** Incoming Payments Lvl 2 Scrn 2 file 2 details
     C                   PARM                    NwIP4AScnFmt
      ** Swift 2001 Standards Update switchable feature indicator                             CSW201
     C                   PARM                    CSW201                                       CSW201
      ** Account with Bank field                                                              CSW201
     C                   PARM                    IPACBK                                       CSW201
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 2 Error indicators
     C                   PARM                    OKIPY3DS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

                                                                                              CSW202
      ** Check if switchable feature CSW202 is switched on                                    CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRetrnCde                                    CSW202
                                                                                              CSW202
     C                   IF        PRetrnCde = 'CSW2002'                                      CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW206
      ** Check if switchable feature CSW206 is switched on                                    CSW206
                                                                                              CSW206
     C                   CALL      'SWIF2006'                                                 CSW206
     C                   PARM      *BLANKS       PRetrnCde                                    CSW206
                                                                                              CSW206
     C                   IF        PRetrnCde = 'CSW2006'                                      CSW206
     C                   EVAL      CSW206 = 'Y'                                               CSW206
     C                   ELSE                                                                 CSW206
     C                   EVAL      CSW206 = 'N'                                               CSW206
     C                   ENDIF                                                                CSW206
      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
     C/COPY FTCPYSRC,SFTADDRSC1
      /EJECT
      *****************************************************************
                                                                                              CSW202
      ** WICOR was amended to insert codeword REPA before CORT.                               CSW202
                                                                                              CSW202
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  TABICD
BONL
CHQB
CORT
HOLD
INTC
PHON
PHOB
PHOI
SDVA
TELE
TELB
TELI
REPA                                                                                          CSW202
**  WICOR                                                                                     CSW201
SDVAINTCREPACORTBONLHOLDCHQBPHOBTELBPHONTELEPHOITELI                                   CSW201 CSW202
