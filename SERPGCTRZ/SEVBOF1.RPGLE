     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Beneficiary of Money (a/c ln 1)')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVBOF1 - Validate Beneficiary of Money (a/c Line 1)         *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR642262           Date 14Sep10               *
      *                 AR628467           Date 16Aug10               *
      *                 AR589197           Date 11Aug10               *
      *                 AR580927           Date 22Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR642262 - Error in IBAN validation (Recompile)              *
      *  AR628467 - Error msg appears:MEC0005:Beneficiary:Account line*
      *             starts but the field with red mark is the         *
      *             Beneficiary of Money not the Beneficiary of Money *
      *             Account line                                      *
      *  AR589197 - The input validation of //xx has been removed if  *
      *             ISO15022 is switched on, it should be reapplied   *
      *             as the code is still used                         *
      *  AR580927 - Incomplete Warning Messages during completion of  *
      *             securities trades                                 *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
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
      ** Security API Trades Extended Settlements from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlements for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Security API Trades Extended Settlements error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Work parameter
     D OVER3           S              1A
     D SWRTN           S              7A
     D CSE028          S              1A
     D WWBOF1          S              1A
     D WWLI01          S              1A
     D WWLI02          S              2A
     D WWLI04          S              4A
     D WWLI05          S              5A
     D WWER35          S              1A
     D WWCUSS          S              1A
     D WWBNBI          S              1A
     D WWCABA          S              3P 0
     D WWCSID          S             12A
     D WWBLCD          S              8A
     D WWFWCD          S              9A
     D WWCHID          S              6P 0
     D WWCHSC          S              6P 0
     D WWALP3          S              3A
     D WWALP6          S              6A
     D WWALP8          S              8A
     D WWALP9          S              9A
     D WWNUM4          S              4P 0
     D WWNUM7          S              7P 0
     D WWNUM9          S              9P 0
     D WWNU10          S             10P 0
     D W0RTN           S              7A
     D WBENF           S             35A
     D WACLN           S             35A
     D WICNIL          S              1A
     D IBENF           S              1A
     D W#ISCD          S              4A
     D WBOFN           S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
     D PINKS           S              1A
     D Z#PARM          S            256A
 
      *
      ** Alpha Input Field
      *
     D WWDS1           DS            35
     D  WWLI35                 1     35
     D  WW0507                 5      7
     D  WW0510                 5     10
     D  WW0512                 5     12
     D  WW0513                 5     13
     D  WW0535                 5     35
     D  WW0835                 8     35
     D  WW1135                11     35
     D  WW1335                13     35
     D  WW1435                14     35
      *
      ** Input Parameters
      *
     D*I#PARM***       DS           512                                                       CGL029
     D I#PARM          DS           514                                                       CGL029
      * Field to be validated
     D  I#VFLD                 1      5
      * Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8
      * Customer/Counterparty Nostro /BIC indentified type
      *    C           X              S  X-> C'party Nostro or Customer
      * Customer/Counterparty/BIC indentified
     D  I#PRTT                 9      9
     D  I#PRTY                10     20
      * Pay Currency
     D  I#PCCY                21     23
      * Receive Currency
     D  I#RCCY                24     26
      * Account Line
     D  I#ACLN                27     61
      * Account Line Character 1
     D  I#ACC1                27     27
      * Account Line Character 2
     D  I#ACC2                28     28
      * Account Line Character 3
     D  I#ACC3                29     29
      * Account Line first 4 characters
     D  I#ACCL                27     30
      * Account Line Clearing System
     D  I#ACCS                29     30
      * Account Line No account data
     D  I#SPC1                31     61
      * Message Type
     D  I#MTYP                62     64
      * Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76
      * Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88
      * Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100
      * Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104
      * Field 53 and 54 Entered
     D  I#5354               105    105
      * Midas Module
     D  I#MMOD               106    107
      * Pay and Receive Settlement Accounts
     D**I#PYAC**             108    125                                                       CGL029
     D**I#RCAC**             126    143                                                       CGL029
      * Transaction Type
     D  I#TTYP               144    145
      * Cover required
     D  I#COVR               146    146
      * Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
      ** Pay and Receive Settlement Accounts                                                  CGL029
     D  I#PYAC               467    490                                                       CGL029
     D  I#RCAC               491    514                                                       CGL029
      *
      ** Output Parameters
      *
     D O#PARM          DS           512
      * Account Line modified
     D  O#ACLN                 1     35
      * Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466
      *
      ** Error Parameters
      *
     D E#PARM          DS           256
      * Calling Program
     D  E#CPGM                 1     10
      * Error message sent
     D  E#ERRM                12     12
      * Warning message sent
     D  E#WARN                13     13
      * Error index
     D  E#INDX                14     18  0
      * Message text to prefix error message
     D  E#MSGD                19     25
     D  E#MSGF                26     35
      * Error codes array
     D  E#ERCD                51    200
     D  O#E                   51    200
      * Declared variables for IBAN                                                           CSW210
      /COPY SECPYSRC,SRIBAN_ILE                                                               CSW210
      *
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
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0                                                    CSW210
     C                   EVAL      WWLI02 = %Subst(ESBOF1:1:2)                              AR589197
      *
      ** Validate Beneficiary of Money (A/c line 1)
      *
     C                   EXSR      SRValBof1
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        ESBOF1OK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESBOF1OK <> 'N'
     C                   IF        (ESAWIN <> *BLANKS) or (ESAWIL <> *BLANKS)
     C                             or (*IN88 = *ON)
     C                   MOVEL     ESBOF1        T2BOF1
     C                   ELSE
     C                   MOVEL     *BLANKS       T2BOF1
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALBOF1 - Validation for Beneficiary of Money (A/c Line 1) *
      *                                                               *
      *****************************************************************
 
     C     SRValBof1     BEGSR
     C                   IF        PSNEW <> 'Y' OR                                            CSW210
     C                             CSE028 <> 'Y'                                              CSW210
     C                             OR WWLI02 = '//'                                         AR589197
      *
      ** Validate If not Blank
      *
     C                   MOVEL     ESBOF1        WWBOF1
     C     ESBOF1        IFNE      *BLANKS
     C     WWBOF1        ANDNE     '#'
      *
      ** Override by F18
      *
     C     PSENT         IFEQ      'CEDEL'
     C     PINKS         ANDEQ     *ON
     C     OVER3         ANDEQ     '1'
     C                   MOVE      *OFF          PINKS
     C                   MOVE      'Y'           OVER3
     C                   ENDIF
      *
      ** If not Overridden
      *
     C     OVER3         IFNE      'Y'
 
     C     ESBOFN        IFEQ      *BLANKS
     C                   MOVE      'N'           ESBOFNOK
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOFN'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5230'     MsgIdXAr(IDx)
     C                   MOVE      '1'           OVER3
 
     C                   ELSE
     C                   MOVEL     ESBOF1        WWLI01
     C                   MOVEL     ESBOF1        WWLI02
     C                   MOVEL     ESBOF1        WWLI04
     C                   MOVEL     ESBOF1        WWLI05
     C                   MOVEL     ESBOF1        WWLI35
 
     C     WWLI02        IFEQ      '//'
     C     WWCUSS        ANDEQ     'C'
     C     WWBNBI        ANDEQ     'N'
     C     WWLI02        OREQ      '//'
     C     WWCUSS        ANDEQ     'S'
     C     WWBNBI        ANDEQ     'N'
     C                   MOVE      'N'           ESBOF1OK
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5250'     MsgIdXAr(IDx)
     C                   MOVE      '1'           OVER3
 
     C                   ELSE
     C                   MOVE      'N'           ESBOF1OK
     C                   MOVE      '1'           OVER3
     C                   MOVE      'N'           WWER35                                     AR589197
 
     C     SWRTN         IFNE      'CSW098 '
     C                   EXSR      SRLI35
     C                   ELSE
      *
      ** Set up parameters for call to ME9940
      *
     C                   MOVE      *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
     C                   MOVEL     'BENF '       I#VFLD
     C                   MOVEL     'PAY'         I#PR
 
     C     WWCUSS        IFEQ      'N'
     C                   MOVEL     'X'           I#PRTT
     C                   ELSE
     C                   MOVEL     WWCUSS        I#PRTT
     C                   ENDIF
 
     C                   MOVEL     WBOFN         I#PRTY
     C                   MOVEL     PTNMC         I#PCCY
     C                   MOVEL     PTNMC         I#RCCY
     C                   MOVEL     WWLI35        I#ACLN
     C                   MOVEL     '5XX'         I#MTYP                                     AR589197
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
     C**********         EVAL      E#CPGM = 'SETSESSIN'                                       CSW210
     C                   EVAL      E#CPGM = 'SETSESVAL'                                       CSW210
     C                   MOVEL     'MEC0018'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
      *
     C                   MOVEL     WBENF         WACLN
      *
     C                   EXSR      SRME99
      *
      ** If no issuer code defined for the currency clearing system,
      ** set flag to display warning message for later display.
      *
     C     WICNIL        IFEQ      'Y'
     C                   MOVEL     'Y'           IBENF
     C                   MOVEL     *BLANKS       WICNIL
     C                   ENDIF
 
     C                   MOVEL     WWLI35        WBENF
 
     C                   ENDIF
 
     C     WWER35        IFNE      'Y'
     C                   MOVE      'Y'           ESBOF1OK
     C                   MOVE      '0'           OVER3
     C                   MOVEL     WWLI35        ESBOF1
     C                   ELSE                                                               AR589197
     C                   EVAL      ESBOF1OK = 'N'                                           AR589197
     C                   ADD       1             IDx                                        AR589197
     C                   MOVE      '1'           OVER3                                      AR589197
     C**********         EVAL      FldNamXAr(IDx) = 'ESBOFN    '                   AR589197 AR628467
     C                   EVAL      FldNamXAr(IDx) = 'ESBOF1    '                            AR589197
     C                   EVAL      MsgIdXAr(IDx) = E#MSGD                                   AR589197
     C                   EVAL      MsgDtaXAr(IDx) = Z#PARM                                  AR589197
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** IBAN Validation                                                                      CSW210
      *                                                                                       CSW210
     C                   IF        ESBOF1 <> *BLANKS AND                                      CSW210
     C                             CSW210 = 'Y' AND                                           CSW210
     C                             CFT004 = 'Y'                                               CSW210
     C                   EVAL      IBANFld = ESBOF1                                           CSW210
     C                   EXSR      SrIBAN                                                     CSW210
     C                   IF        WIBAN35 <> *BLANKS                                         CSW210
     C                   EVAL      ESBOF1 = WIBAN35                                           CSW210
     C                   ENDIF                                                                CSW210
     C                   IF        IBANWarningMsg = 'Y'                                       CSW210
     C                   EVAL      ESBOF1OK = 'N'                                             CSW210
     C                   EVAL      WFldNmXAr(WIx) = 'ESBOF1    '                              CSW210
     C**********         EVAL      WMsgDtXAr(WIx) = 'Bene. Money A/c Line'           CSW210 AR580927
     C                   EVAL      WMsgDtXAr(WIx) = 'Beneficiary of +                       AR580927
     C                             Money Account Line'                                      AR580927
     C                   ENDIF                                                                CSW210
     C                   EVAL      T2FBF1 = ValidIBANFlag                                     CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
 
     C     EValBof1      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRLI35    - Validate A 35 Alpha Input Field                 *
      *                                                               *
      *****************************************************************
 
     C     SRLI35        BEGSR
      *
      ** Initialise Flag to Send Error Message If 35A Fields not
      ** correctly Formatted.
      *
     C                   MOVE      *BLANKS       WWER35
      *
      ** Validate First Character
      *
     C     WWLI01        IFNE      '/'
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
      *
      ** Validate First 2 Characters
      *
     C     WWLI02        IFEQ      '//'
     C     WWLI04        ANDNE     '//BL'
     C     WWLI04        ANDNE     '//CH'
     C     WWLI04        ANDNE     '//CP'
     C     WWLI04        ANDNE     '//FW'
     C     WWLI04        ANDNE     '//SC'
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
      *
      ** Validate First 4 Characters
      *
     C     PTNMC         IFNE      'USD'
     C     WWLI04        IFEQ      '//CH'
     C     WWLI04        OREQ      '//CP'
     C     WWLI04        OREQ      '//FW'
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
     C                   ENDIF
 
     C     PTNMC         IFNE      'DEM'
     C     WWLI04        ANDEQ     '//BL'
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
      *
      ** Invalid Entry
      *
     C     WWER35        IFEQ      'Y'
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5235'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
      *
      ** Validate First 5 Characters
      *
     C     WWLI05        IFEQ      '//CP '
 
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
      *
      ** If //CP is followed by Blanks then Default this to the
      ** Customer CHIPS Participant
      *
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCABA        WW0507
     C                   ENDIF
     C                   ENDIF
      *
      ** Error If ' //CP' is not followed by a 3 Digit Number
      ** followed by Blanks
      *
     C                   MOVEL     WW0507        WWNUM4
     C                   MOVEL     WWNUM4        WWALP3
     C     WW0507        IFNE      WWALP3
     C     WW0835        ORNE      *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5236'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
     C                   ENDIF
      *
      ** If Leftmost 4 Chars are '//FW' followed by Blanks and
      ** Customer SWIFT Id is Blank then Set Up Fedwire Account
      *
     C     WWLI04        IFEQ      '//FW'
 
     C     WW0535        IFEQ      *BLANKS
     C     WWCSID        ANDEQ     *BLANKS
     C                   MOVEL     WWFWCD        WW0513
     C                   ENDIF
      *
      ** Error If Positions 14 -35 of WWLI35 are not Blank
      *
     C     WW1435        IFNE      *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5237'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
      *
      ** Fedwire Account may only be Blank for a Bank with a Valid
      ** SWIFT Address
      *
     C     WW0513        IFEQ      *BLANKS
 
     C     WWCUSS        IFNE      'C'
     C     WWCUSS        ANDNE     'S'
     C     WWBNBI        OREQ      'N'
     C     WWCSID        OREQ      *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5238'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
 
     C                   ELSE
      *
      ** Else, must be A 9 Digit Number
      *
     C                   MOVEL     WW0513        WWNU10
     C                   MOVEL     WWNU10        WWALP9
     C     WW0513        IFNE      WWALP9
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5239'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Customer or Bank must have a SWIFT Address or a Fedwire A/c
      *
     C     WWCSID        IFEQ      *BLANKS
     C     WWFWCD        ANDEQ     *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5240'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If Leftmost 4 Chars of WWLI35 are '//BL' followed by Blanks
      ** Set Up the Bankleitzahl Code
      *
     C     WWLI04        IFEQ      '//BL'
 
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWBLCD        WW0512
     C                   ENDIF
     C                   ENDIF
      *
      ** Error If '//BL' not followed by 8 Digits Number followed by
      ** Blanks
      *
     C                   MOVEL     WW0512        WWNUM9
     C                   MOVEL     WWNUM9        WWALP8
     C     WW0512        IFNE      WWALP8
     C     WW1335        ORNE      *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5241'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If Leftmost 4 Chars of WWLI35 are '//CH' followed by Blanks
      ** Set Up Customer CHIPS Universal Id
      *
     C     WWLI04        IFEQ      '//CH'
 
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCHID        WW0510
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If Leftmost 4 Chars of WWLI35 are '//SC' followed by Blanks
      ** Set Up CHAPS Sort Code
      *
     C     WWLI04        IFEQ      '//SC'
 
     C     WWCUSS        IFEQ      'C'
     C     WWCUSS        OREQ      'S'
     C     WWBNBI        IFEQ      'Y'
     C     WW0535        ANDEQ     *BLANKS
     C                   MOVEL     WWCHSC        WW0510
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Error If '//CH' or '//SC' are not followed by a 6 Digit Number
      *
     C     WWLI04        IFEQ      '//CH'
     C     WWLI04        OREQ      '//SC'
 
     C                   MOVEL     WW0510        WWNUM7
     C                   MOVEL     WWNUM7        WWALP6
     C     WW0510        IFNE      WWALP6
     C     WW1135        ORNE      *BLANKS
     C                   ADD       1             IDx
     C                   MOVEL     'ESBOF1'      FldNamXAr(IDx)
     C                   MOVEL     'SEW5242'     MsgIdXAr(IDx)
     C                   MOVE      'Y'           WWER35
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRME99    - To Validate Account with Line via ME9940        *
      *                                                               *
      *****************************************************************
 
     C     SRME99        BEGSR
 
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN
     C                   PARM                    I#PARM
     C                   PARM                    O#PARM
     C                   PARM                    E#PARM
     C                   PARM                    Z#PARM
 
     C                   MOVEL     O#ACLN        WWLI35
     C     E#ERRM        IFNE      *BLANKS
     C                   MOVEL     'Y'           WWER35
     C                   ELSE
      *
      ** Check whether Issuer Code has been defined for the currency
      ** clearing system. If not, set flag on to issue warning message
      ** for later display (SEW5176).
      *
     C                   MOVEL     Z#PARM        W#ISCD
     C     WWLI02        IFEQ      '//'
     C     W#ISCD        ANDEQ     *BLANKS
     C     O#ACLN        ANDNE     WACLN
     C                   MOVEL     'Y'           WICNIL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      *  SRIBAN - Validation for IBAN Account                         *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
      /COPY SECPYSRC,SEVIBANVAL                                                               CSW210
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    SWRTN
 
     C                   PARM                    CSE028
 
     C                   PARM                    WWCUSS
 
     C                   PARM                    WWBNBI
 
     C                   PARM                    WWCABA
 
     C                   PARM                    WWCSID
 
     C                   PARM                    WWFWCD
 
     C                   PARM                    WWBLCD
 
     C                   PARM                    WWCHID
 
     C                   PARM                    WWCHSC
 
     C                   PARM                    WBOFN
                                                                                              CSW210
     C                   PARM                    CSW210                                       CSW210
                                                                                              CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       CSW210
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSW210
     C                   PARM                    WFldNmXAr                                    CSW210
     C                   PARM                    WMsgIDXAr                                    CSW210
     C                   PARM                    WMsgDtXAr                                    CSW210
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
 
     C                   PARM                    PINKS
 
     C                   PARM                    OVER3
 
     C                   PARM                    IBENF
      *
      ** Initialise Work Fields
      *
     C                   EVAL      WBENF  = *Blanks
     C                   EVAL      WACLN  = *Blanks
     C                   EVAL      WICNIL = *Blanks
     C                   EVAL      IBENF  = *Blanks
      *
      ** Enable display of counterparty safekeeping a/c if
      ** CSE028 is on and ISO15022 is on.
      *
     C     CSE028        IFEQ      'Y'
     C     PSNEW         ANDEQ     'Y'
     C     PGMES         ANDEQ     'Y'
     C                   EVAL      *IN88 = *ON
     C                   ELSE
     C                   EVAL      *IN88 = *OFF
     C                   ENDIF
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
(c) Finastra International Limited 2003
