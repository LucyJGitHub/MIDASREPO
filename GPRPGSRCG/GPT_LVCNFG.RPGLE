     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP List View Configuration Trigger Program')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPT_LVCNFG - On-Line Update of Global File T_GPUTILSR        *
      *             - Trigger program for T_LVCONFIG                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5361            Date 06Jan05               *
      *                 BUG4521 *CREATE    Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5361- Change the format of field UTSRCODE                 *
      *  BUG4521- Update file T_GPUTILSR                              *
      *                                                               *
      *****************************************************************
 
O    FGPUTILL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O
O    D G_T_LVCNFG    E DS                  EXTNAME(T_LVCONFIG)
 
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
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        G_T_LVCNFG
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_T_LVCNFG
O    C                   ENDIF
O
     C     I#BFAF        IFEQ      *BLANKS
     C     I#BIMG        ANDEQ     *BLANKS
     C** INSERT
     C                   EXSR      T_LVCNFG
O    C                   WRITE     T_GPUTILSR
     C                   ELSE
O
      * Use LVID    from T_LVCONFIG to get position on GPUTILL0
     C
     C                   Z-ADD     FILETYPE      KTYPE
     C                   MOVE      *BLANKS       KCODE                                       BUG5361
     C                   MOVE      LVID          KCODE
     C                   MOVE      KCODE         @Numeric10       10 0                       BUG5361
     C                   EVAL      KCODE = %CHAR(@Numeric10)                                 BUG5361
O    C     KEYUTIL       SETLL     GPUTILL0                           99
     C*
     C     KEYUTIL       READE     GPUTILL0                               98
     C*
     C
     C     I#BFAF        IFEQ      'B'
     C     *IN98         ANDEQ     '0'
O    C                   DELETE    T_GPUTILSR
     C                   ELSE
O     * 'After'
 
     C                   EXSR      T_LVCNFG
 
     C     *IN98         IFEQ      '1'
     C** INSERT
O    C                   WRITE     T_GPUTILSR
     C                   ELSE
O     * Update
O    C                   UPDATE    T_GPUTILSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
O
     C/SPACE 5
      ********************************************************************
      * T_LVCNFG - Set up fields
      ********************************************************************
     C     T_LVCNFG      BEGSR
O
      * Move T_LVCONFIG fields into layout for T_GPUTILSR
      * Type
     C                   EVAL      UTSRTYPE = FILETYPE
      * Code
     C                   MOVE      *BLANKS       UTSRCODE                                    BUG5361
     C                   MOVE      LVID          UTSRCODE
     C                   MOVE      UTSRCODE      @Numeric10                                  BUG5361
     C                   EVAL      UTSRCODE = %CHAR(@Numeric10)                              BUG5361
      * Name
     C                   EVAL      UTSRNAME = LVNAME
      * Status
     C                   EVAL      UTSRACTIVE = 'Y'
 
     C                   ENDSR
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
O    C                   OPEN      GPUTILL0
 
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C     KEYUTIL       KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KCODE            10
     C                   Z-ADD     7             FILETYPE
 
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
