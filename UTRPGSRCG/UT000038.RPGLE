     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UT000022F) TOFILE(UPFFDSTPD)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT ADBU work data for log file')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000038 - ADBU work data for log file                       *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE   Date 17Mar20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     FUT000022F IF   E           K DISK    USROPN
     FUTFLDDL1  IF A E           K DISK
      *
     D MODE            S              1
     D HI              S              1
     D ENTT            S              2
     D #C              S              2  0
     D SCRN            S              1  0
     D OFFS            S              3  0
     D #SEQN           S              3  0
     D #FLDN           S              3  0
     D RRN             S              4  0
     D X               S              3  0
     D Z               S              4  0
     D SAVBUF          S              4  0
     D BYTENM          S              1
     D BINVAL          S             12  0
     D BINVLA          S             12
     D CNT             S              1  0
     D Y               S              4  0
     D FLD             S              1
     D FLD1            S              1
     D SIGN            S              1
     D FLD2            S              1
     D FLD1N           S              1  0
     D CHCK1           S              2  0
     D FLD2N           S              1  0
     D CHCK2           S              2  0
     D BS              S              2  0
     D FLD1A           S              1
     D FLD2A           S              1
     D TOTBVL          S              5  0
     D OUTPUT          S              1  0
     D BIT7CN          S             15  0
     D BIT6CN          S             15  0
     D BIT5CN          S             15  0
     D BIT4CN          S             15  0
     D BIT3CN          S             15  0
     D BIT2CN          S             15  0
     D BIT1CN          S             15  0
     D BIT0CN          S             15  0
     D Library         S             10    INZ('*LIBL     ')
     D Outfile         S             10    INZ('UT000022F ')
     D OutFMbr         S             10    INZ('*FIRST    ')
     D OutFMbrOpt      S              8    INZ('*REPLACE')
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
     D ERR             S             76    DIM(3) CTDATA PERRCD(1)
     D CHR             S              1    DIM(89) CTDATA PERRCD(70)
     D CHV             S              1    DIM(38) CTDATA PERRCD(38)
     D BIT             S              2  0 DIM(16) CTDATA PERRCD(16)
     D ALP             S              1    DIM(16) CTDATA PERRCD(16)
     D UBA             S              1    DIM(4400)
     D UPA             S              1    DIM(4400)
     D AR              S              1    DIM(4400)
     D BLK             S              1    DIM(240)
     D OT              S              1    DIM(240) ASCEND
     D OTB             S              1    DIM(240)
     D OTP             S              1    DIM(240)
     D OTW             S              1    DIM(240)
     D                 DS
     D  SRCDTA                 1     80
     D  S                      1     80
     D                                     DIM(80) ASCEND
     D                 DS
     D  SSDATA                 1     41
     D  DAT                    1     41
     D                                     DIM(41)

     D                 DS
     D  @WHDS                  1    131
     D  @FLDI                  1     10
     D  @FLDB                 11     15
     D  @FLDBn                11     15  0
     D  @FLDD                 16     17
     D  @FLDDn                16     17  0
     D  @FLDP                 18     19
     D  @FLDPn                18     19  0
     D  @FTXT                 20     70
     D  @CHD1                 71     90
     D  @CHD2                 91    110
     D  @CHD3                111    130
     D  @FLDT                131    131
      *
     C                   Z-ADD     17            #C
     C                   BITOFF    '01234567'    HI
     C                   BITON     '267'         HI
     C                   MOVEL     HI            ERR
     C                   EVAL      FDFILE = DSP
      *
     C     FLDDTK        KLIST
     C                   KFLD                    FDFILE
     C                   KFLD                    FDSEQN
     C                   KFLD                    FDFLDN
      *
     C     FLDDTP        KLIST
     C                   KFLD                    FDFILE
      *
     C     *ENTRY        PLIST
     C                   PARM                    FILEX            10
     C                   PARM                    MODE
     C                   PARM                    UBA
     C                   PARM                    UPA
     C                   PARM                    ENTT
     C                   PARM                    DSP              10
     C                   PARM                    LIB1             10
     C                   PARM                    LIB2             10
      *
     C                   Z-ADD     1             SCRN
     C                   Z-ADD     1             OFFS
     C                   EXSR      DETNAR
      *
     C     FLDDTP        CHAIN     UTFLDDD0                           99
     C     *IN99         IFEQ      '1'
     C                   EXSR      DETMSK
     C                   END
      *
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
      *
      ** FLDDAT contains list of fields for file DSPFFD1 (with seq 999 for fields excluded)

     C     FLDDTK        SETLL     UTFLDDD0
     C     FLDDTP        READE     UTFLDDD0                               99    *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     FDSEQN        #SEQN             3 0
     C                   Z-ADD     FDFLDN        #FLDN             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         #SEQN
     C                   Z-ADD     *ZERO         #FLDN
     C                   Z-ADD     *ZERO         FDSEQN
     C                   Z-ADD     *ZERO         FDFLDN
     C                   END
     C*
     C     *IN99         DOWEQ     '0'
     C                   ADD       1             RRN               4 0    04    *
     C                   MOVEA     UBA           AR
     C                   EXSR      DETDAT
     C                   MOVEA     OT            OTB
     C     FDRPGN        IFEQ      'WHFLDI'
     C     DSP           ANDEQ     'DSPFFD1'
     C                   MOVEA     OTB(1)        #FIELD
     C                   ENDIF
     C* UBA
     C* UPA
     C     ENTT          IFNE      'UB'
     C     ENTT          ANDNE     'U1'
     C                   MOVEA     OTB(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(41)

      ** in case of new field (EX), the following info must be collected:
      ** WHFLDI WHFLDB WHFLDD WHFLDP WHFTXT WHCHD1 WHCHD2 WHCHD3 WHFLDT
      ** hence leave only when WHFLDT is met
     C                   SELECT
     C     FDRPGN        WHENEQ    'WHFLDI'
     C                   MOVEA     OTB(1)        @FLDI
     C     FDRPGN        WHENEQ    'WHFLDB'
     C                   MOVEA     OTB(1)        @FLDB
     C     FDRPGN        WHENEQ    'WHFLDD'
     C                   MOVEA     OTB(1)        @FLDD
     C     FDRPGN        WHENEQ    'WHFLDP'
     C                   MOVEA     OTB(1)        @FLDP
     C     FDRPGN        WHENEQ    'WHFTXT'
     C                   MOVEA     OTB(1)        @FTXT
     C     FDRPGN        WHENEQ    'WHCHD1'
     C                   MOVEA     OTB(1)        @CHD1
     C     FDRPGN        WHENEQ    'WHCHD2'
     C                   MOVEA     OTB(1)        @CHD2
     C     FDRPGN        WHENEQ    'WHCHD3'
     C                   MOVEA     OTB(1)        @CHD3
     C     FDRPGN        WHENEQ    'WHFLDT'
     C                   MOVEA     OTB(1)        @FLDT
     C                   ENDSL

     C     ENTT          IFEQ      'EZ'
     C                   EVAL      #NARR = 'Rmv field'
     C                   ELSE
     C                   EVAL      #NARR = 'New field'
     C                   ENDIF
     C*****RPGN          IFEQ      'WHFLDI'
     C     FDRPGN        IFEQ      'WHFLDT'
     C     DSP           ANDEQ     'DSPFFD1'
     C                   CALL      'UT000039'
     C                   PARM                    LIB1             10
     C                   PARM                    LIB2             10
     C                   PARM                    FILEX            10
     C                   PARM                    #FATR             4
     C                   PARM                    #NARR            10
     C                   PARM                    #FIELD           10
     C                   PARM                    FDRPGN
     C                   PARM                    FDDESC
     C                   PARM                    DAT
     C                   PARM                    DSP
     C                   PARM                    @WHDS
     C                   PARM                    LIB1

     C                   CLEAR                   @WHDS
     C                   LEAVE
     C                   ENDIF
     C                   ELSE
     C                   MOVEA     UPA           AR
     C                   EXSR      DETDAT
     C                   MOVEA     OT            OTP
     C                   MOVEA     OT            FLD50            50
     C* COMPARE
     C                   MOVE      '0'           *IN20
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     240
     C     OTB(X)        IFNE      OTP(X)
     C                   MOVE      '1'           *IN20
     C*                  MOVE      '<'           FDDESC
     C                   Z-ADD     241           X
     C                   MOVEA     OTB(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(21)
     C                   MOVEA     OTP(OFFS)     DAT(22)
     C                   If        FDRPGN = 'ATTXT'
     C                   eval      @WHDS = FLD50
     C                   ENDIF
     C                   CALL      'UT000039'
     C                   PARM                    LIB1
     C                   PARM                    LIB2
     C                   PARM                    FILEX            10
     C                   PARM                    #FATR             4
     C                   PARM      *BLANKS       #NARR            10
     C                   PARM                    #FIELD           10
     C                   PARM                    FDRPGN
     C                   PARM                    FDDESC
     C                   PARM                    DAT
     C                   PARM                    DSP
     C                   PARM                    @WHDS
     C                   PARM                    LIB1
     C                   eval      @WHDS = *BLANKS
     C                   ELSE
     C                   ADD       1             X
     C                   END
     C                   END
     C*
     C                   END
     C*
     C     FLDDTP        READE     UTFLDDD0                               99    *
     C                   END

     C                   SETON                                        LR
      *****************************************************************
     C*****************************************************************
     C     DETMSK        BEGSR
      *
     C                   CALL      'UTC000004'
     C                   PARM                    FDFILE
     C                   PARM                    Library
     C                   PARM                    Outfile
     C                   PARM                    OutFMbr
     C                   PARM                    OutFMbrOpt
     C                   IF        *INU7 = *ON and
     C                             *INU8 = *ON
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
     C                   GOTO      ENDFD
     C                   ENDIF
     C                   OPEN      UT000022F
      *
     C                   Z-ADD     1             FDFLDN
     C                   READ      UT000022F                              99
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     WHFLDI        FDRPGN
     C                   Z-ADD     WHIBO         FDBUFF
     C                   Z-ADD     WHFLDB        FDLENG
     C                   Z-ADD     WHFLDD        FDDIGI
     C                   Z-ADD     WHFLDP        FDDECP
     C                   MOVEL     WHFTXT        FDDESC
     C                   MOVEL     WHCHD1        FDCOL1
     C                   MOVEL     WHCHD2        FDCOL2
     C                   MOVEL     WHFLDT        FDTYPE
     C                   Z-ADD     FDFLDN        FDSEQN
     C                   WRITE     UTFLDDD0
     C                   ADD       1             FDFLDN
      *
     C                   READ      UT000022F                              99
     C                   END
      *
     C                   CLOSE     UT000022F
      *
     C     ENDFD         ENDSR
      *****************************************************************
     C     DETDAT        BEGSR
      *
     C     FDBUFF        CABGT     4400          TOOBIG
      *
      * Alpha-numeric.
     C                   Z-ADD     1             Z
     C                   MOVEL     *BLANK        OT
     C                   Z-ADD     FDBUFF        SAVBUF
      *
     C     FDTYPE        IFEQ      'A'
     C     FDTYPE        OREQ      'Z'
     C     FDTYPE        OREQ      'L'
     C                   MOVEA     AR(FDBUFF)    OT(Z)
     C                   ADD       FDLENG        Z
     C                   END
      *
      * Binary.
     C     FDTYPE        IFEQ      'B'
     C                   MOVEA     AR(FDBUFF)    OT(Z)
     C                   ADD       FDLENG        Z
     C                   SUB       1             Z
     C                   MOVEL     OT(Z)         FLD
     C                   MOVE      '1'           BYTENM
     C                   EXSR      BITADD
     C                   Z-ADD     TOTBVL        BINVAL
     C     FDLENG        IFGT      1
     C                   SUB       1             Z
     C                   MOVEL     OT(Z)         FLD
     C                   MOVE      '2'           BYTENM
     C                   EXSR      BITADD
     C                   ADD       TOTBVL        BINVAL
     C                   ENDIF
     C     FDLENG        IFGT      2
     C                   SUB       1             Z
     C                   MOVEL     OT(Z)         FLD
     C                   MOVE      '3'           BYTENM
     C                   EXSR      BITADD
     C                   ADD       TOTBVL        BINVAL
     C                   ENDIF
     C                   MOVE      BINVAL        BINVLA
     C                   MOVEA     BINVLA        OT(1)
     C                   Z-ADD     13            Z
     C                   END
      *
      * Packed.
     C     FDTYPE        IFEQ      'P'
     C                   Z-ADD     *ZERO         CNT
     C                   Z-ADD     *ZERO         Y
     C     Y             DOWLT     FDDIGI
     C                   MOVEA     AR(FDBUFF)    FLD
     C                   EXSR      CONPAC
     C                   MOVE      FLD1          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
     C     Y             IFLT      FDDIGI
     C                   MOVE      FLD2          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
     C                   ELSE
     C                   SUB       1             Z
     C     OT(Z)         IFEQ      *BLANK
     C                   MOVEL     '0'           OT(Z)
     C                   END
     C                   ADD       1             Z
     C                   MOVEL     SIGN          OT(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             FDBUFF
     C                   END
     C                   END
      *
      * Signed.
     C     FDTYPE        IFEQ      'S'
     C                   Z-ADD     *ZERO         CNT
     C                   Z-ADD     *ZERO         Y
     C     Y             DOWLT     FDLENG
     C                   MOVEA     AR(FDBUFF)    FLD
     C                   EXSR      CONSIG
     C                   MOVE      FLD2          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
     C     Y             IFEQ      FDLENG
     C                   SUB       1             Z
     C     OT(Z)         IFEQ      *BLANK
     C                   MOVEL     '0'           OT(Z)
     C                   END
     C                   ADD       1             Z
     C                   MOVEL     SIGN          OT(Z)
     C                   ADD       1             Z
     C                   END
     C                   ADD       1             FDBUFF
     C                   END
     C                   END
      *
     C     Z             IFLE      240
     C                   MOVEA     BLK           OT(Z)
     C                   END
      *
      * Single character field.
     C                   Z-ADD     2             X
     C     *BLANK        LOOKUP    OT(X)                              99
     C  N99*BLANK        LOOKUP    OT(X)                                99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     1             X
     C     OT(1)         LOOKUP    CHV(X)                                 99
     C     *IN99         IFEQ      '0'
     C                   EXSR      INVCHR
     C                   END
     C                   ELSE
      * Valid characters.
     C                   Z-ADD     1             Y
     C     OT(1)         LOOKUP    CHR(Y)                                 99
     C     *IN99         IFEQ      '0'
     C                   MOVEA     OT            OTW
     C                   MOVEA     *BLANK        OT
     C                   MOVEA     OTW(3)        OT
     C                   END
     C                   END
      *
     C                   Z-ADD     SAVBUF        FDBUFF
      *
     C     TOOBIG        TAG
     C                   ENDSR
      *****************************************************************
     C     CONPAC        BEGSR
      *
     C                   EXSR      BITSET
      *
     C     CHCK1         IFLE      9
     C                   MOVEL     FLD1N         FLD1
     C                   ELSE
     C                   MOVEL     '*'           FLD1
     C                   END
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     *BLANK        SIGN
     C                   MOVEL     FLD2N         FLD2
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C     CHCK2         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   END
     C                   END
     C*
     C     FLD1          IFEQ      '0'
     C     CNT           ANDEQ     *ZERO
     C                   MOVEL     *BLANK        FLD1
     C                   ELSE
     C                   Z-ADD     1             CNT
     C                   END
     C*
     C     FLD2          IFEQ      '0'
     C     CNT           ANDEQ     *ZERO
     C                   MOVEL     *BLANK        FLD2
     C                   ELSE
     C                   Z-ADD     1             CNT
     C                   END
      *
     C     PENDE         ENDSR
      *****************************************************************
     C     CONSIG        BEGSR
     C                   EXSR      BITSET
      *
     C     CHCK1         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   END
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     FLD2N         FLD2
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C                   END
      *
     C     SENDE         ENDSR
      *****************************************************************
     C     DETNAR        BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
     C     INVCHR        BEGSR
      *
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     *ZERO         Y
     C                   MOVEA     OT            OTW
     C                   MOVEA     *BLANK        OT
     C                   Z-ADD     1             Z
     C                   MOVEL     'x'           OT(Z)
     C     Z             DOUEQ     240
     C     X             IFGE      FDLENG
     C                   Z-ADD     240           Z
     C                   ELSE
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   MOVEL     OTW(Y)        FLD
     C                   EXSR      BITSET
     C                   ADD       1             Z
     C                   MOVEL     FLD1A         OT(Z)
     C     Z             IFLT      240
     C                   ADD       1             Z
     C                   MOVEL     FLD2A         OT(Z)
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C     BITSET        BEGSR
     C                   Z-ADD     *ZERO         FLD1N
     C                   Z-ADD     *ZERO         CHCK1
     C                   Z-ADD     *ZERO         FLD2N
     C                   Z-ADD     *ZERO         CHCK2
      *
     C                   TESTB     '0'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD1N
     C                   ADD       8             CHCK1
     C                   END
      *
     C                   TESTB     '1'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD1N
     C                   ADD       4             CHCK1
     C                   END
      *
     C                   TESTB     '2'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD1N
     C                   ADD       2             CHCK1
     C                   END
      *
     C                   TESTB     '3'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD1N
     C                   ADD       1             CHCK1
     C                   END
      *
     C                   TESTB     '4'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD2N
     C                   ADD       8             CHCK2
     C                   END
      *
     C                   TESTB     '5'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD2N
     C                   ADD       4             CHCK2
     C                   END
      *
     C                   TESTB     '6'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD2N
     C                   ADD       2             CHCK2
     C                   END
      *
     C                   TESTB     '7'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD2N
     C                   ADD       1             CHCK2
     C                   END
      *
     C                   Z-ADD     1             BS
     C     CHCK1         LOOKUP    BIT(BS)                                99
     C                   MOVEL     ALP(BS)       FLD1A
     C                   Z-ADD     1             BS
     C     CHCK2         LOOKUP    BIT(BS)                                99
     C                   MOVEL     ALP(BS)       FLD2A
      *
     C                   ENDSR
      *****************************************************************
     C     BITADD        BEGSR
     C                   Z-ADD     *ZERO         TOTBVL
      *
     C     BYTENM        IFEQ      '1'
     C                   Z-ADD     1             BIT7CN
     C                   Z-ADD     2             BIT6CN
     C                   Z-ADD     4             BIT5CN
     C                   Z-ADD     8             BIT4CN
     C                   Z-ADD     16            BIT3CN
     C                   Z-ADD     32            BIT2CN
     C                   Z-ADD     64            BIT1CN
     C                   Z-ADD     128           BIT0CN
     C                   ELSE
     C     BYTENM        IFEQ      '2'
     C                   Z-ADD     256           BIT7CN
     C                   Z-ADD     512           BIT6CN
     C                   Z-ADD     1024          BIT5CN
     C                   Z-ADD     2048          BIT4CN
     C                   Z-ADD     4096          BIT3CN
     C                   Z-ADD     8192          BIT2CN
     C                   Z-ADD     16304         BIT1CN
     C                   Z-ADD     32768         BIT0CN
     C                   ELSE
     C                   Z-ADD     65536         BIT7CN
     C                   Z-ADD     131072        BIT6CN
     C                   Z-ADD     262144        BIT5CN
     C                   Z-ADD     524288        BIT4CN
     C                   Z-ADD     1048576       BIT3CN
     C                   Z-ADD     2097152       BIT2CN
     C                   Z-ADD     4194304       BIT1CN
     C                   Z-ADD     8388608       BIT0CN
     C                   ENDIF
     C                   ENDIF
      *
     C                   TESTB     '0'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT0CN        TOTBVL
     C                   END
      *
     C                   TESTB     '1'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT1CN        TOTBVL
     C                   END
      *
     C                   TESTB     '2'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT2CN        TOTBVL
     C                   END
      *
     C                   TESTB     '3'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT3CN        TOTBVL
     C                   END
      *
     C                   TESTB     '4'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT4CN        TOTBVL
     C                   END
      *
     C                   TESTB     '5'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT5CN        TOTBVL
     C                   END
      *
     C                   TESTB     '6'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT6CN        TOTBVL
     C                   END
      *
     C                   TESTB     '7'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       BIT7CN        TOTBVL
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
** ERR
 End of file
 Start of file
 Error - unable to display fields of file.
** CHR
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|"$¢%&'()=~-¬@!;:
#,./+*<>?0123456789
** CHV
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*
** BIT
00010203040506070809101112131415
** ALP
0123456789ABCDEF
