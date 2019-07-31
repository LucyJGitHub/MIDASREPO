     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UPP02P) TOFILE(UPP02BPD)                         *
/*XBIB*  OVRDBF FILE(UPP03P) TOFILE(UPP03PPD)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare screen handling - 92 source')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000530B - Compare screen handling                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSM005             Date 18Aug05               *
      *                 CPK016             Date 16Apr03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP001 *CREATE     Date 07Mar97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSM005 - Rewrite of UP0530B and moved to global layer.       *
      *  CPK016 - UPP0* files renamed.                                *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
      *****************************************************************
     FUPP02P    UF   E           K DISK    INFDS(DB01DS)
     FUPP03P    IF   E           K DISK
     FUP00053BDFCF   E             WORKSTN
      * record number of subfile
     F                                     SFILE(SFL:LFD)
     F                                     INFDS(DSPDS)
      *
     D SCN             S              1    DIM(50)
     D SCN2            S              1    DIM(50)
     D DSPDS           DS
     D  COLUMN               154    155B 0
     D  CSRKOR               370    371B 0
     D  KEY                  369    369
     D DB01DS          DS
      * file name
     D  FILE                  83     92
      * library name
     D  LIBR                  93    102
      * member name
     D  MEMBER               129    138
      * number of records
     D  #RCDS                156    159B 0
      * relative record number
     D  RRN                  397    400B 0
     D                 DS
     D  ZEIL1                  1     70
     D  ZZZL1                  1      1
     D  ACNO                   2      4
     D  ZEILW                 71    163
     D  ZZZL2                 71     71
     D  ACNOW                 72     74
     D  UUDAT                 75     81
     D                SDS
     D  PGM                    1     10
     D                 DS
     D  LIBFIL                 1     21
     D  LIBF                   1     10
     D  SLASH                 11     11
     D  SRCF                  12     21
     D  BASFIL                22     42
     D  LIBO                  22     31
     D  SLAS1                 32     32
     D  SRCO                  33     42
     D SCNDS           DS                  OCCURS(100)
     D  SCNOLD                 1     50
      *
     C     *ENTRY        PLIST
     C                   PARM                    NEWL             10
     C                   PARM                    NEWF             10
     C                   PARM                    NEWM             10
     C                   PARM                    PASS1             1
     C                   PARM                    TYP              10
     C                   PARM                    NEWME            10
     C                   PARM                    OLDL             10
     C                   PARM                    OLDF             10
     C                   PARM                    OLDM             10
     C                   PARM                    S                 1
     C                   PARM                    RTCMD             1
     C                   PARM                    MRGLIB           10
     C                   PARM                    WRKLIB           10
     C                   Z-ADD     1             O
      *
     C*------------------------------------------------------------
      *
     C     #RCDS         IFEQ      0
     C                   MOVE      'EMPTY'       STEP
     C                   MOVE      '1'           *INLR
     C                   EXSR      DSPSFL
     C                   RETURN
     C                   END
      *
     C                   MOVEL     NEWL          LIBF
     C                   MOVEL     '/'           SLASH
     C                   MOVEL     NEWF          SRCF
     C                   MOVEL     NEWM          MEMB
     C                   MOVEL     OLDL          LIBO
     C                   MOVEL     '/'           SLAS1
     C                   MOVEL     OLDF          SRCO
     C                   MOVEL     OLDM          MEMBO
      *
     C                   WRITE     FORM11
     C     COLUMN        IFGT      80
     C                   MOVEL     '1'           *IN71
     C                   END
      *
     C                   Z-ADD     1             SRCNO             5 0
     C                   Z-ADD     1             YSRCNO            5 0
     C                   MOVEL     '0'           *IN20
     C*------------------------------------------------------------
     C     RESET         TAG
     C*------------------------------------------------------------
     C                   Z-ADD     SRCNO         POSNO             5 0
     C                   EXSR      DBPOS
     C                   SUB       9             RCDNBR
      *
     C     *IN07         IFEQ      '1'
     C     *IN08         OREQ      '1'
     C     *IN62         IFEQ      '0'
     C                   MOVEL     YSRCNO        USRCNO            5
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM      'DBG0004'     ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM      USRCNO        ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
     C                   END
     C     *IN62         IFEQ      '1'
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM      'DBG0007'     ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
     C                   END
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVEL     RCDNBR        STMTNR            5
     C     RCDNBR        IFLE      0
     C                   Z-ADD     1             RCDNBR
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510 '
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM      'DBG0004'     ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM      '00001'       ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     RCDNBR        SETLL     UPP02PR
     C                   EXSR      PAGUP
     C                   Z-ADD     *ZEROS        FIXLN             5 0
      *
     C*------------------------------------------------------------
     C     DSP           TAG
     C*------------------------------------------------------------
      *
     C                   EXSR      DSPSFL
      *
     C*------------------------------------------------------------
      *
     C     *IN03         IFEQ      '1'
     C                   MOVEL     '3'           RTCMD
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN10         CABEQ     '1'           RESET
     C     *IN25         IFEQ      '1'
     C     *IN06         CASEQ     '1'           MOVE
     C     *IN11         CASEQ     '1'           ACALL
     C     *IN13         CASEQ     '1'           ACCEP
     C     *IN14         CASEQ     '1'           EDIT
     C     *IN15         CASEQ     '1'           ACCEP
     C     *IN19         CASEQ     '1'           WIND
     C     *IN20         CASEQ     '1'           WIND
     C     *IN60         CASEQ     '1'           PAGUP
     C     *IN61         CASEQ     '1'           PAGDWN
     C     *IN22         CASEQ     '1'           SCAN
     C     *IN63         CASEQ     '1'           PRTSCR
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVEL     '0'           *IN62
     C                   MOVEL     'N'           WWTYPA
     C                   Z-ADD     *ZEROS        WWRRN
     C     *IN07         IFEQ      '1'
     C     KL1           KLIST
     C                   KFLD                    WWRELN            5 0
     C                   KFLD                    WWTYPA            1
      *
     C     YSRCNO        ADD       1             WWRELN
     C     RRN           SUB       LFD           WWRRN             5 0
     C     WWRELN        IFLT      WWRRN
     C     WWRELN        ORGT      RRN
     C                   Z-ADD     WWRRN         WWRELN
     C                   END
      *
     C     KL1           SETLL     UPP03PR
     C                   READ      UPP03PR                                62
     C                   Z-ADD     CCRELN        YSRCNO            5 0
     C                   Z-ADD     CCRELN        SRCNO
     C                   Z-ADD     CCRELN        FIXLN
     C                   GOTO      RESET
     C                   END
      *
     C     *IN08         IFEQ      '1'
     C     YSRCNO        SUB       1             WWRELN
     C     RRN           SUB       LFD           WWRRN             5 0
     C     WWRELN        IFLT      WWRRN
     C     WWRELN        ORGT      RRN
     C                   Z-ADD     RRN           WWRELN
     C                   END
     C     KL1           SETGT     UPP03PR
     C                   READP     UPP03PR                                62
     C                   Z-ADD     CCRELN        SRCNO
     C                   Z-ADD     CCRELN        YSRCNO
     C                   Z-ADD     CCRELN        FIXLN
     C                   GOTO      RESET
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN21         IFEQ      '1'
     C                   CALL      'QUSCMDLN'
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN24         IFEQ      '1'
     C     FOOT          IFEQ      ' '
     C                   MOVE      '1'           FOOT
     C                   ELSE
     C                   MOVE      ' '           FOOT              1
     C                   END
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   GOTO      DSP
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     1             LFD
     C                   MOVE      '0'           MDT               1
      *
     C*------------------------------------------------------------
      *
     C     *IN85         DOUEQ     '1'
     C                   READC     SFL                                    85
     C     *IN85         IFEQ      '0'
     C                   Z-ADD     STMT          POSNO
     C                   EXSR      DBPOS
     C                   EXSR      PAGUP
     C                   GOTO      DSP
     C                   END
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   GOTO      DSP
     C*
     C*************************************************************
     C*
     C     SFLCLR        BEGSR
     C                   SETOFF                                       50
     C                   WRITE     SFLCTL
     C                   Z-ADD     0             LFD
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C*
     C*************************************************************
     C*
     C     DSPSFL        BEGSR
      *
     C*------------------------------------------------------------
      *
     C     FOOT          IFEQ      ' '
     C                   WRITE     FORM03
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C                   WRITE     FORM04
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   WRITE     MSFLC
      *
     C*------------------------------------------------------------
      *
     C     LFD           IFGT      0
     C                   SETON                                        50
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   EXSR      CSRCOR
     C     *IN62         IFEQ      '0'
     C     *IN07         IFEQ      '1'
     C     *IN08         OREQ      '1'
     C                   Z-ADD     *ZEROS        TTRRN
     C                   Z-ADD     *ZEROS        TTTRN
     C                   Z-ADD     *ZEROS        TTTTN
     C     RRN           SUB       LFD           TTRRN             5 0
     C     YSRCNO        SUB       TTRRN         TTTRN             5 0
     C     TTTRN         ADD       2             TTTTN             5 0
     C                   Z-ADD     TTTTN         LINE
     C                   Z-ADD     2             COL
     C                   END
     C                   END
     C                   EXFMT     SFLCTL
     C                   CALL      'UPC000560'
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     PAGDWN        BEGSR
     C                   SUB       18            BACK
      *
     C*------------------------------------------------------------
      *
     C     BACK          IFLE      0
     C                   Z-ADD     1             BACK
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     BACK          SETLL     UPP02PR                            80
     C                   EXSR      PAGUP
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     PAGUP         BEGSR
     C                   EXSR      SFLCLR
      *
     C*------------------------------------------------------------
      *
     C                   DO        19
     C                   READ      UPP02PR                                80
      *
     C*------------------------------------------------------------
      *
     C     *IN80         IFEQ      '0'
      *
     C*------------------------------------------------------------
      *
     C     SRCHLN        IFEQ      CMRELN
      *
     C*------------------------------------------------------------
      *
     C                   SETON                                        19
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C                   SETOFF                                       19
     C                   END
     C     FIXLN         IFEQ      CMRELN
     C                   MOVEL     CMRECD        RED
     C                   BITON     '4'           RED               1
     C                   MOVEL     RED           CMRECD
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN71         IFEQ      '0'
     C                   MOVEL     CMRECD        ZEIL1
     C     *IN20         IFEQ      '1'
     C                   MOVE      CMRECD        ZEIL1
     C                   MOVEL     CMRECD        ZZZL1
     C                   END
     C     CMSUGA        IFEQ      'A'
     C                   MOVEL     'ACC'         ACNO
     C                   END
     C     CMSUGA        IFEQ      'Z'
     C                   MOVEL     'DEL'         ACNO
     C                   END
     C                   END
     C     *IN71         IFEQ      '1'
     C                   MOVEL     CMRECD        ZEILW
     C                   MOVE      CMCDAT        ZEILW
     C     CMSUGA        IFEQ      'A'
     C                   MOVEL     'ACC'         ACNOW
     C                   END
     C     CMSUGA        IFEQ      'Z'
     C                   MOVEL     'DEL'         ACNOW
     C                   END
     C                   END
     C                   Z-ADD     CMRELN        STMT
     C                   ADD       1             LFD               4 0
     C                   WRITE     SFL
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     RRN           SUB       LFD           BACK              5 0
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     CSRCOR        BEGSR
     C     CSRKOR        DIV       256           LINE              3 0
     C                   MVR                     COL               3 0
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     DBPOS         BEGSR
     C                   Z-ADD     1             INTVAL            5 0
     C                   Z-ADD     #RCDS         RCDS              5 0
      *
     C*------------------------------------------------------------
      *
     C     #RCDS         IFGT      1
      *
     C*------------------------------------------------------------
      *
     C     RCDS          DOUEQ     1
     C                   DIV       2             RCDS
     C                   MULT      2             INTVAL
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     INTVAL        RCDNBR            5 0
      *
     C*------------------------------------------------------------
      *
     C     INTVAL        DOWGE     1
      *
     C*------------------------------------------------------------
      *
     C     RCDNBR        CHAIN     UPP02PR                            80
     C     CMRELN        CABEQ     POSNO         EXITP
     C                   DIV       2             INTVAL
      *
     C*------------------------------------------------------------
      *
     C     CMRELN        IFGT      POSNO
     C                   SUB       INTVAL        RCDNBR
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C     RCDNBR        ADD       INTVAL        TEST              5 0
      *
     C*------------------------------------------------------------
      *
     C     TEST          IFLE      #RCDS
     C                   ADD       INTVAL        RCDNBR
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
     C     EXITP         TAG
     C*------------------------------------------------------------
     C     RCDNBR        SETLL     UPP02PR
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     SCAN          BEGSR
     C                   MOVE      *BLANKS       FLDSCN
     C                   Z-ADD     O             OO
      *
     C*------------------------------------------------------------
      *
     C     *IN09         DOUEQ     '0'
     C     *IN10         ANDEQ     '0'
      *
     C*------------------------------------------------------------
      *
     C                   EXFMT     FORM10
     C     *IN63         CASEQ     '1'           PRTSCR
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN09         IFEQ      '1'
      *
     C*------------------------------------------------------------
      *
     C                   SUB       1             OO                3 0
      *
     C*------------------------------------------------------------
      *
     C     OO            IFEQ      0
      *
     C*------------------------------------------------------------
      *
     C     O             SUB       1             OO
      *
     C*------------------------------------------------------------
      *
     C     OO            IFEQ      0
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     1             OO
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN10         IFEQ      '1'
      *
     C*------------------------------------------------------------
      *
     C                   ADD       1             OO                3 0
      *
     C*------------------------------------------------------------
      *
     C     OO            IFEQ      O
      *
     C*------------------------------------------------------------
      *
     C     O             SUB       1             OO
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     OO            IFEQ      100
      *
     C*------------------------------------------------------------
      *
     C     OO            OCCUR     SCNDS
      *
     C*------------------------------------------------------------
      *
     C     SCNOLD        IFEQ      *BLANKS
     C     O             SUB       1             OO
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     O             IFNE      OO
     C     OO            OCCUR     SCNDS
     C                   MOVE      *BLANKS       FLDSCN
     C                   MOVEL     SCNOLD        FLDSCN
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     FLDSCN        IFNE      *BLANKS
      *
     C*------------------------------------------------------------
      *
     C     BACK2         IFNE      0
     C     FLDNF         ANDEQ     FLDSCN
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     1             BACK1
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     0             BACK2
     C                   MOVE      *BLANKS       FLDNF
     C     RRN           SUB       LFD           BACK1             5 0
     C                   ADD       5             BACK1             5 0
      *
     C*------------------------------------------------------------
      *
     C     BACK1         IFLE      0
     C                   Z-ADD     1             BACK1
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVEA     FLDSCN        SCN
     C                   MOVE      ''''          AP                1
     C                   Z-ADD     1             P                 2 0
      *
     C*------------------------------------------------------------
      *
     C     SCN(1)        IFEQ      AP
     C                   Z-ADD     2             M                 2 0
     C                   Z-ADD     2             STRPOS
      *
     C*------------------------------------------------------------
      *
     C     SCN(M)        DOWNE     AP
     C                   MOVEA     SCN(M)        SCN2(P)
     C                   ADD       1             P
     C                   ADD       1             M
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     1             M
     C                   Z-ADD     1             STRPOS
      *
     C*------------------------------------------------------------
      *
     C     SCN(M)        DOWNE     *BLANKS
     C                   MOVEA     SCN(M)        SCN2(P)
     C                   ADD       1             P
     C                   ADD       1             M
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVEA     SCN2          PATTRN
      *
     C*------------------------------------------------------------
      *
     C     PATTRN        IFNE      *BLANKS
      *
     C*------------------------------------------------------------
      *
     C     FWDBCK        IFNE      'B'
      *
     C*------------------------------------------------------------
      *
     C     BACK1         SETGT     UPP02PR
     C                   READ      UPP02PR                                91
      *
     C*------------------------------------------------------------
      *
     C                   ELSE
      *
     C*------------------------------------------------------------
      *
     C     BACK1         SETLL     UPP02PR
     C                   READP     UPP02PR                                91
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVE      CMRELN        SNDSEQ            5
      *
     C*------------------------------------------------------------
      *
     C     *IN91         DOWEQ     '0'
     C                   CALL      'QCLSCAN'                            96
     C                   PARM                    CMRECD
     C                   PARM      86            STRLEN            3 0
     C                   PARM                    STRPOS            3 0
     C                   PARM                    PATTRN           25
     C                   PARM      P             PATLEN            3 0
     C                   PARM      '1'           TRANS             1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '*'           WILD              1
     C                   PARM                    RSLT              3 0
     C   96              DUMP
     C                   SETOFF                                         96
     C     RSLT          IFGE      1
     C                   CALL      'UPC000560'
     C                   MOVEL     CMRELN        WPOS              5
     C                   MOVEL     'DBG0006'     ZAMSID
     C                   MOVEL     FLDSCN        ZAMSD1           56
     C                   MOVE      WPOS          ZAMSD1
     C                   MOVEL     ZAMSD1        ZAMSDA
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     RSLT          IFGE      1
     C     SRCSCN        ANDNE     CMRELN
     C                   LEAVE
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     FWDBCK        IFNE      'B'
     C                   READ      UPP02PR                                91
     C*------------------------------------------------------------
     C                   ELSE
     C*------------------------------------------------------------
     C                   READP     UPP02PR                                91
     C*------------------------------------------------------------
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     O             OCCUR     SCNDS
     C                   MOVEL     FLDSCN        SCNOLD
     C                   ADD       1             O                 2 0
      *
     C*------------------------------------------------------------
      *
     C     O             IFGT      100
     C                   Z-ADD     1             O
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     RSLT          IFLT      1
      *
     C*------------------------------------------------------------
      *
     C     BACK2         IFNE      0
     C     FLDNF         ANDEQ     FLDSCN
     C                   MOVEL     'DBG0003'     ZAMSID
     C                   MOVEL     FLDSCN        ZAMSDA
     C*------------------------------------------------------------
     C                   ELSE
     C*------------------------------------------------------------
     C                   MOVEL     'DBG0002'     ZAMSID
     C                   MOVEL     FLDSCN        ZAMSD1           56
     C                   MOVE      SNDSEQ        ZAMSD1
     C                   MOVEL     ZAMSD1        ZAMSDA
     C                   Z-ADD     BACK1         BACK2             5 0
     C                   MOVE      FLDSCN        FLDNF            50
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510 '
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C     *IN91         IFEQ      '0'
     C                   Z-ADD     0             BACK2
     C                   MOVE      *BLANKS       FLDNF
     C                   Z-ADD     CMRELN        SRCHLN
     C                   Z-ADD     CMRELN        SRCSCN            5 0
     C                   MOVEL     FLDSCN        FLDSC2           50
     C     RRN           SUB       5             RCDNBR
     C                   Z-ADD     RRN           RRN2              7 0
      *
     C*------------------------------------------------------------
      *
     C     RCDNBR        IFLE      0
     C                   Z-ADD     1             RCDNBR
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   Z-ADD     RCDNBR        RCDSAV            7 0
     C     RCDNBR        SETLL     UPP02PR
     C                   EXSR      PAGUP
     C                   Z-ADD     0             SRCHLN            5 0
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
     C*
     C*************************************************************
     C*
     C     PRTSCR        BEGSR
     C                   CALL      'UP000550'
     C                   ENDSR
     C*
     C*************************************************************
     C     WIND          BEGSR
     C     *IN19         IFEQ      '1'
     C                   MOVEL     '0'           *IN20
     C                   END
     C                   Z-ADD     *ZEROS        YYRRN
     C     RRN           SUB       LFD           YYRRN             5 0
     C                   ADD       1             YYRRN
     C     YYRRN         SETLL     UPP02PR
     C                   EXSR      PAGUP
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
     C*************************************************************
      *
     C*************************************************************
     C     ACCEP         BEGSR
     C                   MOVEL     *BLANKS       LIRG
     C                   Z-ADD     *ZEROS        AARRN             5 0
     C     RRN           SUB       LFD           AARRN             5 0
     C                   ADD       1             AARRN
     C                   Z-ADD     AARRN         BBRRN             5 0
     C                   EXSR      CSRCOR
     C     AARRN         ADD       LINE          AARRN
     C                   SUB       3             AARRN
     C     AARRN         CHAIN     UPP02PR                            65
     C     *IN65         IFEQ      '0'
     C     CMTYPA        IFNE      'N'
     C     CMTYPA        ANDNE     'O'
     C                   GOTO      TAG02
     C                   END
     C                   MOVEL     CMTYPA        FFTYPA            1
     C                   Z-ADD     AARRN         FROM1
     C                   MOVEA     '00'          *IN(27)
     C     FROM1         SETLL     UPP02PR
     C                   READ      UPP02PR                              2827
     C     FFTYPA        DOWEQ     CMTYPA
     C                   Z-ADD     CMRELN        TO1
     C     *IN27         CABEQ     '1'           TAG01
     C                   READ      UPP02PR                              2827
     C                   END
     C     TAG01         TAG
     C     TO1           CABEQ     FROM1         TAG02
     C                   Z-ADD     TO1           WTO1              5 0
     C     REST          TAG
     C                   EXFMT     FORM08
     C     LIRG          IFEQ      'R'
     C     TO1           CABGT     WTO1          REST
     C     TO1           CABLT     FROM1         REST
     C                   END
     C     LIRG          IFEQ      'R'
     C     FROM1         SETLL     UPP02PR
     C                   MOVEA     '00'          *IN(27)
     C                   READ      UPP02PR                              2827
     C     CMRELN        DOWLE     TO1
     C     CMTYPA        IFEQ      'N'
     C     CMTYPA        OREQ      'O'
     C     *IN13         IFEQ      '1'
     C                   MOVEL     'A'           CMSUGA
     C                   END
     C     *IN15         IFEQ      '1'
     C                   MOVEL     'Z'           CMSUGA
     C                   END
     C                   UPDATE    UPP02PR
     C                   END
     C                   READ      UPP02PR                              2827
     C     *IN27         CABEQ     '1'           TAG03
     C                   END
     C                   GOTO      TAG03
     C                   END
     C     TAG02         TAG
     C     LIRG          IFNE      'R'
     C     AARRN         CHAIN     UPP02PR                            65
     C     CMTYPA        IFEQ      'N'
     C     CMTYPA        OREQ      'O'
     C     *IN13         IFEQ      '1'
     C                   MOVEL     'A'           CMSUGA
     C                   END
     C     *IN15         IFEQ      '1'
     C                   MOVEL     'Z'           CMSUGA
     C                   END
     C                   UPDATE    UPP02PR
     C                   END
     C                   END
     C     TAG03         TAG
     C                   END
     C     BBRRN         SETLL     UPP02PR
     C                   EXSR      PAGUP
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
     C*************************************************************
      *
     C*************************************************************
     C     ACALL         BEGSR
     C                   Z-ADD     *ZEROS        CCRRN             5 0
     C     RRN           SUB       LFD           CCRRN             5 0
     C                   ADD       1             CCRRN
     C                   MOVEL     *BLANKS       RTRN
     C                   Z-ADD     *ZEROS        EERELN
     C                   Z-ADD     *ZEROS        GGRRN
     C                   CALL      'UPC000520'
     C                   PARM                    RTRN              1
     C                   PARM                    NEWL
     C                   PARM                    NEWF
     C                   PARM                    NEWM
     C                   PARM                    EERELN            5 0
     C                   PARM                    NEWME
     C                   PARM                    S
     C                   PARM                    MRGLIB
     C                   PARM                    WRKLIB
     C     RTRN          IFEQ      'N'
     C     EERELN        IFEQ      *ZEROS
     C     CCRRN         SETLL     UPP02PR
     C                   ELSE
     C     EERELN        SUB       9             GGRRN             5 0
     C     GGRRN         SETLL     UPP02PR
     C                   END
     C                   EXSR      PAGUP
     C                   ELSE
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
     C*************************************************************
     C     EDIT          BEGSR
     C                   Z-ADD     *ZEROS        CCRRN             5 0
     C     RRN           SUB       LFD           CCRRN             5 0
     C                   ADD       1             CCRRN
     C                   Z-ADD     CCRRN         BBRRN             5 0
     C                   EXSR      CSRCOR
     C     CCRRN         ADD       LINE          CCRRN
     C                   SUB       3             CCRRN
     C     CCRRN         CHAIN     UPP02PR                            80
     C                   MOVEL     *BLANKS       RTRN
     C                   CALL      'UPC000570B'
     C                   PARM                    RTRN              1
     C                   PARM                    CMRECD
     C                   PARM                    TYP
     C                   PARM                    CMRELN
     C                   UPDATE    UPP02PR
     C     BBRRN         SETLL     UPP02PR
     C                   EXSR      PAGUP
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
     C*************************************************************
     C     MOVE          BEGSR
     C                   Z-ADD     *ZEROS        VVRRN             5 0
     C     RRN           SUB       LFD           VVRRN             5 0
     C                   ADD       1             VVRRN
     C                   Z-ADD     VVRRN         WWRRN             5 0
     C                   EXSR      CSRCOR
     C     VVRRN         ADD       LINE          VVRRN
     C                   SUB       3             VVRRN
     C     VVRRN         CHAIN     UPP02PR                            80
     C                   MOVEL     CMRECD        ZZRECD            6
     C                   MOVE      ZZRECD        Z2RECD            2
     C     Z2RECD        IFEQ      'MV'
     C                   MOVEL     CMLINN        USRCNO            5
     C                   MOVEL     'UP000530B'   ZAPGM
     C                   CALL      'UPC000510'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM      'DBG0005'     ZAMSID            7
     C                   PARM      'UTMSGF'      ZAMSGF           10
     C                   PARM      USRCNO        ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   MOVE      *BLANKS       ZAPGM
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSGF
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
     C                   END
      *
     C     WWRRN         SETLL     UPP02PR
     C                   EXSR      PAGUP
      *
     C*------------------------------------------------------------
      *
     C                   ENDSR
