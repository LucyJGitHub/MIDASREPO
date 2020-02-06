     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate original amount/currency')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVORAM01  - Validate Original Amount/Currency               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207A            Date 29Jul07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 221761             Date 01Apr04               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184259             Date 28Spt00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177811             Date 14APR00               *
      *                 CFT006  *CREATE    Date 01Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - Swift 2007 Standard Changes fix                    *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184259 - Outward RFT exchange rate calculation               *
      *  177811 - Pass amount not currency to ZFIELD                  *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions parameter list
      ** for call to FT0010.
     D/COPY FTCPYSRC,FT0010D001
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      ** External data structure for Bank standing data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Numeric version of Original Amount
     D NumORGAMT       S             13P 0
 
      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             13P 0
 
      ** Exchange Rate calculated by the system/numeric version of PXRATE
     D CalcXRATE       S             13P 8
 
      ** Work field for % rate discrepancy
     D WBtpcrd         S              5  2
                                                                                              CSW207
      ** SWIFT 2007 switchable feature                                                        CSW207
     D CSW207          S              1A   INZ('N')                                           CSW207
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** Return code when calling SWIF2001                                                    CSW201
     D PRTCD           S              7A                                                      CSW201
                                                                                              CSW201
      ** Transfer Amount work variable                                                        CSW201
     D WTrnAmt         S             16A                                                      CSW201
                                                                                              CSW201
      ** Array index                                                                          CSW201
     D Win             S              2P 0                                                    CSW201
                                                                                              CSW201
      ** Transfer Amount work array                                                           CSW201
     D WTrnArr         S              1A   DIM(16)                                            CSW201
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKORAM     = 'Y'
     C                   Eval      OKORCY     = 'Y'
      *
      ** Extract Fund Transfer Details
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     Rtcd              7
     C                   PARM      '*FIRST '     Optn              7
     C     SDFTFR        PARM      SDFTFR        Dsfdy
      *
     C                   IF        Rtcd <> *BLANKS
     C                   Z-ADD     001           Dbase
     C                   MOVEL     'SDFTFRPD'    DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcRd = BtPcRd / 100
     C                   ENDIF
      *
 
      ** Validate both fields
     C                   EXSR      Validate
 
      ** If outgoing RFT,and transfer amount and currency,and original
      ** amount and currency are entered, calculate exchange rate
 
     C                   EXSR      ConvAmts                                                  CSW207A
     C                   If        PPTYP = 'RO' and OKORAM = 'Y'
     C                             and OKORCY ='Y' and OKTRAM = 'Y'
     C**********                   and OKTRCY = 'Y' and PTOOAMT <> *Blanks                   CSW207A
     C                             and OKTRCY = 'Y' and numORGAMT <> 0                       CSW207A
     C                             and PTOCCY <> *Blanks
     C**********         EXSR      ConvAmts                                                  CSW207A
     C                   EXSR      ValXRate
     C                   ENDIF
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate fields                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOCURRR0                                               *
      *                                                               *
      *****************************************************************
     C     Validate      BEGSR
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Outgoing Request for Transfers,                       CSW201
      ** entry to FX Deal Reference is prohibited when Transfer Amount is zero                CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND PPTYP = 'RO'                              CSW201
     C                             AND OKTRAM <> 'N' AND OKTRCY <> 'N'                        CSW201
     C**********                   OR (CSW207 = 'Y' AND PPTYP = 'RO'                  CSW207 CSW207A
     C                             OR (CSW207 = 'Y'                                          CSW207A
     C                             AND OKTRAM <> 'N' AND OKTRCY <> 'N')                       CSW207
      *                                                                                       CSW201
      ** Check if Transfer Amount is zero                                                     CSW201
      *                                                                                       CSW201
     C                   MOVEA     PTRNAMT       WTrnArr                                      CSW201
     C                   EVAL      Win = *ZERO                                                CSW201
      *                                                                                       CSW201
     C                   DOW       Win <> 16                                                  CSW201
     C                   EVAL      Win = Win + 1                                              CSW201
     C                   IF        WTrnArr(Win) = '.' OR WTrnArr(Win) = ' '                   CSW201
     C                   EVAL      WTrnArr(Win) = '0'                                         CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDDO                                                                CSW201
      *                                                                                       CSW201
     C                   MOVEA     WTrnArr       WTrnAmt                                      CSW201
      *                                                                                       CSW201
      ** If Transfer Amount is zero, entry to Original                                        CSW201
      ** Amount or Original Currency is prohibited                                            CSW201
      *                                                                                       CSW201
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   IF        WTrnAmt = *ZEROS AND PTOOAMT <> *BLANKS AND                CSW207
     C                             PINSCA4 <> 'EQUI' AND PINSCB4 <> 'EQUI' AND                CSW207
     C                             PINSCC4 <> 'EQUI' AND PINSCD4 <> 'EQUI' AND                CSW207
     C                             PINSCE4 <> 'EQUI'                                          CSW207
     C                   EVAL      OKORAM = 'N'                                               CSW207
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW207
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0939'                                  CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WTrnAmt = *ZEROS AND PTOOAMT = *BLANKS AND                 CSW207
     C                             (PINSCA4 = 'EQUI' OR PINSCB4 = 'EQUI' OR                   CSW207
     C                             PINSCC4 = 'EQUI' OR PINSCD4 = 'EQUI' OR                    CSW207
     C                             PINSCE4 = 'EQUI')                                          CSW207
     C                   EVAL      OKORAM = 'N'                                               CSW207
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW207
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0938'                                  CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WTrnAmt = *ZEROS AND PTOCCY <> *BLANKS AND                 CSW207
     C                             PINSCA4 <> 'EQUI' AND PINSCB4 <> 'EQUI' AND                CSW207
     C                             PINSCC4 <> 'EQUI' AND PINSCD4 <> 'EQUI' AND                CSW207
     C                             PINSCE4 <> 'EQUI'                                          CSW207
     C                   EVAL      OKORCY = 'N'                                               CSW207
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW207
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0942'                                  CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WTrnAmt = *ZEROS AND PTOCCY = *BLANKS AND                  CSW207
     C                             (PINSCA4 = 'EQUI' OR PINSCB4 = 'EQUI' OR                   CSW207
     C                             PINSCC4 = 'EQUI' OR PINSCD4 = 'EQUI' OR                    CSW207
     C                             PINSCE4 = 'EQUI')                                          CSW207
     C                   EVAL      OKORCY = 'N'                                               CSW207
     C                   EVAL      Idx = Idx + 1                                              CSW207
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW207
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0943'                                  CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
     C                   IF        WTrnAmt = *ZEROS AND PTOOAMT <> *BLANKS                    CSW201
     C                   EVAL      OKORAM = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0502'                                  CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        WTrnAmt = *ZEROS AND PTOCCY <> *BLANKS                     CSW201
     C                   EVAL      OKORCY = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0503'                                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW201
     C                   IF        OKORAM = 'N' OR OKORCY = 'N'                               CSW201
     C                   GOTO      EndValidate                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      *
      ** If Original Amount is not entered, Original Ccy cannot be entered
     C                   IF        PTOOAMT = *Blanks AND PTOCCY <> *Blanks
     C                   MOVE      'N'           OKORCY
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0160'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If Original Ccy is not entered, Original Amount cannot be entered
     C                   IF        PTOCCY = *Blanks AND PTOOAMT <> *Blanks
     C                   MOVE      'N'           OKORAM
     C                   ADD       1             Idx
     C                   MOVEL     'PTOOAMT'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0163'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
      ** If entered, Original Currency must be valid on the system
     C                   IF        PTOCCY <> *Blanks
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PTOCCY        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVE      'N'           OKORCY
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0161'     MsgIdXAr(Idx)
     C                   ELSE
     C                   EVAL      PTOCCY = A6CYCD
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** N.B. Only validate Original Amount if currency valid - to
      **      avoid database errors.
     C                   IF        Idx = 0
      *
      ** If Original Amount entered it must be in valid format for the ccy.
     C                   IF        PTOOAMT <> *Blanks
      *
      ** Format amount field and ZADIG
     C                   MOVE (P)  PTOOAMT       ZFIELD                         ************
     C                   EVAL      ZADIG = 15 - A6NBDP                          ************
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKORAM
     C                   ADD       1             Idx
     C                   MOVEL     'PTOOAMT'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0162'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** If Amount is OK format entry to aprropriate decimal places.
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
 
     C                   MOVE      ZFIELD        PTOOAMT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         ENDSR                                                                CSW201
     C     EndValidate   ENDSR                                                                CSW201
      /EJECT
      *****************************************************************
      *                                                               *
      * ConvAmts - Convert screen fields for Original and Transfer    *
      *            Amounts to numeric (file) format                   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ConvAmts      BEGSR
      *
      ** Obtain Transfer Amount in numeric format
     C                   EVAL      @CCY = PTRNCCY
     C                   EVAL      ZFIELD = *Blanks
     C                   MOVE (P)  PTRNAMT       ZFIELD                         ************
      *
     C                   IF        @CCY <> *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   ENDIF                                                  *** InzEnd ***
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
     C                   PARM      13            ZADIG
      *
     C                   MOVE      ZFIELD        NumTRNAMT
 
      ** Obtain Original Amount in numeric format
     C                   EVAL      @CCY = PTOCCY
     C                   EVAL      ZFIELD = *Blanks
     C*******            MOVE (P)  PTOCCY        ZFIELD                         177811
     C                   MOVE (P)  PTOOAMT       ZFIELD                         177811
      *
     C                   IF        @CCY <> *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   ENDIF                                                  *** InzEnd ***
 
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      PayAmtDP      ZADEC
     C                   PARM      13            ZADIG
      *
     C                   MOVE      ZFIELD        NumORGAMT
 
     C                   ENDSR                                                  *** InzEnd ***
      /EJECT
      *****************************************************************
      *                                                               *
      * ValXRate - Validate Exchange Rate                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     ValXRate      BEGSR
      *
     C                   Select
      *
      ** a) Both Transfer Ccy and Original Ccy are base currency.
     C                   When      PTRNCCY = BJCYCD  and  PTOCCY = BJCYCD
     C                   EVAL      CalcXRATE = 1
      *
      ***b)*Either*Transfer*Ccy*or*Original*Ccy*is*base*currency.******         184259
     C*******************When      PTRNCCY = BJCYCD  or  PTOCCY = BJCYCD        184259
      *******************                                                       184259
     C*******************IF        PTRNCCY = BJCYCD                             184259
     C*******************EVAL      @CCY = PTOCCY                                184259
     C*******************ELSE                                                   184259
     C*******************EVAL      @CCY = PTRNCCY                               184259
     C*******************ENDIF                                                  184259
      *******************                                                       184259
      ***Obtain*details*of*the*non-base*currency***********************         184259
     C*******************IF        @CCY <> *Blanks                              184259
      *******************                                                       184259
     C*******************CALLB     'AOCURRR0'                                   184259
     C*******************PARM      *Blanks       @RTCD                          184259
     C*******************PARM      '*KEY'        @OPTN                          184259
     C*******************PARM                    @CCY                           184259
     C*****SDCURR********PARM      SDCURR        DSFDY                          184259
      *******************                                                       184259
     C*******************ENDIF                                                  184259
      *******************                                                       184259
      ***Exchange*rate*in*this*case*is*(spot*rate*+*sell*spread*rate).*         184259
     C*******************EVAL      CalcXRATE = A6SPRT + A6SLSR                  184259
      *******************                                                       184259
     C*******************IF        CalcXRATE <> *Zeros  AND  A6MDIN = 'D'       184259
     C*******************EVAL      CalcXRATE = (1 / CalcXRATE)                  184259
     C*******************ENDIF                                                  184259
      *                                                                         184259
      ** c) Neither Transfer Ccy or Original Ccy is base currency.              184259
     C                   Other                                                  184259
     C*******************MOVEL     *Blanks       P#NDCY                         184259
     C*******************Z-ADD     *Zeros        P#NDAM                         184259
     C*******************MOVEL     PTRNCCY       P#FRCY                         184259
     C*******************Z-ADD     NumTRNAMT     P#FRAM                         184259
     C*******************Z-ADD     BJRDNB        P#FRDT                         184259
     C*******************MOVEL     PTOCCY        P#TOCY                         184259
     C*******************Z-ADD     NumORGAMT     P#TOAM                         184259
     C*******************Z-ADD     BJRDNB        P#TODT                         184259
     C*******************MOVEL     'N'           P#OVRT                         184259
     C*******************Z-ADD     *Zeros        P#PDAM                         184259
     C*******************Z-ADD     *Zeros        P#RATE                         184259
     C*******************Z-ADD     Wbtpcrd       P#RTDS                         184259
     C*******************MOVEL     'Y'           P#SDIN                         184259
      *******************                                                       184259
     C*******************CALLB     'FT0010'                                     184259
     C*******************PARM                    P#0010                         184259
      *******************                                                       184259
     C*******************EVAL      CalcXRATE = P#RATE                           184259
      *******************                                                       184259
     C*******************IF        CalcXRATE <> *Zeros  AND  P#MDIN = 0         184259
     C*******************EVAL      CalcXRATE = (1 / CalcXRATE)                  184259
     C*******************ENDIF                                                  184259
      *                                                                         184259
     C     NumTRNAMT     DIV(H)    NumORGAMT     CalcXRate                      184259
      *
     C                   ENDSL
      *
     C                   IF        CalcXRATE <> *Zeros
     C                   MOVE (P)  CalcXRATE     ZFIELD
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADECP            2 0
      *
     C                   MOVE      ZFIELD        PXRATE
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   PARM                    OKFlags
 
      ** Access object for Bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 902*
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
      *                                                                                       CSW207
     C                   IF        PRTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
