     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate MT3xx Receiver Party Information')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVRINF - Validate MT3xx Receiver Party Information          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSW213             Date 03Jun13               *
      *  Prev Amend No. AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 226815             Date 26May06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024   *CREATE   Date 31Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      ** Digits
     D Digits          C                   '0123456789'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid SWIFT characters
     D ValSwChar       S              1    DIM(71) CTDATA PERRCD(71)
      *
      ** Valid SWIFT codewords
     D*ValSwCode       S              6    DIM(10) CTDATA PERRCD(10)                          CSW213
     D ValSwCode       S              6    DIM(11) CTDATA PERRCD(11)                          CSW213
      *
      ** SWIFT codewords already entered
     D WSwCodeEnt      S              6    DIM(10)
      *
      ** Work array variable for Additinal info string
     D WAddInAr        S              1    DIM(194)
      *
      ** New Customer in File Format
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPD)
      *
      ** MT3xx BEI details screen error indicators
     D OkCuMT3x      E DS                  EXTNAME(SDECUMTPD)
     D  WDDRINFOK              3      7
      *
      ** New Customer in screen format - MT3xx BEI details
     D NwCuMT3x      E DS                  EXTNAME(SDCUMTPD)
     D  WDDRINF               13    212
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                     AR855391
      ** Index for arrays of warning messages                                               AR855391
     D WIx             S              3P 0                                                  AR855391
      *
      ** Work index
     D Wj              S              4P 0
     D Wx              S              4P 0
     D Wi              S              4P 0
     D WkSize          S              4P 0
     D WkNonB          S              4P 0
      *
      ** Work variables
     D WkEnds          S              1A
     D WkValInf        S              1A
     D WkFirst         S              1A
     D WkChar          S              1A
     D WkCode          S              6A
     D WtCode          S              6A
     D WAddInf6        S              6A
     D WAddInf9        S              9A
     D WAddInf         S            194A
      *
      ** Work variables for SD0011U
     D PRTCD           S              7A
     D PCBEI           S             12A
     D PSICL           S              1A
     D PC6NL           S              1A
     D PINVC           S              1A
     D PSIL8           S              1A
     D PEMSP           S              1A
     D PBICL           S              1A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise work variables.
      *
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0                                                  AR855391
      *
      ** Validate Receiver Information
      *
     C                   IF        WDDRINF <> *BLANKS
     C                   EXSR      SrRecInf
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        WDDRINFOK <> *ALL'Y'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   EVAL      CURI01 = DDRI01
     C                   EVAL      CURI02 = DDRI02
     C                   EVAL      CURI03 = DDRI03
     C                   EVAL      CURI04 = DDRI04
     C                   EVAL      CURI05 = DDRI05
     C                   ENDIF
      *
     C                   IF        WDDRINFOK = *ALL'W'                                      AR855391
     C                   EVAL      RetCodeIn = 'WARNING'                                    AR855391
     C                   ENDIF                                                              AR855391
      *                                                                                     AR855391
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRecInf - Validate Receiver Information                     *
      *                                                               *
      *****************************************************************
     C     SrRecInf      BEGSR
      *
      ** Generate error if not blank and Corporate Flag <> 'Y' or
      ** Corporate BEI is entered.
      *
     C                   IF        (DDCORP <> 'Y' OR
     C                             DDCBEI <> *BLANKS) AND
     C                             WDDRINF <> *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9136'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
      *
      ** There must be no embedded blank lines in between
      *
     C                   IF        (DDRI01 = *BLANK AND DDRI02 <> *BLANK)   OR
     C                             (DDRI02 = *BLANK AND DDRI03 <> *BLANK)   OR
     C                             (DDRI03 = *BLANK AND DDRI04 <> *BLANK)   OR
     C                             (DDRI04 = *BLANK AND DDRI05 <> *BLANK)
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9137'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
      *
      ** Initialise variables
     C                   EVAL      WkEnds = 'N'
     C                   EVAL      WkValInf = 'N'
     C                   MOVE      *BLANKS       WkCode
     C                   MOVE      *BLANKS       WtCode
     C                   EVAL      WkFirst = 'Y'
     C                   MOVEA     *BLANKS       WSwCodeEnt
     C                   EVAL      Wi = 0
     C                   EVAL      Wx = 1
      *
      ** First position must be '/'
     C                   EVAL      WkChar = %SUBST(DDRI01:1:1)
     C                   IF        WkChar <> '/'
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9138'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
      *
      ** This loop terminates if all 5 lines of information has been read
      *
     C                   DOW       Wx <= 200
      *
      ** Initialise work variables
     C                   MOVE      *BLANKS       WAddInf
     C                   MOVEA     *BLANKS       WAddInAr(1)
     C                   Z-ADD     1             Wj
      *
      ** This loop terminates once a pair of codeword and additional
      ** information is ready to be validated OR all 5 lines of information
      ** has been read
      *
     C                   DOW       WkValInf = 'N' AND
     C                             Wx <= 200
      *
     C                   EVAL      *IN01 = *OFF
      *
      ** If '/' is encountered, check if it forms a code word
     C                   IF        WkChar = '/' AND
     C                             Wx < 196
      *
     C                   EVAL      WtCode = %SUBST(WDDRINF:Wx:6)
     C     WTCode        LOOKUP    ValSwCode(1)                           01
      *
      ** Valid codeword
     C                   IF        *IN01
     C                   IF        WKCode = *BLANKS
      *
      ** Check if codeword is split between two lines:
     C                   IF        (Wx >= 36 AND Wx <= 40) OR
     C                             (Wx >= 76 AND Wx <= 80) OR
     C                             (Wx >=116 AND Wx <=120) OR
     C                             (Wx >=156 AND Wx <=160)
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9144'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
 
     C                   EVAL      WkCode = WTcode
     C                   EVAL      WkFirst = 'N'
     C                   ADD       6             Wx
     C                   Z-ADD     Wx            WkSize
     C                   ELSE
     C                   EVAL      WkValInf = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** First entry is not a valid codeword
     C                   IF        NOT(*IN01) AND
     C                             WkFirst = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9138'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** If it does not form a code word, then it forms the additional information
      *
     C                   IF        NOT(*IN01)
      *
     C     WkChar        LOOKUP    ValSwChar(1)                           01
      *
      ** For additional information, must be valid SWIFT characters
     C                   IF        NOT(*IN01) AND
     C                             WkChar <> *BLANK
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     *ALL'N'       WDDRINFOK                                  AR855391
     C**********         MOVEL     'DDRI01'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR9141'     MsgIdXAr(IDx)                              AR855391
     C**********         GOTO      EndRecInf                                                AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     *ALL'W'       WDDRINFOK                                  AR855391
     C                   MOVEL     'DDRI01'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR9141'     WMsgIdXAr(WIx)                             AR855391
     C                   ENDIF
      *
      ** Increment index counters
     C                   EVAL      WAddInAr(Wj) = WkChar
     C                   ADD       1             Wx
     C                   ADD       1             Wj
      *
      ** If it's a non-blank character, save position to be checked later
      ** for trailing blanks
     C                   IF        WkChar <> *BLANK
     C                   Z-ADD     Wx            WkNonB
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If still less than 200, read next character
      *
     C                   IF        Wx  <= 200
     C                   EVAL      WkChar = %SUBST(WDDRINF:Wx:1)
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If all 5 lines has been read, set end-of-information flag
     C                   IF        Wx > 200
     C                   EVAL      WkEnds = 'Y'
     C                   IF        WkCode <> *BLANKS
     C                   EVAL      Wx = WkNonB
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW024
      ** Call subroutine that validates additional information for the code
      ** word read
     C                   MOVE      *BLANKS       WAddInf
     C                   MOVEA     WAddInAr      WAddInf
     C                   EXSR      SRAddInf
      *
     C                   IF        Idx <> *ZERO
     C                   GOTO      EndRecInf
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WkCode
     C                   EVAL      WkValInf = 'N'
      *
      ** If end of information is encountered and either codeword /ABIC/ or
      ** /ACCT/ is not present, send error message
     C                   IF        WkEnds = 'Y'
     C     '/ABIC/'      LOOKUP    WSwCodeEnt                             01
     C                   IF        *IN01
     C     '/NAME/'      LOOKUP    WSwCodeEnt                             01
     C                   ENDIF
     C                   IF        NOT(*IN01)
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9140'     MsgIdXAr(IDx)
     C                   GOTO      EndRecInf
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
 
     C     EndRecInf     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAddInf - Get additional info details                       *
      *                                                               *
      *****************************************************************
     C     SrAddInf      BEGSR
      *
      ** No codeword must be used more than once.
     C                   IF        WkCode <> *BLANKS
     C     WkCode        LOOKUP    WSwCodeEnt                             01
     C                   IF        *IN01
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9146'     MsgIdXAr(IDx)
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
      ** If no errors, move codeword to array of codeword used.
     C                   ADD       1             Wi
     C                   EVAL      WSwCodeEnt(Wi) = WkCode
     C                   ENDIF
      *
      ** Generate error if additional info is blank
     C                   IF        WAddInf = *BLANKS
     C                   IF        WkCode <> *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9142'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
      ** Process depending on type of codeword
      *
     C                   SELECT
     C                   WHEN      WkCode = '/ABIC/'
      *
      ** Error if greater than 11 characters
     C                   IF        (WkNonB - Wx) > 11
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9139'     MsgIdXAr(IDx)
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
      ** Validate to check if BEI id if not 4 characters and 'UKWN'
     C**********         IF        (Wx - WkSize) <> 4 OR                                      226815
     C                   IF        (WkNonB - WkSize) <> 4 OR                                  226815
     C                             WAddInf <> 'UKWN'
     C                   EXSR      SRBEI
     C                   ENDIF
      *
     C                   WHEN      WkCode = '/ACCT/' OR
     C                             WkCode = '/NAME/'
      *
      ** Error if greater than 34 characters
     C                   IF        (Wx - WkSize) > 34
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   IF        WkCode = '/ACCT/'
     C                   MOVEL     'USR9147'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVEL     'USR9148'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
     C                   WHEN      WkCode = '/ADD1/' OR
     C                             WkCode = '/ADD2/' OR
     C                             WkCode = '/CITY/' OR
     C                             WkCode = '/CLRC/'
      *
      ** Error if greater than 35 characters
     C                   IF        (Wx - WkSize) > 35
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   IF        WkCode = '/CLRC/'
     C                   MOVEL     'USR9149'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVEL     'USR9150'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
     C                   WHEN      WkCode = '/USFW/'
      *
      ** Error if non-numeric or greater than 9 digits
     C                   EVAL      WAddInf9 = WAddInf
     C     Digits        CHECK     WAddInf9                               01
     C                   IF        (WkNonB - WkSize) <> 9  OR
     C                             *IN01
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9143'     MsgIdXAr(IDx)
     C                   GOTO      EndAddInf
     C                   ENDIF
      *
     C                   WHEN      WkCode = '/USCH/' OR
     C                             WkCode = '/GBSC/'
      *
      ** Error if non-numeric or greater than 6 digits
     C                   EVAL      WAddInf6 = WAddInf
     C     Digits        CHECK     WAddInf6                               01
     C                   IF        (WkNonB - WkSize) <> 6 OR
     C                             *IN01
     C                   ADD       1             Idx
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   IF        WkCode = '/USCH/'
     C                   MOVEL     'USR9151'     MsgIdXAr(IDx)
     C                   ELSE
     C                   MOVEL     'USR9152'     MsgIdXAr(IDx)
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDSL
      *
     C     EndAddInf     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBEI - Check if valid BEI id                                *
      *                                                               *
      *****************************************************************
     C     SRBEI         BEGSR
      *
      ** Call SD0012U to check if valid SWIFT id if module
      *
     C                   CALL      'SD0011U1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      WAddInf       PCBEI
     C                   PARM      *BLANK        PSICL
     C                   PARM      *BLANK        PC6NL
     C                   PARM      *BLANK        PINVC
     C                   PARM      *BLANK        PSIL8
     C                   PARM      *BLANK        PEMSP
     C                   PARM      *BLANK        PBICL
      *
      ** ID may have no embedded spaces
     C     PEMSP         IFEQ      '1'
      *
      ** ID must be 8 or 11 characters in length
     C     PSICL         OREQ      '1'
     C     PSIL8         OREQ      '1'
     C     PBICL         OREQ      '1'
      *
      ** First 6 characters must be all alpha
     C     PC6NL         OREQ      '1'
      *
      ** No invalid characters may be entered
     C     PINVC         OREQ      '1'
     C                   MOVEL     *ALL'N'       WDDRINFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRI01'      FldNamXAr(Idx)
     C                   MOVEL     'USR9139'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     EndBEI        ENDSR
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** New Customer in screen format - MT3xx BEI details
     C                   PARM                    NwCuMT3x
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
      *
      ** MT3xx BEI details screen error indicators
     C                   PARM                    OkCuMT3x
      *
      ** New Customer in file format
     C                   PARM                    NwCuFilFmt
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
      * Inserted new SWIFT code LEIC to ValSwCode array                                       CSW213
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** Valid swift characters
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-?:().,'+
** Valid swift codewords
/ABIC//ACCT//NAME//ADD1//ADD2//CITY//USFW//USCH//GBSC//CLRC//LEIC/
