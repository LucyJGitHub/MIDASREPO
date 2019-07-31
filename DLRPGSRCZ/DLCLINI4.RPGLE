     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Update class on account keys file')           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLCLINI4 - Update class on account keys file                 *
      *             (Dealing initialisation program)                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FACKEYAL   IP   E             DISK    RENAME(ACKEYALF:INACKF)
     FACKEY     UF   E           K DISK    INCLUDE(ACKEYALF) PREFIX(N_)
     FFDDTSTL0  UF A E           K DISK
     FSDTCLDPD  IF   E             DISK
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D DB              S              2    DIM(10) CTDATA PERRCD(10)
     D DC              S              2    DIM(30) CTDATA PERRCD(30)
     D DD              S              2    DIM(30) CTDATA PERRCD(30)
     D DE              S              2    DIM(30) CTDATA PERRCD(30)
     D DG              S              2    DIM(30) CTDATA PERRCD(30)
 
     D IGNDT           S              2    DIM(999)   ASCEND
     D DTSTCL          S              8    DIM(9999)  ASCEND
 
     D                 DS
     D R_DTSTCL                1      8
     D R_DTYP                  1      2
     D R_DLST                  3      4
     D R_CLAS                  5      8
 
     D FDDTST        E DS                  EXTNAME(FDDTSTPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C                   MOVEL     AKEY          InAKEY           14
     C                   MOVE      AKEY          InClass           4
 
     C     RECI          CABNE     'D'           BYPASS
     C     InClass       CABNE     *BLANK        BYPASS
 
     C                   MOVEL     *BLANK        R_FILE
 
     C                   EVAL      R_DTYP   = %SubST(AKEY: 01: 2)
     C                   EVAL      R_EVTPOS = %SubST(AKEY: 03: 1)
     C                   EVAL      R_DLST   = %SubST(AKEY: 04: 2)
     C                   EVAL      R_MIDPOS = %SubST(AKEY: 06: 4)
 
     C                   EXSR      CHECK_DTYP
 
     C     R_FILE        IFEQ      'DB'
     C                   MOVE      DBCLAS        AKEY             14
     C     R_DTYP        IFEQ      'NX'
     C                   MOVE      NXCLAS        AKEY
     C                   ENDIF
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DC'
     C                   MOVE      DCCLAS        AKEY
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DD'
     C                   MOVE      DDCLAS        AKEY
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DE'
     C                   MOVE      DECLAS        AKEY
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DG'
     C                   MOVE      DGCLAS        AKEY
     C                   ENDIF
 
      * Update a/c key only if by doing so no duplicate is created
 
     C     InAKEY        IFNE      AKEY
     C     AKEY          CHAIN     ACKEYALF                           99
     C     *IN99         IFEQ      *ON
     C     InAKEY        CHAIN     ACKEYALF                           99
     C                   MOVEL     AKEY          N_AKEY
     C                   EXCEPT    ACK
     C                   ENDIF
     C                   ENDIF
 
      * Store deal type/sub-type/class changes
 
     C     InAKEY        IFNE      AKEY
     C                   MOVE      AKEY          R_CLAS
     C                   Z-ADD     1             TS                5 0
     C     R_DTSTCL      LOOKUP    DTSTCL(TS)                             99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    DTSTCL(TS)                             99
     C                   MOVEL     R_DTSTCL      DTSTCL(TS)
     C                   ENDIF
     C                   ENDIF
 
     C     BYPASS        TAG
 
     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     CHECK_DTYP    BEGSR
     C                   SETOFF                                       99
     C                   Z-ADD     1             X                 2 0
 
     C     R_DTYP        LOOKUP    DB(X)                                  99
     C     *IN99         IFEQ      *ON
     C     R_DTYP        IFNE      'OP'
     C     R_DTYP        OREQ      'OP'
     C     R_EVTPOS      ANDEQ     'D'
     C     R_MIDPOS      ANDNE     '    '
     C     R_DTYP        OREQ      'OP'
     C     R_EVTPOS      ANDEQ     'V'
     C                   MOVEL     'DB'          R_FILE
     C                   ENDIF
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DC(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DC'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DD(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DD'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DE(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DE'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     R_DTYP        LOOKUP    DG(X)                                  99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'DG'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C                   Z-ADD     1             IG                4 0
     C     R_DTYP        LOOKUP    IGNDT(IG)                              99
     C     *IN99         IFEQ      *OFF
     C     '  '          LOOKUP    IGNDT(IG)                              99
     C                   MOVEL     R_DTYP        IGNDT(IG)
     C                   ENDIF
 
     C     END_CHECK     ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
 
      * Sort report arrays
 
     C                   SORTA     IGNDT
     C                   SORTA     DTSTCL
 
     C                   OPEN      QSYSPRT
 
      * Report error or completion
 
     C     Count         IFNE      1
     C                   EXCEPT    ERR
     C                   SETON                                        U8
     C                   ELSE
     C                   EXCEPT    FIN
     C                   ENDIF
 
      * Report deal types ignored
 
     C                   Z-ADD     1             IG
     C     *BLANK        LOOKUP    IGNDT(IG)                          99
     C     *IN99         IFEQ      *ON
     C     IG            DOWLE     999
     C                   EXCEPT    IGN
     C                   ADD       1             IG
     C                   ENDDO
     C                   ENDIF
 
      * Add deal type/sub types/classes
 
     C                   Z-ADD     1             TS
     C     *BLANK        LOOKUP    DTSTCL(TS)                         99
     C     *IN99         IFEQ      *ON
     C                   EXCEPT    TSI
     C     TS            DOWLE     9999
     C                   MOVEL     DTSTCL(TS)    R_DTSTCL
     C     DTSTK         CHAIN     FDDTSTPD                           99
     C     *IN99         IFEQ      *ON
     C                   EXSR      ADD_FDDTST
     C                   EXCEPT    TSA
     C                   ENDIF
     C                   ADD       1             TS
     C                   ENDDO
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ADD_FDDTST    BEGSR
 
      * If deal/sub-type exists, just amend its class
 
     C                   MOVEL     *BLANK        R_CLAS
     C     DTSTK         CHAIN     FDDTSTPD                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     DTSTCL(TS)    R_DTSTCL
     C                   MOVEL     R_CLAS        CLAS11
     C                   UPDATE    FDDTSTPD
     C                   ELSE
 
      * Otherwise, add a new deal/sub-type/class record (set with defaults, if present)
 
     C                   MOVEL     DTSTCL(TS)    R_DTSTCL
     C     DTSTKP        CHAIN     FDDTSTPD                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     R_CLAS        CLAS11
     C                   ELSE
     C                   CLEAR                   FDDTST
     C                   MOVEL     R_DTYP        DTPE11
     C                   MOVEL     R_DLST        DLST11
     C                   MOVEL     R_CLAS        CLAS11
     C                   EVAL      NARR11 = '* NAME REQUIRED *'
     C                   Z-ADD     BJRDNB        LCD11
     C                   MOVEL     'I'           TYLC11
     C                   MOVEL     'OTH'         INNR
     C                   ENDIF
     C                   WRITE     FDDTSTPD
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE           10
     C                   MOVEL     *BLANK        R_EVTPOS          1
     C                   MOVEL     *BLANK        R_MIDPOS          4
     C     DTSTK         KLIST
     C                   KFLD                    R_DTYP
     C                   KFLD                    R_DLST
     C                   KFLD                    R_CLAS
     C     DTSTKP        KLIST
     C                   KFLD                    R_DTYP
     C                   KFLD                    R_DLST
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   READ      SDTCLDD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             Count             3 0
     C                   READ      SDTCLDD0                               99
     C                   ENDDO
 
     C     Count         IFNE      1
     C                   SETON                                        LR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            ERR         1
     O                                           26 'PROGRAM ERROR - SDTCLDPD'
     O          E            FIN         1
     O                                           26 'PROGRAM COMPLETED NORMALLY'
     O          E            FIN         2  0
     O                                           26 'DEAL TYPES IGNORED ARE:   '
     O          E            IGN            1
     O                       IGNDT(IG)           25
     O          E            TSI         2  0
     O                                           26 'DEAL TYPE/SUB TYPES ADDED:'
     O          E            TSA            1
     O                       DTSTCL(TS)          34
      ********************************************************************
     OACKEYALF  E            ACK
     O                       N_AKEY
      ********************************************************************
      /SPACE 5
** DB - DEALSDB DTYP
FPFSPISICXSWOPOTPSNX
** DC - DEALSDC DTYP
IPTICLLNDLITTDCDCIILIDFLDPLPFTDTLT
** DD - DEALSDD DTYP
C1C2BPBDTBDATA
** DE - DEALSDE DTYP
CSBSBRTSRATR
** DG - DEALSDG DTYP
FRRSRXRPRRRF
