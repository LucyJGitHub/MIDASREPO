     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UT000022F) TOFILE(UPFFDSTPD)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Produce report for CMPF')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000023 - Display field description for CMPF                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27790 *CREATE   Date 02Jul10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FUTCMPFPD  IP   E             DISK
     FUTFLDDL1  IF   E           K DISK
     FUT000023P1O    F  132        PRINTER USROPN
      *
     D CHLINE          S              2  0
     D FieldHEAD       S              1
     D FLD_Befor       S             40
     D FLD_After       S             40
     D Z               S              4  0
     D X               S              3  0
     D SAVBUF          S              4  0
     D BYTENM          S              1
     D BINVAL          S             12  0
     D BINVLA          S             12
     D CNT             S              1  0
     D Y               S              4  0
     D FLD             S              1
     D FLD1            S              1
     D FLD2            S              1
     D SIGN            S              1
     D FLD1N           S              1  0
     D FLD2N           S              1  0
     D CHCK1           S              2  0
     D CHCK2           S              2  0
     D BS              S              2  0
     D FLD1A           S              1
     D FLD2A           S              1
     D #C              S              3  0
     D TOTBVL          S              5  0
     D BIT7CN          S             15  0
     D BIT6CN          S             15  0
     D BIT5CN          S             15  0
     D BIT4CN          S             15  0
     D BIT3CN          S             15  0
     D BIT2CN          S             15  0
     D BIT1CN          S             15  0
     D BIT0CN          S             15  0
     D Print_OPEN      S              1
     D PTFile          S             10
     D PKFile          S             10
     D PKeyFlds        S            120
     D PDspNoDif       S              4
     D PRptFldNo       S              1
     D LINENO          S              3  0
     D PAGNUM          S              5  0
     D SSTYPE          S             10
     D SSRRN1          S              8
     D SSRRN2          S              8
     D SSDATA          S             78
     D #X              S              3  0
     D #RFN            S              1  0
     D #FN             S              2  0
     D ZFIELD          S             16
     D ZADEC           S              1  0
      *
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
      *
     D                 DS
     D  SRCDTA                 1     80
     D  S                      1     80
     D                                     DIM(80) ASCEND
     D                 DS
     D  DATA                   1     41
     D  DAT                    1     41
     D                                     DIM(41)
 
     D #RPGN           S             10A   DIM(999)
     D #BUFF           S              4S 0 DIM(999)
     D #LENG           S              4S 0 DIM(999)
     D #DIGI           S              4S 0 DIM(999)
     D #DECP           S              1S 0 DIM(999)
     D #DESC           S             30A   DIM(999)
     D #TYPE           S              1A   DIM(999)
     D #KEY            S              1A   DIM(999)
 
     D                 DS
     D W#KFLD                  1    120
     D I#KEY1                  1     10
     D I#KEY2                 11     20
     D I#KEY3                 21     30
     D I#KEY4                 31     40
     D I#KEY5                 41     50
     D I#KEY6                 51     60
     D I#KEY7                 61     70
     D I#KEY8                 71     80
     D I#KEY9                 81     90
     D I#KEYA                 91    100
     D I#KEYB                101    110
     D I#KEYC                111    120
      *
     C                   IF        CFTYPE = 'U2' or
     C                             CFTYPE = 'M2' or
     C                             CFTYPE = 'EX'
      *
     C                   EXSR      FMT_DTLS
      *
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    SPLIT
      *
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    DETS
      *
     C                   MOVEA     CFDATA        UPA
     C                   EXSR      LIST_FLDS
      *
     C                   ENDIF
 
     C                   MOVE      *BLANK        UBA
     C                   IF        CFTYPE = 'U1'
     C                   MOVEA     CFDATA        UBA
     C                   ENDIF
 
     C                   SETON                                        20
 
     CLRN20PDspNoDif     CABNE     '*YES'        NOREP
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    SPLIT
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDREP
     CLR   NOREP         TAG
      *****************************************************************
     C     LIST_FLDS     BEGSR
 
     C                   MOVE      *BLANK        FieldHEAD
     C                   Z-ADD     0             #X
      *
     C     #X            DOWLT     #C
     C                   ADD       1             #X
      *
     C                   MOVEL     #RPGN(#X)     FDRPGN
     C                   Z-ADD     #BUFF(#X)     FDBUFF
     C                   Z-ADD     #LENG(#X)     FDLENG
     C                   Z-ADD     #DIGI(#X)     FDDIGI
     C                   Z-ADD     #DECP(#X)     FDDECP
     C                   MOVEL     #DESC(#X)     FDDESC
     C                   MOVE      #TYPE(#X)     FDTYPE
      * UBA
     C                   MOVEA     UBA           AR
     C                   EXSR      DETDAT
     C                   MOVEA     OT            OTB
      * UPA
     C                   MOVEA     UPA           AR
     C                   EXSR      DETDAT
     C                   MOVEA     OT            OTP
      * COMPARE
     C                   MOVE      '0'           *IN20
     C                   IF        CFTYPE = 'U2'
     C                   Z-ADD     1             X
     C     X             DOUGT     240
     C     OTB(X)        IFNE      OTP(X)
     C                   MOVE      '1'           *IN20
     C                   MOVE      '<<'          FDDESC
     C                   Z-ADD     241           X
     C                   ELSE
     C                   ADD       1             X
     C                   END
     C                   ENDDO
     C                   END
      * OUTPUT
     C                   IF        *IN20 = '1' or
     C                             #KEY(#X) = 'Y' or
     C                             PRptFldNo = 'A'
      *
     C                   IF        FieldHEAD <> 'Y'
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    STRFLDS
     C                   MOVE      'Y'           FieldHEAD
     C                   ENDIF
      *
     C                   MOVE      *BLANK        FLD_Befor
     C                   MOVE      *BLANK        FLD_After
     C                   IF        CFTYPE = 'U2' or
     C                             CFTYPE = 'M2'
     C                   MOVEA     OTB           FLD_Befor
     C                   MOVEA     OTP           FLD_After
     C                   ELSE
     C                   IF        CFTYPE = 'EX' and
     C                             CFFIL1 <> *BLANK
     C                   MOVEA     OTP           FLD_Befor
     C                   ELSE
     C                   MOVEA     OTP           FLD_After
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   EXCEPT    FLDS
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
     C********************************************************************
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
     C                   MOVEL     OT(Z)         FLD                            * NUMB 1 BYTE
     C                   MOVE      '1'           BYTENM
     C                   EXSR      BITADD
     C                   Z-ADD     TOTBVL        BINVAL
     C     FDLENG        IFGT      1
     C                   SUB       1             Z
     C                   MOVEL     OT(Z)         FLD                            * NUMB 2 BYTE
     C                   MOVE      '2'           BYTENM
     C                   EXSR      BITADD
     C                   ADD       TOTBVL        BINVAL
     C                   ENDIF
     C     FDLENG        IFGT      2
     C                   SUB       1             Z
     C                   MOVEL     OT(Z)         FLD                            * NUMB 3 BYTE
     C                   MOVE      '3'           BYTENM
     C                   EXSR      BITADD
     C                   ADD       TOTBVL        BINVAL
     C                   ENDIF
     C                   MOVE      BINVAL        BINVLA           12
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
      *
     C     FLD1          IFEQ      '0'
     C     CNT           ANDEQ     *ZERO
     C                   MOVEL     *BLANK        FLD1
     C                   ELSE
     C                   Z-ADD     1             CNT
     C                   END
      *
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
      *
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
      *****************************************************************
     C     FMT_DTLS      BEGSR
      * Type
     C     CFTYPE        IFEQ      'U2'
     C                   EVAL      SSTYPE = 'Difference'
     C                   ELSE
     C     CFTYPE        IFEQ      'M2'
     C                   EVAL      SSTYPE = 'Match'
     C                   ELSE
     C     CFFIL1        IFNE      *BLANK
     C                   EVAL      SSTYPE = 'File1 only'
     C                   ELSE
     C                   EVAL      SSTYPE = 'File2 only'
     C                   END
     C                   END
     C                   END
      *
     C     CFRRN1        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      CFRRN1        ZFIELD
     C                   Z-ADD     10            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSRRN1
     C                   ELSE
     C                   MOVE      *BLANKS       SSRRN1
     C                   END
      *
     C     CFRRN2        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      CFRRN2        ZFIELD
     C                   Z-ADD     10            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SSRRN2
     C                   ELSE
     C                   MOVE      *BLANKS       SSRRN2
     C                   END
      *
     C                   MOVEL     CFDATA        SSDATA
      *
     C                   ENDSR
      *****************************************************************
     C     ZEDIT         BEGSR
      *
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   ENDSR
      *****************************************************************
     C     PAG           BEGSR
      *
     C                   IF        Print_OPEN <> 'Y'
     C                   OPEN      UT000023P1
     C                   MOVE      'Y'           Print_OPEN
     C                   ENDIF
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     2             ADD       CHLINE        LINENO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTFile
     C                   PARM                    PKFile
     C                   PARM                    PKeyFlds
     C                   PARM                    PDspNoDif
     C                   PARM                    PRptFldNo
      *
     C                   MOVEL     PKeyFlds      W#KFLD
      *
     C                   Z-ADD     99            LINENO
     C                   Z-ADD     0             PAGNUM
      *
     C                   MOVE      *BLANK        SSTYPE
     C                   MOVE      *BLANK        SSRRN1
     C                   MOVE      *BLANK        SSRRN2
     C                   MOVE      *BLANK        SSDATA
      * Get fields
     C                   Z-ADD     0             #X
     C     PTFile        SETLL     UTFLDDD0
     C     PTFile        READE     UTFLDDD0                               99
     C     *IN99         DOWEQ     '0'
     C     FDSEQN        IFNE      999
     C     #X            ANDLT     999
     C                   ADD       1             #X
     C                   MOVEL     FDRPGN        #RPGN(#X)
     C                   Z-ADD     FDBUFF        #BUFF(#X)
     C                   Z-ADD     FDLENG        #LENG(#X)
     C                   Z-ADD     FDDIGI        #DIGI(#X)
     C                   Z-ADD     FDDECP        #DECP(#X)
     C                   MOVEL     FDDESC        #DESC(#X)
     C                   MOVE      FDTYPE        #TYPE(#X)
     C     #RPGN(#X)     SCAN      W#KFLD                                 99
     C   99              MOVE      'Y'           #KEY(#X)
     C                   ENDIF
     C     PTFile        READE     UTFLDDD0                               99
     C                   ENDDO
      *
      * Show first x fields of each record.
     C                   IF        PRptFldNo <> 'A'
     C                   MOVEL     PRptFldNo     #RFN
     C                   Z-ADD     1             #FN
     C     #FN           DOWLE     #RFN
     C                   MOVE      'Y'           #KEY(#FN)
     C                   ADD       1             #FN
     C                   ENDDO
     C                   ENDIF
      *
     C                   Z-ADD     #X            #C
      *
     C                   ENDSR
      *****************************************************************
     OUT000023P1E            PAGEHEAD        001002
     O                                           14 'UT000023P1    '
     O                                           70 'CMPF - File Comparison'
     O                                          120 'Page:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD       1
     O                                            5 'File:'
     O                       PTFile              16
     O                                           21 'Key:'
     O                       PKFile              32
     O                                           33 '/'
     O                       I#KEY1              43
     O                       I#KEY2              54
     O                       I#KEY3              65
     O                       I#KEY4              76
     O                       I#KEY5              87
     O                       I#KEY6              98
     O                       I#KEY7             109
     O                       I#KEY8             120
     O                       I#KEY9             131
      *
     O          E            PAGEHEAD       1
     O                                            4 'Type'
     O                                           18 'File 1'
     O                                           30 'RRN 1'
     O                                           39 'File 2'
     O                                           51 'RRN 2'
     O                       I#KEYA             109
     O                       I#KEYB             120
     O                       I#KEYC             131
      *
     O          E            DETS        1
     O                       SSTYPE              10
     O                       CFFIL1              22
     O                       SSRRN1              31
     O                       CFFIL2              43
     O                       SSRRN2              52
     O                       SSDATA             132
      *
     O          E            STRFLDS     1
     O                                           26 'Fields -------------------'
     O                                           52 '---------------File 1-----'
     O                                           78 '--------------------------'
     O                                          104 '--------------File 2------'
     O                                          130 '--------------------------'
      *
     O          E            FLDS        1
     O                       FDRPGN              10
     O                       FDDESC              40
     O                       FLD_Befor           81
     O                       FLD_After          132
      *
     O          E            SPLIT       1
     O                                           26 '=========================='
     O                                           52 '=========================='
     O                                           78 '=========================='
     O                                          104 '=========================='
     O                                          130 '=========================='
      *
     O          E            ENDREP      1
     O                                           70 '***** End of Report *****'
** CHR
 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|"$¢%&'()=~-¬@!;:
#,./+*<>?0123456789
** CHV
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*
** BIT
00010203040506070809101112131415
** ALP
0123456789ABCDEF
