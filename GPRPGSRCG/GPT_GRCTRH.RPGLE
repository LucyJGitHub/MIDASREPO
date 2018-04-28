     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Country Hierarchy Trigger Program')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPT_GRCTRH - On-Line Update of Global File T_GPUTILSR        *
      *             - Trigger program for T_GRCTRYH                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245952  *CREATE    Date 23Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245952 - Update file T_GPUTILSR                              *
      *                                                               *
      *****************************************************************
 
O    FGPUTILL1  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O
O    D G_T_GRCTRYH   E DS                  EXTNAME(T_GRCTRYH)
O    D G_T_GRCTRYH_A E DS                  EXTNAME(T_GRCTRYH) PREFIX(A_)
 
     D FILETYPE        S                   LIKE(UTSRTYPE)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates - Trigger event will always be update for this file
O
O    C                   MOVEL     I#BIMG        G_T_GRCTRYH
O    C                   MOVEL     I#AIMG        G_T_GRCTRYH_A
O
      * Use RHNAME from T_GRCTRYH to get position on GPUTILL1
 
     C                   Z-ADD     FILETYPE      KTYPE
     C                   MOVE      *BLANKS       KNAME
     C                   EVAL      KNAME = RHNAME
O
O    C     KEYUTIL       SETLL     GPUTILL1                           99
     C     KEYUTIL       READE     GPUTILL1                               98
 
O     * Update - Move T_GRCTRYH username field into layout of T_GPUTILSR
     C     *IN98         IFEQ      '0'
     C                   EVAL      UTSRNAME = A_RHNAME
O    C                   UPDATE    T_GPUTILSR
     C                   ENDIF
 
     C                   RETURN
      ********************************************************************
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
O    C                   OPEN      GPUTILL1
 
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C     KEYUTIL       KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KNAME            65
     C                   Z-ADD     4             FILETYPE
 
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
