     H DEBUG DECEDIT('0,') DATEDIT(*DMY.)
      *****************************************************************
/**** *: OVRDBF MULTB ZZGBLANG                                      : *                     MD061518
/**** *: OVRDBF MULXB ZZGBXXLANG                                    : *   CUT004            MD061518
/**** *: OVRDBF MULTLANG ZZGBLANG                                   : *                     MD061518
/**** *: OVRDBF MULTLANX ZZGBXXLANG                                 : *   CUT004            MD061518
/**** *: OVRDBF MULTA ZZGBLANGL                                     : *                     MD061518
/**** *: OVRDBF MULXA ZZGBXLANGL                                    : *   CUT004            MD061518
/**** *: OVRDBF MULTO ZZGBLANGO                                     : *                     MD061518
/**** *: OVRDBF MULXO ZZGBXLANGO                                    : *   CUT004            MD061518
/**** *: OVRDBF MULTN ZZGBLANGN                                     : *                     MD061518
/**** *: RPGBASE                                                      *                     MD061518
/*STD *  RPGSQLBND                                                    *                     MD061518
/*EXI *  TEXT('Midas ML Assign MSGIDs to text in DSPF')
      *****************************************************************
      *                                                               *
      *  MIDAS  MULTI LANGUAGE MODULE                                 *
      *                                                               *
      *  ML0130 - ASSIGN MESSAGE ID'S TO TEXT IN DSPF                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061518           Date 23Jul23               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243900             Date 13Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018             Date 30Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 173348             DATE 10JAN00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUT004             DATE 24SEP98               *
      *                 087363             DATE 10MAY95               *
      *                 S01516             DATE 18JUL94               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061518 - Deliverable Data Split for ZZGBLANG and ZZGBXXLANG*
      *  MD046248 - Finastra Rebranding                               *
      *  243900 - Skip *DS3 or *DS4 on indicator area.                *
      *  CPK018 - MidasPlus packaging.                                *
      *           - SDLANGL0 in in the zone but this program is in    *
      *             the global layer. MLLANGL0 created to hold the    *
      *             global data.                                      *
      *           - Increase in the size of the arrays used in program*
      *             to allow for the multi-language of display files  *
      *             with 132 columns and 27 lines (*DS4)              *
      *  173348 - CRTOBJ adds multlang reference to core multilang    *
      *           ref file when not in Non-Core mode                  *
      *           Non-core messages being written to core non-english *
      *           message files                                       *
      *  CUT004 - Allow Core and Non-Core mode of compilation for     *
      *           Multilanguage                                       *
      *  087363 - Remove code which prevents MQ display files being   *
      *           created with message file text (multilanguaged)     *
      *  S01516 - Incorporation into core                             *
      *                                                               *
      *****************************************************************
     FRPGTEMP   IP   F   80        DISK
     FRPGOUTP   O  A F   80        DISK
     F*MULTLANG* O  A E           K DISK                                                    MD061518
     F*MULTLANX* O  A E           K DISK                                         CUT004     MD061518
     F**********                           RENAME(MLTLANGR:MULTXR)              CUT004      MD061518
     F*MULTA**** IF   E           K DISK                                                    MD061518
     F**********                           RENAME(MLTLANGR:MULTAR)                          MD061518
     F*MULXA**** IF   E           K DISK                                         CUT004     MD061518
     F**********                           RENAME(MLTLANGR:MULXAR)              CUT004      MD061518
     F*MULTB**** IF   E           K DISK                                                    MD061518
     F**********                           RENAME(MLTLANGR:MULTBR)                          MD061518
     F*MULXB**** IF   E           K DISK                                         CUT004     MD061518
     F**********                           RENAME(MLTLANGR:MULXBR)              CUT004      MD061518
     F*MULTN**** IF   E           K DISK                                                    MD061518
     F**********                           RENAME(MLTLANGR:MULTNR)                          MD061518
     F*MULTO**** IF   E           K DISK                                                    MD061518
     F**********                           RENAME(MLTLANGR:MULTOR)                          MD061518
     F*MULXO**** IF   E           K DISK                                         CUT004     MD061518
     F**********                           RENAME(MLTLANGR:MULXOR)              CUT004      MD061518
     F*SDLANGL0IF*E*******    K        DISK                                                   CPK018
     FMLLANGL0  IF   E           K DISK
     FSFLMSGPF  O    E             DISK
      * Field/Msg.Id for SFL texts
      *
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
     D**********          AR1        80  1               Input Src.Data                       CPK018
     D**********          AR2        80  1               MSG Text... line                     CPK018
     D**********          AR3        80  1               DDS Output Line                      CPK018
     D**********          AR4        80  1               Work Array                           CPK018
     D**********          AR5        80  1               DDS Output Coment                    CPK018
     D AR1             S              1    DIM(132)                             Input Src.Data
     D AR2             S              1    DIM(132)                             MSG Text... line
     D AR3             S              1    DIM(132)                             DDS Output Line
     D AR4             S              1    DIM(132)                             Work Array
     D AR5             S              1    DIM(132)                             DDS Output Coment
     D ARA             S              1    DIM(1024)                            Input Text......
     D ARB             S              1    DIM(1024)                            Text work array
      *
     D TEST            S              1    DIM(1) CTDATA PERRCD(1)
     D MESS            S             80    DIM(3) CTDATA PERRCD(1)
     D @ID             S              1    DIM(14) CTDATA PERRCD(14)
      *
     D                 DS
     D**MSGDNB**               1      7                                                     MD061518
     D  DSGDNB                 1      7                                                     MD061518
     D  NUMB                   4      7
     D  #ID                    3      3
     D                 DS
     D  WMSGF                  1     10
     D  WFNM                   1      2
     D                 DS
     D  OMSGF                  1     10
     D  OFNM                   1      2
     D  OLAN                   3      4
     D****************************************5   8 OMSF                  173348
     D  OMSF                   5     10                                         173348
     D                 DS
     D  MNBRN                  1     10
     D  MNBRN2                 4      6
     D                 DS
     D  POSDS                  1      3
     D  P1                     1      1
     D  P2                     2      2
     D ZZGBL         E DS                  EXTNAME(ZZGBLCTD)                                MD061518
     D ZZGBLO        E DS                  EXTNAME(ZZGBLCTD)                                MD061518
     D                                     PREFIX(O)                                        MD061518
     D LENRB           S              2  0                                                  MD061518
     D DFNN            S             10                                                     MD061518
     IRPGTEMP   NS
     I                                  1   80  DATA
     I                                  7    7  @CMT
     I                                  7   16  @IND
     I                                  9   12  @DS34
     I                                 17   17  @FMT          L1
     I                                 19   28  @FLDN
     I                                 33   34  @LNGTH
     I                                 40   41  @LINE
     I                                 42   44  @POS
     I                                 42   42  @P1
     I                                 43   43  @P2
     I                                 45   49  @45#49
     I                                 45   48  @45#48
     I*MULTAR***                                                                            MD061518
     I**********    DSPFNM                      DSPFA                                       MD061518
     I**********    MSGFNM                      MSGFA                                       MD061518
     I**********    MULNBR                      MNBRA                                       MD061518
     I**********    RCDFMT                      FMTNA                                       MD061518
     I**********    LEN                         LENRA                                       MD061518
     I*MULXAR***                                                                 CUT004     MD061518
     I**********    DSPFNM                      DSPFXA                          CUT004      MD061518
     I**********    MSGFNM                      MSGFXA                          CUT004      MD061518
     I**********    MULNBR                      MNBRXA                          CUT004      MD061518
     I**********    RCDFMT                      FMTNXA                          CUT004      MD061518
     I**********    LEN                         LENRXA                          CUT004      MD061518
     I*MULTBR***                                                                            MD061518
     I**********    DSPFNM                      DSPFB                                       MD061518
     I**********    MSGFNM                      MSGFB                                       MD061518
     I**********    MULNBR                      MNBRB                                       MD061518
     I**********    RCDFMT                      FMTNB                                       MD061518
     I**********    LEN                         LENRB                                       MD061518
     I*MULXBR***                                                                 CUT004     MD061518
     I**********    DSPFNM                      DSPFXB                          CUT004      MD061518
     I**********    MSGFNM                      MSGFXB                          CUT004      MD061518
     I**********    MULNBR                      MNBRXB                          CUT004      MD061518
     I**********    RCDFMT                      FMTNXB                          CUT004      MD061518
     I**********    LEN                         LENRXB                          CUT004      MD061518
     I*MULTNR***                                                                            MD061518
     I**********    MSGDNM                      DNMN                                        MD061518
     I**********    MSGDNB                      DNBN                                        MD061518
     I**********    MSGFNM                      FNMN                                        MD061518
     I**********    DSPFNM                      DFNN                                        MD061518
     I**********    RCDFMT                      FMTN                                        MD061518
     I**********    COL                         COLN                                        MD061518
     I**********    ROL                         ROLN                                        MD061518
     I**********    LEN                         LENN                                        MD061518
     I**********    MODU                        MODUN                                       MD061518
     I**********    MULNBR                      MNBRN                                       MD061518
     I*MULTOR***                                                                            MD061518
     I**********    MSGDNM                      DNMNO                                       MD061518
     I**********    MSGDNB                      DNBNO                                       MD061518
     I**********    MSGFNM                      FNMNO                                       MD061518
     I**********    DSPFNM                      DFNNO                                       MD061518
     I**********    RCDFMT                      FMTNO                                       MD061518
     I**********    COL                         COLNO                                       MD061518
     I**********    ROL                         ROLNO                                       MD061518
     I**********    LEN                         LENNO                                       MD061518
     I**********    MODU                        MODUO                                       MD061518
     I**********    MULNBR                      MNBRO                                       MD061518
      **********                                                                            MD061518
     I*MULXOR***                                                                 CUT004     MD061518
     I**********    MSGDNM                      DNMNXO                          CUT004      MD061518
     I**********    MSGDNB                      DNBNXO                          CUT004      MD061518
     I**********    MSGFNM                      FNMNXO                          CUT004      MD061518
     I**********    DSPFNM                      DFNNXO                          CUT004      MD061518
     I**********    RCDFMT                      FMTNXO                          CUT004      MD061518
     I**********    COL                         COLNXO                          CUT004      MD061518
     I**********    ROL                         ROLNXO                          CUT004      MD061518
     I**********    LEN                         LENNXO                          CUT004      MD061518
     I**********    MODU                        MODUXO                          CUT004      MD061518
     I**********    MULNBR                      MNBRXO                          CUT004      MD061518
      /EJECT
     C     *ENTRY        PLIST
     C**********         PARM                    MSGFNM                                     MD061518
     C                   PARM                    XXGFNM           10                        MD061518
     C**********         PARM                    DSPFNM                                     MD061518
     C                   PARM                    XXPFNM           10                        MD061518
     C                   PARM                    LIBRAR           10
     C                   PARM                    MULTLA           10
     C                   PARM                    MODUL             2
     C                   PARM                    CORE              1                           CUT00
     C                   PARM                    MSGFNX           10                           CUT00
      *
     C                   EVAL      MSGFNM = XXGFNM                                          MD061518
     C                   EVAL      DSPFNM = XXPFNM                                          MD061518
      *-Initialise all work fileds---------------FIRST CYCLE-----------
      *
     C     *IN11         IFEQ      '0'
     C                   EXSR      INZ
     C                   EXSR      INZ2
     C                   MOVE      '1'           *IN11
     C                   END
      *
      *-Do NOT process MIDAS/Q source----------------------------------
      *
     C***********MODUL     CABEQ'MQ'      END              >>> END >>>    087363
      *
      *-Save Format level information----------------------------------
      *
     C     *INL1         IFEQ      '1'
     C     @FMT          ANDEQ     'R'
     C     @CMT          ANDEQ     *BLANKS
     C                   MOVEL     @FLDN         RCDFMT
     C                   MOVE      '1'           *IN30
     C                   MOVE      '0'           *IN77
     C                   END
      *
      *-Move Core DDS to Input Src Array ------------------------------
      *
     C                   MOVEA     DATA          AR1
      *
      *-Process lines not needing any change --------------------------
      *
     C                   EXSR      NOCHG
      *
      *-Check pos 45-80 for 'Text.....' -------------------------------
      *
     C                   EXSR      FIND
      *
      *-Process Completed TEXT..... -----------------------------------
      *
     C     SIGN          CASEQ     'C'           TEXT
     C                   END
      *
      *----------------------------------------------------------------
      *
     C     END           TAG                                                    <<<<< END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Total Time Processing                                        *
      *                                                               *
      *****************************************************************
     CLR   *INLR         IFEQ      '1'
      *
      *-Process Completed TEXT.....
      *
     CLR   SIGN          CASEQ     'C'           TEXT
     CLR                 END
      *
     CLR                 END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * NOCHG  ----                                                   *
      *         Copy without change - Comments, Fields, Dsiplay Atr., *
      *         Keywords (TIME,DATE) and Hidden Fields to the new DDS *
      *****************************************************************
     C     NOCHG         BEGSR
      *
      * Comment Line ------------------------------
     C     @CMT          IFEQ      '*'
     C                   MOVEA     AR1           DATA2            80
     C                   EXCEPT    UPD1
     C                   GOTO      END                                          >>> END >>>
     C                   END
      *                                                                                       243900
      ** *DS3 or *DS4 line ------------------------                                           243900
      *                                                                                       243900
     C     @DS34         IFEQ      '*DS3'
     C     @DS34         OREQ      '*DS4'
     C                   MOVEA     AR1           DATA2
     C                   EXCEPT    UPD1
     C                   GOTO      END
     C                   END
      *
      * Save latest Line and Position values ------
      *  First FMT has been read
     C     *IN30         IFEQ      '1'
      * Save Line/Pos
     C     @LINE         IFNE      *BLANKS
     C                   MOVE      @LINE         #LINE
     C                   MOVE      @POS          #POS
     C                   ELSE
      * Calculate Position
      * (#POS + @POS   + #LNGTH)
     C     @P1           IFEQ      '+'
     C     @P2           OREQ      '+'
     C                   MOVE      @POS          POSDS
     C     P1            IFEQ      '+'
     C                   MOVE      '0'           P1
     C                   END
     C     P2            IFEQ      '+'
     C                   MOVE      '0'           P2
     C                   END
     C                   MOVE      POSDS         WRK3N             3 0
     C                   ADD       WRK3N         #POS
     C                   ADD       #LNGTH        #POS
     C                   END
     C                   END
      * Save Field Length
      *  (If Field Length is equal to zero,
      *   it will be calculated in FIND sr)
     C     @POS          IFNE      *BLANKS
     C                   IF        %SUBST(@LNGTH:1:1) = '+'                                 MD061518
     C                             or %SUBST(@LNGTH:1:1) = '-'                              MD061518
     C                   ELSE                                                               MD061518
     C                   MOVE      @LNGTH        #LNGTH
     C                   ENDIF                                                              MD061518
     C                   END
     C                   END
      /EJECT
      * Check for SFL -----------------------------
     C     *IN77         IFEQ      '0'
     C     *IN30         ANDEQ     '1'
     C     @45#48        COMP      'SFL '                                 77     SFL format
     C  N77@45#49        COMP      ' SFL '                                77     SFL format
     C                   END
      * Next field --------------------------------
     C     @FLDN         IFNE      *BLANKS
     C     SIGN          ANDEQ     *BLANKS
     C                   MOVEA     AR1           DATA2
     C                   EXCEPT    UPD1
     C                   GOTO      END                                          >>> END >>>
     C                   END
      *
      * Display Atributes, Keywords ---------------
     C     @POS          IFEQ      *BLANKS
     C     SIGN          ANDEQ     *BLANKS
     C                   MOVEA     AR1           DATA2
     C                   EXCEPT    UPD1
     C                   GOTO      END                                          >>> END >>>
     C                   END
      *
      * TIME, DATE --------------------------------
     C     @POS          IFNE      *BLANKS
     C     @45#49        IFEQ      'TIME '
     C     @45#49        OREQ      'DATE '
     C     @45#49        OREQ      ' TIME'
     C     @45#49        OREQ      ' DATE'
     C                   MOVEA     AR1           DATA2
     C                   EXCEPT    UPD1
     C                   GOTO      END                                          >>> END >>>
     C                   END
     C                   END
      *
      * Hidden & Message fields -------------------
     C     @LNGTH        IFNE      *BLANKS
     C     SIGN          ANDEQ     *BLANKS
     C                   MOVEA     AR1           DATA2
     C                   EXCEPT    UPD1
     C                   GOTO      END                                          >>> END >>>
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FIND   ----                                                   *
      *         Copy without change - Comments, Fields, Dsiplay Atr., *
      *         Keywords (TIME,DATE) and Hidden Fields to the new DDS *
      *                                                               *
      *****************************************************************
     C     FIND          BEGSR
      *
      * Ignore Non-Text lines -----------------------------
      *
     C     SIGN          IFEQ      ' '
     C     AR1(45)       ANDNE     ' '
     C     AR1(45)       ANDNE     WTEST
     C                   GOTO      END1                                         >>> END1 >>>
     C                   END
      *
      *----------------------------------------------------
      * Source Element being processed
      *
     C                   Z-ADD     44            E                 2 0
      *
      * Next Src. Element to be processed
      *
     C                   Z-ADD     45            Z                 2 0
      *
      * Process positions 45-80 ---------------------------
      *
     C     E             DOWLT     80
      *         =====================
     C                   ADD       1             E
     C                   ADD       1             Z
      *
      * Ignore First ' on text line ----------
      *  and Save Text's Line/Pos/Inds
      *                                          SIGN = ' '
     C     SIGN          IFEQ      ' '
     C     *IN21         ANDEQ     '0'
     C     WTEST         LOOKUP    AR1(E)                                 53
     C     E             ADD       1             Z
     C                   MOVE      @LINE         SLINE
     C                   MOVE      @POS          SPOS
     C                   MOVE      @IND          SIND
     C                   MOVE      @POS          POSDS
     C                   MOVE      '1'           *IN21
     C                   GOTO      BYP                                          >>> BYP >>>
     C                   END
      /EJECT
      *
      * Ignore begining blanks after the---------
      *  '+' continuation line
      *                                          SIGN = '+'
     C     SIGN          IFEQ      '+'
     C     *IN23         ANDEQ     '0'
      *
     C     AR1(E)        DOWEQ     ' '
     C     E             ANDLT     80
     C                   ADD       1             E
     C                   ADD       1             Z
     C                   END
      *
     C                   MOVE      '1'           *IN23
      * Ignore blank line
     C     AR1(E)        CABEQ     ' '           BYP                            >>> BYP >>>
     C                   END
      *
      * Check for End Of Text and ------------
      *  duplicate quotes
      *                                          ARE,E =  '
     C     AR1(E)        IFEQ      WTEST
      * Ignore ''
     C     Z             IFLT      81
     C     AR1(Z)        ANDEQ     WTEST
     C                   ADD       1             E
     C                   ADD       1             Z
     C                   GOTO      BLKX                                         >>> BLKX >>>
     C                   END
      *
      * Save Display Atributes, If any found at end of TEXT...
      *
     C                   MOVE      *BLANKS       #ATR             36
     C     Z             IFLE      80
     C                   MOVEA     AR1(Z)        #ATR
     C                   END
      *
      * Set TEXT completed sign
     C                   Z-ADD     F             #LNGTH
     C                   Z-ADD     F             F2
     C                   MOVEL     'C'           SIGN
     C                   GOTO      END1                                         >>> END1 >>>
     C                   END
      *---------------------------------------
     C     BLKX          TAG                                                    <<<<< BLKX
      *---------------------------------------
      /EJECT
      *
      * Check for TEXT... Continuation -------
      *                                          ARE,E =  + , -
     C     AR1(E)        IFEQ      '-'
     C     AR1(E)        OREQ      '+'
      *
      * Check for imbeded +,- in the TEXT
     C                   MOVE      *BLANKS       #AR1             40
     C     Z             IFLE      80
     C                   MOVEA     AR1(Z)        #AR1
     C                   END
      *
     C     #AR1          IFEQ      *BLANKS
     C                   MOVE      AR1(E)        SIGN
     C                   GOTO      END1                                         >>> END1 >>>
     C                   END
     C                   END
      *
      * Save TEXT.... element for outpot -----
      *
     C                   ADD       1             F
     C                   MOVE      AR1(E)        ARA(F)
      *
      *---------------------------------------
     C     BYP           TAG                                                    <<<<< BYP
      *---------------------------------------
      * E DOWLT 80 - end
     C                   END
      *
      *---------------------------------------
     C     END1          TAG                                                    <<<<< END1
      *---------------------------------------
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN23
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TEXT   ----                                                   *
      *         Process Completed TEXT.....  for output to new DDS    *
      *         If TEXT.... *GT 80 char., splitup into seperate lines *
      *                                                               *
      *****************************************************************
     C     TEXT          BEGSR
      *
     C     NXTLIN        TAG                                                    <<<< NXTLIN
      *
     C                   MOVE      *BLANKS       AR2
     C                   MOVE      *BLANKS       AR4
      *
      *         position   +  length
     C     #POS          ADD       F2            WRK4N             4 0
      *
      *====================================================
      * Split-up TEXT... into 80 char per line of text
      *
     C********** WRK4N     IFGT 80                                                            CPK018
     C     WRK4N         IFGT      132
      *         ===================
      *
      *
      * 1 |TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT|  ARA
      * 2 |TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT|
      * 3 |TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT|  TEXT.. array
      * 4 |TTTTTTTTTTTTTTTTTTTT                           |
      * nn|                                               |
     C                   Z-ADD     #POS          A                 3 0
     C                   MOVEA     ARA           AR4(A)
      *
      *   |          TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT|  AR4
      *
     C                   MOVEA     AR4(A)        AR2
      *
      *   |TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT          |  AR2
      *                                                     output array
      *
      * Calculate Text line's length
     C********** 81        SUB  #POS      #F2                                                 CPK018
     C     133           SUB       #POS          #F2
      * Setup Line Nbr
     C                   MOVE      SLINE         OLINE
      * Setup Start Position
     C                   MOVE      SPOS          OPOS
      /EJECT
      * Allow for atribute byte
      * ~~~~~~~~~~~~~~~~~~~~~~~~
      *  setup atribute byte in either last, or 1st position
      *   of an 80 character line
      *
     C     *IN20         IFEQ      '0'
     C                   MOVE      '1'           *IN20
     C     #F2           ADD       1             A
      *
      * X = Start Pos of the next Text field
      *    2nd pos next line
     C     ARA(A)        IFEQ      ' '
     C                   Z-ADD     2             X                 2 0
      *    1st pos next line
     C                   ELSE
     C                   Z-ADD     1             X
     C                   END
     C                   END
      *
      * Blank out Atribute byte in the Text array
      * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C     X             IFEQ      1
     C                   MOVE      ' '           AR2(80)
     C                   SUB       1             #F2
     C                   END
      *----------------------------------------------------
      * TEXT... field less than 80 char
      *
     C                   ELSE
      *            ===================
      *
     C                   MOVEA     ARA           AR2
      *   |TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT          |  AR2
      *                                                     output array
      * Setup Text's length
     C                   Z-ADD     F2            #F2
     C                   Z-ADD     F2            #LNGTH
      * Setup Line Nbr
     C                   MOVE      SLINE         OLINE
      * Setup Start Position
     C                   MOVE      SPOS          OPOS
      *
     C                   END
      *            ===================
      /EJECT
      *====================================================
      *
      * Output TEXT... line
      * ~~~~~~~~~~~~~~~~~~~~
     C                   EXSR      MSGSR
      *
      *====================================================
      *
      * Setup processing for the remaining TEXT.... line(s)
      *
     C********** WRK4N     IFGT 80                                                            CPK018
     C     WRK4N         IFGT      132
      *         ===================
      *
      * Outstanding TEXT... Length
     C                   SUB       #F2           F2                             length
     C                   SUB       1             F2                             atr.byte
      *
     C     F2            IFGT      0                                                        >>
      *
      * Next Line Nbr
     C                   ADD       1             #LINE
     C                   MOVE      #LINE         SLINE
      * Next Position
     C                   MOVE      *BLANKS       SPOS
     C                   MOVE      X             SPOS
     C                   Z-ADD     X             #POS
      *
      * Reset TEXT... array for next line's output
      *         length        atr+1     next pos
     C     #F2           ADD       2             A
     C                   MOVE      *BLANKS       ARB
     C                   MOVEA     ARA(A)        ARB
     C                   MOVE      *BLANKS       ARA
     C                   MOVEA     ARB           ARA
      * F2 > 0
     C                   END
      *
     C     F2            CABGT     0             NXTLIN                         >>> NXTLIN >>>
     C                   END
      *====================================================
      * Initialise Work fields
      *
     C                   EXSR      INZ2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MSGSR  ----                                                   *
      *         Process TEXT.... field for output to the new DDS      *
      *                                                               *
      *****************************************************************
      *
     C     MSGSR         BEGSR
      *
      *-TEXT Field DDS ------------------------------------
      *
     C                   MOVE      *BLANKS       AR3
     C                   MOVEA     MESS(2)       AR3
      * Condition Inds
     C                   MOVEA     SIND          AR3(7)
      * Field Name
     C                   MOVEA     WFNM          AR3(19)
     C                   MOVEA     'M'           AR3(21)
      *  &  Seq Nbr
     C                   ADD       1             SEQ1
     C                   MOVEL     SEQ1          SEQ3
     C                   MOVEA     SEQ3          AR3(22)
      * Field Length
     C                   MOVE      #F2           F2A               2
     C                   MOVEA     F2A           AR3(33)
      * Line Nbr (2A)
     C                   MOVEA     OLINE         AR3(40)
      * Pos. Nbr (3A)
     C                   MOVEA     OPOS          AR3(42)
      * MSGID/MSGF
     C                   MOVEA     WFNM          AR3(51)
     C                   MOVEA     'M'           AR3(53)
      *
     C*********************MOVEAWMSGF     AR3,59                          CUT004
      * Assign MSG ID Nbr
     C                   EXSR      EXCP1
     C                   MOVEA     WMSGF         AR3(59)                                       CUT00
      *
      * Check for SFL Text fields
     C     *IN77         IFEQ      '1'
     C                   MOVEA     AR3(19)       FLDNAM            6
     C                   MOVEA     AR3(51)       MSGID             7
     C                   MOVEA     *BLANKS       AR3(45)
     C                   WRITE     SFLMSGFM                             53
     C                   END
      * Output DDS
     C                   MOVEA     AR3           DATA2
     C                   EXCEPT    UPD1
      /EJECT
      *
      *-MSG comment line-----------------------------------
      *
     C                   MOVEA     *BLANKS       AR5
     C                   MOVEL     *BLANKS       WAR51
     C                   MOVEL     *BLANKS       WAR52
     C                   MOVEL     *BLANKS       WDNB1
     C                   MOVEL     *BLANKS       WDNB2
      *
     C                   MOVEL     MSGDNM        WAR51            73
     C                   MOVE      MSGDNM        WAR52             7
      *
     C                   MOVE      MSGDNB        WDNB1             4
     C                   MOVEL     MSGDNB        WDNB2             2
      *
     C                   MOVE      WDNB1         WDNB              6
     C                   MOVEL     WDNB2         WDNB
      *
     C                   MOVEA     MESS(3)       AR5
     C                   MOVEA     WAR51         AR5(8)
     C                   MOVEA     WDNB          AR5(1)
     C                   MOVEA     AR5           DATA2
     C                   EXCEPT    UPD1
      *
     C     WAR52         IFNE      *BLANKS
     C                   MOVEA     *BLANKS       AR5
     C                   MOVEA     MESS(3)       AR5
     C                   MOVEA     WAR52         AR5(8)
     C                   MOVEA     WDNB          AR5(1)
     C                   MOVEA     AR5           DATA2
     C                   EXCEPT    UPD1
     C                   END
      *
      *-MSG Field Display Atributes -------------------------
      *
     C     #ATR          IFNE      *BLANKS
     C                   MOVE      *BLANKS       AR4
     C                   MOVEA     #ATR          AR4(45)
     C                   MOVEA     AR4           DATA2
     C                   EXCEPT    UPD1
     C                   END
      *----------------------------------------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXCP1  ----                                                   *
      *         Assign Message ID to the TEXT.... line                *
      *                                                               *
      *****************************************************************
     C     EXCP1         BEGSR
      *
     C                   MOVEA     AR2           KEY2             80
     C                   MOVE      '0'           *IN50
      *
     C                   MOVE      CMSGFN        MSGFNM                                        CUT00
     C                   MOVE      CMSGFN        WMSGF                                         CUT00
     C                   MOVE      *BLANKS       MSGTXT            1                           CUT00
      *
      * Find TEXT... in a MSGF
     C     KEY3          KLIST
     C                   KFLD                    KEY2
     C                   KFLD                    WMSGF
      *
     C*****KEY3*         SETLL     MULTB                                                    MD061518
      **********                                                                            MD061518
     C**********         DO        *HIVAL                                                   MD061518
      **********                                                                            MD061518
     C*****KEY3*         READE     MULTB                                  50     EOF        MD061518
     C/EXEC SQL                                                                             MD061518
     C+ declare EXCCursor sensitive scroll cursor  for                                      MD061518
     C+ select MSGDNM, MSGDNB, COL, ROL, LEN, MODU                                          MD061518
     C+                       from ZZGBLCTD                                                 MD061518
     C+ where MSGFNM = :WMSGF and MSGDNM = :KEY2                                            MD061518
     C+ order by MSGDNM, MSGFNM                                                             MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ open EXCCursor                                                                      MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   DO        *HIVAL                                                   MD061518
     C/EXEC SQL                                                                             MD061518
     C+ fetch next from EXCCursor                                                           MD061518
     C+ into :MSGDNM, :DSGDNB, :COL, :ROL, :LENRB, :MODU                                    MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C*EXEC SQL                                                                             MD061518
     C* select MSGDNM, MSGDNB, COL, ROL, LEN, MODU                                          MD061518
     C* into :MSGDNM, :DSGDNB, :COL, :ROL, :LENRB, :MODU from ZZGBLCTD                      MD061518
     C* where MSGFNM = :WMSGF and MSGDNM = :KEY2                                            MD061518
     C* order by MULNBR desc                                                                MD061518
     C* fetch first 1 row only                                                              MD061518
     C*END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       50                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        50                    MD061518
     C                   ELSE                                                               MD061518
     C                   EVAL      MSGDNB = DSGDNB                                          MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
      *
      * If in Non-Core mode and MSG not in Core MSGF, try non-core MSGF   CUT004
     C     *IN50         IFEQ      *ON                                                         CUT00
     C     CORE          ANDEQ     'N'                                                         CUT00
     C                   MOVE      MSGFNX        WMSGF                                         CUT00
     C                   MOVE      *OFF          *IN50                                         CUT00
     C*****KEY3          SETLL     MULXB                                              CUT00 MD061518
     C*****KEY3          READE     MULXB                                  50          CUT00 MD061518
      *                                                                   CUT004
     C/EXEC SQL                                                                             MD061518
     C+ select MSGDNM, MSGDNB, COL, ROL, LEN, MODU                                          MD061518
     C+ into :MSGDNM, :DSGDNB, :COL, :ROL, :LENRB, :MODU from ZZGBLBTD                      MD061518
     C+ where MSGFNM = :WMSGF and MSGDNM = :KEY2                                            MD061518
     C+ order by MULNBR desc                                                                MD061518
     C+ fetch first 1 row only                                                              MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       50                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        50                    MD061518
     C                   ELSE                                                               MD061518
     C                   EVAL      MSGDNB = DSGDNB                                          MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
     C     *IN50         IFEQ      *OFF                                                        CUT00
      *                    Text found in Non-Core msg-ref file            CUT004
     C                   MOVE      'N'           MSGTXT                                        CUT00
     C                   ENDIF                                                                 CUT00
      *                                                                   CUT004
     C                   ENDIF                                                                 CUT00
      *                                                                   CUT004
      * Text not found in either msg-ref file                             CUT004
     C     *IN50         IFEQ      *ON                                                      MD061518
     C/EXEC SQL                                                                             MD061518
     C+ close EXCCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
     C                   ENDIF                                                              MD061518
     C     *IN50         CABEQ     '1'           BYP2                           >>> BYP2 >>>
     C***********LENRB*****CABEQ#F2       RTR4             >>> RTR4 >>>   CUT004
      *
      * Text found in Core msg-ref file ?                                 CUT004
     C     LENRB         IFEQ      #F2                                                         CUT00
     C     MSGTXT        ANDEQ     *BLANKS                                                     CUT00
     C                   MOVE      'C'           MSGTXT            1                           CUT00
     C/EXEC SQL                                                                             MD061518
     C+ close EXCCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
     C                   GOTO      RTR4                                         >>> RTR4 >>>   CUT00
     C                   ENDIF                                                                 CUT00
      *
      * Text found in Non-Core msg-ref file ?                             CUT004
     C     MSGTXT        IFEQ      'N'                                                         CUT00
     C/EXEC SQL                                                                             MD061518
     C+ close EXCCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
     C                   GOTO      RTR4                                         >>> RTR4 >>>   CUT00
     C                   ENDIF                                                                 CUT00
      *
      * DO *hival end
      * DO FINISH = 'Y'                                                                     MD061518
     C                   END
     C/EXEC SQL                                                                             MD061518
     C+ close EXCCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
      *
      * -----------------------------
     C     RTR4          TAG                                                     <<<< RTR4
      * -----------------------------
      *
     C                   MOVEA     #ID           AR3(53)
     C                   MOVEA     NUMB          AR3(54)
      *
      * Find TEXT...& DSPF  in a MSGF
     C     KEY7          KLIST
     C                   KFLD                    KEY2
     C                   KFLD                    WMSGF
     C                   KFLD                    DSPFNM
      *
     C     MSGTXT        IFEQ      'C'                                                         CUT00
     C*****KEY7*         CHAIN     MULTO                              53                    MD061518
     C/EXEC SQL                                                                             MD061518
     C+ select * into :ZZGBLO from ZZGBLCTD                                                 MD061518
     C+ where MSGFNM = :WMSGF and MSGDNM = :KEY2 and DSPFNM = :DSPFNM                       MD061518
     C+ fetch first 1 row only                                                              MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       53                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        53                    MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
     C                   ELSE                                                                  CUT00
     C*****KEY7*         CHAIN     MULTO                              53                    MD061518
     C/EXEC SQL                                                                             MD061518
     C+ select * into :ZZGBLO from ZZGBLBTD                                                 MD061518
     C+ where MSGFNM = :WMSGF and MSGDNM = :KEY2 and DSPFNM = :DSPFNM                       MD061518
     C+ fetch first 1 row only                                                              MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       53                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        53                    MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
     C                   ENDIF                                                                 CUT00
      *
     C     *IN53         IFEQ      '1'
      * No entry for text AND dspf in the msgf (Old text, NeW DSPF)       CUT004
     C                   MOVE      'Y'           NWDSPF            1                           CUT00
     C                   Z-ADD     #F2           LEN
     C                   GOTO      BYP3
     C                   END
      * TEXT.. & DSPF found
     C                   GOTO      BYP9                                         >>> BYP9 >>>
      * ---------------------------------------------------
      /EJECT
      * -----------------------------
     C     BYP2          TAG                                                    <<<< BYP2
      * -----------------------------
      * Setup DSPF/MSGID for the TEXT...
      *
     C                   MOVEL     *HIVAL        KEY1              7
      *
     C     KEY           KLIST
     C                   KFLD                    KEY1
     C                   KFLD                    WMSGF
      *
     C     CORE          IFEQ      'Y'                                                         CUT00
     C*****KEY**         SETGT     MULTAR                                                   MD061518
     C**********         READP     MULTAR                                 70     NOT EQUAL  MD061518
     C/EXEC SQL                                                                             MD061518
     C+ declare BYCCursor sensitive scroll cursor  for                                      MD061518
     C+ select MSGDNM, MSGDNB, COL, ROL, MODU                                               MD061518
     C+                       from ZZGBLCTD                                                 MD061518
     C+ where MSGFNM = :WMSGF                                                               MD061518
     C+ order by MSGDNB desc                                                                MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ open BYCCursor                                                                      MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ fetch next from BYCCursor                                                           MD061518
     C+ into :MSGDNM, :DSGDNB, :COL, :ROL, :MODU                                            MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       70                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        70                    MD061518
     C                   ELSE                                                               MD061518
     C                   EVAL      MSGDNB = DSGDNB                                          MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ close BYCCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   ELSE                                                                  CUT00
     C*****KEY**         SETGT     MULXAR                                             CUT00 MD061518
     C**********         READP     MULXAR                                 70     NOT ECUT00 MD061518
     C/EXEC SQL                                                                             MD061518
     C+ declare BYBCursor sensitive scroll cursor  for                                      MD061518
     C+ select MSGDNM, MSGDNB, COL, ROL, MODU                                               MD061518
     C+                       from ZZGBLCTD                                                 MD061518
     C+ where MSGFNM = :WMSGF                                                               MD061518
     C+ order by MSGDNB desc                                                                MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ open BYBCursor                                                                      MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ fetch next from BYBCursor                                                           MD061518
     C+ into :MSGDNM, :DSGDNB, :COL, :ROL, :MODU                                            MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   SETOFF                                       70                    MD061518
     C                   IF        SQLCODE <> 0                                             MD061518
     C                   SETON                                        70                    MD061518
     C                   ELSE                                                               MD061518
     C                   EVAL      MSGDNB = DSGDNB                                          MD061518
     C                   ENDIF                                                              MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ close BYBCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   ENDIF                                                                 CUT00
      *
      * 1st Msg ID
     C     *IN70         IFEQ      '1'
      *
     C     CORE          IFEQ      'Y'                                                         CUT00
     C                   MOVEL     'M'           #ID
     C                   ELSE                                                                  CUT00
     C                   MOVEL     'A'           #ID                                           CUT00
     C                   ENDIF                                                                 CUT00
      *
     C                   MOVEA     '0001'        AR3(54)
     C                   MOVEL     '0001'        NUMB
      * Next Msg ID
     C                   ELSE
      *
     C                   MOVEL     NUMB          WNUMB             4 0
      *
      *   If the message found is the last one for this letter
      *   i.e. it is ZZx9999 then use the next leter in sequence
     C     WNUMB         IFEQ      9999
     C                   Z-ADD     0             WNUMB
     C                   Z-ADD     1             @@                2 0
     C     #ID           LOOKUP    @ID(@@)                                60
     C                   ADD       1             @@
     C                   MOVEL     @ID(@@)       #ID
     C                   END
      *
     C                   ADD       1             WNUMB
     C                   MOVEL     WNUMB         NUMB
     C                   MOVEA     NUMB          AR3(54)
     C                   END
      *
      * Create Message for this TEXT...
      *
     C                   EVAL      MSGDNB = DSGDNB                                          MD061518
     C                   MOVEA     AR2           MSGDNM
     C                   MOVEA     #ID           AR3(53)
     C                   MOVE      #ID           WFNMA             3
     C******************   MOVE 'M'       WFNMA   3
     C                   MOVEL     WFNM          WFNMA
     C                   MOVEL     WFNMA         MSGDNB
     C                   MOVE      OLINE         COL
     C                   MOVE      OPOS          ROL
     C                   Z-ADD     #F2           LEN
      *
     C     CORE          IFEQ      'N'                                                         CUT00
     C                   MOVE      MSGFNX        WMSGF                                         CUT00
     C                   ENDIF                                                                 CUT00
      *
     C                   CALL      'MLC0140'                                                       +
     C                   PARM                    WMSGF
     C                   PARM                    MSGDNM
     C                   PARM                    MSGDNB
     C                   PARM                    LIBRAR
     C                   PARM                    MULTLA
      *
     C                   EXCEPT    UPD3
      /EJECT
      *
     C                   MOVEL     *LOVAL        OKEY              2
     C********** OKEY      SETLLSDLANGDF                                                      CPK018
     C     OKEY          SETLL     @LANGL0
      *
     C                   DO        *HIVAL
      *
     C**********           READ SDLANGDF                 80 EOF                               CPK018
     C                   READ      @LANGL0                                80     EOF
      *
     C     *IN80         CABEQ     '1'           BYP3                           >>> BYP3 >>>
      *
     C     RECI          IFEQ      'X'
     C                   MOVEL     SCUNT         OLAN
      *                                                                   173348
     C     CORE          IFEQ      'N'                                                         17334
     C                   MOVE      'XXMSGF'      OMSF                                          17334
     C                   ENDIF                                                                 17334
      *                                                                   173348
     C                   CALL      'MLC0140'
     C                   PARM                    OMSGF
     C                   PARM                    MSGDNM
     C                   PARM                    MSGDNB
     C                   PARM                    LIBRAR
     C                   PARM                    MULTLA
     C                   END
      * DO *hival end
     C                   END
      *
      * -----------------------------
     C     BYP3          TAG                                                    <<<< BYP3
      * -----------------------------
      *
     C                   MOVEL     *BLANKS       MNBR8
     C                   MOVEL     *BLANKS       MNBR7
      *
     C                   MOVEL     WFNM          MNBR8
     C                   MOVE      'M'           MNBR8             3
     C                   MOVE      SEQ3          MNBR7             6
     C                   MOVEL     MNBR8         MNBR7
     C                   MOVEL     MNBR7         MULNBR
     C                   MOVEL     MODUL         MODU
      *                                                                   CUT004
      **If*Core*Mode*or*(Non-Core*mode*but*text*found*in************CUT004173348
      **Core*msg*ref*file)******************************************CUT004173348
      * If Core Mode                                                      173348
     C     CORE          IFEQ      'Y'                                          *CORE*         CUT00
     C***********MSGTXT    OREQ 'C'                                 CUT004173348
     C**********         WRITE     MLTLANGR                                                 MD061518
     C                   EVAL      DSGDNB = MSGDNB                                          MD061518
     C/exec SQL                                                                             MD061518
     C+ insert into ZZGBLCTD                                                                MD061518
     C+ (                                                                                   MD061518
     C+   MSGDNM                                                                            MD061518
     C+  ,MSGDNB                                                                            MD061518
     C+  ,MSGFNM                                                                            MD061518
     C+  ,DSPFNM                                                                            MD061518
     C+  ,RCDFMT                                                                            MD061518
     C+  ,COL                                                                               MD061518
     C+  ,ROL                                                                               MD061518
     C+  ,LEN                                                                               MD061518
     C+  ,MODU                                                                              MD061518
     C+  ,MULNBR                                                                            MD061518
     C+  ,MSMODE                                                                            MD061518
     C+ )                                                                                   MD061518
     C+ values                                                                              MD061518
     C+ (                                                                                   MD061518
     C+   :MSGDNM                                                                           MD061518
     C+  ,:DSGDNB                                                                           MD061518
     C+  ,:MSGFNM                                                                           MD061518
     C+  ,:DSPFNM                                                                           MD061518
     C+  ,:RCDFMT                                                                           MD061518
     C+  ,:COL                                                                              MD061518
     C+  ,:ROL                                                                              MD061518
     C+  ,:LEN                                                                              MD061518
     C+  ,:MODU                                                                             MD061518
     C+  ,:MULNBR                                                                           MD061518
     C+  ,'C'                                                                               MD061518
     C+ )                                                                                   MD061518
     C/end-exec                                                                             MD061518
     C/exec SQL                                                                             MD061518
     C+ insert into ZZGBLXTD                                                                MD061518
     C+ (                                                                                   MD061518
     C+   MSGDNM                                                                            MD061518
     C+  ,MSGDNB                                                                            MD061518
     C+  ,MSGFNM                                                                            MD061518
     C+  ,DSPFNM                                                                            MD061518
     C+  ,MULNBR                                                                            MD061518
     C+  ,MSMODE                                                                            MD061518
     C+ )                                                                                   MD061518
     C+ values                                                                              MD061518
     C+ (                                                                                   MD061518
     C+   :MSGDNM                                                                           MD061518
     C+  ,:DSGDNB                                                                           MD061518
     C+  ,:MSGFNM                                                                           MD061518
     C+  ,:DSPFNM                                                                           MD061518
     C+  ,:MULNBR                                                                           MD061518
     C+  ,'C'                                                                               MD061518
     C+ )                                                                                   MD061518
     C/end-exec                                                                             MD061518
     C                   ELSE                                                                  CUT00
     C                   MOVE      MSGFNX        MSGFNM                                        CUT00
     C**********         WRITE     MULTXR                                             CUT00 MD061518
     C                   EVAL      DSGDNB = MSGDNB                                          MD061518
     C/exec SQL                                                                             MD061518
     C+ insert into ZZGBLBTD                                                                MD061518
     C+ (                                                                                   MD061518
     C+   MSGDNM                                                                            MD061518
     C+  ,MSGDNB                                                                            MD061518
     C+  ,MSGFNM                                                                            MD061518
     C+  ,DSPFNM                                                                            MD061518
     C+  ,RCDFMT                                                                            MD061518
     C+  ,COL                                                                               MD061518
     C+  ,ROL                                                                               MD061518
     C+  ,LEN                                                                               MD061518
     C+  ,MODU                                                                              MD061518
     C+  ,MULNBR                                                                            MD061518
     C+  ,MSMODE                                                                            MD061518
     C+ )                                                                                   MD061518
     C+ values                                                                              MD061518
     C+ (                                                                                   MD061518
     C+   :MSGDNM                                                                           MD061518
     C+  ,:DSGDNB                                                                           MD061518
     C+  ,:MSGFNM                                                                           MD061518
     C+  ,:DSPFNM                                                                           MD061518
     C+  ,:RCDFMT                                                                           MD061518
     C+  ,:COL                                                                              MD061518
     C+  ,:ROL                                                                              MD061518
     C+  ,:LEN                                                                              MD061518
     C+  ,:MODU                                                                             MD061518
     C+  ,:MULNBR                                                                           MD061518
     C+  ,'B'                                                                               MD061518
     C+ )                                                                                   MD061518
     C/end-exec                                                                             MD061518
     C/exec SQL                                                                             MD061518
     C+ insert into ZZGBLXTD                                                                MD061518
     C+ (                                                                                   MD061518
     C+   MSGDNM                                                                            MD061518
     C+  ,MSGDNB                                                                            MD061518
     C+  ,MSGFNM                                                                            MD061518
     C+  ,DSPFNM                                                                            MD061518
     C+  ,MULNBR                                                                            MD061518
     C+  ,MSMODE                                                                            MD061518
     C+ )                                                                                   MD061518
     C+ values                                                                              MD061518
     C+ (                                                                                   MD061518
     C+   :MSGDNM                                                                           MD061518
     C+  ,:DSGDNB                                                                           MD061518
     C+  ,:MSGFNM                                                                           MD061518
     C+  ,:DSPFNM                                                                           MD061518
     C+  ,:MULNBR                                                                           MD061518
     C+  ,'B'                                                                               MD061518
     C+ )                                                                                   MD061518
     C/end-exec                                                                             MD061518
     C                   ENDIF                                                                 CUT00
      *
      * -----------------------------
     C     BYP9          ENDSR                                                  <<<< BYP9
      * -----------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      * INZ    ----                                                   *
      *         First Cycle processing only                           *
      *                                                               *
      *****************************************************************
      *
     C     INZ           BEGSR
      *
     C     *LIKE         DEFINE    @LINE         OLINE
     C     *LIKE         DEFINE    @LINE         SLINE
     C     *LIKE         DEFINE    @POS          OPOS
     C     *LIKE         DEFINE    @POS          SPOS
     C     *LIKE         DEFINE    @IND          SIND
      *
     C                   Z-ADD     0             #LINE             2 0
     C                   Z-ADD     0             #POS              3 0
     C                   Z-ADD     0             #LNGTH            2 0
      *
      * TEST NEW FIELD
     C                   MOVEL     *HIVAL        KEY8             10
      * Store Core Message File name in storage field                     CUT004
     C                   MOVEL     MSGFNM        CMSGFN           10                           CUT00
      *
     C     KEY9          KLIST
     C                   KFLD                    KEY8
     C                   KFLD                    DSPFNM
      *
     C*****KEY9*         SETGT     MULTNR                                                   MD061518
      **********                                                                            MD061518
     C**********         READP     MULTNR                                 53     NOT EQUAL  MD061518
      **********                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ declare INZCursor sensitive scroll cursor  for                                      MD061518
     C+ select MULNBR, DSPFNM from ZZGBLCTD                                                 MD061518
     C+ order by MULNBR desc                                                                MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ open INZCursor                                                                      MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C/EXEC SQL                                                                             MD061518
     C+ fetch next from INZCursor into :MNBRN, :DFNN                                        MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518

     C     DSPFNM        IFNE      DFNN
     C                   Z-ADD     1             SEQ1              3 0
     C                   ELSE
     C                   MOVEL     MNBRN2        MNBRN3            3 0
     C                   Z-ADD     MNBRN3        SEQ1
     C                   END
      *
      * Blank out work fields
      *
     C                   MOVE      TEST(1)       WTEST             1
     C                   MOVE      MSGFNM        WMSGF
     C*********************MOVE 'MSGF'    OMSF                            173348
     C                   MOVEL(P)  'MSGF'        OMSF                                          17334
     C                   MOVE      WFNM          OFNM
      *
     C/EXEC SQL                                                                             MD061518
     C+ close INZCursor                                                                     MD061518
     C/END-EXEC                                                                             MD061518
                                                                                            MD061518
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INZ2   ----                                                   *
      *         First Cycle and Detail Time processing                *
      *          work fields initialisation                           *
      *                                                               *
      *****************************************************************
      *
     C     INZ2          BEGSR
      *
     C                   Z-ADD     0             E                 2 0
     C                   Z-ADD     0             F                 4 0
     C                   Z-ADD     0             F2                4 0
     C                   Z-ADD     0             #F2               2 0
      *
     C                   Z-ADD     0             CPT               3 0
     C                   Z-ADD     0             CPT1              3 0
     C                   Z-ADD     0             CPT3              3 0
      *
     C                   MOVE      *BLANKS       SEQ3              3
     C                   MOVE      *BLANKS       SIGN              1
      *
     C                   MOVEA     *BLANKS       AR2
     C                   MOVEA     *BLANKS       AR3
      *
     C                   MOVEA     *BLANKS       ARA
     C                   MOVEA     *BLANKS       ARB
      *
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN23
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     ORPGOUTP   EADD         UPD1
     O                       DATA2               80
      *
     OQSYSPRT   H    1P                     2 01
     O         OR    OF
     O                                           60 'NEW MESSAGES ADDED'
     O                                           76 'TO MESSAGE FILE'
     O          D    1P                     1
     O         OR    OF
     O                                           18 'DISPLAY FILE NAME:'
     O                       DSPFNM              30
     O          D    1P                  1  1
     O         OR    OF
     O                                           12 'MESSAGE ID'
     O                                           23 'MESS FILE'
     O                                           46 'LIB SOURCE'
     O                                           61 'MESSAGE TEXT'
     O          EF           UPD3           1
     O                       MSGDNB              13
     O                       WMSGF               25
     O*************************LIBRAR    47                               CUT004
     O                       MULTLA              47                             CUT004
     O                       MSGDNM             130
      * === end of source ===
**   TEST
'
**   MESSAGE FILE NAME
     A            MSGNM         10A  H      TEXT('MESSAGE FILE NAME')
     A            MUL             A         MSGID(                  )
      *
**
MNOPQRSTUVWXYZ
