     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Update class on loan types/sub types file')   *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LECLINI3 - Update class on loan types/sub types file         *
      *             (Lending initialisation program)                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE164             Date 18Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242073             Date 20Sep06               *
      *                 CLE042  *CREATE    Date 06Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  242073 - Update  corresponding record in TABLET6.            *
      *  CLE042 - Extended Loan Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FSDLOANPD  IP   E             DISK    RENAME(SDLOAND0:SDLOANIN)
     FSDLOANL0  UF   E           K DISK    RENAME(@AYRECK:SDLOAND0 ) PREFIX(N_)
     FSDLNX1L0  UF   E           K DISK    RENAME(SDLOANF6:SDLNX1D0) PREFIX(N_)
     FSDTCLDPD  IF   E             DISK
     FTABLET6   UF   E           K DISK    PREFIX(T6_)                                        242073
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D LTSTCL          S              8    DIM(9999)  ASCEND
 
     D                 DS
     D R_LTSTCL                1      8
     D R_LTYP                  1      2
     D R_SUTP                  3      4
     D R_CLAS                  5      8
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C                   MOVE      AYLNCL        InClass           4
 
     C     AYLNCL        CABNE     *BLANK        BYPASS
 
     C                   MOVEL     *BLANK        R_FILE
     C                   EVAL      R_LTYP  = AYLNTY
     C                   EVAL      R_SUTP  = AYLNST
 
     C                   EXSR      CHECK_LOAN
 
     C     R_FILE        IFEQ      'LE'
     C                   MOVE      LECLAS        AYLNCL
     C                   ENDIF
 
      * Update loan type/sub-type only if by doing so no duplicate is created
 
     C     InClass       IFNE      AYLNCL
     C     N_LTSTK       CHAIN     SDLOAND0                           99
     C     *IN99         IFEQ      *ON
     C     O_LTSTK       CHAIN     SDLOAND0                           99
     C                   MOVEL     AYLNCL        N_AYLNCL
     C     O_LTSTK       CHAIN     SDLNX1D0                           98
     C  N98              MOVEL     AYLNCL        N_VILNCL
     C                   EXCEPT    LTST
                                                                                              242073
      ** Update corresponding record in TABLET6                                               242073
                                                                                              242073
     C                   EXSR      SrUpdTab                                                   242073
                                                                                              242073
     C                   ENDIF
     C                   ENDIF
 
      * Store loan type/sub-type/class changes
 
     C     InClass       IFNE      AYLNCL
     C                   MOVE      AYLNCL        R_CLAS
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
 
     C                   MOVEL     AYLNTY        FirstChar         1
     C     FirstChar     IFEQ      'H'
     C     FirstChar     OREQ      'J'
     C     FirstChar     OREQ      'K'
     C                   MOVEL     'LE'          R_FILE
     C                   GOTO      END_CHECK
     C                   ENDIF
 
     C     END_CHECK     ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
 
      * Sort report arrays
 
     C                   SORTA     LTSTCL
 
     C                   OPEN      QSYSPRT
 
      * Report error or completion
 
     C     Count         IFNE      1
     C                   EXCEPT    ERR
     C                   SETON                                        U8
     C                   ELSE
     C                   EXCEPT    FIN
     C                   ENDIF
 
      * Report loan type/sub types/classes processed
 
     C                   Z-ADD     1             TS
     C     *BLANK        LOOKUP    LTSTCL(TS)                         99
     C     *IN99         IFEQ      *ON
     C                   EXCEPT    TSI
     C     TS            DOWLE     9999
     C                   MOVEL     LTSTCL(TS)    R_LTSTCL
     C                   EXCEPT    TSA
     C                   ADD       1             TS
     C                   ENDDO
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
     C                   ENDSR
      ********************************************************************                    242073
      /SPACE 5                                                                                242073
      ********************************************************************                    242073
     C     SrUpdTab      BEGSR                                                                242073
                                                                                              242073
     C     N_LTSTK       CHAIN     TABLET6                                                    242073
     C                   IF        NOT %FOUND(TABLET6)                                        242073
     C     O_LTSTK       CHAIN     TABLET6                                                    242073
     C                   IF        %FOUND(TABLET6)                                            242073
     C                   MOVEL     AYLNCL        T6_LNCL                                      242073
     C                   UPDATE    TABLET6F                                                   242073
     C                   ENDIF                                                                242073
     C                   ENDIF                                                                242073
                                                                                              242073
     C                   ENDSR                                                                242073
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
     C                   MOVEL     *BLANK        R_FILE            2
     C     O_LTSTK       KLIST
     C                   KFLD                    R_LTYP
     C                   KFLD                    R_SUTP
     C                   KFLD                    InClass
     C     N_LTSTK       KLIST
     C                   KFLD                    R_LTYP
     C                   KFLD                    R_SUTP
     C                   KFLD                    AYLNCL
 
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
     O          E            TSI         2  0
     O                                           26 'LOAN TYPE/SUB TYPES ADDED:'
     O          E            TSA            1
     O                       LTSTCL(TS)          34
     OSDLOAND0  E            LTST
     O                       N_AYLNCL
     OSDLNX1D0  E   N98      LTST
     O                       N_VILNCL
