     H DEBUG
     H DATEDIT(*DMYH)
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Currency Position Update')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCCYPUPD - Currency Position Update                         *
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
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDCURRL1IF   E           K DISK    INFSR(*PSSR)
     FGPCCYPL0  UF A E           K DISK    INFSR(*PSSR)
 
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
      * Incoming/Outgoing
     D OFI             S             15  0 DIM(16)
     D OFO             S             15  0 DIM(16)
 
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
 
 
      /SPACE 5
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUTS
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BRCA            3
     C                   PARM                    I#CCY             3
     C                   PARM                    I#RECN            2 0
      * Position - COB
     C                   PARM                    PCOB             15 0
      * Dates
     C                   PARM                    ODT
      * Incoming/Outgoing
     C                   PARM                    OFI
     C                   PARM                    OFO
 
      * Return if position not 01 or 02.
 
     C     I#RECN        IFNE      01
     C     I#RECN        ANDNE     02
     C                   RETURN
     C                   ENDIF
 
      * Get bank details
 
     C     I#ZONE        IFNE      BJZONE
     C                   EXSR      GET_BANK
     C                   MOVE      *BLANK        X_CCY
     C                   Z-ADD     *zero         X_SPD
     C                   Z-ADD     *zero         X_SPR
     C                   MOVE      *BLANK        X_MDI
     C                   Z-ADD     *zero         X_FCT
     C                   ENDIF
 
      * If zone is available
 
     C     Zone_Avail    IFEQ      'Y'
 
      * Access currency details
 
     C                   EXSR      ACS_CURRDT
 
      * Update positions
 
     C                   EXSR      UPD_POSN
     C                   ENDIF
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Update positions
      *****************************************************************
     C     UPD_POSN      BEGSR
 
     C                   Z-ADD     *ZERO         W_PCOB           15 0
     C                   Z-ADD     *ZERO         W_ODT
     C                   Z-ADD     *ZERO         W_OFI
     C                   Z-ADD     *ZERO         W_OFO
     C                   Z-ADD     *ZERO         W_OII
     C                   Z-ADD     *ZERO         W_OIO
 
      *  Dates
     C                   Z-ADD     ODT           W_ODT
 
      *  Calculate Currency Positions - 01 record
 
     C     I#RECN        IFEQ      01
     C                   Z-ADD     PCOB          W_PCOB
     C                   Z-ADD     OFI           W_OFI
     C                   Z-ADD     OFO           W_OFO
     C                   EXSR      CALC_CCYPOS_01
     C                   ELSE
 
      *  Calculate Currency Positions - 02 record
 
     C                   Z-ADD     OFI           W_OII
     C                   Z-ADD     OFO           W_OIO
     C                   EXSR      CALC_CCYPOS_02
     C                   END
 
      * Access currency position
 
     C                   MOVEL     I#BRCA        CPBRCA
     C                   MOVEL     I#CCY         CPCCY
     C                   Z-ADD     *ZERO         CPNET
     C                   Z-ADD     *ZERO         CPUMT
     C                   Z-ADD     *ZERO         CPFWD
     C                   Z-ADD     *ZERO         CPINT
 
     C     GPCCYPK       CHAIN     GPCCYPD0                           60        *
 
      *  Update Currency Positions - 01 record
 
     C     I#RECN        IFEQ      01
     C     Net_Posn      DIV(H)    X_FCT(#C)     CPNET
     C     Unmatured_PosnDIV(H)    X_FCT(#C)     CPUMT
     C     Forward_Posn  DIV(H)    X_FCT(#C)     CPFWD
     C                   ENDIF
 
      *  Update Currency Positions - 02 record
 
     C     I#RECN        IFEQ      02
     C     Interest_Posn DIV(H)    X_FCT(#C)     CPINT
     C                   ENDIF
 
      *  Update Position
      *  (NOT under commitment control)
 
     C  N60              UPDATE    GPCCYPD0
     C   60              WRITE     GPCCYPD0
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
 
     C     I#ZONE        CHAIN     GZSDBANKL1                         99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           Zone_Avail        1
     C                   ELSE
     C                   MOVEL     'N'           Zone_Avail
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Currency Details
      *****************************************************************
     C     ACS_CURRDT    BEGSR
 
      * Determine if currency details previously accessed
 
     C                   Z-ADD     1             #C                3 0
     C     I#CCY         LOOKUP    X_CCY(#C)                              99    *
 
      * If not
 
     C     *IN99         IFEQ      *OFF
 
      * Access currency details
 
     C     GZSDCURRK     CHAIN     GZSDCURRL1                         99
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:' + I#CCY
     C                   EXSR      *PSSR
     C                   END
 
      * Store currency details
 
     C                   Z-ADD     1             #C
     C     *BLANK        LOOKUP    X_CCY(#C)                              99    *
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
 
     C                   ENDIF
 
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
 
     C     GZSDCURRK     KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#CCY
     C     GPCCYPK       KLIST
     C                   KFLD                    I#BRCA
     C                   KFLD                    I#CCY
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
