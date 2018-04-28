     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Prices Retrieve')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Market Price API                 *
      *                                                               *
      *  FFMPRIRTV - MIDAS FF MARKET PRICES DETAILS RETRIEVE          *
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Market center.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10387R (Reopen) Date 07Feb06               *
      *                 BUG10387           Date 06Feb06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BUG10387R - Checks Market Code even if OTC (Reopen)          *
      *  BUG10387 - Checks Market Code even if OTC                    *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPRICS     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
     FPRICS2    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICSDF:PRICSD3)
     F                                     PREFIX(X)
     F                                     USROPN
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID an¢ *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Error indicators
     D OKTrnDets     E DS                  EXTNAME(FFEMPRIPD)
 
      ** New Transaction Detail in File Format
     D NwMnFilFmt    E DS                  EXTNAME(FFVMPRIPD)
 
      ** External DS for bank details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Market Prices Details in File Format
     D TranFilFmt    E DS                  EXTNAME(PRICSD) PREFIX(@)
 
      ** Market control details
     D MarketCont    E DS                  EXTNAME(MKCTLD) PREFIX(M)
 
      ** Market centre details
     D MarketCent    E DS                  EXTNAME(MARKT)  PREFIX(MK)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Market centre details
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D    SARLCD     E                     EXTFLD(LCD)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** DS for market prices key
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PPRSTRP         S             15P 8
 
      ** Define variable for switchable CSC011.
     D CSC011          S              1A   INZ('N')
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** 13,0S and 1,0S field for passing to FFVSTRKPR
     D***Zero13S         S             13S 0 INZ(0)                                         BUG10387
     D Zero13S         S             13P 0 INZ(0)                                           BUG10387
     D Zero1S          S              1S 0 INZ(0)
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** OK flag variables
 
      ** Flags
     D POTCFlag        S              1A
                                                                                            BUG10387
      ** Market Code                                                                        BUG10387
                                                                                            BUG10387
     D PPRMRKT         S                   LIKE(PRMRKT)                                     BUG10387
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      INIT
 
     C                   IF        PSCRN = 'A' OR PSCRN = 'K' OR PSCRN = 'X'
 
      ** Validate Market Centre code
 
     C                   EXSR      VALMRKT
 
     C                   IF        PSCRN = 'A'
     C                   CLOSE     PRICS
     C                   CLOSE     PRICS2
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT' AND (PSCRN = 'K'
     C                             OR PSCRN = 'R')
     C                   EXSR      VFRNT
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N'
     C                   CLOSE     PRICS
     C                   CLOSE     PRICS2
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code
 
     C                   IF        PSCRN = 'K' OR PSCRN = 'R' OR
     C                             PSCRN = 'P'
 
     C                   EXSR      VAL
 
     C                   IF        OKACTN = 'Y' AND (PSCRN = 'K' OR
     C                             PSCRN = 'R' OR PSCRN = 'P')
     C                   EXSR      VALKEYFLD
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR OKISTC = 'N' OR
     C                             OKYEAR = 'N' OR OKMTHN = 'N' OR
     C                             OKPCAL = 'N' OR OKSTRP = 'N'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **-----------------------------------------------*
      ** Access Security Checking                      *
      **-----------------------------------------------*
 
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN = DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C*                  EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        OKACTN = 'N' OR OKISTC = 'N' OR
     C                             OKMTHN = 'N' OR OKYEAR = 'N' OR
     C                             OKPCAL = 'N' OR OKSTRP = 'N'
     C                   CLOSE     PRICS
     C                   CLOSE     PRICS2
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PSCRN = 'K' OR PSCRN = 'R' OR
     C                             PSCRN = 'P' OR PSCRN = 'U'
 
      **--------------------------------*
      ** Validation for Action Code 'I' *
      **--------------------------------*
     C                   IF        DDACTN = 'I' AND (PSCRN = 'K' OR
     C                             PSCRN = 'R')
     C                   EXSR      VALACI
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'E' *
      **--------------------------------*
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVMRKT
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'A' *
      **--------------------------------*
 
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVMRKT
     C                   ENDIF
 
      **--------------------------------*
      ** Validation for Action Code 'D' *
      **--------------------------------*
 
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVMRKT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
 
      ** Check user's authority for the action.
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
 
      ** Check user's authority for the action & Booking Branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      ** Access Transaction from the Transactions file
 
     C                   EVAL      KISTT = PRISTT
     C                   MOVE      PRYRNO        KYRNO
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   EVAL      KMTHN = 01
     C                   WHEN      PRMTHN = 'FEB'
     C                   EVAL      KMTHN = 02
     C                   WHEN      PRMTHN = 'MAR'
     C                   EVAL      KMTHN = 03
     C                   WHEN      PRMTHN = 'APR'
     C                   EVAL      KMTHN = 04
     C                   WHEN      PRMTHN = 'MAY'
     C                   EVAL      KMTHN = 05
     C                   WHEN      PRMTHN = 'JUN'
     C                   EVAL      KMTHN = 06
     C                   WHEN      PRMTHN = 'JUL'
     C                   EVAL      KMTHN = 07
     C                   WHEN      PRMTHN = 'AUG'
     C                   EVAL      KMTHN = 08
     C                   WHEN      PRMTHN = 'SEP'
     C                   EVAL      KMTHN = 09
     C                   WHEN      PRMTHN = 'OCT'
     C                   EVAL      KMTHN = 10
     C                   WHEN      PRMTHN = 'NOV'
     C                   EVAL      KMTHN = 11
     C                   WHEN      PRMTHN = 'DEC'
     C                   EVAL      KMTHN  = 12
     C                   ENDSL
 
     C                   EVAL      KPCAL = PRPCAL
     C                   EVAL      KSTRP = PPRSTRP
 
     C     KPRICS        CHAIN     PRICS
 
     C                   IF        %FOUND(PRICS) AND RECI = 'D'
     C                   EVAL      OKISTC = 'N'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYEAR = 'N'
     C                   EVAL      OKPCAL = 'N'
     C                   EVAL      OKSTRP = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDISTC'      FldNameArr(Ix)
     C                   MOVEL     'MMA2102'     MsgIdArr(Ix)
     C                   ENDIF
 
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      * RTVMRKT - RETRIEVE MARKET PRICE DETAIL IF ACTION CODE 'A', 'E' OR 'D'
      **********************************************************************
     C     RTVMRKT       BEGSR
 
      ** The front office can send us both Front Office ID and transaction ID;
      ** When the RTV is called in the back office the transaction ID must be valid
 
     C                   IF        (PRISTT <> *BLANK AND PRYRNO <> *ZERO
     C                             AND PRMTHN <> *ZEROS AND SubForISTT = 0)
     C                             OR ModeofOp <> '*FRONT'
 
     C                   EVAL      KISTT = PRISTT
     C                   MOVE      PRYRNO        KYRNO
 
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   EVAL      KMTHN = 01
     C                   WHEN      PRMTHN = 'FEB'
     C                   EVAL      KMTHN = 02
     C                   WHEN      PRMTHN = 'MAR'
     C                   EVAL      KMTHN = 03
     C                   WHEN      PRMTHN = 'APR'
     C                   EVAL      KMTHN = 04
     C                   WHEN      PRMTHN = 'MAY'
     C                   EVAL      KMTHN = 05
     C                   WHEN      PRMTHN = 'JUN'
     C                   EVAL      KMTHN = 06
     C                   WHEN      PRMTHN = 'JUL'
     C                   EVAL      KMTHN = 07
     C                   WHEN      PRMTHN = 'AUG'
     C                   EVAL      KMTHN = 08
     C                   WHEN      PRMTHN = 'SEP'
     C                   EVAL      KMTHN = 09
     C                   WHEN      PRMTHN = 'OCT'
     C                   EVAL      KMTHN = 10
     C                   WHEN      PRMTHN = 'NOV'
     C                   EVAL      KMTHN = 11
     C                   WHEN      PRMTHN = 'DEC'
     C                   EVAL      KMTHN  = 12
     C                   ENDSL
 
     C                   EVAL      KPCAL = PRPCAL
     C                   EVAL      KSTRP = PPRSTRP
 
     C     KPRICS        CHAIN     PRICS
 
     C                   IF        PSCRN = 'K' OR PSCRN = 'R' OR PSCRN = 'U'
     C                   IF        (NOT %FOUND(PRICS) OR (%FOUND(PRICS)
     C                             AND RECI = '*')) AND (DDACTN = 'A' OR
     C                             DDACTN = 'D')
     C                   EVAL      OKISTC = 'N'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYEAR = 'N'
     C                   EVAL      OKPCAL = 'N'
     C                   EVAL      OKSTRP = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDISTC'      FldNameArr(Ix)
     C                   MOVEL     'MMA2103'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   IF        DDACTN = 'E' AND NOT %FOUND(PRICS)
     C                   EVAL      OKISTC = 'N'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYEAR = 'N'
     C                   EVAL      OKPCAL = 'N'
     C                   EVAL      OKSTRP = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDISTC'      FldNameArr(Ix)
     C                   MOVEL     'MMA2104'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        %FOUND(PRICS) AND OKISTC = 'Y' AND
     C                             OKMTHN = 'Y' AND OKYEAR = 'Y' AND
     C                             OKPCAL = 'Y' AND OKSTRP = 'Y'
     C                   EVAL      @RECI = RECI
     C                   EVAL      @ISTT = ISTT
     C                   EVAL      @YRNO = YRNO
     C                   EVAL      @MTHN = MTHN
     C                   EVAL      @PCAL = PCAL
     C                   EVAL      @STRP = STRP
     C                   EVAL      @NEWP = NEWP
     C                   EVAL      @PLEC = PLEC
     C                   EVAL      @PBEC = PBEC
     C                   EVAL      @PRSM = PRSM
     C                   EVAL      @RSKF = RSKF
     C                   EVAL      @LCD  = LCD
     C                   EVAL      @CHTP = CHTP
     C                   EVAL      @TNLU = TNLU
     C                   EVAL      @FRNT = FRNT
     C                   EVAL      @AFRT = AFRT
     C                   EVAL      @REPA = REPA
     C                   EVAL      @TMST = TMST
 
     C                   ENDIF
     C                   ENDIF
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      ** ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2100'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     FOTRID        CHAIN     PRICS2
 
      ** If Insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        %FOUND(PRICS2)
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        NOT %FOUND(PRICS2)
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALMRKT - VALIDATION OF MARKET CENTRE CODE
      *****************************************************************
     C     VALMRKT       BEGSR
 
      ** Market Centre
 
     C                   IF        PRMRKT <> *BLANKS
 
     C                   IF        POTCFlag <> 'Y'
 
     C                   EXSR      MarkDets
 
     C                   ELSE
 
     C                   EVAL      %SUBST(@ISTT:1:2) = PRMRKT
 
     C                   ENDIF
 
     C                   ENDIF
 
 
 
     C                   IF        PSCRN = 'X'
     C                   EVAL      PSCRN = 'K'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE
      *****************************************************************
     C     VAL           BEGSR
 
     C                   IF        PSCRN = 'K'
 
      ** Action Code validation
 
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> ' '
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2100'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   IF        OKACTN = 'Y' AND PSCRN = 'K'
     C                   IF        (PRISTC <> *BLANKS OR PRMTHN <> *BLANKS
     C                             OR PRYRNO <> *BLANKS OR PRPCAL <> *BLANK
     C                             OR PRSTRP <> *BLANKS) AND DDACTN = *BLANKS
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2105'     MsgIdArr(Ix)
     C                   ELSE
 
     C                   IF        DDACTN <> *BLANKS AND PRISTC = *BLANKS
     C                             AND PRMTHN = *BLANKS AND PRYRNO = *BLANKS
     C                             AND PRPCAL = *BLANK AND PRSTRP = *BLANKS
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA2101'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALKEYFLD - Validate the key field entries
      *****************************************************************
     C     VALKEYFLD     BEGSR
 
     C                   IF        DDACTN <> *BLANK OR
     C                             PRISTC <> *BLANKS OR PRMTHN <> *BLANKS
     C                             OR PRYRNO <> *BLANK OR PRPCAL <> *BLANK
     C                             OR PRSTRP <> *BLANKS
 
      ** Instrument Type
 
     C                   CALLB     'FFVMPMKIN'
 
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
      ** The instrument types format (data strucure)
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
     C                   PARM      *BLANKS       InstTypes
 
      ** Inputs to called procedure
      ** --------------------------
      ** Instrument type (3A, from transaction)
      ** Market I.D. (2A, from transaction)
 
     C                   PARM                    PRISTC
     C                   PARM                    PRMRKT
     C                   PARM                    POTCFlag
 
     C                   IF        ReturnCode <> *BLANKS
     C                   EVAL      OKISTC = 'N'
     C                   EXSR      UpdateErrs
     C                   ELSE
     C                   EVAL      %SUBST(@ISTT:3:3)  = PRISTC
     C                   ENDIF
 
     C                   IF        PSCRN = 'K'
 
     C                   IF        POTCFlag <> 'Y'
 
      ** Month and Year
 
     C                   CALLB     'FFVMPYRMO'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
      ** Numeric (file) version of month number
      ** Numeric (file) version of year number
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
     C                   PARM                    DVMTHN
     C                   PARM                    DVYRNO
      ** Input/output
      ** ------------
      ** OK flags
     C                   PARM                    OKTrnDets
      ** Inputs to called procedure
      ** --------------------------
      ** Month number (3A, from transaction)
      ** Year number (2A, from transaction)
      ** Current trading date
      ** Run date format (1A, from SDBANKPD)
      ** The instrument types format (data strucure)
     C                   PARM                    PRMTHN
     C                   PARM                    PRYRNO
     C                   PARM                    CTDATE
     C                   PARM                    BJDFIN
     C                   PARM                    InstTypes
 
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      UpdateErrs
     c                   ELSE
     C                   EVAL      @YRNO = DVYRNO
     C                   EVAL      @MTHN = DVMTHN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Put/Call
 
      ** Only validate if instrument was ok, as otherwise ISPT won't be
      ** set up.
     C                   IF        OKISTC <> 'N'
 
     C                   CALLB     'FFVMPPCAL'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Put/call indicator (1A, from transaction)
      ** Instrument processing type (1,0S, from INTYPD)
     C                   PARM                    PRPCAL
     C                   PARM                    ITISPT
 
 
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      OKPCAL = 'N'
     C                   EXSR      UpdateErrs
     C                   ELSE
     C                   EVAL      @PCAL = PRPCAL
     C                   ENDIF
 
     C                   ENDIF
 
      ** Strike price
 
      ** Only validate if instrument was ok, as otherwise INTYPD fields
      ** won't be set up.
     C                   IF        OKISTC <> 'N'
                                                                                            BUG10387
     C                   IF        POTCFlag <> 'Y'                                          BUG10387
     C                   EVAL      PPRMRKT = PRMRKT                                         BUG10387
     C                   ELSE                                                               BUG10387
     C                   EVAL      PPRMRKT = *BLANKS                                        BUG10387
     C                   ENDIF                                                              BUG10387
 
     C                   CALLB     'FFVMPSTRP'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
      ** Field name array
      ** Error message ID array
      ** Error message data array
      ** Numeric (file) version of strike price
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
     C                   PARM      *ZERO         DVSTRP
 
      ** Inputs to called procedure
      ** --------------------------
      ** Strike price (16A, from transaction)
      ** The INTYPD format (several fields required by calld module)
      ** Market (2A, from transaction)
      ** Counter amount (13,0S, from transaction - not applicable for
      ** exchange-traded transactions)
      ** Delivery amount (13,0S, from transaction - not applicable for
      ** exchange-traded transactions)
      ** Counter currency decimal places (1,0P, from currencies file -
      ** not applicable for exchange-traded transactions)
      ** Delivery currency decimal places (1,0P, from currencies file -
      ** not applicable for exchange-traded transactions)
     C                   PARM                    PRSTRP
     C                   PARM                    InstTypes
     C**********         PARM                    PRMRKT                                     BUG10387
     C                   PARM                    PPRMRKT                                    BUG10387
     C                   PARM                    Zero13S
     C                   PARM                    Zero13S
     C                   PARM                    Zero1S
     C                   PARM                    Zero1S
 
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      OKSTRP = 'N'
     C                   EXSR      UpdateErrs
     C                   EVAL      PPRSTRP = *ZERO
     C                   ELSE
     C                   EVAL      PPRSTRP = DVSTRP
     C                   EVAL      @STRP   = DVSTRP
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MarkDets - Get Market details
      *****************************************************************
     C     MarkDets      BEGSR
 
      ** Get market details and market control
 
     C                   CALLB     'FFVMPMRKT'
 
      ** Outputs
 
     C                   PARM                    ReturnCode
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
     C                   PARM      *BLANKS       MarketCont
     C                   PARM      *BLANKS       MarketCent
 
      ** Inputs
 
     C                   PARM                    PRMRKT
     C                   PARM      'I'           DDACTN2           1
 
 
      ** If error(s) found, add deatails to the main arrays.
 
     C                   IF        ReturnCode <> *Blanks
 
     C                   EXSR      UpdateErrs
 
     C                   EVAL      OKMRKT = 'N'
 
     C                   ELSE
 
     C                   EVAL      PMKTN = MKMKTN
     C                   EVAL      %SUBST(@ISTT:1:2)  = PRMRKT
 
     C                   EXSR      GetCTDate
     C
     C                   IF        CTDATE = *ZERO
     C                   EVAL      PBUSD = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = CTDATE
     C                   EXSR      ZDATE2
     C                   EVAL      PBUSD = *BLANKS
     C                   MOVEL     ZADATE        PBUSD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PRMRKT = *BLANKS AND PSCRN <> 'X'
     C                   EVAL      PRMRKT = 'ST'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetCTDate - Determine the current trading date                *
      *                                                               *
      *****************************************************************
 
     C     GetCTDate     BEGSR
 
      ** Set up the current trading date
      ** -------------------------------
      ** MBUSD is from MKCTL and BJRDNB is from SDBANKPD
 
     C                   IF        MBUSD = 0
     C                   EVAL      CTDATE = BJRDNB
      *
      ** If 24x7 Midas availability is installed and user is in support
      ** system, set the trading date to the processing date held in
      ** dtaara SC24X7
      *
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EVAL      CTDATE = S1DATE
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CTDATE = MBUSD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UpdateErrs - Update Errors
      *****************************************************************
     C     UpdateErrs    BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APAPNDARRS'
 
      ** Outputs from called procedure
      ** =============================
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Error array index
 
     C                   PARM                    Ix
 
      ** Field names with errors array
 
     C                   PARM                    FldNameArr
 
      ** Error message ID array
 
     C                   PARM                    MsgIDArr
 
      ** Error message data array
 
     C                   PARM                    MsgDtaArr
 
      ** Warning array index
 
     C                   PARM                    WIdx
 
      ** Field names with warnings array
 
     C                   PARM                    WFldNamArr
 
      ** Warning message ID array
 
     C                   PARM                    WMsgIDArr
 
      ** Warning message data array
 
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** ==========================
      ** Field name array
 
     C                   PARM                    FldNamXArr
 
      ** Error message ID array
 
     C                   PARM                    MsgIDXArr
 
      ** Error message data array
 
     C                   PARM                    MsgDtaXArr
 
      ** Field name array
 
     C                   PARM                    FldNamWArr
 
      ** Warning message ID array
 
     C                   PARM                    MsgIDWArr
 
      ** Warning message data array
 
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      ** Open Files
     C                   OPEN      PRICS
     C                   OPEN      PRICS2
 
      ** Clear Outputs
 
     C                   CLEAR                   TranFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKMRKT = 'Y'
     C                   EVAL      OKISTC = 'Y'
     C                   EVAL      OKYEAR = 'Y'
     C                   EVAL      OKMTHN = 'Y'
     C                   EVAL      OKPCAL = 'Y'
     C                   EVAL      OKSTRP = 'Y'
     C                   EVAL      OKNEWP = 'Y'
     C                   EVAL      OKNWPI = 'Y'
     C                   EVAL      OKRSKF = 'Y'
 
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
 
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      PRISTT        SubForISTT        2 0
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp          6
 
      ** Response mode
 
     C                   PARM                    RespMode          1
 
      ** Action Code
 
     C                   PARM                    DDACTN            1
 
      ** Front Office Transaction ID
 
     C                   PARM                    FOTRID           20
 
      ** Transaction Number
 
     C                   PARM                    PRTRNN
 
      ** A = First retrieve, K = second retrieve, R = third retrieve
 
     C                   PARM                    PSCRN             1
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      ** Outputs
      ** =======
      ** Transaction Details in File Format
 
     C                   PARM                    TranFilFmt
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Market Name
 
     C                   PARM                    PMKTN            20
 
      ** Business Date in 99MON99 format
 
     C                   PARM                    PBUSD             7
 
      ** Valid instrument types
 
     C                   PARM                    InstTypes
 
      ** Numeric strike price
 
     C                   PARM                    PPRSTRP
 
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'FFMPRIRTV'
 
      **  GET RUNDAT to access MULTI-BRANCHING flag.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Determine if 24x7 Midas availability is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'CSC011'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
 
      ** Key List
 
     C     KPRICS        KLIST
     C                   KFLD                    KISTT             5
     C                   KFLD                    KYRNO             2 0
     C                   KFLD                    KMTHN             2 0
     C                   KFLD                    KPCAL             1
     C                   KFLD                    KSTRP            15 8
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
