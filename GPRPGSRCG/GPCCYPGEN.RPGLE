     H DEBUG
     H DATEDIT(*DMYH)
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Currency Position Generation')                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCCYPGEN - Currency Position Generation                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239642             Date 01Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  239642 - If RNX1021 (duplicate key) is encountered due to    *
      *           slow machine response, retry execution of GPCCYPGEN.*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDBRCHL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCURRL1IF   E           K DISK    INFSR(*PSSR)
     FGZOLPOSL0 IF   F  400     6AIDISK    INFSR(*PSSR) KEYLOC(2)
     F***GPCCYPL0  UF A E           K DISK    INFSR(*PSSR)                                    239642
     FGPCCYPL0  UF A E           K DISK    INFSR(FILSR)                                       239642
 
      *    Currency
     D X_CCY           S              3    DIM(150) ASCEND
      *    Spot Days
     D X_SPD           S              2  0 DIM(150)
      *    Spot rate
     D X_SPR           S             15  8 DIM(150)
      *    Mutliply/Divide Indicator
     D X_MDI           S              1    DIM(150)
      *    Factors
     D X_FCT           S              7  0 DIM(150)
 
 
      * IN DATA
      * -------
      *  Dates
     D ODT             S              5  0 DIM(19)
      *  Foreign Exchange
     D OFI             S             15  0 DIM(16)
     D OFO             S             15  0 DIM(16)
      *  Interest
     D OII             S             15  0 DIM(16)
     D OIO             S             15  0 DIM(16)
 
      * WORK DATA
      * ---------
      *  Dates
     D W_ODT           S              5  0 DIM(16)
      *  Foreign Exchange
     D W_OFI           S             15  0 DIM(16)
     D W_OFO           S             15  0 DIM(16)
      *  Interest
     D W_OII           S             15  0 DIM(16)
     D W_OIO           S             15  0 DIM(16)
 
     D W_DIFF          S             15  0 DIM(16)
 
      * OUT DATA
      * --------
     D O_NET           S             12  0 DIM(999)
     D O_UMT           S             12  0 DIM(999)
     D O_FWD           S             12  0 DIM(999)
     D O_INT           S             12  0 DIM(999)
 
 
      /SPACE 5
 
      **   Positions File
     IGZOLPOSL0 NS  01    1 CD    5 C0    6 C1
     I         OR   02    1 CD    5 C0    6 C2
     I                                  1    1  RECI
     I                                  2    4  CCY
     I                                  5    6 0RECN
     I                             P    7   14 0PCOB
     I                             P   15   62  ODT
      **   Foreign Exchange Position Values.
     I                             P   63  190  OFI
     I                             P  191  318  OFO
      **   Interest Position Values.
     I                             P   63  190  OII
     I                             P  191  318  OIO
      **   Catchall
     I          NS
      *****************************************************************
      /SPACE 5
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
 
      * If one zone required
 
     C     I#ZONE        IFNE      *BLANK
 
      * Read branches in zone
 
     C     GZSDBRCHK     SETLL     SDBRCHD0
     C     GZSDBRCHK     READE     SDBRCHD0                               99
 
      * For each branch
     C     *IN99         DOWEQ     *OFF
 
      * Extract
     C                   EXSR      EXTRACT
 
      * Read next branch in zone
     C     GZSDBRCHK     READE     SDBRCHD0                               99
     C                   ENDDO
 
     C                   ELSE
 
      * If all zones required
 
      * Read all branches
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               99
 
      * For each branch
     C     *IN99         DOWEQ     *OFF
 
      * Extract
     C                   EXSR      EXTRACT
 
      * Read next branch
     C                   READ      SDBRCHD0                               99
     C                   ENDDO
 
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Extract
      *****************************************************************
     C     EXTRACT       BEGSR
 
      * Remove existing currency positions for this branch
 
     C                   EXSR      REMOVE_CCYP
 
      * Get bank details
 
     C                   EXSR      GET_BANK
 
      * If zone is available
 
     C     Zone_Avail    IFEQ      'Y'
 
      * Load currency details
 
     C                   EXSR      LOAD_CURRDT
 
      * Update positions for this branch
 
     C                   EXSR      UPD_POSN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Remove existing currency positions for this branch
      *****************************************************************
     C     REMOVE_CCYP   BEGSR
 
     C     GPCCYPK       SETLL     GPCCYPD0
     C     GPCCYPK       READE     GPCCYPD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPCCYPD0
     C     GPCCYPK       READE     GPCCYPD0                               99
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update positions for this branch
      *****************************************************************
     C     UPD_POSN      BEGSR
 
      *  Reset Indicators and Work Arrays
 
     C                   MOVE      'N'           RecordRead        1
     C                   MOVE      *BLANK        P_CCY             3
 
     C                   Z-ADD     *ZERO         W_PCOB           15 0
     C                   Z-ADD     *ZERO         W_ODT
     C                   Z-ADD     *ZERO         W_OFI
     C                   Z-ADD     *ZERO         W_OFO
     C                   Z-ADD     *ZERO         W_OII
     C                   Z-ADD     *ZERO         W_OIO
 
     C                   Z-ADD     *ZERO         O_NET
     C                   Z-ADD     *ZERO         O_UMT
     C                   Z-ADD     *ZERO         O_FWD
     C                   Z-ADD     *ZERO         O_INT
 
     C     A8BRCD        SETLL     GZOLPOSL0
 
     C     *IN42         DOUEQ     '1'
 
     C                   MOVEA     '00'          *IN(01)
 
     C     A8BRCD        READE     GZOLPOSL0                              42
 
      *  At end of file
      *   Calculate Currency Positions
 
     C     *IN42         IFEQ      '1'
     C     RecordRead    ANDEQ     'Y'
     C                   Z-ADD     1             #C
     C     P_CCY         LOOKUP    X_CCY(#C)                              99
     C                   EXSR      CALC_CCYPOS_01
     C                   EXSR      CALC_CCYPOS_02
     C     Net_Posn      DIV(H)    X_FCT(#C)     O_NET(#C)
     C     Unmatured_PosnDIV(H)    X_FCT(#C)     O_UMT(#C)
     C     Forward_Posn  DIV(H)    X_FCT(#C)     O_FWD(#C)
     C     Interest_Posn DIV(H)    X_FCT(#C)     O_INT(#C)
     C                   END
 
      *  Process Only '01/02' Positions Records
 
     C     *IN01         IFEQ      '1'
     C     *IN02         OREQ      '1'
 
      *  On change of currency
      *   Calculate Currency Positions
 
     C     CCY           IFNE      P_CCY
     C     RecordRead    ANDEQ     'Y'
     C                   Z-ADD     1             #C
     C     P_CCY         LOOKUP    X_CCY(#C)                              99
     C                   EXSR      CALC_CCYPOS_01
     C                   EXSR      CALC_CCYPOS_02
     C     Net_Posn      DIV(H)    X_FCT(#C)     O_NET(#C)
     C     Unmatured_PosnDIV(H)    X_FCT(#C)     O_UMT(#C)
     C     Forward_Posn  DIV(H)    X_FCT(#C)     O_FWD(#C)
     C     Interest_Posn DIV(H)    X_FCT(#C)     O_INT(#C)
     C                   Z-ADD     *ZERO         W_PCOB
     C                   Z-ADD     *ZERO         W_ODT
     C                   Z-ADD     *ZERO         W_OFI
     C                   Z-ADD     *ZERO         W_OFO
     C                   Z-ADD     *ZERO         W_OII
     C                   Z-ADD     *ZERO         W_OIO
     C                   ENDIF
 
     C                   MOVE      CCY           P_CCY
 
      *  Dates
     C                   Z-ADD     ODT           W_ODT
 
      *  Update work data
 
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     PCOB          W_PCOB
     C                   Z-ADD     OFI           W_OFI
     C                   Z-ADD     OFO           W_OFO
     C                   ELSE
     C                   Z-ADD     OII           W_OII
     C                   Z-ADD     OIO           W_OIO
     C                   END
 
     C                   MOVE      'Y'           RecordRead
      *
     C                   END
      *
     C                   END
 
      *  At End Of File Write Positions
      *  ------------------------------
 
     C                   DO        CurrencyCount Y                 3 0
     C                   MOVE      A8BRCD        CPBRCA
     C                   MOVE      X_CCY(Y)      CPCCY
     C                   MOVE      O_NET(Y)      CPNET
     C                   MOVE      O_UMT(Y)      CPUMT
     C                   MOVE      O_FWD(Y)      CPFWD
     C                   MOVE      O_INT(Y)      CPINT
     C                   WRITE     GPCCYPD0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate Currency Positions - 01 record
      *****************************************************************
     C     CALC_CCYPOS_01BEGSR
 
      * Net Position
      * ------------
 
     C                   Z-ADD     W_PCOB        Net_Posn         15 0
 
      * Unmatured Spot Position
      * -----------------------
 
     C                   Z-ADD     0             Z                 2 0
     C     *IN66         DOUEQ     '0'
     C                   ADD       1             Z
     C     W_ODT(Z)      COMP      BJRDNB                               66
 
      *  LOOP UNTIL Z HAS REACHED 16
 
     C   66Z             COMP      16                                   66
     C                   END
 
     C                   SETOFF                                       66
     C                   Z-ADD     0             ZZ                2 0
     C     *IN66         DOUEQ     '0'
     C                   ADD       1             ZZ
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     X_SPD(#C)     ZNRDYS
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANK        ZLOC
     C                   EXSR      FWDT
 
     C     W_ODT(ZZ)     COMP      ZDYNBR                               66
     C   66ZZ            COMP      16                                   66
     C                   END
 
     C                   Z-ADD     *ZERO         W#OFI            15 0
     C                   Z-ADD     *ZERO         W#OFO            15 0
     C     Z             DO        ZZ            Z0                2 0
     C                   ADD       W_OFI(Z0)     W#OFI
     C                   ADD       W_OFO(Z0)     W#OFO
     C                   END
 
     C     W#OFI         SUB       W#OFO         Unmatured_Posn   15 0
 
      *  Forward Position
      *  ----------------
 
     C     W_OFI         SUB       W_OFO         W_DIFF
     C                   XFOOT     W_DIFF        WORK15           15 0
 
     C     WORK15        SUB       Unmatured_PosnForward_Posn     15 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Calculate Currency Positions - 02 record
      *****************************************************************
     C     CALC_CCYPOS_02BEGSR
 
      *  Interest Position
      *  -----------------
 
     C     W_OII         SUB       W_OIO         W_DIFF
     C                   XFOOT     W_DIFF        Interest_Posn    15 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Get bank details for zone
      *****************************************************************
     C     GET_BANK      BEGSR
 
     C     A8ZONE        CHAIN     SDBANKD0                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           Zone_Avail        1
     C                   ELSE
     C                   MOVEL     'N'           Zone_Avail
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Load Currency Details
      *****************************************************************
     C     LOAD_CURRDT   BEGSR
 
     C                   MOVE      *BLANK        X_CCY
     C                   Z-ADD     *zero         X_SPD
     C                   Z-ADD     *zero         X_SPR
     C                   MOVE      *BLANK        X_MDI
     C                   Z-ADD     *zero         X_FCT
 
     C                   Z-ADD     0             #C                3 0
 
      *  Read All Records In The Currency Code File And Build
      *  Program Arrays Of Currency/Spot Rate and Factor.
 
     C     A8ZONE        SETLL     GZSDCURRL1
     C     *IN40         DOUEQ     '1'
     C     A8ZONE        READE     GZSDCURRL1                             40
 
     C     *IN40         IFEQ      '0'
     C     A6DLCI        ANDEQ     'Y'
 
     C                   ADD       1             #C
     C                   MOVE      A6CYCD        X_CCY(#C)
 
      * Spot days
     C                   Z-ADD     A6SPDY        X_SPD(#C)
 
     C     A6NBDP        COMP      1                                    5051
     C     A6NBDP        COMP      2                                  53  52
 
      * Spot rate
     C   50              Z-ADD     A6SPRT        X_SPR(#C)
     C     A6MDIN        IFEQ      'M'
     C   51A6SPRT        DIV       10            X_SPR(#C)
     C   52A6SPRT        DIV       100           X_SPR(#C)
     C   53A6SPRT        DIV       1000          X_SPR(#C)
     C                   ELSE
     C   51A6SPRT        MULT      10            X_SPR(#C)
     C   52A6SPRT        MULT      100           X_SPR(#C)
     C   53A6SPRT        MULT      1000          X_SPR(#C)
     C                   END
 
      * Mult/Div
     C                   MOVE      A6MDIN        X_MDI(#C)
 
      * Factor
     C   50              Z-ADD     1000          X_FCT(#C)
     C   51              Z-ADD     10000         X_FCT(#C)
     C   52              Z-ADD     100000        X_FCT(#C)
     C   53              Z-ADD     1000000       X_FCT(#C)
     C                   END
     C                   ENDDO
 
     C                   Z-ADD     #C            CurrencyCount     3 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Calculate Working Days Forward
      *****************************************************************
     C     FWDT          BEGSR
     C                   CALLB     'GPFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      * Key lists
 
     C     GZSDBRCHK     KLIST
     C                   KFLD                    I#ZONE
     C     GPCCYPK       KLIST
     C                   KFLD                    A8BRCD
     C                   ENDSR
      ********************************************************************                    239642
      * FILSR - Subroutine to catch I/O exceptions of GPCCYPL0.          *                    239642
      ********************************************************************                    239642
     C     FILSR         BEGSR                                                                239642
     C                   IF        %STATUS = 01021                                            239642
     C                   SETON                                        U5                      239642
     C                   ENDIF                                                                239642
     C                   EXSR      *PSSR                                                      239642
     C                   ENDSR                                                                239642
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
