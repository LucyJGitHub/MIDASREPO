     H DEBUG
     H COPYRIGHT('(C) Copyright Midas-Kapiti International Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Update class on account keys file')           *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LECLINI4 - Update class on account keys file                 *
      *             (Lending initialisation program)                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE164             Date 18Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042  *CREATE    Date 06Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CLE042 - Extended Loan Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FACKEYAL   IP   E             DISK    RENAME(ACKEYALF:INACKF)
     FACKEY     UF   E           K DISK    INCLUDE(ACKEYALF) PREFIX(N_)
     FSDLOANL0  UF   E           K DISK
     FSDTCLDPD  IF   E             DISK
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D IGNDT           S              2    DIM(999)   ASCEND
     D LTSTCL          S              8    DIM(9999)  ASCEND
 
     D                 DS
     D R_LTSTCL                1      8
     D R_LTYP                  1      2
     D R_SUTP                  3      4
     D R_CLAS                  5      8
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C                   MOVEL     AKEY          InAKEY           14
     C                   MOVE      AKEY          InClass           4
 
     C     RECI          CABNE     'D'           BYPASS
     C     InClass       CABNE     *BLANK        BYPASS
 
     C                   MOVEL     *BLANK        R_FILE
 
     C                   EVAL      R_LTYP   = %SubST(AKEY: 01: 2)
     C                   EVAL      R_SUTP   = %SubST(AKEY: 04: 2)
 
     C                   EXSR      CHECK_LOAN
 
     C     R_FILE        IFEQ      'LE'
     C                   MOVE      LECLAS        AKEY
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
 
      * Store loan type/sub-type/class changes
 
     C     InAKEY        IFNE      AKEY
     C                   MOVE      AKEY          R_CLAS
     C                   Z-ADD     1             TS                5 0
     C     R_LTSTCL      LOOKUP    LTSTCL(TS)                             99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    LTSTCL(TS)                             99
     C                   MOVEL     R_LTSTCL      LTSTCL(TS)
     C                   ENDIF
     C                   ENDIF
 
     C     BYPASS        TAG
 
     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     CHECK_LOAN    BEGSR
 
     C                   MOVEL     R_LTYP        FirstChar         1
     C     FirstChar     IFEQ      'H'
     C     FirstChar     OREQ      'J'
     C     FirstChar     OREQ      'K'
     C                   MOVEL     'LE'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C                   Z-ADD     1             IG                4 0
     C     R_LTYP        LOOKUP    IGNDT(IG)                              99
     C     *IN99         IFEQ      *OFF
     C     '  '          LOOKUP    IGNDT(IG)                              99
     C                   MOVEL     R_LTYP        IGNDT(IG)
     C                   ENDIF
 
     C     END_CHECK     ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
 
      * Sort report arrays
 
     C                   SORTA     IGNDT
     C                   SORTA     LTSTCL
 
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
 
      * Add loan type/sub types/classes
 
     C                   Z-ADD     1             TS
     C     *BLANK        LOOKUP    LTSTCL(TS)                         99
     C     *IN99         IFEQ      *ON
     C                   EXCEPT    TSI
     C     TS            DOWLE     9999
     C                   MOVEL     LTSTCL(TS)    R_LTSTCL
     C     LTSTK         CHAIN     @AYRECK                            99
     C     *IN99         IFEQ      *ON
     C                   EXSR      ADD_SDLOAN
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
     C     ADD_SDLOAN    BEGSR
 
      * If loan/sub-type exists, just amend its class
 
     C                   MOVEL     *BLANK        R_CLAS
     C     LTSTK         CHAIN     @AYRECK                            99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     LTSTCL(TS)    R_LTSTCL
     C                   MOVEL     R_CLAS        AYLNCL
     C                   UPDATE    @AYRECK
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE            2
     C     LTSTK         KLIST
     C                   KFLD                    R_LTYP
     C                   KFLD                    R_SUTP
     C                   KFLD                    R_CLAS
     C     LTSTKP        KLIST
     C                   KFLD                    R_LTYP
     C                   KFLD                    R_SUTP
 
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
     O                                           26 'LOAN TYPE/SUB TYPES ADDED:'
     O          E            TSA            1
     O                       LTSTCL(TS)          34
      ********************************************************************
     OACKEYALF  E            ACK
     O                       N_AKEY
      ********************************************************************
