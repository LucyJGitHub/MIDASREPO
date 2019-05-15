     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities amend checking for screen 4')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS4MD - Securities Amend Checking for Screen 4           *
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
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 14Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
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
      ** Securities Screen 4 details from incoming transaction
      ** - screen format
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
     D                                     PREFIX(A)
      *
      ** Securities Screen 4 details retrieved from file
      ** - screen format
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities Screen 4 error indicators
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
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
     D CSE031          S              1A
     D PPROT           S              1A
 
     D WAmt1           S             15A
     D WAAmt2          S             15A
      *
      ** Parameters for module ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
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
      *
     C                   IF        *IN20 = *OFF
      *
      ** Applicable Date 1 not amendable.
      *
     C                   IF        ADDAD01 <> DDAD01
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 1'
     C                   EVAL      OKAD01 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 1 not amendable.
      *
     C                   IF        ADDBR01 <> DDBR01
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 1'
     C                   EVAL      OKBR01 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 1 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS01        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS01       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 1'
     C                   EVAL      OKBS01 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 1 not amendable.
      *
     C                   IF        ADDSI01 <> DDSI01
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI01'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 1'
     C                   EVAL      OKSI01 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 2 not amendable.
      *
     C                   IF        ADDAD02 <> DDAD02
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 2'
     C                   EVAL      OKAD02 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 2 not amendable.
      *
     C                   IF        ADDBR02 <> DDBR02
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 2'
     C                   EVAL      OKBR02 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 2 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS02        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS02       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 2'
     C                   EVAL      OKBS02 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 2 not amendable.
      *
     C                   IF        ADDSI02 <> DDSI02
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI02'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 2'
     C                   EVAL      OKSI02 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 3 not amendable.
      *
     C                   IF        ADDAD03 <> DDAD03
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 3'
     C                   EVAL      OKAD03 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 3 not amendable.
      *
     C                   IF        ADDBR03 <> DDBR03
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 3'
     C                   EVAL      OKBR03 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 3 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS03        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS03       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 3'
     C                   EVAL      OKBS03 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 3 not amendable.
      *
     C                   IF        ADDSI03 <> DDSI03
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI03'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 3'
     C                   EVAL      OKSI03 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 4 not amendable.
      *
     C                   IF        ADDAD04 <> DDAD04
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 4'
     C                   EVAL      OKAD04 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 4 not amendable.
      *
     C                   IF        ADDBR04 <> DDBR04
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 4'
     C                   EVAL      OKBR04 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 4 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS04        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS04       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 4'
     C                   EVAL      OKBS04 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 4 not amendable.
      *
     C                   IF        ADDSI04 <> DDSI04
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI04'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 4'
     C                   EVAL      OKSI04 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 5 not amendable.
      *
     C                   IF        ADDAD05 <> DDAD05
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 5'
     C                   EVAL      OKAD05 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 5 not amendable.
      *
     C                   IF        ADDBR05 <> DDBR05
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 5'
     C                   EVAL      OKBR05 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 5 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS05        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS05       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 5'
     C                   EVAL      OKBS05 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 5 not amendable.
      *
     C                   IF        ADDSI05 <> DDSI05
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI05'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 5'
     C                   EVAL      OKSI05 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 6 not amendable.
      *
     C                   IF        ADDAD06 <> DDAD06
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 6'
     C                   EVAL      OKAD06 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 6 not amendable.
      *
     C                   IF        ADDBR06 <> DDBR06
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 6'
     C                   EVAL      OKBR06 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 6 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS06        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS06       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 6'
     C                   EVAL      OKBS06 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 6 not amendable.
      *
     C                   IF        ADDSI06 <> DDSI06
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI06'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 6'
     C                   EVAL      OKSI06 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 7 not amendable.
      *
     C                   IF        ADDAD07 <> DDAD07
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 7'
     C                   EVAL      OKAD07 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 7 not amendable.
      *
     C                   IF        ADDBR07 <> DDBR07
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 7'
     C                   EVAL      OKBR07 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 7 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS07        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS07       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 7'
     C                   EVAL      OKBS07 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 7 not amendable.
      *
     C                   IF        ADDSI07 <> DDSI07
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI07'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 7'
     C                   EVAL      OKSI07 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 8 not amendable.
      *
     C                   IF        ADDAD08 <> DDAD08
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 8'
     C                   EVAL      OKAD08 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 8 not amendable.
      *
     C                   IF        ADDBR08 <> DDBR08
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 8'
     C                   EVAL      OKBR08 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 8 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS08        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS08       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 8'
     C                   EVAL      OKBS08 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 8 not amendable.
      *
     C                   IF        ADDSI08 <> DDSI08
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI08'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 8'
     C                   EVAL      OKSI08 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 9 not amendable.
      *
     C                   IF        ADDAD09 <> DDAD09
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 9'
     C                   EVAL      OKAD09 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 9 not amendable.
      *
     C                   IF        ADDBR09 <> DDBR09
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 9'
     C                   EVAL      OKBR08 = '9'
     C                   ENDIF
      *
      ** Spread Rate 9 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS09        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS09       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 9'
     C                   EVAL      OKBS09 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 9 not amendable.
      *
     C                   IF        ADDSI09 <> DDSI09
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI09'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 9'
     C                   EVAL      OKSI09 = 'N'
     C                   ENDIF
      *
      *
      ** Applicable Date 10 not amendable.
      *
     C                   IF        ADDAD10 <> DDAD10
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDAD10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Applicable Date 10'
     C                   EVAL      OKAD10 = 'N'
     C                   ENDIF
      *
      ** Base Rate Code 10 not amendable.
      *
     C                   IF        ADDBR10 <> DDBR10
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBR10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Base Rate Code 10'
     C                   EVAL      OKBR10 = 'N'
     C                   ENDIF
      *
      ** Spread Rate 10 not amendable.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDBS10        ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAMT1
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     ADDBS10       ZFIELD
     C                   EXSR      SRZAmt
     C                   MOVE      ZFIELD        WAAMT2
 
     C                   IF        WAMT1 <> WAAMT2
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDBS10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 10'
     C                   EVAL      OKBS10 = 'N'
     C                   ENDIF
      *
      ** Spread Indicator 10 not amendable.
      *
     C                   IF        ADDSI10 <> DDSI10
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNameArr(IDx) = 'DDSI10'
     C                   EVAL      MsgIdArr(IDx)  = 'SEA0249'
     C                   EVAL      MsgDtaArr(IDx) = 'Spread Rate 10'
     C                   EVAL      OKSI10 = 'N'
     C                   ENDIF
      *
      *
     C                   ENDIF
 
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
     C                   IF        CSE031 = 'Y'
     C                   IF        PPROT = '3' OR PPROT = '8'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
     C                   ENDIF
      *
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
      ** Applicable Date 1
      *
     C                   IF        OKAD01 = 'N'
     C                   EVAL      ADDAD01 = DDAD01
     C                   ENDIF
      *
      ** Base Rate Code 1
      *
     C                   IF        OKBR01 = 'N'
     C                   EVAL      ADDBR01 = DDBR01
     C                   ENDIF
      *
      ** Spread Rate 1
      *
     C                   IF        OKBS01 = 'N'
     C                   EVAL      ADDBS01 = DDBS01
     C                   ENDIF
      *
      ** Spread Indicator 1
      *
     C                   IF        OKSI01 = 'N'
     C                   EVAL      ADDSI01 = DDSI01
     C                   ENDIF
      *
      ** Applicable Date 2
      *
     C                   IF        OKAD02 = 'N'
     C                   EVAL      ADDAD02 = DDAD02
     C                   ENDIF
      *
      ** Base Rate Code 2
      *
     C                   IF        OKBR02 = 'N'
     C                   EVAL      ADDBR02 = DDBR02
     C                   ENDIF
      *
      ** Spread Rate 2
      *
     C                   IF        OKBS02 = 'N'
     C                   EVAL      ADDBS02 = DDBS02
     C                   ENDIF
      *
      ** Spread Indicator 2
      *
     C                   IF        OKSI02 = 'N'
     C                   EVAL      ADDSI02 = DDSI02
     C                   ENDIF
      *
      *
      ** Applicable Date 3
      *
     C                   IF        OKAD03 = 'N'
     C                   EVAL      ADDAD03 = DDAD03
     C                   ENDIF
      *
      ** Base Rate Code 3
      *
     C                   IF        OKBR03 = 'N'
     C                   EVAL      ADDBR03 = DDBR03
     C                   ENDIF
      *
      ** Spread Rate 3
      *
     C                   IF        OKBS03 = 'N'
     C                   EVAL      ADDBS03 = DDBS03
     C                   ENDIF
      *
      ** Spread Indicator 3
      *
     C                   IF        OKSI03 = 'N'
     C                   EVAL      ADDSI03 = DDSI03
     C                   ENDIF
      *
      ** Applicable Date 4
      *
     C                   IF        OKAD04 = 'N'
     C                   EVAL      ADDAD04 = DDAD04
     C                   ENDIF
      *
      ** Base Rate Code 4
      *
     C                   IF        OKBR04 = 'N'
     C                   EVAL      ADDBR04 = DDBR04
     C                   ENDIF
      *
      ** Spread Rate 4
      *
     C                   IF        OKBS04 = 'N'
     C                   EVAL      ADDBS04 = DDBS04
     C                   ENDIF
      *
      ** Spread Indicator 4
      *
     C                   IF        OKSI04 = 'N'
     C                   EVAL      ADDSI04 = DDSI04
     C                   ENDIF
      *
      *
      ** Applicable Date 5
      *
     C                   IF        OKAD05 = 'N'
     C                   EVAL      ADDAD05 = DDAD05
     C                   ENDIF
      *
      ** Base Rate Code 5
      *
     C                   IF        OKBR05 = 'N'
     C                   EVAL      ADDBR05 = DDBR05
     C                   ENDIF
      *
      ** Spread Rate 5
      *
     C                   IF        OKBS05 = 'N'
     C                   EVAL      ADDBS05 = DDBS05
     C                   ENDIF
      *
      ** Spread Indicator 5
      *
     C                   IF        OKSI05 = 'N'
     C                   EVAL      ADDSI05 = DDSI05
     C                   ENDIF
      *
      ** Applicable Date 6
      *
     C                   IF        OKAD06 = 'N'
     C                   EVAL      ADDAD06 = DDAD06
     C                   ENDIF
      *
      ** Base Rate Code 6
      *
     C                   IF        OKBR06 = 'N'
     C                   EVAL      ADDBR06 = DDBR06
     C                   ENDIF
      *
      ** Spread Rate 6
      *
     C                   IF        OKBS06 = 'N'
     C                   EVAL      ADDBS06 = DDBS06
     C                   ENDIF
      *
      ** Spread Indicator 6
      *
     C                   IF        OKSI06 = 'N'
     C                   EVAL      ADDSI06 = DDSI06
     C                   ENDIF
      *
      *
      ** Applicable Date 7
      *
     C                   IF        OKAD07 = 'N'
     C                   EVAL      ADDAD07 = DDAD07
     C                   ENDIF
      *
      ** Base Rate Code 7
      *
     C                   IF        OKBR07 = 'N'
     C                   EVAL      ADDBR07 = DDBR07
     C                   ENDIF
      *
      ** Spread Rate 7
      *
     C                   IF        OKBS07 = 'N'
     C                   EVAL      ADDBS07 = DDBS07
     C                   ENDIF
      *
      ** Spread Indicator 7
      *
     C                   IF        OKSI07 = 'N'
     C                   EVAL      ADDSI07 = DDSI07
     C                   ENDIF
      *
      ** Applicable Date 8
      *
     C                   IF        OKAD08 = 'N'
     C                   EVAL      ADDAD08 = DDAD08
     C                   ENDIF
      *
      ** Base Rate Code 8
      *
     C                   IF        OKBR08 = 'N'
     C                   EVAL      ADDBR08 = DDBR08
     C                   ENDIF
      *
      ** Spread Rate 8
      *
     C                   IF        OKBS08 = 'N'
     C                   EVAL      ADDBS08 = DDBS08
     C                   ENDIF
      *
      ** Spread Indicator 8
      *
     C                   IF        OKSI08 = 'N'
     C                   EVAL      ADDSI08 = DDSI08
     C                   ENDIF
      *
      *
      ** Applicable Date 9
      *
     C                   IF        OKAD09 = 'N'
     C                   EVAL      ADDAD09 = DDAD09
     C                   ENDIF
      *
      ** Base Rate Code 9
      *
     C                   IF        OKBR09 = 'N'
     C                   EVAL      ADDBR09 = DDBR09
     C                   ENDIF
      *
      ** Spread Rate 9
      *
     C                   IF        OKBS09 = 'N'
     C                   EVAL      ADDBS09 = DDBS09
     C                   ENDIF
      *
      ** Spread Indicator 9
      *
     C                   IF        OKSI09 = 'N'
     C                   EVAL      ADDSI09 = DDSI09
     C                   ENDIF
      *
      ** Applicable Date 10
      *
     C                   IF        OKAD10 = 'N'
     C                   EVAL      ADDAD10 = DDAD10
     C                   ENDIF
      *
      ** Base Rate Code 10
      *
     C                   IF        OKBR10 = 'N'
     C                   EVAL      ADDBR10 = DDBR10
     C                   ENDIF
      *
      ** Spread Rate 10
      *
     C                   IF        OKBS10 = 'N'
     C                   EVAL      ADDBS10 = DDBS10
     C                   ENDIF
      *
      ** Spread Indicator 10
      *
     C                   IF        OKSI10 = 'N'
     C                   EVAL      ADDSI10 = DDSI10
     C                   ENDIF
      *
 
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
      ** Securities Screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE4ScnFmt
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
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Coupon Fixing for Floating Rate Notes.
     C                   PARM                    CSE031
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
      ** Securities Screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
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
