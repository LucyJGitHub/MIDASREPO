     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP original exchange rate')          *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIOEXR - Validate IP Original Exchange Rate                *
      *                                                               *
      *  Function:  This module validates the Original Exchange Rate. *
      *             This is a component of FTIPAYCTL, FTIPAYRPR,      *
      *             FTIPAYSIN, and service program for Level 2        *
      *             validation modules.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 210871             Date 26Apr06               *
      *                 CAP084             Date 09Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  210871 - If instructed ccy is equal to pay ccy, set original *
      *           rate to 1.                                          *
      *  CAP084 - Increase the length of WPayAmt & WInsAmt to cater   *
      *           for large numbers and Power(1) scenarios            *
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

      ** Incoming Payments Lvl 1 details
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)

      ** Incoming Payments Lvl 1 file 2 details
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)

      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      ** Incoming Payments Lvl 1 error indicators
     D OKIPY1DS      E DS                  EXTNAME(FTEIPY1PD)

      ** Correction factor for amounts
     D Power           S              7  3 DIM(7) CTDATA PERRCD(1)

      /COPY FTCPYSRC,FT0010D001

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

     D**********WInsAmt         S             13  0                                           CAP084
     D**********WPayAmt         S             13  0                                           CAP084
     D WInsAmt         S             16  0                                                    CAP084
     D WPayAmt         S             16  0                                                    CAP084
     D WDiffNBDP       S              3  0

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

     C                   IF        (DDOEXR <> *Blanks)
     C                   EXSR      SROEXR
     C                   ELSE
     C                   EXSR      SRDEFAULT
     C                   ENDIF

      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROEXR - Validation of Original Exchange Rate.               *
      *****************************************************************
     C     SROEXR        BEGSR

      *
      ** If Instructed Amount/Currency was not entered, entry to this field
      **    is invalid.

     C                   IF        DDNDCY  = *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3139'
     C                   EVAL      FldNamXAr(Idx) = 'DDOEXR'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKOEXR = 'N'
     C                   GOTO      EXOEXR
     C                   ENDIF

      *
      ** Validate exchange rate format

     C                   EVAL      PInChr16 = *Blanks
     C                   CALL      'ZALIGN'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      DDOEXR        PInChr16         16
     C                   PARM      8             PNum010           1 0
     C                   PARM      5             PNum020           2 0
     C                   PARM      *Blanks       POutChr16        16
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3140'
     C                   EVAL      FldNamXAr(Idx) = 'DDOEXR'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKOEXR = 'N'
     C                   GOTO      EXOEXR
     C                   ENDIF

     C                   MOVE      POutChr16     I2INOEXR

      *
      ** If Original Exchange rate is zero, do defaulting

     C                   IF        I2INOEXR = 0
     C                   EXSR      SRDEFAULT
     C                   ENDIF

      *
      ** Format for output to screen

     C                   MOVE      *BLANKS       WCHR16
     C                   MOVE      I2INOEXR      WCHR16

     C                   CALL      'ZEDIT'
     C                   PARM                    WCHR16           16
     C                   PARM      8             WNUM010           1 0

     C                   MOVE      WCHR16        DDOEXR

     C     EXOEXR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDEFAULT- Defaults Original Exchange Rate.                  *
      *****************************************************************
     C     SRDEFAULT     BEGSR

      *
      ** Do the default if Instructed amount/currency and Pay amount/ccy
      **    were entered successfully.

     C                   IF        OKPCCY = 'Y' AND DDPCCY <> *Blanks AND
     C                             OKPYAM = 'Y' AND PPayAmt <> *ZERO AND
     C                             OKNDCY = 'Y' AND DDNDCY <> *Blanks AND
     C                             OKNDAM = 'Y' AND PInsAmt <> *ZERO

      ** Set up parameters for FT0010
     C                   CLEAR                   P#0010
     C                   MOVE      *BLANKS       P#NDCY
     C                   Z-ADD     *ZEROS        P#NDAM
     C                   EVAL      P#DBCY = DDPCCY
     C                   EVAL      P#DBAM = PPayAmt
     C                   EVAL      P#CRCY = DDNDCY
     C                   EVAL      P#CRAM = PInsAmt
     C                   MOVE      *Blanks       P#PDCY
     C                   Z-ADD     *ZEROS        P#PDAM
     C                   Z-ADD     *ZEROS        P#DBDT
     C                   Z-ADD     *ZEROS        P#CRDT
     C                   MOVE      *ZEROS        P#RATE
     C                   MOVE      *BLANKS       P#OVRT
     C                   MOVE      *BLANKS       P#SDIN
     C                   Z-add     PBTPCRD       P#RTDS
     C                   EVAL      P#PMSQ = 'FTVIOEXR'
     C                   MOVE      *Blanks       P#INDC
     C                   MOVE      *Blanks       P#RTCD

     C                   CALL      'FT0010'
     C                   PARM                    P#0010

     C                   IF        P#RTCD = '*ERROR'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'FT0010'
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF

      *
      ** Get difference in the number of decimal places between
      ** Instructed Currency and Pay currency.

     C                   EVAL      WDiffNBDP = PInsNBDP - PPayNBDP

     C                   SELECT
     C                   WHEN      WDiffNBDP = 0
     C                   EVAL      WPayAmt = PPayAmt
     C                   EVAL      WInsAmt = PInsAmt
     C                   WHEN      WDiffNBDP > 0
     C                   EVAL      WPayAmt = PPayAmt / Power(WDiffNBDP)
     C                   EVAL      WInsAmt = PInsAmt
     C                   WHEN      WDiffNBDP < 0
     C                   EVAL      WPayAmt = PPayAmt
     C                   EVAL      WDiffNBDP = WDiffNBDP * (-1)
     C                   EVAL      WInsAmt = PInsAmt / Power(WDiffNBDP)
     C                   ENDSL

     C                   If        DDPCCY = DDNDCY                                            210871
     C                   Eval      I2INOEXR = 1                                               210871
     C                   Else                                                                 210871
                                                                                              210871
     C                   IF        P#MDIN = 1
     C                   EVAL      I2INOEXR = WInsAmt / WPayAmt
     C                   ELSE
     C                   EVAL      I2INOEXR = WPayAmt / WInsAmt
     C                   ENDIF
                                                                                              210871
     C                   EndIf                                                                210871
      *
      ** Format for output to screen

     C                   MOVE      *BLANKS       WCHR16
     C                   MOVE      I2INOEXR      WCHR16

     C                   CALL      'ZEDIT'
     C                   PARM                    WCHR16
     C                   PARM      8             WNUM010

     C                   MOVE      WCHR16        DDOEXR

     C                   ENDIF

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
      ** Incoming Payments Lvl1 details
     C                   PARM                    NwIP1ScnFmt
      ** Incoming Payments Lvl1 file 2 details
     C                   PARM                    NwIP1AScnFmt
      ** Pay Amount
     C                   PARM                    PPayAmt          13 0
      ** Pay Amount's number of decimal places
     C                   PARM                    PPayNBDP          1 0
      ** Instructed Amount
     C                   PARM                    PInsAmt          13 0
      ** Instructed Amount's number of decimal places
     C                   PARM                    PInsNBDP          1 0
      ** Percent Rate Discrepancy (SDFTFRPD)
     C                   PARM                    PBTPCRD           5 2
      *
      ************
      ** Output **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 1 error indicators
     C                   PARM                    OKIPY1DS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

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
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  Power(for amount conversion)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
