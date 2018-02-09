     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Update class on deal types/sub types file')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLCLINI3 - Update class on deal types/sub types file         *
      *             (Dealing initialisation program)                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FFDDTSTPD  IP   E             DISK    RENAME(FDDTSTPD:INFDDTST)
     FFDDTSTL0  UF   E           K DISK    RENAME(FDDTSTPD:FDDTSTPDF) PREFIX(N_)
     FACKEY     IF   E           K DISK
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
 
     D                 DS
     D OP_AKEY                 1     14
     D OP_DTYP                 1      2
     D OP_POS3                 3      3
     D OP_DLST                 4      5
     D OP_POS9                 9     10
     D OP_CLAS                11     14
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C                   MOVE      CLAS11        InClass           4
 
     C     CLAS11        CABNE     *BLANK        BYPASS
 
     C                   MOVEL     *BLANK        R_FILE
     C                   EVAL      R_DTYP  = DTPE11
     C                   EVAL      R_DLST  = DLST11
 
     C                   EXSR      CHECK_DTYP
 
     C     R_FILE        IFEQ      'DB'
     C                   MOVE      DBCLAS        CLAS11
     C     R_DTYP        IFEQ      'NX'
     C                   MOVE      NXCLAS        CLAS11
     C                   ENDIF
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DC'
     C                   MOVE      DCCLAS        CLAS11
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DD'
     C                   MOVE      DDCLAS        CLAS11
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DE'
     C                   MOVE      DECLAS        CLAS11
     C                   ENDIF
 
     C     R_FILE        IFEQ      'DG'
     C                   MOVE      DGCLAS        CLAS11
     C                   ENDIF
 
      * Update a/c key only if by doing so no duplicate is created
 
     C     InClass       IFNE      CLAS11
     C     N_DTSTK       CHAIN     FDDTSTPDF                          99
     C     *IN99         IFEQ      *ON
     C     O_DTSTK       CHAIN     FDDTSTPDF                          99
     C                   MOVEL     CLAS11        N_CLAS11
     C                   EXCEPT    DTST
     C                   ENDIF
     C                   ENDIF
 
      * Store deal type/sub-type/class changes
 
     C     InClass       IFNE      CLAS11
     C                   MOVE      CLAS11        R_CLAS
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
     C     R_DTYP        IFEQ      'OP'
     C                   EXSR      DET_Optiondeal
     C                   ENDIF
     C     R_DTYP        IFNE      'OP'
     C     R_DTYP        OREQ      'OP'
     C     OptionDeal    ANDEQ     'Y'
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
     C     DET_OptionDealBEGSR
     C                   MOVEL     'N'           OptionDeal        1
     C                   EVAL      OP_DTYP   = DTPE11
     C                   EVAL      OP_DLST   = DLST11
     C                   EVAL      OP_CLAS   = *BLANK
     C     OP_AKEY       CHAIN     ACKEYALF                           99
     C  N99              MOVEL     'Y'           OptionDeal
     C                   EVAL      OP_CLAS  = DBCLAS
     C     OP_AKEY       CHAIN     ACKEYALF                           99
     C  N99              MOVEL     'Y'           OptionDeal
     C                   ENDSR
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
 
      * Report deal type/sub types/classes processed
 
     C                   Z-ADD     1             TS
     C     *BLANK        LOOKUP    DTSTCL(TS)                         99
     C     *IN99         IFEQ      *ON
     C                   EXCEPT    TSI
     C     TS            DOWLE     9999
     C                   MOVEL     DTSTCL(TS)    R_DTSTCL
     C                   EXCEPT    TSA
     C                   ADD       1             TS
     C                   ENDDO
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE           10
 
     C                   MOVEL     'D'           OP_POS3
     C                   MOVEL     'FB'          OP_POS9
 
     C     O_DTSTK       KLIST
     C                   KFLD                    R_DTYP
     C                   KFLD                    R_DLST
     C                   KFLD                    InClass
     C     N_DTSTK       KLIST
     C                   KFLD                    R_DTYP
     C                   KFLD                    R_DLST
     C                   KFLD                    CLAS11
 
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
     OFDDTSTPDF E            DTST
     O                       N_CLAS11
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
