     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas EM Update I/C Exposure for Nxt Days TF Trans')   *
      *****************************************************************
      *                                                               *
      *  Midas - Exposure Management Module                           *
      *                                                               *
      *  EM000001 - Midas EM Update Input Cycle Exposure Files for    *
      *             Next Day's Trade Finance Transactions             *
      *                                                               *
      *  Function:  This program will update the opening TI exposures *
      *             from Account Transfer events falling on or before *
      *             the next working day. This processing is          *
      *             equivalent to that which occurs for the other     *
      *             forward transactions from the Dealing, Lending,   *
      *             etc. modules (EM0700).                            *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI007  *CREATE    Date 31Mar14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
/*    *  CTI007 - Trade Finance BF Midas 2.2 Exposure Management      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess   - Process Account Transfer Transaction           *
      *  SRCalcExp   - Calculate the Exposure Amount                  *
      *  SRUpdate    - Update the Necessary Tables                    *
      *  SRScale     - Subroutine to Scale Amount                     *
      *  *INZSR      - Initialisation Subroutine                      *
      *  *PSSR       - Program Exception Subroutine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLATMIL9  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Transfer Manual Input
 
     FEMEXSCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas EM Exposure Scaling File
 
     FEMTFEXL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas EM Detail Transactions Key
 
     FEMTFCBL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas EM Trade Finance Customer Balances
 
     FEMTFSAL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas EM Sub-limit Totals
 
     FEMTFSLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas EM Sub-Limit Types
 
     FEMCEX     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(EMCEXX1F:EMCEXX3F)
      ** Midas EM Input Cycle Exposure File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Power array for currency conversion
     D POWER           S              7  0 DIM(7) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** Scaling arrays
     D PER             S              5  0 DIM(6) ASCEND
     D PCT             S              3  0 DIM(6) ASCEND
 
      ** Data structure for access objects, first DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for access objects, second DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Exposure Management data
     D SDEXPM        E DS                  EXTNAME(SDEXPMPD)
 
      ** External DS for Currency data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Account Codes data
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Internal DS for EM0010 entry parameter
     DP#0010           DS           256
     D P#NDCY                  1      3
     D P#NDAM                  4     10P 0
     D P#DBCY                 11     13
     D P#DBAM                 14     20P 0
     D P#DBDT                 21     23P 0
     D P#CRCY                 24     26
     D P#CRAM                 27     33P 0
     D P#PDCY                 34     36
     D P#PDAM                 37     43P 0
     D P#CRDT                 44     46P 0
     D P#RATE                 47     53P 8
     D P#MDIN                 54     54  0
     D P#OVRT                 55     55
     D P#SDIN                 56     56
     D P#RTDS                 57     59P 4
      *
     D P#FRCY                 11     13
     D P#FRAM                 14     20P 0
     D P#FRDT                 21     23P 0
     D P#TOCY                 24     26
     D P#TOAM                 27     33P 0
     D P#TODT                 44     46P 0
      *
     D P#PMSQ                 60     69
     D P#INDC                 70     74
     D P#RTCD                 75     81
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter fields
     D PRtCd           S              7A
     D POption         S              7A
     D PCcy            S              3A
     D PAcod           S             10A
 
      ** Work Variables
     D NBDPBU          S              1  0
     D M               S              1  0
     D WRun            S              1A
     D WCNUM           S              6A
     D WCCY            S              3A
     D WACOD           S             10  0
     D WAMNT           S             15P 0
     D WVDAT           S              5P 0
     D WDCIN           S              1A
     D WEXAMT          S             15P 0
     D WWAMNT          S             15  0
     D W1AMNT          S             15  0
     D @DELTP          S              2A
     D @SCAMT          S             13  0
     D @TDATE          S              5  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process all live record in Accounts Transfer table
 
     C     *LOVAL        SETLL     GLATMIL9
     C                   READ      GLATMIL9
 
     C                   DOW       NOT %EOF(GLATMIL9)
 
      ** Process debit side of account transfer transaction
 
     C                   EVAL      WCNUM = R1DBCU
     C                   EVAL      WCCY  = R1DBCY
     C                   EVAL      WACOD = R1DBAC
     C                   EVAL      WAMNT = R1DAMT
     C                   EVAL      WVDAT = R1DRVL
     C                   EVAL      WDCIN = 'D'
     C                   EXSR      SRProcess
 
      ** Process credit side of account transfer transaction
 
     C                   EVAL      WCNUM = R1CRCU
     C                   EVAL      WCCY  = R1CRCY
     C                   EVAL      WACOD = R1CRAC
     C                   EVAL      WAMNT = R1CAMT
     C                   EVAL      WVDAT = R1CRVL
     C                   EVAL      WDCIN = 'C'
     C                   EXSR      SRProcess
 
     C                   READ      GLATMIL9
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Account Transfer Transaction             *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Process only transactions which are due on the next working day
 
     C                   IF        WVDAT <= BJDNWD
 
     C                   MOVEL     WACOD         PAcod
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcod
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Process only Trade Finance Accounts
 
     C                   IF        A5TFCT = 'Y'
 
      ** Calculate the exposure amount
     C                   EXSR      SRCalcExp
 
      ** Update necessary tables
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcExp - Calculate the Exposure Amount                    *
      *                                                               *
      *****************************************************************
     C     SRCalcExp     BEGSR
 
     C                   EVAL      WEXAMT = 0
     C                   EVAL      WWAMNT = 0
     C                   EVAL      W1AMNT = 0
 
      ** If the account currency is not the same as the exposure
      ** management currency, convert the event amount into
      ** exposure management currency
 
     C                   IF        WCCY   = BUCYCD
     C                   EVAL      WWAMNT = WAMNT
     C                   ELSE
     C                   CLEAR                   P#0010
     C                   EVAL      P#FRDT = WVDAT
     C                   EVAL      P#TODT = WVDAT
     C                   EVAL      P#FRCY = WCCY
     C                   EVAL      P#TOCY = BUCYCD
     C                   EVAL      P#FRAM = WAMNT
     C                   EVAL      P#TOAM = 0
     C                   EVAL      P#RATE = 0
 
      ** Validate and calculate currencies
 
     C                   CALL      'EM0010'
     C                   PARM                    P#0010
 
     C                   IF        P#RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'EM0010  '
     C                   EVAL      DBKey  = *BLANKS
     C                   EVAL      DBase  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WWAMNT = P#TOAM
     C                   ENDIF
 
     C                   EVAL      M      = NBDPBU + 1
     C                   EVAL      WEXAMT = WWAMNT / POWER(M)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Necessary Tables                           *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Divide the event amount by the number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      WCCY          PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOCURRR0'
     C                   EVAL      DBKey  = WCCY
     C                   EVAL      DBase  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      M      = A6NBDP + 1
     C                   EVAL      W1AMNT = WAMNT / POWER(M)
 
     C                   IF        WDCIN  = 'C'
     C                   EVAL      WEXAMT = WEXAMT * -1
     C                   ENDIF
 
     ** Update PF/EMTFEXPD EM Details Transactions Key
 
     C     K_TFEX        CHAIN     EMTFEXL0                           99
     C                   IF        *IN99 = '1'
     C                   EVAL      EXCNUM = WCNUM
     C                   EVAL      EXACNO = WACOD
     C                   EVAL      EXTRNS = R1TREF
     C                   EVAL      EXCURR = WCCY
     C                   EVAL      EXUAMT = W1AMNT
     C                   EVAL      EXVDTE = WVDAT
     C                   EVAL      EXDRCR = WDCIN
     C                   EVAL      EXRDTE = R1INDT
     C                   WRITE     EMTFEX
     C                   ELSE
     C                   EVAL      EXCURR = WCCY
     C                   EVAL      EXUAMT = W1AMNT
     C                   EVAL      EXVDTE = WVDAT
     C                   EVAL      EXDRCR = WDCIN
     C                   EVAL      EXRDTE = R1INDT
     C                   UPDATE    EMTFEX
     C                   ENDIF
 
     ** Update PF/EMTFCBPD EM Tarde Finance Customer Balances
 
     C     K_TFCB        CHAIN     EMTFCBL0                           99
     C                   IF        *IN99 = '1'
     C                   EVAL      CBCUST = WCNUM
     C                   EVAL      CBACNO = WACOD
     C                   EVAL      CBLIM  = *ZEROS
     C                   EVAL      CBSCL  = *BLANKS
     C                   EVAL      CBOFFB = *ZEROS
     C                   EVAL      CBEXP  = WEXAMT
     C                   WRITE     EMTFCB
     C                   ELSE
      ** If the customer sub-limit weighting factor exists, scale the amount
 
     C                   IF        CBSCL <> *BLANKS
     C                   EVAL      @DELTP = CBSCL
     C                   Z-ADD     WEXAMT        @SCAMT
     C                   EVAL      @TDATE = *ZEROS
     C                   EXSR      SRScale
     C                   Z-ADD     @SCAMT        WEXAMT
     C                   ENDIF
 
     C                   EVAL      CBEXP  = CBEXP + WEXAMT
     C                   UPDATE    EMTFCB
     C                   ENDIF
 
     ** Update PF/EMTFSAPD EM Sub-limit Totals
 
     C     WACOD         CHAIN     EMTFSAL1                           99
     C                   IF        *IN99 = '1'
     C                   EVAL      SAACOD = WACOD
     C                   EVAL      SATYPE = '#'
     C                   EVAL      SALIM  = *ZEROS
     C                   EVAL      SAOFFA = *ZEROS
     C                   EVAL      SAEXP  = WEXAMT
     C                   WRITE     EMTFSA
     C                   ELSE
     C                   EVAL      SAEXP  = SAEXP + WEXAMT
     C                   UPDATE    EMTFSA
     C                   ENDIF
 
     ** Update PF/EMTFSLPD EM Sub-limit Types
 
     C     SATYPE        CHAIN     EMTFSLL0                           99
     C                   IF        *IN99 = '1'
     C                   IF        SATYPE = '#'
     C                   EVAL      SLTYPE = SATYPE
     C                   EVAL      SLDESC = 'UNKNOWN'
     C                   EVAL      SLEXP  = WEXAMT
     C                   WRITE     EMTFSL
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SLEXP  = SLEXP + WEXAMT
     C                   UPDATE    EMTFSL
     C                   ENDIF
 
     ** Update PF/EMCEXX2 EM Input Cycle Exposure File
 
     C     WCNUM         CHAIN     EMCEX                              99
     C                   IF        *IN99 = '1' OR
     C                             RECI <> 'D'
     C                   EVAL      RECI  = *BLANKS
     C                   EVAL      MCUNA = *BLANKS
     C                   EVAL      MFXE  = *ZEROS
     C                   EVAL      MFXB  = *ZEROS
     C                   EVAL      MMME  = *ZEROS
     C                   EVAL      MMMB  = *ZEROS
     C                   EVAL      MLEG  = *ZEROS
     C                   EVAL      MLEE  = *ZEROS
     C                   EVAL      MLEB  = *ZEROS
     C                   EVAL      MLAE  = *ZEROS
     C                   EVAL      MLAB  = *ZEROS
     C                   EVAL      MREG  = *ZEROS
     C                   EVAL      MREE  = *ZEROS
     C                   EVAL      MREB  = *ZEROS
     C                   EVAL      MFRE  = *ZEROS
     C                   EVAL      MFRO  = *ZEROS
     C                   EVAL      ZZ008 = *BLANKS
     C                   EVAL      MSTE  = *ZEROS
     C                   EVAL      MSTB  = *ZEROS
     C                   EVAL      MSIE  = *ZEROS
     C                   EVAL      MSCE  = *ZEROS
     C                   EVAL      MSPO  = *ZEROS
     C                   EVAL      LCD   = *ZEROS
     C                   EVAL      CHTP  = *BLANKS
     C                   EVAL      MXPT  = *ZEROS
     C                   EVAL      MIRE  = *ZEROS
     C                   EVAL      MIRO  = *ZEROS
     C                   EVAL      MFUE  = *ZEROS
     C                   EVAL      MFUO  = *ZEROS
     C                   EVAL      MOPE  = *ZEROS
     C                   EVAL      MOPO  = *ZEROS
     C                   EVAL      TFEX  = *ZEROS
     C                   EVAL      TFGR  = *ZEROS
     C                   EVAL      TFOF  = *ZEROS
     C                   ENDIF
 
     C                   EVAL      RECI  = 'D'
     C                   EVAL      MCUNA = WCNUM
     C                   EVAL      LCD   = BJRDNB
 
     C                   IF        *IN99 = '1'
     C                   EVAL      CHTP  = 'I'
     C                   EVAL      TFEX  = WEXAMT
     C                   WRITE     EMCEXX2F
     C                   ELSE
     C                   EVAL      CHTP  = 'A'
     C                   EVAL      TFEX  = TFEX + WEXAMT
     C                   UPDATE    EMCEXX2F
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScale - Subroutine to Scale Amount                         *
      *                                                               *
      *****************************************************************
     C     SRScale       BEGSR
 
     C     @DELTP        CHAIN     EMEXSCL1                           90
 
      ** If record found, or scaling type not equal to N.(Otherwise
      ** the amount is ignored in these calcs and is not scaled.
     C                   IF        *IN90 = '0' AND
     C                             EKSCTY <> 'N'
 
      ** If scaling type = I (Interpolation)
     C                   IF        EKSCTY = 'I'
     C                   MOVE      'N'           @SFLAG            1
 
      ** If 'TO DATE' <= First period(EKPRD1) then scaling factor is
      ** the first percentage factor(EKPR1P).
     C                   IF        @TDATE <= EKPRD1
     C                   Z-ADD     EKPR1P        @SCLGF
     C                   EVAL      @SFLAG = 'Y'
     C                   ENDIF
 
      ** If 'TO DATE' >= second period(EKPRD2) then scaling factor is
      ** the second percentage factor(EKPR2P).
     C                   IF        @TDATE >= EKPRD2
     C                   Z-ADD     EKPR2P        @SCLGF
     C                   EVAL      @SFLAG = 'Y'
     C                   ENDIF
 
     ** If neither of the above two, do calculations
     C                   IF        @SFLAG = 'N'
     C     @TDATE        SUB       EKPRD1        @WRK1             5 0
     C     EKPRD2        SUB       EKPRD1        @WRK2             5 0
     C     @WRK1         DIV       @WRK2         @WRK3            11 5
     C     EKPR2P        SUB       EKPR1P        @WRK4             3 0
     C     @WRK3         MULT      @WRK4         @WRK5             7 4
     C     @WRK5         ADD(H)    EKPR1P        @SCLGF            7 3
     C                   ENDIF
     C                   ENDIF
 
      ** If scaling type = T (Threshold) or = B (Tiered),
      ** fill-up period array
     C                   IF        EKSCTY = 'T' OR
     C                             EKSCTY = 'B'
     C                   Z-ADD     EKPRD1        PER(1)
     C                   Z-ADD     EKPRD2        PER(2)
     C                   Z-ADD     EKPRD3        PER(3)
     C                   Z-ADD     EKPRD4        PER(4)
     C                   Z-ADD     EKPRD5        PER(5)
     C                   Z-ADD     EKPRD6        PER(6)
     C                   Z-ADD     EKPR1P        PCT(1)
     C                   Z-ADD     EKPR2P        PCT(2)
     C                   Z-ADD     EKPR3P        PCT(3)
     C                   Z-ADD     EKPR4P        PCT(4)
     C                   Z-ADD     EKPR5P        PCT(5)
     C                   Z-ADD     EKPR6P        PCT(6)
     C                   ENDIF
 
      ** Find scaling percentage (Threshold)
     C                   IF        EKSCTY = 'T'
 
      ** Find period end equal to or higher than 'TO DATE'
     C                   Z-ADD     1             @@C               1 0
     C     @TDATE        LOOKUP    PER(@@C)                           66
 
     ** Move the corresponding percentage into the scaling flag field
     C                   MOVEA     PCT(@@C)      @WRK4
     C                   Z-ADD     @WRK4         @SCLGF
     C                   ENDIF
 
     **Find scaling percentage (Tiered)
     C                   IF        EKSCTY = 'B'
 
     ** Find period end equal to or higher than 'TO DATE'
     C                   Z-ADD     1             @@C
     C     @TDATE        LOOKUP    PER(@@C)                           66
 
     ** Add the percentages up to and including the corresponding
     ** band in which the TO DATE was situated.
     C                   Z-ADD     *ZERO         @WRK4
     C                   Z-ADD     1             @D                1 0
     C     @D            DOUGT     @@C
     C                   ADD       PCT(@D)       @WRK4
     C                   ADD       1             @D
     C                   ENDDO
 
     C                   Z-ADD     @WRK4         @SCLGF
     C                   ENDIF
 
     ** Calculate scaled exposure
     C     @SCLGF        MULT      @SCAMT        @SCAMT
     C     @SCAMT        DIV       100           @SCAMT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOBANKR0'
     C                   EVAL      DBKey  = POption
     C                   EVAL      DBase  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access exposure management data
 
     C                   CALL      'AOEXPMR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDEXPM        PARM      SDEXPM        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOEXPMR0'
     C                   EVAL      DBKey  = POption
     C                   EVAL      DBase  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access exposure currency details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POption
     C                   PARM      BUCYCD        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOCURRR0'
     C                   EVAL      DBKey  = BUCYCD
     C                   EVAL      DBase  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      NBDPBU = A6NBDP
 
     C     K_TFEX        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WACOD
     C                   KFLD                    R1TREF
 
     C     K_TFCB        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WACOD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun  = *BLANK
     C                   EVAL      WRun  = 'Y'
     C                   EVAL      DBPGM = 'EM000001'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
