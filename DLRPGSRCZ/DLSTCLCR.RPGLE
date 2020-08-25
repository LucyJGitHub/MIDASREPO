     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas DL Deal SubType/Class Changes - A/c Key Rpt')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLSTCLCR - Deal Sub-Type/Class Changes - A/c Key Reporting   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR821740           Date 29Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 CDL038  *CREATE    Date 10May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CSD027A- Conversion of customer number to alpha.             *
      *  CDL038 - Extended Deal Sub Type                              *
      *                                                               *
      *****************************************************************

     FDLDKEYL0  IP   E           K DISK    INFSR(*PSSR) RENAME(DKEYSDPF: INF)
     FDLSTCLCRP1O    F  132        PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL)
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)  EXTIND(*INU4)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)  EXTIND(*INU4)
     F                                     INCLUDE(ACKEYALF)
     F                                     PREFIX(K_)
     FGEDLMPD   O  A E             DISK    INFSR(*PSSR)  EXTIND(*INU4)
     F                                     PREFIX(E_)
     FDKEYSZZ   UF   E             DISK    INFSR(*PSSR)  EXTIND(*INU1)
     F                                     PREFIX(W_)
     FDKEYSDP   O  A E             DISK    INFSR(*PSSR)  EXTIND(*INU1)


     D SPOOL           DS
      * FILE INFORMATION DATA STRUCTURE
     D  SFILE                 83     92
     D  SFNUM                123    124B 0


     D K_ACKEYAL     E DS                  EXTNAME(ACKEYAL) PREFIX(K_)
     D NCD                    38     49    DIM(6)
     D PRF                    50     55    DIM(6)
     D ACD                    97    156    DIM(6)


     D BRC             S              3    DIM(999)
     D BIC             S              6    DIM(999)


     D E_GEDLM       E DS                  EXTNAME(GEDLMPD) PREFIX(E_)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)


     IINF           01
     I                                          BRCA          L3
     I                                          ECCY          L2
     I                                          DLNO          L1

      ** Access branch details

     C   L3              DO
     C                   EXSR      ACS_BRCA
     C                   IF        PrintFileOpen = 'Y'
     C                   CLOSE     DLSTCLCRP1                           99
     C                   ENDIF
     C                   Z-ADD     0             PAGENO            5 0
     C                   Z-ADD     90            LINENO            5 0
     C                   EVAL      PrintFileOpen = 'Y'
     C                   OPEN      DLSTCLCRP1
     C                   EXSR      ZSFILE
     C                   ENDDO

      ** Access currency details

     C   L2              DO
     C                   EXSR      ACS_CCY
     C     A6NBDP        COMP      1                                    2021
     C     A6NBDP        COMP      2                                  23  22
     C                   ENDDO

      ** Change of deal number

     C   L1              DO
     C                   Z-ADD     1             CHLINE            1 0
     C                   EXSR      PAGECHG
     C                   EXCEPT    SPACE1
     C                   ENDDO

      * Add a/c key to the account keys file DKEYSDP

     C   U1              EXSR      WRT_DKEYSDP

      * Generate shadow entries to GEDLMPD (Diagnostic use only)

     C   U4              EXSR      WRT_GEDLMPD

      * Report account key

     C     REVI          COMP      1                                      60
     C                   Z-ADD     1             CHLINE            1 0
     C                   EXSR      PAGECHG
     C                   EXCEPT    REPORT

     CLR                 IF        PrintFileOpen <> 'Y'
     CLR                 OPEN      DLSTCLCRP1
     CLR                 Z-ADD     2             CHLINE
     CLR                 EXSR      PAGECHG
     CLR                 EXCEPT    NODETAILS
     CLR                 ELSE
     CLR                 Z-ADD     2             CHLINE
     CLR                 EXSR      PAGECHG
     CLR                 EXCEPT    ENDOFREP
     CLR                 ENDIF
     CLR U1              EXSR      UPD_DKEYSZZ

      /SPACE 5
      ********************************************************************
     C     ACS_BRCA      BEGSR
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      BRCA          PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ACS_CCY       BEGSR
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      ECCY          PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ZSFILE        BEGSR

      ** REPORT SPOOL FILE GENERATION

     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM      BRCA          @PARM             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     PAGECHG       BEGSR

     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGENO
     C                   EXCEPT    HEADINGS
     C     5             ADD       CHLINE        LINENO
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
     C     WRT_DKEYSDP   BEGSR

      * Write an account key to DKEYSDP

     C                   WRITE     DKEYSDPF

      * Accumulate totals

     C                   ADD       1             W_NORE

     C     EAMT          DIV       1000          ZZAMT
     C     ZZAMT         IFLT      0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   Z-ADD     W_HRWN        ZZTOTI
     C                   Z-ADD     W_HRDC        ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        W_HRWN
     C                   Z-ADD     ZZTOTD        W_HRDC
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     WRT_GEDLMPD   BEGSR

     C     AKEY          CHAIN     ACKEYALF                           70
     C  N70K_RECI        COMP      'D'                                7070
     C     *IN70         CABEQ     *ON           NO_ACKEY

      * Prepare entry

     C                   CLEAR                   E_GEDLM
     C                   MOVEL     'P'           E_RECI
     C                   MOVEL     'GE-DL'       E_SPOS

     C                   Z-ADD     1             X                 3 0
     C     X             DOWLE     6

     C     PRF(X)        IFEQ      '1'
     C     PRF(X)        OREQ      '3'

      * Branch
     C                   MOVEL     BRCA          E_BRCA
      * Customer
     C     PRF(X)        IFEQ      '1'
     C                   Z-ADD     1             BR
     C     BRCA          LOOKUP    BRC(BR)                                99
     C   99              MOVEL     BIC(BR)       E_CNUM
     C**N99*****         Z-ADD     999999        E_CNUM                                      CSD027A
     C  N99              EVAL      E_CNUM = '999999'                                         CSD027A
     C                   ELSE
     C                   MOVEL     CNUM          E_CNUM
     C                   ENDIF
      * Currency
     C                   MOVEL     ECCY          E_CCY
      * Account Code
     C                   MOVEL     ACD(X)        E_ACOD

      * Account sequence
     C     PRF(X)        IFEQ      '1'
     C                   Z-ADD     1             E_ACSQ
     C                   ELSE
     C                   Z-ADD     ACSQ          E_ACSQ
     C                   ENDIF
      * Posting Amount
      * & DR/CR indicator
     C                   Z-ADD     EAMT          E_PSTA
     C     X             IFLE      3
     C     REVI          ANDEQ     0
     C     X             ORGT      3
     C     REVI          ANDEQ     1
     C                   Z-ADD     0             E_DRCR
     C                   ELSE
     C                   Z-ADD     1             E_DRCR
     C                   ENDIF

      * Deal number
     C                   MOVEL     DLNO          E_DLREF

      * A/c key
     C                   MOVEL     AKEY          E_ACKEY

      * Write a diagnostic entry to GEDLMPD

     C                   WRITE     APOSTPDF
     C                   ENDIF

     C                   ADD       1             X
     C                   ENDDO

     C     NO_ACKEY      ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     UPD_DKEYSZZ   BEGSR

     C                   UPDATE    DKEYSZZF

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      *  GLZADD - Add an Amount to the Total                          *
      *****************************************************************
      *
     C     GLZADD        BEGSR
      *
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91
      *
     C     *IN91         IFEQ      *ON
     C                   GOTO      ZZAEND
     C                   ENDIF
      *
      ** Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now
      *
     C                   EXSR      GLZSUM
      *
     C     ZZAEND        ENDSR
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  GLZSUM - Carry Out Addition                                  *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   MOVE      *OFF          *IN91
     C                   MOVE      *OFF          *IN92
     C                   MOVE      *OFF          *IN93
     C                   MOVE      *OFF          *IN94
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN99
      *
      ** Determine sign of ZZAMTI & D, 92
      *
     C     ZZAMTI        COMP      0                                    9293
      *
     C     *IN93         IFEQ      *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C                   GOTO      ZZSEND
     C                   ENDIF
      *
      ** Determine sign of ZZTOTI & D, 91
      *
     C     ZZTOTI        COMP      0                                    9193
      *
     C     *IN93         IFEQ      *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF
      *
      ** If ZZTOTAL is zero, return ZZAMOUNT
      *
     C     *IN93         IFEQ      *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
      *
      ** If signs differ bypass overflow checks
      *
     C     *IN91         IFEQ      *ON
     C     *IN92         ANDEQ     *OFF
     C     *IN91         OREQ      *OFF
     C     *IN92         ANDEQ     *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
      *
     C     *IN93         IFEQ      *OFF
     C     ZZWK2         COMP      -999                                 93
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     *IN92         ANDEQ     *OFF
     C     ZZAMTI        ADD       1             ZZWK3            15 0
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     *IN92         ANDEQ     *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
     C                   ENDIF
      *
     C     *IN93         IFEQ      *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF
      *
      ** If modulus of ZZWK3 < modulus of ZZTOTI then O/F has occurred
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ** If O/F zeroise ZZAMT, *IN99 set and ZZTOT fields left intact
      *
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     0             ZZAMT            15 3
     C                   ENDIF
      *
     C                   GOTO      ZZSEND
      *
      ** The 'SIGNS' are different
      *
     C     ZZOFPS        TAG
      *
      ** If ZZAMT was negative, make it pos. to comp with ZZTOT
      *
     C     *IN92         IFEQ      *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI           15 0
     C                   Z-SUB     ZZAMTD        ZZAMTD            3 0
     C                   ENDIF
      *
      ** If ZZTOT was negative, make it pos. to comp with ZZAMT
      *
     C     *IN91         IFEQ      *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Both ZZAMT and ZZTOT are now positive
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
      *
     C     *IN95         IFEQ      *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF
      *
      ** If ZZTOT = ZZAMT return zero
      *
     C     *IN95         IFEQ      *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF
      *
      ** If ZZTOT > ZZAMT
      *
     C     *IN93         IFEQ      *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     *IN94         ANDEQ     *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWK2
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     *IN94         ANDEQ     *ON
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
      *
     C     *IN93         IFEQ      *ON
     C     *IN94         ANDEQ     *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF
      *
      ** If ZZAMT > ZZTOT
      *
     C     *IN93         IFEQ      *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF
      *
     C     *IN93         IFEQ      *OFF
     C     *IN94         ANDEQ     *ON
     C     ZZAMTI        SUB       1             ZZWK3            15 0
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
      *
     C     *IN93         IFEQ      *OFF
     C     *IN94         ANDEQ     *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF
      *
     C     *IN93         IFEQ      *OFF
     C     *IN94         ANDEQ     *ON
     C     ZZWK2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
      *
     C     *IN93         IFEQ      *OFF
     C     *IN94         ANDEQ     *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Reverse sign of ZZTOT if larger I/P fields were negative
      *
     C                   MOVE      *OFF          *IN94
      *
     C     *IN93         IFEQ      *ON
     C     *IN91         ANDEQ     *ON
     C     *IN93         OREQ      *OFF
     C     *IN92         ANDEQ     *ON
     C                   MOVE      *ON           *IN94
     C                   ENDIF
      *
     C     *IN94         IFEQ      *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
      *
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
      *
     C     *IN92         IFEQ      *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
      *
     C     ZZSEND        TAG
      *
      ** If ZZTOTD is zero and ZZTOTI is neg. set up ZZNEGD
      *
     C                   MOVE      *OFF          *IN96
      *
     C     ZZTOTD        COMP      0                                      91
      *
     C     *IN91         IFEQ      *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF
      *
     C     *IN96         IFEQ      *ON
     C                   MOVE      '.000-'       ZZNEGD            5
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *PSSR         BEGSR
     C     P#RUN         IFNE      'Y'
     C                   MOVEL     'Y'           P#RUN             1
     C                   SETON                                        LRU7U8
     C                   DUMP
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   Z-ADD     90            LINENO            5 0
     C                   MOVEL     'N'           PrintFileOpen     1

      ** Access DKEYSDP trailer

     C     *INU1         IFEQ      *ON
     C                   READ      DKEYSZZ                                99
     C     *IN99         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      * Load up branch codes and BICN (if in diagnostic mode)

     C     *INU4         IFEQ      *ON
     C     A8BRCD        SETLL     @A8REB1
     C                   Z-ADD     1             BR                4 0
     C                   READ      @A8REB1                                99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     A8BRCD        BRC(BR)
     C                   MOVEL     A8BICN        BIC(BR)
     C                   ADD       1             BR
     C                   READ      @A8REB1                                99
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
     ODLSTCLCRP1E            HEADINGS         02
     O                                           26 'REFERENCE DLSTCLCRP1'
     O                       BJURPT              89
     O                                          104 'DATE'
     O                       BJMRDT             112
     O                                          122 'PAGE'
     O                       PAGENO        Z    127
     O          E            HEADINGS         03
     O                                           69 'SUB TYPE/CLASS CHANGE '
     O                                           88 'ACCOUNT KEYS REPORT'
     O               U1                         120 '* UPDATE *'
     O          E            HEADINGS         04
     O                                           12 'BRANCH'
     O                       BRCA                16
     O                       A8BRNM              48
     O          E            HEADINGS         05
     O                                           30 'DEAL NUMBER      ACCOUNT'
     O                                           53 ' KEY       CUSTOMER NO.'
     O                                           80 '                EVENT'
     O                                           98 ' DATE   EVENT CCY.'
     O                                          116 'EVENT AMOUNT'
     O          E            REPORT      1
     O                       DLNO                15
     O                       AKEY                36
     O                       CNUM                50
     O                       BJMRDT              82
     O                       ECCY                94
     O               20      EAMT               117 ' ,   ,   ,   , 0 -'
     O               21      EAMT               119 '   ,   ,   , 0 . -'
     O               22      EAMT               120 '  ,   ,   , 0 .  -'
     O               23      EAMT               121 ' ,   ,   , 0 .   -'
     O               60                         128 '* REV *'
     O               70 U4                      130 '!'
     O          E            SPACE1      1
     O                                          132 '.'
     O          E            NODETAILS   2
     O                                           78 '** NO DETAILS TO REPORT **'
     O          E            ENDOFREP    2
     O                                           76 '*** END OF REPORT ***'
