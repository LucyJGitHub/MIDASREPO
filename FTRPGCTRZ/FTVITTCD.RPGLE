     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP Transaction Type Code')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVITTCD - Validate IP Transaction Type Code                 *
      *                                                               *
      *  Function:  This module validates the Transaction Type Code.  *
      *             This is a component of FTIPAYCTL, FTIPAYRPR,      *
      *             FTIPAYSIN, and service program for level 2        *
      *             validation modules.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. MD000091           Date 06May13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW202 - SWIFT 2002 Standards Update                         *
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

      ** Incoming Payments Lvl2 Scrn 2 details
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)

      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      ** Incoming Payments Lvl 2 Scrn 2 details
     D OKIPY3DS      E DS                  EXTNAME(FTEIPY3PD)

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

      ** SWIFT 2002 Switchable Feature Indicator                                              CSW202
     D CSW202          S              1A                                                      CSW202
                                                                                              CSW202
      ** Return Code when calling SWIF2002                                                    CSW202
     D PRetrnCde       S              7A                                                      CSW202
                                                                                              CSW202
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
     C                   EVAL      ErrorFound = 'N'                                           CSW202

     C                   EXSR      SRTTCD

      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRTTCD - Validation of Transaction Type Code.                *
      *****************************************************************
     C     SRTTCD        BEGSR

      *
      ** Entry is optional

     C                   IF        DDTTCD  = *BLANKS
     C                   EVAL      I2INTTCD = *BLANKS
     C                   GOTO      EXTTCD
     C                   ENDIF
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, characters of                         CSW202
      ** Transaction Type Code may now be of type Alphanumeric.                               CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C     ALPHAN        CHECK     DDTTCD        J                                            CSW202
     C                   ELSE                                                                 CSW202

      *
      ** Otherwise, check if entry consists only of characters from
      **    'A' to 'Z'

     C     ALPHAB        CHECK     DDTTCD        J
     C                   ENDIF                                                                CSW202

     C                   IF        (J > 0)
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5010'
     C                   EVAL      FldNamXAr(Idx) = 'DDTTCD'
     C**********         EVAL      MsgDtaXAr(Idx) = DDTTCD                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(DDTTCD))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDTTCD)                   MD000091
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKTTCD = 'N'
     C                   ENDIF

     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INTTCD = DDTTCD
     C                   ENDIF

     C     EXTTCD        ENDSR
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
      *
      ************
      ** OUTPUT **
      ************
      *
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
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
