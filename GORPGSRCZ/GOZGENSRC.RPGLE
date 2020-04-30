     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  CRTSRCPF FILE(QTEMP/GORPGG  ) RCDLEN(112)
/*XBIB*  CRTSRCPF FILE(QTEMP/GPRPGG  ) RCDLEN(112)
/*XBIC*  CRTSRCPF FILE(QTEMP/GPCPYG  ) RCDLEN(112)
/*XBID*  CRTSRCPF FILE(QTEMP/GPCPYWHG) RCDLEN(112)
/*XBIE*  CRTSRCPF FILE(QTEMP/GPCPYSRG) RCDLEN(112)
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Source generator')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GOZGENSRC - Source Generator                                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10215           Date 27Sep06               *
      *                 CGP001  *CREATE    Date 11Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *             to facilitate independent zone upgrades           *
      *  CGP001 - Global Processing.                                  *
      *                                                               *
      *****************************************************************
     FGPGLOBFL0 IF   E           K DISK
     FGORPGG    O    E           K DISK    RENAME(GORPGG:GORPGGF)
     FGPRPGG    O    E           K DISK    RENAME(GPRPGG:GPRPGGF)
     FGPCPYG    O    E           K DISK    RENAME(GPCPYG:GPCPYGF)
     FGPCPYWHG  O    E           K DISK    RENAME(GPCPYWHG:GPCPYWHGF)
     FGPCPYSRG  O    E           K DISK    RENAME(GPCPYSRG:GPCPYSRGF)
 
     D***SRC_GORPG       S             80    DIM(290) CTDATA PERRCD(1)               BUG10215 CGP017
     D***SRC_GORPG       S             80    DIM(299) CTDATA PERRCD(1)               CGP017 MD055146
     D SRC_GORPG       S             80    DIM(306) CTDATA PERRCD(1)                        MD055146
     D***SRC_GPRPG       S             80    DIM(147) CTDATA PERRCD(1)               BUG10215 CGP017
     D SRC_GPRPG       S             80    DIM(152) CTDATA PERRCD(1)                          CGP017
     D*SRC_GORPG*******S*************80    DIM(288) CTDATA PERRCD(1)                        BUG10215
     D*SRC_GPRPG*******S*************80    DIM(142) CTDATA PERRCD(1)                        BUG10215
     D***SRC_GPCPY       S             80    DIM(27)  CTDATA PERRCD(1)                        CGP017
     D SRC_GPCPY       S             80    DIM(30)  CTDATA PERRCD(1)                          CGP017
     D SRC_GPCPYWH     S             80    DIM(3)  CTDATA PERRCD(1)
     D SRC_GPCPYSR     S             80    DIM(3)  CTDATA PERRCD(1)
     D SRC_WHSRHDR     S             80    DIM(16) CTDATA PERRCD(1)
 
     D                 DS
     D  S                      1    100
     D                                     DIM(100)
     D  SRCDTA                 1    100
 
     D FM              S             10    DIM(9)
     D GKY             S             10    DIM(9)
     D ZKY             S             10    DIM(9)
 
 
     C     GPDTASK       CHAIN     GPGLOBFD0                          H1
     C                   EXSR      SET_INDTA
 
      * If Bulk Synchronization done
 
     C     GFBLSY        IFEQ      'Y'
 
      * Generate GO* RPG (Bulk Synchronization RPG)
 
     C                   EXSR      GEN_GORPG
     C                   ENDIF
 
      * If On-Line Synchronization done
 
     C     GFOLSY        IFEQ      'T'
     C     GFOLSY        OREQ      'B'
     C     GFOLSY        OREQ      'N'                                                      BUG10215
 
      * Generate GP* RPG (On-Line Synchronization RPG)
 
     C                   EXSR      GEN_GPRPG
 
      * Generate GP* CPY (On-Line Synchronization /COPY)
 
     C                   EXSR      GEN_GPCPY
     C     GFOLSY        IFNE      'N'                                                      BUG10215
 
      * Generate GP* WHEN CPY (On-Line Synchronization /COPY)
 
     C                   EXSR      GEN_GPCPYWH
 
      * Generate GP* SUBR CPY (On-Line Synchronization /COPY)
 
     C                   EXSR      GEN_GPCPYSR
     C                   ENDIF                                                              BUG10215
     C                   ENDIF
 
      * return
 
     C                   MOVEL     GFGPF_GO      O_GORPG
     C                   MOVEL     GFGPF_GP      O_GPRPG
     C                   MOVEL     GFGPF_GP      O_GPCPY
 
     C                   SETON                                        LR
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * Generate GO* RPG (Bulk Synchronization RPG)
      ********************************************************************
     C     GEN_GORPG     BEGSR
 
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
     C                   Z-ADD     1             X                 4 0
     C*****X****         DOUGT     290                                               BUG10215 CGP017
     C     X             DOUGT     299                                                        CGP017
     C*****X*************DOUGT     288                                                      BUG10215
 
     C                   MOVEL     SRC_GORPG(X)  SRCDTA
 
     C                   EXSR      SUB_GORPG
 
     C     X             IFEQ      4
     C                   MOVEL     '/*STD'       SRCDTA
     C                   ENDIF
 
     C   20S(1)          IFEQ      'B'
     C     GFGBRC        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20S(1)          IFEQ      'Z'
     C     GFZONE        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20              ADD       1             SRCSEQ
     C   20              WRITE     GORPGGF
     C     FmtRead       IFEQ      'Y'
     C                   EXSR      FMTS_GORPG
     C                   ENDIF
     C     KeyRead       IFEQ      'G'
     C                   EXSR      KEYS_GORPG_G
     C                   ENDIF
     C     KeyRead       IFEQ      'Z'
     C                   EXSR      KEYS_GORPG_Z
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Generate GP* RPG (On-Line Synchronization RPG)
      ********************************************************************
     C     GEN_GPRPG     BEGSR
 
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
 
     C                   Z-ADD     1             X                 4 0
     C*****X****         DOUGT     147                                               BUG10215 CGP017
     C     X             DOUGT     152                                                        CGP017
     C*****X*************DOUGT     142                                                      BUG10215
 
     C                   MOVEL     SRC_GPRPG(X)  SRCDTA
 
     C                   EXSR      SUB_GPRPG
 
     C     X             IFEQ      4
     C                   MOVEL     '/*STD'       SRCDTA
     C                   ENDIF
 
     C   20S(1)          IFEQ      'B'
     C     GFGBRC        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20S(1)          IFEQ      'Z'
     C     GFZONE        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20S(1)          IFEQ      'T'
     C     GFTRUP        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20S(1)          IFEQ      'O'
     C     GFGKY1        ANDEQ     *BLANK
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
 
     C   20              ADD       1             SRCSEQ
     C   20              WRITE     GPRPGGF
     C   20KeyRead       IFEQ      'Z'
     C                   EXSR      KEYS_GPRPG_Z
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Generate GP* CPY (On-Line Synchronization /COPY)
      ********************************************************************
     C     GEN_GPCPY     BEGSR
 
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
 
     C                   Z-ADD     1             X                 4 0
     C*****X****         DOUGT     27                                                         CGP017
     C     X             DOUGT     30                                                         CGP017
 
     C                   MOVEL     SRC_GPCPY(X)  SRCDTA
     C                   EXSR      SUB_GPCPY
 
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPCPYGF
 
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Generate GP* WHEN CPY (On-Line Synchronization /COPY)
      ********************************************************************
     C     GEN_GPCPYWH   BEGSR
 
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
 
     C                   Z-ADD     1             X
     C     X             DOUGT     3
 
     C                   MOVEL     SRC_GPCPYWH(X)SRCDTA
     C                   EXSR      SUB_GPCPY
 
     C     X             IFEQ      2
     C                   MOVEL     '      /'     SRCDTA
     C                   ENDIF
 
     C     X             IFNE      2
     C     GFMULT        OREQ      'Y'
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPCPYWHGF
     C                   ENDIF
 
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Generate GP* SUBR CPY (On-Line Synchronization /COPY)
      ********************************************************************
     C     GEN_GPCPYSR   BEGSR
 
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
 
     C                   Z-ADD     1             X
     C     X             DOUGT     3
 
     C                   MOVEL     SRC_GPCPYSR(X)SRCDTA
     C                   EXSR      SUB_GPCPY
 
     C     X             IFEQ      2
     C                   MOVEL     '      /'     SRCDTA
     C                   ENDIF
 
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPCPYSRGF
 
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set input data
      ********************************************************************
     C     SET_INDTA     BEGSR
 
     C     GFZPFF        IFEQ      *BLANK
     C                   MOVEL     GFZLFF        GFZPFF
     C                   ENDIF
     C     GFGPFF        IFEQ      *BLANK
     C                   MOVEL     GFZLFF        GFGPFF
     C                   ENDIF
     C     GFGLFF        IFEQ      *BLANK
     C                   MOVEL     GFZLFF        GFGLFF
     C                   ENDIF
 
     C                   MOVEL     GFGPF         GFGPF_GO         10
     C                   MOVEL     'GO'          GFGPF_GO
 
     C                   MOVEL     GFGPF         GFGPF_GP         10
     C                   MOVEL     'GP'          GFGPF_GP
 
     C                   MOVE      GFGPF         GFGPF_T           8
 
     C                   MOVEL     GFZLF1        FM(1)
     C                   MOVEL     GFZLF2        FM(2)
     C                   MOVEL     GFZLF3        FM(3)
     C                   MOVEL     GFZLF4        FM(4)
     C                   MOVEL     GFZLF5        FM(5)
     C                   MOVEL     GFZLF6        FM(6)
     C                   MOVEL     GFZLF7        FM(7)
     C                   MOVEL     GFZLF8        FM(8)
     C                   MOVEL     GFZLF9        FM(9)
      * global key
     C                   MOVEL     GFGKY1        GKY(1)
     C                   MOVEL     GFGKY2        GKY(2)
     C                   MOVEL     GFGKY3        GKY(3)
     C                   MOVEL     GFGKY4        GKY(4)
     C                   MOVEL     GFGKY5        GKY(5)
     C                   MOVEL     GFGKY6        GKY(6)
     C                   MOVEL     GFGKY7        GKY(7)
     C                   MOVEL     GFGKY8        GKY(8)
     C                   MOVEL     GFGKY9        GKY(9)
      * default zone branch
     C     GFZBRC        IFEQ      *BLANK
     C                   MOVEL     GFGBRC        GFZBRC
     C                   ENDIF
      * Zone key
     C                   MOVEL     GFZKY1        ZKY(1)
     C                   MOVEL     GFZKY2        ZKY(2)
     C                   MOVEL     GFZKY3        ZKY(3)
     C                   MOVEL     GFZKY4        ZKY(4)
     C                   MOVEL     GFZKY5        ZKY(5)
     C                   MOVEL     GFZKY6        ZKY(6)
     C                   MOVEL     GFZKY7        ZKY(7)
     C                   MOVEL     GFZKY8        ZKY(8)
     C                   MOVEL     GFZKY9        ZKY(9)
      * default zone key
     C     ZKY(1)        IFEQ      *BLANK
     C                   MOVEL     GKY           ZKY
     C                   ENDIF
 
      * no of key fields
     C                   Z-ADD     1             ZK
     C     *BLANK        LOOKUP    GKY(ZK)                                99
     C     ZK            SUB       1             SNoK              1 0
 
      * Is global branch in global key?
     C                   MOVEL     'N'           Brch_Glb_key      1
     C     GFGBRC        IFNE      *BLANK
     C     GFGBRC        LOOKUP    GKY                                    99
     C   99              MOVEL     'Y'           Brch_Glb_key
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *******************************************************************
      *
      * G Z   R P G   S O U R C E
      *
      ********************************************************************
     C     SUB_GORPG     BEGSR
 
     C                   MOVE      *ON           *IN20
      ***
     C     '@GBRC'       SCAN      SRCDTA        Y                 2 0    99    *
     C******IN99         IFEQ      *ON                                                        CGP017
     C     *IN99         DOWEQ     *ON                                                        CGP017
     C                   MOVEA     GFGBRC        S(Y)
     C     '@GBRC'       SCAN      SRCDTA        Y                        99                  CGP017
     C                   ENDDO                                                                CGP017
     C**********         ENDIF                                                                CGP017
      ***
     C     '@ZBRC'       SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZBRC        S(Y)
     C                   ENDIF
      ***
     C     '@ZONE'       SCAN      SRCDTA        Y                 2 0    99    *
     C******IN99         IFEQ      *ON                                                        CGP017
     C     *IN99         DOWEQ     *ON                                                        CGP017
     C                   MOVEA     GFZONE        S(Y)
     C     '@ZONE'       SCAN      SRCDTA        Y                 2 0    99    *             CGP017
     C                   ENDDO                                                                CGP017
     C**********         ENDIF                                                                CGP017
      ***
     C     '@ZPF '       SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZPF         S(Y)
     C                   ENDIF
                                                                                            BUG10215
     C     '@GPF_GP'     SCAN      SRCDTA        Y                        99    *           BUG10215
     C     *IN99         IFEQ      *ON                                                      BUG10215
     C                   MOVEA     GFGPF_GP      S(Y)                                       BUG10215
     C                   MOVE      '/'           S(7)                                       BUG10215
     C                   ENDIF                                                              BUG10215
 
     C     '@ZPFF'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZPFF        S(Y)
     C                   ENDIF
      ***
     C     *IN99         DOUEQ     *OFF
     C     '@ZLF '       SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZLF         S(Y)
     C                   ENDIF
     C                   ENDDO
 
     C     '@ZLFF'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZLFF        S(Y)
     C                   ENDIF
      ***
     C     '@GLF '       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGLF         S(Y)
     C                   ENDIF
 
     C     '@GLFF'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGLFF        S(Y)
     C                   ENDIF
      ***
     C     '@GPF '       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF         S(Y)
     C                   ENDIF
 
     C     '@GPFF'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPFF        S(Y)
     C                   ENDIF
 
     C     '@GPF_GO'     SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF_GO      S(Y)
     C                   ENDIF
      ** Formats
     C                   MOVEL     *BLANK        FmtRead           1
 
     C     '@FMT1'       SCAN      SRCDTA        YF                2 0    99    *
     C     *IN99         IFEQ      *ON
     C     FM(1)         IFNE      *BLANK
     C                   MOVEL     FM(1)         Format           10
     C                   MOVEA     Format        S(YF)
     C                   MOVEL     'Y'           FmtRead
     C                   ELSE
     C                   MOVE      *OFF          *IN20
     C                   ENDIF
     C                   ENDIF
      ** Keys
     C                   MOVEL     *BLANK        KeyRead           1
 
     C     '@ZKY1'       SCAN      SRCDTA        YK                2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'Z'           KeyRead           1
     C                   MOVEL     ZKY(1)        KeyFld           10
     C                   MOVEA     KeyFld        S(YK)
     C                   MOVE      SNoK          S(66)
     C                   ELSE
     C     '@GKY1'       SCAN      SRCDTA        YK                       99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'G'           KeyRead
     C                   MOVEL     GKY(1)        KeyFld
     C                   MOVEA     KeyFld        S(YK)
     C                   MOVE      SNoK          S(66)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
     C     FMTS_GORPG    BEGSR
 
     C                   Z-ADD     2             ZF                2 0
     C     ZF            DOWLE     9
     C     FM(ZF)        ANDNE     *BLANK
     C                   MOVEL     FM(ZF)        Format
     C                   MOVEA     Format        S(YF)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GORPGGF
     C                   ADD       1             ZF
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
     C     KEYS_GORPG_G  BEGSR
 
     C     SNok          SUB       1             NoK               1 0
 
     C                   Z-ADD     2             ZK                2 0
     C     ZK            DOWLE     9
     C     GKY(ZK)       ANDNE     *BLANK
     C                   MOVEL     GKY(ZK)       KeyFld
     C                   MOVEA     KeyFld        S(YK)
     C                   MOVE      NoK           S(66)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GORPGGF
     C                   ADD       1             ZK
     C                   SUB       1             NoK
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
     C     KEYS_GORPG_Z  BEGSR
 
     C     SNok          SUB       1             NoK
 
     C                   Z-ADD     2             ZK
     C     ZK            DOWLE     9
     C     ZKY(ZK)       ANDNE     *BLANK
     C                   MOVEL     ZKY(ZK)       KeyFld
     C                   MOVEA     KeyFld        S(YK)
     C                   MOVE      NoK           S(66)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GORPGGF
     C                   ADD       1             ZK
     C                   SUB       1             NoK
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *******************************************************************
      *
      * G P   R P G   S O U R C E
      *
      ********************************************************************
     C     SUB_GPRPG     BEGSR
 
     C                   MOVE      *ON           *IN20
      ***
     C     '@ZONE'       SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZONE        S(Y)
     C                   ENDIF
      ***
     C     '@TRUP'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFTRUP        S(Y)
     C                   ENDIF
      ***
     C     *IN99         DOUEQ     *OFF
     C     '@ZPF '       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZPF         S(Y)
     C                   ENDIF
     C                   ENDDO
      ***
     C     '@GLFU'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGLFU        S(Y)
     C                   ENDIF
 
     C     '@GLFF'       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGLFF        S(Y)
     C                   ENDIF
 
     C     '@GPF '       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF         S(Y)
     C                   ENDIF
                                                                                            BUG10215
     C     *IN99         DOUEQ     *OFF                                                     BUG10215
     C     '@GPFF'       SCAN      SRCDTA        Y                        99    *           BUG10215
     C     *IN99         IFEQ      *ON                                                      BUG10215
     C                   MOVEA     GFGPFF        S(Y)                                       BUG10215
     C                   ENDIF                                                              BUG10215
     C                   ENDDO                                                              BUG10215
 
     C     '@GPF_GP'     SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF_GP      S(Y)
     C                   ENDIF
      ** Keys
     C                   MOVEL     *BLANK        KeyRead           1
 
     C                   Z-ADD     1             ZK
     C     '@ZKY1'       SCAN      SRCDTA        YK                2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'Z'           KeyRead           1
     C     GFGBRC        IFNE      *BLANK
     C     Brch_Glb_key  ANDEQ     'N'
     C                   MOVEA     GFGBRC        S(YK)
     C                   ELSE
     C     GFZONE        IFNE      *BLANK
     C                   MOVEA     GFZONE        S(YK)
     C                   ELSE
     C                   MOVEL     ZKY(1)        KeyFld           10
     C                   MOVEA     KeyFld        S(YK)
     C                   ADD       1             ZK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
     C     KEYS_GPRPG_Z  BEGSR
 
     C     ZK            DOWLE     9
     C     ZKY(ZK)       ANDNE     *BLANK
     C                   MOVEL     ZKY(ZK)       KeyFld
     C                   MOVEA     KeyFld        S(YK)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPRPGGF
     C                   ADD       1             ZK
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *******************************************************************
      *
      * G P   C P Y   S O U R C E
      *
      ********************************************************************
     C     SUB_GPCPY     BEGSR
 
     C     *IN99         DOUEQ     *OFF
     C     '@ZPF '       SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFZPF         S(Y)
     C                   ENDIF
     C                   ENDDO
 
     C     '@GPF '       SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF         S(Y)
     C                   ENDIF
 
     C     *IN99         DOUEQ     *OFF
     C     '@GPF_T'      SCAN      SRCDTA        Y                 2 0    99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF_T       S(Y)
     C                   ENDIF
     C                   ENDDO
 
     C     *IN99         DOUEQ     *OFF
     C     '@GPF_GP'     SCAN      SRCDTA        Y                        99    *
     C     *IN99         IFEQ      *ON
     C                   MOVEA     GFGPF_GP      S(Y)
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Generate CPYWH and CPYSR Header Boxes
      ********************************************************************
     C     GEN_WHSRHDR   BEGSR
 
      * WH header box
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
     C                   Z-ADD     1             X
     C     X             DOUGT     16
     C                   MOVEL     SRC_WHSRHDR(X)SRCDTA
     C     S(1)          IFNE      'S'
     C                   MOVE      *BLANK        S(1)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPCPYWHGF
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      * SR header box
     C                   Z-ADD     0             SRCSEQ
     C                   Z-ADD     0             SRCDAT
     C                   Z-ADD     1             X
     C     X             DOUGT     16
     C                   MOVEL     SRC_WHSRHDR(X)SRCDTA
     C     S(1)          IFNE      'W'
     C                   MOVE      *BLANK        S(1)
     C                   ADD       1             SRCSEQ
     C                   WRITE     GPCPYSRGF
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZPF            10
     C                   PARM                    I_ZLF            10
     C                   PARM                    I_FIRST           1
     C                   PARM                    O_GORPG          10
     C                   PARM                    O_GPRPG          10
     C                   PARM                    O_GPCPY          10
 
     C     GPDTASK       KLIST
     C                   KFLD                    I_ZPF
     C                   KFLD                    I_ZLF
     C**********         MOVEL     '     D/'     SRC_GORPG(30)                       BUG10215 CGP017
     C                   MOVEL     '     D/'     SRC_GORPG(33)                                CGP017
 
      * Output header boxes to CPYWH and CPYSR members
 
     C     I_FIRST       IFEQ      'Y'
     C                   EXSR      GEN_WHSRHDR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
** SRC_GORPG
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
      ***RPGBASEBNC****************************************************                       CGP017
      *  RPGBASEMOD                                                   *                       CGP017
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  @GPF_GO    - Bulk Update of Global File @GPF                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
 
     F@ZLF      IP  AE           K DISK    RENAME(@ZLFF      : FormatZON)
     F                                     IGNORE(@FMT1      )
     F                                     INFSR(*PSSR)
     F@GLF      IS  AE           K DISK    RENAME(@GLFF      : FormatGLB)
     F                                     PREFIX(G_)
     F                                     INFSR(*PSSR)
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
      * Program Status Data Structure
     D COPY ZACPYSRC,PSDS
 
     D Z_@ZLF        E DS                  EXTNAME(@ZPF      )
     D G_@ZLF        E DS                  EXTNAME(@GPF      )
     D                                     PREFIX(G_)

B    D***BR*****         S              3    DIM(99)                                        MD055146
B    D***SL*****         S             27    DIM(99)                                        MD055146
B    D BR              S              3    DIM(999)                                         MD055146
B    D SL              S             27    DIM(999)                                         MD055146
B
B    D SYNLOGREC       DS
B    D  BSCNTW                 1      9S 0
B    D  BSCNTD                10     18S 0
B    D  BSCNTU                19     27S 0
B
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8
 
     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6
 
     D                 DS
     D  TIME_STR               1      6S 0
     D  STR_HH                 1      2S 0
     D  STR_MM                 3      4S 0
     D  STR_SS                 5      6S 0
 
     D                 DS
     D  TIME_END               1      6S 0
     D  END_HH                 1      2S 0
     D  END_MM                 3      4S 0
     D  END_SS                 5      6S 0
 
     IFormatZON     01
     I                                          @ZKY1         L1M5
     IFormatGLB     02
     I                                          G_@GKY1       L1M5
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   MOVEL     Z_@ZLF        G_@ZLF
Z    C                   EVAL      G_@ZONE       = I_ZONE
B    C                   EVAL      G_@GBRC       = @ZBRC
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPD_GLOBALFILE
     C                   ELSE
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPD_GLOBALFILE
     C                   ENDIF
     C                   ELSE
     C   02              MOVE      @GBRC         G_@GBRC                                      CGP017
     C   02              MOVE      @ZONE         G_@ZONE                                      CGP017
     C     Z_@ZLF        IFNE      G_@ZLF                                                     CGP017
     C   02              MOVEL     Z_@ZLF        G_@ZLF
Z    C   02              EVAL      G_@ZONE       = I_ZONE
B    C   02              EVAL      G_@GBRC       = @ZBRC
     C   02              EVAL      I#BFAF = 'A'
     C   02              EXSR      UPD_GLOBALFILE
     C                   ELSE                                                                 CGP017
     C   02              MOVE      *OFF          *IN02                                        CGP017
     C                   ENDIF                                                                CGP017
     C                   ENDIF
     C                   EXSR      UPD_SYNTOT
     CLR                 EXSR      WRT_SYNLOG
     C/SPACE 5
      ********************************************************************
      * Update Global File
      ********************************************************************
     C     UPD_GLOBALFILEBEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_@ZLF
     C                   EVAL      I#AIMG = G_@ZLF
     C COPY GPCPYSRCG,@GPF_GP
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update Synchronization Totals
      ********************************************************************
     C     UPD_SYNTOT    BEGSR

B    C**********         Z-ADD     1             I                 2 0                      MD055146
B    C                   Z-ADD     1             I                 3 0                      MD055146
B    C   01@ZBRC         LOOKUP    BR(I)                                  99
B    C   02G_@GBRC       LOOKUP    BR(I)                                  99
B    C     *IN99         IFEQ      *OFF
B    C     '***'         LOOKUP    BR(I)                                  99
B    C   01              MOVEL     @ZBRC         BR(I)
B    C   02              MOVEL     G_@GBRC       BR(I)
B    C                   CLEAR                   SYNLOGREC
B    C                   MOVEL     SYNLOGREC     SL(I)
B    C                   ELSE
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   ENDIF
B
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
B    C                   ADD       1             BSCNTW
     C                   ADD       1             T_BSCNTW
     C                   ELSE
B    C                   ADD       1             BSCNTD
     C                   ADD       1             T_BSCNTD
     C                   ENDIF
     C                   ELSE
B    C   02              ADD       1             BSCNTU
     C   02              ADD       1             T_BSCNTU
     C                   ENDIF
 
B    C                   MOVEL     SYNLOGREC     SL(I)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write to Synchronization Log
      ********************************************************************
     C     WRT_SYNLOG    BEGSR
 
      * Write overall totals
     C                   MOVEL     '***'         BSBRCA
     C                   Z-ADD     T_BSCNTW      BSCNTW
     C                   Z-ADD     T_BSCNTD      BSCNTD
     C                   Z-ADD     T_BSCNTU      BSCNTU
      *
     C                   EVAL      BSDATE = PSRunDateA
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSJobNoA
 
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_END = NUM_TIME
     C                   EVAL      BSETIM   = BUF_TIME
 
      * Calculate total number of seconds
 
     C                   EXSR      CAL_TOS
 
     C                   WRITE     GPSBLOGD0
 
B     * Write branch totals
B    C**********         Z-ADD     1             I                 2 0                      MD055146
B    C                   Z-ADD     1             I                 3 0                      MD055146
B    C     BR(I)         DOWNE     '***'
B    C                   MOVEL     BR(I)         BSBRCA
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   WRITE     GPSBLOGD0
B    C                   ADD       1             I
B    C                   ENDDO
B
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate total number of seconds
      ********************************************************************
     C     CAL_TOS       BEGSR
 
     C     TIME_END      IFLT      TIME_STR
     C                   ADD       240000        TIME_END
     C                   ENDIF
 
     C     END_HH        SUB       STR_HH        TOT_HH            6 0
     C     END_MM        SUB       STR_MM        TOT_MM            6 0
     C     END_SS        SUB       STR_SS        TOT_SS            6 0
 
     C     STR_MM        IFGT      END_MM
     C                   SUB       1             TOT_HH
     C                   ADD       60            TOT_MM
     C                   ENDIF
 
     C     STR_SS        IFGT      END_SS
     C                   SUB       1             TOT_MM
     C                   ADD       60            TOT_SS
     C                   ENDIF
 
     C                   MULT      3600          TOT_HH
     C                   MULT      60            TOT_MM
 
     C                   Z-ADD     TOT_HH        BSTOS
     C                   ADD       TOT_MM        BSTOS
     C                   ADD       TOT_SS        BSTOS
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Record the time
      ********************************************************************
     C     RECD_TIME     BEGSR
     C                   TIME                    NUM_TIME          6 0
     C                   MOVEL     NUM_TIME      ALP_TIME          6
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10
 
     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_@ZLF
     C                   CLEAR                   G_@ZLF
 
      * Delete existing log records
 
     C                   EVAL      BSFILE = '@GPF      '
     C                   EVAL      BSZONE = I_ZONE
     C     GPSBLOGK      SETLL     GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C                   ENDDO
 
     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EXSR      RECD_TIME
     C                   EVAL      TIME_STR = NUM_TIME
     C                   EVAL      BSSTIM   = BUF_TIME
 
B     * Initialize branches
B    C                   MOVE      '***'         BR
B
      * Initialize overall totals
     C                   Z-ADD     *ZERO         T_BSCNTW          9 0
     C                   Z-ADD     *ZERO         T_BSCNTD          9 0
     C                   Z-ADD     *ZERO         T_BSCNTU          9 0
 
      * Key lists
 
     C     GPSBLOGK      KLIST
     C                   KFLD                    BSFILE
     C                   KFLD                    BSZONE
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
** SRC_GPRPG
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
      ***RPGBASEBNC****************************************************                       CGP017
      *  RPGBASEMOD                                                   *                       CGP017
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  @GPF_GP    - On-Line Update of Global File @GPF              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
 
O    F@GLFU     UF   E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     USROPN
O    F@GPF      O  A E           K DISK    INFSR(*PSSR) PREFIX(G_) COMMIT(D_COM)
O    F                                     RENAME(@GPFF       :W_@GPFF        )
O    F                                     USROPN
O
O    D Z_@ZPF        E DS                  EXTNAME(@GPF      )
O    D G_@ZPF        E DS                  EXTNAME(@GPF      ) PREFIX(G_)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
T
T     * GPTRAPPD Updates
T
T    C     I#TRAP        IFEQ      'Y'
T    C     I#BFAF        ANDEQ     'A'
T    C**********         CALL      '@TRUP     '                                               CGP017
     C                   CALLB     '@TRUP     '                                               CGP017
T    C                   PARM      *BLANK        W#RTCD            7
T    C                   PARM      *BLANK        W#ERMS           50
T    C                   PARM                    I#BIMG
T    C                   PARM                    I#AIMG
T    C     W#RTCD        IFEQ      '*ERROR'
T    C                   EVAL      I#ERMS = 'ERROR IN CALL TO @TRUP     '
T    C                   EXSR      *PSSR
T    C                   ENDIF
T    C                   ENDIF
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_@ZPF
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_@ZPF
O    C                   ENDIF
Z    C                   MOVEL     I#ZONE        @ZONE
O
O    C     K_@GLFU       CHAIN     @GLFF                              99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    @GLFF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_@ZPF
O    C                   MOVEL     Z_@ZPF        G_@ZPF
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      '@GPF      '  I#FILE           10
O    C                   PARM      G_@ZPF        IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_@ZPF
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    @GLFF
O    C                   ELSE
O    C                   WRITE     W_@GPFF
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      @GLFU
O    C                   OPEN      @GPF
O
O     * Key lists
O
O    C     K_@GLFU       KLIST
O    C                   KFLD                    @ZKY1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
** SRC_GPCPY
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  @GPF_GP    - On-Line Update of Global File @GPF              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      *  Prev Amend No. BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************
     C**********         CALL      '@GPF_GP     '                                             CGP017
     C                   CALLB     '@GPF_GP     '                                             CGP017
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#ZONE           10            * ERROR MESSAGE
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO @GPF_GP   '
     C                   EXSR      *PSSR
     C                   END
** SRC_GPCPYWH
     C     I#FILE        WHENEQ    '@ZPF      '
       COPY GPCPYSRCG,Z1@GPF_T
     C                   EXSR      @GPF_GP
** SRC_GPCPYSR
     C     @GPF_GP       BEGSR
       COPY GPCPYSRCG,@GPF_GP
     C                   ENDSR
** SRC_WHSRHDR
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
S     *  GPZOLSYNSR - Subroutines                                     *
W     *  GPZOLSYNWH - Wheneq statements                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. BUG10215 *REBUILD  Date 27Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10215 - Global replication needs a global interface       *
      *                                                               *
      *****************************************************************